from drf_spectacular.utils import OpenApiResponse, extend_schema, OpenApiExample
from rest_framework import status
from rest_framework_simplejwt.serializers import TokenRefreshSerializer

from apps.core.serializers.account import (
    GoogleSocialAuthSerializer,
    CreateVirtualAccountSerializer,
    UpdateProfileSerializer,
)


def google_social_auth_docs():
    return extend_schema(
        summary="Google Authentication Endpoint for registering and logging in",
        description="""
            This endpoint allows users to authenticate through Google and automatically creates a profile for them if it doesn't exist.
            """,
        request=GoogleSocialAuthSerializer,
        tags=["Social Authentication"],
        responses={
            status.HTTP_200_OK: OpenApiResponse(
                response={"application/json"},
                description="Success",
                examples=[
                    OpenApiExample(
                        name="Success without virtual account",
                        value={
                            "status": "success",
                            "message": "Authenticated successfully",
                            "data": {
                                "tokens": {
                                    "access": "<access-token>",
                                    "refresh": "<refresh-token>",
                                },
                                "profile_data": {
                                    "email": "admin@gmail.com",
                                    "profile": {
                                        "id": "sss-sss-sss-sss-sss",
                                        "profile_avatar": None,
                                        "first_name": "John",
                                        "last_name": "Doe",
                                        "bio": None,
                                        "gender": None,
                                        "country": None,
                                        "facebook_media_link": None,
                                        "instagram_media_link": None,
                                        "twitter_media_link": None,
                                        "linkedin_media_link": None,
                                        "youtube_media_link": None,
                                        "tiktok_media_link": None,
                                        "animal_avatar": None,
                                    },
                                    "virtual_account": None,
                                },
                            },
                        },
                    ),
                    OpenApiExample(
                        name="Success with virtual account",
                        value={
                            "status": "success",
                            "message": "Authenticated successfully",
                            "data": {
                                "tokens": {
                                    "access": "<access-token>",
                                    "refresh": "<refresh-token>",
                                },
                                "profile_data": {
                                    "email": "admin@gmail.com",
                                    "profile": {
                                        "id": "sss-sss-sss-sss-sss",
                                        "profile_avatar": None,
                                        "first_name": "John",
                                        "last_name": "Doe",
                                        "bio": None,
                                        "gender": None,
                                        "country": None,
                                        "facebook_media_link": None,
                                        "instagram_media_link": None,
                                        "twitter_media_link": None,
                                        "linkedin_media_link": None,
                                        "youtube_media_link": None,
                                        "tiktok_media_link": None,
                                        "animal_avatar": None,
                                    },
                                    "virtual_account": {
                                        "id": "aaaa-bb29-aaa-aaa-aaaaaa",
                                        "updated_at": "2024-12-31T16:50:34.398990Z",
                                        "flw_ref": "",
                                        "order_ref": "",
                                        "account_number": "000000100155",
                                        "account_status": "active",
                                        "bank_name": "Mock Bank Bank",
                                        "note": "",
                                        "amount": 0,
                                    },
                                    "links": [
                                        {
                                            "status": "success",
                                            "message": "Freemium contents retrieved successfully",
                                            "data": [
                                                {
                                                    "id": "dbe433ad-adf7-4314-9e3d-14512c9d4209",
                                                    "title": "Mock title",
                                                    "link": "https://www.google.com",
                                                    "category": {
                                                        "id": "e929e96c-612e-46b8-bae5-bc040494994c",
                                                        "name": "Games",
                                                    },
                                                    "image": None,
                                                    "description": None,
                                                }
                                            ],
                                        },
                                    ],
                                    "engagement_contents": [
                                        {
                                            "status": "success",
                                            "message": "Engagement contents retrieved successfully",
                                            "data": [
                                                {
                                                    "id": "dbe433ad-adf7-4314-9e3d-14512c9d4209",
                                                    "platform": {
                                                        "id": "e929e96c-612e-46b8-bae5-bc040494994c",
                                                        "name": "Games",
                                                    },
                                                    "link": "https://www.google.com",
                                                    "people_needed": 100,
                                                    "payment_fee": 100,
                                                    "created_at": "2021-01-01T00:00:00Z",
                                                }
                                            ],
                                        },
                                    ],
                                },
                            },
                        },
                    ),
                ],
            ),
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(
                response={"application/json"},
                description="Server Error",
                examples=[
                    OpenApiExample(
                        name="Error",
                        value={
                            "status": "error",
                            "message": "Validation error occurred.",
                            "errors": {
                                "id_token": [
                                    "Invalid token, please use the right token."
                                ]
                            },
                        },
                    ),
                ],
            ),
        },
    )


def refresh_token_auth_docs():
    return extend_schema(
        summary="Refresh Token",
        description="""
        This endpoint allows refresh of expired tokens in the system
        """,
        tags=["Social Authentication"],
        request=TokenRefreshSerializer,
        responses={
            status.HTTP_200_OK: OpenApiResponse(
                response={"application/json"},
                description="Success",
                examples=[
                    OpenApiExample(
                        name="Success",
                        value={
                            "status": "success",
                            "message": "Token refreshed successfully",
                            "data": {"access_token": "<str:access_token>"},
                        },
                    ),
                ],
            ),
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(
                response={"application/json"},
                description="Error",
                examples=[
                    OpenApiExample(
                        name="Error",
                        value={
                            "status": "error",
                            "message": "Error refreshing token",
                            "errors": "<custom_error>",
                        },
                    ),
                ],
            ),
        },
    )


def create_virtual_account_docs():
    return extend_schema(
        summary="Create Virtual Account",
        description="""
            This endpoint allows users to create a virtual account using their bvn on the backend.
            """,
        request=CreateVirtualAccountSerializer,
        tags=["Virtual Account"],
        responses={
            status.HTTP_200_OK: OpenApiResponse(
                response={"application/json"},
                description="Success",
                examples=[
                    OpenApiExample(
                        name="Success",
                        value={
                            "status": "success",
                            "message": "Virtual account created successfully",
                            "data": {
                                "id": "dbe433ad-adf7-4314-9e3d-14512c9d4209",
                                "account_number": "0067100155",
                                "bank_name": "Mock Bank",
                                "amount": 0,
                            },
                        },
                    ),
                    OpenApiExample(
                        name="Exists",
                        value={
                            "status": "success",
                            "message": "User already has a virtual account",
                            "data": {
                                "id": "dbe433ad-adf7-4314-9e3d-14512c9d4209",
                                "account_number": "0067100155",
                                "bank_name": "Mock Bank",
                                "amount": 0,
                            },
                        },
                    ),
                ],
            ),
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(
                response={"application/json"},
                description="Server Error",
                examples=[
                    OpenApiExample(
                        name="Error",
                        value={
                            "status": "error",
                            "message": "Error creating virtual account.",
                            "errors": "Custom error message",
                        },
                    )
                ],
            ),
        },
    )


def update_user_profile_docs():
    return extend_schema(
        summary="Update User Profile",
        description="""
            This endpoint allows users to update their profile.
            """,
        request=UpdateProfileSerializer,
        tags=["User Profile"],
        responses={
            status.HTTP_202_ACCEPTED: OpenApiResponse(
                response={"application/json"},
                description="Success",
                examples=[
                    OpenApiExample(
                        name="Success",
                        value={
                            "status": "success",
                            "message": "Profile updated successfully",
                            "data": {
                                "profile_avatar": "",
                                "first_name": "s",
                                "last_name": "Kalos",
                                "bio": "",
                                "facebook_media_link": "",
                                "instagram_media_link": "",
                                "twitter_media_link": "",
                                "linkedin_media_link": "",
                                "youtube_media_link": "",
                                "tiktok_media_link": "",
                            },
                        },
                    )
                ],
            ),
        },
    )


def get_user_profile_docs():
    return extend_schema(
        summary="Get User Profile",
        description="""
            This endpoint allows users to retrieve their profile.
            """,
        tags=["User Profile"],
        responses={
            status.HTTP_200_OK: OpenApiResponse(
                response={"application/json"},
                description="Success",
                examples=[
                    OpenApiExample(
                        name="Success",
                        value={
                            "status": "success",
                            "message": "Profile retrieved successfully",
                            "data": {
                                "email": "connectme9817@gmail.com",
                                "profile": {
                                    "id": "e870d9fd-6fc4-4c0f-a8e2-8058b0a0bdb0",
                                    "profile_avatar": "",
                                    "first_name": "s",
                                    "last_name": "Kalos",
                                    "bio": "",
                                    "gender": "",
                                    "country": "",
                                    "facebook_media_link": "",
                                    "instagram_media_link": "",
                                    "twitter_media_link": "",
                                    "linkedin_media_link": "",
                                    "youtube_media_link": "",
                                    "tiktok_media_link": "",
                                    "animal_avatar": "",
                                },
                                "virtual_account": {
                                    "id": "dbe433ad-adf7-4314-9e3d-14512c9d4209",
                                    "account_number": "0067100155",
                                    "bank_name": "Mock Bank",
                                    "amount": 0,
                                },
                            },
                        },
                    ),
                ],
            ),
        },
    )
