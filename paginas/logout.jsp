<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // Verificar se existe sessão ativa
  if(session.getAttribute("nivel") == null){
    response.sendRedirect("index.jsp");
    return;
  }
  else{
    // Destruir todas as variáveis de sessão
    session.invalidate();

    // Redirecionar para a página inicial
    response.sendRedirect("index.jsp");
    return;
  }
%>