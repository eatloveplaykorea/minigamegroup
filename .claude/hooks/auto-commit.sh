#!/usr/bin/env bash
# Commit and push any uncommitted changes when Claude finishes a turn.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
[ -z "$(git status --porcelain)" ] && exit 0

git add -A
files=$(git diff --cached --name-only | head -5 | tr '\n' ' ' | sed 's/ $//')
count=$(git diff --cached --name-only | wc -l | tr -d ' ')
[ "$count" -gt 5 ] && files="$files 외 $((count - 5))개"
git commit -q -m "Auto-commit: update $files" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>" || exit 0

if git push -q 2>/dev/null; then
  echo '{"systemMessage":"변경사항을 자동 커밋하고 GitHub에 push했습니다."}'
else
  echo '{"systemMessage":"자동 커밋은 했지만 GitHub push에 실패했습니다. 네트워크나 로그인 상태를 확인하세요."}'
fi
