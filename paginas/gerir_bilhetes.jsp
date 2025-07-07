<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de cliente (1) ou funcionário (2)
  Integer nivel = (Integer) session.getAttribute("nivel");
  if(nivel == null || (nivel != 1 && nivel != 2)){
    response.sendRedirect("voltar.jsp");
    return;
  }

  Integer idUtilizador = (Integer) session.getAttribute("id_utilizador");

  // Buscar os bilhetes do utilizador
  PreparedStatement stmt = conn.prepareStatement("SELECT * FROM bilhete WHERE id_utilizador = ?");
  stmt.setInt(1, idUtilizador);
  ResultSet result = stmt.executeQuery();
%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <title>Gerir Bilhetes - FelixBus</title>
  <link href="bootstrap.min.css" rel="stylesheet">
<style>
  .top-button {
    margin: 30px 0;
    text-align: center;
  }

  .divider {
    border-top: 2px solid #ddd;
    margin-bottom: 30px;
  }

  .bilhete-card {
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    padding: 20px 25px;
    margin-bottom: 25px;
    transition: transform 0.2s ease;
  }

  .bilhete-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
  }

  .bilhete-card h5 {
    font-weight: 700;
    color:rgb(0, 0, 0);
    margin-bottom: 10px;
  }

  .bilhete-card p {
    font-size: 1.1rem;
    color: #333;
    margin-bottom: 15px;
  }

  .bilhete-card .btn {
    margin-right: 10px;
    min-width: 90px;
    font-weight: 600;
    border-radius: 6px;
  }

  .bilhete-card .btn-warning {
    background-color: #ffc107;
    border-color: #ffc107;
  }

  .bilhete-card .btn-warning:hover {
    background-color: #e0a800;
    border-color: #d39e00;
  }

  .bilhete-card .btn-danger {
    background-color: #dc3545;
    border-color: #dc3545;
  }

  .bilhete-card .btn-danger:hover {
    background-color: #bb2d3b;
    border-color: #b02a37;
  }
</style>

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

  <!-- Botão Adicionar Bilhete -->
  <div class="top-button">
    <a href="comprar_bilhete.jsp" class="btn btn-primary btn-lg">Comprar Bilhete</a>
  </div>

  <div class="divider"></div>

  <!-- Lista de Bilhetes -->
  <%
  boolean hasBilhetes = false;
  while (result.next()) {
    hasBilhetes = true;
    int idBilhete = result.getInt("id_bilhete");
    String cidadeDestino = result.getString("cidade_destino");
    String dataViagem = result.getString("data_viagem");
    String hora = result.getString("hora");

    // Escapar HTML para segurança
    if (cidadeDestino != null) cidadeDestino = cidadeDestino.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    if (dataViagem != null) dataViagem = dataViagem.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    if (hora != null) hora = hora.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

    out.print("<div class=\"bilhete-card\">");
    out.print("<h5><strong>Destino:</strong> " + (cidadeDestino != null ? cidadeDestino : "") + "</h5>");
    out.print("<p><strong>Data:</strong> " + (dataViagem != null ? dataViagem : "") + "</p>");
    out.print("<p><strong>Hora de partida:</strong> " + (hora != null ? hora : "") + "</p>");
    out.print("<div class=\"mt-3\">");
    out.print("<a href=\"alterar_bilhete.jsp?id=" + idBilhete + "\" class=\"btn btn-warning btn-sm\">Alterar</a>");
    out.print("<a href=\"anular_bilhete.jsp?id=" + idBilhete + "\" class=\"btn btn-danger btn-sm\" onclick=\"return confirm('Tem a certeza que quer anular este bilhete?')\">Anular</a>");
    out.print("</div>");
    out.print("</div>");
  }

  if (!hasBilhetes) {
    out.print("<div class=\"alert alert-info text-center\">Não tem bilhetes registados.</div>");
  }

  result.close();
  stmt.close();
  %>

</div>
<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
