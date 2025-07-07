<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ include file="../basedados/basedados.h" %>
<%
// Verificar se o utilizador tem nível de acesso de cliente (1) ou funcionário (2)
Integer nivel = (Integer) session.getAttribute("nivel");
if(nivel == null || (nivel != 1 && nivel != 2)){
    response.sendRedirect("voltar.jsp");
    return;
}

String origem = request.getParameter("origem");
String destino = request.getParameter("destino");
String dataViagem = request.getParameter("data_viagem");

ArrayList<Map<String, Object>> viagens = new ArrayList<>();
boolean hasSearchParams = false;

if (origem != null && destino != null && dataViagem != null &&
    !origem.trim().isEmpty() && !destino.trim().isEmpty() && !dataViagem.trim().isEmpty()) {

    hasSearchParams = true;

    String sql = "SELECT " +
        "v.id_viagem, " +
        "r.nome_rota, " +
        "v.data, " +
        "v.hora_partida, " +
        "v.hora_chegada, " +
        "co.nome_cidade AS origem, " +
        "cd.nome_cidade AS destino, " +
        "r.taxa_inicial + (ABS(rcd.num_paragem - rco.num_paragem) * r.taxa_paragem) AS preco_estimado " +
        "FROM viagem v " +
        "JOIN rotas r ON v.id_rota = r.id_rota " +
        "JOIN rotas_cidade rco ON rco.id_rota = v.id_rota " +
        "JOIN rotas_cidade rcd ON rcd.id_rota = v.id_rota " +
        "JOIN cidades co ON rco.id_cidade = co.id_cidade " +
        "JOIN cidades cd ON rcd.id_cidade = cd.id_cidade " +
        "WHERE v.data = ? " +
        "AND co.nome_cidade = ? " +
        "AND cd.nome_cidade = ? " +
        "AND rco.num_paragem < rcd.num_paragem " +
        "AND v.estado_viagem = 1 " +
        "AND v.vagas > 0 " +
        "ORDER BY v.hora_partida";

    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, dataViagem);
    stmt.setString(2, origem);
    stmt.setString(3, destino);
    ResultSet result = stmt.executeQuery();

    // Carregar todos os resultados para uma lista
    while (result.next()) {
        Map<String, Object> viagem = new HashMap<>();
        viagem.put("id_viagem", result.getInt("id_viagem"));
        viagem.put("nome_rota", result.getString("nome_rota"));
        viagem.put("data", result.getString("data"));
        viagem.put("hora_partida", result.getString("hora_partida"));
        viagem.put("hora_chegada", result.getString("hora_chegada"));
        viagem.put("origem", result.getString("origem"));
        viagem.put("destino", result.getString("destino"));
        viagem.put("preco_estimado", result.getDouble("preco_estimado"));
        viagens.add(viagem);
    }

    result.close();
    stmt.close();
}
%>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <title>Comprar Bilhete - FelixBus</title>
  <link href="bootstrap.min.css" rel="stylesheet">
  <style>
    .form-container {
      max-width: 1000px;
      background: #ffffff;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      margin-top: 50px;
    }

    .top-title {
      margin-top: 40px;
      text-align: center;
    }
  </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="voltar.jsp">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="voltar.jsp">Voltar</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Conteúdo -->
<div class="container d-flex justify-content-center">
  <div class="form-container">
    <h3 class="text-center mb-4">Comprar Bilhete</h3>

   

    <form method="post" action="executa_compra.jsp">
    <%
    if (hasSearchParams) {
        if (!viagens.isEmpty()) {
    %>
        <table class="table table-bordered align-middle">
            <thead>
                <tr>
                    <th>Rota</th>
                    <th>Data</th>
                    <th>Partida</th>
                    <th>Chegada</th>
                    <th>Origem</th>
                    <th>Destino</th>
                    <th>Preço</th>
                    <th>Comprar</th>
                </tr>
            </thead>
            <tbody>
            <%
            for (Map<String, Object> viagem : viagens) {
                int idViagem = (Integer) viagem.get("id_viagem");
                String nomeRota = (String) viagem.get("nome_rota");
                String data = (String) viagem.get("data");
                String horaPartida = (String) viagem.get("hora_partida");
                String horaChegada = (String) viagem.get("hora_chegada");
                String origemResult = (String) viagem.get("origem");
                String destinoResult = (String) viagem.get("destino");
                double precoEstimado = (Double) viagem.get("preco_estimado");

                // Escapar HTML para segurança
                if (nomeRota != null) nomeRota = nomeRota.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                if (data != null) data = data.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                if (horaPartida != null) horaPartida = horaPartida.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                if (horaChegada != null) horaChegada = horaChegada.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                if (origemResult != null) origemResult = origemResult.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                if (destinoResult != null) destinoResult = destinoResult.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
            %>
                <tr>
                    <td><%= nomeRota != null ? nomeRota : "" %></td>
                    <td><%= data != null ? data : "" %></td>
                    <td><%= horaPartida != null ? horaPartida : "" %></td>
                    <td><%= horaChegada != null ? horaChegada : "" %></td>
                    <td><%= origemResult != null ? origemResult : "" %></td>
                    <td><%= destinoResult != null ? destinoResult : "" %></td>
                    <td><%= String.format("%.2f", precoEstimado) %> €</td>
                    <td>
                        <button type="submit" name="id_viagem" value="<%= idViagem %>" class="btn btn-success btn-sm">
                            Comprar
                        </button>
                        <input type="hidden" name="origem" value="<%= origemResult != null ? origemResult : "" %>">
                        <input type="hidden" name="destino" value="<%= destinoResult != null ? destinoResult : "" %>">
                        <input type="hidden" name="data" value="<%= data != null ? data : "" %>">
                        <input type="hidden" name="preco" value="<%= precoEstimado %>">
                    </td>
                </tr>
            <%
            }
            %>
            </tbody>
        </table>
    <%
        } else {
    %>
        <div class="alert alert-warning text-center">Nenhum bilhete encontrado para os critérios selecionados.</div>
    <%
        }
    } else {
    %>
        <div class="alert alert-info text-center">Por favor, preencha todos os campos para pesquisar viagens.</div>
    <%
    }
    %>
</form>

  </div>
</div>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
