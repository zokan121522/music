#!/usr/bin/env python3
"""
CMUS Favorites Tag Manager
Writes or removes the ★ symbol in the Comment tag of audio files.
Supports MP3 (ID3), FLAC (Vorbis), M4A/MP4 (©cmt), and OGG.
"""

import sys
import os

STAR = "★"
EMPTY = ""


def tag_mp3(filepath, text):
    """Tag MP3 files using ID3 COMM frame with UTF-8."""
    from mutagen.id3 import ID3, COMM

    try:
        audio = ID3(filepath)
    except Exception:
        audio = ID3()

    audio.delall("COMM")
    if text:
        audio.add(COMM(encoding=3, lang="eng", desc="", text=text))
    audio.save(filepath)
    return True


def tag_flac(filepath, text):
    """Tag FLAC files using Vorbis COMMENT."""
    from mutagen.flac import FLAC

    audio = FLAC(filepath)
    # Remove existing comment
    if "comment" in audio:
        del audio["comment"]
    if "description" in audio:
        del audio["description"]
    if text:
        audio["comment"] = text
        audio["description"] = text
    audio.save()
    return True


def tag_mp4(filepath, text):
    """Tag M4A/MP4 files using ©cmt atom."""
    from mutagen.mp4 import MP4

    audio = MP4(filepath)
    if text:
        audio["©cmt"] = text
    elif "©cmt" in audio:
        del audio["©cmt"]
    audio.save()
    return True


def tag_ogg(filepath, text):
    """Tag OGG files using Vorbis COMMENT."""
    from mutagen.oggvorbis import OggVorbis

    audio = OggVorbis(filepath)
    if "comment" in audio:
        del audio["comment"]
    if "description" in audio:
        del audio["description"]
    if text:
        audio["comment"] = text
        audio["description"] = text
    audio.save()
    return True


def tag_opus(filepath, text):
    """Tag OPUS files (same as OGG)."""
    from mutagen.oggopus import OggOpus

    audio = OggOpus(filepath)
    if "comment" in audio:
        del audio["comment"]
    if "description" in audio:
        del audio["description"]
    if text:
        audio["comment"] = text
        audio["description"] = text
    audio.save()
    return True


def detect_format(filepath):
    """Detect audio format by extension."""
    ext = os.path.splitext(filepath)[1].lower()
    mapping = {
        ".mp3": "mp3",
        ".flac": "flac",
        ".m4a": "mp4",
        ".mp4": "mp4",
        ".ogg": "ogg",
        ".opus": "opus",
        ".wav": "wav",
        ".aiff": "aiff",
        ".aif": "aiff",
        ".wma": "wma",
    }
    return mapping.get(ext, None)


def main():
    if len(sys.argv) < 3:
        print("Usage: fav-tag.py <add|remove> <filepath>")
        sys.exit(1)

    action = sys.argv[1].lower()
    filepath = sys.argv[2]

    if not os.path.isfile(filepath):
        print(f"Error: File not found: {filepath}")
        sys.exit(1)

    fmt = detect_format(filepath)
    if fmt is None:
        print(f"Warning: Unsupported format for {filepath}, skipping tag")
        sys.exit(0)

    text = STAR if action == "add" else EMPTY

    try:
        if fmt == "mp3":
            tag_mp3(filepath, text)
        elif fmt == "flac":
            tag_flac(filepath, text)
        elif fmt == "mp4":
            tag_mp4(filepath, text)
        elif fmt == "ogg":
            tag_ogg(filepath, text)
        elif fmt == "opus":
            tag_opus(filepath, text)
        else:
            print(f"Warning: Cannot tag {fmt} files, skipping")
            sys.exit(0)

        if text:
            print(f"★ Added to {os.path.basename(filepath)}")
        else:
            print(f"♡ Removed from {os.path.basename(filepath)}")
    except Exception as e:
        print(f"Error tagging {filepath}: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
