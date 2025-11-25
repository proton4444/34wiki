// Inject custom branding CSS and JavaScript
(function() {
  var link = document.createElement('link');
  link.rel = 'stylesheet';
  link.href = '/assets/custom-branding.css';
  document.head.appendChild(link);
  
  var script = document.createElement('script');
  script.src = '/assets/branding.js';
  document.head.appendChild(script);
})();
