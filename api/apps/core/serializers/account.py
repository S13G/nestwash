from django.contrib.auth import get_user_model
from rest_framework import serializers
from ..models.account import CustomerProfile, ServiceProviderProfile, Address

User = get_user_model()

class CustomerRegistrationSerializer(serializers.Serializer):
    """Serializer for user registration"""
    full_name = serializers.CharField()
    email = serializers.EmailField()
    phone_number = serializers.CharField()
    full_name = serializers.CharField()
    password = serializers.CharField(write_only=True, style={'input_type': 'password'})
    user_type = serializers.ChoiceField(choices=User.USER_TYPE_CHOICES, default=User.CUSTOMER, read_only=True)
    preferred_service_areas = serializers.ListField(
        child=serializers.CharField(),
        required=False,
        help_text="List of preferred service areas (e.g., neighborhoods, cities: Ikeja, Mainland)"
    )
    date_of_birth = serializers.DateField(required=False, write_only=True)
    terms_accepted = serializers.BooleanField(required=True)
    
    def validate_email(self, value):
        """Validate that the email is not already in use"""
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email is already in use.")
        return value
    
    def validate_phone_number(self, value):
        """Validate that the phone number is not already in use"""
        if User.objects.filter(phone_number=value).exists():
            raise serializers.ValidationError("Phone number is already in use.")
        return value
    
    def validate(self, data):
        if not data.get('terms_accepted', False):
            raise serializers.ValidationError({"terms_accepted": "You must accept the terms and conditions."})
        
        return data


class VerificationSerializer(serializers.Serializer):
    """Serializer for verification codes"""
    user_id = serializers.IntegerField()
    code = serializers.CharField(max_length=6)
