# Create more services in other apps with this template
# Use services in other apps to make your views short and clean
# Perform business logic, processing and complex queries in them
# Use model managers too for mini database queries
from typing import Optional, Union, List, Tuple

from django.conf import settings
from django.db.models import QuerySet

User = settings.AUTH_USER_MODEL


class BaseService:
    def __init__(self):
        self.model = None
        self.serializer_class = None
        self.secret_key = settings.FLUTTERWAVE_SECRET_KEY
        if not self.secret_key:
            raise ValueError("FLUTTERWAVE_SECRET_KEY is not set")

        self.headers = {
            "Authorization": f"Bearer {self.secret_key}",
            "Content-Type": "application/json",
        }
        self.base_url = "https://api.flutterwave.com/v3"

    def get_headers(self):
        """
        Return headers to ensure they're always fresh
        """
        return {
            "Authorization": f"Bearer {self.secret_key}",
            "Content-Type": "application/json",
        }

    def set_context(self, model=None, serializer_class=None):
        """
        Dynamically set the context (model and serializer) for the service.
        """
        self.model = model
        self.serializer_class = serializer_class

    @classmethod
    def check_object_existence(cls, queryset):
        if not queryset.exists():
            return None
        return queryset.first()

    def filter_objects(self, model=None, **kwargs):
        if model is None:
            queryset = self.model.objects.filter(**kwargs)
        else:
            queryset = model.objects.filter(**kwargs)
        return self.check_object_existence(queryset)

    def _get_base_queryset(
        self,
        queryset: Optional[QuerySet] = None,
        filters_kwargs: Optional[dict] = None,
        user: Optional[User] = None,
    ):
        """
        Get base queryset with common filtering logic.
        """
        if queryset is None:
            queryset = self.model.objects.all()

            # Check if the model has `is_deleted` and `is_active` fields
            if hasattr(self.model, "is_deleted"):
                queryset = queryset.exclude(is_deleted=True)
            if hasattr(self.model, "is_active"):
                queryset = queryset.exclude(is_active=False)

        # Apply user filter if provided
        if user is not None:
            queryset = queryset.filter(user=user)

        # Apply custom filters if provided
        if filters_kwargs:
            queryset = queryset.filter(**filters_kwargs)

        return queryset

    def retrieve_all_objects(
        self,
        fields_to_defer: Optional[Union[List[str], Tuple[str, ...]]] = None,
        queryset: Optional[QuerySet] = None,
        user: User = None,
    ):
        """
        Retrieve all objects, excluding deleted and inactive ones.
        If `fields` is provided, use .values() to retrieve specific fields.
        If `queryset` is provided, use it instead of the default queryset.
        """

        queryset = self._get_base_queryset(queryset=queryset, user=user)

        if fields_to_defer:
            return queryset.defer(*fields_to_defer)
        return queryset

    def retrieve_filtered_objects(
        self,
        filters_kwargs: dict,
        fields_to_defer: Optional[Union[List[str], Tuple[str, ...]]] = None,
        queryset: Optional[QuerySet] = None,
    ):
        """
        Retrieve all objects, excluding deleted and inactive ones.
        If `fields` is provided, use .values() to retrieve specific fields.
        If `queryset` is provided, use it instead of the default queryset.
        """

        queryset = self._get_base_queryset(
            queryset=queryset,
            filters_kwargs=filters_kwargs,
        )

        if fields_to_defer:
            return queryset.defer(*fields_to_defer)
        return queryset

    def create_object(self, model=None, user=None, is_active=True, **kwargs):

        # Determine the model to use
        target_model = model if model is not None else self.model

        # Add `is_active` to kwargs if needed
        if is_active:
            kwargs["is_active"] = True

        if user:
            kwargs["user"] = user

        # Create and return the object
        return target_model.objects.create(**kwargs)

    def update_object(self, obj_id, **kwargs):
        instance = self.filter_objects(id=obj_id)

        if instance is None:
            return None

        # Keep track of fields that are updated
        updated_fields = []  # noqa

        for key, value in kwargs.items():
            if getattr(instance, key) != value:  # Check if the field value has changed
                setattr(instance, key, value)
                updated_fields.append(key)

        if updated_fields:  # Only save if there are changes
            instance.full_clean()
            instance.save(update_fields=updated_fields)

        return instance

    def delete_object(self, **kwargs):
        queryset = self._get_base_queryset(filters_kwargs=kwargs)
        instance = self.check_object_existence(queryset)
    
        if instance is None:
            return None
    
        if hasattr(instance, "is_deleted") and hasattr(instance, "is_active"):
            instance.is_deleted = True
            instance.is_active = False
            instance.save(update_fields=["is_deleted", "is_active"])
        else:
            instance_data = instance
            instance.delete()
            return instance_data  # So instance won't be none after deletion
    
        return instance
