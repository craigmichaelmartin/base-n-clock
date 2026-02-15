#!/usr/bin/env python3
"""
Generate required channel images for the Base N Clock Roku channel.

Usage:
    pip install Pillow
    cd roku
    python generate_images.py

Creates:
    images/icon_focus_hd.png   - 336x210  Channel icon (focused)
    images/icon_side_hd.png    - 108x69   Channel icon (side)
    images/splash_screen_hd.jpg - 1280x720 Splash screen
"""

import os
import sys

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("Pillow is required. Install it with:")
    print("  pip install Pillow")
    sys.exit(1)

IMAGES_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "images")
BG_COLOR = (6, 6, 12)
ACCENT_COLOR = (0, 229, 255)


def get_font(size):
    """Try to load a clean font, fall back to default."""
    font_paths = [
        "/System/Library/Fonts/Menlo.ttc",
        "/System/Library/Fonts/SFMono-Regular.otf",
        "/System/Library/Fonts/Helvetica.ttc",
        "/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationMono-Bold.ttf",
        "C:\\Windows\\Fonts\\consola.ttf",
        "C:\\Windows\\Fonts\\cour.ttf",
    ]
    for path in font_paths:
        if os.path.exists(path):
            try:
                return ImageFont.truetype(path, size)
            except Exception:
                pass
    return ImageFont.load_default()


def create_image(width, height, filename, text, font_size):
    """Create a simple branded image with centered text."""
    img = Image.new("RGB", (width, height), color=BG_COLOR)
    draw = ImageDraw.Draw(img)
    font = get_font(font_size)

    bbox = draw.textbbox((0, 0), text, font=font, align="center")
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    x = (width - tw) / 2
    y = (height - th) / 2

    draw.text((x, y), text, fill=ACCENT_COLOR, font=font, align="center")

    os.makedirs(IMAGES_DIR, exist_ok=True)
    filepath = os.path.join(IMAGES_DIR, filename)
    img.save(filepath)
    print(f"  Created: {filepath}")


if __name__ == "__main__":
    print("Generating Roku channel images...")
    print()
    create_image(336, 210, "icon_focus_hd.png", "Base N\nClock", 36)
    create_image(108, 69, "icon_side_hd.png", "BNC", 18)
    create_image(1280, 720, "splash_screen_hd.jpg", "Base N Clock", 64)
    print()
    print("Done! All images created in the images/ directory.")
