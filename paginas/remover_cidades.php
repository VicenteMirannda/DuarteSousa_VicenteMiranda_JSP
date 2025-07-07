<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>

<?php
    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        

   

    if (isset($_POST['id_cidade'])) {
        $sql = "DELETE FROM cidades WHERE id_cidade = '".$_POST['id_cidade']."' ";
        $res = mysqli_query($conn, $sql);
        if($res){
            echo "Cidade removida com sucesso!";
            header("refresh:2;url=voltar.php");
        }else{
            echo "Erro ao remover Cidade!";
            header("refresh:2;url=voltar.php");
        }
      
        
    }
    else {
        echo "Erro";
        header('Location: voltar.php');
    }

}

?>


<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Remover Cidade - FelixBus</title>
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
                    <a class="nav-link" href="gestao_cidades.php">Voltar</a>
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
              <th>Nome da Cidade</th>
              
              
          </tr>
      </thead>
      <tbody>
          <?php
          
          include '../basedados/basedados.h';
          $sql = "SELECT * FROM cidades";
          $result = mysqli_query($conn, $sql);
          
          while ($row = mysqli_fetch_assoc($result)) {


                echo "<tr>";
                echo "<td>" . htmlspecialchars($row['nome_cidade']) . "</td>";
                echo "<td>";
                echo "<form action='remover_cidades.php' method='POST'>";
                echo "<input type='hidden' name='id_cidade' value='" . $row['id_cidade'] . "'>";
                echo "<button type='submit' class='btn btn-primary'>Remover</button>";
                echo "</form>";
                echo "</td>";
              
                echo "</tr>";
            
          }
          ?>
      </tbody>
  </table>



  <br>
  </div>