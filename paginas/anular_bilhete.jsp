<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// Verificar se a sessão existe e se o nível é 1 ou 2
Integer nivel = (Integer) session.getAttribute("nivel");
if (nivel == null || (nivel != 1 && nivel != 2)) {
    response.sendRedirect("voltar.jsp");
    return;
}
%>
<%@ include file="../basedados/basedados.h" %>

<%
String id_bilhete_str = request.getParameter("id");

if (id_bilhete_str != null) {
    try {
        int id_bilhete = Integer.parseInt(id_bilhete_str);
        
        // Verificar se o bilhete existe
        String query = "SELECT * FROM bilhete WHERE id_bilhete = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setInt(1, id_bilhete);
        ResultSet result = stmt.executeQuery();

        if (result.next()) {
            // Obter informações do bilhete
            String query_info = "SELECT preco, id_utilizador FROM bilhete WHERE id_bilhete = ?";
            PreparedStatement stmt_info = conn.prepareStatement(query_info);
            stmt_info.setInt(1, id_bilhete);
            ResultSet result_info = stmt_info.executeQuery();
            
            double valor = 0;
            int id_utilizador = 0;
            
            if (result_info.next()) {
                valor = result_info.getDouble("preco");
                id_utilizador = result_info.getInt("id_utilizador");
            }
            result_info.close();
            stmt_info.close();

            // Bilhete encontrado, proceder com a anulação
            String query_delete = "DELETE FROM bilhete WHERE id_bilhete = ?";
            PreparedStatement stmt_delete = conn.prepareStatement(query_delete);
            stmt_delete.setInt(1, id_bilhete);
            
            if (stmt_delete.executeUpdate() > 0) {
                // Devolver o dinheiro do bilhete e criar um extrato bancário
                String query_update = "UPDATE carteiras SET saldo = saldo + ? WHERE id_utilizador = ?";
                PreparedStatement stmt_update = conn.prepareStatement(query_update);
                stmt_update.setDouble(1, valor);
                stmt_update.setInt(2, id_utilizador);
                stmt_update.executeUpdate();
                stmt_update.close();

                // Obter ID da carteira
                String query_carteira = "SELECT id_carteira FROM carteiras WHERE id_utilizador = ?";
                PreparedStatement stmt_carteira = conn.prepareStatement(query_carteira);
                stmt_carteira.setInt(1, id_utilizador);
                ResultSet result_carteira = stmt_carteira.executeQuery();
                
                Integer id_carteira = null;
                if (result_carteira.next()) {
                    id_carteira = result_carteira.getInt("id_carteira");
                }
                result_carteira.close();
                stmt_carteira.close();

                if (id_carteira != null) {
                    int tipo_transacao = 1;
                    String query_extrato = "INSERT INTO estratos_bancarios (id_carteira, id_utilizador, data_transacao, valor, tipo_transacao) VALUES (?, ?, NOW(), ?, ?)";
                    PreparedStatement stmt_extrato = conn.prepareStatement(query_extrato);
                    stmt_extrato.setInt(1, id_carteira);
                    stmt_extrato.setInt(2, id_utilizador);
                    stmt_extrato.setDouble(3, valor);
                    stmt_extrato.setInt(4, tipo_transacao);
                    stmt_extrato.executeUpdate();
                    stmt_extrato.close();
                }

                out.println("<script>alert('Bilhete anulado com sucesso!'); window.location.href='voltar.jsp';</script>");
            } else {
                out.println("<script>alert('Erro ao anular o bilhete. Tente novamente.'); window.location.href='voltar.jsp';</script>");
            }
            stmt_delete.close();
        } else {
            out.println("<script>alert('Bilhete não encontrado.'); window.location.href='voltar.jsp';</script>");
        }
        result.close();
        stmt.close();
        
    } catch (NumberFormatException e) {
        out.println("<script>alert('ID do bilhete inválido.'); window.location.href='voltar.jsp';</script>");
    } catch (SQLException e) {
        out.println("<script>alert('Erro na base de dados: " + e.getMessage() + "'); window.location.href='voltar.jsp';</script>");
    }
} else {
    out.println("<script>alert('ID do bilhete inválido.'); window.location.href='voltar.jsp';</script>");
}
%>
