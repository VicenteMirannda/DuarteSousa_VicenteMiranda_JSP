<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de cliente (1)
  if(session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(1)){
    response.sendRedirect("voltar.jsp");
    return;
  }
%>


<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Menu Cliente - FelixBus</title>
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
            <a href="consultar_estrato.jsp" class="btn btn-primary btn-menu w-100">Consultar Estrato</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="gestao_carteira.jsp" class="btn btn-primary btn-menu w-100">Gerir Carteira</a>
        </div>

        <div class="col-md-6 col-lg-4 mb-3">
            <a href="dados_cli_func.jsp" class="btn btn-primary btn-menu w-100">Visualizar / Editar Dados Pessoais</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="gerir_bilhetes.jsp" class="btn btn-primary btn-menu w-100">Gerir Bilhetes</a>
        </div>
        
    </div>
</div>


<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
