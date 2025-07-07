<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se já existe sessão ativa
  if(session.getAttribute("nivel") != null){
    response.sendRedirect("voltar.jsp");
    return;
  }

  if (request.getParameter("utilizador") != null && request.getParameter("password") != null &&
      request.getParameter("email") != null && request.getParameter("data_nasc") != null) {

      String username = request.getParameter("utilizador");
      String plainPassword = request.getParameter("password");

      // Hash da password usando BCrypt
      String password = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
      String email = request.getParameter("email");
      String dataNasc = request.getParameter("data_nasc");

      // Inserir pedido de registo na tabela 'registo' para aprovação do admin
      PreparedStatement stmt = conn.prepareStatement("INSERT INTO registos (nome_utilizador, password, email, data_nasc) VALUES (?, ?, ?, ?)");
      stmt.setString(1, username);
      stmt.setString(2, password);
      stmt.setString(3, email);
      stmt.setString(4, dataNasc);

      boolean result = stmt.executeUpdate() > 0;
      stmt.close();

      if (result) {
          out.println("O seu pedido de registo foi submetido com sucesso. Aguarde que o administrador o aprove.<br>");
          response.setHeader("refresh", "3; url=voltar.jsp");
          return;
      } else {
          out.println("Ocorreu um erro ao submeter o pedido de registo.");
      }
  }
%>


<!doctype html>
<html lang="pt">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="bootstrap.min.css">
    <title>FelixBus</title>
    <style>

      
      body {
      background-image: url("fundo-reciclado-da-textura-do-papel-branco-papel-de-parede-vintage_118047-8988.avif");
      background-size: cover;
      background-repeat: no-repeat;
    
    }
      img{
        border-radius: 20px;
      }
      .bio-image {
        width: 200px;
        height: 200px;
        object-fit: cover;
      }

      footer{
    padding: 20px;
    text-align: center;
    margin-top: 16.4%;
    font-size: 14px;
    
  }
  footer p{
    color: white;
  }
  
    </style>
  </head>

  <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
          <a class="navbar-brand" href="voltar.jsp">FelixBus</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
            <li class="nav-item">
                    <a class="nav-link" href="horarios.jsp">Horários</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="localizacao.jsp">Localização</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="contactos.jsp">Contactos</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="login.jsp">Login/Registar</a>
                </li>
            </ul>
          </div>
        </div>
      </nav>
     
      <div style="margin-top: 2%;">
        <div class="container">
          <div class="row">

          <!-- login -->
          <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 1%;">
            <h2>Registar</h2>
            <form action = "registar.jsp" method = "POST">
              <div class="mb-3">
                <label for="utilizador" class="form-label">Utilizador</label>
                <input type="text" class="form-control" id="utilizador" name="utilizador" required >
              </div>
              <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
              </div>
              <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required  >
              </div>
              <div class="mb-3">
                <label for="Data Nascimento" class="form-label">Data Nascimento</label>
                <input type="date" class="form-control" id="data_nasc" name="data_nasc" required>
              </div>
             
              <button type="submit" class="btn btn-primary">Registar</button>
            </form>
          </div>
  
          </div>
        </div>
      </div>
      
      

  </body>
</html>