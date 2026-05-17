
import os
import glob
files = glob.glob('**/*.jsp', recursive=True)
count = 0
for f in files:
    if 'layout' in f or 'dashboard.jsp' in f:
        continue
    with open(f, 'r', encoding='utf-8') as file:
        content = file.read()
    if '<header class="topbar">' in content:
        content = content.replace('<header class="topbar">', '<header class="page-header">')
        with open(f, 'w', encoding='utf-8') as file:
            file.write(content)
        count += 1
print('Updated', count, 'files')

