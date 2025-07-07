<?php
  session_start();
  if($_SESSION['nivel'] != 2){
    header('Location: voltar.php');
  }
  include '../basedados/basedados.h';

  
?>




<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Menu Funcionário - FelixBus</title>
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
                    <a class="nav-link" href="gestao_bilhetes_func.php">Voltar</a>
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
    <h1>Utilizadores</h1>
    <br>

    <table class="table">
      <thead>
          <tr>
              <th>Nome do Utilizador</th>
              <th>Email</th>
              <th>Data Nascimento</th>
              <th>Nivel Acesso</th>
             
              
          </tr>
      </thead>
      <tbody>
          <?php
          
        // Primeiro, mostrar a tabela de utilizadores se não houver POST de compra
        if (
            !isset($_POST['id_utilizador'], $_POST['id_viagem'], $_POST['origem'], $_POST['destino'], $_POST['data'], $_POST['preco'])
        ) {
            // Mostrar tabela de utilizadores
            include '../basedados/basedados.h';
            $sql = "SELECT * FROM utilizadores WHERE nivel_acesso = 1"; 
            $result = mysqli_query($conn, $sql);

            while ($row = mysqli_fetch_assoc($result)) {
                $sql2 = "SELECT descricao FROM nivel_acesso n inner join utilizadores u on n.nivel_acesso = u.nivel_acesso
                 WHERE n.nivel_acesso = " . $row['nivel_acesso'];
                $result2 = mysqli_query($conn, $sql2);
                $row2 = mysqli_fetch_assoc($result2);

                echo "<tr>";
                echo "<td>" . htmlspecialchars($row['nome_utilizador']) . "</td>";
                echo "<td>" . htmlspecialchars($row['email']) . "</td>";
                echo "<td>" . htmlspecialchars($row['data_nasc']) . "</td>";
                echo "<td>" . htmlspecialchars($row2['descricao']) . "</td>";
                echo "<td>";
                echo "<form action='executa_compra_funcionario.php' method='POST'>";
                echo "<input type='hidden' name='id_utilizador' value='" . $row['id_utilizador'] . "'>";
                // Repassar os valores do POST atual
                if (isset($_POST['id_viagem'])) {
                    echo "<input type='hidden' name='id_viagem' value='" . htmlspecialchars($_POST['id_viagem'], ENT_QUOTES) . "'>";
                }
                if (isset($_POST['origem'])) {
                    echo "<input type='hidden' name='origem' value='" . htmlspecialchars($_POST['origem'], ENT_QUOTES) . "'>";
                }
                if (isset($_POST['destino'])) {
                    echo "<input type='hidden' name='destino' value='" . htmlspecialchars($_POST['destino'], ENT_QUOTES) . "'>";
                }
                if (isset($_POST['data'])) {
                    echo "<input type='hidden' name='data' value='" . htmlspecialchars($_POST['data'], ENT_QUOTES) . "'>";
                }
                if (isset($_POST['preco'])) {
                    echo "<input type='hidden' name='preco' value='" . htmlspecialchars($_POST['preco'], ENT_QUOTES) . "'>";
                }
                echo "<button type='submit' class='btn btn-primary'>Selecionar</button>";
                echo "</form>";
                echo "</td>";
                echo "</tr>";
            }
        } else {
            // Só processa a compra se todos os POSTs necessários estiverem presentes
            if (isset($_POST['id_utilizador'], $_POST['id_viagem'], $_POST['origem'], $_POST['destino'], $_POST['data'], $_POST['preco'])) {
                $id_utilizador = intval($_POST['id_utilizador']);
                $id_viagem = intval($_POST['id_viagem']);
                $origem = $_POST['origem'];
                $destino = $_POST['destino'];
                $data = $_POST['data'];
                $preco_estimado = floatval($_POST['preco']);

                // Verificar saldo do cliente
                $query_saldo = "SELECT saldo FROM carteiras WHERE id_utilizador = ?";
                $stmt = $conn->prepare($query_saldo);
                $stmt->bind_param("i", $id_utilizador);
                $stmt->execute();
                $stmt->bind_result($saldo);
                $stmt->fetch();
                $stmt->close();

                if ($saldo < $preco_estimado) {
                    echo "<script>alert('Saldo insuficiente para realizar a compra.'); window.location.href='voltar.php';</script>";
                    exit();
                } else {
                    // Buscar o número da paragem correspondente à origem
                    $query_paragem = "
                        SELECT rc.num_paragem 
                        FROM rotas_cidade rc
                        INNER JOIN cidades c ON rc.id_cidade = c.id_cidade
                        WHERE c.nome_cidade = ?
                    ";
                    $stmt_paragem = $conn->prepare($query_paragem);
                    $stmt_paragem->bind_param("s", $origem);
                    $stmt_paragem->execute();
                    $stmt_paragem->bind_result($numero_paragem);
                    $stmt_paragem->fetch();
                    $stmt_paragem->close();

                    // Buscar a hora da viagem pelo id_viagem
                    $query_hora = "SELECT hora_partida FROM viagem WHERE id_viagem = ?";
                    $stmt_hora = $conn->prepare($query_hora);
                    $stmt_hora->bind_param("i", $id_viagem);
                    $stmt_hora->execute();
                    $stmt_hora->bind_result($hora_partida);
                    $stmt_hora->fetch();
                    $stmt_hora->close();

                    // Adiciona ($numero_paragem - 1) horas à hora de partida
                    $hora_partida_dt = new DateTime($hora_partida);
                    $horas_adicionar = max(0, $numero_paragem - 1);
                    $hora_partida_dt->modify("+{$horas_adicionar} hour");
                    $ponto_hora = $hora_partida_dt->format('H:i:s');

                    // Inserir bilhete
                    $query_bilhete = "INSERT INTO bilhete (id_utilizador, id_viagem, cidade_origem, cidade_destino, data_viagem, hora, preco) VALUES (?, ?, ?, ?, ?, ?, ?)";
                    $stmt_bilhete = $conn->prepare($query_bilhete);
                    $stmt_bilhete->bind_param("iissssd", $id_utilizador, $id_viagem, $origem, $destino, $data, $ponto_hora, $preco_estimado);

                    // Retirar uma vaga da viagem
                    $query_vagas = "UPDATE viagem SET vagas = vagas - 1 WHERE id_viagem = ?";
                    $stmt_vagas = $conn->prepare($query_vagas);
                    $stmt_vagas->bind_param("i", $id_viagem);

                    if ($stmt_bilhete->execute()) {
                        $stmt_vagas->execute();
                        $stmt_vagas->close();

                        // Atualizar saldo do utilizador
                        $novo_saldo = $saldo - $preco_estimado;
                        $query_update_saldo = "UPDATE carteiras SET saldo = ? WHERE id_utilizador = ?";
                        $stmt_update = $conn->prepare($query_update_saldo);
                        $stmt_update->bind_param("di", $novo_saldo, $id_utilizador);
                        $stmt_update->execute();
                        $stmt_update->close();

                        // Buscar id_carteira
                        $query_carteira = "SELECT id_carteira FROM carteiras WHERE id_utilizador = ?";
                        $stmt_carteira = $conn->prepare($query_carteira);
                        $stmt_carteira->bind_param("i", $id_utilizador);
                        $stmt_carteira->execute();
                        $stmt_carteira->bind_result($id_carteira);
                        $stmt_carteira->fetch();
                        $stmt_carteira->close();

                        // Criar extrato bancário
                        $tipo_transacao = 0; // 0 para débito
                        $valor_negativo = $preco_estimado;
                        $query_extrato = "INSERT INTO estratos_bancarios (id_carteira, id_utilizador, tipo_transacao, valor, data_transacao) VALUES (?, ?, ?, ?, NOW())";
                        $stmt_extrato = $conn->prepare($query_extrato);
                        $stmt_extrato->bind_param("iiid", $id_carteira, $id_utilizador, $tipo_transacao, $valor_negativo);
                        $stmt_extrato->execute();
                        $stmt_extrato->close();

                        echo "<script>alert('Compra realizada com sucesso!'); window.location.href='voltar.php';</script>";
                    } else {
                        echo "<script>alert('Erro ao criar bilhete.'); window.location.href='voltar.php';</script>";
                    }
                    $stmt_bilhete->close();
                }
            } else {
                echo "<script>alert('Dados inválidos.'); window.location.href='voltar.php';</script>";
            }
        }
        ?>
        





  <br>
  </div>