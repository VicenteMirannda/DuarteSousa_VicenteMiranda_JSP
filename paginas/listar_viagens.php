<?php
session_start();
if ($_SESSION['nivel'] != 3) {
    header("Location: voltar.php");
    exit;
}

include '../basedados/basedados.h';


// Filtros
$rota = mysqli_real_escape_string($conn, $_GET['rota'] ?? '');
$veiculo = mysqli_real_escape_string($conn, $_GET['veiculo'] ?? '');
$data = mysqli_real_escape_string($conn, $_GET['data'] ?? '');
$ordenar = $_GET['ordenar'] ?? '';

$where = "WHERE v.estado_viagem = 1";

if ($rota !== '') {
    $where .= " AND r.nome_rota LIKE '%$rota%'";
}
if ($veiculo !== '') {
    $where .= " AND ve.nome_veiculo LIKE '%$veiculo%'";
}
if ($data !== '') {
    $where .= " AND v.data = '$data'";
}

// Ordenação
switch ($ordenar) {
    case 'data':
        $orderBy = "ORDER BY v.data DESC";
        break;
    case 'hora_partida':
        $orderBy = "ORDER BY v.hora_partida DESC";
        break;
    case 'vagas':
        $orderBy = "ORDER BY v.vagas DESC"; 
        break;
    default:
        $orderBy = "ORDER BY v.data DESC, v.hora_partida DESC";
        break;
}

$sql = "
    SELECT v.*, r.nome_rota, ve.nome_veiculo 
    FROM viagem v
    JOIN rotas r ON v.id_rota = r.id_rota
    JOIN veiculos ve ON v.id_veiculo = ve.id_veiculo
    $where
    $orderBy
";

$result = mysqli_query($conn, $sql);


?>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lista de Viagens - FelixBus</title>
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
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="voltar.php">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">

                <li class="nav-item">
                    <a class="nav-link" href="gestao_viagens.php">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.php">Logout</a>
                </li>
               
            </ul>
        </div>
    </div>
</nav>
<br>
<div class="container">
<h1>Listar Viagens</h1>

<br>
<form method="GET" class="row g-3 mb-4">
    <div class="col-md-3">
        <label for="rota" class="form-label">Rota</label>
        <input type="text" class="form-control" id="rota" name="rota" value="<?= htmlspecialchars($_GET['rota'] ?? '') ?>">
    </div>
    <div class="col-md-3">
        <label for="veiculo" class="form-label">Veículo</label>
        <input type="text" class="form-control" id="veiculo" name="veiculo" value="<?= htmlspecialchars($_GET['veiculo'] ?? '') ?>">
    </div>
    <div class="col-md-3">
        <label for="data" class="form-label">Data</label>
        <input type="date" class="form-control" id="data" name="data" value="<?= htmlspecialchars($_GET['data'] ?? '') ?>">
    </div>
    <div class="col-md-3">
        <label for="ordenar" class="form-label">Ordenar por</label>
        <select class="form-select" name="ordenar">
            <option value="">Padrão</option>
            <option value="data" <?= ($_GET['ordenar'] ?? '') == 'data' ? 'selected' : '' ?>>Data</option>
            <option value="hora_partida" <?= ($_GET['ordenar'] ?? '') == 'hora_partida' ? 'selected' : '' ?>>Hora de Partida</option>
            <option value="vagas" <?= ($_GET['ordenar'] ?? '') == 'vagas' ? 'selected' : '' ?>>Vagas</option>
        </select>
    </div>
    <div class="col-md-12">
        <button type="submit" class="btn btn-primary">Filtrar</button>
        <a href="listar_viagens.php" class="btn btn-secondary">Limpar</a>
    </div>
</form>

<br>


<table class="table">
    <thead>
        <tr>
            <th>Rota</th>
            <th>Veículo</th>
            <th>Data</th>
            <th>Hora de Partida</th>
            <th>Hora de Chegada</th>
            <th>Vagas</th>
        </tr>
    </thead>
    <tbody>
        <?php
        if (mysqli_num_rows($result) > 0) {
            while ($row = mysqli_fetch_assoc($result)) {
                if ($row['estado_viagem']== 1){
                echo "<tr>";
                echo "<td>" . htmlspecialchars($row['nome_rota']) . "</td>";
                echo "<td>" . htmlspecialchars($row['nome_veiculo']) . "</td>";
                echo "<td>" . htmlspecialchars($row['data']) . "</td>";
                echo "<td>" . htmlspecialchars($row['hora_partida']) . "</td>";
                echo "<td>" . htmlspecialchars($row['hora_chegada']) . "</td>";
                echo "<td>" . htmlspecialchars($row['vagas']) . "</td>";
                echo "</tr>";
            }
        }
        } else {
            echo "<tr><td colspan='6'>Nenhuma viagem encontrada.</td></tr>";
        }
        ?>
    </tbody>
</table>
</div>
</body>
</html>
