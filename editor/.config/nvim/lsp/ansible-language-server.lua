return {
    cmd = {'ansible-language-server', '--stdio'},
    filetypes = {
        'yaml.ansible',
    },
    root_markers = {
        '.ansible-lint',
        'ansible.cfg',
    },
}
