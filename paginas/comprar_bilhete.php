<?php
session_start();
include '../basedados/basedados.h';

if ($_SESSION['nivel'] != 1 && $_SESSION['nivel'] != 2) {
    header('Location: voltar.php');
    exit();
}

$id_utilizador = $_SESSION['id_utilizador'];


?>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <title>Comprar Bilhete - FelixBus</title>
  <link href="bootstrap.min.css" rel="stylesheet">
  <style>
    .form-container {
      max-width: 500px;
      background: #ffffff;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      margin-top: 50px;
    }

    .top-title {
      margin-top: 40px;
      text-align: center;
    }
  </style>
</head>
<body>

<!-- Navbar -->
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

<!-- Conteúdo -->
<div class="container d-flex justify-content-center">
  <div class="form-container">
    <h3 class="text-center mb-4">Comprar Bilhete</h3>

    <?php if (isset($erro)): ?>
      <div class="alert alert-danger"><?php echo $erro; ?></div>
    <?php endif; ?>

    <form method="post" action="processa_bilhete.php">

      <div class="mb-3">
        <label for="Origem" class="form-label">Origem</label>
        <input type="text" class="form-control" id="origem" name="origem" required>
      </div>
      <div class="mb-3">
        <label for="destino" class="form-label">Destino</label>
        <input type="text" class="form-control" id="destino" name="destino" required>
      </div>
      <div class="mb-3">
        <label for="data_viagem" class="form-label">Data da Viagem</label>
        <input type="date" class="form-control" id="data_viagem" name="data_viagem" required>
      </div>
      
      <button type="submit" class="btn btn-success w-100">Comprar</button>
    </form>
  </div>
</div>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
