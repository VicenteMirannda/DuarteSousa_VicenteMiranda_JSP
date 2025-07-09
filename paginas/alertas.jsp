<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>
<%
// Lógica de filtro e ordenação
String ordenar_por = request.getParameter("ordenar_por");
if (ordenar_por == null) {
    ordenar_por = "";
}

String sql = "SELECT a.*, t.descricao AS tipo_descricao, r.nome_rota " +
             "FROM alertas a " +
             "LEFT JOIN tipo_alerta t ON a.tipo = t.id_tipo " +
             "LEFT JOIN rotas r ON a.id_rota = r.id_rota";

// Aplicar ordenação
if (!ordenar_por.isEmpty()) {
    sql += " ORDER BY CASE " +
           "WHEN t.descricao = ? THEN 0 " +
           "ELSE 1 " +
           "END, t.descricao ASC";
}

PreparedStatement stmt = null;
ResultSet result = null;
int total_alertas = 0;

try {
    // Executar query principal
    stmt = conn.prepareStatement(sql);
    if (!ordenar_por.isEmpty()) {
        stmt.setString(1, ordenar_por);
    }
    result = stmt.executeQuery();
    
    // Contar alertas para navbar
    PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(*) FROM alertas");
    ResultSet countResult = countStmt.executeQuery();
    if (countResult.next()) {
        total_alertas = countResult.getInt(1);
    }
    countResult.close();
    countStmt.close();
} catch (SQLException e) {
    out.println("Erro ao carregar alertas: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Alertas - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        /* estilos iguais aos anteriores (mantidos para consistência visual) */
        body {
            background-color: #e9ecef;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            background: #fff;
            margin-top: 40px;
            margin-bottom: 40px;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            font-weight: 700;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
        }

        thead th {
            background-color: #0d6efd;
            color: #fff;
            padding: 12px 15px;
            text-align: center;
        }

        tbody tr {
            background-color: #f8f9fa;
        }

        tbody td {
            padding: 15px;
            text-align: center;
        }

        form button {
            width: 100%;
        }

        .navbar-brand {
            font-weight: 700;
            letter-spacing: 0.08em;
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="voltar.jsp">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="consultar_rotas.jsp">Consultar Rotas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-warning" href="alertas.jsp">
                        Alertas <i class="bi bi-bell-fill"></i>
                        <span class="badge bg-danger"><%= total_alertas %></span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="localizacao.jsp">Localização</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="contactos.jsp">Contactos</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="login.jsp">Login/Registar</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- CONTEÚDO -->
<div class="container">
    <h1>Alertas</h1>

    <!-- FORMULÁRIO DE FILTRO -->
    <form method="post" class="mb-5">
        <label for="ordenar_por" class="form-label fw-semibold">Filtrar por tipo de alerta:</label>
        <select name="ordenar_por" id="ordenar_por" class="form-select">
            <option value="">Todos</option>
            <option value="promocoes" <%= "promocoes".equals(ordenar_por) ? "selected" : "" %>>Promoções</option>
            <option value="altera_horario" <%= "altera_horario".equals(ordenar_por) ? "selected" : "" %>>Alteração de Horários</option>
            <option value="cancelamento" <%= "cancelamento".equals(ordenar_por) ? "selected" : "" %>>Cancelamento</option>
        </select>
        <button type="submit" class="btn btn-primary mt-3">Aplicar Filtro</button>
    </form>

    <!-- TABELA DE ALERTAS -->
    <table class="table table-striped">
        <thead>
            <tr>
                
                <th>Rota</th>
                <th>ID Viagem</th>
                <th>Tipo</th>
                <th>Descrição</th>
            </tr>
        </thead>
        <tbody>
            <%
            boolean hasResults = false;
            try {
                if (result != null) {
                    while (result.next()) {
                        hasResults = true;
                        String nome_rota = result.getString("nome_rota") != null ? result.getString("nome_rota") : "";
                        String id_viagem = result.getString("id_viagem") != null ? result.getString("id_viagem") : "";
                        String tipo_descricao = result.getString("tipo_descricao") != null ? result.getString("tipo_descricao") : "";
                        String id_alerta = result.getString("id_alerta") != null ? result.getString("id_alerta") : "";
            %>
                        <tr>
                            <td><%= nome_rota %></td>
                            <td><%= id_viagem %></td>
                            <td><%= tipo_descricao %></td>
                            <td>
                                <form method="POST" action="descricao_a.jsp">
                                    <input type="hidden" name="id_alerta" value="<%= id_alerta %>">
                                    <button type="submit" class="btn btn-outline-primary btn-sm">Ver Descrição</button>
                                </form>
                            </td>
                        </tr>
            <%
                    }
                }
                if (!hasResults) {
            %>
                    <tr><td colspan="4">Nenhum alerta encontrado.</td></tr>
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

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
