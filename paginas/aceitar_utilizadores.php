<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>

<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['id_utilizador'])) {
    // Obter o utilizador da tabela registos
    $id_registo = intval($_POST['id_utilizador']);
    $sql = "SELECT * FROM registos WHERE id_registo = $id_registo";
    $res = mysqli_query($conn, $sql);

    if ($row = mysqli_fetch_assoc($res)) {
        // Inserir na tabela utilizadores
        $nome = mysqli_real_escape_string($conn, $row['nome_utilizador']);
        $email = mysqli_real_escape_string($conn, $row['email']);
        $data_nasc = mysqli_real_escape_string($conn, $row['data_nasc']);
        $password = mysqli_real_escape_string($conn, $row['password']);

        $sql_insert = "INSERT INTO utilizadores (nome_utilizador, email, data_nasc, password, nivel_acesso) 
                       VALUES ('$nome', '$email', '$data_nasc', '$password', 1)";
        if (mysqli_query($conn, $sql_insert)) {
            $id_utilizador = mysqli_insert_id($conn);

            // Criar carteira com saldo 0
            $sql_carteira = "INSERT INTO carteiras (id_utilizador, saldo) VALUES ($id_utilizador, 0)";
            mysqli_query($conn, $sql_carteira);

            // Remover da tabela registos
            $sql_delete = "DELETE FROM registos WHERE id_registo = $id_registo";
            mysqli_query($conn, $sql_delete);

            // Redirecionar para a própria página após aceitar
            header("Location: aceitar_utilizadores.php");
            exit;
        } else {
            // Em caso de erro, redirecionar para voltar.php
            header("Location: voltar.php");
            exit;
        }
    } else {
        // Em caso de erro, redirecionar para voltar.php
        header("Location: voltar.php");
        exit;
    }
}
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

    <table class="table">
      <thead>
          <tr>
              <th>Nome do Utilizador</th>
              <th>Email</th>
              <th>Data Nascimento</th>
              
             
              
          </tr>
      </thead>
      <tbody>
          <?php
          
          include '../basedados/basedados.h';
          $sql = "SELECT * FROM registos";
          $result = mysqli_query($conn, $sql);
          
          while ($row = mysqli_fetch_assoc($result)) {

                // Exibir os dados do utilizador

                echo "<tr>";
                echo "<td>" . htmlspecialchars($row['nome_utilizador']) . "</td>";
                echo "<td>" . htmlspecialchars($row['email']) . "</td>";
                echo "<td>" . htmlspecialchars($row['data_nasc']) . "</td>";
                
                echo "<td>";
                echo "<form action='aceitar_utilizadores.php' method='POST'>";
                echo "<input type='hidden' name='id_utilizador' value='" . $row['id_registo'] . "'>";
                echo "<button type='submit' class='btn btn-primary'>Aceitar</button>";
                echo "</form>";
                echo "</td>";
              
                echo "</tr>";
            
          }
          ?>
      </tbody>
  </table>



  <br>
  </div>
