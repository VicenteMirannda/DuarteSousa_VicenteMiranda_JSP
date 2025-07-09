<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Arrays" %>
<%@ include file="../basedados/basedados.h" %>
<%
// Recolher dados do formulário (POST)
String nome_rota = request.getParameter("nome_rota");
if (nome_rota == null) nome_rota = "";

String min_paragens_param = request.getParameter("min_paragens");
int min_paragens = -1;
if (min_paragens_param != null && !min_paragens_param.isEmpty()) {
    try {
        min_paragens = Integer.parseInt(min_paragens_param);
    } catch (NumberFormatException e) {
        min_paragens = -1;
    }
}

String ordenar_por = request.getParameter("ordenar_por");
String[] validColumns = {"nome_rota", "taxa_inicial", "num_paragens"};
if (ordenar_por == null || !Arrays.asList(validColumns).contains(ordenar_por)) {
    ordenar_por = "nome_rota";
}

String ordem = request.getParameter("ordem");
if (!"DESC".equals(ordem)) {
    ordem = "ASC";
}

// Construir a query com base nos filtros
String sql = "SELECT * FROM rotas WHERE 1=1";

if (!nome_rota.isEmpty()) {
    sql += " AND nome_rota LIKE ?";
}
if (min_paragens != -1) {
    sql += " AND num_paragens >= ?";
}

sql += " ORDER BY " + ordenar_por + " " + ordem;

PreparedStatement stmt = null;
ResultSet result = null;

try {
    stmt = conn.prepareStatement(sql);
    int paramIndex = 1;
    
    if (!nome_rota.isEmpty()) {
        stmt.setString(paramIndex++, "%" + nome_rota + "%");
    }
    if (min_paragens != -1) {
        stmt.setInt(paramIndex++, min_paragens);
    }
    
    result = stmt.executeQuery();
} catch (SQLException e) {
    out.println("Erro ao executar consulta: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Filtrar Rotas - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <br>
    <h1>Resultado da filtragem de Rotas</h1>
    <a href="listar_rotas.jsp" class="btn btn-secondary">Voltar</a>
    <br><br>

    <table class="table">
        <thead>
            <tr>
                <th>Rota</th>
                <th>Taxa Inicial</th>
                <th>Taxa por Paragem</th>
                <th>Nº de Paragens</th>
            </tr>
        </thead>
        <tbody>
            <%
            boolean hasResults = false;
            try {
                if (result != null) {
                    while (result.next()) {
                        hasResults = true;
                        String nome_rota_result = result.getString("nome_rota") != null ? result.getString("nome_rota") : "";
                        String taxa_inicial = result.getString("taxa_inicial") != null ? result.getString("taxa_inicial") : "";
                        String taxa_paragem = result.getString("taxa_paragem") != null ? result.getString("taxa_paragem") : "";
                        String num_paragens = result.getString("num_paragens") != null ? result.getString("num_paragens") : "";
            %>
                        <tr>
                            <td><%= nome_rota_result %></td>
                            <td><%= taxa_inicial %> €</td>
                            <td><%= taxa_paragem %> €</td>
                            <td><%= num_paragens %></td>
                        </tr>
            <%
                    }
                }
                if (!hasResults) {
            %>
                    <tr><td colspan='4'>Nenhuma rota encontrada com os filtros aplicados.</td></tr>
            <%
                }
            } catch (SQLException e) {
                out.println("Erro ao processar resultados: " + e.getMessage());
            } finally {
                if (result != null) {
                    try { result.close(); } catch (SQLException e) {}
                }
                if (stmt != null) {
                    try { stmt.close(); } catch (SQLException e) {}
                }
            }
            %>
        </tbody>
    </table>
</div>
</body>
</html>
