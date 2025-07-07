<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>
<?php 
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        if (
            isset($_POST['descricao']) &&
            isset($_POST['id_rota']) &&
            isset($_POST['taxa_inicial']) &&
            isset($_POST['taxa_paragem'])
        ) {
            $id_rota = $_POST['id_rota'];
            $descricao = $_POST['descricao'];
            $taxa_inicial = $_POST['taxa_inicial'];
            $taxa_paragem = $_POST['taxa_paragem'];

            // Busca os valores atuais
            $sql_select = "SELECT taxa_inicial, taxa_paragem FROM rotas WHERE id_rota='$id_rota'";
            $result = mysqli_query($conn, $sql_select);
            if ($result && $row = mysqli_fetch_assoc($result)) {
                $nova_taxa_inicial = $row['taxa_inicial'] * $taxa_inicial;
                $nova_taxa_paragem = $row['taxa_paragem'] * $taxa_paragem;

                // Atualiza as taxas de desconto na viagem
                $sql = "UPDATE rotas SET taxa_inicial='$nova_taxa_inicial', taxa_paragem='$nova_taxa_paragem' WHERE id_rota='$id_rota'";
                $res = mysqli_query($conn, $sql);

                // Regista o alerta de desconto aplicado
                $sql2 = "INSERT INTO alertas (id_rota, id_viagem, descricao, tipo) VALUES ('$id_rota', NULL, '$descricao', '1')";
                $res2 = mysqli_query($conn, $sql2);

                if ($res && $res2) {
                    echo "Desconto aplicado com sucesso!";
                    header("refresh:2;url=voltar.php");
                } else {
                    echo "Erro ao aplicar desconto!";
                    header("refresh:2;url=voltar.php");
                }
            } else {
                echo "Rota não encontrada!";
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
                    <a class="nav-link" href="adicionar_promocao.php">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.php">Logout</a>
                </li>
               
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2>Aplicar Desconto</h2>
    <form action="aplicar_desconto.php" method="POST">
    <br><br>
        Taxa Inicial:

        <select name="taxa_inicial">
            <option value="1"></option>
            <option value="0.70">30%</option>
            <option value="0.50">50%</option>
            <option value="0.25">75%</option>
        </select>

        <br><br>
        Taxa por Paragem:

        <select name="taxa_paragem">
            <option value="1"></option>
            <option value="0.70">30%</option>
            <option value="0.50">50%</option>
            <option value="0.25">75%</option>
        </select>

        <br><br>


        <div class="mb-3">
            <label for="descricao" class="form-label">Descrição do Desconto</label>
            <textarea class="form-control" id="descricao" name="descricao" rows="4" required></textarea>
            <input type="hidden" name="id_rota" value="<?php if (isset($_POST['id_rota'])) { echo $_POST['id_rota']; } ?>">
        </div>
        <button type="submit" class="btn btn-danger">Aplicar Desconto</button>
    </form>
</div>