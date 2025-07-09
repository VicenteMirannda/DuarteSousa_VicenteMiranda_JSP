<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // Verificar se a sessão existe e se o nível é 3 (equivalente ao session_start() e verificação do PHP)
  Integer nivel = (Integer) session.getAttribute("nivel");
  if(nivel == null || nivel != 3){
    response.sendRedirect("voltar.jsp");
    return;
  }
%>
<%@ include file="../basedados/basedados.h" %>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gestao de Viagens - FelixBus</title>
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
                    <a class="nav-link" href="voltar.jsp">Voltar</a>
                </li>

                
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
               
            </ul>
        </div>
    </div>
</nav>

<!-- Botões Centrais -->
<div class="container center-buttons">
    <div class="row justify-content-center text-center">
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="listar_viagens.jsp" class="btn btn-primary btn-menu w-100">Listar Viagens</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="adicionar_viagens.jsp" class="btn btn-primary btn-menu w-100">Adicionar Viagens</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="editar_viagens.jsp" class="btn btn-primary btn-menu w-100">Editar Viagens</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="remover_viagens.jsp" class="btn btn-primary btn-menu w-100">Remover Viagens</a>
        </div>
    </div>
</div>




<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
