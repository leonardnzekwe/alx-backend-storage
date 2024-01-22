#!/usr/bin/env python3
"""10-update_topics Module"""


def update_topics(mongo_collection, name, topics):
    """
    Changes all topics of a school document based on the name.
    """
    filter_query = {"name": name}
    update_query = {"$set": {"topics": topics}}
    return mongo_collection.update_many(filter_query, update_query)
