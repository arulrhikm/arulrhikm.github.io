(function () {
  var objectEl = document.getElementById('cv-pdf-object');
  var iframeEl = document.getElementById('cv-pdf-iframe');
  var downloadEl = document.getElementById('cv-download');
  var statusEl = document.getElementById('cv-build-status');
  var lastBuilt = null;

  function pdfUrl(version) {
    return 'cv.pdf?v=' + encodeURIComponent(version) + '#view=FitH';
  }

  function renderPdf(version, label) {
    if (lastBuilt === version) {
      return;
    }
    lastBuilt = version;
    var url = pdfUrl(version);
    if (objectEl) {
      objectEl.data = url;
    }
    if (iframeEl) {
      iframeEl.src = url;
    }
    if (downloadEl) {
      downloadEl.href = 'cv.pdf?v=' + encodeURIComponent(version);
    }
    if (statusEl && label) {
      statusEl.textContent = label;
    }
  }

  function refresh() {
    fetch('build-info.json?t=' + Date.now(), { cache: 'no-store' })
      .then(function (response) {
        if (!response.ok) {
          throw new Error('missing build-info.json');
        }
        return response.json();
      })
      .then(function (info) {
        var label = 'Last built ' + info.built.slice(0, 4) + '-' +
          info.built.slice(4, 6) + '-' + info.built.slice(6, 8) +
          ' ' + info.built.slice(8, 10) + ':' + info.built.slice(10, 12) + ' UTC';
        renderPdf(info.built, label);
      })
      .catch(function () {
        renderPdf(String(Date.now()), 'Run scripts/build-cv.ps1 locally to generate cv.pdf');
      });
  }

  refresh();

  var host = window.location.hostname;
  if (host === 'localhost' || host === '127.0.0.1') {
    window.setInterval(refresh, 2000);
  }
})();
