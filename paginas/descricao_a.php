<?php
  include '../basedados/basedados.h';
?>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Descrição do Alerta - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #e9ecef;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            background: #ffffff;
            margin-top: 40px;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            font-weight: bold;
            color: #343a40;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }

        thead th {
            background-color: #0d6efd;
            color: #fff;
            padding: 12px;
            text-align: center;
            font-size: 18px;
            border-radius: 8px 8px 0 0;
        }

        tbody td {
            padding: 15px;
            text-align: center;
            font-size: 16px;
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }

        tbody tr:hover {
            background-color: #e2e6ea;
        }

        .navbar-brand {
            font-weight: bold;
            letter-spacing: 0.07em;
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
                    <a class="nav-link" href="alertas.php">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.php">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <h1>Descrição do Alerta</h1>

    <table class="table">
        <thead>
            <tr>
                <th>Descrição</th>
            </tr>
        </thead>
        <tbody>
            <?php
                $id_alerta = isset($_POST['id_alerta']) ? intval($_POST['id_alerta']) : 0;
                $sql = "SELECT * FROM alertas WHERE id_alerta = $id_alerta";
                $result = mysqli_query($conn, $sql);

                while ($row = mysqli_fetch_assoc($result)) {
                    echo "<tr>";
                    echo "<td>" . htmlspecialchars($row['descricao']) . "</td>";
                    echo "</tr>";
                }
            ?>
        </tbody>
    </table>
</div>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
