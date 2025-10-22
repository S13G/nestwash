from django.core.management.base import BaseCommand

from apps.common.models import BlacklistedToken


# Create a celery beat task to remove expired blacklisted tokens once in a while
# Perhaps once a month
class Command(BaseCommand):
    help = "Remove expired blacklisted tokens"

    def handle(self, *args, **kwargs):
        BlacklistedToken.objects.all().delete()
        self.stdout.write("Expired blacklisted tokens removed.")
