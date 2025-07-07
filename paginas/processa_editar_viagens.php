<?php
session_start();
if ($_SESSION['nivel'] != 3) {
    header("Location: voltar.php");
    exit;
}

include '../basedados/basedados.h';




$id_viagem = $_SESSION['id_viagem'];


    $sql2 = "SELECT * FROM viagem WHERE id_viagem = $id_viagem";
    $result2 = mysqli_query($conn, $sql2);
    $viagem = mysqli_fetch_assoc($result2);


if ($_SERVER['REQUEST_METHOD'] === 'POST'&& isset($_POST['id_rota']) && isset($_POST['id_veiculo']) && isset($_POST['data']) && isset($_POST['hora_partida']) && isset($_POST['hora_chegada']) && isset($_POST['vagas'])) {
   
   

    
  
    $id_rota = $_POST['id_rota'];
    $id_veiculo =  $_POST['id_veiculo'];
    $data = $_POST['data'];
    $hora_partida = $_POST['hora_partida'];
    $hora_chegada =  $_POST['hora_chegada'];
    $vagas =  $_POST['vagas'];

    
    $sql = "UPDATE viagem 
            SET id_rota = $id_rota, id_veiculo = $id_veiculo, data = '$data',
                hora_partida = '$hora_partida', hora_chegada = '$hora_chegada', vagas = $vagas
            WHERE id_viagem = $id_viagem";

    if (mysqli_query($conn, $sql)) {
        $mensagem = "Viagem atualizada com sucesso!";

        if (
            $hora_partida !== $viagem['hora_partida'] ||
            $hora_chegada !== $viagem['hora_chegada']
        ) {
            header("Location: alterar_hora.php");
            exit;
        }

        header("Location: editar_viagens.php");
        unset($_SESSION['id_viagem']);

    } else {
        $erro = "Erro ao atualizar: " . mysqli_error($conn);
    }
}



?>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Editar de Viagens - FelixBus</title>
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
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="voltar.php">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">

                <li class="nav-item">
                    <a class="nav-link" href="editar_viagens.php">Voltar</a>
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
<h1>Editar Viagem</h1>
<br>
<form method="POST" action="">



    <div class="mb-3">
        <label>Rota:</label>
        <select name="id_rota" class="form-control" required>
            <?php
            $rotas = mysqli_query($conn, "SELECT id_rota, nome_rota FROM rotas");
            while ($rota = mysqli_fetch_assoc($rotas)) {
                $selected = $rota['id_rota'] == $viagem['id_rota'] ? 'selected' : '';
                echo "<option value='{$rota['id_rota']}' $selected>{$rota['nome_rota']}</option>";
            }
            ?>
        </select>
    </div>

    <div class="mb-3">
        <label>Veículo:</label>
        <select name="id_veiculo" class="form-control" required>
            <?php
            $veiculos = mysqli_query($conn, "SELECT id_veiculo, nome_veiculo FROM veiculos");
            while ($v = mysqli_fetch_assoc($veiculos)) {
                $selected = $v['id_veiculo'] == $viagem['id_veiculo'] ? 'selected' : '';
                echo "<option value='{$v['id_veiculo']}' $selected>{$v['nome_veiculo']}</option>";
            }
            ?>
        </select>
    </div>

    <div class="mb-3">
        <label>Data:</label>
        <input type="date" name="data" class="form-control" value="<?php echo $viagem['data']; ?>" required>
    </div>

    <div class="mb-3">
        <label>Hora de Partida:</label>
        <input type="time" name="hora_partida" class="form-control" value="<?php echo $viagem['hora_partida']; ?>" required>
    </div>

    <div class="mb-3">
        <label>Hora de Chegada:</label>
        <input type="time" name="hora_chegada" class="form-control" value="<?php echo $viagem['hora_chegada']; ?>" required>
    </div>

    <div class="mb-3">
        <label>Vagas:</label>
        <input type="number" name="vagas" class="form-control" value="<?php echo $viagem['vagas']; ?>" required>
    </div>


    <button type="submit" class="btn btn-primary">Guardar Alterações</button>
    
</form>
        </div>
</body>
</html>
