<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de administrador (3)
  if(session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(3)){
    response.sendRedirect("voltar.jsp");
    return;
  }

  // Processar remoção de cidade
  if("POST".equals(request.getMethod()) && request.getParameter("id_cidade") != null){
    String idCidadeParam = request.getParameter("id_cidade");

    try {
        int idCidade = Integer.parseInt(idCidadeParam);

        PreparedStatement stmt = conn.prepareStatement("DELETE FROM cidades WHERE id_cidade = ?");
        stmt.setInt(1, idCidade);
        boolean res = stmt.executeUpdate() > 0;
        stmt.close();

        if(res){
            out.println("Cidade removida com sucesso!");
            response.setHeader("refresh", "2; url=voltar.jsp");
        }else{
            out.println("Erro ao remover Cidade!");
            response.setHeader("refresh", "2; url=voltar.jsp");
        }
    } catch (NumberFormatException e) {
        out.println("Erro");
        response.sendRedirect("voltar.jsp");
    }
  }
%>


<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Remover Cidade - FelixBus</title>
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
              <th>Nome da Cidade</th>
              
              
          </tr>
      </thead>
      <tbody>
          <%

          PreparedStatement stmt = conn.prepareStatement("SELECT * FROM cidades");
          ResultSet result = stmt.executeQuery();

          while (result.next()) {
            int idCidade = result.getInt("id_cidade");
            String nomeCidade = result.getString("nome_cidade");

            // Escapar HTML para segurança
            if (nomeCidade != null) nomeCidade = nomeCidade.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

            out.print("<tr>");
            out.print("<td>" + (nomeCidade != null ? nomeCidade : "") + "</td>");
            out.print("<td>");
            out.print("<form action='remover_cidades.jsp' method='POST'>");
            out.print("<input type='hidden' name='id_cidade' value='" + idCidade + "'>");
            out.print("<button type='submit' class='btn btn-primary'>Remover</button>");
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