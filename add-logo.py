import os

from PIL import Image, ImageDraw, ImageFont

# Create directory if it doesn't exist
os.makedirs("/c/knosso/34wiki/data-outline", exist_ok=True)

# Create logo image (200x200px)
logo_size = 200
logo = Image.new(
    "RGBA", (logo_size, logo_size), (253, 185, 39, 255)
)  # Yellow background
draw = ImageDraw.Draw(logo)

# Draw black checkmark and "34"
# Checkmark coordinates (simplified)
checkmark_points = [(40, 100), (80, 140), (160, 60)]
draw.polygon(checkmark_points, fill=(0, 0, 0, 255))

# Save logo
logo.save("/c/knosso/34wiki/logo.png")
print("Logo created: /c/knosso/34wiki/logo.png")

# Create favicon (32x32px)
favicon = Image.new("RGBA", (32, 32), (253, 185, 39, 255))
favicon.save("/c/knosso/34wiki/data-outline/favicon.ico")
print("Favicon created: /c/knosso/34wiki/data-outline/favicon.ico")
