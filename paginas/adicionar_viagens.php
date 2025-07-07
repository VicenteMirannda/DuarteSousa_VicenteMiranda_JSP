<?php
session_start();
if ($_SESSION['nivel'] != 3) {
    header("Location: voltar.php");
    exit;
}

include '../basedados/basedados.h';
?>

<?php


if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $id_rota = (int) $_POST['id_rota'];
    $id_veiculo = (int) $_POST['id_veiculo'];
    $data =  $_POST['data'];
    $hora_partida = $_POST['hora_partida'];
    $hora_chegada =  $_POST['hora_chegada'];
    $vagas = (int) $_POST['vagas'];

    $sql = "INSERT INTO viagem (id_rota, id_veiculo, data, hora_partida, hora_chegada, vagas, estado_viagem) 
            VALUES ($id_rota, $id_veiculo, '$data', '$hora_partida', '$hora_chegada', $vagas, 1)";

    if (mysqli_query($conn, $sql)) {
        echo "<div style='padding:20px;'><h3>Viagem adicionada com sucesso!</h3>";
    } else {
        echo "<p>Erro ao adicionar viagem: " . mysqli_error($conn) . "</p>";
    }
}

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
        .content-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        h1 {
            text-align: center;
            margin-bottom: 25px;
            font-size: 24px;
        }
        .btn-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
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

<div class="content-container">
    <h1>Adicionar Viagem</h1>

    <form method="POST" action="adicionar_viagens.php">
        <div class="mb-3">
            <label class="form-label">Rota:</label>
            <select name="id_rota" class="form-select" required>
                <?php
                $rotas = mysqli_query($conn, "SELECT id_rota, nome_rota FROM rotas");
                while ($rota = mysqli_fetch_assoc($rotas)) {
                    echo "<option value='{$rota['id_rota']}'>{$rota['nome_rota']}</option>";
                }
                ?>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Veículo:</label>
            <select name="id_veiculo" class="form-select" required>
                <?php
                $veiculos = mysqli_query($conn, "SELECT id_veiculo, nome_veiculo FROM veiculos");
                while ($v = mysqli_fetch_assoc($veiculos)) {
                    echo "<option value='{$v['id_veiculo']}'>{$v['nome_veiculo']}</option>";
                }
                ?>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Data:</label>
            <input type="date" name="data" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Hora de Partida:</label>
            <input type="time" name="hora_partida" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Hora de Chegada:</label>
            <input type="time" name="hora_chegada" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Número de Vagas:</label>
            <input type="number" name="vagas" class="form-control" required>
        </div>

        <div class="btn-container">
            <a href="gestao_viagens.php" class="btn btn-secondary">Voltar</a>
            <button type="submit" class="btn btn-success">Adicionar Viagem</button>
        </div>
    </form>
</div>

</body>
</html>