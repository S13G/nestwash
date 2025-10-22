from decouple import config
from django.contrib.auth import get_user_model
from django.core.management.base import BaseCommand

User = get_user_model()


class Command(BaseCommand):
    help = "Creates a superuser."

    def handle(self, *args, **options):
        admin_full_name = config("ADMIN_FULL_NAME")
        admin_email = config("ADMIN_EMAIL")
        admin_phone_number = config('ADMIN_PHONE')
        admin_password = config("ADMIN_PASSWORD")

        if not User.objects.filter(email=admin_email).exists():
            User.objects.create_superuser(  # noqa
                full_name=admin_full_name, email=admin_email, phone_number= admin_phone_number, password=admin_password
            )
            self.stdout.write(self.style.SUCCESS("Superuser has been created."))
        else:
            self.stderr.write(self.style.WARNING("Superuser already exists."))
