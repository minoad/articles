"""
Scans plat documents and stores the resulting data
"""

import logging
import pathlib
from pathlib import Path

import click

logging.basicConfig(
    filename="project_name.log",
    encoding="utf-8",
    level=logging.INFO,
    format="%(asctime)s %(levelname)-8s %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)


@click.command()
@click.option("--count", default=1, help="Number of greetings.")
@click.option("--name", prompt="Your name", help="The person to greet.")
def hello(count, name):
    """Simple program that greets NAME for a total of COUNT times."""
    for x in range(count):
        click.echo(f"Hello {name} {x}!")


# add file or folder detection
# TODO: Output to database
def main() -> int:
    """
    Entry point of the program.
    This function iterates over the directories and files in the PLAT_DIR
    directory.
    It collects all the file paths and returns 0.
    Returns:
        int: The exit code of the program.
    """
    return 0


if __name__ == "__main__":
    print("begin")
    sys.exit(main())
