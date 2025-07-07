<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>
<?php
    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        
    $cidade = $_POST['cidade'];
   

    $sql = "INSERT INTO cidades (nome_cidade) VALUES ('$cidade')";
    $res = mysqli_query($conn, $sql);
    if($res){
        echo "cidade adicionada com sucesso!";
        header("refresh:2;url=voltar.php");
    }else{
        echo "Erro ao adicionar cidade!";
        header("refresh:2;url=voltar.php");
    }
    }
    
?>



<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Adicionar Cidade - FelixBus</title>
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
                    <a class="nav-link" href="gestao_cidades.php">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.php">Logout</a>
                </li>
               
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <h1>Adicionar Cidades</h1>

            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
            
            <form action = "adicionar_cidades.php" method = "POST">
              <div class="mb-3">
                <label for="utilizador" class="form-label">Nome da Cidade</label>
                <input type="text" class="form-control" id="cidade" name="cidade"  required>
              </div>
              
              
              <button type="submit" class="btn btn-primary">Adicionar</button>
            </form>
          </div>
              
              
              
          
     


    </div>