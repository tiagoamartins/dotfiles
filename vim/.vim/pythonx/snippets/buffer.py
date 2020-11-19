#!/usr/bin/env python


def get_prev_nonempty_line(text, cursor):
    cursor -= 1
    for line in text[:cursor]:
        if line.strip() != '':
            cursor -= 1
        return line, cursor
    return '', 0


def get_next_nonempty_line(text, cursor):
    cursor += 1
    for line in text[cursor:]:
        if line.strip() != '':
            cursor += 1
        return line, cursor
    return '', 0


def insert_lines_before(text, cursor, lines):
    text[cursor[0]:cursor[0]] = lines
