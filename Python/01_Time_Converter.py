def convert_minutes(total_minutes: int) -> str:
    """Return a human-readable string for the given number of minutes."""
    if total_minutes < 0:
        raise ValueError("Minutes cannot be negative.")

    hours = total_minutes // 60     
    remaining_minutes = total_minutes % 60

    if hours == 0:
        return f"{remaining_minutes} minutes"
    elif hours == 1:
        return f"{hours} hr {remaining_minutes} minutes"
    else:
        return f"{hours} hrs {remaining_minutes} minutes"

if __name__ == "__main__":
    test_cases = [130, 110, 60, 45, 0, 200, 59, 120, 1440]

    print("Minutes  →  Human-Readable")
    print("-" * 35)
    for mins in test_cases:
        print(f"  {mins:<7} →  {convert_minutes(mins)}")

    print()
    user_input = input("Enter minutes to convert (or press Enter to skip): ").strip()
    if user_input.isdigit():
        print(f"Result: {convert_minutes(int(user_input))}")
