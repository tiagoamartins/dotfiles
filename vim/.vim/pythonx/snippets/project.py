#!/usr/bin/env python

import vim
import datetime
import re
import subprocess


def projection_query(key):
    cmd = 'projectionist#query(\"' + key + '\")'
    for query in vim.eval(cmd):
        return query[1]

    return ''


def get_git_config_value(key):
    return subprocess.getoutput('git config --get \"' + key + '\"')


def get_hg_config_value(key):
    return subprocess.getoutput('hg showconfig ' + key)


def get_author():
    # Check if the current project is using Hg or not
    if (subprocess.getoutput('hg branch 2> /dev/null')):
        return re.sub('\\s*<.*>', '', get_hg_config_value('ui.username'))
    else:
        return get_git_config_value('user.name')


def get_project_author():
    project_author = get_git_config_value('project.author')

    if project_author:
        return project_author
    else:
        return get_author()


def get_title(basename):
    title_regex = '.+?(?:(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])' \
                  '|(?<=[a-zA-Z])(?=\\d)|(?<=\\d)(?=[a-zA-Z])|$)'
    basename = '_'.join(re.findall(title_regex, basename))
    basename = re.sub(r'^.', lambda m: m.group(0).upper(), basename)
    basename = re.sub(r'_(.)', lambda m: ' ' + m.group(1).upper(), basename)

    return basename


def get_copyright():
    projection_copyright = projection_query('copyright')

    if projection_copyright:
        name = projection_copyright
    else:
        name = get_project_author()

    return ' '.join(['©', datetime.datetime.now().strftime('%Y'), 'by', name])


def get_project_title():
    projection_title = projection_query('title')

    if projection_title:
        return projection_title
    else:
        project_title = get_git_config_value('project.title')

        if project_title:
            return projection_title
        else:
            return '<Project Name>'
