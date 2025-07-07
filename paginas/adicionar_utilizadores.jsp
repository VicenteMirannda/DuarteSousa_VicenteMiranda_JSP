<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de administrador (3)
  if(session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(3)){
    response.sendRedirect("voltar.jsp");
    return;
  }

  if("POST".equals(request.getMethod())){

    String utilizador = request.getParameter("utilizador");
    String pass = request.getParameter("pass");
    String email = request.getParameter("email");
    String dataNasc = request.getParameter("data_nasc");
    String nivel = request.getParameter("nivel");

    // Hash da password usando BCrypt
    String hashedPassword = BCrypt.hashpw(pass, BCrypt.gensalt());

    PreparedStatement stmt = conn.prepareStatement("INSERT INTO utilizadores (nome_utilizador, password, email, data_nasc, nivel_acesso) VALUES (?, ?, ?, ?, ?)");
    stmt.setString(1, utilizador);
    stmt.setString(2, hashedPassword);
    stmt.setString(3, email);
    stmt.setString(4, dataNasc);
    stmt.setInt(5, Integer.parseInt(nivel));

    boolean res = stmt.executeUpdate() > 0;

    // Obter o ID do utilizador recém-criado
    int idUtilizador = 0;
    if (res) {
        PreparedStatement stmtId = conn.prepareStatement("SELECT id_utilizador FROM utilizadores WHERE nome_utilizador = ?");
        stmtId.setString(1, utilizador);
        ResultSet rsId = stmtId.executeQuery();
        if (rsId.next()) {
            idUtilizador = rsId.getInt("id_utilizador");
        }
        rsId.close();
        stmtId.close();
    }

    stmt.close();

    if(res && idUtilizador > 0){
        // Criar carteira para o novo utilizador com saldo inicial 0
        PreparedStatement stmtCarteira = conn.prepareStatement("INSERT INTO carteiras (id_utilizador, saldo) VALUES (?, 0)");
        stmtCarteira.setInt(1, idUtilizador);
        boolean carteiraRes = stmtCarteira.executeUpdate() > 0;
        stmtCarteira.close();

        if (carteiraRes) {
            out.println("Utilizador e carteira adicionados com sucesso!");
        } else {
            out.println("Utilizador adicionado, mas erro ao criar carteira!");
        }
        response.setHeader("refresh", "2; url=voltar.jsp");
    }else{
        out.println("Erro ao adicionar utilizador!");
        response.setHeader("refresh", "2; url=voltar.jsp");
    }
  }
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
    <h1>Adicionar Utilizador</h1>

            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
            
            <form action = "adicionar_utilizadores.jsp" method = "POST">
              <div class="mb-3">
                <label for="utilizador" class="form-label">Nome de Utilizador</label>
                <input type="text" class="form-control" id="utilizador" name="utilizador"  required>
              </div>
              <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="text" class="form-control" id="pass" name="pass"  required>
              </div>
              <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="text" class="form-control" id="email" name="email" required>
              </div>
              <div class="mb-3">
                <label for="data_nasc" class="form-label">Data Nascimento</label>
                <input type="date" class="form-control" id="data_nasc" name="data_nasc" required>
              </div>
            <div class="mb-3">
                <label for="nivel" class="form-label">Nível de Acesso</label>
                <select class="form-select" id="nivel" name="nivel" required>
                    <option value="1">Cliente</option>
                    <option value="2">Funcionario</option>
                    <option value="3">Admin</option>
                </select>
            </div>
            
              
              <button type="submit" class="btn btn-primary">Adicionar</button>
            </form>
          </div>
              
              
              
          
     


    </div>