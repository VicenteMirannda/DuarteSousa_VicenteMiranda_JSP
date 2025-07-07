<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de administrador (3) ou funcionário (2)
  Integer nivel = (Integer) session.getAttribute("nivel");
  if(nivel == null || (nivel != 3 && nivel != 2)){
    response.sendRedirect("voltar.jsp");
    return;
  }
%>


<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FelixBus</title>
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
  <br>
    <h1>Transações</h1>
    <br>

    <table class="table">
      <thead>
          <tr>
              <th>Transação</th>
              <th>Carteira</th>
              <th>Nome</th>
              <th>Data Transação</th>
              <th>Valor</th>
              
              
          </tr>
      </thead>
      <tbody>
          <%

          PreparedStatement stmt = conn.prepareStatement("SELECT * FROM estratos_bancarios ORDER BY id_transacao ASC");
          ResultSet result = stmt.executeQuery();

          while (result.next()) {
            int idTransacao = result.getInt("id_transacao");
            int idCarteira = result.getInt("id_carteira");
            int idUtilizador = result.getInt("id_utilizador");
            String dataTransacao = result.getString("data_transacao");
            double valor = result.getDouble("valor");
            int tipoTransacao = result.getInt("tipo_transacao");

            // Buscar nome do utilizador
            PreparedStatement userStmt = conn.prepareStatement("SELECT nome_utilizador FROM utilizadores WHERE id_utilizador = ?");
            userStmt.setInt(1, idUtilizador);
            ResultSet userResult = userStmt.executeQuery();

            String nomeUtilizador = "";
            if (userResult.next()) {
                nomeUtilizador = userResult.getString("nome_utilizador");
            }
            userResult.close();
            userStmt.close();

            // Escapar HTML para segurança
            if (nomeUtilizador != null) nomeUtilizador = nomeUtilizador.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
            if (dataTransacao != null) dataTransacao = dataTransacao.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

            // Determinar cor baseada no tipo de transação
            String cor = (tipoTransacao == 1) ? "green" : "red";

            out.print("<tr>");
            out.print("<td>" + idTransacao + "</td>");
            out.print("<td>" + idCarteira + "</td>");
            out.print("<td>" + (nomeUtilizador != null ? nomeUtilizador : "") + "</td>");
            out.print("<td>" + (dataTransacao != null ? dataTransacao : "") + "</td>");
            out.print("<td style='color: " + cor + ";'>" + valor + "</td>");
            out.print("</tr>");
          }

          result.close();
          stmt.close();
          %>
      </tbody>
  </table>



  <br>
  </div>