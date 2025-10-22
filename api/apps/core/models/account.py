from django.contrib.auth.base_user import AbstractBaseUser
from django.contrib.auth.models import PermissionsMixin
from django.core import validators
from django.db import models
from rest_framework_simplejwt.tokens import RefreshToken

from apps.common.models import BaseModel, ActiveBaseModel
from apps.core.managers import CustomUserManager
from apps.core.choices import USER_TYPES
from utilities.general import validate_image_file
from utilities.images import optimize_image


class User(AbstractBaseUser, ActiveBaseModel, PermissionsMixin):
    username = None
    user_type = models.CharField(choices=USER_TYPES, max_length=20)
    email = models.EmailField(unique=True)
    email_verified = models.BooleanField(default=False)
    full_name = models.CharField(max_length=255)
    phone_number = models.CharField(
        max_length=20,
        validators=[
            validators.RegexValidator(
                regex=r'^\+?1?\d{9,15}$',
                message="Phone number must be entered in the format: '+999999999'. Up to 15 digits allowed."
            )
        ],
        unique=True
    )
    phone_number_verified = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    terms_accepted = models.BooleanField(default=False)

    objects = CustomUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['full_name', 'phone_number']

    def __str__(self):
        return f"{self.email} ({self.user_type})"

    def tokens(self):
        refresh = RefreshToken.for_user(self)
        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token)
        }


class CustomerProfile(BaseModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='customer_profile')
    date_of_birth = models.DateField()
    preferred_service_areas = models.TextField(help_text="Enter comma-separated areas, e.g., 'Ikeja, Yaba'")
    profile_photo = models.ImageField(
        upload_to='profile_photos/customers/', 
        null=True, 
        blank=True,
        validators=[validate_image_file],
        help_text="Profile photo will be automatically optimized for quality and size. Supported formats: JPG, JPEG, PNG, GIF, WEBP"
    )
    notification_preferences = models.JSONField(
        default=dict,
        help_text="Preferences for receiving notifications about cleaning services"
    )

    class Meta:
        verbose_name = 'Customer Profile'
        verbose_name_plural = 'Customer Profiles'

    def __str__(self):
        return f"Customer: {self.user.full_name}"

    def profile_photo_url(self):
        return self.profile_photo.url if self.profile_photo else None
        
    def save(self, *args, **kwargs):
        # Optimize profile photo if it's being updated
        if self.profile_photo and hasattr(self.profile_photo, 'file'):
            self.profile_photo = optimize_image(self.profile_photo)
        super().save(*args, **kwargs)


class ServiceProviderProfile(BaseModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='provider_profile')
    is_business = models.BooleanField(default=False)
    business_name = models.CharField(max_length=255)
    is_registered_business = models.BooleanField(default=False)
    identification_document = models.FileField(
        upload_to='identification_docs/', 
        null=True, 
        blank=True,
    )
    identification_number = models.CharField(max_length=255, null=True, blank=True)
    address = models.CharField(max_length=255, null=True, blank=True)
    service_description = models.TextField(null=True, blank=True)
    profile_photo = models.ImageField(
        upload_to='profile_photos/service_providers/', 
        null=True, 
        blank=True,
        validators=[validate_image_file],
        help_text="Profile photo will be automatically optimized for quality and size. Supported formats: JPG, JPEG, PNG, GIF, WEBP"
    )
    is_verified = models.BooleanField(default=False)
    longitude = models.FloatField(null=True, blank=True)
    latitude = models.FloatField(null=True, blank=True)
    is_available = models.BooleanField(default=False)
    average_rating = models.DecimalField(
        max_digits=3, 
        decimal_places=2, 
        default=0.0,
        help_text="Average rating from customers"
    )
    total_rating = models.PositiveIntegerField(default=0)
    notification_preferences = models.JSONField(
        default=dict,
        help_text="Preferences for receiving notifications about cleaning services"
    )


    class Meta:
        verbose_name = 'Service Provider Profile'
        verbose_name_plural = 'Service Provider Profiles'

    def __str__(self):
        return f"Service Provider: {self.business_name} ({'Active' if self.is_active else 'Inactive'})"
        

class Address(BaseModel):
    customer = models.ForeignKey(CustomerProfile, on_delete=models.CASCADE, related_name='addresses')
    address_label = models.CharField(max_length=10, null=True)
    street_address = models.CharField(max_length=255)
    city = models.CharField(max_length=255)
    state = models.CharField(max_length=255)
    instruction = models.TextField(null=True)
    is_default = models.BooleanField(default=False)

    class Meta:
        verbose_name = 'Address'
        verbose_name_plural = 'Addresses'
        constraints = [
            models.UniqueConstraint(
                fields=['customer'],
                condition=models.Q(is_default=True),
                name='unique_default_address_per_customer'
            )
        ]

    def __str__(self):
        return f"{self.address_label}, {self.city}, {self.state}"


