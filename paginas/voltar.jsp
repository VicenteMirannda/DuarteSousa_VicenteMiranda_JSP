<%
// Get session object
HttpSession userSession = request.getSession(false);

if (userSession != null && userSession.getAttribute("nivel") != null) {
    Integer nivel = (Integer) userSession.getAttribute("nivel");
    
    if (nivel == 1) {
        response.sendRedirect("menucliente.jsp");
    } else if (nivel == 2) {
        response.sendRedirect("menufuncionario.jsp");
    } else if (nivel == 3) {
        response.sendRedirect("menuadmin.jsp");
    } else {
        response.sendRedirect("index.jsp");
    }
} else {
    response.sendRedirect("index.jsp");
}
%>
