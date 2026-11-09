# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# 미니 게임 모음 (minigamegroup)

- 사용자에게는 한국어로 답변한다. 게임 UI 문구도 한국어로 쓴다.
- GitHub: [github.com/eatloveplaykorea/minigamegroup](https://github.com/eatloveplaykorea/minigamegroup) (공개 저장소, `main` 브랜치)
  - 저장소 주소: `https://github.com/eatloveplaykorea/minigamegroup`
- 사이트(GitHub Pages, `main` 루트에서 배포): https://eatloveplaykorea.github.io/minigamegroup/
  - `main`에 push하면 1~2분 뒤 사이트에 반영된다.

## 실행·빌드
- 빌드, 패키지 관리, 린트, 테스트가 없다. HTML 파일을 브라우저로 바로 연다 (예: PowerShell `Start-Process index.html`).
- 배포 상태 확인: `gh api repos/eatloveplaykorea/minigamegroup/pages/builds/latest --jq .status`

## 구조
- 게임마다 HTML 파일 하나에 CSS·JS를 모두 인라인으로 넣는다. 외부 라이브러리는 쓰지 않는다. 게임 파일은 `<!doctype html>`을 포함한 완전한 문서다.
- `index.html`은 게임 모음 홈이다. 게임별 카드(`data-cat`으로 퍼즐/순발력 필터)와 최고 기록 표시가 있다.
- `minesweeper-guide.html`은 지뢰찾기 소개 페이지다. `minesweeper.html`을 iframe으로 넣어 바로 플레이할 수 있다. claude.ai Artifact로도 게시되어 있어서 `<!doctype>`·`<html>`·`<head>` 태그 없이 내용만 있다. 이 형식을 유지한다.
- 홈과 소개 페이지만 Google Fonts(Do Hyeon, IBM Plex Sans KR, JetBrains Mono)를 쓴다. 게임 파일은 시스템 폰트만 쓴다.
- 모든 페이지는 `:root` CSS 변수로 색을 정의하고, `prefers-color-scheme: dark`로 다크 모드를 지원한다.
- 각 게임 페이지에는 `index.html`로 돌아가는 링크가 있다.

### 최고 기록 (게임 ↔ 홈 연결)
각 게임은 최고 기록을 localStorage에 저장하고, `index.html`의 `BEST` 객체가 같은 키를 읽어 카드에 보여 준다. 키 이름을 바꾸거나 게임을 추가하면 양쪽을 함께 고쳐야 한다. localStorage 접근은 항상 try/catch로 감싼다.

| 게임 | 키 | 값 |
|---|---|---|
| 지뢰찾기 | `ms-best-{easy,medium,hard}` | 클리어 시간(초, 낮을수록 좋음) |
| 카드 짝맞추기 | `memory-best-{level}` | 시도 횟수 |
| 숫자야구 | `baseball-best-{자릿수}` | 시도 횟수 |
| 뱀 게임 | `snake-best` | 점수 |
| 두더지 잡기 | `mole-best` | 점수 |

### 새 게임 추가 시
1. 기존 게임처럼 단일 HTML 파일을 만든다 (다크 모드, 홈 링크, 최고 기록 저장 포함).
2. `index.html`에 카드(`<li class="card ..." data-cat="puzzle|action">`, `data-best`)와 `BEST` 항목을 추가한다.

## Git 규칙
- 모든 변경은 Git으로 관리하고 GitHub에 push한다.
- 작업 단위가 끝나면 내용을 설명하는 커밋 메시지로 직접 커밋하고 push한다.
- 남은 변경은 Stop 훅(`.claude/settings.json` → `.claude/hooks/auto-commit.sh`)이 턴 종료 시 자동으로 커밋·push한다.
- `.sh` 파일은 LF 줄바꿈을 유지한다 (`.gitattributes`).
