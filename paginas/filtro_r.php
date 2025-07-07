<?php


include '../basedados/basedados.h';

// Recolher dados do formulário (POST)
$nome_rota = isset($_POST['nome_rota']) ? $_POST['nome_rota'] : '';
$min_paragens = isset($_POST['min_paragens']) ? (int) $_POST['min_paragens'] : '';
$ordenar_por = isset($_POST['ordenar_por']) && in_array($_POST['ordenar_por'], ['nome_rota', 'taxa_inicial', 'num_paragens']) ? $_POST['ordenar_por'] : 'nome_rota';
$ordem = (isset($_POST['ordem']) && $_POST['ordem'] === 'DESC') ? 'DESC' : 'ASC';

// Construir a query com base nos filtros
$sql = "SELECT * FROM rotas WHERE 1=1";

if (!empty($nome_rota)) {
    $sql .= " AND nome_rota LIKE '%$nome_rota%'";
}
if ($min_paragens !== '') {
    $sql .= " AND num_paragens >= $min_paragens";
}

$sql .= " ORDER BY $ordenar_por $ordem";


$result = mysqli_query($conn, $sql);
?>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Filtrar Rotas - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <br>
    <h1>Resultado da filtragem de Rotas</h1>
    <a href="listar_rotas.php" class="btn btn-secondary">Voltar</a>
    <br><br>

    <table class="table">
        <thead>
            <tr>
                <th>Rota</th>
                <th>Taxa Inicial</th>
                <th>Taxa por Paragem</th>
                <th>Nº de Paragens</th>
            </tr>
        </thead>
        <tbody>
            <?php
            if (mysqli_num_rows($result) > 0) {
                while ($row = mysqli_fetch_assoc($result)) {
                    echo "<tr>";
                    echo "<td>" . htmlspecialchars($row['nome_rota']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['taxa_inicial']) . " €</td>";
                    echo "<td>" . htmlspecialchars($row['taxa_paragem']) . " €</td>";
                    echo "<td>" . htmlspecialchars($row['num_paragens']) . "</td>";
                    echo "</tr>";
                }
            } else {
                echo "<tr><td colspan='4'>Nenhuma rota encontrada com os filtros aplicados.</td></tr>";
            }
            ?>
        </tbody>
    </table>
</div>
</body>
</html>
