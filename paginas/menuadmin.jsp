<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de administrador (3)
  if(session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(3)){
    response.sendRedirect("voltar.jsp");
    return;
  }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Painel de Administração - FelixBus</title>
    
    <link href="bootstrap.min.css" rel="stylesheet">
    
    <style>
        /* Podemos adicionar pequenos ajustes se necessário, mas o ideal é usar classes Bootstrap */
        body {
            background-color: #f8f9fa; /* Um cinza muito claro para o fundo */
        }
        .card-title {
            color: #212529; /* Cor principal para os títulos */
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
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>      
            </ul>
        </div>
    </div>
</nav>

<div class="container text-center py-5">
    <h1 class="display-5 fw-bold">Painel de Administração</h1>
    <p class="lead text-muted">Selecione uma das opções abaixo para gerir o sistema.</p>
</div>

<div class="container">
    <div class="row g-4">
        
        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center">
                    <h5 class="card-title mb-3">Gestão de Rotas</h5>
                    <p class="card-text text-muted">Crie, edite e visualize as rotas dos autocarros.</p>
                    <a href="gestao_rotas.jsp" class="btn btn-outline-primary mt-auto">Aceder</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center">
                    <h5 class="card-title mb-3">Gestão de Viagens</h5>
                    <p class="card-text text-muted">Agende e administre as viagens disponíveis.</p>
                    <a href="gestao_viagens.jsp" class="btn btn-outline-primary mt-auto">Aceder</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center">
                    <h5 class="card-title mb-3">Gestão de Utilizadores</h5>
                    <p class="card-text text-muted">Consulte e gira as contas dos utilizadores.</p>
                    <a href="gestao_utilizadores.jsp" class="btn btn-outline-primary mt-auto">Aceder</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center">
                    <h5 class="card-title mb-3">Gestão de Alertas</h5>
                    <p class="card-text text-muted">Envie alertas, informações e promoções.</p>
                    <a href="gestao_alertas.jsp" class="btn btn-outline-primary mt-auto">Aceder</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center">
                    <h5 class="card-title mb-3">Visualizar / Editar Dados</h5>
                    <p class="card-text text-muted">Consulte ou altere os seus dados pessoais.</p>
                    <a href="dados_pessoais.jsp" class="btn btn-outline-primary mt-auto">Aceder</a>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center">
                    <h5 class="card-title mb-3">Gestão de Cidades</h5>
                    <p class="card-text text-muted">Adicione ou remova cidades do sistema.</p>
                    <a href="gestao_cidades.jsp" class="btn btn-outline-primary mt-auto">Aceder</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body d-flex flex-column text-center">
                    <h5 class="card-title mb-3">Consultar Estrato</h5>
                    <p class="card-text text-muted">Verifique o extrato financeiro e de viagens.</p>
                    <a href="consultar_estrato_admin.jsp" class="btn btn-outline-primary mt-auto">Aceder</a>
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