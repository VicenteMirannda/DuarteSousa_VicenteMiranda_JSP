<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de administrador (3)
  if(session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(3)){
    response.sendRedirect("voltar.jsp");
    return;
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
                    <a class="nav-link" href="associar_cidades.jsp">Voltar</a>
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
    <h1>Cidades</h1>
    <br>

    <table class="table">
      <thead>
          <tr>
              <th>Id</th>
              <th>Nome Cidade</th>
              
              
          </tr>
      </thead>
      <tbody>
          <%

          String idRotaParam = request.getParameter("id_rota");
          int idRota = 0;
          if (idRotaParam != null) {
              try {
                  idRota = Integer.parseInt(idRotaParam);
              } catch (NumberFormatException e) {
                  idRota = 0;
              }
          }

          PreparedStatement stmt = conn.prepareStatement("SELECT * FROM cidades c WHERE c.id_cidade NOT IN (SELECT rc.id_cidade FROM rotas_cidade rc WHERE rc.id_rota = ?) ORDER BY c.id_cidade ASC");
          stmt.setInt(1, idRota);
          ResultSet result = stmt.executeQuery();

          while (result.next()) {
            int idCidade = result.getInt("id_cidade");
            String nomeCidade = result.getString("nome_cidade");

            // Escapar HTML para segurança
            if (nomeCidade != null) nomeCidade = nomeCidade.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

            out.print("<tr>");
            out.print("<td>" + idCidade + "</td>");
            out.print("<td>" + (nomeCidade != null ? nomeCidade : "") + "</td>");
            out.print("<td>");
            out.print("<form action='associar.jsp' method='POST'>");
            out.print("<input type='hidden' name='id_cidade' value='" + idCidade + "'>");
            out.print("<input type='hidden' name='rota' value='" + idRota + "'>");
            out.print("<button type='submit' class='btn btn-primary'>Associar</button>");
            out.print("</form>");
            out.print("</tr>");
          }

          result.close();
          stmt.close();
          %>
      </tbody>
  </table>



  <br>
  </div>

  <%
// Verifica se o formulário foi enviado
if ("POST".equals(request.getMethod()) &&
    request.getParameter("id_cidade") != null &&
    request.getParameter("rota") != null) {

    try {
        int idCidade = Integer.parseInt(request.getParameter("id_cidade"));
        int rota = Integer.parseInt(request.getParameter("rota"));

        // Busca o número atual de paragens da rota
        PreparedStatement stmt2 = conn.prepareStatement("SELECT num_paragens FROM rotas WHERE id_rota = ?");
        stmt2.setInt(1, rota);
        ResultSet result2 = stmt2.executeQuery();

        int numParagem = 1;
        if (result2.next()) {
            numParagem = result2.getInt("num_paragens") + 1;
        }
        result2.close();
        stmt2.close();

        // Insere a associação entre a cidade e a rota
        PreparedStatement stmtInsert = conn.prepareStatement("INSERT INTO rotas_cidade (id_rota, id_cidade, num_paragem) VALUES (?, ?, ?)");
        stmtInsert.setInt(1, rota);
        stmtInsert.setInt(2, idCidade);
        stmtInsert.setInt(3, numParagem);
        boolean insertSuccess = stmtInsert.executeUpdate() > 0;
        stmtInsert.close();

        // Atualiza o número de paragens da rota
        PreparedStatement stmtUpdate = conn.prepareStatement("UPDATE rotas SET num_paragens = num_paragens + 1 WHERE id_rota = ?");
        stmtUpdate.setInt(1, rota);
        stmtUpdate.executeUpdate();
        stmtUpdate.close();

        if (insertSuccess) {
            out.println("<div class='alert alert-success'>Cidade associada com sucesso!</div>");

            // Redireciona para a página de gestão de cidades
            response.sendRedirect("gestao_cidades.jsp");
            return;
        } else {
            out.println("<div class='alert alert-danger'>Erro ao associar cidade!</div>");
        }
    } catch (NumberFormatException e) {
        out.println("<div class='alert alert-danger'>Erro: Parâmetros inválidos!</div>");
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Erro ao associar cidade: " + e.getMessage() + "</div>");
    }
}
%>