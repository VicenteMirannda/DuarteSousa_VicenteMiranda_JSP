<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de administrador (3)
  if(session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(3)){
    response.sendRedirect("voltar.jsp");
    return;
  }

  Integer id = (Integer) session.getAttribute("id_utilizador");

  if ("POST".equals(request.getMethod()) &&
      request.getParameter("utilizador") != null &&
      request.getParameter("email") != null &&
      request.getParameter("data_nasc") != null) {

    String novoNome = request.getParameter("utilizador");
    String email = request.getParameter("email");
    String dataNasc = request.getParameter("data_nasc");

    // Atualizar dados básicos
    PreparedStatement stmt1 = conn.prepareStatement("UPDATE utilizadores SET nome_utilizador=?, email=?, data_nasc=? WHERE id_utilizador=?");
    stmt1.setString(1, novoNome);
    stmt1.setString(2, email);
    stmt1.setString(3, dataNasc);
    stmt1.setInt(4, id);
    boolean res = stmt1.executeUpdate() > 0;
    stmt1.close();

    // Atualizar password se fornecida
    String password = request.getParameter("password");
    if(password != null && !password.trim().isEmpty()){
        String novaPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        PreparedStatement stmt2 = conn.prepareStatement("UPDATE utilizadores SET password=? WHERE id_utilizador=?");
        stmt2.setString(1, novaPassword);
        stmt2.setInt(2, id);
        stmt2.executeUpdate();
        stmt2.close();
    }

    if(res){
        out.println("Administrador editado com sucesso!");
        response.setHeader("refresh", "2");
    }
    else{
        out.println("Erro ao editar Administrador!");
    }
  }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Dados Pessoais Admin - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <style>
       body {
            background-color: #f8f9fa;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .form-container {
            max-width: 600px;
            width: 100%;
            margin: 20px auto;
            padding: 30px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .form-title {
            text-align: center;
            margin-bottom: 25px;
            color: #343a40;
        }
        .btn-submit {
            width: 100%;
            padding: 10px;
            font-weight: 500;
        }
        .content-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            padding: 20px 0;
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
                    <a class="nav-link" href="voltar.jsp">Voltar</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
            </ul>
          </div>
        </div>
      </nav>


<%
    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM utilizadores WHERE id_utilizador = ?");
    stmt.setInt(1, id);
    ResultSet result = stmt.executeQuery();

    if (result.next()) {
        int idUtilizador = result.getInt("id_utilizador");
        String nomeUtilizador = result.getString("nome_utilizador");
        String emailUtilizador = result.getString("email");
        String dataNasc = result.getString("data_nasc");
        int nivelAcesso = result.getInt("nivel_acesso");
%>
            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 3%;">

            <form action = "dados_pessoais.jsp" method = "POST">
            <div class="mb-3">
                <label for="id_utilizador" class="form-label">ID_Utilizador</label>
                <input type="text" class="form-control" id="id_utilizador" name="id_utilizador" value="<%= idUtilizador %>" readonly>
              </div>
              <div class="mb-3">
                <label for="utilizador" class="form-label">Utilizador</label>
                <input type="text" class="form-control" id="utilizador" name="utilizador" value="<%= nomeUtilizador != null ? nomeUtilizador : "" %>" required>
              </div>
              <div class="mb-3">
                <label for="idade" class="form-label">Email</label>
                <input type="text" class="form-control" id="email" name="email" value="<%= emailUtilizador != null ? emailUtilizador : "" %>" required>
              </div>
              <div class="mb-3">
                <label for="data_nasc" class="form-label">Data Nascimento</label>
                <input type="date" class="form-control" id="data_nasc" name="data_nasc" value="<%= dataNasc != null ? dataNasc : "" %>" required>
              </div>
              <div class="mb-3">
                  <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" value="" placeholder="Nova password (deixe em branco para não alterar)">
              </div>
              <div class="mb-3">
                <label for="id_utilizador" class="form-label">Nivel de Acesso</label>
                <input type="text" class="form-control" id="nivel de Acesso" name="nivel de Acesso" value="<%= nivelAcesso %>" readonly>
              </div>

              <button type="submit" class="btn btn-primary">Editar</button>
            </form>
          </div>

<%
    }
    result.close();
    stmt.close();
%>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
