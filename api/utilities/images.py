from io import BytesIO
from PIL import Image
from django.core.files.uploadedfile import InMemoryUploadedFile
import sys

def optimize_image(image_file, max_size=(800, 800), quality=85):
    """
    Optimize an uploaded image to reduce file size while maintaining quality.
    
    Args:
        image_file: The uploaded image file
        max_size: Maximum dimensions (width, height) for the image
        quality: JPEG compression quality (1-100)
        
    Returns:
        An optimized InMemoryUploadedFile
    """
    if not image_file:
        return image_file
        
    # Open the uploaded image
    img = Image.open(image_file)
    
    # Convert to RGB if needed (for PNG with transparency)
    if img.mode != 'RGB':
        img = img.convert('RGB')
    
    # Resize the image while maintaining aspect ratio
    img.thumbnail(max_size, Image.LANCZOS)
    
    # Save the optimized image to a BytesIO buffer
    output = BytesIO()
    img.save(output, format='JPEG', quality=quality, optimize=True)
    output.seek(0)
    
    # Create a new InMemoryUploadedFile from the buffer
    return InMemoryUploadedFile(
        output,
        'ImageField',
        f"{image_file.name.split('.')[0]}.jpg",
        'image/jpeg',
        sys.getsizeof(output),
        None
    )