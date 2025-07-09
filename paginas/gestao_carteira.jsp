<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador está logado
  if(session.getAttribute("nivel") == null){
    response.sendRedirect("voltar.jsp");
    return;
  }

  double saldo = 0;

  // Verifica se foi enviado um ID via POST, senão usa o da sessão
  int id;
  if ("POST".equals(request.getMethod()) && request.getParameter("id_utilizador") != null) {
      try {
          id = Integer.parseInt(request.getParameter("id_utilizador"));
      } catch (NumberFormatException e) {
          id = (Integer) session.getAttribute("id_utilizador");
      }
  } else {
      id = (Integer) session.getAttribute("id_utilizador");
  }

  // Consulta para obter o saldo do utilizador
  PreparedStatement stmt = conn.prepareStatement("SELECT saldo FROM carteiras WHERE id_utilizador = ?");
  stmt.setInt(1, id);
  ResultSet result = stmt.executeQuery();

  if (result.next()) {
      saldo = result.getDouble("saldo");
  } else {
      // Se não houver saldo, inicializa como 0
      saldo = 0;
  }
  result.close();
  stmt.close();
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gestão da Carteira - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <style>
        /* Estilo opcional para um fundo subtil e transições suaves */
        body {
            background-color: #f4f7f6;
        }
        .card {
            transition: all 0.3s ease;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="voltar.jsp">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="voltar.jsp">❮ Voltar</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="card shadow-lg border-0 rounded-4">
                <div class="card-body p-4 p-md-5">
                    <div class="row align-items-center">
                        <div class="col-md-6 text-center text-md-start mb-4 mb-md-0">
                            <h2 class="h6 text-muted text-uppercase">Saldo Disponível</h2>
                            <p class="display-4 fw-bold text-primary mb-0">€<%= String.format("%.2f", saldo).replace('.', ',') %></p>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="d-grid gap-3">
                                <a href="adicionar_saldo.jsp" class="btn btn-success btn-lg py-3 fw-bold">➕ Adicionar Saldo</a>
                                <a href="levantar_saldo.jsp" class="btn btn-outline-secondary btn-lg py-3">➖ Levantar Saldo</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="container text-center text-muted py-4 mt-auto">
    <p>&copy; <%= new java.util.Date().getYear() + 1900 %> FelixBus. Todos os direitos reservados.</p>
</footer>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>