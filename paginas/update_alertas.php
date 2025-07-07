<?php
  session_start();
  if($_SESSION['nivel'] != 3){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>
<?php 
function emptyIfNull($value) {
    return $value === null ? '' : $value;
}
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['id_alerta'], $_POST['descricao'])) {
    $id_alerta = intval($_POST['id_alerta']);
    $descricao = trim($_POST['descricao']);

    if ($descricao === '') {
        echo "<div class='alert alert-danger'>Erro: A descrição não pode estar vazia.</div>";
    } else {
        $sql = "UPDATE alertas SET descricao = ? WHERE id_alerta = ?";
        $stmt = mysqli_prepare($conn, $sql);
        mysqli_stmt_bind_param($stmt, 'si', $descricao, $id_alerta);

        if (mysqli_stmt_execute($stmt)) {
            echo "<div class='alert alert-success'>Descrição do alerta atualizada com sucesso!</div>";
            header("refresh:2;url=voltar.php");
        } else {
            echo "<div class='alert alert-danger'>Erro ao atualizar a descrição: " . mysqli_error($conn) . "</div>";
            header("refresh:2;url=voltar.php");
        }

        mysqli_stmt_close($stmt);
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
                    <a class="nav-link" href="editar_alerta.php">Voltar</a>
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
    <h1>Editar Alerta</h1>

    <?php
            if (isset($_POST['id_alerta'])) {
                
            
            include '../basedados/basedados.h';
            $sql = "SELECT * FROM alertas where id_alerta = " . $_POST['id_alerta'];
            $result = mysqli_query($conn, $sql);
            while ($row = mysqli_fetch_assoc($result)) {

                $sql_tipo = "SELECT descricao FROM tipo_alerta WHERE id_tipo = " . $row['tipo'];
                $result_tipo = mysqli_query($conn, $sql_tipo);
                $descricao_tipo = '';
                if ($result_tipo && mysqli_num_rows($result_tipo) > 0) {
                    $row_tipo = mysqli_fetch_assoc($result_tipo);
                    $descricao_tipo = $row_tipo['descricao'];
                }

                $id_rota = $row['id_rota'];
                $id_viagem = $row['id_viagem'];

                // Buscar nome da rota
                $nome_rota = '';
                if (!empty($id_rota)) {
                    $sql_rota = "SELECT nome_rota FROM rotas WHERE id_rota = $id_rota";
                    $result_rota = mysqli_query($conn, $sql_rota);
                    if ($result_rota && mysqli_num_rows($result_rota) > 0) {
                        $row_rota = mysqli_fetch_assoc($result_rota);
                        $nome_rota = $row_rota['nome_rota'];
                    }
                }

             
                ?>
            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
            
            <form action = "update_alertas.php" method = "POST">
            <div class="mb-3">
                <label for="id_alerta" class="form-label">ID_Alerta</label>
                <input type="text" class="form-control" id="id_alerta" name="id_alerta" value="<?php echo $_POST['id_alerta']; ?>" readonly>
              </div>
              <div class="mb-3">
                <label for="rota" class="form-label">Nome Rota</label>
                <input type="text" class="form-control" id="rota" name="rota" value="<?php echo htmlspecialchars($nome_rota); ?>" readonly>
              </div>

              <div class="mb-3">
                <label for="id_viagem" class="form-label">ID Viagem</label>
                <input type="text" class="form-control" id="id_viagem" name="id_viagem" value="<?php echo htmlspecialchars($id_viagem); ?>" readonly>
              </div>

              <div class="mb-3">
                <label for="descricao" class="form-label">Descrição</label>
                <input type="text" class="form-control" id="descricao" name="descricao" value="<?php echo htmlspecialchars($row['descricao']); ?>" required>
              </div>

              <div class="mb-3">
                <label for="tipo" class="form-label">Tipo</label>
                <input type="text" class="form-control" id="tipo" name="tipo" value="<?php echo htmlspecialchars($descricao_tipo); ?>" readonly>
              </div>
              
              <button type="submit" class="btn btn-primary">Editar</button>
            </form>
          </div>
              
              
              
            <?php
            }
        }
            ?>