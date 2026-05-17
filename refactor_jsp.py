import os
import re

base_dir = r"c:\Users\dovin\Downloads\Y1S2 SIMS\Y1S2_WD275_SIMS\src\main\webapp\WEB-INF\views"

# Folders mapping to active menu
folder_to_menu = {
    'users': 'users',
    'products': 'products',
    'supplier': 'suppliers',
    'stockin': 'stockin',
    'stockout': 'stockout',
    'customer': 'customers'
}

skip_files = ['login.jsp', 'register.jsp', 'dashboard.jsp']

def process_file(filepath):
    filename = os.path.basename(filepath)
    if filename in skip_files:
        return
    
    # Check if inside layout folder
    if 'layout' in filepath:
        return

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Determine active menu from folder name
    folder_name = os.path.basename(os.path.dirname(filepath))
    active_menu = folder_to_menu.get(folder_name, '')
    
    page_title = filename.replace('.jsp', '').capitalize() + " | " + folder_name.capitalize()

    # Create the include tag
    header_include = f'<jsp:include page="/WEB-INF/views/layout/header.jsp">\n    <jsp:param name="pageTitle" value="{page_title}" />\n    <jsp:param name="activeMenu" value="{active_menu}" />\n</jsp:include>\n'
    footer_include = '<jsp:include page="/WEB-INF/views/layout/footer.jsp" />\n'

    # Try to find the start of HTML and <main class="main">
    # We want to preserve the <%@ page ... %> tags at the top.
    
    # Regex to find everything from <!DOCTYPE html> or <html> up to <main class="main">
    pattern_head = r'(?i)(<!DOCTYPE html>|<html.*?>).*?<main class="main">'
    
    new_content = re.sub(pattern_head, header_include, content, flags=re.DOTALL)
    
    if new_content == content:
        print(f"Warning: Could not match head pattern in {filepath}")
        return

    # Regex to replace from </main> to the end of file
    pattern_foot = r'(?i)</main>\s*</div>\s*</body>\s*</html>'
    new_content = re.sub(pattern_foot, footer_include, new_content, flags=re.DOTALL)

    # Some files might not have </div> between main and body if layout changed
    if new_content == content or "</main>" in new_content.split(footer_include)[-1]:
         # Try a looser foot pattern
         pattern_foot_loose = r'(?i)</main>.*?</html>'
         new_content = re.sub(pattern_foot_loose, footer_include, new_content, flags=re.DOTALL)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print(f"Processed: {filepath}")

for root, dirs, files in os.walk(base_dir):
    for file in files:
        if file.endswith('.jsp'):
            process_file(os.path.join(root, file))

print("Done refactoring.")
