<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de cliente (1) ou funcionário (2)
  Integer nivel = (Integer) session.getAttribute("nivel");
  if(nivel == null || (nivel != 1 && nivel != 2)){
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
        out.println("Dados editados com sucesso!");
        response.setHeader("refresh", "2");
    }
    else{
        out.println("Erro ao editar dados!");
    }
  }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Dados Pessoais - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <style>
        .form-container {
            max-width: 500px;
            margin: 25px auto;
            padding: 25px;
            background-color: #f8f9fa;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
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
%>
            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 11%;">

            <form action = "dados_cli_func.jsp" method = "POST">
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
                <input type="text" class="form-control" id="password" name="password" placeholder="Nova password (deixe em branco para não alterar)" >
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
