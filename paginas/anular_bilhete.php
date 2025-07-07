<?php
session_start();
include '../basedados/basedados.h';

if ($_SESSION['nivel'] != 1 && $_SESSION['nivel'] != 2) {
    header('Location: voltar.php');
    exit();
}

$id_bilhete = $_GET['id'] ?? null;

if (isset($id_bilhete)) {
    // Verificar se o bilhete existe
    $query = "SELECT * FROM bilhete WHERE id_bilhete = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $id_bilhete);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {

        $query_info = "SELECT preco, id_utilizador FROM bilhete WHERE id_bilhete = ?";
        $stmt_info = $conn->prepare($query_info);
        $stmt_info->bind_param("i", $id_bilhete);
        $stmt_info->execute();
        $result_info = $stmt_info->get_result();
        if ($row = $result_info->fetch_assoc()) {
            $valor = $row['preco'];
            $id_utilizador = $row['id_utilizador'];
        }
        $stmt_info->close();

        // Bilhete encontrado, proceder com a anulação
        $query_delete = "DELETE FROM bilhete WHERE id_bilhete = ?";
        $stmt_delete = $conn->prepare($query_delete);
        $stmt_delete->bind_param("i", $id_bilhete);
        if ($stmt_delete->execute()) {
            // Devolver o dinheiro do bilhete e criar um extrato bancário
            $query_update = "UPDATE carteiras SET saldo = saldo + ? WHERE id_utilizador = ?";
            $stmt_update = $conn->prepare($query_update);
            $stmt_update->bind_param("di", $valor, $id_utilizador);
            $stmt_update->execute();
            $stmt_update->close();

            $query_carteira = "SELECT id_carteira FROM carteiras WHERE id_utilizador = ?";
            $stmt_carteira = $conn->prepare($query_carteira);
            $stmt_carteira->bind_param("i", $id_utilizador);
            $stmt_carteira->execute();
            $result_carteira = $stmt_carteira->get_result();
            $id_carteira = null;
            if ($row_carteira = $result_carteira->fetch_assoc()) {
                $id_carteira = $row_carteira['id_carteira'];
            }
            $stmt_carteira->close();

            if ($id_carteira !== null) {
                $tipo_transacao = 1;
                $query_extrato = "INSERT INTO estratos_bancarios (id_carteira, id_utilizador, data_transacao, valor, tipo_transacao) VALUES (?, ?, NOW(), ?, ?)";
                $stmt_extrato = $conn->prepare($query_extrato);
                $stmt_extrato->bind_param("iidi", $id_carteira, $id_utilizador, $valor, $tipo_transacao);
                $stmt_extrato->execute();
                $stmt_extrato->close();
            }

            echo "<script>alert('Bilhete anulado com sucesso!'); window.location.href='voltar.php';</script>";
        } else {
            echo "<script>alert('Erro ao anular o bilhete. Tente novamente.'); window.location.href='voltar.php';</script>";
        }
        $stmt_delete->close();
    } else {
        echo "<script>alert('Bilhete não encontrado.'); window.location.href='voltar.php';</script>";
    }
    $stmt->close();
} else {
    echo "<script>alert('ID do bilhete inválido.'); window.location.href='voltar.php';</script>";
}
?>
