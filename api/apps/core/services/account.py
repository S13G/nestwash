from django.conf import settings
from django.utils import timezone
from django.contrib.auth import get_user_model
from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.utils.html import strip_tags
import random
import string
import logging

from ..models.account import CustomerProfile, ServiceProviderProfile

User = get_user_model()
logger = logging.getLogger(__name__)

class AccountService:
    """
    Service class for handling account-related operations including signup,
    verification, and profile management.
    """
    
    @staticmethod
    def generate_verification_code(length=6):
        """Generate a random verification code."""
        return ''.join(random.choices(string.digits, k=length))
    
    @classmethod
    def create_user(cls, email, phone_number, full_name, password, user_type):
        """
        Create a new user with the provided information.
        
        Args:
            email: User's email address
            phone_number: User's phone number
            full_name: User's full name
            password: User's password
            user_type: Type of user (customer or service_provider)
            
        Returns:
            Newly created user object
        """
        try:
            user = User.objects.create_user(
                email=email,
                phone_number=phone_number,
                full_name=full_name,
                password=password,
                user_type=user_type
            )
            
            # Generate and store verification codes
            email_code = cls.generate_verification_code()
            phone_code = cls.generate_verification_code()
            
            # Store verification codes (implementation depends on your verification model)
            cls.store_verification_codes(user, email_code, phone_code)
            
            # Send verification emails and SMS
            cls.send_email_verification(user, email_code)
            cls.send_phone_verification(user, phone_code)
            
            return user
        except Exception as e:
            logger.error(f"Error creating user: {str(e)}")
            raise
    
    @classmethod
    def create_customer_profile(cls, user, date_of_birth=None, preferred_service_areas=None):
        """
        Create a customer profile for a user.
        
        Args:
            user: User object
            date_of_birth: Customer's date of birth
            preferred_service_areas: Customer's preferred service areas
            
        Returns:
            Newly created customer profile
        """
        try:
            profile = CustomerProfile.objects.create(
                user=user,
                date_of_birth=date_of_birth,
                preferred_service_areas=preferred_service_areas or ""
            )
            return profile
        except Exception as e:
            logger.error(f"Error creating customer profile: {str(e)}")
            raise
    
    @classmethod
    def create_service_provider_profile(cls, user, business_name=None, is_business=False):
        """
        Create a service provider profile for a user.
        
        Args:
            user: User object
            business_name: Name of the business
            is_business: Whether the service provider is a business
            
        Returns:
            Newly created service provider profile
        """
        try:
            profile = ServiceProviderProfile.objects.create(
                user=user,
                business_name=business_name or "",
                is_business=is_business
            )
            return profile
        except Exception as e:
            logger.error(f"Error creating service provider profile: {str(e)}")
            raise
    
    @staticmethod
    def store_verification_codes(user, email_code, phone_code):
        """
        Store verification codes for a user.
        This is a placeholder - implement according to your verification model.
        """
        # Implementation depends on your verification model
        # For example, you might store these in Redis or a VerificationCode model
        pass
    
    @staticmethod
    def send_email_verification(user, verification_code):
        """
        Send email verification code to user.
        
        Args:
            user: User object
            verification_code: Email verification code
        """
        try:
            subject = 'Verify Your Email Address'
            html_message = render_to_string(
                'emails/email_verification.html',
                {'user': user, 'verification_code': verification_code}
            )
            plain_message = strip_tags(html_message)
            
            send_mail(
                subject,
                plain_message,
                settings.DEFAULT_FROM_EMAIL,
                [user.email],
                html_message=html_message,
                fail_silently=False
            )
        except Exception as e:
            logger.error(f"Error sending email verification: {str(e)}")
            raise
    
    @staticmethod
    def send_phone_verification(user, verification_code):
        """
        Send phone verification code to user.
        
        Args:
            user: User object
            verification_code: Phone verification code
        """
        # Implementation depends on your SMS provider
        # This is a placeholder
        try:
            # Example using a hypothetical SMS service
            # sms_service.send_sms(
            #     to=user.phone_number,
            #     message=f"Your verification code is: {verification_code}"
            # )
            pass
        except Exception as e:
            logger.error(f"Error sending phone verification: {str(e)}")
            raise
    
    @classmethod
    def verify_email(cls, user, verification_code):
        """
        Verify user's email with the provided verification code.
        
        Args:
            user: User object
            verification_code: Email verification code
            
        Returns:
            Boolean indicating whether verification was successful
        """
        # Implementation depends on your verification model
        # This is a placeholder
        try:
            # Check if verification code matches
            # if verification_code_matches:
            user.email_verified = True
            user.save(update_fields=['email_verified'])
            return True
            # return False
        except Exception as e:
            logger.error(f"Error verifying email: {str(e)}")
            return False
    
    @classmethod
    def verify_phone(cls, user, verification_code):
        """
        Verify user's phone number with the provided verification code.
        
        Args:
            user: User object
            verification_code: Phone verification code
            
        Returns:
            Boolean indicating whether verification was successful
        """
        # Implementation depends on your verification model
        # This is a placeholder
        try:
            # Check if verification code matches
            # if verification_code_matches:
            user.phone_number_verified = True
            user.save(update_fields=['phone_number_verified'])
            return True
            # return False
        except Exception as e:
            logger.error(f"Error verifying phone: {str(e)}")
            return False
    
    @classmethod
    def accept_terms(cls, user):
        """
        Mark that a user has accepted the terms of service.
        
        Args:
            user: User object
        """
        try:
            user.terms_accepted = True
            user.terms_accepted_date = timezone.now()
            user.save(update_fields=['terms_accepted', 'terms_accepted_date'])
        except Exception as e:
            logger.error(f"Error accepting terms: {str(e)}")
            raise