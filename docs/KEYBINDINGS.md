# 🎵 Retro Wave CMUS — Keybindings Reference

> Stranger Things Edition — Full keyboard control reference

---

## Views

| Key | View | Description |
|-----|------|-------------|
| `1` | Library | Browse by artist/album tree |
| `2` | Sorted | Sorted library view |
| `3` | Playlist | Current playback list |
| `4` | Queue | Temporary queue |
| `5` | **Browser** | 📂 **File browser** (default view) |
| `6` | Filters | Custom filter sets |
| `7` | Settings | Configuration panel |

---

## Playback

| Key | Action |
|-----|--------|
| `p` / `c` | Pause / Resume |
| `x` | Play |
| `v` | Stop |
| `b` | Next track |
| `z` | Previous track |
| `B` | Next album |
| `Z` | Previous album |
| `←` / `h` | Seek backward 5s |
| `→` / `l` | Seek forward 5s |
| `,` | Seek backward 1m |
| `.` | Seek forward 1m |

## Volume

| Key | Action |
|-----|--------|
| `^U` (Ctrl+U) | Volume **up** (10%) |
| `^D` (Ctrl+D) | Volume **down** (10%) |
| `[` | Left channel up |
| `]` | Right channel up |
| `{` | Left channel down |
| `}` | Right channel down |

> `+` / `-` are overridden (no-op) — use `^U` / `^D` instead to avoid accidental triggers.

## List / Queue

| Key | Action |
|-----|--------|
| `Enter` | Play selected |
| `Space` | Toggle selection |
| `a` | Add to library |
| `e` | Add to queue |
| `E` | Add to queue (play next) |
| `y` | Add to playlist |
| `D` / `Del` | Remove from list |
| `Tab` | Switch panels |

## Modes

| Key | Action |
|-----|--------|
| `m` | Cycle playback mode (all/artist/album) |
| `s` | Toggle shuffle |
| `r` | Toggle repeat all |
| `R` | Toggle repeat current |
| `C` | Toggle continue |
| `o` | Toggle sorted library |
| `M` | Toggle play library |

## Favorites

| Key | Action |
|-----|--------|
| `f` | ★ Toggle favorite — adds/removes ★ in tag + symlink |
| `F` | 📂 Browse favorites folder — navigate & play as folder |

> **Note**: Favorites are stored as ★ in the file's Comment tag and as symlinks in
> `~/.config/cmus/favorites-view/`. Browse with `F` to see the ★-prefixed symlinks.

## Search

| Key | Action |
|-----|--------|
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next result |
| `N` | Previous result |
| `L` | Live filter |

## Navigation

| Key | Action |
|-----|--------|
| `↑` / `j` | Move up |
| `↓` / `k` | Move down |
| `PageUp` / `^B` | Page up |
| `PageDown` / `^F` | Page down |
| `g` / `Home` | Go to top |
| `G` / `End` | Go to bottom |

## Other

| Key | Action |
|-----|--------|
| `q` | Quit cmus |
| `F1` | Show this help panel |
| `:` | Command mode |
| `Ctrl+K` | Show all keybindings |
| `Ctrl+L` | Refresh screen |
| `u` | Update cache |
| `I` | Show song info |

---

## Quick Filters (View 6)

| Filter | Description |
|--------|-------------|
| `unheard` | Songs never played |
| `mp3` | Only MP3 files |
| `flac` | Only FLAC files |
| `ogg` | Only OGG files |
| `wav` | Only WAV files |
| `missing-tag` | Songs without metadata |
| `stream` | Streaming tracks |
| `90s` | Songs from the 90s |
| `classical` | Classical genre |

---

## Theme Colors

```
Background:  Black (#0d0d0d)
Active:      Dark Red (#8b0000, #cc0000)
Secondary:   Gray (#666666, #999999)
Text:        White (#ffffff)
Error:       Bright Red (#ff4444)
```
