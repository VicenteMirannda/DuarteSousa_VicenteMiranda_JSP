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
    String nome_rota = request.getParameter("nome_rota");
    String taxa_inicial = request.getParameter("taxa_inicial");
    String taxa_paragem = request.getParameter("taxa_paragem");
    String num_paragens = request.getParameter("num_paragens");
    
    try {
      String sql = "INSERT INTO rotas (nome_rota, taxa_inicial, taxa_paragem, num_paragens) VALUES (?, ?, ?, ?)";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, nome_rota);
      stmt.setString(2, taxa_inicial);
      stmt.setString(3, taxa_paragem);
      stmt.setString(4, num_paragens);
      
      int result = stmt.executeUpdate();
      stmt.close();
      
      if(result > 0){
        out.println("Rota adicionada com sucesso!");
        response.setHeader("refresh", "2;url=voltar.jsp");
      } else {
        out.println("Erro ao adicionar Rota!");
        response.setHeader("refresh", "2;url=voltar.jsp");
      }
    } catch (SQLException e) {
      out.println("Erro ao adicionar Rota: " + e.getMessage());
      response.setHeader("refresh", "2;url=voltar.jsp");
    }
  }
%>



<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Adicionar Rotas - FelixBus</title>
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
    <h1>Adicionar Rotas</h1>

            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
            
            <form action = "adicionar_rotas.jsp" method = "POST">
              <div class="mb-3">
                <label for="utilizador" class="form-label">Nome da Rota</label>
                <input type="text" class="form-control" id="nome_rota" name="nome_rota"  required>
              </div>
            <div class="mb-3">
                <label for="saldo" class="form-label">Taxa Inicial</label>
                <input type="number" class="form-control" id="taxa_inicial" name="taxa_inicial" required>
            </div>
            <div class="mb-3">
                <label for="saldo" class="form-label">Taxa Paragem</label>
                <input type="number" class="form-control" id="taxa_paragem" name="taxa_paragem" required>
            </div>
            <div class="mb-3">
                <label for="saldo" class="form-label">Número de Paragens</label>
                <input type="number" class="form-control" id="num_paragens" name="num_paragens" required>
            </div>
              
              <button type="submit" class="btn btn-primary">Adicionar</button>
            </form>
          </div>
              
              
              
          
     


    </div>

<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
