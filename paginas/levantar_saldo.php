<?php
    session_start();
    if (!isset($_SESSION['nivel'])) {
        header('Location: voltar.php');
        exit();
}
    include '../basedados/basedados.h';

?>
<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Recebe os dados do formulário de confirmação de identidade
        $username = $_POST['username'] ?? '';
        $password = $_POST['password'] ?? '';
        $valor = (float) ($_POST['valor'] ?? 0);

        if ($valor > 0 && !empty($username) && !empty($password)) {
                // Verifica se o utilizador existe e a password está correta
                $username = mysqli_real_escape_string($conn, $username);
                $password = mysqli_real_escape_string($conn, $password);

                $sql = "SELECT id_utilizador, password FROM utilizadores WHERE nome_utilizador = '$username'";
                $result = mysqli_query($conn, $sql);

                if ($result && mysqli_num_rows($result) === 1) {
                        $row = mysqli_fetch_assoc($result);
                        // Supondo que a password está guardada em texto simples (não recomendado)
                        if (password_verify($password, $row['password'])) {
                                $id_utilizador = $row['id_utilizador'];
                                // Verifica saldo atual
                                $sql_saldo = "SELECT saldo FROM carteiras WHERE id_utilizador = $id_utilizador";
                                $res_saldo = mysqli_query($conn, $sql_saldo);
                                if ($res_saldo && $row_saldo = mysqli_fetch_assoc($res_saldo)) {
                                        if ($row_saldo['saldo'] >= $valor) {
                                                $sql_update = "UPDATE carteiras SET saldo = saldo - $valor WHERE id_utilizador = $id_utilizador";
                                                if (mysqli_query($conn, $sql_update)) {
                                                        echo "<div style='padding:20px;'><h3>Levantamento efetuado com sucesso!</h3></div>";
                                                        $id_carteira_query = "SELECT id_carteira FROM carteiras WHERE id_utilizador = $id_utilizador";
                                                        $id_carteira_result = mysqli_query($conn, $id_carteira_query);
                                                        if ($id_carteira_result && mysqli_num_rows($id_carteira_result) === 1) {
                                                                $carteira_row = mysqli_fetch_assoc($id_carteira_result);
                                                                $id_carteira = $carteira_row['id_carteira'];
                                                                $id_utilizador_sessao = $_SESSION['id_utilizador'];
                                                                $sql_insert_estrato = "INSERT INTO estratos_bancarios (id_carteira, id_utilizador, data_transacao, valor, tipo_transacao) VALUES ($id_carteira, $id_utilizador_sessao, NOW(), $valor, 0)";
                                                                mysqli_query($conn, $sql_insert_estrato);
                                                        }
                                                        header("refresh:2;url=voltar.php");
                                                        exit();
                                                } else {
                                                        echo "<p>Erro ao levantar saldo: " . mysqli_error($conn) . "</p>";
                                                }
                                        } else {
                                                echo "<p>Saldo insuficiente para levantar esse valor.</p>";
                                        }
                                } else {
                                        echo "<p>Erro ao obter saldo.</p>";
                                }
                        } else {
                                echo "<p>Nome de utilizador ou password incorretos.</p>";
                        }
                } else {
                        echo "<p>Nome de utilizador ou password incorretos.</p>";
                }
        } else {
                echo "<p>Preencha todos os campos e insira um valor positivo.</p>";
        }
}
?>

<!DOCTYPE html>
<html lang="pt">
<head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Levantar Saldo - FelixBus</title>
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
        <h1>Levantar Saldo</h1>

                        <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
                        
                        <form action = "levantar_saldo.php" method = "POST">
                            <div class="mb-3">
                                <label for="valor" class="form-label">Valor</label>
                                <input type="number" class="form-control" id="valor" name="valor" min="0.01" step="0.01" required>
                            </div>
                            <hr>
                            <p class="text-center fw-bold">Confirmação de identidade</p>
                            <div class="mb-3">
                                <label for="username" class="form-label">Nome de Utilizador</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Levantar</button>
                        </form>
                    </div>

        </div>