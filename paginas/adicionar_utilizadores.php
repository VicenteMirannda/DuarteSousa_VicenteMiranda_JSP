<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>
<?php
    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        
    $utilizador = $_POST['utilizador'];
    $pass = $_POST['pass'];
    $email = $_POST['email'];
    $data_nasc = $_POST['data_nasc'];
    $nivel = $_POST['nivel'];
    

    $sql = "INSERT INTO utilizadores (nome_utilizador, password, email, data_nasc, nivel_acesso) VALUES ('$utilizador', '$pass', '$email', '$data_nasc', '$nivel')";
    $res = mysqli_query($conn, $sql);
    if($res){
        echo "Utilizador adicionado com sucesso!";
        header("refresh:2;url=voltar.php");
    }else{
        echo "Erro ao adicionar utilizador!";
        header("refresh:2;url=voltar.php");
    }
    }
    
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
                    <a class="nav-link" href="gestao_utilizadores.php">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.php">Logout</a>
                </li>
               
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <h1>Adicionar Utilizador</h1>

            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
            
            <form action = "adicionar_utilizadores.php" method = "POST">
              <div class="mb-3">
                <label for="utilizador" class="form-label">Nome de Utilizador</label>
                <input type="text" class="form-control" id="utilizador" name="utilizador"  required>
              </div>
              <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="text" class="form-control" id="pass" name="pass"  required>
              </div>
              <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="text" class="form-control" id="email" name="email" required>
              </div>
              <div class="mb-3">
                <label for="data_nasc" class="form-label">Data Nascimento</label>
                <input type="date" class="form-control" id="data_nasc" name="data_nasc" required>
              </div>
            <div class="mb-3">
                <label for="nivel" class="form-label">Nível de Acesso</label>
                <select class="form-select" id="nivel" name="nivel" required>
                    <option value="1">Cliente</option>
                    <option value="2">Funcionario</option>
                    <option value="3">Admin</option>
                </select>
            </div>
            
              
              <button type="submit" class="btn btn-primary">Adicionar</button>
            </form>
          </div>
              
              
              
          
     


    </div>