<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// Verificar se a sessão existe e se o nível é 3
Integer nivel = (Integer) session.getAttribute("nivel");
if (nivel == null || nivel != 3) {
    response.sendRedirect("voltar.jsp");
    return;
}
%>
<%@ include file="../basedados/basedados.h" %>

<%
// Processar formulário se for POST
if ("POST".equals(request.getMethod())) {
    String descricao = request.getParameter("descricao");
    
    if (descricao != null) {
        Integer id_viagem = (Integer) session.getAttribute("id_viagem");
        
        if (id_viagem != null) {
            String sql = "INSERT INTO alertas (id_rota, id_viagem, descricao, tipo) VALUES (NULL, '" + id_viagem + "', '" + descricao + "', '3')";
            
            try {
                Statement stmt = conn.createStatement();
                int res = stmt.executeUpdate(sql);
                
                if (res > 0) {
                    out.println("Alerta registado com sucesso!");
                    session.removeAttribute("id_viagem");
                    response.setHeader("refresh", "2;url=voltar.jsp");
                } else {
                    out.println("Erro ao registar alerta!");
                    session.removeAttribute("id_viagem");
                    response.setHeader("refresh", "2;url=voltar.jsp");
                }
            } catch (SQLException e) {
                out.println("Erro ao registar alerta!");
                session.removeAttribute("id_viagem");
                response.setHeader("refresh", "2;url=voltar.jsp");
            }
        } else {
            out.println("ID da viagem não encontrado na sessão.");
            session.removeAttribute("id_viagem");
            response.setHeader("refresh", "2;url=voltar.jsp");
        }
    }
}
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Menu Admin - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">

    
    <style>
       body {
            background-color: #f8f9fa;
        }
        .center-buttons {
        min-height: 80vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .btn-menu {
        padding: 15px;
        font-size: 16px;
    }
    </style>    

   
</head>
<body>

<!-- Barra de Navegação -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="voltar.jsp">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">

                <li class="nav-item">
                    <a class="nav-link" href="voltar.jsp">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
               
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2>Alteração de Hora</h2>
    <form action="alterar_hora.jsp" method="POST">
        <div class="mb-3">
            <label for="descricao" class="form-label">Descrição da Alteração</label>
            <textarea class="form-control" id="descricao" name="descricao" rows="4" required></textarea>
        </div>
        <button type="submit" class="btn btn-danger">Criar Alerta</button>
    </form>
</div>

</body>
</html>
