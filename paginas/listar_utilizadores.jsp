<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
// Verificar se o utilizador tem nível de acesso de administrador (3)
if (session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(3)) {
    response.sendRedirect("voltar.jsp");
    return;
}

// Inicializar variáveis
String pesquisa = request.getParameter("pesquisa");
String nivel = request.getParameter("nivel");
String ordenar = request.getParameter("ordenar");

if (pesquisa == null) pesquisa = "";
if (nivel == null) nivel = "";
if (ordenar == null) ordenar = "";

// Construção da query base
StringBuilder sql = new StringBuilder();
sql.append("SELECT u.*, n.descricao AS nivel, c.saldo ");
sql.append("FROM utilizadores u ");
sql.append("JOIN nivel_acesso n ON u.nivel_acesso = n.nivel_acesso ");
sql.append("LEFT JOIN carteiras c ON u.id_utilizador = c.id_utilizador ");
sql.append("WHERE 1=1 ");

// Lista de parâmetros para PreparedStatement
java.util.List<Object> params = new java.util.ArrayList<>();

// Filtro por nome
if (!pesquisa.isEmpty()) {
    sql.append("AND u.nome_utilizador LIKE ? ");
    params.add("%" + pesquisa + "%");
}

// Filtro por nível de acesso
if (!nivel.isEmpty()) {
    try {
        int nivelInt = Integer.parseInt(nivel);
        sql.append("AND u.nivel_acesso = ? ");
        params.add(nivelInt);
    } catch (NumberFormatException e) {
        // Ignorar se não for um número válido
    }
}

// Ordenação
if ("saldo".equals(ordenar)) {
    sql.append("ORDER BY c.saldo DESC");
} else if ("data_nasc".equals(ordenar)) {
    sql.append("ORDER BY u.data_nasc DESC");
}

// Executar a query
PreparedStatement stmt = conn.prepareStatement(sql.toString());
for (int i = 0; i < params.size(); i++) {
    stmt.setObject(i + 1, params.get(i));
}
ResultSet result = stmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Menu Admin - FelixBus</title>
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
        <a class="navbar-brand" href="voltar.jsp">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="gestao_utilizadores.jsp">Voltar</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <br>
    <h1>Utilizadores</h1>
    <br>

    <!-- Formulário de Filtro -->
    <form method="POST" action="listar_utilizadores.jsp" class="row g-3 mb-4">
        <div class="col-md-4">
            <input type="text" class="form-control" name="pesquisa" placeholder="Pesquisar por nome" value="<%= pesquisa %>">
        </div>

        <div class="col-md-3">
            <select class="form-select" name="nivel">
                <option value="">Todos os níveis</option>
                <%
                PreparedStatement nivelStmt = conn.prepareStatement("SELECT * FROM nivel_acesso");
                ResultSet nivelResult = nivelStmt.executeQuery();
                while (nivelResult.next()) {
                    String nivelAcesso = String.valueOf(nivelResult.getInt("nivel_acesso"));
                    String descricao = nivelResult.getString("descricao");
                    String selected = nivel.equals(nivelAcesso) ? "selected" : "";
                    out.print("<option value='" + nivelAcesso + "' " + selected + ">" + descricao + "</option>");
                }
                nivelResult.close();
                nivelStmt.close();
                %>
            </select>
        </div>

        <div class="col-md-3">
            <select class="form-select" name="ordenar">
                <option value="">Ordenar por</option>
                <option value="saldo" <%= "saldo".equals(ordenar) ? "selected" : "" %>>Saldo</option>
                <option value="data_nasc" <%= "data_nasc".equals(ordenar) ? "selected" : "" %>>Data de Nascimento</option>
            </select>
        </div>

        <div class="col-md-2">
            <button type="submit" class="btn btn-primary w-100">Filtrar</button>
        </div>
    </form>

    <!-- Tabela de Resultados -->
    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>Nome do Utilizador</th>
                <th>Email</th>
                <th>Data Nascimento</th>
                <th>Nível de Acesso</th>
                <th>Saldo</th>
            </tr>
        </thead>
        <tbody>
            <%
            boolean hasResults = false;
            while (result.next()) {
                hasResults = true;
                String nomeUtilizador = result.getString("nome_utilizador");
                String email = result.getString("email");
                String dataNasc = result.getString("data_nasc");
                String nivelDesc = result.getString("nivel");
                String saldo = result.getString("saldo");

                // Escapar HTML para segurança
                if (nomeUtilizador != null) nomeUtilizador = nomeUtilizador.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                if (email != null) email = email.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                if (dataNasc != null) dataNasc = dataNasc.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                if (nivelDesc != null) nivelDesc = nivelDesc.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                if (saldo != null) saldo = saldo.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

                out.print("<tr>");
                out.print("<td>" + (nomeUtilizador != null ? nomeUtilizador : "") + "</td>");
                out.print("<td>" + (email != null ? email : "") + "</td>");
                out.print("<td>" + (dataNasc != null ? dataNasc : "") + "</td>");
                out.print("<td>" + (nivelDesc != null ? nivelDesc : "") + "</td>");
                out.print("<td>" + (saldo != null ? saldo : "0") + " €</td>");
                out.print("</tr>");
            }

            if (!hasResults) {
                out.print("<tr><td colspan='5'>Nenhum utilizador encontrado.</td></tr>");
            }

            result.close();
            stmt.close();
            %>
        </tbody>
    </table>
    <br>
</div>

</body>
</html>
