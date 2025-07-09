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
// Obter ID da viagem da sessão ou do parâmetro POST
Integer id_viagem = null;
if (request.getParameter("id_viagem") != null) {
    id_viagem = Integer.parseInt(request.getParameter("id_viagem"));
    session.setAttribute("id_viagem", id_viagem);
} else {
    id_viagem = (Integer) session.getAttribute("id_viagem");
}

// Buscar dados da viagem
String sql2 = "SELECT * FROM viagem WHERE id_viagem = " + id_viagem;
Statement stmt2 = conn.createStatement();
ResultSet result2 = stmt2.executeQuery(sql2);
result2.next();

String mensagem = null;
String erro = null;

// Processar formulário se for POST
if ("POST".equals(request.getMethod()) && 
    request.getParameter("id_rota") != null && 
    request.getParameter("id_veiculo") != null && 
    request.getParameter("data") != null && 
    request.getParameter("hora_partida") != null && 
    request.getParameter("hora_chegada") != null && 
    request.getParameter("vagas") != null) {
    
    String id_rota = request.getParameter("id_rota");
    String id_veiculo = request.getParameter("id_veiculo");
    String data = request.getParameter("data");
    String hora_partida = request.getParameter("hora_partida");
    String hora_chegada = request.getParameter("hora_chegada");
    String vagas = request.getParameter("vagas");
    
    String sql = "UPDATE viagem " +
                 "SET id_rota = " + id_rota + ", id_veiculo = " + id_veiculo + ", data = '" + data + "', " +
                 "hora_partida = '" + hora_partida + "', hora_chegada = '" + hora_chegada + "', vagas = " + vagas + " " +
                 "WHERE id_viagem = " + id_viagem;
    
    try {
        Statement stmt = conn.createStatement();
        int rowsAffected = stmt.executeUpdate(sql);
        
        if (rowsAffected > 0) {
            mensagem = "Viagem atualizada com sucesso!";
            
            if (!hora_partida.equals(result2.getString("hora_partida")) ||
                !hora_chegada.equals(result2.getString("hora_chegada"))) {
                response.sendRedirect("alterar_hora.jsp");
                return;
            }
            
            response.sendRedirect("editar_viagens.jsp");
            session.removeAttribute("id_viagem");
            return;
        } else {
            erro = "Erro ao atualizar viagem";
        }
    } catch (SQLException e) {
        erro = "Erro ao atualizar: " + e.getMessage();
    }
}
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
                    <a class="nav-link" href="editar_viagens.jsp">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
               
            </ul>
        </div>
    </div>
</nav>



<div class="container">
    <br>
<h1>Editar Viagem</h1>
<br>
<form method="POST" action="">



    <div class="mb-3">
        <label>Rota:</label>
        <select name="id_rota" class="form-control" required>
            <%
            Statement stmtRotas = conn.createStatement();
            ResultSet rotas = stmtRotas.executeQuery("SELECT id_rota, nome_rota FROM rotas");
            while (rotas.next()) {
                String selected = rotas.getInt("id_rota") == result2.getInt("id_rota") ? "selected" : "";
                out.println("<option value='" + rotas.getInt("id_rota") + "' " + selected + ">" + rotas.getString("nome_rota") + "</option>");
            }
            rotas.close();
            stmtRotas.close();
            %>
        </select>
    </div>

    <div class="mb-3">
        <label>Veículo:</label>
        <select name="id_veiculo" class="form-control" required>
            <%
            Statement stmtVeiculos = conn.createStatement();
            ResultSet veiculos = stmtVeiculos.executeQuery("SELECT id_veiculo, nome_veiculo FROM veiculos");
            while (veiculos.next()) {
                String selected = veiculos.getInt("id_veiculo") == result2.getInt("id_veiculo") ? "selected" : "";
                out.println("<option value='" + veiculos.getInt("id_veiculo") + "' " + selected + ">" + veiculos.getString("nome_veiculo") + "</option>");
            }
            veiculos.close();
            stmtVeiculos.close();
            %>
        </select>
    </div>

    <div class="mb-3">
        <label>Data:</label>
        <input type="date" name="data" class="form-control" value="<%= result2.getString("data") %>" required>
    </div>

    <div class="mb-3">
        <label>Hora de Partida:</label>
        <input type="time" name="hora_partida" class="form-control" value="<%= result2.getString("hora_partida") %>" required>
    </div>

    <div class="mb-3">
        <label>Hora de Chegada:</label>
        <input type="time" name="hora_chegada" class="form-control" value="<%= result2.getString("hora_chegada") %>" required>
    </div>

    <div class="mb-3">
        <label>Vagas:</label>
        <input type="number" name="vagas" class="form-control" value="<%= result2.getString("vagas") %>" required>
    </div>


    <button type="submit" class="btn btn-primary">Guardar Alterações</button>
    
</form>
        </div>
</body>
</html>
