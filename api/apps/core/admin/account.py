from django.contrib import admin
from django.contrib.auth.admin import GroupAdmin as BaseGroupAdmin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth.models import Group as DjangoGroup

from apps.core.models.account import *


class Group(DjangoGroup):
    class Meta:
        verbose_name = "group"
        verbose_name_plural = "groups"
        proxy = True


@admin.register(Group)
class GroupAdmin(BaseGroupAdmin):
    pass


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = (
        "full_name",
        "user_type",
        "email",
        "phone_number",
        "email_verified",
        "phone_number_verified",
        "is_staff",
        "is_active",
        "is_superuser",
        "created_at",
    )
    list_filter = (
        "is_staff",
        "is_active",
        "is_superuser",
        "user_type",
        "terms_accepted",
        "email_verified",
        "phone_number_verified",
    )
    list_per_page = 20
    fieldsets = (
        (
            "User Credentials",
            {
                "fields": (
                    "user_type",
                    "email",
                    "phone_number",
                    "password",
                )
            },
        ),
        (
            "Personal Information",
            {
                "fields": (
                    "full_name",
                    "email_verified",
                    "phone_number_verified",
                    "terms_accepted",
                )
            },
        ),
        (
            "Permissions",
            {
                "fields": (
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "groups",
                    "user_permissions",
                )
            },
        ),
        (
            "Important Dates",
            {
                "fields": (
                    "last_login",
                    "created_at",
                    "updated_at",
                )
            },
        ),
    )

    add_fieldsets = (
        (
            "User Information",
            {
                "classes": ("wide",),
                "fields": (
                    "email",
                    "full_name",
                    "user_type",
                    "phone_number",
                    "password1",
                    "password2",
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "terms_accepted",
                ),
            },
        ),
    )
    readonly_fields = (
        "last_login",
        "created_at",
        "updated_at",
    )
    search_fields = ("email", "full_name", "phone_number")
    ordering = ("email", "full_name",)


@admin.register(CustomerProfile)
class CustomerProfileAdmin(admin.ModelAdmin):
    list_display = (
        "user", 
        "date_of_birth", 
        "created_at", 
        "updated_at")
    search_fields = (
        "user__email", 
        "user__full_name", 
        "preferred_service_areas"
        )
    list_per_page = 20
    fieldsets = [
        (
            "Customer Information",
            {
                "fields": [
                    "user",
                    "date_of_birth",
                    "preferred_service_areas",
                    "profile_photo",
                    "notification_preferences",
                ],
            },
        ),
        (
            "Status Information",
            {
                "fields": [
                    "created_at",
                    "updated_at",
                    "is_active",
                    "is_deleted",
                ],
            },
        ),
    ]
    readonly_fields = ("created_at", "updated_at")


@admin.register(ServiceProviderProfile)
class ServiceProviderProfileAdmin(admin.ModelAdmin):
    list_display = (
        "user", 
        "business_name", 
        "is_business",
        "is_registered_business", 
        "is_available",
        "user__is_active",
        "is_verified", 
        "average_rating",
        "total_rating",
        "created_at"
    )
    list_filter = ("user__is_active", "is_verified", "is_business", "is_registered_business", "is_available")
    search_fields = ("user__email", "user__full_name", "business_name", "address")
    list_per_page = 20
    fieldsets = [
        (
            "Business Information",
            {
                "fields": [
                    "user",
                    "business_name",
                    "is_business",
                    "is_registered_business",
                    "address",
                    "service_description",
                    "profile_photo",
                    "notification_preferences",
                    "average_rating",
                    "total_rating",
                ],
            },
        ),
        (
            "Identification Information",
            {
                "fields": [
                    "identification_document",
                    "identification_number",
                ],
            },
        ),
        (
            "Location Information",
            {
                "fields": [
                    "longitude",
                    "latitude",
                ],
            },
        ),
        (
            "Status Information",
            {
                "fields": [
                    "is_available",
                    "user__is_active",
                    "is_verified",
                    "created_at",
                    "updated_at",
                    "is_deleted",
                ],
            },
        ),
    ]
    readonly_fields = ("created_at", "updated_at")


@admin.register(Address)
class AddressAdmin(admin.ModelAdmin):
    list_display = (
        "customer", 
        "address_label", 
        "street_address", 
        "city", 
        "state", 
        "is_default"
    )
    list_filter = ("city", "state", "is_default")
    search_fields = ("customer__user__email", "customer__user__full_name", "street_address", "city", "state")
    list_per_page = 20
    fieldsets = [
        (
            "Address Information",
            {
                "fields": [
                    "customer",
                    "address_label",
                    "street_address",
                    "city",
                    "state",
                    "instruction",
                    "is_default",
                ],
            },
        ),
        (
            "Status Information",
            {
                "fields": [
                    "created_at",
                    "updated_at",
                    "is_active",
                    "is_deleted",
                ],
            },
        ),
    ]
    readonly_fields = ("created_at", "updated_at")

admin.site.unregister(DjangoGroup)
