#!/usr/bin/env bash
#
# setup_nix_nvme.sh ─ Re-initialise an NVMe drive as a single /nix store
#                     and install multi-user Nix (if absent).
# ---------------------------------------------------------------------------
set -Eeuo pipefail

# ─────────────── EDIT THESE VARIABLES FOR YOUR ENVIRONMENT ──────────────────
NVME_DEVICE="/dev/nvme0n1" # whole-disk node
PART_LABEL="nix-store"     # ext4 volume label
FSTAB_OPTS="defaults,discard,nofail"
COPY_STORE="no" # "yes" to rsync an existing store over
OLD_STORE_MOUNT="/nix"
NIX_INSTALL_URL="https://nixos.org/nix/install"
# ─────────────────────────────────────────────────────────────────────────────

error() {
    echo "Error: $*" >&2
    exit 1
}
need_root() { ((EUID == 0)) || error "Run with sudo."; }

confirm_device() {
    echo -e "\n*** NVMe to be reformatted: ${NVME_DEVICE} ***"
    lsblk -e7 "${NVME_DEVICE}"
    echo
    read -rp "Type the device path again to continue (anything else = abort): " a
    [[ "$a" == "$NVME_DEVICE" ]] || error "Aborted."
}

stop_services() { systemctl stop nix-daemon.service 2>/dev/null || true; }

unmount_nix() {
    if mountpoint -q /nix 2>/dev/null; then
        echo "Unmounting existing /nix..."
        umount -l /nix
    else
        echo "/nix not mounted (OK)."
    fi
}

assert_nix_unused() {
    if [[ -d /nix ]] && lsof +D /nix &>/dev/null; then
        error "/nix still has open files. Stop running builds and try again."
    fi
}

wipe_and_partition() {
    echo "Wiping partition table on ${NVME_DEVICE} ..."
    sgdisk --zap-all "${NVME_DEVICE}"

    echo "Creating single ext4 partition ..."
    parted -s "${NVME_DEVICE}" mklabel gpt \
        mkpart primary ext4 0% 100%
    partprobe "${NVME_DEVICE}"
}

format_partition() {
    local part="${NVME_DEVICE}p1"
    echo "Formatting ${part} as ext4 (${PART_LABEL}) ..."
    mkfs.ext4 -L "${PART_LABEL}" "${part}"
}

wait_for_label() {
    echo -n "Waiting for udev symlink /dev/disk/by-label/${PART_LABEL}"
    for _ in {1..10}; do
        [[ -e /dev/disk/by-label/${PART_LABEL} ]] && {
            echo " ✓"
            return
        }
        sleep 1
        echo -n "."
    done
    echo
    error "udev did not create the symlink in time."
}

mount_new_store() {
    mkdir -p /nix
    mount /dev/disk/by-label/"${PART_LABEL}" /nix
}

copy_old_store() {
    [[ ${COPY_STORE} == yes ]] || return 0
    echo "Copying store from ${OLD_STORE_MOUNT} to new /nix ..."
    rsync -aHAX --delete "${OLD_STORE_MOUNT}/" /nix/
}

write_fstab() {
    if ! grep -q "${PART_LABEL}" /etc/fstab; then
        echo "/dev/disk/by-label/${PART_LABEL} /nix ext4 ${FSTAB_OPTS} 0 0" \
            >>/etc/fstab
        echo "Added /nix entry to /etc/fstab (with nofail)."
    fi
}

install_nix() {
    if ! command -v nix >/dev/null; then
        echo "Installing multi-user Nix ..."
        sh <(curl -L "${NIX_INSTALL_URL}") --daemon
    fi
}

finish() {
    systemctl daemon-reload
    systemctl start nix-daemon.service
    echo
    df -h /nix
    echo -e "\n🎉  /nix is ready and Nix is running."
}

# ─────────────────────────────── MAIN FLOW ──────────────────────────────────
need_root
confirm_device
stop_services
unmount_nix
assert_nix_unused
wipe_and_partition
format_partition
wait_for_label
mount_new_store
copy_old_store
write_fstab
install_nix
finish
