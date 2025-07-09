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
String sql = "SELECT v.*, r.nome_rota, ve.nome_veiculo " +
             "FROM viagem v " +
             "JOIN rotas r ON v.id_rota = r.id_rota " +
             "JOIN veiculos ve ON v.id_veiculo = ve.id_veiculo " +
             "ORDER BY v.data DESC, v.hora_partida DESC";

Statement stmt = conn.createStatement();
ResultSet result = stmt.executeQuery(sql);
session.removeAttribute("id_viagem");
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Editar de Viagens - FelixBus</title>
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
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="voltar.jsp">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">

                <li class="nav-item">
                    <a class="nav-link" href="gestao_viagens.jsp">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
               
            </ul>
        </div>
    </div>
</nav>
<br>
<div class="container">
<h1>Editar de Viagens</h1>


<table class="table">
    <thead>
        <tr>
            <th>Rota</th>
            <th>Veículo</th>
            <th>Data</th>
            <th>Hora de Partida</th>
            <th>Hora de Chegada</th>
            <th>Vagas</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <%
        boolean hasResults = false;
        while (result.next()) {
            if (result.getInt("estado_viagem") == 1) {
                hasResults = true;
                session.setAttribute("id_viagem", result.getInt("id_viagem"));
        %>
                <tr>
                    <td><%= result.getString("nome_rota").replace("<", "&lt;").replace(">", "&gt;") %></td>
                    <td><%= result.getString("nome_veiculo").replace("<", "&lt;").replace(">", "&gt;") %></td>
                    <td><%= result.getString("data").replace("<", "&lt;").replace(">", "&gt;") %></td>
                    <td><%= result.getString("hora_partida").replace("<", "&lt;").replace(">", "&gt;") %></td>
                    <td><%= result.getString("hora_chegada").replace("<", "&lt;").replace(">", "&gt;") %></td>
                    <td><%= result.getString("vagas").replace("<", "&lt;").replace(">", "&gt;") %></td>
                    <td>
                        <form action="processa_editar_viagens.jsp" method="POST">
                            <input type="hidden" name="id_viagem" value="<%= result.getInt("id_viagem") %>">
                            <button type="submit" class="btn btn-primary">Editar</button>
                        </form>
                    </td>
                </tr>
        <%
            }
        }
        if (!hasResults) {
        %>
            <tr><td colspan="6">Nenhuma viagem encontrada.</td></tr>
        <%
        }
        %>
    </tbody>
</table>
</div>
</body>
</html>
