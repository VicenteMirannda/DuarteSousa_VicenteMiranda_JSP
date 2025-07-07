<?php
session_start();
include '../basedados/basedados.h';

if ($_SESSION['nivel'] != 1  && $_SESSION['nivel'] != 2) {
    header('Location: voltar.php');
    exit();
}

$origem = $_POST['origem'] ?? null;
$destino = $_POST['destino'] ?? null;
$data_viagem = $_POST['data_viagem'] ?? null;


if ($origem && $destino && $data_viagem) {
$sql = "SELECT
  v.id_viagem,
  r.nome_rota,
  v.data,
  v.hora_partida,
  v.hora_chegada,
  co.nome_cidade AS origem,
  cd.nome_cidade AS destino,
  r.taxa_inicial + (ABS(rcd.num_paragem - rco.num_paragem) * r.taxa_paragem) AS preco_estimado
FROM viagem v
JOIN rotas r ON v.id_rota = r.id_rota
JOIN rotas_cidade rco ON rco.id_rota = v.id_rota
JOIN rotas_cidade rcd ON rcd.id_rota = v.id_rota
JOIN cidades co ON rco.id_cidade = co.id_cidade
JOIN cidades cd ON rcd.id_cidade = cd.id_cidade
WHERE v.data = '$data_viagem'
  AND co.nome_cidade = '$origem'
  AND cd.nome_cidade = '$destino'
  AND rco.num_paragem < rcd.num_paragem
  AND v.estado_viagem = 1
  AND v.vagas > 0
ORDER BY v.hora_partida" ;

}

?>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <title>Comprar Bilhete - FelixBus</title>
  <link href="bootstrap.min.css" rel="stylesheet">
  <style>
    .form-container {
      max-width: 1000px;
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

   

    <form method="post" action="executa_compra.php">
    <?php
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        die("Erro na preparação da consulta: " . $conn->error);
    }
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0): ?>
        <table class="table table-bordered align-middle">
            <thead>
                <tr>
                    
                    <th>Rota</th>
                    <th>Data</th>
                    <th>Partida</th>
                    <th>Chegada</th>
                    <th>Origem</th>
                    <th>Destino</th>
                    <th>Preço</th>
                    <th>Comprar</th>
                    
                </tr>
            </thead>
            <tbody>
            <?php while($row = $result->fetch_assoc()): ?>
                <tr>
                    
                    <td><?php echo htmlspecialchars($row['nome_rota']); ?></td>
                    <td><?php echo htmlspecialchars($row['data']); ?></td>
                    <td><?php echo htmlspecialchars($row['hora_partida']); ?></td>
                    <td><?php echo htmlspecialchars($row['hora_chegada']); ?></td>
                    <td><?php echo htmlspecialchars($row['origem']); ?></td>
                    <td><?php echo htmlspecialchars($row['destino']); ?></td>
                    <td><?php echo htmlspecialchars($row['preco_estimado']); ?> €</td>

                   <td> <button type="submit" name="id_viagem" value="<?php echo $row['id_viagem']; ?>" class="btn btn-success btn-sm">
                            Comprar
                        </button>
                        <input type="hidden" name="origem" value="<?php echo $row['origem']; ?>">
                        <input type="hidden" name="destino" value="<?php echo $row['destino']; ?>">
                        <input type="hidden" name="data" value="<?php echo $row['data']; ?>">
                        <input type="hidden" name="preco" value="<?php echo $row['preco_estimado']; ?>"> </td>
                </tr>
            <?php endwhile; ?>
            </tbody>
        </table>
        
    <?php else: ?>
        <div class="alert alert-warning text-center">Nenhum bilhete encontrado para os critérios selecionados.</div>
    <?php endif;

    $stmt->close();
    $conn->close();
    ?>
</form>

  </div>
</div>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
