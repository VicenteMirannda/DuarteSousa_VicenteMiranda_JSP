<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
 

include '../basedados/basedados.h';

$id = $_SESSION['id_utilizador'];

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['utilizador']) && isset($_POST['email']) && isset($_POST['data_nasc']) ) {
    $novo_nome = $_POST['utilizador'];
    
    
    $sql1 = "UPDATE utilizadores SET nome_utilizador='".$_POST['utilizador']."', email='".$_POST['email']."', data_nasc='".$_POST['data_nasc']."' 
    WHERE id_utilizador= $id";
    $res = mysqli_query($conn,$sql1);

    if(isset($_POST['password'])){
        $nova_password = password_hash($_POST['password'], PASSWORD_DEFAULT);
        $sql2 = "UPDATE utilizadores SET password='$nova_password' WHERE id_utilizador= $id";
        mysqli_query($conn, $sql2);
    }

    if($res){
        echo "Administrador editado com sucesso!";
        header("refresh:2");
    }
    else{
        echo "Erro ao editar Administrador!";
    }
}

?>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Dados Pessoais Admin - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <style>
       body {
            background-color: #f8f9fa;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .form-container {
            max-width: 600px;
            width: 100%;
            margin: 20px auto;
            padding: 30px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .form-title {
            text-align: center;
            margin-bottom: 25px;
            color: #343a40;
        }
        .btn-submit {
            width: 100%;
            padding: 10px;
            font-weight: 500;
        }
        .content-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            padding: 20px 0;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
          <a class="navbar-brand" href="voltar.php">FelixBus</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
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


<?php
    $sql = "SELECT * FROM utilizadores where id_utilizador = $id";
            $result = mysqli_query($conn, $sql);
            while ($row = mysqli_fetch_assoc($result)) {

                ?>
            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 11%;">
            
            <form action = "dados_pessoais.php" method = "POST">
            <div class="mb-3">
                <label for="id_utilizador" class="form-label">ID_Utilizador</label>
                <input type="text" class="form-control" id="id_utilizador" name="id_utilizador" value="<?php echo $row['id_utilizador']; ?>" readonly>
              </div>
              <div class="mb-3">
                <label for="utilizador" class="form-label">Utilizador</label>
                <input type="text" class="form-control" id="utilizador" name="utilizador" value="<?php echo $row['nome_utilizador']; ?>" required>
              </div>
              <div class="mb-3">
                <label for="idade" class="form-label">Email</label>
                <input type="text" class="form-control" id="email" name="email" value = "<?php echo $row['email']; ?>" required>
              </div>
              <div class="mb-3">
                <label for="data_nasc" class="form-label">Data Nascimento</label>
                <input type="date" class="form-control" id="data_nasc" name="data_nasc" value="<?php echo $row['data_nasc']; ?>" required>
              </div>
              <div class="mb-3">
                  <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" value="" placeholder="Nova password (deixe em branco para não alterar)">
              </div>
              <div class="mb-3">
                <label for="id_utilizador" class="form-label">Nivel de Acesso</label>
                <input type="text" class="form-control" id="nivel de Acesso" name="nivel de Acesso" value="<?php echo $row['nivel_acesso']; ?>" readonly>
              </div>
              
              <button type="submit" class="btn btn-primary">Editar</button>
            </form>
          </div>
              
              
              
            <?php
            }
            ?>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
