<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>
<?php 
    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        if (isset($_POST['descricao']) && isset($_POST['id_viagem'])) {
            $id_viagem = $_POST['id_viagem'];
            $descricao = $_POST['descricao'];
            $sql = "INSERT INTO alertas (id_rota, id_viagem, descricao, tipo) VALUES ( NULL,'$id_viagem', '$descricao', '2')";
            $res = mysqli_query($conn, $sql);
            $sql2 = "UPDATE viagem SET estado_viagem = 0 WHERE id_viagem = '$id_viagem'";
            $res2 = mysqli_query($conn, $sql2);
            
            if($res){
                echo "Cancelamento registado com sucesso!";
                header("refresh:2;url=voltar.php");
            }else{
                echo "Erro ao registar cancelamento!";
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
    <h2>Cancelar Viagem</h2>
    <form action="cancelar_viagem.php" method="POST">
        <div class="mb-3">
            <label for="descricao" class="form-label">Descrição do Cancelamento</label>
            <textarea class="form-control" id="descricao" name="descricao" rows="4" required></textarea>
            <input type="hidden" name="id_viagem" value="<?php if (isset($_POST['id_viagem'])) { echo $_POST['id_viagem']; } ?>">
        </div>
        <button type="submit" class="btn btn-danger">Cancelar Viagem</button>
    </form>
</div>