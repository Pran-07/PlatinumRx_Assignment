"""
02_Remove_Duplicates.py
-----------------------
Remove duplicate characters from a string using a loop,
preserving the first occurrence of each character.

Examples:
    "programming"  →  "progamin"
    "aabbcc"       →  "abc"
    "hello world"  →  "helo wrd"
"""


def remove_duplicates(input_string: str) -> str:
    """
    Return a new string with duplicate characters removed.
    Uses an explicit loop (no set/dict comprehension shortcuts).
    Preserves the order of first occurrences.
    """
    result = ""                                # will build the unique string here

    for char in input_string:                  # iterate every character
        if char not in result:                 # seen before? skip it
            result = result + char             # first time seen → keep it

    return result


# ── Demo / test ─────────────────────────────────────────────────────────────
if __name__ == "__main__":
    test_cases = [
        "programming",
        "aabbcc",
        "hello world",
        "mississippi",
        "abcabc",
        "112233",
        "",                   # edge case: empty string
        "a",                  # edge case: single character
    ]

    print("Input String       →  Unique String")
    print("-" * 45)
    for s in test_cases:
        print(f"  {repr(s):<20} →  {repr(remove_duplicates(s))}")

    # Interactive mode
    print()
    user_input = input("Enter a string to remove duplicates (or press Enter to skip): ")
    if user_input:
        print(f"Result: {repr(remove_duplicates(user_input))}")
