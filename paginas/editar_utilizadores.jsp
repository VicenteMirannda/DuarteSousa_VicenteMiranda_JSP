<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de administrador (3)
  if(session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(3)){
    response.sendRedirect("voltar.jsp");
    return;
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
              <th>Nivel Acesso</th>
              
              
          </tr>
      </thead>
      <tbody>
          <%

          PreparedStatement stmt = conn.prepareStatement("SELECT * FROM utilizadores");
          ResultSet result = stmt.executeQuery();

          while (result.next()) {
            int idUtilizador = result.getInt("id_utilizador");
            String nomeUtilizador = result.getString("nome_utilizador");
            String email = result.getString("email");
            String dataNasc = result.getString("data_nasc");
            int nivelAcesso = result.getInt("nivel_acesso");

            PreparedStatement stmt2 = conn.prepareStatement("SELECT descricao FROM nivel_acesso WHERE nivel_acesso = ?");
            stmt2.setInt(1, nivelAcesso);
            ResultSet result2 = stmt2.executeQuery();
            String descricao = "";
            if (result2.next()) {
                descricao = result2.getString("descricao");
            }
            result2.close();
            stmt2.close();

            // Escapar HTML para segurança
            if (nomeUtilizador != null) nomeUtilizador = nomeUtilizador.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
            if (email != null) email = email.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
            if (dataNasc != null) dataNasc = dataNasc.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
            if (descricao != null) descricao = descricao.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

            out.print("<tr>");
            out.print("<td>" + (nomeUtilizador != null ? nomeUtilizador : "") + "</td>");
            out.print("<td>" + (email != null ? email : "") + "</td>");
            out.print("<td>" + (dataNasc != null ? dataNasc : "") + "</td>");
            out.print("<td>" + (descricao != null ? descricao : "") + "</td>");

            out.print("<td>");
            out.print("<form action='editar_dados.jsp' method='POST'>");
            out.print("<input type='hidden' name='id_utilizador' value='" + idUtilizador + "'>");
            out.print("<button type='submit' class='btn btn-primary'>Editar</button>");
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