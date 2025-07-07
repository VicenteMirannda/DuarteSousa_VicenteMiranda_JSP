<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>


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
        <div class="container">
          <a class="navbar-brand" href="voltar.php">FelixBus</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
            <li class="nav-item">
                    <a class="nav-link" href="logout.php">Logout</a>
                </li>    
            </ul>
          </div>
        </div>
      </nav>

<!-- Botões Centrais -->
<div class="container center-buttons">
    <div class="row justify-content-center text-center">
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="gestao_rotas.php" class="btn btn-primary btn-menu w-100">Gestão de Rotas</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="gestao_viagens.php" class="btn btn-primary btn-menu w-100">Gestão de Viagens</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="gestao_utilizadores.php" class="btn btn-primary btn-menu w-100">Gestão de Utilizadores</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="gestao_alertas.php" class="btn btn-primary btn-menu w-100">Gestão de Alertas / Informações / Promoções</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="dados_pessoais.php" class="btn btn-primary btn-menu w-100">Visualizar / Editar Dados Pessoais</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="gestao_cidades.php" class="btn btn-primary btn-menu w-100">Gestão de Cidades</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="consultar_estrato_admin.php" class="btn btn-primary btn-menu w-100">Consultar Estrato</a>
        </div>
    </div>
</div>






<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
