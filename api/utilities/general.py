import hashlib
import secrets
import os

from cryptography.fernet import Fernet
from decouple import config
from django.core.exceptions import ValidationError
from django.core.exceptions import ValidationError
from django.db import transaction
from django.utils import timezone

from apps.common.choices import SUCCESS, FAILED
from apps.common.models import TaskLog

ENCRYPTION_SECRET_KEY = config("ENCRYPTION_SECRET_KEY")
cipher_suite = Fernet(ENCRYPTION_SECRET_KEY)


def validate_phone_number(value):
    if not value.startswith("+"):
        raise ValidationError("Phone number must start with country code e.g. (+44).")
    elif not value[1:].isdigit():
        raise ValidationError("Phone number must be digits.")
        
def validate_image_file(value):
    """
    Validates that the uploaded file is an image (not PDF or other formats).
    """
   
    
    ext = os.path.splitext(value.name)[1]
    valid_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp']
    
    if not ext.lower() in valid_extensions:
        raise ValidationError('Only image files are allowed. Supported formats: JPG, JPEG, PNG, GIF, WEBP')


def generate_otp_secret_key():
    return secrets.token_hex(32)


def encrypt_details_with_secret_key(data):
    encrypted_data = cipher_suite.encrypt(data.encode()).decode()
    return encrypted_data


def decrypt_details_with_secret_key(encrypted_data):
    decrypted_data = cipher_suite.decrypt(encrypted_data.encode()).decode()
    return decrypted_data


def create_success_task_log(checkpoint, message):
    with transaction.atomic():
        TaskLog.objects.create(
            checkpoint=checkpoint,
            message=message,
            status=SUCCESS,
        )


def create_failed_task_log(checkpoint, message, data_details=None):
    with transaction.atomic():
        TaskLog.objects.create(
            checkpoint=checkpoint,
            message=message,
            status=FAILED,
            data_details=data_details,
        )


def generate_transaction_reference():
    # Longer random string (16 bytes = 32 characters)
    random_part = secrets.token_hex(16).upper()

    # Timestamp (for internal use only, not exposed)
    timestamp_part = timezone.now().strftime("%y%m%d%H%M%S")

    # Combine random part and timestamp, then hash for additional security
    combined = f"{random_part}{timestamp_part}"
    hashed_reference = hashlib.sha256(combined.encode()).hexdigest().upper()

    # Use the first 20 characters of the hash as the reference
    return hashed_reference[:20]
