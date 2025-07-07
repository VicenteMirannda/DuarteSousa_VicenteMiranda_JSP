<?php
include '../basedados/basedados.h';
?>
<!doctype html>
<html lang="pt">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>FelixBus - Contactos</title>

  <!-- Bootstrap CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

  <style>
    body {
      background-color: #f8fafc;
    }
    .card {
      border: none;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
    }
    footer {
      background-color: #343a40;
      padding: 20px;
      text-align: center;
    }
    footer p {
      color: white;
      margin: 0;
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
            <ul class="navbar-nav ms-auto"> <!-- Alinha os links à direita -->
                <li class="nav-item">
                    <a class="nav-link" href="consultar_rotas.php">Consultar Rotas</a>
                </li>  
                <?php
                
                $result = mysqli_query($conn, "SELECT COUNT(*) as total FROM alertas");
                $row = mysqli_fetch_assoc($result);
                if ($row['total'] > 0) {
                    echo '<li class="nav-item">
                            <a class="nav-link text-warning" href="alertas.php">Alertas <i class="bi bi-bell-fill"></i> <span class="badge bg-danger">'.$row['total'].'</span></a>
                          </li>';
                }
                ?>
               

                <li class="nav-item">
                    <a class="nav-link" href="localizacao.php">Localização</a>
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


<div class="container my-5">
  <div class="row justify-content-center g-4">

    <div class="col-lg-5">
      <div class="card p-4">
        <h2>📞 Informações de Contato</h2>
        <p><strong>📍 Endereço:</strong> R. Conselheiro Albuquerque 27A, 6000-161 Castelo Branco</p>
        <p><strong>📱 Telefone:</strong> 910125593</p>
        <p><strong>📧 Email:</strong> felixbus@gmail.com</p>
      </div>
    </div>

    <div class="col-lg-6">
      <div class="card p-4">
        <h2>📬 Formulário de Contato</h2>
        <form id="contact-form">
          <div class="mb-3">
            <label for="name" class="form-label">Nome:</label>
            <input type="text" id="name" name="name" class="form-control" required>
          </div>
          <div class="mb-3">
            <label for="email" class="form-label">Email:</label>
            <input type="email" id="email" name="email" class="form-control" required>
          </div>
          <div class="mb-3">
            <label for="message" class="form-label">Mensagem:</label>
            <textarea id="message" name="message" class="form-control" rows="5" required></textarea>
          </div>
          <button type="submit" class="btn btn-primary w-100">Enviar</button>
        </form>
      </div>
    </div>

  </div>
</div>



</body>
</html>
