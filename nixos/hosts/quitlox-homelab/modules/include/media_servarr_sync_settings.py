#!/usr/bin/env python3
"""
Sync UI settings for exactly one Servarr instance (Sonarr or Radarr) using the v3 API.

Sets:
- Calendar → First day of week  = Monday
- Calendar → Week column header = "Tue 25/03" (format: ddd DD/MM)
- Dates    → Time format        = "17:00/17:30" (format: HH:mm)

Usage (examples):
  arr-sync-ui --app sonarr --url http://127.0.0.1:8989 --keyfile /path/to/api_key.txt
  arr-sync-ui --app radarr --url http://127.0.0.1:7878 --keyfile /path/to/api_key.txt

Behavior:
- Waits for API readiness (GET /api/v3/system/status or /api/v3/health).
- GET /api/v3/config/ui -> reads current UiConfig (must include 'id').
- PUT /api/v3/config/ui/{id} only when changes are needed.
- Logs to stdout (systemd captures it nicely).
"""

import argparse
import json
import logging
import sys
import time
import urllib.error
import urllib.request
from dataclasses import dataclass
from typing import Any, Dict, Tuple


class ServarrAPIError(Exception):
    """Custom exception for Servarr API errors."""
    pass


# Desired UI configuration settings using exact API field names
DESIRED_UI_CONFIG = {
    "firstDayOfWeek": 1,  # 0=Sunday, 1=Monday
    "calendarWeekColumnHeader": "ddd DD/MM",  # Format: "Tue 25/03"
    "timeFormat": "HH:mm",  # Format: "17:00/17:30"
}


@dataclass
class TimeoutConfig:
    """Configuration for timeouts and delays."""
    http_timeout: int = 10      # seconds
    startup_timeout: int = 180  # seconds
    retry_delay: int = 3        # seconds


# Configuration instances
TIMEOUTS = TimeoutConfig()

LOG = logging.getLogger("arr-sync-ui")
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(logging.Formatter("%(levelname)s: %(message)s"))
LOG.addHandler(handler)
LOG.setLevel(logging.INFO)

def _make_request(url: str, api_key: str, method: str = "GET", data: Dict[str, Any] | None = None) -> Tuple[int, Any]:
    """Make HTTP request to Servarr API."""
    headers = {"X-Api-Key": api_key, "Accept": "application/json"}
    body = None
    
    if data is not None:
        body = json.dumps(data).encode("utf-8")
        headers["Content-Type"] = "application/json"
    
    request = urllib.request.Request(url, data=body, headers=headers, method=method)
    
    try:
        with urllib.request.urlopen(request, timeout=TIMEOUTS.http_timeout) as response:
            raw_data = response.read()
            payload = json.loads(raw_data.decode()) if raw_data else None
            return response.getcode(), payload
    except urllib.error.HTTPError as error:
        raw_data = error.read()
        try:
            return error.code, json.loads(raw_data.decode())
        except json.JSONDecodeError:
            return error.code, raw_data.decode(errors="replace")

def _wait_for_api_ready(app: str, base_url: str, api_key: str) -> None:
    """Wait for Servarr API to become ready."""
    start_time = time.time()
    health_endpoints = ["/api/v3/system/status", "/api/v3/health"]
    
    LOG.info("%s: waiting for API at %s ...", app, base_url)
    
    while True:
        try:
            for endpoint in health_endpoints:
                status_code, _ = _make_request(f"{base_url}{endpoint}", api_key)
                if status_code == 200:
                    LOG.info("%s: API is ready (%s)", app, endpoint)
                    return
        except Exception:
            pass
        
        elapsed = time.time() - start_time
        if elapsed > TIMEOUTS.startup_timeout:
            raise ServarrAPIError(f"{app}: API not ready after {TIMEOUTS.startup_timeout}s at {base_url}")
        
        time.sleep(TIMEOUTS.retry_delay)

def _get_ui_config(app: str, base_url: str, api_key: str) -> Dict[str, Any]:
    """Retrieve current UI configuration from Servarr API."""
    url = f"{base_url}/api/v3/config/ui"
    status_code, payload = _make_request(url, api_key)
    
    if status_code != 200 or not isinstance(payload, dict) or "id" not in payload:
        raise ServarrAPIError(f"{app}: failed to get UI config from {url} -> {status_code}: {payload}")
    
    return payload


def _calculate_ui_changes(current_config: Dict[str, Any]) -> tuple[bool, Dict[str, Any]]:
    """Calculate what UI settings need to be changed."""
    updated_config = dict(current_config)
    has_changes = False
    
    for key, desired_value in DESIRED_UI_CONFIG.items():
        if updated_config.get(key) != desired_value:
            updated_config[key] = desired_value
            has_changes = True
    
    return has_changes, updated_config


def _read_api_key(keyfile_path: str) -> str:
    """Read API key from file and strip whitespace."""
    try:
        with open(keyfile_path, 'r', encoding='utf-8') as file:
            return file.read().strip()
    except FileNotFoundError:
        raise ServarrAPIError(f"API key file not found: {keyfile_path}")
    except IOError as error:
        raise ServarrAPIError(f"Failed to read API key file {keyfile_path}: {error}")


def main() -> int:
    """Main entry point for the script."""
    parser = argparse.ArgumentParser(description="Sync Servarr UI settings (single instance).")
    parser.add_argument("--app", required=True, choices=["sonarr", "radarr"], help="Which Servarr app")
    parser.add_argument("--url", required=True, help="Base URL, e.g. http://127.0.0.1:8989")
    parser.add_argument("--keyfile", required=True, help="Path to file containing API key")
    args = parser.parse_args()

    app = args.app
    base_url = args.url.rstrip("/")
    api_key = _read_api_key(args.keyfile)

    try:
        _wait_for_api_ready(app, base_url, api_key)
        
        current_ui_config = _get_ui_config(app, base_url, api_key)
        
        # Build current config string dynamically
        current_values = ", ".join(
            f"{key}={current_ui_config.get(key)}" 
            for key in DESIRED_UI_CONFIG.keys()
        )
        LOG.info(
            "%s: current UI config (id=%s) -> %s",
            app,
            current_ui_config.get("id"),
            current_values
        )

        has_changes, updated_ui_config = _calculate_ui_changes(current_ui_config)
        if not has_changes:
            LOG.info("%s: already up-to-date; nothing to change", app)
            return 0

        update_url = f"{base_url}/api/v3/config/ui/{current_ui_config['id']}"
        LOG.info("%s: updating UI config via PUT %s", app, update_url)
        
        status_code, response_payload = _make_request(update_url, api_key, "PUT", updated_ui_config)
        if status_code not in (200, 202):
            raise ServarrAPIError(f"{app}: PUT request failed ({status_code}): {response_payload}")

        LOG.info("%s: UI config updated successfully", app)
        return 0
        
    except Exception as error:
        LOG.error("%s: %s", app, error)
        return 1

if __name__ == "__main__":
    sys.exit(main())

