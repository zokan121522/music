#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  CMUS — Help Panel
#  Displays keybindings reference via less
#  Bind to F1 in cmus: bind common F1 push shell ~/music/scripts/help-panel.sh
# ═══════════════════════════════════════════════════════════

cat << 'EOF' | less -R

╔═══════════════════════════════════════════════════════════╗
║         🎵 RETRO WAVE CMUS — KEYBINDINGS               ║
║         ░ strata░ger thi░gs ░dition                     ║
╚═══════════════════════════════════════════════════════════╝

┌────────── V I S T A S ──────────┐
│                                  │
│  1  Library (Tree view)          │
│  2  Sorted (by artist/album)     │
│  3  Playlist (current queue)     │
│  4  Queue (temporary)            │
│  5  📂 BROWSER (navigate files)  │ ← Default view
│  6  Filters (custom)             │
│  7  Settings                     │
│                                  │
└──────────────────────────────────┘

┌────────── R E P R O D U C C I Ó N ──────────┐
│                                              │
│  p / c    Pause / Resume                     │
│  x        Play                               │
│  v        Stop                               │
│  b        Next track                         │
│  z        Previous track                     │
│  B        Next album                         │
│  Z        Previous album                     │
│  ← / h    Seek backward 5s                   │
│  → / l    Seek forward 5s                    │
│  ,        Seek backward 1m                   │
│  .        Seek forward 1m                    │
│                                              │
└──────────────────────────────────────────────┘

┌────────── V O L U M E N ──────────┐
│                                    │
│  + / =    Volume up (10%)          │
│  -        Volume down (10%)        │
│  [        Volume left channel up   │
│  ]        Volume right channel up  │
│  {        Volume left channel down │
│  }        Volume right channel down│
│                                    │
└────────────────────────────────────┘

┌────────── L I S T A  /  C O L A ──────────┐
│                                            │
│  Enter     Play selected                   │
│  Space     Toggle play/select              │
│  a         Add to library                  │
│  e         Add to queue                    │
│  E         Add to queue and play next      │
│  y         Add to playlist                 │
│  D / Del   Remove from list                │
│  Tab       Switch between panels           │
│                                            │
└────────────────────────────────────────────┘

┌────────── M O D O S ──────────┐
│                                │
│  m       Cycle playback mode   │
│          (all / artist / album)│
│  s       Toggle shuffle        │
│  r       Toggle repeat all     │
│  R       Toggle repeat current │
│  C       Toggle continue       │
│  f       Toggle follow         │
│  o       Toggle sorted library │
│  M       Toggle play library   │
│                                │
└────────────────────────────────┘

┌────────── F A V O R I T O S ★ ──────────┐
│                                          │
│  f       Toggle favorite ★/♡            │
│  F       Load favorites playlist         │
│                                          │
│  Tip: Favorites are saved to disk and    │
│  persist between cmus sessions.          │
│                                          │
└──────────────────────────────────────────┘

┌────────── B Ú S Q U E D A ──────────┐
│                                      │
│  /       Search forward              │
│  ?       Search backward             │
│  n       Next result                 │
│  N       Previous result             │
│  L       Live filter                 │
│                                      │
└──────────────────────────────────────┘

┌────────── O T R O S ──────────┐
│                                │
│  q       Quit cmus             │
│  F1      This help panel       │
│  :       Command mode          │
│  Ctrl+K  Show all keybindings  │
│  Ctrl+L  Refresh screen        │
│  g       Go to top             │
│  G       Go to bottom          │
│  ↑ / ↓   Navigate              │
│  PageUp   Page up              │
│  PageDown Page down            │
│                                │
└────────────────────────────────┘

────────────────────────────────────────────────────────────
  Tip: Press 5 to browse folders  |  f to ★ favorite
  Press F to load favorites playlist  |  q to close help
────────────────────────────────────────────────────────────
EOF
