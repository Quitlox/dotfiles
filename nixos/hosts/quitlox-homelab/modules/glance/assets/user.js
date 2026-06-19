// Make monitor widget icons clickable, opening the site URL in a new tab
document.addEventListener("click", function (e) {
  var icon = e.target.closest(".widget-type-monitor .monitor-site-icon");
  if (icon) {
    var link = icon.parentElement.querySelector("a[href]");
    if (link) {
      window.open(link.href, "_blank", "noreferrer");
    }
  }
});