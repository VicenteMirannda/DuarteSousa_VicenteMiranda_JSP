<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>
<?php 

if($_SERVER['REQUEST_METHOD'] == 'POST'){

    if (isset($_POST['id_rota'], $_POST['rota'], $_POST['taxa_inicial'], $_POST['taxa_paragem'], $_POST['num_paragens'])) {
        $id_rota = $_POST['id_rota'];
        $rota = $_POST['rota'];
        $taxa_inicial = $_POST['taxa_inicial'];
        $taxa_paragem = $_POST['taxa_paragem'];
        $num_paragens = $_POST['num_paragens'];

        if ($taxa_inicial < 0 || $taxa_paragem < 0 || $num_paragens < 0) {
            echo "<div class='alert alert-danger'>Erro: Os valores de Taxa Inicial, Taxa Paragem e Número de Paragens não podem ser negativos.</div>";
        } else {
            $sql = "UPDATE rotas SET nome_rota = ?, taxa_inicial = ?, taxa_paragem = ?, num_paragens = ? WHERE id_rota = ?";
            $stmt = mysqli_prepare($conn, $sql);
            mysqli_stmt_bind_param($stmt, 'sdddi', $rota, $taxa_inicial, $taxa_paragem, $num_paragens, $id_rota);

            if (mysqli_stmt_execute($stmt)) {
                echo "<div class='alert alert-success'>Rota atualizada com sucesso!</div>";
                header("refresh:2;url=voltar.php");
            } else {
                echo "<div class='alert alert-danger'>Erro ao atualizar a rota: " . mysqli_error($conn) . "</div>";
                header("refresh:2;url=voltar.php");
            }

            mysqli_stmt_close($stmt);
        }
    

    

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
                    <a class="nav-link" href="editar_rotas.php">Voltar</a>
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
    <h1>Editar Rota</h1>

    <?php
            if (isset($_POST['id_rota'])) {
                
            
            include '../basedados/basedados.h';
            $sql = "SELECT * FROM rotas where id_rota = " . $_POST['id_rota'];
            $result = mysqli_query($conn, $sql);
            while ($row = mysqli_fetch_assoc($result)) {

                ?>
            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
            
            <form action = "editar_dados_rota.php" method = "POST">
            <div class="mb-3">
                <label for="id_rota" class="form-label">ID_Rota</label>
                <input type="text" class="form-control" id="id_rota" name="id_rota" value="<?php echo $_POST['id_rota']; ?>" readonly>
              </div>
              <div class="mb-3">
                <label for="rota" class="form-label">Nome Rota</label>
                <input type="text" class="form-control" id="rota" name="rota" value="<?php echo $row['nome_rota']; ?>" required>
              </div>
              
              <div class="mb-3">
                <label for="taxa_inicial" class="form-label">Taxa Inicial</label>
                <input type="number" class="form-control" id="taxa_inicial" name="taxa_inicial" value = "<?php echo $row['taxa_inicial']; ?>" required>
              </div>
             
            <div class="mb-3">
                <label for="taxa_paragem" class="form-label">Taxa Paragem</label>
                <input type="number" class="form-control" id="taxa_paragem" name="taxa_paragem" value = "<?php echo $row['taxa_paragem']; ?>" required>
              </div>
            <div class="mb-3">
                <label for="num_paragens" class="form-label">Número de Paragens</label>
                <input type="number" class="form-control" id="num_paragens" name="num_paragens" value = "<?php echo $row['num_paragens']; ?>" required>
              </div>
              
              <button type="submit" class="btn btn-primary">Editar</button>
            </form>
          </div>
              
              
              
            <?php
            }
        }
            ?>