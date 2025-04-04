// Responsive Menu Detection
(function() {
  function detectIframe() {
    if (window.self !== window.top) {
      // We're in an iframe, hide navigation
      const navElements = document.querySelectorAll('.main-nav, nav, header');
      navElements.forEach(el => {
        if (el) el.style.display = 'none';
      });
      
      // Add padding to body to compensate for removed nav
      document.body.style.paddingTop = '0';
      
      // Add class to body for iframe-specific styling
      document.body.classList.add('in-iframe');
    }
  }
  
  // Run on load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', detectIframe);
  } else {
    detectIframe();
  }
})();
