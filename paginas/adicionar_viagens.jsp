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
    
    int id_rota = Integer.parseInt(request.getParameter("id_rota"));
    int id_veiculo = Integer.parseInt(request.getParameter("id_veiculo"));
    String data = request.getParameter("data");
    String hora_partida = request.getParameter("hora_partida");
    String hora_chegada = request.getParameter("hora_chegada");
    int vagas = Integer.parseInt(request.getParameter("vagas"));

    String sql = "INSERT INTO viagem (id_rota, id_veiculo, data, hora_partida, hora_chegada, vagas, estado_viagem) " +
                 "VALUES (" + id_rota + ", " + id_veiculo + ", '" + data + "', '" + hora_partida + "', '" + hora_chegada + "', " + vagas + ", 1)";

    try {
        Statement stmt = conn.createStatement();
        stmt.executeUpdate(sql);
        out.println("<div style='padding:20px;'><h3>Viagem adicionada com sucesso!</h3>");
    } catch (SQLException e) {
        out.println("<p>Erro ao adicionar viagem: " + e.getMessage() + "</p>");
    }
}
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
        .content-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        h1 {
            text-align: center;
            margin-bottom: 25px;
            font-size: 24px;
        }
        .btn-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
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

<div class="content-container">
    <h1>Adicionar Viagem</h1>

    <form method="POST" action="adicionar_viagens.jsp">
        <div class="mb-3">
            <label class="form-label">Rota:</label>
            <select name="id_rota" class="form-select" required>
                <%
                Statement stmtRotas = conn.createStatement();
                ResultSet rotas = stmtRotas.executeQuery("SELECT id_rota, nome_rota FROM rotas");
                while (rotas.next()) {
                    out.println("<option value='" + rotas.getInt("id_rota") + "'>" + rotas.getString("nome_rota") + "</option>");
                }
                rotas.close();
                stmtRotas.close();
                %>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Veículo:</label>
            <select name="id_veiculo" class="form-select" required>
                <%
                Statement stmtVeiculos = conn.createStatement();
                ResultSet veiculos = stmtVeiculos.executeQuery("SELECT id_veiculo, nome_veiculo FROM veiculos");
                while (veiculos.next()) {
                    out.println("<option value='" + veiculos.getInt("id_veiculo") + "'>" + veiculos.getString("nome_veiculo") + "</option>");
                }
                veiculos.close();
                stmtVeiculos.close();
                %>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Data:</label>
            <input type="date" name="data" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Hora de Partida:</label>
            <input type="time" name="hora_partida" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Hora de Chegada:</label>
            <input type="time" name="hora_chegada" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Número de Vagas:</label>
            <input type="number" name="vagas" class="form-control" required>
        </div>

        <div class="btn-container">
            <a href="gestao_viagens.jsp" class="btn btn-secondary">Voltar</a>
            <button type="submit" class="btn btn-success">Adicionar Viagem</button>
        </div>
    </form>
</div>

</body>
</html>
