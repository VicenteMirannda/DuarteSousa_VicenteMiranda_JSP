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
%>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <title>Comprar Bilhete - FelixBus</title>
  <link href="bootstrap.min.css" rel="stylesheet">
  <style>
    .form-container {
      max-width: 500px;
      background: #ffffff;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      margin-top: 50px;
    }

    .top-title {
      margin-top: 40px;
      text-align: center;
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

<!-- Conteúdo -->
<div class="container d-flex justify-content-center">
  <div class="form-container">
    <h3 class="text-center mb-4">Comprar Bilhete</h3>

    <%
    String erro = (String) request.getAttribute("erro");
    if (erro != null) {
    %>
      <div class="alert alert-danger"><%= erro %></div>
    <%
    }
    %>

    <form method="post" action="processa_bilhete.jsp">

      <div class="mb-3">
        <label for="Origem" class="form-label">Origem</label>
        <input type="text" class="form-control" id="origem" name="origem" required>
      </div>
      <div class="mb-3">
        <label for="destino" class="form-label">Destino</label>
        <input type="text" class="form-control" id="destino" name="destino" required>
      </div>
      <div class="mb-3">
        <label for="data_viagem" class="form-label">Data da Viagem</label>
        <input type="date" class="form-control" id="data_viagem" name="data_viagem" required>
      </div>
      
      <button type="submit" class="btn btn-success w-100">Comprar</button>
    </form>
  </div>
</div>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
