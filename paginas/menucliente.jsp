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
    <title>Área de Cliente - FelixBus</title>
    
    <link href="bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 20px rgba(0,0,0,.08);
            transition: all 0.3s ease;
        }
    </style>      
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="voltar.jsp">FelixBus</a>
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

<div class="container text-center py-5">
    <h1 class="display-5 fw-bold">A sua área pessoal</h1>
    <p class="lead text-muted">Bem-vindo(a) de volta! Gira a sua conta e as suas viagens.</p>
</div>

<div class="container">
    <div class="row g-4 justify-content-center">

       <div class="col-md-6 col-lg-4">
    <div class="card h-100 shadow-sm border-0">
        <div class="card-body d-flex flex-column text-center p-4">
            <h5 class="card-title mb-3">🎟️ Gerir Bilhetes</h5>
            <p class="card-text text-muted">Consulte os seus bilhetes ativos, compre novas viagens e veja o seu histórico.</p>
            
            <a href="gerir_bilhetes.jsp" class="btn btn-outline-primary mt-auto">Aceder</a>
            
        </div>
    </div>
</div>
        
        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center p-4">
                    <h5 class="card-title mb-3">💳 Gerir Carteira</h5>
                    <p class="card-text text-muted">Adicione ou levante saldo e consulte o estado da sua carteira digital.</p>
                    <a href="gestao_carteira.jsp" class="btn btn-outline-primary mt-auto">Gerir</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center p-4">
                    <h5 class="card-title mb-3">📄 Consultar Extrato</h5>
                    <p class="card-text text-muted">Veja o seu histórico detalhado de todas as viagens e transações financeiras.</p>
                    <a href="consultar_estrato.jsp" class="btn btn-outline-primary mt-auto">Consultar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center p-4">
                    <h5 class="card-title mb-3">👤 Dados Pessoais</h5>
                    <p class="card-text text-muted">Mantenha as suas informações de contacto e dados pessoais sempre atualizados.</p>
                    <a href="dados_cli_func.jsp" class="btn btn-outline-primary mt-auto">Editar</a>
                </div>
            </div>
        </div>
        
    </div>
</div>

<footer class="container text-center text-muted py-4 mt-5">
    <p>&copy; <%= new java.util.Date().getYear() + 1900 %> FelixBus. Todos os direitos reservados.</p>
</footer>

<script src="bootstrap.bundle.min.js"></script>

</body>
</html>