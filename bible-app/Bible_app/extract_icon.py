from PIL import Image
import sys

try:
    img = Image.open('assets/Holy_Bible_icon.ico')
    # Pillow opens the largest image in the .ico file by default.
    print(f"Opened image format: {img.format}, size: {img.size}")
    # Convert to RGBA just in case
    img = img.convert("RGBA")
    img.save('assets/Holy_Bible_icon.png', format='PNG')
    print("Successfully converted ICO to PNG")
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
