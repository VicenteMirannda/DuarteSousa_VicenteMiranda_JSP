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
                    <a class="nav-link" href="listar_alertas.jsp">Voltar</a>
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
    <h1>Alerta</h1>
    <br>

    <table class="table">
      <thead>
          <tr>
              <th>Descrição</th>
              
              
              
              
          </tr>
      </thead>
      <tbody>
          <%
          String id_alerta = request.getParameter("id_alerta");
          if (id_alerta != null) {
              try {
                  String sql = "SELECT * FROM alertas WHERE id_alerta = ?";
                  PreparedStatement stmt = conn.prepareStatement(sql);
                  stmt.setInt(1, Integer.parseInt(id_alerta));
                  ResultSet result = stmt.executeQuery();
                  
                  while (result.next()) {
          %>
                      <tr>
                          <td><%= result.getString("descricao") != null ? result.getString("descricao") : "" %></td>
                      </tr>
          <%
                  }
                  result.close();
                  stmt.close();
              } catch (SQLException e) {
                  out.println("Erro ao carregar descrição do alerta: " + e.getMessage());
              } catch (NumberFormatException e) {
                  out.println("ID do alerta inválido.");
              }
          } else {
              out.println("ID do alerta não fornecido.");
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
