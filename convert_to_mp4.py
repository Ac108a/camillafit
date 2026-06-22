#!/usr/bin/env python3
"""Convert exercise GIFs to MP4 for iOS Safari compatibility."""
import os
import glob
import imageio.v3 as iio
from imageio_ffmpeg import write_frames

GIF_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "gifs")

def gif_to_mp4(gif_path, mp4_path):
    frames = iio.imread(gif_path, index=None)
    h, w = frames[0].shape[:2]
    # Ensure even dimensions (required by h264)
    h = h if h % 2 == 0 else h - 1
    w = w if w % 2 == 0 else w - 1

    writer = write_frames(
        mp4_path,
        (w, h),
        fps=15,
        codec="libx264",
        pix_fmt_in="rgb24",
        pix_fmt_out="yuv420p",
        output_params=["-crf", "28", "-preset", "fast", "-movflags", "+faststart"],
    )
    writer.send(None)  # initialize
    for frame in frames:
        frame = frame[:h, :w, :3]  # crop to even dims, ensure RGB
        writer.send(frame)
    writer.close()

for gif in sorted(glob.glob(os.path.join(GIF_DIR, "*.gif"))):
    name = os.path.splitext(os.path.basename(gif))[0]
    mp4 = os.path.join(GIF_DIR, name + ".mp4")
    if os.path.exists(mp4):
        print(f"  skip {name}.mp4 (exists)")
        continue
    try:
        gif_to_mp4(gif, mp4)
        gif_kb = os.path.getsize(gif) / 1024
        mp4_kb = os.path.getsize(mp4) / 1024
        print(f"  {name}.gif ({gif_kb:.0f}KB) -> .mp4 ({mp4_kb:.0f}KB)")
    except Exception as e:
        print(f"  FAILED {name}: {e}")

print(f"\nDone. MP4 files: {len(glob.glob(os.path.join(GIF_DIR, '*.mp4')))}")
