<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ include file="../basedados/basedados.h" %>
<%
if (session.getAttribute("nivel") != null) {
  response.sendRedirect("voltar.jsp");
  return;
}

if (request.getParameter("user") != null && request.getParameter("pass") != null) {
  String username = request.getParameter("user");
  String password = request.getParameter("pass");

  PreparedStatement stmt = conn.prepareStatement("SELECT * FROM utilizadores WHERE nome_utilizador = ?");
  stmt.setString(1, username);
  ResultSet result = stmt.executeQuery();

  if (result.next()) {
    String storedPassword = result.getString("password");
    int nivelAcesso = result.getInt("nivel_acesso");
    int idUtilizador = result.getInt("id_utilizador");

    // Verificar password usando BCrypt
    boolean passwordMatch = false;
    try {
      // Verificar se a password corresponde ao hash BCrypt armazenado
      passwordMatch = BCrypt.checkpw(password, storedPassword);
    } catch (Exception e) {
      // Fallback para passwords em texto simples (compatibilidade com dados antigos)
      passwordMatch = storedPassword.equals(password);
    }

    if (passwordMatch) {
      session.setAttribute("nivel", nivelAcesso);
      session.setAttribute("id_utilizador", idUtilizador);

      if (nivelAcesso == 1) {
        response.setHeader("refresh", "2; url=menucliente.jsp");
        out.println("<div class='alert alert-success text-center mt-3'>Bem vindo Cliente</div>");
      } else if (nivelAcesso == 2) {
        response.setHeader("refresh", "2; url=menufuncionario.jsp");
        out.println("<div class='alert alert-success text-center mt-3'>Bem vindo Funcionário</div>");
      } else if (nivelAcesso == 3) {
        response.setHeader("refresh", "2; url=menuadmin.jsp");
        out.println("<div class='alert alert-success text-center mt-3'>Bem vindo Administrador</div>");
      }
    } else {
      out.println("<div class='alert alert-danger text-center mt-3'>Utilizador ou senha inválidos</div>");
    }
  } else {
    out.println("<div class='alert alert-danger text-center mt-3'>Utilizador ou senha inválidos</div>");
  }

  result.close();
  stmt.close();
}
%>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Login/Registar - FelixBus</title>
  <link href="bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />

  <style>
    body {
      background: #f8f9fa;
      margin: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }
    .login-container {
      max-width: 420px;
      background: rgba(255, 255, 255, 0.95);
      padding: 30px 40px;
      border-radius: 12px;
      box-shadow: 0 6px 20px rgba(0,0,0,0.1);
      margin: 40px auto;
    }
    .login-container h2 {
      font-weight: 600;
      margin-bottom: 30px;
      color: #212529;
      text-align: center;
    }
    .btn-primary {
      background-color: #0d6efd;
      border: none;
      font-weight: 600;
      transition: background-color 0.3s ease;
    }
    .btn-primary:hover {
      background-color: #0b5ed7;
    }
    a {
      color: #0d6efd;
      font-weight: 600;
      text-decoration: none;
    }
    a:hover {
      color: #0a58ca;
      text-decoration: underline;
    }
    input.form-control {
      padding: 12px 14px;
      font-size: 1rem;
      border-radius: 6px;
    }
  </style>
</head>
<body>

<!-- Navbar original sem alterações -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="voltar.jsp">FelixBus</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="consultar_rotas.jsp">Consultar Rotas</a></li>
        <%
        PreparedStatement stmtAlertas = conn.prepareStatement("SELECT COUNT(*) as total FROM alertas");
        ResultSet resultAlertas = stmtAlertas.executeQuery();
        if (resultAlertas.next()) {
          int total = resultAlertas.getInt("total");
          if (total > 0) {
            out.print("<li class=\"nav-item\">");
            out.print("<a class=\"nav-link text-warning\" href=\"alertas.jsp\">Alertas <i class=\"bi bi-bell-fill\"></i> <span class=\"badge bg-danger\">" + total + "</span></a>");
            out.print("</li>");
          }
        }
        resultAlertas.close();
        stmtAlertas.close();
        %>
        <li class="nav-item"><a class="nav-link" href="localizacao.jsp">Localização</a></li>
        <li class="nav-item"><a class="nav-link" href="contactos.jsp">Contactos</a></li>
        <li class="nav-item"><a class="nav-link active" href="login.jsp">Login/Registar</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Container do login, centralizado com margin auto e espaçamento de 40px do topo -->
<div class="login-container shadow-sm">
  <h2>Login</h2>
  <form action="login.jsp" method="post" autocomplete="off" novalidate>
    <div class="mb-3">
      <label for="user" class="form-label">Utilizador</label>
      <input type="text" class="form-control" id="user" name="user" placeholder="Digite seu utilizador" required>
    </div>
    <div class="mb-4">
      <label for="pass" class="form-label">Senha</label>
      <input type="password" class="form-control" id="pass" name="pass" placeholder="Digite sua senha" required>
    </div>
    <button type="submit" class="btn btn-primary w-100">Login</button>
  </form>

  <p class="text-center mt-3 mb-0">
    Ainda não tem conta? <a href="registar.jsp">Registe-se</a>
  </p>
</div>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
