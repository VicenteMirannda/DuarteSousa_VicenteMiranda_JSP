<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ include file="../basedados/basedados.h" %>
<%
    // Bloco de Lógica Principal (Tudo no topo)

    // 1. VERIFICAR SESSÃO E NÍVEL DE ACESSO
    Integer nivel = (Integer) session.getAttribute("nivel");
    if (nivel == null || (nivel != 1 && nivel != 2)) {
        response.sendRedirect("voltar.jsp");
        return;
    }
    Integer id = (Integer) session.getAttribute("id_utilizador");
    String mensagem = ""; // Para feedback ao utilizador

    // 2. PROCESSAR O FORMULÁRIO (SE FOR UM POST)
    if ("POST".equals(request.getMethod())) {
        String novoNome = request.getParameter("utilizador");
        String email = request.getParameter("email");
        String dataNasc = request.getParameter("data_nasc");
        String password = request.getParameter("password");

        // Atualizar dados básicos
        PreparedStatement stmtUpdate = conn.prepareStatement("UPDATE utilizadores SET nome_utilizador=?, email=?, data_nasc=? WHERE id_utilizador=?");
        stmtUpdate.setString(1, novoNome);
        stmtUpdate.setString(2, email);
        stmtUpdate.setString(3, dataNasc);
        stmtUpdate.setInt(4, id);
        int res = stmtUpdate.executeUpdate();
        stmtUpdate.close();

        // Atualizar password se fornecida
        if (password != null && !password.trim().isEmpty()) {
            String novaPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            PreparedStatement stmtPass = conn.prepareStatement("UPDATE utilizadores SET password=? WHERE id_utilizador=?");
            stmtPass.setString(1, novaPassword);
            stmtPass.setInt(2, id);
            stmtPass.executeUpdate();
            stmtPass.close();
        }

        if (res > 0) {
            mensagem = "Dados editados com sucesso!";
        } else {
            mensagem = "Erro ao editar dados!";
        }
    }

    // 3. BUSCAR OS DADOS ATUAIS PARA EXIBIR NO FORMULÁRIO
    String nomeUtilizador = "";
    String emailUtilizador = "";
    String dataNascUtilizador = "";

    PreparedStatement stmtSelect = conn.prepareStatement("SELECT * FROM utilizadores WHERE id_utilizador = ?");
    stmtSelect.setInt(1, id);
    ResultSet result = stmtSelect.executeQuery();

    if (result.next()) {
        nomeUtilizador = result.getString("nome_utilizador");
        emailUtilizador = result.getString("email");
        dataNascUtilizador = result.getString("data_nasc");
    }
    result.close();
    stmtSelect.close();
%>
<!DOCTYPE html>
<html lang="pt" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dados Pessoais - FelixBus</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <style>
        /* O body ocupa 100% da altura para permitir a centralização vertical */
        body {
            display: flex;
            flex-direction: column;
            background-color: #f8f9fa;
        }
        /* O main vai ocupar todo o espaço disponível, empurrando o footer para baixo */
        .main-content {
            flex: 1;
        }
    </style>
</head>
<body class="h-100">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="voltar.jsp">FelixBus</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="voltar.jsp">❮ Voltar</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<main class="main-content d-flex align-items-center py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6 col-xl-5">
                <div class="card border-0 shadow-sm rounded-3">
                    <div class="card-body p-4 p-sm-5">
                        <h1 class="card-title text-center h3 fw-bold mb-4">Os Seus Dados</h1>
                        
                        <% if (!mensagem.isEmpty()) { %>
                            <div class="alert alert-info" role="alert">
                                <%= mensagem %>
                            </div>
                        <% } %>

                        <form action="dados_cli_func.jsp" method="POST">
                            <div class="mb-3">
                                <label for="utilizador" class="form-label">Nome de Utilizador</label>
                                <input type="text" class="form-control" id="utilizador" name="utilizador" value="<%= nomeUtilizador != null ? nomeUtilizador : "" %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="<%= emailUtilizador != null ? emailUtilizador : "" %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="data_nasc" class="form-label">Data de Nascimento</label>
                                <input type="date" class="form-control" id="data_nasc" name="data_nasc" value="<%= dataNascUtilizador != null ? dataNascUtilizador : "" %>" required>
                            </div>
                            <hr class="my-4">
                            <div class="mb-3">
                                <label for="password" class="form-label">Nova Password</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Deixe em branco para não alterar">
                                <div class="form-text">Por segurança, a sua password atual não é exibida.</div>
                            </div>
                            <div class="d-grid pt-2">
                                <button type="submit" class="btn btn-primary btn-lg fw-bold">Guardar Alterações</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>