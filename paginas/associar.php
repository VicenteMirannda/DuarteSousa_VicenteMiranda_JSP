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
                    <a class="nav-link" href="associar_cidades.php">Voltar</a>
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
    <h1>Cidades</h1>
    <br>

    <table class="table">
      <thead>
          <tr>
              <th>Id</th>
              <th>Nome Cidade</th>
              
              
          </tr>
      </thead>
      <tbody>
          <?php
          
          include '../basedados/basedados.h';
        
            $id_rota = isset($_POST['id_rota']) ? intval($_POST['id_rota']) : 0;
            $sql = "SELECT * FROM cidades c WHERE c.id_cidade NOT IN (
                        SELECT rc.id_cidade FROM rotas_cidade rc WHERE rc.id_rota = $id_rota
                    ) ORDER BY c.id_cidade ASC";
            $result = mysqli_query($conn, $sql);
       
          
          while ($row = mysqli_fetch_assoc($result)) {

                echo "<tr>";
                echo "<td>" . htmlspecialchars($row['id_cidade']) . "</td>";
                echo "<td>" . htmlspecialchars($row['nome_cidade']) . "</td>";
                echo "<td>";
                echo "<form action='associar.php' method='POST'>";
                echo "<input type='hidden' name='id_cidade' value='" . $row['id_cidade'] . "'>";
                echo "<input type='hidden' name='rota' value='" . $id_rota . "'>";
                echo "<button type='submit' class='btn btn-primary'>Associar</button>";
                echo "</form>";
                echo "</tr>";
            
          }
          ?>
      </tbody>
  </table>



  <br>
  </div>

  <?php
// Verifica se o formulário foi enviado
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['id_cidade']) && isset($_POST['rota'])) {
    $id_cidade = intval($_POST['id_cidade']);
    $rota = intval($_POST['rota']);

    // Busca o número atual de paragens da rota
    $sql2 = "SELECT num_paragens FROM rotas WHERE id_rota = $rota";
    $result2 = mysqli_query($conn, $sql2);
    $row2 = mysqli_fetch_assoc($result2);
    $num_paragem = $row2['num_paragens'] + 1;

    // Insere a associação entre a cidade e a rota
    $sql = "INSERT INTO rotas_cidade (id_rota, id_cidade, num_paragem) VALUES ($rota, $id_cidade, $num_paragem)";
    // Executa a consulta

    // Atualiza o número de paragens da rota
    $update_sql = "UPDATE rotas SET num_paragens = num_paragens + 1 WHERE id_rota = $rota";
    mysqli_query($conn, $update_sql);
    
    if (mysqli_query($conn, $sql)) {
        echo "<div class='alert alert-success'>Cidade associada com sucesso!</div>";
        
        // Redireciona para a página de gestão de cidades
        header("Location: gestao_cidades.php");
        exit();
    } else {
        echo "<div class='alert alert-danger'>Erro ao associar cidade: " . mysqli_error($conn) . "</div>";
    }
}
?>