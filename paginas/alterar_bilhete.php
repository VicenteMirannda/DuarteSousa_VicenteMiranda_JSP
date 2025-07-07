<?php
session_start();
include '../basedados/basedados.h';

if ($_SESSION['nivel'] != 1 && $_SESSION['nivel'] != 2) {
    header('Location: voltar.php');
    exit();
}

$id_bilhete = $_GET['id'] ?? null;

if (!$id_bilhete) {
    echo "<script>alert('ID do bilhete inválido.'); window.location.href='voltar.php';</script>";
    exit();
}




$sql = "SELECT * FROM bilhete WHERE id_bilhete = $id_bilhete";
$result = mysqli_query($conn, $sql);

if (!$result || mysqli_num_rows($result) == 0) {
    echo "<script>alert('Bilhete não encontrado.'); window.location.href='voltar.php';</script>";
    exit();
}




?>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <title>Gerir Bilhetes - FelixBus</title>
  <link href="bootstrap.min.css" rel="stylesheet">

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

 

 

  <!-- Lista de Bilhetes -->
  <?php
  if (mysqli_num_rows($result) > 0) {
    while($bilhete = mysqli_fetch_assoc($result)) {
    ?>
    <form action="atualizar_bilhete.php" method="post" class="mt-4 mx-auto" style="max-width: 500px;">
      <input type="hidden" name="id_bilhete" value="<?php echo intval($bilhete['id_bilhete']); ?>">

    <div class="mb-3">
      <label for="cidade_origem" class="form-label"><strong>Cidade de Origem:</strong></label>
    <select class="form-control" id="cidade_origem" name="cidade_origem" required>
<?php
$id_viagem = $bilhete['id_viagem'];

// Buscar cidades da rota associada à viagem
$sql_cidades = "
  SELECT c.nome_cidade as nome
  FROM viagem v
  JOIN rotas r ON v.id_rota = r.id_rota
  JOIN rotas_cidade cr ON r.id_rota = cr.id_rota
  JOIN cidades c ON cr.id_cidade = c.id_cidade
  WHERE v.id_viagem = " . intval($id_viagem) . "
  ORDER BY cr.num_paragem ASC
";
$result_cidades = mysqli_query($conn, $sql_cidades);

if ($result_cidades && mysqli_num_rows($result_cidades) > 0) {
  while ($cidade = mysqli_fetch_assoc($result_cidades)) {
    $selected = ($cidade['nome'] === $bilhete['cidade_origem']) ? 'selected' : '';
    echo '<option value="' . htmlspecialchars($cidade['nome']) . '" ' . $selected . '>' . htmlspecialchars($cidade['nome']) . '</option>';
  }
} else {
  echo '<option value="">Nenhuma cidade encontrada</option>';
}
?>
</select>

    </div>
    <div class="mb-3">
        <label for="cidade_destino" class="form-label"><strong>Cidade de Destino:</strong></label>
        <select class="form-control" id="cidade_destino" name="cidade_destino" required>
            <?php
            // Buscar cidades da rota associada à viagem (mesmo que para origem)
            $sql_cidades_destino = "
                SELECT c.nome_cidade as nome
                FROM viagem v
                JOIN rotas r ON v.id_rota = r.id_rota
                JOIN rotas_cidade cr ON r.id_rota = cr.id_rota
                JOIN cidades c ON cr.id_cidade = c.id_cidade
                WHERE v.id_viagem = " . intval($id_viagem) . "
                ORDER BY cr.num_paragem ASC
            ";
            $result_cidades_destino = mysqli_query($conn, $sql_cidades_destino);

            if ($result_cidades_destino && mysqli_num_rows($result_cidades_destino) > 0) {
                while ($cidade = mysqli_fetch_assoc($result_cidades_destino)) {
                    $selected = ($cidade['nome'] === $bilhete['cidade_destino']) ? 'selected' : '';
                    echo '<option value="' . htmlspecialchars($cidade['nome']) . '" ' . $selected . '>' . htmlspecialchars($cidade['nome']) . '</option>';
                }
            } else {
                echo '<option value="">Nenhuma cidade encontrada</option>';
            }
            ?>
        </select>
    </div>
      <div class="mb-3">
        <label for="data_viagem" class="form-label"><strong>Data da Viagem:</strong></label>
        <input type="date" class="form-control" id="data_viagem" name="data_viagem" value="<?php echo htmlspecialchars($bilhete['data_viagem']); ?>" required>
      </div>
      <div class="mb-3">
        <label for="hora" class="form-label"><strong>Hora de Partida:</strong></label>
        <input type="time" class="form-control" id="hora" name="hora" value="<?php echo htmlspecialchars($bilhete['hora']); ?>" required>
      </div>
      <button type="submit" class="btn btn-primary">Alterar Bilhete</button>
    </form>
    <?php

      
    }
  } 
  ?>

</div>
<script src="bootstrap.bundle.min.js"></script>
</body>
</html>

