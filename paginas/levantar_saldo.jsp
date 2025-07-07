<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ include file="../basedados/basedados.h" %>
<%
// Verificar se o utilizador está logado
if(session.getAttribute("nivel") == null){
    response.sendRedirect("voltar.jsp");
    return;
}

if ("POST".equals(request.getMethod())) {
    // Recebe os dados do formulário de confirmação de identidade
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String valorParam = request.getParameter("valor");

    if (username == null) username = "";
    if (password == null) password = "";

    double valor = 0;
    if (valorParam != null && !valorParam.trim().isEmpty()) {
        try {
            valor = Double.parseDouble(valorParam);
        } catch (NumberFormatException e) {
            valor = 0;
        }
    }

    if (valor > 0 && !username.trim().isEmpty() && !password.trim().isEmpty()) {
        // Verifica se o utilizador existe e a password está correta
        PreparedStatement stmt = conn.prepareStatement("SELECT id_utilizador, password FROM utilizadores WHERE nome_utilizador = ?");
        stmt.setString(1, username);
        ResultSet result = stmt.executeQuery();

        if (result.next()) {
            int idUtilizador = result.getInt("id_utilizador");
            String hashedPassword = result.getString("password");

            if (BCrypt.checkpw(password, hashedPassword)) {
                // Verifica saldo atual
                PreparedStatement stmtSaldo = conn.prepareStatement("SELECT saldo FROM carteiras WHERE id_utilizador = ?");
                stmtSaldo.setInt(1, idUtilizador);
                ResultSet resSaldo = stmtSaldo.executeQuery();

                if (resSaldo.next()) {
                    double saldoAtual = resSaldo.getDouble("saldo");

                    if (saldoAtual >= valor) {
                        // Atualizar saldo
                        PreparedStatement stmtUpdate = conn.prepareStatement("UPDATE carteiras SET saldo = saldo - ? WHERE id_utilizador = ?");
                        stmtUpdate.setDouble(1, valor);
                        stmtUpdate.setInt(2, idUtilizador);
                        boolean updateSuccess = stmtUpdate.executeUpdate() > 0;
                        stmtUpdate.close();

                        if (updateSuccess) {
                            out.println("<div style='padding:20px;'><h3>Levantamento efetuado com sucesso!</h3></div>");

                            // Obter ID da carteira
                            PreparedStatement stmtCarteira = conn.prepareStatement("SELECT id_carteira FROM carteiras WHERE id_utilizador = ?");
                            stmtCarteira.setInt(1, idUtilizador);
                            ResultSet carteiraResult = stmtCarteira.executeQuery();

                            if (carteiraResult.next()) {
                                int idCarteira = carteiraResult.getInt("id_carteira");
                                Integer idUtilizadorSessao = (Integer) session.getAttribute("id_utilizador");

                                // Inserir no extrato bancário
                                PreparedStatement stmtEstrato = conn.prepareStatement("INSERT INTO estratos_bancarios (id_carteira, id_utilizador, data_transacao, valor, tipo_transacao) VALUES (?, ?, NOW(), ?, 0)");
                                stmtEstrato.setInt(1, idCarteira);
                                stmtEstrato.setInt(2, idUtilizadorSessao);
                                stmtEstrato.setDouble(3, valor);
                                stmtEstrato.executeUpdate();
                                stmtEstrato.close();
                            }
                            carteiraResult.close();
                            stmtCarteira.close();

                            response.setHeader("refresh", "2; url=voltar.jsp");
                        } else {
                            out.println("<p>Erro ao levantar saldo!</p>");
                        }
                    } else {
                        out.println("<p>Saldo insuficiente para levantar esse valor.</p>");
                    }
                } else {
                    out.println("<p>Erro ao obter saldo.</p>");
                }
                resSaldo.close();
                stmtSaldo.close();
            } else {
                out.println("<p>Nome de utilizador ou password incorretos.</p>");
            }
        } else {
            out.println("<p>Nome de utilizador ou password incorretos.</p>");
        }
        result.close();
        stmt.close();
    } else {
        out.println("<p>Preencha todos os campos e insira um valor positivo.</p>");
    }
}
%>

<!DOCTYPE html>
<html lang="pt">
<head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Levantar Saldo - FelixBus</title>
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
                                        <a class="nav-link" href="voltar.jsp">Voltar</a>
                                </li>

                                <li class="nav-item">
                                        <a class="nav-link" href="logout.jsp">Logout</a>
                                </li>
                             
                        </ul>
                </div>
        </div>
</nav>

<div class="container">
        <h1>Levantar Saldo</h1>

                        <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
                        
                        <form action = "levantar_saldo.jsp" method = "POST">
                            <div class="mb-3">
                                <label for="valor" class="form-label">Valor</label>
                                <input type="number" class="form-control" id="valor" name="valor" min="0.01" step="0.01" required>
                            </div>
                            <hr>
                            <p class="text-center fw-bold">Confirmação de identidade</p>
                            <div class="mb-3">
                                <label for="username" class="form-label">Nome de Utilizador</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Levantar</button>
                        </form>
                    </div>

        </div>