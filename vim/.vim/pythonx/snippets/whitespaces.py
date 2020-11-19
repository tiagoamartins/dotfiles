#!/usr/bin/env python

import re


def ensure_newlines(text, cursor, amount):
    line_number, _ = cursor

    for line in reversed(text[:line_number]):
        if line != '' or amount <= 0:
            break

        amount -= 1
        line_number -= 1

    text[line_number:line_number] = [''] * amount
    return text, line_number, amount


def ensure_indent(text, cursor, indent, expand_tab=True, shift_width=4):
    if expand_tab == '1':
        indent_symbol = ' ' * shift_width
    else:
        indent_symbol = '\t'

    text[cursor[0]] = indent_symbol * indent

    return (cursor[0], len(text[cursor[0]]))


def get_indentation(line):
    indent = len(line) - len(line.lstrip())

    return indent, line[:indent]


def get_higher_indent(text, cursor):
    line_number, _ = cursor

    current_indent, _ = get_indentation(text[line_number])
    for line in reversed(text[:line_number]):
        line_number -= 1
        if line == '':
            continue

        line_indent, _ = get_indentation(line)
        if current_indent > line_indent:
            return (line, line_number)

    return None


def match_higher_indent(text, cursor, pattern):
    line_number, _ = cursor
    while True:
        indent = get_higher_indent(text, (line_number, 0))
        if not indent:
            return

        line, line_number = indent
        if re.search(pattern, line.strip()):
            return indent


def match_exact_indent(text, cursor, amount, pattern, direction=+1):
    line_number, _ = cursor

    line_number += direction

    while 0 <= line_number < len(text):
        line = text[line_number]
        line_indent, _ = get_indentation(line)

        if line_indent == amount:
            if re.search(pattern, line):
                return (line_number, 0)

        line_number += direction

    return None


def match_exact_indent_as_in_line(text, cursor, line, pattern, direction=+1):
    amount = len(get_indentation(line)[1])
    return match_exact_indent(text, cursor, amount, pattern, direction)
