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
    <h1>Alertas</h1>
    <br>

    <form method="post" action="filtro_alertas.php">
        <input type="text" name="tipo_alerta" placeholder="Tipo de alerta">
        
        <br><br>
        Ordenar por:

        <select name="ordenar_por">
            <option value="promocoes">Promoções</option>
            <option value="altera_horario">Alteração de Horários</option>
            <option value="cancelamento">Cancelamento</option>
        </select>

        <br><br>

        <button type="submit" class='btn btn-primary'>Filtrar/Ordenar</button>
        <br><br><br><br>
        
    </form>

    <table class="table">
      <thead>
          <tr>
              <th>Alerta</th>
              <th>Rota</th>
              <th>Id_Viagem</th>
              <th>Tipo</th>
              
              
              
          </tr>
      </thead>
      <tbody>
          <?php
          
          include '../basedados/basedados.h';
          $sql = "SELECT * FROM alertas";
          $result = mysqli_query($conn, $sql);
          
        while ($row = mysqli_fetch_assoc($result)) {

            // Obter descrição do tipo de alerta
            $descricao = '';
            if (!empty($row['tipo'])) {
            $sql2 = "SELECT descricao FROM tipo_alerta WHERE id_tipo = " . intval($row['tipo']);
            $result2 = mysqli_query($conn, $sql2);
            $row2 = mysqli_fetch_assoc($result2);
            $descricao = $row2 && isset($row2['descricao']) ? htmlspecialchars($row2['descricao']) : '';
            }

            // Obter nome da rota
            $nome_rota = '';
            if (isset($row['id_rota']) && is_numeric($row['id_rota'])) {
            $id_rota = intval($row['id_rota']);
            $sql3 = "SELECT nome_rota FROM rotas WHERE id_rota = $id_rota";
            $result3 = mysqli_query($conn, $sql3);
            $row3 = mysqli_fetch_assoc($result3);
            $nome_rota = $row3 && isset($row3['nome_rota']) ? htmlspecialchars($row3['nome_rota']) : '';
            }

            // Obter id_viagem
            $id_viagem = isset($row['id_viagem']) ? htmlspecialchars($row['id_viagem']) : '';

            echo "<tr>";
            echo "<td>" . (isset($row['id_alerta']) ? htmlspecialchars($row['id_alerta']) : '') . "</td>";
            echo "<td>" . $nome_rota . "</td>";
            echo "<td>" . $id_viagem . "</td>";
            echo "<td>" . $descricao . "</td>";
            echo "<td>";
            echo "<form action='descricao_alertas.php' method='POST'>";
            echo "<input type='hidden' name='id_alerta' value='" . (isset($row['id_alerta']) ? htmlspecialchars($row['id_alerta']) : '') . "'>";
            echo "<button type='submit' class='btn btn-primary'>Ver Descrição</button>";
            echo "</form>";
            echo "</td>";
            echo "</tr>";
        }
          ?>
      </tbody>
  </table>



  <br>
  </div>