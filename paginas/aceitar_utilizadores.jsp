<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de administrador (3)
  if(session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(3)){
    response.sendRedirect("voltar.jsp");
    return;
  }

  // Processar aceitação de utilizador
  if("POST".equals(request.getMethod()) && request.getParameter("id_utilizador") != null) {
    // Obter o utilizador da tabela registos
    int idRegisto = Integer.parseInt(request.getParameter("id_utilizador"));

    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM registos WHERE id_registo = ?");
    stmt.setInt(1, idRegisto);
    ResultSet res = stmt.executeQuery();

    if (res.next()) {
        // Obter dados do registo
        String nome = res.getString("nome_utilizador");
        String email = res.getString("email");
        String dataNasc = res.getString("data_nasc");
        String password = res.getString("password");

        // Inserir na tabela utilizadores
        PreparedStatement stmtInsert = conn.prepareStatement("INSERT INTO utilizadores (nome_utilizador, email, data_nasc, password, nivel_acesso) VALUES (?, ?, ?, ?, 1)", java.sql.Statement.RETURN_GENERATED_KEYS);
        stmtInsert.setString(1, nome);
        stmtInsert.setString(2, email);
        stmtInsert.setString(3, dataNasc);
        stmtInsert.setString(4, password);

        boolean insertSuccess = stmtInsert.executeUpdate() > 0;

        if (insertSuccess) {
            // Obter o ID do utilizador recém-criado
            ResultSet generatedKeys = stmtInsert.getGeneratedKeys();
            int idUtilizador = 0;
            if (generatedKeys.next()) {
                idUtilizador = generatedKeys.getInt(1);
            }
            generatedKeys.close();

            // Criar carteira com saldo 0
            PreparedStatement stmtCarteira = conn.prepareStatement("INSERT INTO carteiras (id_utilizador, saldo) VALUES (?, 0)");
            stmtCarteira.setInt(1, idUtilizador);
            stmtCarteira.executeUpdate();
            stmtCarteira.close();

            // Remover da tabela registos
            PreparedStatement stmtDelete = conn.prepareStatement("DELETE FROM registos WHERE id_registo = ?");
            stmtDelete.setInt(1, idRegisto);
            stmtDelete.executeUpdate();
            stmtDelete.close();

            stmtInsert.close();
            res.close();
            stmt.close();

            // Redirecionar para a própria página após aceitar
            response.sendRedirect("aceitar_utilizadores.jsp");
            return;
        } else {
            stmtInsert.close();
            res.close();
            stmt.close();
            // Em caso de erro, redirecionar para voltar.jsp
            response.sendRedirect("voltar.jsp");
            return;
        }
    } else {
        res.close();
        stmt.close();
        // Em caso de erro, redirecionar para voltar.jsp
        response.sendRedirect("voltar.jsp");
        return;
    }
  }
%>


<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Menu Admin - FelixBus</title>
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
                    <a class="nav-link" href="gestao_utilizadores.jsp">Voltar</a>
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
    <h1>Utilizadores</h1>
    <br>

    <table class="table">
      <thead>
          <tr>
              <th>Nome do Utilizador</th>
              <th>Email</th>
              <th>Data Nascimento</th>
              
             
              
          </tr>
      </thead>
      <tbody>
          <%

          PreparedStatement stmt = conn.prepareStatement("SELECT * FROM registos");
          ResultSet result = stmt.executeQuery();

          while (result.next()) {
            int idRegisto = result.getInt("id_registo");
            String nomeUtilizador = result.getString("nome_utilizador");
            String email = result.getString("email");
            String dataNasc = result.getString("data_nasc");

            // Escapar HTML para segurança
            if (nomeUtilizador != null) nomeUtilizador = nomeUtilizador.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
            if (email != null) email = email.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
            if (dataNasc != null) dataNasc = dataNasc.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

            // Exibir os dados do utilizador
            out.print("<tr>");
            out.print("<td>" + (nomeUtilizador != null ? nomeUtilizador : "") + "</td>");
            out.print("<td>" + (email != null ? email : "") + "</td>");
            out.print("<td>" + (dataNasc != null ? dataNasc : "") + "</td>");

            out.print("<td>");
            out.print("<form action='aceitar_utilizadores.jsp' method='POST'>");
            out.print("<input type='hidden' name='id_utilizador' value='" + idRegisto + "'>");
            out.print("<button type='submit' class='btn btn-primary'>Aceitar</button>");
            out.print("</form>");
            out.print("</td>");

            out.print("</tr>");
          }

          result.close();
          stmt.close();
          %>
      </tbody>
  </table>



  <br>
  </div>
