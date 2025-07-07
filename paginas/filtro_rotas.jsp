<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
// Verificar se o utilizador tem nível de acesso de administrador (3)
if(session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(3)){
    response.sendRedirect("voltar.jsp");
    return;
}

// Recolher dados do formulário (POST)
String nomeRota = request.getParameter("nome_rota");
String minParagensParam = request.getParameter("min_paragens");
String ordenarPor = request.getParameter("ordenar_por");
String ordem = request.getParameter("ordem");

// Valores padrão
if (nomeRota == null) nomeRota = "";
int minParagens = 0;
if (minParagensParam != null && !minParagensParam.trim().isEmpty()) {
    try {
        minParagens = Integer.parseInt(minParagensParam);
    } catch (NumberFormatException e) {
        minParagens = 0;
    }
}

// Validar ordenação
if (ordenarPor == null || (!ordenarPor.equals("nome_rota") && !ordenarPor.equals("taxa_inicial") && !ordenarPor.equals("num_paragens"))) {
    ordenarPor = "nome_rota";
}
if (ordem == null || !ordem.equals("DESC")) {
    ordem = "ASC";
}

// Construir a query com base nos filtros
StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM rotas WHERE 1=1");

if (!nomeRota.trim().isEmpty()) {
    sqlBuilder.append(" AND nome_rota LIKE ?");
}
if (minParagensParam != null && !minParagensParam.trim().isEmpty()) {
    sqlBuilder.append(" AND num_paragens >= ?");
}

sqlBuilder.append(" ORDER BY ").append(ordenarPor).append(" ").append(ordem);

PreparedStatement stmt = conn.prepareStatement(sqlBuilder.toString());

int paramIndex = 1;
if (!nomeRota.trim().isEmpty()) {
    stmt.setString(paramIndex++, "%" + nomeRota + "%");
}
if (minParagensParam != null && !minParagensParam.trim().isEmpty()) {
    stmt.setInt(paramIndex++, minParagens);
}

ResultSet result = stmt.executeQuery();
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
            while (result.next()) {
                hasResults = true;
                String nomeRotaResult = result.getString("nome_rota");
                double taxaInicial = result.getDouble("taxa_inicial");
                double taxaParagem = result.getDouble("taxa_paragem");
                int numParagens = result.getInt("num_paragens");

                // Escapar HTML para segurança
                if (nomeRotaResult != null) nomeRotaResult = nomeRotaResult.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

                out.print("<tr>");
                out.print("<td>" + (nomeRotaResult != null ? nomeRotaResult : "") + "</td>");
                out.print("<td>" + taxaInicial + " €</td>");
                out.print("<td>" + taxaParagem + " €</td>");
                out.print("<td>" + numParagens + "</td>");
                out.print("</tr>");
            }

            if (!hasResults) {
                out.print("<tr><td colspan='4'>Nenhuma rota encontrada com os filtros aplicados.</td></tr>");
            }

            result.close();
            stmt.close();
            %>
        </tbody>
    </table>
</div>
</body>
</html>
