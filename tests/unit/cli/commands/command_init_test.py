"""command_init_test
"""
from nwa.cli.commands import COMMANDS


def test_commands():
    """test_commands
    """
    assert [C().name for C in COMMANDS] == [
        "controllability",
        "intervention",
        "network",
        "outcome",
        "xcs",
    ]
