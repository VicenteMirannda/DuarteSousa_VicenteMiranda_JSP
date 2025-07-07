<?php
  session_start();
if ($_SESSION['nivel'] != 1 && $_SESSION['nivel'] != 2) {
    header('Location: voltar.php');
    exit;
}
 

include '../basedados/basedados.h';

$id = $_SESSION['id_utilizador'];

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['utilizador']) && isset($_POST['email']) && isset($_POST['data_nasc'])) {
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
        echo "Dados editados com sucesso!";
        header("refresh:2");
    }
    else{
        echo "Erro ao editar dados!";
    }
}

?>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Dados Pessoais - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <style>
        .form-container {
            max-width: 500px;
            margin: 25px auto;
            padding: 25px;
            background-color: #f8f9fa;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
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
            
            <form action = "dados_cli_func.php" method = "POST">
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
                <input type="date" class="form-control" id="data_nasc" name="data_nasc" value = "<?php echo $row['data_nasc']; ?>" required>
              </div>
              
              <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="text" class="form-control" id="password" name="password" placeholder="Nova password (deixe em branco para não alterar)" required>
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
