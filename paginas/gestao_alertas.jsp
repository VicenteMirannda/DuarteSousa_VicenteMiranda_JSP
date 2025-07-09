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
    <title>Gestão de Alertas e Promoções - FelixBus</title>
    
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
                    <a class="nav-link" href="menuadmin.jsp">❮ Voltar ao Menu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container text-center py-5">
    <h1 class="display-5 fw-bold">Alertas e Promoções</h1>
    <p class="lead text-muted">Comunique informações importantes e crie promoções para os seus clientes.</p>
</div>

<div class="container">
    <div class="row g-4 justify-content-center">

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center p-4">
                    <h5 class="card-title mb-3">📢 Adicionar Promoção</h5>
                    <p class="card-text text-muted">Crie uma nova campanha promocional ou um alerta informativo para os utilizadores.</p>
                    <a href="adicionar_promocao.jsp" class="btn btn-outline-success mt-auto">Adicionar</a>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center p-4">
                    <h5 class="card-title mb-3">📋 Histórico de Alertas</h5>
                    <p class="card-text text-muted">Consulte a lista de todas as promoções e alertas que já foram enviados.</p>
                    <a href="listar_alertas.jsp" class="btn btn-outline-secondary mt-auto">Ver Histórico</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center p-4">
                    <h5 class="card-title mb-3">✏️ Editar</h5>
                    <p class="card-text text-muted">Altere o conteúdo ou as condições de um alerta ou promoção existente.</p>
                    <a href="editar_alerta.jsp" class="btn btn-outline-primary mt-auto">Editar</a>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center p-4">
                    <h5 class="card-title mb-3">➖ Remover</h5>
                    <p class="card-text text-muted">Elimine permanentemente um alerta ou uma promoção da base de dados.</p>
                    <a href="remover_alertas.jsp" class="btn btn-outline-danger mt-auto">Remover</a>
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