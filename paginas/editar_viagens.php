<?php
session_start();
if ($_SESSION['nivel'] != 3) {
    header("Location: voltar.php");
    exit;
}

include '../basedados/basedados.h';


$sql = "
    SELECT v.*, r.nome_rota, ve.nome_veiculo 
    FROM viagem v
    JOIN rotas r ON v.id_rota = r.id_rota
    JOIN veiculos ve ON v.id_veiculo = ve.id_veiculo
    ORDER BY v.data DESC, v.hora_partida DESC
";

$result = mysqli_query($conn, $sql);
unset($_SESSION['id_viagem']);
?>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Editar de Viagens - FelixBus</title>
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
<h1>Editar de Viagens</h1>


<table class="table">
    <thead>
        <tr>
            <th>Rota</th>
            <th>Veículo</th>
            <th>Data</th>
            <th>Hora de Partida</th>
            <th>Hora de Chegada</th>
            <th>Vagas</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <?php
        if (mysqli_num_rows($result) > 0) {
            while ($row = mysqli_fetch_assoc($result)) {
                if ($row['estado_viagem']== 1){
                    $_SESSION['id_viagem'] = $row['id_viagem'];
                echo "<tr>";
                echo "<td>" . htmlspecialchars($row['nome_rota']) . "</td>";
                echo "<td>" . htmlspecialchars($row['nome_veiculo']) . "</td>";
                echo "<td>" . htmlspecialchars($row['data']) . "</td>";
                echo "<td>" . htmlspecialchars($row['hora_partida']) . "</td>";
                echo "<td>" . htmlspecialchars($row['hora_chegada']) . "</td>";
                echo "<td>" . htmlspecialchars($row['vagas']) . "</td>";
                echo "<td>";
                echo "<form action='processa_editar_viagens.php' method='POST'>";
                echo "<button type='submit' class='btn btn-primary'>Editar</button>";
                echo "</form>";
                echo "</td>";
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
