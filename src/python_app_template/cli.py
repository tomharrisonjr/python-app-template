"""CLI for the python_app_template package"""
import argparse

import requests


def main(argv=None) -> int:
    """
    Parse name and print greeting

    Args:
        argv: The arguments to parse. Expects a name to greet.
    """
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--name",
        help="The name of your github account, to greet and count repos for",
        default="world",
    )
    args = parser.parse_args(argv)
    if (args.name) == "":
        print("Username cannot be empty")
        return 1

    print(f"Hello {args.name}!")

    gh_api_uri = f"https://api.github.com/users/{args.name}/repos"
    repos = requests.get(gh_api_uri)
    if repos.status_code != 200:
        print(f"Couldn't fetch your repos from {gh_api_uri}, but that's ok.")
        return 1

    repos = repos.json()
    print(f"Your github account has {len(repos)} repos.")  # type: ignore
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
