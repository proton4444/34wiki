// Inject custom branding CSS
(function() {
  var link = document.createElement('link');
  link.rel = 'stylesheet';
  link.href = '/assets/custom-branding.css';
  document.head.appendChild(link);
})();
