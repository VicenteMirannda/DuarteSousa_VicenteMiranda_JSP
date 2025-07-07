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
                    <a class="nav-link" href="gestao_cidades.jsp">Voltar</a>
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
    <h1>Cidades</h1>
    <br>

    <table class="table">
      <thead>
          <tr>
              <th>Id</th>
              <th>Nome Cidade</th>
              
              
          </tr>
      </thead>
      <tbody>
          <%

          PreparedStatement stmt = conn.prepareStatement("SELECT * FROM cidades ORDER BY id_cidade ASC");
          ResultSet result = stmt.executeQuery();

          while (result.next()) {
            int idCidade = result.getInt("id_cidade");
            String nomeCidade = result.getString("nome_cidade");

            // Escapar HTML para segurança
            if (nomeCidade != null) nomeCidade = nomeCidade.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

            out.print("<tr>");
            out.print("<td>" + idCidade + "</td>");
            out.print("<td>" + (nomeCidade != null ? nomeCidade : "") + "</td>");
            out.print("</tr>");
          }

          result.close();
          stmt.close();
          %>
      </tbody>
  </table>



  <br>
  </div>