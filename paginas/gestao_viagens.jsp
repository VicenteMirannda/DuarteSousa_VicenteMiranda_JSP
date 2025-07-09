<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se a sessão existe e se o nível é 3 (administrador)
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
    <title>Gestão de Viagens - FelixBus</title>
    
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
    <h1 class="display-5 fw-bold">Gestão de Viagens</h1>
    <p class="lead text-muted">Agende novas viagens, consulte as existentes e gira os detalhes de cada percurso.</p>
</div>

<div class="container">
    <div class="row g-4 justify-content-center">

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center p-4">
                    <h5 class="card-title mb-3">🗓️ Listar Viagens</h5>
                    <p class="card-text text-muted">Veja todas as viagens agendadas, com detalhes sobre rotas, horários e lugares.</p>
                    <a href="listar_viagens.jsp" class="btn btn-outline-secondary mt-auto">Listar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center p-4">
                    <h5 class="card-title mb-3">➕ Adicionar Viagens</h5>
                    <p class="card-text text-muted">Agende uma nova viagem para uma rota, definindo data, hora e preço.</p>
                    <a href="adicionar_viagens.jsp" class="btn btn-outline-success mt-auto">Adicionar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center p-4">
                    <h5 class="card-title mb-3">✏️ Editar Viagens</h5>
                    <p class="card-text text-muted">Altere informações de uma viagem existente, como horário ou motorista.</p>
                    <a href="editar_viagens.jsp" class="btn btn-outline-primary mt-auto">Editar</a>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center p-4">
                    <h5 class="card-title mb-3">➖ Remover Viagens</h5>
                    <p class="card-text text-muted">Cancele e remova uma viagem agendada que já não se irá realizar.</p>
                    <a href="remover_viagens.jsp" class="btn btn-outline-danger mt-auto">Remover</a>
                </div>
            </div>
        </div>

    </div>
</div>

<footer class="container text-center text-muted py-4 mt-5">
    <p>&copy; <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %> FelixBus. Todos os direitos reservados.</p>
</footer>

<script src="bootstrap.bundle.min.js"></script>

</body>
</html>