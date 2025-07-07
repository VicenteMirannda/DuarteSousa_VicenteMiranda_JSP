<?php
  session_start();
if (!isset($_SESSION['nivel'])) {
    header('Location: voltar.php');
    exit();
}
  include '../basedados/basedados.h';

$saldo = 0;

// Verifica se foi enviado um ID via POST, senão usa o da sessão
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['id_utilizador'])) {
    $id = $_POST['id_utilizador'];
} else {
    $id = $_SESSION['id_utilizador'];
}

// Consulta para obter o saldo do utilizador    
$sql = "SELECT saldo FROM carteiras WHERE id_utilizador = '$id'";
$result = mysqli_query($conn, $sql);    
if ($result && mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    $saldo = $row['saldo'];
} else {
    // Se não houver saldo, inicializa como 0
    $saldo = 0;
}
  
?>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gestão da Carteira - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
        }

        .carteira-container {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .carteira-box {
            background: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            width: 100%;
        }

        .saldo-info {
            font-size: 22px;
            color: #343a40;
        }

        .saldo-valor {
            font-size: 32px;
            color: #007bff;
            font-weight: bold;
        }

        .btn-menu {
            padding: 15px;
            font-size: 16px;
            width: 100%;
        }
       
        @media (max-width: 768px) {
            .row.align-items-center {
                flex-direction: column;
                text-align: center;
            }

            .saldo-info, .btn-menu {
                margin-top: 20px;
            }
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

<!-- Área da Carteira -->
<div class="container carteira-container">
    <div class="carteira-box">
        <div class="row align-items-center">
            <!-- Lado esquerdo: Saldo -->
            <div class="col-md-6 mb-4 mb-md-0">
                <div class="saldo-info">Saldo atual:</div>
                <div class="saldo-valor">€<?= number_format($saldo, 2, ',', '.') ?></div>
            </div>

            <!-- Lado direito: Botões -->
            <div class="col-md-6">
                <div class="d-grid gap-3">
                    <a href="adicionar_saldo.php" class="btn btn-primary btn-menu" >Adicionar Saldo</a>
                    <a href="levantar_saldo.php" class="btn btn-primary btn-menu" >Levantar Saldo</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
