# -*- coding: utf-8 -*-

try:
    import vim
    import datetime
    import re
    import subprocess

except ImportError:
    raise ImportError("Error while importing dependencies")

def projectionQuery (key):
    cmd = "projectionist#query(\"" + key + "\")"
    for query in vim.eval(cmd):
        return query[1]

    return ""

def getGitConfigValue (key):
    return subprocess.getoutput("git config --get \"" + key + "\"")

def getHgConfigValue (key):
    return subprocess.getoutput("hg showconfig " + key)

def snippetAuthor ():
    # Check if the current project is using Hg or not
    if (subprocess.getoutput("hg branch 2> /dev/null")):
        return re.sub('\s*<.*>', '', getHgConfigValue('ui.username'))
    else:
        return getGitConfigValue('user.name')

def snippetProjectAuthor ():
    projectAuthor = getGitConfigValue('project.author')

    if projectAuthor:
        return projectAuthor
    else:
        return snippetAuthor()

def snippetTitle (basename):
    basename = '_'.join(re.findall('.+?(?:(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])|(?<=[a-zA-Z])(?=\d)|(?<=\d)(?=[a-zA-Z])|$)', basename))
    basename = re.sub(r'^.', lambda m: m.group(0).upper(), basename)
    basename = re.sub(r'_(.)', lambda m: ' ' + m.group(1).upper(), basename)

    return basename

def snippetCopyright ():
    projectionCopyright = projectionQuery("copyright")

    if projectionCopyright:
        name = projectionCopyright
    else:
        name = snippetProjectAuthor()

    return ' '.join(['©', datetime.datetime.now().strftime('%Y'), 'by', name])

def snippetProjectTitle():
    projectionTitle = projectionQuery("title")

    if projectionTitle:
        return projectionTitle
    else:
        projectTitle = getGitConfigValue('project.title')

        if projectTitle:
            return projectionTitle
        else:
            return "<Project Name>"
