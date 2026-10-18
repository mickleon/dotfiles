#!/usr/bin/env python3

import glob
import os
import re
import shutil

path = os.path.expanduser('~/.local/share/evolution/categories.xml')
shutil.copy(path, path + '.bak')
xml = open(path, encoding='utf-8').read()

found = set()
for db in glob.glob(os.path.expanduser('~/.cache/evolution/tasks/*/cache.db')):
    data = open(db, 'rb').read().decode('utf-8', 'ignore')
    for m in re.finditer(r'^CATEGORIES[^:\r\n]*:([^\r\n]*)', data, re.M):
        found.update(c.strip() for c in m.group(1).split(',') if c.strip())

new = [
    c for c in sorted(found) if f'a="{c}" default="1" searchable="1"' not in xml
]
entries = ''.join(f'  <category a="{c}"/>\n' for c in new)
xml = xml.replace('</categories>', entries + '</categories>')
open(path, 'w', encoding='utf-8').write(xml)
print('Добавлено:', new)
