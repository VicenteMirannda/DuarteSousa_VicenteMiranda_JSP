<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>
<?php 
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        if (isset($_POST['descricao'])) {
            $descricao = $_POST['descricao'];
            if (isset($_SESSION['id_viagem'])) {
                $id_viagem = $_SESSION['id_viagem'];
                $sql = "INSERT INTO alertas (id_rota, id_viagem, descricao, tipo) VALUES (NULL, '$id_viagem', '$descricao', '3')";
                $res = mysqli_query($conn, $sql);

                if ($res) {
                    echo "Alerta registado com sucesso!";
                    unset($_SESSION['id_viagem']);
                    header("refresh:2;url=voltar.php");
                } else {
                    echo "Erro ao registar alerta!";
                    unset($_SESSION['id_viagem']);
                    header("refresh:2;url=voltar.php");
                }
            } else {
                echo "ID da viagem não encontrado na sessão.";
                unset($_SESSION['id_viagem']);
                header("refresh:2;url=voltar.php");
            }
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
                    <a class="nav-link" href="voltar.php">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.php">Logout</a>
                </li>
               
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2>Alteração de Hora</h2>
    <form action="alterar_hora.php" method="POST">
        <div class="mb-3">
            <label for="descricao" class="form-label">Descrição da Alteração</label>
            <textarea class="form-control" id="descricao" name="descricao" rows="4" required></textarea>
        </div>
        <button type="submit" class="btn btn-danger">Criar Alerta</button>
    </form>
</div>