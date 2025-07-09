<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar sessão
  Integer nivel = (Integer) session.getAttribute("nivel");
  if(nivel == null || nivel != 3){
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
                    <a class="nav-link" href="gestao_rotas.jsp">Voltar</a>
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
          try {
              String sql = "SELECT * FROM rotas";
              PreparedStatement stmt = conn.prepareStatement(sql);
              ResultSet result = stmt.executeQuery();

              while (result.next()) {
          %>
                  <tr>
                      <td><%= result.getString("nome_rota") != null ? result.getString("nome_rota") : "" %></td>
                      <td><%= result.getString("taxa_inicial") != null ? result.getString("taxa_inicial") : "" %> €</td>
                      <td><%= result.getString("taxa_paragem") != null ? result.getString("taxa_paragem") : "" %> €</td>
                      <td><%= result.getString("num_paragens") != null ? result.getString("num_paragens") : "" %></td>
                      <td>
                          <form action='ver_paragens.jsp' method='POST'>
                              <input type='hidden' name='id_rota' value='<%= result.getInt("id_rota") %>'>
                              <button type='submit' class='btn btn-primary'>Ver Paragens</button>
                          </form>
                      </td>
                  </tr>
          <%
              }
              result.close();
              stmt.close();
          } catch (SQLException e) {
              out.println("Erro ao carregar rotas: " + e.getMessage());
          }
          %>
      </tbody>
  </table>



  <br>
  </div>