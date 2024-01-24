#!/usr/bin/env python3
"""Implementing an expiring web cache and tracker"""
import requests
import redis

# Redis connection
client = redis.Redis()


def get_page(url: str) -> str:
    """
    Obtains HTML content of the URL argument and returns it.
    """
    result = requests.get(url).text
    count_key = f"count:{url}"
    result_key = f"result:{url}"

    if not client.exists(count_key):
        client.set(count_key, 1)
        client.setex(result_key, 10, result)
    else:
        client.incr(count_key)

    return result
