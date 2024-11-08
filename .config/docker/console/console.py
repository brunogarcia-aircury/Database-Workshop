import cmd
from colorama import Fore, Style, init

class MyConsole(cmd.Cmd):
    intro = f"\n{Fore.CYAN}Welcome to Database Expertise Console! Type help or ? to list commands.{Style.RESET_ALL}\n"
    prompt = "(myconsole) "

    def do_greet(self, person):
        """Greet a person: GREET <name>"""
        if person:
            print(f"Hello, {person}!")
        else:
            print("Hello!")

    def do_add(self, line):
        """Add two numbers: ADD <num1> <num2>"""
        try:
            numbers = line.split()
            num1, num2 = float(numbers[0]), float(numbers[1])
            print(f"The result is: {num1 + num2}")
        except (IndexError, ValueError):
            print("Please provide two numbers.")

    def do_exit(self, line):
        """Exit the console"""
        print("Goodbye!")
        return True  # Returning True exits the console

if __name__ == '__main__':
    MyConsole().cmdloop()
