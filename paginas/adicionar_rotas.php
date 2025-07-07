<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>
<?php
    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        
    $nome_rota = $_POST['nome_rota'];
    $taxa_inicial = $_POST['taxa_inicial'];
    $taxa_paragem = $_POST['taxa_paragem'];
    $num_paragens = $_POST['num_paragens'];
    

    $sql = "INSERT INTO rotas (nome_rota, taxa_inicial, taxa_paragem, num_paragens) VALUES ('$nome_rota', '$taxa_inicial', '$taxa_paragem', '$num_paragens')";
    $res = mysqli_query($conn, $sql);
    if($res){
        echo "Rota adicionada com sucesso!";
        header("refresh:2;url=voltar.php");
    }else{
        echo "Erro ao adicionar Rota!";
        header("refresh:2;url=voltar.php");
    }
    }
    
?>



<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Adicionar Rotas - FelixBus</title>
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
                    <a class="nav-link" href="gestao_rotas.php">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.php">Logout</a>
                </li>
               
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <h1>Adicionar Rotas</h1>

            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
            
            <form action = "adicionar_rotas.php" method = "POST">
              <div class="mb-3">
                <label for="utilizador" class="form-label">Nome da Rota</label>
                <input type="text" class="form-control" id="nome_rota" name="nome_rota"  required>
              </div>
            <div class="mb-3">
                <label for="saldo" class="form-label">Taxa Inicial</label>
                <input type="number" class="form-control" id="taxa_inicial" name="taxa_inicial" required>
            </div>
            <div class="mb-3">
                <label for="saldo" class="form-label">Taxa Paragem</label>
                <input type="number" class="form-control" id="taxa_paragem" name="taxa_paragem" required>
            </div>
            <div class="mb-3">
                <label for="saldo" class="form-label">Número de Paragens</label>
                <input type="number" class="form-control" id="num_paragens" name="num_paragens" required>
            </div>
              
              <button type="submit" class="btn btn-primary">Adicionar</button>
            </form>
          </div>
              
              
              
          
     


    </div>