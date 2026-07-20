#!/usr/bin/env bash
# word_like_app.sh
# Minimal local "Word-like" editor using browser + HTML/JS
# Usage: chmod +x word_like_app.sh && ./word_like_app.sh

APP_DIR="$(pwd)/word_like_app"
APP_HTML="$APP_DIR/index.html"

mkdir -p "$APP_DIR"

cat > "$APP_HTML" <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Word-like Editor</title>
  <style>
    body {
      margin: 0;
      font-family: system-ui, sans-serif;
      background: #f3f3f3;
    }
    #toolbar {
      display: flex;
      gap: 8px;
      padding: 8px;
      background: #ffffff;
      border-bottom: 1px solid #ccc;
    }
    #toolbar button, #toolbar select {
      padding: 4px 8px;
      font-size: 14px;
    }
    #editor {
      padding: 16px;
      min-height: calc(100vh - 50px);
      background: #ffffff;
      outline: none;
    }
  </style>
</head>
<body>
  <div id="toolbar">
    <select id="fontFamily">
      <option value="system-ui">System</option>
      <option value="serif">Serif</option>
      <option value="sans-serif">Sans</option>
      <option value="monospace">Mono</option>
    </select>
    <select id="fontSize">
      <option value="12px">12</option>
      <option value="14px" selected>14</option>
      <option value="16px">16</option>
      <option value="18px">18</option>
      <option value="24px">24</option>
    </select>
    <button data-cmd="bold"><b>B</b></button>
    <button data-cmd="italic"><i>I</i></button>
    <button data-cmd="underline"><u>U</u></button>
    <button data-cmd="justifyLeft">Left</button>
    <button data-cmd="justifyCenter">Center</button>
    <button data-cmd="justifyRight">Right</button>
    <button id="btnSave">Save</button>
    <button id="btnLoad">Load</button>
  </div>

  <div id="editor" contenteditable="true">
    Start typing here…
  </div>

  <script>
    const editor = document.getElementById('editor');
    const fontFamily = document.getElementById('fontFamily');
    const fontSize = document.getElementById('fontSize');
    const btnSave = document.getElementById('btnSave');
    const btnLoad = document.getElementById('btnLoad');

    document.querySelectorAll('#toolbar button[data-cmd]').forEach(btn => {
      btn.addEventListener('click', () => {
        document.execCommand(btn.dataset.cmd, false, null);
      });
    });

    fontFamily.addEventListener('change', () => {
      document.execCommand('fontName', false, fontFamily.value);
    });

    fontSize.addEventListener('change', () => {
      editor.style.fontSize = fontSize.value;
    });

    btnSave.addEventListener('click', () => {
      const blob = new Blob([editor.innerHTML], { type: 'text/html' });
      const a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = 'document.html';
      a.click();
      URL.revokeObjectURL(a.href);
    });

    btnLoad.addEventListener('click', () => {
      const input = document.createElement('input');
      input.type = 'file';
      input.accept = '.html,.htm,.txt';
      input.onchange = () => {
        const file = input.files[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onload = e => {
          editor.innerHTML = e.target.result;
        };
        reader.readAsText(file);
      };
      input.click();
    });
  </script>
</body>
</html>
EOF

# Open in default browser using a simple local file (no server needed)
if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$APP_HTML" &
elif command -v open >/dev/null 2>&1; then
  open "$APP_HTML" &
else
  echo "Open $APP_HTML manually in your browser."
fi

echo "Word-like app ready at: $APP_HTML"
