<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
// Verificar se o utilizador tem nível de acesso de cliente (1) ou funcionário (2)
Integer nivel = (Integer) session.getAttribute("nivel");
if(nivel == null || (nivel != 1 && nivel != 2)){
    response.sendRedirect("voltar.jsp");
    return;
}

Integer idUtilizador = (Integer) session.getAttribute("id_utilizador");

String idViagemParam = request.getParameter("id_viagem");
String precoParam = request.getParameter("preco");
String origem = request.getParameter("origem");
String destino = request.getParameter("destino");
String data = request.getParameter("data");

if (idUtilizador != null && idViagemParam != null && precoParam != null &&
    origem != null && destino != null && data != null) {

    // parte para o funcionario
    if (nivel == 2) {
        // Redirecionar para executa_compra_funcionario.jsp com os dados via POST
        String idViagemEscaped = idViagemParam.replaceAll("\"", "&quot;").replaceAll("'", "&#39;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
        String origemEscaped = origem.replaceAll("\"", "&quot;").replaceAll("'", "&#39;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
        String destinoEscaped = destino.replaceAll("\"", "&quot;").replaceAll("'", "&#39;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
        String dataEscaped = data.replaceAll("\"", "&quot;").replaceAll("'", "&#39;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
        String precoEscaped = precoParam.replaceAll("\"", "&quot;").replaceAll("'", "&#39;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");

        out.print("<form id='redirectForm' action='executa_compra_funcionario.jsp' method='POST' style='display:none;'>");
        out.print("<input type='hidden' name='id_viagem' value='" + idViagemEscaped + "'>");
        out.print("<input type='hidden' name='origem' value='" + origemEscaped + "'>");
        out.print("<input type='hidden' name='destino' value='" + destinoEscaped + "'>");
        out.print("<input type='hidden' name='data' value='" + dataEscaped + "'>");
        out.print("<input type='hidden' name='preco' value='" + precoEscaped + "'>");
        out.print("</form>");
        out.print("<script>");
        out.print("document.getElementById('redirectForm').submit();");
        out.print("</script>");
        return;
    }

    // parte do cliente
    if (nivel == 1) {
        // código para cliente
        // Verificar saldo do cliente
        PreparedStatement stmtSaldo = conn.prepareStatement("SELECT saldo FROM carteiras WHERE id_utilizador = ?");
        stmtSaldo.setInt(1, idUtilizador);
        ResultSet resultSaldo = stmtSaldo.executeQuery();

        double saldo = 0;
        if (resultSaldo.next()) {
            saldo = resultSaldo.getDouble("saldo");
        }
        resultSaldo.close();
        stmtSaldo.close();

        double precoEstimado = 0;
        try {
            precoEstimado = Double.parseDouble(precoParam);
        } catch (NumberFormatException e) {
            out.print("<script>alert('Preço inválido.'); window.location.href='voltar.jsp';</script>");
            return;
        }

        if (saldo < precoEstimado) {
            // Saldo insuficiente
            out.print("<script>alert('Saldo insuficiente para realizar a compra.'); window.location.href='voltar.jsp';</script>");
            return;
        } else {
            int idViagem = 0;
            try {
                idViagem = Integer.parseInt(idViagemParam);
            } catch (NumberFormatException e) {
                out.print("<script>alert('ID da viagem inválido.'); window.location.href='voltar.jsp';</script>");
                return;
            }

            // Buscar o número da paragem correspondente à origem
            PreparedStatement stmtParagem = conn.prepareStatement(
                "SELECT rc.num_paragem " +
                "FROM rotas_cidade rc " +
                "INNER JOIN cidades c ON rc.id_cidade = c.id_cidade " +
                "WHERE c.nome_cidade = ?"
            );
            stmtParagem.setString(1, origem);
            ResultSet resultParagem = stmtParagem.executeQuery();

            int numeroParagem = 0;
            if (resultParagem.next()) {
                numeroParagem = resultParagem.getInt("num_paragem");
            }
            resultParagem.close();
            stmtParagem.close();

            // Buscar a hora da viagem pelo id_viagem
            PreparedStatement stmtHora = conn.prepareStatement("SELECT hora_partida FROM viagem WHERE id_viagem = ?");
            stmtHora.setInt(1, idViagem);
            ResultSet resultHora = stmtHora.executeQuery();

            String horaPartida = "";
            if (resultHora.next()) {
                horaPartida = resultHora.getString("hora_partida");
            }
            resultHora.close();
            stmtHora.close();

            // Adiciona (numero_paragem - 1) horas à hora de partida
            java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("HH:mm:ss");
            java.util.Calendar cal = java.util.Calendar.getInstance();
            try {
                cal.setTime(timeFormat.parse(horaPartida));
                int horasAdicionar = Math.max(0, numeroParagem - 1);
                cal.add(java.util.Calendar.HOUR_OF_DAY, horasAdicionar);
            } catch (java.text.ParseException e) {
                // Se falhar o parse, usar a hora original
            }
            String pontoHora = timeFormat.format(cal.getTime());


            // Inserir bilhete
            PreparedStatement stmtBilhete = conn.prepareStatement(
                "INSERT INTO bilhete (id_utilizador, id_viagem, cidade_origem, cidade_destino, data_viagem, hora, preco) VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            stmtBilhete.setInt(1, idUtilizador);
            stmtBilhete.setInt(2, idViagem);
            stmtBilhete.setString(3, origem);
            stmtBilhete.setString(4, destino);
            stmtBilhete.setString(5, data);
            stmtBilhete.setString(6, pontoHora);
            stmtBilhete.setDouble(7, precoEstimado);

            // Retirar uma vaga da viagem
            PreparedStatement stmtVagas = conn.prepareStatement("UPDATE viagem SET vagas = vagas - 1 WHERE id_viagem = ?");
            stmtVagas.setInt(1, idViagem);

            boolean bilheteInserido = stmtBilhete.executeUpdate() > 0;

            if (bilheteInserido) {
                // Atualizar saldo do utilizador
                double novoSaldo = saldo - precoEstimado;
                PreparedStatement stmtUpdateSaldo = conn.prepareStatement("UPDATE carteiras SET saldo = ? WHERE id_utilizador = ?");
                stmtUpdateSaldo.setDouble(1, novoSaldo);
                stmtUpdateSaldo.setInt(2, idUtilizador);
                stmtUpdateSaldo.executeUpdate();
                stmtUpdateSaldo.close();

                // Buscar id_carteira
                PreparedStatement stmtCarteira = conn.prepareStatement("SELECT id_carteira FROM carteiras WHERE id_utilizador = ?");
                stmtCarteira.setInt(1, idUtilizador);
                ResultSet resultCarteira = stmtCarteira.executeQuery();

                int idCarteira = 0;
                if (resultCarteira.next()) {
                    idCarteira = resultCarteira.getInt("id_carteira");
                }
                resultCarteira.close();
                stmtCarteira.close();

                // Criar extrato bancário
                int tipoTransacao = 0; // 0 para débito
                PreparedStatement stmtExtrato = conn.prepareStatement(
                    "INSERT INTO estratos_bancarios (id_carteira, id_utilizador, tipo_transacao, valor, data_transacao) VALUES (?, ?, ?, ?, NOW())"
                );
                stmtExtrato.setInt(1, idCarteira);
                stmtExtrato.setInt(2, idUtilizador);
                stmtExtrato.setInt(3, tipoTransacao);
                stmtExtrato.setDouble(4, precoEstimado);
                stmtExtrato.executeUpdate();
                stmtExtrato.close();

                // Executar atualização das vagas
                stmtVagas.executeUpdate();
                stmtVagas.close();

                out.print("<script>alert('Compra realizada com sucesso!'); window.location.href='voltar.jsp';</script>");
            } else {
                out.print("<script>alert('Erro ao criar bilhete.'); window.location.href='voltar.jsp';</script>");
            }

            stmtBilhete.close();
        }

    }
} else {
    out.print("<script>alert('Dados inválidos.'); window.location.href='voltar.jsp';</script>");
}
%>
