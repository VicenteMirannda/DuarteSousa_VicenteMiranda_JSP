<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Descrição do Alerta - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #e9ecef;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            background: #ffffff;
            margin-top: 40px;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            font-weight: bold;
            color: #343a40;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }

        thead th {
            background-color: #0d6efd;
            color: #fff;
            padding: 12px;
            text-align: center;
            font-size: 18px;
            border-radius: 8px 8px 0 0;
        }

        tbody td {
            padding: 15px;
            text-align: center;
            font-size: 16px;
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }

        tbody tr:hover {
            background-color: #e2e6ea;
        }

        .navbar-brand {
            font-weight: bold;
            letter-spacing: 0.07em;
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
                    <a class="nav-link" href="alertas.jsp">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <h1>Descrição do Alerta</h1>

    <table class="table">
        <thead>
            <tr>
                <th>Descrição</th>
            </tr>
        </thead>
        <tbody>
            <%
                String id_alerta_param = request.getParameter("id_alerta");
                int id_alerta = 0;
                if (id_alerta_param != null) {
                    try {
                        id_alerta = Integer.parseInt(id_alerta_param);
                    } catch (NumberFormatException e) {
                        id_alerta = 0;
                    }
                }
                
                if (id_alerta > 0) {
                    try {
                        String sql = "SELECT * FROM alertas WHERE id_alerta = ?";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, id_alerta);
                        ResultSet result = stmt.executeQuery();

                        while (result.next()) {
            %>
                            <tr>
                                <td><%= result.getString("descricao") != null ? result.getString("descricao") : "" %></td>
                            </tr>
            <%
                        }
                        result.close();
                        stmt.close();
                    } catch (SQLException e) {
                        out.println("Erro ao carregar descrição do alerta: " + e.getMessage());
                    }
                } else {
                    out.println("ID do alerta inválido ou não fornecido.");
                }
            %>
        </tbody>
    </table>
</div>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
