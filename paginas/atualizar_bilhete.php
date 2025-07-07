<?php
session_start();
include '../basedados/basedados.h';

if ($_SESSION['nivel'] != 1) {
    header('Location: voltar.php');
    exit();
}

if (
    !isset($_POST['id_bilhete']) || 
    !isset($_POST['cidade_origem']) || 
    !isset($_POST['cidade_destino']) || 
    !isset($_POST['data_viagem'])
) {
    echo "<script>alert('Dados incompletos.'); window.location.href='gerir_bilhetes.php';</script>";
    exit();
}

$id_bilhete = intval($_POST['id_bilhete']);
$cidade_origem = mysqli_real_escape_string($conn, $_POST['cidade_origem']);
$cidade_destino = mysqli_real_escape_string($conn, $_POST['cidade_destino']);
$data_viagem = $_POST['data_viagem'];

// 1. Obter a viagem e info da rota
$sql_viagem = "
SELECT v.id_viagem, v.hora_partida, v.id_rota,
       rc_origem.num_paragem AS origem_paragem,
       rc_destino.num_paragem AS destino_paragem,
       r.taxa_inicial, r.taxa_paragem
FROM viagem v
JOIN rotas r ON v.id_rota = r.id_rota
JOIN rotas_cidade rc_origem ON r.id_rota = rc_origem.id_rota
JOIN cidades c1 ON rc_origem.id_cidade = c1.id_cidade
JOIN rotas_cidade rc_destino ON r.id_rota = rc_destino.id_rota
JOIN cidades c2 ON rc_destino.id_cidade = c2.id_cidade
WHERE c1.nome_cidade = '$cidade_origem'
  AND c2.nome_cidade = '$cidade_destino'
  AND rc_origem.num_paragem < rc_destino.num_paragem
  AND v.data = '$data_viagem'
LIMIT 1
";

$result_viagem = mysqli_query($conn, $sql_viagem);

if (mysqli_num_rows($result_viagem) === 0) {
    echo "<script>alert('Não existe uma viagem com esses dados.'); window.history.back();</script>";
    exit();
}

$viagem = mysqli_fetch_assoc($result_viagem);
$id_viagem = $viagem['id_viagem'];
$hora_partida = $viagem['hora_partida'];
$origem_paragem = $viagem['origem_paragem'];
$destino_paragem = $viagem['destino_paragem'];
$taxa_inicial = $viagem['taxa_inicial'];
$taxa_paragem = $viagem['taxa_paragem'];

// 2. Calcular nova hora
$horas_adicionais = $origem_paragem - 1;
$nova_hora = date("H:i:s", strtotime("$hora_partida +$horas_adicionais hour"));

// 3. Calcular novo preço
$paragens = $destino_paragem - $origem_paragem;
$preco = $taxa_inicial + ($paragens * $taxa_paragem);

// 4. Obter utilizador do bilhete
$sql_utilizador = "SELECT id_utilizador FROM bilhete WHERE id_bilhete = $id_bilhete";
$result_utilizador = mysqli_query($conn, $sql_utilizador);

if (!$result_utilizador || mysqli_num_rows($result_utilizador) === 0) {
    echo "<script>alert('Utilizador não encontrado.'); window.history.back();</script>";
    exit();
}

$row_utilizador = mysqli_fetch_assoc($result_utilizador);
$id_utilizador = $row_utilizador['id_utilizador'];

// 5. Verificar saldo
$sql_saldo = "SELECT saldo FROM carteiras WHERE id_utilizador = $id_utilizador";
$result_saldo = mysqli_query($conn, $sql_saldo);

if (!$result_saldo || mysqli_num_rows($result_saldo) === 0) {
    echo "<script>alert('Carteira não encontrada.'); window.history.back();</script>";
    exit();
}

$row_saldo = mysqli_fetch_assoc($result_saldo);
$saldo_atual = $row_saldo['saldo'];

if ($saldo_atual < $preco) {
    echo "<script>alert('Saldo insuficiente para atualizar o bilhete.'); window.history.back();</script>";
    exit();
}

// 6. Descontar o saldo
$novo_saldo = $saldo_atual - $preco;
$sql_update_saldo = "UPDATE carteiras SET saldo = $novo_saldo WHERE id_utilizador = $id_utilizador";
mysqli_query($conn, $sql_update_saldo);

// 7. Atualizar o bilhete
$sql_update_bilhete = "
    UPDATE bilhete
    SET cidade_origem = '$cidade_origem',
        cidade_destino = '$cidade_destino',
        data_viagem = '$data_viagem',
        hora = '$nova_hora',
        preco = '$preco',
        id_viagem = $id_viagem
    WHERE id_bilhete = $id_bilhete
";
mysqli_query($conn, $sql_update_bilhete);

// 8. Inserir no extrato bancário (opcional, recomendado)

$sql_estrato = "
INSERT INTO estratos_bancarios (id_carteira, id_utilizador, data_transacao, valor, tipo_transacao)
VALUES (
    (SELECT id_carteira FROM carteiras WHERE id_utilizador = $id_utilizador),
    $id_utilizador,
    NOW(),
    $preco,
    0 
)";
mysqli_query($conn, $sql_estrato);

// 9. Finalizar
echo "<script>alert('Bilhete atualizado com sucesso.'); window.location.href='gerir_bilhetes.php';</script>";
?>
