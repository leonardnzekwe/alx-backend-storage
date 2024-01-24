#!/usr/bin/env python3
"""Implementing an expiring web cache and tracker"""
import redis
import requests
from functools import wraps

# Use a constant for expiration time for better readability
CACHE_EXPIRATION_TIME = 10

# Redis connection
r = redis.Redis()


def url_access_count(method):
    """Decorator for get_page function."""

    @wraps(method)
    def wrapper(url):
        """Wrapper function to handle caching and counting URL access."""
        key = f"cached:{url}"
        cached_value = r.get(key)

        if cached_value:
            return cached_value.decode("utf-8")

        # Get new content and update cache
        key_count = f"count:{url}"
        html_content = method(url)

        r.incr(key_count)
        r.set(key, html_content, ex=CACHE_EXPIRATION_TIME)
        r.expire(key, CACHE_EXPIRATION_TIME)

        return html_content

    return wrapper


@url_access_count
def get_page(url: str) -> str:
    """Obtain the HTML content of a particular URL."""
    results = requests.get(url)
    return results.text


if __name__ == "__main__":
    # Example usage
    get_page("http://slowwly.robertomurray.co.uk")
