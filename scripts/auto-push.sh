#!/bin/bash
# auto-push.sh — Chạy tự động bởi macOS LaunchAgent mỗi sáng
# Kiểm tra xem Cowork agent đã viết bài mới chưa, nếu có thì commit + push

REPO="$HOME/VSCProject/Cowork-TIL"
LOG="$REPO/scripts/auto-push.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

log "=== auto-push started ==="

cd "$REPO" || { log "ERROR: cannot cd into $REPO"; exit 1; }

# Kiểm tra có thay đổi chưa commit không
if git diff --quiet && git diff --staged --quiet; then
    log "Nothing to commit. Skipping."
    exit 0
fi

log "Changes detected:"
git diff --name-only >> "$LOG"

# Commit
git add content/posts/ curriculum.md
COMMIT_MSG="auto: TIL $(date '+%Y-%m-%d')"
git commit -m "$COMMIT_MSG" >> "$LOG" 2>&1

# Push (dùng SSH remote đã có sẵn)
git push >> "$LOG" 2>&1

if [ $? -eq 0 ]; then
    log "✅ Pushed successfully!"
else
    log "❌ Push failed. Check SSH key and remote."
fi

log "=== auto-push done ==="
