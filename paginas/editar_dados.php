<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>
<?php 

    if($_SERVER['REQUEST_METHOD'] == 'POST'){

        if ($_POST['id_utilizador'] == $_SESSION['id_utilizador']) {
            echo "Não pode editar a sua própria conta!";
            header("refresh:2;url=editar_utilizadores.php");
        }
        if (isset($_POST['id_utilizador']) && isset($_POST['utilizador']) && isset($_POST['data_nasc']) && isset($_POST['nivel'])) {
            $id_utilizador = $_POST['id_utilizador'];
            $utilizador = $_POST['utilizador'];
            $data_nasc = $_POST['data_nasc'];
            $nivel = $_POST['nivel'];

            
            $nivel_check_query = "SELECT COUNT(*) as count FROM nivel_acesso WHERE nivel_acesso = '$nivel'";
            $nivel_check_result = mysqli_query($conn, $nivel_check_query);
            $nivel_check_row = mysqli_fetch_assoc($nivel_check_result);

            if ($nivel_check_row['count'] > 0) {
                $sql = "UPDATE utilizadores SET nome_utilizador='$utilizador', data_nasc='$data_nasc', nivel_acesso='$nivel', saldo='$saldo' WHERE id_utilizador='$id_utilizador'";
                $res = mysqli_query($conn, $sql);
            } else {
                echo "Erro: O nível de acesso especificado não existe.";
                header("refresh:2;url=editar_utilizadores.php");
                
            }
            $res = mysqli_query($conn, $sql);
            
            if($res){
                echo "Utilizador editado com sucesso!";
                header("refresh:2;url=voltar.php");
            }else{
                echo "Erro ao editar utilizador!";
                header("refresh:2;url=voltar.php");
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
                    <a class="nav-link" href="editar_utilizadores.php">Voltar</a>
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
    <h1>Editar Dados Utilizador</h1>
    

    
       
            <?php
            if (isset($_POST['id_utilizador'])) {
                
            
            include '../basedados/basedados.h';
            $sql = "SELECT * FROM utilizadores where id_utilizador = " . $_POST['id_utilizador'];
            $result = mysqli_query($conn, $sql);
            while ($row = mysqli_fetch_assoc($result)) {

                ?>
            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
            
            <form action = "editar_dados.php" method = "POST">
            <div class="mb-3">
                <label for="id_utilizador" class="form-label">ID_Utilizador</label>
                <input type="text" class="form-control" id="id_utilizador" name="id_utilizador" value="<?php echo $_POST['id_utilizador']; ?>" readonly>
              </div>
              <div class="mb-3">
                <label for="utilizador" class="form-label">Utilizador</label>
                <input type="text" class="form-control" id="utilizador" name="utilizador" value="<?php echo $row['nome_utilizador']; ?>" required>
              </div>
              
              <div class="mb-3">
                <label for="data_nasc" class="form-label">Data Nascimento</label>
                <input type="date" class="form-control" id="data_nasc" name="data_nasc" value = "<?php echo $row['data_nasc']; ?>" required>
              </div>
              <div class="mb-3">
                <label for="nivel" class="form-label">Nível de Acesso</label>
                <select class="form-select" id="nivel" name="nivel" value = "<?php echo $row['nivel_acesso']; ?>" required>
                  <option default>---</option>
                  <option value="1">Cliente</option>
                    <option value="2">Funcionário</option>
                    <option value="3">Admin</option>
                </select>
            </div>
            
              
              <button type="submit" class="btn btn-primary">Editar</button>
            </form>
          </div>
              
              
              
            <?php
            }
        }
            ?>
