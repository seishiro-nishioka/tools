#!/usr/bin/env bash
# Package each tool directory into a zip for GitHub Releases.
#   scripts/package.sh [out_dir]   (default: dist)
# Outputs:
#   <tool>.zip      one tool (the <tool>/ folder)
#   tools-all.zip   all tools + the list page (index.html, README.md)
#   notes.md        release notes (tool name and version)
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
out="${1:-dist}"
case "$out" in /*) ;; *) out="$PWD/$out" ;; esac
rm -rf "$out"
mkdir -p "$out"
cd "$root"

repo_url="https://github.com/seishiro-nishioka/tools"
tools=()
for d in */; do
  d="${d%/}"
  [ -f "$d/index.html" ] || continue
  tools+=("$d")
done

{
  echo "各ツールの zip を展開して \`index.html\` をブラウザで開くと使えます。"
  echo "外部ライブラリ (PDF.js、JSZip など) は公開版と同じく CDN から読み込むため、初回の利用にはインターネット接続が必要です。"
  echo
  echo "| ツール | バージョン | ダウンロード |"
  echo "|---|---|---|"
} > "$out/notes.md"

# Stage a copy so links work when opened from file:// (a folder URL does not
# resolve to index.html there). The sources for GitHub Pages stay untouched.
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT
cp index.html README.md "$stage/"
for t in "${tools[@]}"; do
  cp -r "$t" "$stage/"
  sed -i 's#href="\.\./"#href="../index.html"#g' "$stage/$t/index.html"
  sed -i "s#href=\"$t/\"#href=\"$t/index.html\"#g" "$stage/index.html"
done
cd "$stage"

for t in "${tools[@]}"; do
  # Exclude nothing but OS junk; the folder is self-contained by rule.
  zip -qr -X "$out/$t.zip" "$t" -x '*.DS_Store' -x '*/.*'
  ver="$(grep -oE 'v20[0-9]{2}\.[0-9]+\.[0-9]+\.[0-9]+' "$root/$t/index.html" | head -n1 || true)"
  echo "| [$t]($repo_url/tree/main/$t) | ${ver:--} | \`$t.zip\` |" >> "$out/notes.md"
done

zip -qr -X "$out/tools-all.zip" index.html README.md "${tools[@]}" -x '*.DS_Store' -x '*/.*'
echo >> "$out/notes.md"
echo "全ツールをまとめた \`tools-all.zip\` もあります (展開後の \`index.html\` が一覧ページ)。" >> "$out/notes.md"

ls -l "$out"
