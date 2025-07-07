<?php
  session_start();
  if($_SESSION['nivel'] != 1){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>


<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FelixBus</title>
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
  <br>
    <h1>Suas Transações</h1>
    <br>

    <table class="table">
      <thead>
          <tr>
              <th>Transação</th>
              <th>Carteira</th>
              <th>Nome</th>
              <th>Data Transação</th>
              <th>Valor</th>
              
              
          </tr>
      </thead>
      <tbody>
          <?php
          
          include '../basedados/basedados.h';
          $id_utilizador = $_SESSION['id_utilizador'];
          $sql = "SELECT * FROM estratos_bancarios WHERE id_utilizador = $id_utilizador ORDER BY id_transacao ASC";
          $result = mysqli_query($conn, $sql);
          
          while ($row = mysqli_fetch_assoc($result)) {

            $id_utilizador = $row['id_utilizador'];
            $user_sql = "SELECT nome_utilizador FROM utilizadores WHERE id_utilizador = $id_utilizador";
            $user_result = mysqli_query($conn, $user_sql);
            $user_row = mysqli_fetch_assoc($user_result);
            

                echo "<tr>";
                echo "<td>" . htmlspecialchars($row['id_transacao']) . "</td>";
                echo "<td>" . htmlspecialchars($row['id_carteira']) . "</td>";
                echo "<td>" . htmlspecialchars($user_row['nome_utilizador']) . "</td>";
                echo "<td>" . htmlspecialchars($row['data_transacao']) . "</td>";
                $valor = $row['valor'];
                $tipo_transacao = $row['tipo_transacao'];
                $cor = ($tipo_transacao == 1) ? 'green' : 'red';
                echo "<td style='color: $cor;'>" . $valor . "</td>";
                echo "</tr>";
            
          }
          ?>
      </tbody>
  </table>



  <br>
  </div>