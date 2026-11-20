// Public release metadata only. No account identifiers, analytics or cookies.
fetch('release.json').then(r => { if (!r.ok) throw new Error('Unavailable'); return r.json(); }).then(release => {
  const url = new URL(release.android.url, location.href);
  const ownDownload = url.origin === location.origin && url.pathname.startsWith('/downloads/');
  const githubDownload = url.protocol === 'https:' && url.hostname === 'github.com' && url.pathname.startsWith('/siripireddyindirareddy91/LIFEVERSE_AI/releases/download/');
  if (!ownDownload && !githubDownload) return;
  document.querySelector('#android-download').href = url.href;
  document.querySelector('#apk-detail').textContent = release.android.label;
}).catch(() => { /* The verified preview link in HTML remains available. */ });
