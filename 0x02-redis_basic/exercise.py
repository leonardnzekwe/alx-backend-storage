#!/usr/bin/env python3
"""Redis Basics Exercise Module"""

import redis
import uuid
from typing import Union, Callable
from functools import cache, wraps


class Cache:
    """
    Cache class for storing data in Redis.
    """

    def __init__(self) -> None:
        """Initialize Redis client and flush the database."""
        self._redis = redis.Redis()
        self._redis.flushdb()

    @staticmethod
    def count_calls(method: Callable) -> Callable:
        """Decorator to count the number of calls to a method."""
        counts = {}

        @wraps(method)
        def wrapper(self, *args, **kwargs):
            key = method.__qualname__
            counts[key] = counts.get(key, 0) + 1
            result = method(self, *args, **kwargs)
            return result

        return wrapper

    @staticmethod
    def call_history(method: Callable) -> Callable:
        """
        Decorator to store the history of inputs
        and outputs for a function.
        """

        @wraps(method)
        def wrapper(self, *args, **kwargs):
            input_key = "{}:inputs".format(method.__qualname__)
            output_key = "{}:outputs".format(method.__qualname__)

            # Store input arguments
            self._redis.rpush(input_key, str(args))

            # Execute the wrapped function to retrieve the output
            result = method(self, *args, **kwargs)

            # Store the output
            self._redis.rpush(output_key, result)

            return result

        return wrapper

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
            fn: Callable = None) -> Union[str, bytes, int, float, None]:
        """
        Retrieve data from Redis based on the key
        and apply the optional conversion function (fn).
        """
        data = self._redis.get(key)
        if data is not None and fn is not None:
            return fn(data)
        return data

    def get_str(self, key: str) -> Union[str, None]:
        """Retrieve and return data from Redis as a UTF-8 string."""
        return self.get(key, fn=lambda d: d.decode("utf-8"))

    def get_int(self, key: str) -> Union[int, None]:
        """Retrieve and return data from Redis as an integer."""
        return self.get(key, fn=int)


def replay(func: Callable) -> None:
    """Display the history of calls for a particular function."""
    input_key = f"{func.__qualname__}:inputs"
    output_key = f"{func.__qualname__}:outputs"

    inputs = cache._redis.lrange(input_key, 0, -1)
    outputs = cache._redis.lrange(output_key, 0, -1)

    print(f"{func.__qualname__} was called {len(inputs)} times:")
    for args, result in zip(inputs, outputs):
        print(f"{func.__qualname__ + args.decode()} -> {result.decode()}")
