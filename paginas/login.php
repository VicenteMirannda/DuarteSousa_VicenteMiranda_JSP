<?php
session_start();
if (isset($_SESSION['nivel'])) {
  header('Location: voltar.php');
  exit;
}
include '../basedados/basedados.h';

if (isset($_POST['user']) && isset($_POST['pass'])) {
  $username = $_POST['user'];
  $password = $_POST['pass'];

  $query = "SELECT * FROM utilizadores WHERE nome_utilizador = '$username'";
  $result = mysqli_query($conn, $query);

  if (mysqli_num_rows($result)) {
    while ($registro = mysqli_fetch_assoc($result)) {
      if (password_verify($password, $registro['password'])) {
        $_SESSION['nivel'] = $registro['nivel_acesso'];
        $_SESSION['id_utilizador'] = $registro['id_utilizador'];

        if ($registro['nivel_acesso'] == 1) {
          header("refresh:2; url=menucliente.php");
          echo "<div class='alert alert-success text-center mt-3'>Bem vindo Cliente</div>";
        } elseif ($registro['nivel_acesso'] == 2) {
          header("refresh:2; url=menufuncionario.php");
          echo "<div class='alert alert-success text-center mt-3'>Bem vindo Funcionário</div>";
        } elseif ($registro['nivel_acesso'] == 3) {
          header("refresh:2; url=menuadmin.php");
          echo "<div class='alert alert-success text-center mt-3'>Bem vindo Administrador</div>";
        }
      } else {
        echo "<div class='alert alert-danger text-center mt-3'>Utilizador ou senha inválidos</div>";
      }
    }
  } else {
    echo "<div class='alert alert-danger text-center mt-3'>Utilizador ou senha inválidos</div>";
  }
}
?>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Login/Registar - FelixBus</title>
  <link href="bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />

  <style>
    body {
      background: #f8f9fa;
      margin: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }
    .login-container {
      max-width: 420px;
      background: rgba(255, 255, 255, 0.95);
      padding: 30px 40px;
      border-radius: 12px;
      box-shadow: 0 6px 20px rgba(0,0,0,0.1);
      margin: 40px auto;
    }
    .login-container h2 {
      font-weight: 600;
      margin-bottom: 30px;
      color: #212529;
      text-align: center;
    }
    .btn-primary {
      background-color: #0d6efd;
      border: none;
      font-weight: 600;
      transition: background-color 0.3s ease;
    }
    .btn-primary:hover {
      background-color: #0b5ed7;
    }
    a {
      color: #0d6efd;
      font-weight: 600;
      text-decoration: none;
    }
    a:hover {
      color: #0a58ca;
      text-decoration: underline;
    }
    input.form-control {
      padding: 12px 14px;
      font-size: 1rem;
      border-radius: 6px;
    }
  </style>
</head>
<body>

<!-- Navbar original sem alterações -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="voltar.php">FelixBus</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="consultar_rotas.php">Consultar Rotas</a></li>
        <?php
        $result = mysqli_query($conn, "SELECT COUNT(*) as total FROM alertas");
        $row = mysqli_fetch_assoc($result);
        if ($row['total'] > 0) {
          echo '<li class="nav-item">
              <a class="nav-link text-warning" href="alertas.php">Alertas <i class="bi bi-bell-fill"></i> <span class="badge bg-danger">'.$row['total'].'</span></a>
              </li>';
        }
        ?>
        <li class="nav-item"><a class="nav-link" href="localizacao.php">Localização</a></li>
        <li class="nav-item"><a class="nav-link" href="contactos.php">Contactos</a></li>
        <li class="nav-item"><a class="nav-link active" href="login.php">Login/Registar</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Container do login, centralizado com margin auto e espaçamento de 40px do topo -->
<div class="login-container shadow-sm">
  <h2>Login</h2>
  <form action="login.php" method="post" autocomplete="off" novalidate>
    <div class="mb-3">
      <label for="user" class="form-label">Utilizador</label>
      <input type="text" class="form-control" id="user" name="user" placeholder="Digite seu utilizador" required>
    </div>
    <div class="mb-4">
      <label for="pass" class="form-label">Senha</label>
      <input type="password" class="form-control" id="pass" name="pass" placeholder="Digite sua senha" required>
    </div>
    <button type="submit" class="btn btn-primary w-100">Login</button>
  </form>

  <p class="text-center mt-3 mb-0">
    Ainda não tem conta? <a href="registar.php">Registe-se</a>
  </p>
</div>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
