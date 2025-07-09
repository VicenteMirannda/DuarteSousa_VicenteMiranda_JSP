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
    String id_alerta = request.getParameter("id_alerta");
    
    if (id_alerta != null) {
        try {
            String sql = "DELETE FROM alertas WHERE id_alerta = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(id_alerta));
            
            int result = stmt.executeUpdate();
            stmt.close();
            
            if(result > 0){
                out.println("Alerta removido com sucesso!");
                response.setHeader("refresh", "2;url=voltar.jsp");
            } else {
                out.println("Erro ao remover alerta!");
                response.setHeader("refresh", "2;url=voltar.jsp");
            }
        } catch (SQLException e) {
            out.println("Erro ao remover alerta: " + e.getMessage());
            response.setHeader("refresh", "2;url=voltar.jsp");
        } catch (NumberFormatException e) {
            out.println("ID do alerta inválido.");
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
                    <a class="nav-link" href="gestao_alertas.jsp">Voltar</a>
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
    <h1>Alertas</h1>
    <br>

 
 <table class="table">
      <thead>
          <tr>
              <th>Alerta</th>
              <th>Rota</th>
              <th>Id_Viagem</th>
              <th>Tipo</th>
              
              
              
          </tr>
      </thead>
      <tbody>
          <%
          try {
              String sql = "SELECT * FROM alertas";
              PreparedStatement stmt = conn.prepareStatement(sql);
              ResultSet result = stmt.executeQuery();
              
              while (result.next()) {
                  // Obter descrição do tipo de alerta
                  String descricao = "";
                  String tipo = result.getString("tipo");
                  if (tipo != null && !tipo.isEmpty()) {
                      try {
                          String sql2 = "SELECT descricao FROM tipo_alerta WHERE id_tipo = ?";
                          PreparedStatement stmt2 = conn.prepareStatement(sql2);
                          stmt2.setInt(1, Integer.parseInt(tipo));
                          ResultSet result2 = stmt2.executeQuery();
                          if (result2.next()) {
                              descricao = result2.getString("descricao") != null ? result2.getString("descricao") : "";
                          }
                          result2.close();
                          stmt2.close();
                      } catch (NumberFormatException e) {
                          // Tipo inválido, manter descrição vazia
                      }
                  }
                  
                  // Obter nome da rota
                  String nome_rota = "";
                  String id_rota_str = result.getString("id_rota");
                  if (id_rota_str != null && !id_rota_str.isEmpty()) {
                      try {
                          int id_rota = Integer.parseInt(id_rota_str);
                          String sql3 = "SELECT nome_rota FROM rotas WHERE id_rota = ?";
                          PreparedStatement stmt3 = conn.prepareStatement(sql3);
                          stmt3.setInt(1, id_rota);
                          ResultSet result3 = stmt3.executeQuery();
                          if (result3.next()) {
                              nome_rota = result3.getString("nome_rota") != null ? result3.getString("nome_rota") : "";
                          }
                          result3.close();
                          stmt3.close();
                      } catch (NumberFormatException e) {
                          // ID da rota inválido, manter nome vazio
                      }
                  }
                  
                  // Obter id_viagem
                  String id_viagem = result.getString("id_viagem") != null ? result.getString("id_viagem") : "";
                  String id_alerta = result.getString("id_alerta") != null ? result.getString("id_alerta") : "";
          %>
                  <tr>
                      <td><%= id_alerta %></td>
                      <td><%= nome_rota %></td>
                      <td><%= id_viagem %></td>
                      <td><%= descricao %></td>
                      <td>
                          <form action='remover_alertas.jsp' method='POST'>
                              <input type='hidden' name='id_alerta' value='<%= id_alerta %>'>
                              <button type='submit' class='btn btn-danger'>Remover</button>
                          </form>
                      </td>
                  </tr>
          <%
              }
              result.close();
              stmt.close();
          } catch (SQLException e) {
              out.println("Erro ao carregar alertas: " + e.getMessage());
          }
          %>
      </tbody>
  </table>

</div>

<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
