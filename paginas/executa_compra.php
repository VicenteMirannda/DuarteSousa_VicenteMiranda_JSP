<?php
session_start();
include '../basedados/basedados.h';

if ($_SESSION['nivel'] != 1 && $_SESSION['nivel'] != 2) {
    header('Location: voltar.php');
    exit();
}

$id_utilizador = $_SESSION['id_utilizador'];

if (isset($id_utilizador) && isset($_POST['id_viagem']) && isset($_POST['preco'])&& isset($_POST['origem']) && isset($_POST['destino']) && isset($_POST['data'])) {

    // parte para o funcionario
    if ($_SESSION['nivel'] == 2) {
        // Redirecionar para executa_compra_funcionario.php com os dados via POST
        echo "
        <form id='redirectForm' action='executa_compra_funcionario.php' method='POST' style='display:none;'>
            <input type='hidden' name='id_viagem' value='" . htmlspecialchars($_POST['id_viagem'], ENT_QUOTES) . "'>
            <input type='hidden' name='origem' value='" . htmlspecialchars($_POST['origem'], ENT_QUOTES) . "'>
            <input type='hidden' name='destino' value='" . htmlspecialchars($_POST['destino'], ENT_QUOTES) . "'>
            <input type='hidden' name='data' value='" . htmlspecialchars($_POST['data'], ENT_QUOTES) . "'>
            <input type='hidden' name='preco' value='" . htmlspecialchars($_POST['preco'], ENT_QUOTES) . "'>
        </form>
        <script>
            document.getElementById('redirectForm').submit();
        </script>
        ";
        exit();
    }

    // parte do cliente
    if ($_SESSION['nivel'] == 1) {
        // código para cliente
        // Verificar saldo do cliente
        $query_saldo = "SELECT saldo FROM carteiras WHERE id_utilizador = $id_utilizador";
        $stmt = $conn->prepare($query_saldo);
        $stmt->execute();
        $stmt->bind_result($saldo);
        $stmt->fetch();
        $stmt->close();

        $preco_estimado = floatval($_POST['preco']);

        if ($saldo < $preco_estimado) {
            // Saldo insuficiente
            echo "<script>alert('Saldo insuficiente para realizar a compra.'); window.location.href='voltar.php';</script>";
            exit();
        }else{
            $id_viagem = intval($_POST['id_viagem']);
            $origem = $_POST['origem'];
            $destino = $_POST['destino'];
            $data = $_POST['data'];

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
                // Atualizar saldo do utilizador
                $novo_saldo = $saldo - $preco_estimado;
                $query_update_saldo = "UPDATE carteiras SET saldo = ? WHERE id_utilizador = ?";
                $stmt_update = $conn->prepare($query_update_saldo);
                $stmt_update->bind_param("di", $novo_saldo, $id_utilizador);
                $stmt_update->execute();
                $stmt_update->close();

                // Buscar id_carteira corretamente (usando bind_param antes de execute)
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
        }
            $stmt_bilhete->close();
        }


    }else {
    echo "<script>alert('Dados inválidos.'); window.location.href='voltar.php';</script>";
}

?>
