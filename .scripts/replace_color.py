#!/usr/bin/python3
import sys
from PIL import Image

def is_grayscale(r, g, b):
    return r == g == b

def hex_to_rgb(hex_color):
    # Remove '#' if it exists
    hex_color = hex_color.lstrip('#')
    # Convert hex to RGB
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def replace_colorful_pixels(image_path, replacement_color, output_path):
    with Image.open(image_path) as img:
        pixels = img.load()
        for i in range(img.width):
            for j in range(img.height):
                r, g, b = pixels[i, j][:3]
                if not is_grayscale(r, g, b):
                    pixels[i, j] = replacement_color
        img.save(output_path)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python script.py <path_to_image> <replacement_color_hex> <output_path>")
        sys.exit(1)

    image_path = sys.argv[1]
    replacement_color_hex = sys.argv[2]
    output_path = sys.argv[3]

    replacement_color = hex_to_rgb(replacement_color_hex)  # Convert hex to RGB tuple

    replace_colorful_pixels(image_path, replacement_color, output_path)
    print(f"Processed image saved to {output_path}")
