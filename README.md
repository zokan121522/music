# 🎵 Retro Wave Music Player

> CMUS configuration with a Stranger Things retro aesthetic.
> Dark reds, grays, blacks, and crisp white contrasts.

## 🚀 Quick Start

```bash
# Launch the player menu (recommended shortcut)
musicIA

# Or from the project directory
./LAUNCH.sh

# Or launch cmus directly
cmus
```

Press **5** in cmus to browse your music folders.

## 🎨 Features

- **Stranger Things retro theme** — Dark reds, grays, blacks, white contrast
- **Visual progress bar** — See your playback position at a glance
- **Browser-first** — Starts in file browser view to pick music instantly
- **Enhanced song format** — Clean, color-coded track display
- **Quick filters** — Find unheard tracks, new additions, and more
- **Custom keybindings** — Intuitive controls (`p` for pause, etc.)
- **Help panel** — Press `F1` for keybinding reference
- **Navigation menu** — `LAUNCH.sh` for easy access

## 📁 Structure

The project lives at `~/MyApps/music/`. Music files are at `~/music/` (symlink to storage).

```
~/MyApps/music/
├── LAUNCH.sh          # Main navigation menu
├── cmus/
│   └── rc             # CMUS configuration reference
├── scripts/
│   ├── help-panel.sh  # F1 help overlay
│   ├── fav-toggle.sh  # ★ favorites toggle
│   ├── fav-load.sh    # Favorites browser
│   └── boot-cmus.sh   # Launcher with music path
├── docs/
│   └── KEYBINDINGS.md # Full keybinding reference
├── Dockerfile         # Linux verification build
└── README.md
```

## 🔧 Install Dependencies

```bash
brew install cmus
```

## 🎮 CMUS Views

| Key | View | Use |
|-----|------|-----|
| `1` | Library | Browse all music |
| `2` | Sorted | By artist/album |
| `3` | Playlist | Current queue |
| `4` | Queue | Temporary queue |
| `5` | **Browser** | 📂 Browse folders |
| `6` | Filters | Custom filters |
| `7` | Settings | Config options |

## ⌨️ Main Controls

| Key | Action |
|-----|--------|
| `p` / `c` | Play / Pause |
| `b` / `z` | Next / Previous |
| `+` / `-` | Volume up / down |
| `s` | Shuffle toggle |
| `r` | Repeat toggle |
| `q` | Quit |

## 🖼️ Preview

```
┌─ 5:Browser ──────────────────────────────────────────┐
│  📁 /music/                                           │
│    ├── 🎵 My Playlist                                 │
│    └── 🎵 More Music                                  │
├───────────────────────────────────────────────────────┤
│  ⏵ 3:42 / 6:15  ────████████████░░░░░░░░░░──         │
│  🎵 Artist - Song                            🔊 65%  │
│  [p]pause [b]next [z]prev [s]shuffle [r]repeat [q]   │
└───────────────────────────────────────────────────────┘
```
