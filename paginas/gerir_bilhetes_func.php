<?php
  session_start();
if ($_SESSION['nivel'] != 1 && $_SESSION['nivel'] != 2) {
    header('Location: voltar.php');
    exit();
}
  include '../basedados/basedados.h';

$id_utilizador = $_SESSION['id_utilizador'];

// Buscar os bilhetes do utilizador
$query = "SELECT * FROM bilhete ";
$result = mysqli_query($conn, $query);
  
?>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <title>Gerir Bilhetes - FelixBus</title>
  <link href="bootstrap.min.css" rel="stylesheet">
<style>
  .top-button {
    margin: 30px 0;
    text-align: center;
  }

  .divider {
    border-top: 2px solid #ddd;
    margin-bottom: 30px;
  }

  .bilhete-card {
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    padding: 20px 25px;
    margin-bottom: 25px;
    transition: transform 0.2s ease;
  }

  .bilhete-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
  }

  .bilhete-card h5 {
    font-weight: 700;
    color:rgb(0, 0, 0);
    margin-bottom: 10px;
  }

  .bilhete-card p {
    font-size: 1.1rem;
    color: #333;
    margin-bottom: 15px;
  }

  .bilhete-card .btn {
    margin-right: 10px;
    min-width: 90px;
    font-weight: 600;
    border-radius: 6px;
  }

  .bilhete-card .btn-warning {
    background-color: #ffc107;
    border-color: #ffc107;
  }

  .bilhete-card .btn-warning:hover {
    background-color: #e0a800;
    border-color: #d39e00;
  }

  .bilhete-card .btn-danger {
    background-color: #dc3545;
    border-color: #dc3545;
  }

  .bilhete-card .btn-danger:hover {
    background-color: #bb2d3b;
    border-color: #b02a37;
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

<div class="container">

  <!-- Botão Adicionar Bilhete -->
  <div class="top-button">
    <a href="comprar_bilhete.php" class="btn btn-primary btn-lg">Comprar Bilhete</a>
  </div>

  <div class="divider"></div>

  <!-- Lista de Bilhetes -->
  <?php
  if (mysqli_num_rows($result) > 0) {
    while($bilhete = mysqli_fetch_assoc($result)) {

        $id_cliente = $bilhete['id_utilizador'];
        $query_cliente = "SELECT nome_utilizador FROM utilizadores WHERE id_utilizador = ?";
        $stmt = mysqli_prepare($conn, $query_cliente);
        mysqli_stmt_bind_param($stmt, "i", $id_cliente);
        mysqli_stmt_execute($stmt);
        mysqli_stmt_bind_result($stmt, $nome_cliente);
        mysqli_stmt_fetch($stmt);
        mysqli_stmt_close($stmt);

      echo '
      <div class="bilhete-card">
        <h5><strong>Destino:</strong> ' . htmlspecialchars($bilhete['cidade_destino']) . '</h5>
        <p><strong>Data:</strong> ' . htmlspecialchars($bilhete['data_viagem']) . '</p>
        <p><strong>Hora de partida:</strong> ' . htmlspecialchars($bilhete['hora']) . '</p>
        <p><strong>Cliente:</strong> ' . htmlspecialchars($nome_cliente) . '</p>

        <div class="mt-3">
          <a href="alterar_bilhete.php?id=' . urlencode($bilhete['id_bilhete']) . '" class="btn btn-warning btn-sm">Alterar</a>
          <a href="anular_bilhete.php?id=' . urlencode($bilhete['id_bilhete']) . '" class="btn btn-danger btn-sm" onclick="return confirm(\'Tem a certeza que quer anular este bilhete?\')">Anular</a>
        </div>
      </div>';

      
    }
  } else {
    echo '<div class="alert alert-info text-center">Não tem bilhetes registados.</div>';
  }
  ?>

</div>
<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
