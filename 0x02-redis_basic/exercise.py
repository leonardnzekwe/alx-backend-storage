#!/usr/bin/env python3
"""Redis Basics Exercise Module"""

import redis
import uuid
from typing import Union, Callable, Any
from functools import wraps


def count_calls(method: Callable) -> Callable:
    """
    Decorator to count how many times
    methods of the Cache class are called
    """
    key = method.__qualname__

    @wraps(method)
    def wrapper(self: Any, *args: Any, **kwargs: Any) -> Any:
        """Wrapper that increments a key in Redis for Cache.store"""
        self._redis.incr(key)
        return method(self, *args, **kwargs)

    return wrapper


def call_history(method: Callable) -> Callable:
    """
    call_history decorator to store the history of inputs
    and outputs for a particular function.
    """
    input_key = method.__qualname__ + ":inputs"
    output_key = method.__qualname__ + ":outputs"

    @wraps(method)
    def wrapper(self: Any, *args: Any, **kwargs: Any) -> Any:
        """Wrapper that records input and output data in Redis lists"""
        input_data = str(args)
        self._redis.rpush(input_key, input_data)
        output_data = method(self, *args)
        self._redis.rpush(output_key, output_data)
        return output_data

    return wrapper


def replay(method: Callable) -> None:
    """
    replay function to display the
    history of calls of a particular function
    """
    client = redis.Redis()

    in_key = f"{method.__qualname__ }:inputs"
    out_key = f"{method.__qualname__}:outputs"

    in_data = client.lrange(in_key, 0, -1)
    out_data = client.lrange(out_key, 0, -1)
    zippy = list(zip(in_data, out_data))

    print(f"{method.__qualname__} was called {len(zippy)} times:")

    for value, r_id in zippy:
        print(
            f'{method.__qualname__}(*{value.decode("utf-8")}) '
            f'-> {r_id.decode("utf-8")}'
        )


class Cache:
    """
    Cache class for storing data in Redis.
    """

    def __init__(self) -> None:
        """Initialize Redis client and flush the database."""
        self._redis = redis.Redis()
        self._redis.flushdb()

    @count_calls
    @call_history
    def store(self, data: Union[str, bytes, int, float]) -> str:
        """
        Generate a random key,
        store input data in Redis, and return the key.
        """
        key = str(uuid.uuid4())
        self._redis.set(key, data)
        return key

    def get(self, key: str,
            fn: Callable = None) -> Union[str, bytes, int, float]:
        """
        Retrieve data from Redis based on the key
        and apply the optional conversion function (fn).
        """
        if fn:
            return fn(self._redis.get(key))
        return self._redis.get(key)

    def get_str(self, key: str) -> Union[str, None]:
        """Retrieve and return data from Redis as a string."""
        return str(self._redis.get(key))

    def get_int(self, key: str) -> Union[int, None]:
        """Retrieve and return data from Redis as an integer."""
        return int(self._redis.get(key))
