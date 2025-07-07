<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
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

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="voltar.php">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">

                <li class="nav-item">
                    <a class="nav-link" href="gestao_alertas.php">Voltar</a>
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
    <h1>Rotas</h1>
    <br>

     <table class="table">
      <thead>
          <tr>
              <th>Nome da Rotas</th>
              <th>Taxa Inicial</th>
              <th>Taxa de Paragem</th>
              <th>Número de Paragens</th>
          </tr>
      </thead>
      <tbody>
          <?php
          
          include '../basedados/basedados.h';
          $sql = "SELECT * FROM rotas";
          $result = mysqli_query($conn, $sql);
          
          while ($row = mysqli_fetch_assoc($result)) {

           
                echo "<tr>";
                echo "<td>" . htmlspecialchars($row['nome_rota']) . "</td>";
                echo "<td>" . htmlspecialchars($row['taxa_inicial']) . " €</td>";
                echo "<td>" . htmlspecialchars($row['taxa_paragem']) . " €</td>";
                echo "<td>" . htmlspecialchars($row['num_paragens']) . "</td>";
                echo "<td>";
                echo "<form action='aplicar_desconto.php' method='POST'>";
                echo "<input type='hidden' name='id_rota' value='" . $row['id_rota'] . "'>";
                echo "<button type='submit' class='btn btn-primary'>Aplicar Promoção</button>";
                echo "</form>";
                echo "</td>";
              
                echo "</tr>";
            
          }
          ?>
      </tbody>
  </table>



  <br>
  </div>