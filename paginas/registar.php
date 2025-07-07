<?php
  session_start();
  if(isset($_SESSION['nivel'])){
    header('Location: voltar.php');
  }
    include '../basedados/basedados.h';

    if (isset($_POST['utilizador']) && isset($_POST['password']) && isset($_POST['email']) && isset($_POST['data_nasc'])) {
        $username = $_POST['utilizador'];
        $password = password_hash($_POST['password'], PASSWORD_DEFAULT);
        
        $email= $_POST['email'];
        $data_nasc = $_POST['data_nasc'];
        
        
        
    
        // Inserir pedido de registo na tabela 'registo' para aprovação do admin
        $query = "INSERT INTO registos (nome_utilizador, password, email, data_nasc) VALUES ('$username', '$password', '$email', '$data_nasc')";
        $result = mysqli_query($conn, $query);
    
        if ($result) {
            echo "O seu pedido de registo foi submetido com sucesso. Aguarde que o administrador o aprove.<br>";
            header("refresh:3; url=voltar.php");
            exit;
        } else {
            echo "Ocorreu um erro ao submeter o pedido de registo.";
        }
    }
  ?>


<!doctype html>
<html lang="pt">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="bootstrap.min.css">
    <title>FelixBus</title>
    <style>

      
      body {
      background-image: url("fundo-reciclado-da-textura-do-papel-branco-papel-de-parede-vintage_118047-8988.avif");
      background-size: cover;
      background-repeat: no-repeat;
    
    }
      img{
        border-radius: 20px;
      }
      .bio-image {
        width: 200px;
        height: 200px;
        object-fit: cover;
      }

      footer{
    padding: 20px;
    text-align: center;
    margin-top: 16.4%;
    font-size: 14px;
    
  }
  footer p{
    color: white;
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
                    <a class="nav-link" href="horarios.php">Horários</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="localizacao.php">Localização</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="contactos.php">Contactos</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="login.php">Login/Registar</a>
                </li>
            </ul>
          </div>
        </div>
      </nav>
     
      <div style="margin-top: 2%;">
        <div class="container">
          <div class="row">

          <!-- login -->
          <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 1%;">
            <h2>Registar</h2>
            <form action = "registar.php" method = "POST">
              <div class="mb-3">
                <label for="utilizador" class="form-label">Utilizador</label>
                <input type="text" class="form-control" id="utilizador" name="utilizador" required >
              </div>
              <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
              </div>
              <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required  >
              </div>
              <div class="mb-3">
                <label for="Data Nascimento" class="form-label">Data Nascimento</label>
                <input type="date" class="form-control" id="data_nasc" name="data_nasc" required>
              </div>
             
              <button type="submit" class="btn btn-primary">Registar</button>
            </form>
          </div>
  
          </div>
        </div>
      </div>
      
      

  </body>
</html>