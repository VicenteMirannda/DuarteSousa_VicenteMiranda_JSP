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
// Filtros
String rota = request.getParameter("rota");
String veiculo = request.getParameter("veiculo");
String data = request.getParameter("data");
String ordenar = request.getParameter("ordenar");

if (rota == null) rota = "";
if (veiculo == null) veiculo = "";
if (data == null) data = "";
if (ordenar == null) ordenar = "";

String where = "WHERE v.estado_viagem = 1";

if (!rota.isEmpty()) {
    where += " AND r.nome_rota LIKE '%" + rota.replace("'", "''") + "%'";
}
if (!veiculo.isEmpty()) {
    where += " AND ve.nome_veiculo LIKE '%" + veiculo.replace("'", "''") + "%'";
}
if (!data.isEmpty()) {
    where += " AND v.data = '" + data.replace("'", "''") + "'";
}

// Ordenação
String orderBy;
switch (ordenar) {
    case "data":
        orderBy = "ORDER BY v.data DESC";
        break;
    case "hora_partida":
        orderBy = "ORDER BY v.hora_partida DESC";
        break;
    case "vagas":
        orderBy = "ORDER BY v.vagas DESC"; 
        break;
    default:
        orderBy = "ORDER BY v.data DESC, v.hora_partida DESC";
        break;
}

String sql = "SELECT v.*, r.nome_rota, ve.nome_veiculo " +
             "FROM viagem v " +
             "JOIN rotas r ON v.id_rota = r.id_rota " +
             "JOIN veiculos ve ON v.id_veiculo = ve.id_veiculo " +
             where + " " + orderBy;

Statement stmt = conn.createStatement();
ResultSet result = stmt.executeQuery(sql);
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lista de Viagens - FelixBus</title>
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
<h1>Listar Viagens</h1>

<br>
<form method="GET" class="row g-3 mb-4">
    <div class="col-md-3">
        <label for="rota" class="form-label">Rota</label>
        <input type="text" class="form-control" id="rota" name="rota" value="<%= rota.replace("\"", "&quot;") %>">
    </div>
    <div class="col-md-3">
        <label for="veiculo" class="form-label">Veículo</label>
        <input type="text" class="form-control" id="veiculo" name="veiculo" value="<%= veiculo.replace("\"", "&quot;") %>">
    </div>
    <div class="col-md-3">
        <label for="data" class="form-label">Data</label>
        <input type="date" class="form-control" id="data" name="data" value="<%= data.replace("\"", "&quot;") %>">
    </div>
    <div class="col-md-3">
        <label for="ordenar" class="form-label">Ordenar por</label>
        <select class="form-select" name="ordenar">
            <option value="">Padrão</option>
            <option value="data" <%= "data".equals(ordenar) ? "selected" : "" %>>Data</option>
            <option value="hora_partida" <%= "hora_partida".equals(ordenar) ? "selected" : "" %>>Hora de Partida</option>
            <option value="vagas" <%= "vagas".equals(ordenar) ? "selected" : "" %>>Vagas</option>
        </select>
    </div>
    <div class="col-md-12">
        <button type="submit" class="btn btn-primary">Filtrar</button>
        <a href="listar_viagens.jsp" class="btn btn-secondary">Limpar</a>
    </div>
</form>

<br>


<table class="table">
    <thead>
        <tr>
            <th>Rota</th>
            <th>Veículo</th>
            <th>Data</th>
            <th>Hora de Partida</th>
            <th>Hora de Chegada</th>
            <th>Vagas</th>
        </tr>
    </thead>
    <tbody>
        <%
        boolean hasResults = false;
        while (result.next()) {
            if (result.getInt("estado_viagem") == 1) {
                hasResults = true;
        %>
                <tr>
                    <td><%= result.getString("nome_rota").replace("<", "&lt;").replace(">", "&gt;") %></td>
                    <td><%= result.getString("nome_veiculo").replace("<", "&lt;").replace(">", "&gt;") %></td>
                    <td><%= result.getString("data").replace("<", "&lt;").replace(">", "&gt;") %></td>
                    <td><%= result.getString("hora_partida").replace("<", "&lt;").replace(">", "&gt;") %></td>
                    <td><%= result.getString("hora_chegada").replace("<", "&lt;").replace(">", "&gt;") %></td>
                    <td><%= result.getString("vagas").replace("<", "&lt;").replace(">", "&gt;") %></td>
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
