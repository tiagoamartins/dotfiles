#!/usr/bin/env python

import re

from .. import buffer, whitespaces


function_re = re.compile(r'^def ')
method_re = re.compile(r'^\s+def ')
class_re = re.compile(r'^class ')


def ensure_newlines(text, cursor):
    x, prev_line = buffer.get_prev_nonempty_line(text, cursor[0])
    if prev_line <= 0:
        return
    line_number, _ = cursor
    line = text[line_number]
    if function_re.match(line):
        whitespaces.ensure_newlines(text, (line_number, 0), 2)
    if method_re.match(line):
        whitespaces.ensure_newlines(text, (line_number, 0), 1)
    if class_re.match(line):
        whitespaces.ensure_newlines(text, (line_number, 0), 2)


def ensure_newlines_after(text, cursor):
    x, line_number = buffer.get_next_nonempty_line(text, cursor[0])
    if line_number <= 0:
        return
    else:
        ensure_newlines(text, (line_number, 0))
