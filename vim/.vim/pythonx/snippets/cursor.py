#!/usr/bin/env python


def to_vim(cursor):
    return (cursor[0] + 1, cursor[1])


def to_vim_lang(cursor):
    return (cursor[0] + 1, cursor[1] + 1)
