"""conftest
"""
import json
from pathlib import Path

import pytest  # pylint: disable=E0401


@pytest.fixture()
def url_data():
    """url_data
    """
    filepath = Path(__file__).parent / "fixtures" / "url_data.json"
    if filepath:
        with open(filepath) as file:
            return json.load(file)
    else:
        return {}


@pytest.fixture()
def canonical_urls():
    """canonical_urls
    """
    filepath = Path(__file__).parent / "fixtures" / "canonical_urls.json"
    if filepath:
        with open(filepath) as file:
            return json.load(file)
    else:
        return {}


@pytest.fixture()
def valid_urls():
    """valid_urls
    """
    filepath = Path(__file__).parent / "fixtures" / "valid_urls.json"
    if filepath:
        with open(filepath) as file:
            return json.load(file)
    else:
        return []


@pytest.fixture()
def invalid_urls():
    """invalid_urls
    """
    filepath = Path(__file__).parent / "fixtures" / "invalid_urls.json"
    if filepath:
        with open(filepath) as file:
            return json.load(file)
    else:
        return []
