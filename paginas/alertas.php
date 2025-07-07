<?php
include '../basedados/basedados.h';

// Lógica de filtro e ordenação
$ordenar_por = isset($_POST['ordenar_por']) ? $_POST['ordenar_por'] : '';

$sql = "SELECT a.*, t.descricao AS tipo_descricao, r.nome_rota 
        FROM alertas a
        LEFT JOIN tipo_alerta t ON a.tipo = t.id_tipo
        LEFT JOIN rotas r ON a.id_rota = r.id_rota";

// Aplicar ordenação
if (!empty($ordenar_por)) {
    $ordenar_por = mysqli_real_escape_string($conn, $ordenar_por);
    $sql .= " ORDER BY CASE 
                WHEN t.descricao = '$ordenar_por' THEN 0
                ELSE 1
              END, t.descricao ASC";
}

$result = mysqli_query($conn, $sql);

// Contar alertas para navbar
$total_alertas = mysqli_num_rows(mysqli_query($conn, "SELECT * FROM alertas"));
?>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Alertas - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        /* estilos iguais aos anteriores (mantidos para consistência visual) */
        body {
            background-color: #e9ecef;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            background: #fff;
            margin-top: 40px;
            margin-bottom: 40px;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            font-weight: 700;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
        }

        thead th {
            background-color: #0d6efd;
            color: #fff;
            padding: 12px 15px;
            text-align: center;
        }

        tbody tr {
            background-color: #f8f9fa;
        }

        tbody td {
            padding: 15px;
            text-align: center;
        }

        form button {
            width: 100%;
        }

        .navbar-brand {
            font-weight: 700;
            letter-spacing: 0.08em;
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="voltar.php">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="consultar_rotas.php">Consultar Rotas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-warning" href="alertas.php">
                        Alertas <i class="bi bi-bell-fill"></i>
                        <span class="badge bg-danger"><?= $total_alertas ?></span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="localizacao.php">Localização</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="contactos.php">Contactos</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="login.php">Login/Registar</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- CONTEÚDO -->
<div class="container">
    <h1>Alertas</h1>

    <!-- FORMULÁRIO DE FILTRO -->
    <form method="post" class="mb-5">
        <label for="ordenar_por" class="form-label fw-semibold">Filtrar por tipo de alerta:</label>
        <select name="ordenar_por" id="ordenar_por" class="form-select">
            <option value="">Todos</option>
            <option value="promocoes" <?= $ordenar_por == 'promocoes' ? 'selected' : '' ?>>Promoções</option>
            <option value="altera_horario" <?= $ordenar_por == 'altera_horario' ? 'selected' : '' ?>>Alteração de Horários</option>
            <option value="cancelamento" <?= $ordenar_por == 'cancelamento' ? 'selected' : '' ?>>Cancelamento</option>
        </select>
        <button type="submit" class="btn btn-primary mt-3">Aplicar Filtro</button>
    </form>

    <!-- TABELA DE ALERTAS -->
    <table class="table table-striped">
        <thead>
            <tr>
                
                <th>Rota</th>
                <th>ID Viagem</th>
                <th>Tipo</th>
                <th>Descrição</th>
            </tr>
        </thead>
        <tbody>
            <?php if (mysqli_num_rows($result) > 0): ?>
                <?php while ($row = mysqli_fetch_assoc($result)): ?>
                    <tr>
                        
                        <td><?= htmlspecialchars($row['nome_rota']) ?></td>
                        <td><?= htmlspecialchars($row['id_viagem']) ?></td>
                        <td><?= htmlspecialchars($row['tipo_descricao']) ?></td>
                        <td>
                            <form method="POST" action="descricao_a.php">
                                <input type="hidden" name="id_alerta" value="<?= htmlspecialchars($row['id_alerta']) ?>">
                                <button type="submit" class="btn btn-outline-primary btn-sm">Ver Descrição</button>
                            </form>
                        </td>
                    </tr>
                <?php endwhile; ?>
            <?php else: ?>
                <tr><td colspan="5">Nenhum alerta encontrado.</td></tr>
            <?php endif; ?>
        </tbody>
    </table>
</div>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
