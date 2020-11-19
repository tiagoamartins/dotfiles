#!/usr/bin/env python

import vim

from abc import ABC, abstractmethod


SINGLE_QUOTES = "'"
DOUBLE_QUOTES = '"'


class Argument:
    def __init__(self, arg):
        self.arg = arg
        self.name = arg.split('=')[0].strip()

    def __str__(self):
        return self.name

    def iskwarg(self):
        return '=' in self.arg


class DocsWriter(ABC):
    def __init__(self, snip):
        self.snip = snip

    @abstractmethod
    def format_arg(self, arg):
        raise NotImplementedError

    @abstractmethod
    def write_return(self):
        raise NotImplementedError

    def write_args(self, args):
        for arg in args:
            self.snip += self.format_arg(arg) + ' TODO'


class DoxygenDocsWriter(DocsWriter):
    def format_arg(self, arg):
        return '@param {}'.format(arg)

    def write_return(self):
        self.snip += '@return: TODO'


class GoogleDocsWriter(DocsWriter):
    def format_arg(self, arg):
        return '{} (TODO):'.format(arg)

    def write_return(self):
        self.snip += 'Returns: TODO'

    def write_args(self, args):
        kwargs = [arg for arg in args if arg.iskwarg()]
        args = [arg for arg in args if not arg.iskwarg()]

        if args:
            self.snip += 'Args:'
            self.snip.shift()
            for arg in args:
                self.snip += self.format_arg(arg) + ' TODO'
            self.snip.unshift()

        if kwargs:
            if args:
                self.snip.rv += '\n' + self.snip.mkline('', indent='')
            self.snip += 'Kwargs:'
            self.snip.shift()
            for kwarg in kwargs:
                self.snip += self.format_arg(kwarg) + ' TODO'
            self.snip.unshift()


class NumpyDocsWriter(DocsWriter):
    def format_arg(self, arg):
        return '{} :'.format(arg)

    def write_return(self):
        self.snip += 'Returns'
        self.snip += '-------'
        self.snip += 'TODO'

    def write_args(self, args):
        if args:
            self.snip += 'Parameters'
            self.snip += '----------'

        kwargs = [arg for arg in args if arg.iskwarg()]
        args = [arg for arg in args if not arg.iskwarg()]

        if args:
            for arg in args:
                self.snip += self.format_arg(arg) + ' TODO'
        if kwargs:
            for kwarg in kwargs:
                self.snip += self.format_arg(kwarg) + ' TODO, optional'


class NormalDocsWriter(DocsWriter):
    def format_arg(self, arg):
        return ':{}:'.format(arg)

    def write_return(self):
        self.snip += ':returns: TODO'


class SphinxDocsWriter(NormalDocsWriter):
    def format_arg(self, arg):
        return super().format_arg('param {}'.format(arg))

    def write_return(self):
        self.snip += ':returns:'
        self.snip.shift()
        self.snip += 'TODO'
        self.snip.unshift()
        self.snip += ':rtype: TODO'

    def write_args(self, args):
        for index, arg in enumerate(args):
            if index != 0:
                self.snip.rv += '\n' + self.snip.mkline('', indent='')
            self.snip += self.format_arg(arg)
            self.snip.shift()
            self.snip += 'TODO'
            self.snip.unshift()


class JediDocsWriter(NormalDocsWriter):
    def format_arg(self, arg):
        return super().format_arg('type {}'.format(arg))


def factory_doc_writer(snip):
    style = snip.opt('g:ultisnips_python_style', 'sphinx')

    if style == 'doxygen':
        Writer = DoxygenDocsWriter
    elif style == 'sphinx':
        Writer = SphinxDocsWriter
    elif style == 'google':
        Writer = GoogleDocsWriter
    elif style == 'numpy':
        Writer = NumpyDocsWriter
    elif style == 'jedi':
        Writer = JediDocsWriter
    else:
        Writer = NormalDocsWriter

    return Writer(snip)


def parse_args(arglist):
    args = [Argument(arg) for arg in arglist.split(',') if arg]
    args = [arg for arg in args if arg.name != 'self']

    return args


def get_quoting_style(snip):
    style = snip.opt('g:ultisnips_python_quoting_style', 'single')
    if style == 'single':
        return SINGLE_QUOTES
    return DOUBLE_QUOTES


def triple_quotes(snip):
    style = snip.opt('g:ultisnips_python_triple_quoting_style', 'double')
    if not style:
        return get_quoting_style(snip) * 3
    return (SINGLE_QUOTES if style == 'single' else DOUBLE_QUOTES) * 3


def triple_quotes_handle_trailing(snip, quoting_style):
    """
    Generate triple quoted strings and handle any trailing quote char,
    which might be there from some autoclose/autopair plugin,
    i.e. when expanding ``'|'``.
    """
    if not snip.c:
        # Do this only once, otherwise the following error would happen:
        # RuntimeError: The snippets content did not converge: …
        _, col = vim.current.window.cursor
        line = vim.current.line

        # Handle already existing quote chars after the trigger.
        _ret = quoting_style * 3
        while True:
            try:
                nextc = line[col]
            except IndexError:
                break
            if nextc == quoting_style and len(_ret):
                _ret = _ret[1:]
                col = col + 1
            else:
                break
        snip.rv = _ret
    else:
        snip.rv = snip.c


def write_docstring_args(args, snip):
    if not args:
        snip.rv += ' {0}'.format(triple_quotes(snip))
        return

    snip.rv += '\n' + snip.mkline('', indent='')

    writer = factory_doc_writer(snip)
    writer.write_args(args)


def write_init_body(snip, parents, arg_str):
    snip.rv = ''
    snip >> 2
    if parents:
        snip.rv += 'super().__init__()'

    args = parse_args(arg_str)
    for arg in args:
        snip += 'self.%s = %s' % (arg, arg)


def write_slots_args(args, snip):
    args = ["'_%s'" % arg for arg in args]
    snip += '__slots__ = (%s,)' % ', '.join(args)


def function_docstring(snip, func_name, arg_str):
    """
    Writes a function docstring with the current style.

    :param t: The values of the placeholders
    :param snip: UltiSnips.TextObjects.SnippetUtil object instance
    """
    snip.rv = triple_quotes(snip)
    snip >> 1
    snip += 'TODO: Docstring for {}'.format(func_name)

    args = parse_args(arg_str)
    if args:
        write_docstring_args(args, snip)

    snip.rv += '\n' + snip.mkline('', indent='')

    writer = factory_doc_writer(snip)
    writer.write_return()
    snip += triple_quotes(snip)
