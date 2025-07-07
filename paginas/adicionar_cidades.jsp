<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de administrador (3)
  if(session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(3)){
    response.sendRedirect("voltar.jsp");
    return;
  }

  // Processar adição de cidade
  if("POST".equals(request.getMethod()) && request.getParameter("cidade") != null){
    String cidade = request.getParameter("cidade");

    PreparedStatement stmt = conn.prepareStatement("INSERT INTO cidades (nome_cidade) VALUES (?)");
    stmt.setString(1, cidade);
    boolean res = stmt.executeUpdate() > 0;
    stmt.close();

    if(res){
        out.println("cidade adicionada com sucesso!");
        response.setHeader("refresh", "2; url=voltar.jsp");
    }else{
        out.println("Erro ao adicionar cidade!");
        response.setHeader("refresh", "2; url=voltar.jsp");
    }
  }
%>



<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Adicionar Cidade - FelixBus</title>
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
    <h1>Adicionar Cidades</h1>

            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
            
            <form action = "adicionar_cidades.jsp" method = "POST">
              <div class="mb-3">
                <label for="utilizador" class="form-label">Nome da Cidade</label>
                <input type="text" class="form-control" id="cidade" name="cidade"  required>
              </div>
              
              
              <button type="submit" class="btn btn-primary">Adicionar</button>
            </form>
          </div>
              
              
              
          
     


    </div>