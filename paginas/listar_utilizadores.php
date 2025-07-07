<?php
session_start();
if ($_SESSION['nivel'] != 3) {
    header('Location: voltar.php');
    exit;
}

include '../basedados/basedados.h';

// Inicializa variáveis
$pesquisa = $_POST['pesquisa'] ?? '';
$nivel = $_POST['nivel'] ?? '';
$ordenar = $_POST['ordenar'] ?? '';

// Construção da query base
$sql = "
    SELECT u.*, n.descricao AS nivel, c.saldo
    FROM utilizadores u
    JOIN nivel_acesso n ON u.nivel_acesso = n.nivel_acesso
    LEFT JOIN carteiras c ON u.id_utilizador = c.id_utilizador
    WHERE 1
";


// Filtro por nome
if (!empty($pesquisa)) {
    $pesquisa_esc = mysqli_real_escape_string($conn, $pesquisa);
    $sql .= " AND u.nome_utilizador LIKE '%$pesquisa_esc%'";
}

// Filtro por nível de acesso
if (!empty($nivel)) {
    $nivel_esc = (int)$nivel;
    $sql .= " AND u.nivel_acesso = $nivel_esc";
}

// Ordenação
if ($ordenar == 'saldo') {
    $sql .= " ORDER BY c.saldo DESC";
} elseif ($ordenar == 'data_nasc') {
    $sql .= " ORDER BY u.data_nasc DESC";
}

// Executa a query
$result = mysqli_query($conn, $sql);
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
                    <a class="nav-link" href="gestao_utilizadores.php">Voltar</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.php">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <br>
    <h1>Utilizadores</h1>
    <br>

    <!-- Formulário de Filtro -->
    <form method="POST" action="listar_utilizadores.php" class="row g-3 mb-4">
        <div class="col-md-4">
            <input type="text" class="form-control" name="pesquisa" placeholder="Pesquisar por nome" value="<?= $_POST['pesquisa'] ?? '' ?>">
        </div>

        <div class="col-md-3">
            <select class="form-select" name="nivel">
                <option value="">Todos os níveis</option>
                <?php
                $nivel_sql = "SELECT * FROM nivel_acesso";
                $nivel_result = mysqli_query($conn, $nivel_sql);
                while ($n = mysqli_fetch_assoc($nivel_result)) {
                    $selected = ($_POST['nivel'] ?? '') == $n['nivel_acesso'] ? 'selected' : '';
                    echo "<option value='{$n['nivel_acesso']}' $selected>{$n['descricao']}</option>";
                }
                ?>
            </select>
        </div>

        <div class="col-md-3">
            <select class="form-select" name="ordenar">
                <option value="">Ordenar por</option>
                <option value="saldo" <?= ($_POST['ordenar'] ?? '') == 'saldo' ? 'selected' : '' ?>>Saldo</option>
                <option value="data_nasc" <?= ($_POST['ordenar'] ?? '') == 'data_nasc' ? 'selected' : '' ?>>Data de Nascimento</option>
            </select>
        </div>

        <div class="col-md-2">
            <button type="submit" class="btn btn-primary w-100">Filtrar</button>
        </div>
    </form>

    <!-- Tabela de Resultados -->
    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>Nome do Utilizador</th>
                <th>Email</th>
                <th>Data Nascimento</th>
                <th>Nível de Acesso</th>
                <th>Saldo</th>
            </tr>
        </thead>
        <tbody>
            <?php
            if (mysqli_num_rows($result) > 0) {
                while ($row = mysqli_fetch_assoc($result)) {
                    echo "<tr>";
                    echo "<td>" . htmlspecialchars($row['nome_utilizador']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['email']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['data_nasc']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['nivel']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['saldo']) . " €</td>";
                    echo "</tr>";
                }
            } else {
                echo "<tr><td colspan='5'>Nenhum utilizador encontrado.</td></tr>";
            }
            ?>
        </tbody>
    </table>
    <br>
</div>

</body>
</html>
