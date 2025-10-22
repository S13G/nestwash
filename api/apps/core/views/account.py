from django.contrib.auth import get_user_model
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from rest_framework import status, permissions
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.generics import CreateAPIView, UpdateAPIView
from rest_framework.permissions import AllowAny, IsAuthenticated

from ..services.account_service import AccountService
from ..services.verification_service import VerificationService
from ..serializers.account_serializers import (
    UserRegistrationSerializer,
    VerificationSerializer,
    CustomerProfileSerializer
)

User = get_user_model()

class CustomerRegistrationView(CreateAPIView):
    """
    API view for customer registration
    """
    permission_classes = [AllowAny]
    serializer_class = UserRegistrationSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        # Extract validated data
        validated_data = serializer.validated_data
        
        try:
            # Create user
            user = AccountService.create_user(
                email=validated_data['email'],
                phone_number=validated_data['phone_number'],
                full_name=validated_data['full_name'],
                password=validated_data['password'],
                user_type='customer'
            )
            
            # Create customer profile
            AccountService.create_customer_profile(
                user=user,
                date_of_birth=validated_data.get('date_of_birth')
            )
            
            # Return success response
            return Response({
                'status': 'success',
                'message': 'Registration successful. Please verify your email and phone number.',
                'user_id': user.id
            }, status=status.HTTP_201_CREATED)
            
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)


class EmailVerificationView(APIView):
    """
    API view for email verification
    """
    permission_classes = [AllowAny]
    
    def post(self, request, *args, **kwargs):
        serializer = VerificationSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            user_id = serializer.validated_data['user_id']
            code = serializer.validated_data['code']
            
            user = User.objects.get(id=user_id)
            
            # Verify email
            is_verified = VerificationService.verify_email_code(user, code)
            
            if is_verified:
                return Response({
                    'status': 'success',
                    'message': 'Email verified successfully.'
                }, status=status.HTTP_200_OK)
            else:
                return Response({
                    'status': 'error',
                    'message': 'Invalid or expired verification code.'
                }, status=status.HTTP_400_BAD_REQUEST)
                
        except User.DoesNotExist:
            return Response({
                'status': 'error',
                'message': 'User not found.'
            }, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)


class PhoneVerificationView(APIView):
    """
    API view for phone verification
    """
    permission_classes = [AllowAny]
    
    def post(self, request, *args, **kwargs):
        serializer = VerificationSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            user_id = serializer.validated_data['user_id']
            code = serializer.validated_data['code']
            
            user = User.objects.get(id=user_id)
            
            # Verify phone
            is_verified = VerificationService.verify_phone_code(user, code)
            
            if is_verified:
                return Response({
                    'status': 'success',
                    'message': 'Phone number verified successfully.'
                }, status=status.HTTP_200_OK)
            else:
                return Response({
                    'status': 'error',
                    'message': 'Invalid or expired verification code.'
                }, status=status.HTTP_400_BAD_REQUEST)
                
        except User.DoesNotExist:
            return Response({
                'status': 'error',
                'message': 'User not found.'
            }, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)


class ResendVerificationView(APIView):
    """
    API view for resending verification codes
    """
    permission_classes = [AllowAny]
    
    def post(self, request, *args, **kwargs):
        verification_type = request.data.get('type')
        user_id = request.data.get('user_id')
        
        if not verification_type or not user_id:
            return Response({
                'status': 'error',
                'message': 'Verification type and user ID are required.'
            }, status=status.HTTP_400_BAD_REQUEST)
            
        try:
            user = User.objects.get(id=user_id)
            
            if verification_type == 'email':
                VerificationService.resend_email_verification(user)
                message = 'Email verification code resent successfully.'
            elif verification_type == 'phone':
                VerificationService.resend_phone_verification(user)
                message = 'Phone verification code resent successfully.'
            else:
                return Response({
                    'status': 'error',
                    'message': 'Invalid verification type. Must be "email" or "phone".'
                }, status=status.HTTP_400_BAD_REQUEST)
                
            return Response({
                'status': 'success',
                'message': message
            }, status=status.HTTP_200_OK)
            
        except User.DoesNotExist:
            return Response({
                'status': 'error',
                'message': 'User not found.'
            }, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)


class CustomerProfileUpdateView(UpdateAPIView):
    """
    API view for updating customer profile
    """
    permission_classes = [IsAuthenticated]
    serializer_class = CustomerProfileSerializer
    
    def get_object(self):
        return self.request.user.customer_profile
    
    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        
        return Response({
            'status': 'success',
            'message': 'Profile updated successfully.',
            'data': serializer.data
        }, status=status.HTTP_200_OK)


class AcceptTermsView(APIView):
    """
    API view for accepting terms of service
    """
    permission_classes = [IsAuthenticated]
    
    def post(self, request, *args, **kwargs):
        try:
            AccountService.accept_terms(request.user)
            
            return Response({
                'status': 'success',
                'message': 'Terms accepted successfully.'
            }, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)