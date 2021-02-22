#!/usr/bin/env python

import vim

from .cursor import to_vim, to_vim_lang


def get_names(cursor):
    position = to_vim(cursor)
    try:
        syntax_stack = vim.eval('synstack({}, {})'.format(
            *to_vim_lang(position)
        ))
    except SystemError:
        return []

    names = []
    for syn_id in syntax_stack:
        names.append(
            vim.eval('synIDattr(synIDtrans({}), "name")'.format(syn_id))
        )

    return names


def is_string(cursor):
    return 'String' in get_names(cursor)
