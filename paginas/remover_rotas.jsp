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
  
  // Processar formulário se for POST
  if("POST".equals(request.getMethod())){
    String id_rota = request.getParameter("id_rota");
    
    if (id_rota != null) {
        try {
            // Remover a rota
            String sql = "DELETE FROM rotas WHERE id_rota = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(id_rota));
            
            int result = stmt.executeUpdate();
            stmt.close();
            
            if(result > 0){
                // Remover todas as viagens associadas à rota
                String sql2 = "DELETE FROM viagem WHERE id_rota = ?";
                PreparedStatement stmt2 = conn.prepareStatement(sql2);
                stmt2.setInt(1, Integer.parseInt(id_rota));
                stmt2.executeUpdate();
                stmt2.close();
                
                out.println("Rota removida com sucesso!");
                response.setHeader("refresh", "2;url=voltar.jsp");
            } else {
                out.println("Erro ao remover Rota!");
                response.setHeader("refresh", "2;url=voltar.jsp");
            }
        } catch (SQLException e) {
            out.println("Erro ao remover Rota: " + e.getMessage());
            response.setHeader("refresh", "2;url=voltar.jsp");
        } catch (NumberFormatException e) {
            out.println("ID da rota inválido.");
            response.setHeader("refresh", "2;url=voltar.jsp");
        }
    } else {
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
    <title>Remover Rotas - FelixBus</title>
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
    <h1>Remover Rotas</h1>
    <br>

    <table class="table">
      <thead>
          <tr>
              <th>Nome da Rotas</th>
              <th>Taxa Inicial</th>
              <th>Taxa de Paragem</th>
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
                      <td><%= result.getString("taxa_inicial") != null ? result.getString("taxa_inicial") : "" %></td>
                      <td><%= result.getString("taxa_paragem") != null ? result.getString("taxa_paragem") : "" %></td>
                      <td><%= result.getString("num_paragens") != null ? result.getString("num_paragens") : "" %></td>
                      <td>
                          <form action='remover_rotas.jsp' method='POST'>
                              <input type='hidden' name='id_rota' value='<%= result.getInt("id_rota") %>'>
                              <button type='submit' class='btn btn-primary'>Remover</button>
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

<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
