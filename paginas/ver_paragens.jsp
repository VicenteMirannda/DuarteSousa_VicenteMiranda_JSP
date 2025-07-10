<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// Verificação de sessão comentada como no original
//Integer nivel = (Integer) session.getAttribute("nivel");
//if (nivel == null || nivel != 3) {
//    response.sendRedirect("voltar.jsp");
//    return;
//}
%>
<%@ include file="../basedados/basedados.h" %>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ver paragens - FelixBus</title>
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
                    <a class="nav-link" href="listar_rotas.jsp">Voltar</a>
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
              <th>Cidade</th>
              <th>Numero da Paragem</th>
              
              
              
          </tr>
      </thead>
      <tbody>
          <%
          try {
              String id_rota = request.getParameter("id_rota");
              if (id_rota == null) {
                  id_rota = "0"; // Valor padrão se não houver parâmetro
              }
              
              String sql = "SELECT * FROM rotas_cidade WHERE id_rota = " + id_rota + " ORDER BY num_paragem";
              Statement stmt = conn.createStatement();
              ResultSet result = stmt.executeQuery(sql);
              
              while (result.next()) {
                  String sql2 = "SELECT nome_cidade FROM cidades c inner join rotas_cidade rc on c.id_cidade = rc.id_cidade WHERE c.id_cidade = " + result.getInt("id_cidade") + " AND rc.id_rota = " + id_rota;
                  Statement stmt2 = conn.createStatement();
                  ResultSet result2 = stmt2.executeQuery(sql2);
                  
                  if (result2.next()) {
          %>
                      <tr>
                          <td><%= result2.getString("nome_cidade").replace("<", "&lt;").replace(">", "&gt;") %></td>
                          <td><%= result.getString("num_paragem").replace("<", "&lt;").replace(">", "&gt;") %></td>
                      </tr>
          <%
                  }
                  result2.close();
                  stmt2.close();
              }
              result.close();
              stmt.close();
          } catch (SQLException e) {
              out.println("Erro ao carregar paragens: " + e.getMessage());
          }
          %>
      </tbody>
  </table>



  <br>
  </div>

</body>
</html>
