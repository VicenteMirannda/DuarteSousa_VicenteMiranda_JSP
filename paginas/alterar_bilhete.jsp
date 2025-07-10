<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// Verificar se a sessão existe e se o nível é 1 ou 2
Integer nivel = (Integer) session.getAttribute("nivel");
if (nivel == null || (nivel != 1 && nivel != 2)) {
    response.sendRedirect("voltar.jsp");
    return;
}
%>
<%@ include file="../basedados/basedados.h" %>

<%
String id_bilhete = request.getParameter("id");

if (id_bilhete == null || id_bilhete.isEmpty()) {
    out.println("<script>alert('ID do bilhete inválido.'); window.location.href='voltar.jsp';</script>");
    return;
}

String sql = "SELECT * FROM bilhete WHERE id_bilhete = " + id_bilhete;
Statement stmt = conn.createStatement();
ResultSet result = stmt.executeQuery(sql);

if (!result.next()) {
    out.println("<script>alert('Bilhete não encontrado.'); window.location.href='voltar.jsp';</script>");
    return;
}

// Armazenar os dados do bilhete em variáveis
int bilhete_id = result.getInt("id_bilhete");
int bilhete_id_viagem = result.getInt("id_viagem");
String bilhete_cidade_origem = result.getString("cidade_origem");
String bilhete_cidade_destino = result.getString("cidade_destino");
String bilhete_data_viagem = result.getString("data_viagem");
String bilhete_hora = result.getString("hora");

// Verificações de null
if (bilhete_cidade_origem == null) bilhete_cidade_origem = "";
if (bilhete_cidade_destino == null) bilhete_cidade_destino = "";
if (bilhete_data_viagem == null) bilhete_data_viagem = "";
if (bilhete_hora == null) bilhete_hora = "";

// Fechar o ResultSet e Statement iniciais
result.close();
stmt.close();
%>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <title>Gerir Bilhetes - FelixBus</title>
  <link href="bootstrap.min.css" rel="stylesheet">

</head>
<body>

<!-- Navbar -->
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

<div class="container">

 

 

  <!-- Lista de Bilhetes -->
  <form action="atualizar_bilhete.jsp" method="post" class="mt-4 mx-auto" style="max-width: 500px;">
    <input type="hidden" name="id_bilhete" value="<%= bilhete_id %>">

    <div class="mb-3">
      <label for="cidade_origem" class="form-label"><strong>Cidade de Origem:</strong></label>
    <select class="form-control" id="cidade_origem" name="cidade_origem" required>
<%
int id_viagem = bilhete_id_viagem;
String cidade_origem_atual = bilhete_cidade_origem;

// Buscar cidades da rota associada à viagem
String sql_cidades = "SELECT c.nome_cidade as nome " +
                     "FROM viagem v " +
                     "JOIN rotas r ON v.id_rota = r.id_rota " +
                     "JOIN rotas_cidade cr ON r.id_rota = cr.id_rota " +
                     "JOIN cidades c ON cr.id_cidade = c.id_cidade " +
                     "WHERE v.id_viagem = " + id_viagem + " " +
                     "ORDER BY cr.num_paragem ASC";

Statement stmt_cidades = conn.createStatement();
ResultSet result_cidades = stmt_cidades.executeQuery(sql_cidades);

boolean hasCidades = false;
while (result_cidades.next()) {
    hasCidades = true;
    String nome_cidade = result_cidades.getString("nome");
    String selected = nome_cidade.equals(cidade_origem_atual) ? "selected" : "";
    out.println("<option value=\"" + nome_cidade.replace("\"", "&quot;") + "\" " + selected + ">" + nome_cidade.replace("<", "&lt;").replace(">", "&gt;") + "</option>");
}

if (!hasCidades) {
    out.println("<option value=\"\">Nenhuma cidade encontrada</option>");
}

result_cidades.close();
stmt_cidades.close();
%>
</select>

    </div>
    <div class="mb-3">
        <label for="cidade_destino" class="form-label"><strong>Cidade de Destino:</strong></label>
        <select class="form-control" id="cidade_destino" name="cidade_destino" required>
            <%
            String cidade_destino_atual = bilhete_cidade_destino;

            // Buscar cidades da rota associada à viagem (mesmo que para origem)
            String sql_cidades_destino = "SELECT c.nome_cidade as nome " +
                                        "FROM viagem v " +
                                        "JOIN rotas r ON v.id_rota = r.id_rota " +
                                        "JOIN rotas_cidade cr ON r.id_rota = cr.id_rota " +
                                        "JOIN cidades c ON cr.id_cidade = c.id_cidade " +
                                        "WHERE v.id_viagem = " + id_viagem + " " +
                                        "ORDER BY cr.num_paragem ASC";

            Statement stmt_cidades_destino = conn.createStatement();
            ResultSet result_cidades_destino = stmt_cidades_destino.executeQuery(sql_cidades_destino);

            boolean hasCidadesDestino = false;
            while (result_cidades_destino.next()) {
                hasCidadesDestino = true;
                String nome_cidade = result_cidades_destino.getString("nome");
                String selected = nome_cidade.equals(cidade_destino_atual) ? "selected" : "";
                out.println("<option value=\"" + nome_cidade.replace("\"", "&quot;") + "\" " + selected + ">" + nome_cidade.replace("<", "&lt;").replace(">", "&gt;") + "</option>");
            }

            if (!hasCidadesDestino) {
                out.println("<option value=\"\">Nenhuma cidade encontrada</option>");
            }

            result_cidades_destino.close();
            stmt_cidades_destino.close();
            %>
        </select>
    </div>
      <div class="mb-3">
        <label for="data_viagem" class="form-label"><strong>Data da Viagem:</strong></label>
        <input type="date" class="form-control" id="data_viagem" name="data_viagem" value="<%= bilhete_data_viagem.replace("\"", "&quot;") %>" required>
      </div>
      <div class="mb-3">
        <label for="hora" class="form-label"><strong>Hora de Partida:</strong></label>
        <input type="time" class="form-control" id="hora" name="hora" value="<%= bilhete_hora.replace("\"", "&quot;") %>" required>
      </div>
      <button type="submit" class="btn btn-primary">Alterar Bilhete</button>
    </form>

</div>
<script src="bootstrap.bundle.min.js"></script>
</body>
</html>