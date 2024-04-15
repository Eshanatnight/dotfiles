#! /usr/bin/env python3
"""
print the content of rem.txt, cheatsheet to stdout
"""


def main():
    """
    entry point for the program
    """
    with open("/Users/kellsatnite/tools/scripts/rem.txt", "r", encoding="utf-8") as f:
        lines = f.readlines()

        for line in lines:
            _line = line.strip()
            print(_line)


if __name__ == "__main__":
    main()
