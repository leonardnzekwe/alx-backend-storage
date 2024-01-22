#!/usr/bin/env python3
"""11-schools_by_topic Module"""


def schools_by_topic(mongo_collection, topic):
    """
    Returns the list of schools having a specific topic.
    """
    return mongo_collection.find({"topics": topic})
