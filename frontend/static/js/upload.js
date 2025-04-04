// Fixed file upload functionality
function uploadJSON() {
  const fileInput = document.getElementById('uploadInput');
  if (!fileInput.files || fileInput.files.length === 0) {
    alert('Please select a file to upload');
    return;
  }

  const file = fileInput.files[0];
  const reader = new FileReader();

  reader.onload = function(e) {
    try {
      const data = JSON.parse(e.target.result);

      // Log data for debugging
      console.log("Parsed JSON data:", data);

      fetch('/api/upload', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
      })
      .then(response => {
        console.log("Upload response status:", response.status);
        return response.json();
      })
      .then(result => {
        console.log("Upload result:", result);
        if (result.status === 'uploaded') {
          alert('File uploaded successfully!');
          window.location.reload();
        } else {
          alert('Upload failed: ' + (result.message || result.status));
        }
      })
      .catch(error => {
        console.error("Upload error:", error);
        alert('Upload error: ' + error);
      });
    } catch (error) {
      console.error("JSON parse error:", error);
      alert('Invalid JSON file: ' + error);
    }
  };

  reader.readAsText(file);
}

// Add event listener after DOM content is loaded
document.addEventListener('DOMContentLoaded', function() {
  const uploadButton = document.querySelector('button[onclick="uploadJSON()"]');
  if (uploadButton) {
    uploadButton.onclick = uploadJSON;
  }
});
