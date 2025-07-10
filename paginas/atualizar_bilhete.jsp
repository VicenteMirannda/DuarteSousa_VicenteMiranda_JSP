<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%
// Verificar se a sessão existe e se o nível é 1
Integer nivel = (Integer) session.getAttribute("nivel");
if (nivel == null || nivel != 1) {
    response.sendRedirect("voltar.jsp");
    return;
}
%>
<%@ include file="../basedados/basedados.h" %>

<%
// Verificar se todos os parâmetros necessários foram enviados
if (request.getParameter("id_bilhete") == null || 
    request.getParameter("cidade_origem") == null || 
    request.getParameter("cidade_destino") == null || 
    request.getParameter("data_viagem") == null) {
    out.println("<script>alert('Dados incompletos.'); window.location.href='gerir_bilhetes.jsp';</script>");
    return;
}

int id_bilhete = Integer.parseInt(request.getParameter("id_bilhete"));
String cidade_origem = request.getParameter("cidade_origem").replace("'", "''");
String cidade_destino = request.getParameter("cidade_destino").replace("'", "''");
String data_viagem = request.getParameter("data_viagem");

// 1. Obter a viagem e info da rota
String sql_viagem = "SELECT v.id_viagem, v.hora_partida, v.id_rota, " +
                   "rc_origem.num_paragem AS origem_paragem, " +
                   "rc_destino.num_paragem AS destino_paragem, " +
                   "r.taxa_inicial, r.taxa_paragem " +
                   "FROM viagem v " +
                   "JOIN rotas r ON v.id_rota = r.id_rota " +
                   "JOIN rotas_cidade rc_origem ON r.id_rota = rc_origem.id_rota " +
                   "JOIN cidades c1 ON rc_origem.id_cidade = c1.id_cidade " +
                   "JOIN rotas_cidade rc_destino ON r.id_rota = rc_destino.id_rota " +
                   "JOIN cidades c2 ON rc_destino.id_cidade = c2.id_cidade " +
                   "WHERE c1.nome_cidade = '" + cidade_origem + "' " +
                   "AND c2.nome_cidade = '" + cidade_destino + "' " +
                   "AND rc_origem.num_paragem < rc_destino.num_paragem " +
                   "AND v.data = '" + data_viagem + "' " +
                   "LIMIT 1";

Statement stmt_viagem = conn.createStatement();
ResultSet result_viagem = stmt_viagem.executeQuery(sql_viagem);

if (!result_viagem.next()) {
    out.println("<script>alert('Não existe uma viagem com esses dados.'); window.history.back();</script>");
    return;
}

int id_viagem = result_viagem.getInt("id_viagem");
String hora_partida = result_viagem.getString("hora_partida");
int origem_paragem = result_viagem.getInt("origem_paragem");
int destino_paragem = result_viagem.getInt("destino_paragem");
double taxa_inicial = result_viagem.getDouble("taxa_inicial");
double taxa_paragem = result_viagem.getDouble("taxa_paragem");

result_viagem.close();
stmt_viagem.close();

// 2. Calcular nova hora
int horas_adicionais = origem_paragem - 1;
SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
Calendar cal = Calendar.getInstance();
cal.setTime(sdf.parse(hora_partida));
cal.add(Calendar.HOUR_OF_DAY, horas_adicionais);
String nova_hora = sdf.format(cal.getTime());

// 3. Calcular novo preço
int paragens = destino_paragem - origem_paragem;
double preco = taxa_inicial + (paragens * taxa_paragem);

// 4. Obter utilizador do bilhete
String sql_utilizador = "SELECT id_utilizador FROM bilhete WHERE id_bilhete = " + id_bilhete;
Statement stmt_utilizador = conn.createStatement();
ResultSet result_utilizador = stmt_utilizador.executeQuery(sql_utilizador);

if (!result_utilizador.next()) {
    out.println("<script>alert('Utilizador não encontrado.'); window.history.back();</script>");
    return;
}

int id_utilizador = result_utilizador.getInt("id_utilizador");
result_utilizador.close();
stmt_utilizador.close();

// 5. Verificar saldo
String sql_saldo = "SELECT saldo FROM carteiras WHERE id_utilizador = " + id_utilizador;
Statement stmt_saldo = conn.createStatement();
ResultSet result_saldo = stmt_saldo.executeQuery(sql_saldo);

if (!result_saldo.next()) {
    out.println("<script>alert('Carteira não encontrada.'); window.history.back();</script>");
    return;
}

double saldo_atual = result_saldo.getDouble("saldo");
result_saldo.close();
stmt_saldo.close();

if (saldo_atual < preco) {
    out.println("<script>alert('Saldo insuficiente para atualizar o bilhete.'); window.history.back();</script>");
    return;
}

// 6. Descontar o saldo
double novo_saldo = saldo_atual - preco;
String sql_update_saldo = "UPDATE carteiras SET saldo = " + novo_saldo + " WHERE id_utilizador = " + id_utilizador;
Statement stmt_update_saldo = conn.createStatement();
stmt_update_saldo.executeUpdate(sql_update_saldo);
stmt_update_saldo.close();

// 7. Atualizar o bilhete
String sql_update_bilhete = "UPDATE bilhete " +
                           "SET cidade_origem = '" + cidade_origem + "', " +
                           "cidade_destino = '" + cidade_destino + "', " +
                           "data_viagem = '" + data_viagem + "', " +
                           "hora = '" + nova_hora + "', " +
                           "preco = '" + preco + "', " +
                           "id_viagem = " + id_viagem + " " +
                           "WHERE id_bilhete = " + id_bilhete;

Statement stmt_update_bilhete = conn.createStatement();
stmt_update_bilhete.executeUpdate(sql_update_bilhete);
stmt_update_bilhete.close();

// 8. Inserir no extrato bancário (opcional, recomendado)
String sql_estrato = "INSERT INTO estratos_bancarios (id_carteira, id_utilizador, data_transacao, valor, tipo_transacao) " +
                    "VALUES (" +
                    "(SELECT id_carteira FROM carteiras WHERE id_utilizador = " + id_utilizador + "), " +
                    id_utilizador + ", " +
                    "NOW(), " +
                    preco + ", " +
                    "0)";

Statement stmt_estrato = conn.createStatement();
stmt_estrato.executeUpdate(sql_estrato);
stmt_estrato.close();

// 9. Finalizar
out.println("<script>alert('Bilhete atualizado com sucesso.'); window.location.href='gerir_bilhetes.jsp';</script>");
%>
