<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Localização - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
   <style>
    body {
        background-color: #f1f3f5;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .container {
        margin-top: 60px;
        margin-bottom: 60px;
    }

    .localizacao-box {
        background: #ffffff;
        border-radius: 16px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
        padding: 30px;
    }

    h2 {
        color: #343a40;
        font-weight: bold;
        margin-bottom: 20px;
    }

   .map-container {
    width: 100%;
    height: 500px;
    border-radius: 10px;
    overflow: hidden;
}


    .map-container iframe {
        width: 100%;
        height: 100%;
        border: none;
        border-radius: 10px;
    }

    p {
        font-size: 16px;
        margin: 5px 0;
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
                    <a class="nav-link active" href="localizacao.jsp">Localização</a>
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

<!-- Conteúdo -->
<div class="container">
    <div class="localizacao-box row align-items-center justify-content-center">
        <!-- Esquerda: Morada -->
        <div class="col-md-5 text-center mb-4 mb-md-0">
            <h2>Onde Estamos</h2>
            <p><strong>FelixBus - Terminal Rodoviário</strong></p>
            <p>📍 Rua das Viagens, 123</p>
            <p>🏙️ Castelo Branco, Portugal</p>
            <p>☎️ +351 123 456 789</p>
        </div>

        <!-- Direita: Mapa -->
        <!-- Lado Direito - Mapa -->
<div class="col-md-7">
  <div class="map-container">
    <iframe 
      src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3064.478826363975!2d-7.492034023601263!3d39.818680891821!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0xd3d5fbcd356ebc7%3A0x2e675e2db613e3af!2sTerminal%20Rodovi%C3%A1rio%20de%20Castelo%20Branco!5e0!3m2!1spt-PT!2spt!4v1743292708075!5m2!1spt-PT!2spt" 
      style="width: 100%; height: 100%; border: none; border-radius: 10px;"
      allowfullscreen=""
      loading="lazy"
      referrerpolicy="no-referrer-when-downgrade">
    </iframe>
  </div>
</div>

    </div>
</div>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
