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
    <h1>Rotas</h1>
    <br>

    <form method="post" action="filtro_rotas.jsp">
        <input type="text" name="nome_rota" placeholder="Nome da rota">
        <input type="number" name="min_paragens" placeholder="Mínimo de paragens">
        <br><br>
        Ordenar por:

        <select name="ordenar_por">
            <option value="nome_rota">Nome</option>
            <option value="taxa_inicial">Taxa Inicial</option>
            <option value="num_paragens">Nº Paragens</option>
        </select>

        

        <select name="ordem">
            <option value="ASC">Crescente</option>
            <option value="DESC">Decrescente</option>
        </select>

        <br><br>

        <button type="submit" class='btn btn-primary'>Filtrar/Ordenar</button>
        <br><br><br><br>
        
    </form>

    <table class="table">
      <thead>
          <tr>
              <th>Rota</th>
              <th>Taxa Inical</th>
              <th>Taxa por Paragem</th>
              <th>Número de Paragens</th>
              
              
          </tr>
      </thead>
      <tbody>
          <%

          PreparedStatement stmt = conn.prepareStatement("SELECT * FROM rotas");
          ResultSet result = stmt.executeQuery();

          while (result.next()) {
            int idRota = result.getInt("id_rota");
            String nomeRota = result.getString("nome_rota");
            double taxaInicial = result.getDouble("taxa_inicial");
            double taxaParagem = result.getDouble("taxa_paragem");
            int numParagens = result.getInt("num_paragens");

            // Escapar HTML para segurança
            if (nomeRota != null) nomeRota = nomeRota.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

            out.print("<tr>");
            out.print("<td>" + (nomeRota != null ? nomeRota : "") + "</td>");
            out.print("<td>" + taxaInicial + " €</td>");
            out.print("<td>" + taxaParagem + " €</td>");
            out.print("<td>" + numParagens + "</td>");
            out.print("<td>");
            out.print("<form action='associar.jsp' method='POST'>");
            out.print("<input type='hidden' name='id_rota' value='" + idRota + "'>");
            out.print("<button type='submit' class='btn btn-primary'>Associar Cidade</button>");
            out.print("</form>");
            out.print("</tr>");
          }

          result.close();
          stmt.close();
          %>
      </tbody>
  </table>



  <br>
  </div>