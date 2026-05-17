import re
with open(r'src\main\webapp\WEB-INF\views\dashboard.jsp', 'r', encoding='utf-8') as f:
    content = f.read()

header = '''<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Dashboard" />
    <jsp:param name="activeMenu" value="dashboard" />
</jsp:include>'''

footer = '<jsp:include page="/WEB-INF/views/layout/footer.jsp" />'

# Replace everything from <!DOCTYPE html> to </header>
content = re.sub(r'(?i)<!DOCTYPE html>.*?</header>', header, content, flags=re.DOTALL)
content = re.sub(r'(?i)</main>\s*</body>\s*</html>', footer, content, flags=re.DOTALL)

with open(r'src\main\webapp\WEB-INF\views\dashboard.jsp', 'w', encoding='utf-8') as f:
    f.write(content)
print('Dashboard refactored.')
