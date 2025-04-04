// Responsive Menu Detection with iframe protection
(function() {
  function detectIframe() {
    // Check if we're in an iframe
    if (window.self !== window.top) {
      console.log("Detected running in iframe - hiding navigation");
      
      // Hide all navigation elements
      const navElements = document.querySelectorAll('.nav-menu, .main-nav, nav, header');
      navElements.forEach(el => {
        if (el) el.style.display = 'none';
      });
      
      // Add padding to body to compensate for removed nav
      document.body.style.paddingTop = '0';
      
      // Add class to body for iframe-specific styling
      document.body.classList.add('in-iframe');
    } else {
      console.log("Running as main window - showing navigation");
    }
  }
  
  // Run on load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', detectIframe);
  } else {
    detectIframe();
  }
})();
