<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FelixBus</title>
    <!-- Bootstrap CSS -->
    <link href="bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">



    <style>
        /* Estilos para imagem de fundo */
        body {
            position: relative;
            margin: 0;
            padding: 0;
            height: 100vh;
            background: url('bus.jpg') no-repeat center center;
            background-size: cover;
        }

        /* Camada de desfoque */
        body::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: inherit;
            filter: blur(5px); /* Ajuste o valor conforme necessário */
            z-index: -1;
        }

        /* Centralizar o conteúdo principal */
        .conteudo {
            position: relative;
            z-index: 1;
            text-align: center;
            color: white;
            background: rgba(0, 0, 0, 0.5); /* Fundo semi-transparente */
            padding: 30px;
            border-radius: 10px;
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

<!-- Conteúdo Principal -->
<div class="d-flex align-items-center justify-content-center vh-100">
    <div class="conteudo">
        <h1>Bem-vindo à FelixBus</h1>
        <p>Gerencie suas viagens de forma rápida e fácil.</p>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
