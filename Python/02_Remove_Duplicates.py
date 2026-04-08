def remove_duplicates(input_string: str) -> str:
    """
    Return a new string with duplicate characters removed.
    Uses an explicit loop (no set/dict comprehension shortcuts).
    Preserves the order of first occurrences.
    """
    result = ""                                

    for char in input_string:                  
        if char not in result:                 
            result = result + char             

    return result

if __name__ == "__main__":
    test_cases = [
        "programming",
        "aabbcc",
        "hello world",
        "mississippi",
        "abcabc",
        "112233",
        "",                   
        "a",                  
    ]

    print("Input String       →  Unique String")
    print("-" * 45)
    for s in test_cases:
        print(f"  {repr(s):<20} →  {repr(remove_duplicates(s))}")

    print()
    user_input = input("Enter a string to remove duplicates (or press Enter to skip): ")
    if user_input:
        print(f"Result: {repr(remove_duplicates(user_input))}")
