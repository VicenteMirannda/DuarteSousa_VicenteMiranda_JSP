<?php
  session_start();
  if($_SESSION['nivel'] != 1){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>


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
        <a class="navbar-brand" href="voltar.php">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                
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
            <a href="consultar_estrato.php" class="btn btn-primary btn-menu w-100">Consultar Estrato</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="gestao_carteira.php" class="btn btn-primary btn-menu w-100">Gerir Carteira</a>
        </div>
    
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="dados_cli_func.php" class="btn btn-primary btn-menu w-100">Visualizar / Editar Dados Pessoais</a>
        </div>
        <div class="col-md-6 col-lg-4 mb-3">
            <a href="gerir_bilhetes.php" class="btn btn-primary btn-menu w-100">Gerir Bilhetes</a>
        </div>
        
    </div>
</div>


<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
