from django.contrib.auth.base_user import BaseUserManager
from django.utils.translation import gettext_lazy as _


class CustomUserManager(BaseUserManager):

    @staticmethod
    def _validate_superuser_fields(extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        extra_fields.setdefault("is_active", True)

        if not extra_fields.get("is_staff"):
            raise ValueError(_("Superusers must have is_staff=True"))
        if not extra_fields.get("is_superuser"):
            raise ValueError(_("Superusers must have is_superuser=True"))

        return extra_fields

    def _validate_email(self, email):
        if not email:
            raise ValueError(_("An email address is required"))
        email = self.normalize_email(email)
        return email

    def _create_user(self, full_name, email, phone_number, password, **extra_fields):
        """
        Create and save a user with the given email and password.
        """
        if not full_name:
            raise ValueError(_("The full name field is required"))
        if not phone_number:
            raise ValueError(_("The phone number field is required"))
        email = self._validate_email(email)

        user = self.model(full_name=full_name, email=email, phone_number=phone_number, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, full_name=None, email=None, phone_number=None, password=None, **extra_fields):
        extra_fields.setdefault("is_staff", False)
        extra_fields.setdefault("is_superuser", False)
        return self._create_user(full_name, email,  phone_number, password, **extra_fields)

    def create_superuser(
        self, full_name=None, email=None, phone_number=None, password=None, **extra_fields
    ):
        extra_fields = self._validate_superuser_fields(extra_fields)
        return self._create_user(full_name, email, phone_number, password, **extra_fields)
