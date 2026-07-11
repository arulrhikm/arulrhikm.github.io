function toggleSection(buttonId, contentId) {
  const content = document.getElementById(contentId);
  const icon = document.getElementById(buttonId);
  if (!content || !icon) return;

  const isOpen = content.classList.contains('open');
  if (isOpen) {
    content.classList.remove('open');
    content.style.maxHeight = '0';
    icon.textContent = '+';
  } else {
    content.classList.add('open');
    content.style.maxHeight = content.scrollHeight + 'px';
    icon.textContent = '\u2212';
  }
}

document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.collapse-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      toggleSection(btn.dataset.icon, btn.dataset.target);
    });
  });

  document.querySelectorAll('.work-title').forEach(function (title) {
    title.setAttribute('tabindex', '0');
    title.setAttribute('role', 'button');

    function toggleWorkItem() {
      title.parentElement.classList.toggle('open');
    }

    title.addEventListener('click', toggleWorkItem);
    title.addEventListener('keydown', function (e) {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        toggleWorkItem();
      }
    });
  });
});
