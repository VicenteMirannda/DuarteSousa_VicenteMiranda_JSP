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
    <div class="container-fluid">
        <a class="navbar-brand" href="voltar.php">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">

                <li class="nav-item">
                    <a class="nav-link" href="menuadmin.php">Voltar</a>
                </li>

                
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
            <a href="listar_alertas.php" class="btn btn-primary btn-menu w-100">Histórico de Alertas</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="adicionar_promocao.php" class="btn btn-primary btn-menu w-100">Adicionar Promoção</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="editar_alerta.php" class="btn btn-primary btn-menu w-100">Editar</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="remover_alertas.php" class="btn btn-primary btn-menu w-100">Remover</a>
        </div>
    </div>
</div>






<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>