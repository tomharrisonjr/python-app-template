"""
Provides several sample functions for testing the docstrings
"""


def foo(a: int, b: int) -> int:
    """
    Adds two numbers together

    Examples:
        >>> foo(a=1, b=2)
        3
        >>> foo(b=2, a=13)
        15


    Args:
        a: The first number to add
        b: The second number to add

    Returns:
        The sum of a and b
    """
    return a + b


def bar(name: str = "Mysterious Person") -> str:
    """
    Say hello to the user.

    Args:
        name: The name of the person to greet

    Returns:
        A string with a greeting
    """
    return f"Hello {name}!"
