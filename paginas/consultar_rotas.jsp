<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ include file="../basedados/basedados.h" %>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Rotas - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #e9ecef;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            background: #ffffff;
            margin-top: 40px;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            font-weight: bold;
            color: #343a40;
            margin-bottom: 30px;
        }

        form {
            margin-bottom: 40px;
        }

        input[type="text"],
        input[type="number"],
        select {
            padding: 10px;
            margin: 5px 10px 10px 0;
            width: 220px;
            border-radius: 6px;
            border: 1px solid #ced4da;
        }

        .btn {
            margin-top: 10px;
        }

        thead th {
            background-color: #0d6efd;
            color: #fff;
            text-align: center;
            padding: 12px;
            font-size: 18px;
            font-weight: bold;
            border-radius: 8px 8px 0 0;
        }

        tbody td {
            background-color: #f8f9fa;
            text-align: center;
            padding: 15px;
            font-size: 18px;
            font-weight: 500;
            color: #212529;
            border-bottom: 1px solid #dee2e6;
        }

        tbody tr:hover {
            background-color: #e2e6ea;
        }

        /* Melhorar visibilidade do símbolo € */
        .euro-symbol {
            font-weight: bold;
            color: #198754;
            font-size: 18px;
        }

        .navbar-brand {
            font-weight: bold;
            letter-spacing: 0.07em;
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
            <ul class="navbar-nav ms-auto"> <!-- Alinha os links à direita -->
                <li class="nav-item">
                    <a class="nav-link" href="consultar_rotas.jsp">Consultar Rotas</a>
                </li>  
                <%
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    pstmt = conn.prepareStatement("SELECT COUNT(*) as total FROM alertas");
                    rs = pstmt.executeQuery();
                    if (rs.next() && rs.getInt("total") > 0) {
                        int total = rs.getInt("total");
                %>
                        <li class="nav-item">
                            <a class="nav-link text-warning" href="alertas.jsp">Alertas <i class="bi bi-bell-fill"></i> <span class="badge bg-danger"><%=total%></span></a>
                        </li>
                <%
                    }
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                }
                %>
               

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


<!-- Conteúdo principal -->
<div class="container">
    <h1>Consultar Rotas</h1>

    <form method="post" action="filtro_r.jsp" class="d-flex flex-wrap justify-content-start">
        <input type="text" name="nome_rota" placeholder="Nome da rota">
        <input type="number" name="min_paragens" placeholder="M&iacute;nimo de paragens">
        
        <select name="ordenar_por">
            <option value="nome_rota">Nome</option>
            <option value="taxa_inicial">Taxa Inicial</option>
            <option value="num_paragens">N&ordm; Paragens</option>
        </select>

        <select name="ordem">
            <option value="ASC">Crescente</option>
            <option value="DESC">Decrescente</option>
        </select>

        <button type="submit" class="btn btn-primary">Filtrar/Ordenar</button>
    </form>

    <table class="table">
        <thead>
            <tr>
                <th>Rota</th>
                <th>Taxa Inicial</th>
                <th>Taxa por Paragem</th>
                <th>N&uacute;mero de Paragens</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <%
                PreparedStatement pstmtRotas = null;
                ResultSet rsRotas = null;
                DecimalFormat df = new DecimalFormat("#0.00");
                
                try {
                    pstmtRotas = conn.prepareStatement("SELECT * FROM rotas");
                    rsRotas = pstmtRotas.executeQuery();

                    while (rsRotas.next()) {
            %>
                        <tr>
                            <td><strong><%=rsRotas.getString("nome_rota")%></strong></td>
                            <td><%=df.format(rsRotas.getDouble("taxa_inicial"))%> <span class="euro-symbol">&euro;</span></td>
                            <td><%=df.format(rsRotas.getDouble("taxa_paragem"))%> <span class="euro-symbol">&euro;</span></td>
                            <td><strong><%=rsRotas.getInt("num_paragens")%></strong></td>
                            <td>
                                <form action="ver_paragens.jsp" method="POST">
                                    <input type="hidden" name="id_rota" value="<%=rsRotas.getInt("id_rota")%>">
                                    <button type="submit" class="btn btn-sm btn-outline-primary">Ver Paragens</button>
                                </form>
                            </td>
                        </tr>
            <%
                    }
                } finally {
                    if (rsRotas != null) rsRotas.close();
                    if (pstmtRotas != null) pstmtRotas.close();
                }
            %>
        </tbody>
    </table>
</div>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
