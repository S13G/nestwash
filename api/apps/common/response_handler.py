from rest_framework import status
from rest_framework.response import Response


class ResponseHandler:
    """
    Class to handle consistent API responses and exceptions
    """

    @staticmethod
    def success(message, data=None, status_code=status.HTTP_200_OK):
        """Standard success response"""
        return Response(
            {
                "status": "success",
                "message": message,
                "data": data,
            },
            status=status_code,
        )

    @staticmethod
    def error(message, errors=None, status_code=status.HTTP_400_BAD_REQUEST):
        """Standard error response"""
        return Response(
            {
                "status": "error",
                "message": message,
                "errors": errors,
            },
            status=status_code,
        )

    @staticmethod
    def validation_error(validation_errors, status_code=status.HTTP_400_BAD_REQUEST):
        """
        Handle validation errors in a consistent format
        Converts DRF validation errors into a simple array of messages
        """
        error_messages = []
        
        if isinstance(validation_errors, dict):
            for field, messages in validation_errors.items():
                if isinstance(messages, list):
                    for message in messages:
                        if field == 'non_field_errors':
                            error_messages.append(str(message))
                        else:
                            # Format: "Field name: Error message"
                            field_name = field.replace('_', ' ').title()
                            error_messages.append(f"{field_name}: {str(message)}")
                else:
                    field_name = field.replace('_', ' ').title()
                    error_messages.append(f"{field_name}: {str(messages)}")
        elif isinstance(validation_errors, list):
            error_messages.extend([str(error) for error in validation_errors])
        else:
            error_messages.append(str(validation_errors))
        
        return Response(
            {
                "status": "error",
                "message": "Validation failed. Please check the following errors:",
                "errors": error_messages,
            },
            status=status_code,
        )
