import re
from urllib.parse import urlparse
from django.core.exceptions import ValidationError
from django.conf import settings
import logging

logger = logging.getLogger(__name__)


class URLSecurityValidator:
    """
    Security validator for URLs to check for phishing, malware, and illicit content.
    """
    
    # Common phishing/suspicious patterns
    SUSPICIOUS_PATTERNS = [
        r'bit\.ly',
        r'tinyurl\.com',
        r'goo\.gl',
        r't\.co',
        r'ow\.ly',
        r'is\.gd',
        r'buff\.ly',
        r'[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}',  # IP addresses
        r'[a-zA-Z0-9]+-[a-zA-Z0-9]+-[a-zA-Z0-9]+\.(tk|ml|ga|cf)',  # Suspicious TLDs
        r'[a-zA-Z0-9]+\.(tk|ml|ga|cf|pw|top)',  # Free suspicious domains
    ]
    
    # Blocked domains/keywords
    BLOCKED_KEYWORDS = [
        'phishing', 'scam', 'fraud', 'malware', 'virus', 'trojan',
        'adult', 'porn', 'xxx', 'gambling', 'casino', 'bet',
        'drugs', 'illegal', 'piracy', 'torrent', 'warez'
    ]
    
    # Safe domains whitelist (major platforms)
    SAFE_DOMAINS = [
        'facebook.com', 'instagram.com', 'twitter.com', 'x.com',
        'youtube.com', 'tiktok.com', 'linkedin.com', 'pinterest.com',
        'snapchat.com', 'reddit.com', 'discord.com', 'telegram.org',
        'whatsapp.com', 'google.com', 'microsoft.com', 'apple.com'
    ]
    
    @classmethod
    def validate_url_security(cls, url: str) -> dict:
        result = {
            'is_safe': True,
            'warnings': [],
            'blocked_reasons': []
        }
        
        try:
            parsed_url = urlparse(url.lower())
            domain = parsed_url.netloc.replace('www.', '')
            
            # Check if domain is in safe list
            if any(safe_domain in domain for safe_domain in cls.SAFE_DOMAINS):
                return result
            
            # Check for suspicious patterns
            for pattern in cls.SUSPICIOUS_PATTERNS:
                if re.search(pattern, url, re.IGNORECASE):
                    result['warnings'].append(f"Suspicious pattern detected: {pattern}")
            
            # Check for blocked keywords
            for keyword in cls.BLOCKED_KEYWORDS:
                if keyword in url.lower():
                    result['is_safe'] = False
                    result['blocked_reasons'].append(f"Blocked keyword detected: {keyword}")
            
            # Check URL structure
            cls._validate_url_structure(url, result)
            
            # Check domain reputation (basic)
            cls._check_domain_reputation(domain, result)
            
        except Exception as e:
            logger.warning(f"URL security validation error for {url}: {str(e)}")
            result['warnings'].append("Could not fully validate URL security")
        
        return result
    
    @classmethod
    def _validate_url_structure(cls, url: str, result: dict):
        """Validate URL structure for suspicious patterns."""
        parsed = urlparse(url)
        
        # Check for suspicious URL patterns
        if len(parsed.path) > 300:
            result['warnings'].append("Unusually long URL path")
        
        if parsed.path.count('/') > 12:
            result['warnings'].append("Unusually deep URL path")
        
        # Check for suspicious query parameters
        if parsed.query:
            suspicious_params = ['redirect', 'goto', 'url', 'link', 'next']
            for param in suspicious_params:
                if param in parsed.query.lower():
                    result['warnings'].append(f"Suspicious redirect parameter: {param}")
    
    @classmethod
    def _check_domain_reputation(cls, domain: str, result: dict):
        """Basic domain reputation check."""
        # Check for suspicious TLDs
        suspicious_tlds = ['.tk', '.ml', '.ga', '.cf', '.pw', '.top']
        if any(domain.endswith(tld) for tld in suspicious_tlds):
            result['warnings'].append("Domain uses suspicious TLD")
        
        # Check for excessive subdomains
        if domain.count('.') > 3:
            result['warnings'].append("Excessive subdomains detected")
    
    @classmethod
    def validate_content_link(cls, url: str, raise_exception: bool = True) -> str:
        """
        Validate content link with security checks.
        If URL is deemed unsafe and raise_exception is True
        """
        # Ensure URL ends with forward slash
        if not url.endswith("/"):
            url = url + "/"
        
        # Perform security validation
        security_result = cls.validate_url_security(url)
        
        if not security_result['is_safe'] and raise_exception:
            reasons = '; '.join(security_result['blocked_reasons'])
            raise ValidationError(f"URL blocked for security reasons: {reasons}")
        
        # Log warnings for monitoring
        if security_result['warnings']:
            warnings = '; '.join(security_result['warnings'])
            logger.warning(f"URL security warnings for {url}: {warnings}")
        
        return url


class ContentSecurityValidator:
    """
    Validator for content security including text and image validation.
    """
    
    # Blocked content patterns
    BLOCKED_CONTENT_PATTERNS = [
        r'\b(phishing|scam|fraud)\b',
        r'\b(malware|virus|trojan)\b',
        r'\b(illegal|drugs|weapons)\b',
        r'\b(adult|porn|xxx)\b',
        r'\b(gambling|casino|bet)\b',
    ]
    
    @classmethod
    def validate_text_content(cls, text: str) -> dict:
        """
        Validate text content for illicit material.
        """
        result = {
            'is_safe': True,
            'warnings': [],
            'blocked_reasons': []
        }
        
        if not text:
            return result
        
        text_lower = text.lower()
        
        # Check for blocked patterns
        for pattern in cls.BLOCKED_CONTENT_PATTERNS:
            if re.search(pattern, text_lower):
                result['is_safe'] = False
                result['blocked_reasons'].append(f"Blocked content pattern detected")
        
        return result
    
    @classmethod
    def validate_submission_content(cls, text: str = None, raise_exception: bool = True) -> bool:
        """
        Validate submission content for security.
        If content is deemed unsafe and raise_exception is True
        """
        if text:
            result = cls.validate_text_content(text)
            
            if not result['is_safe'] and raise_exception:
                raise ValidationError("Content contains blocked material and cannot be submitted")
            
            return result['is_safe']
        
        return True


# Convenience functions for serializer use
def validate_url_security(url: str) -> str:
    return URLSecurityValidator.validate_content_link(url)


def validate_content_security(text: str = None) -> bool:
    return ContentSecurityValidator.validate_submission_content(text)