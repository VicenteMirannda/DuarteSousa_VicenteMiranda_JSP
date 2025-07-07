<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar se o utilizador tem nível de acesso de administrador (3)
  if(session.getAttribute("nivel") == null || !session.getAttribute("nivel").equals(3)){
    response.sendRedirect("voltar.jsp");
    return;
  }

  // Processar formulário de edição
  if("POST".equals(request.getMethod()) &&
     request.getParameter("utilizador") != null &&
     request.getParameter("data_nasc") != null &&
     request.getParameter("nivel") != null) {

    String idUtilizadorParam = request.getParameter("id_utilizador");
    Integer idUtilizadorSessao = (Integer) session.getAttribute("id_utilizador");

    if (idUtilizadorParam != null && idUtilizadorSessao != null) {
        int idUtilizador = Integer.parseInt(idUtilizadorParam);

        

        String utilizador = request.getParameter("utilizador");
        String dataNasc = request.getParameter("data_nasc");
        String nivel = request.getParameter("nivel");

        // Verificar se o nível de acesso existe
        PreparedStatement nivelCheckStmt = conn.prepareStatement("SELECT COUNT(*) as count FROM nivel_acesso WHERE nivel_acesso = ?");
        nivelCheckStmt.setInt(1, Integer.parseInt(nivel));
        ResultSet nivelCheckResult = nivelCheckStmt.executeQuery();

        boolean nivelExiste = false;
        if (nivelCheckResult.next()) {
            nivelExiste = nivelCheckResult.getInt("count") > 0;
        }
        nivelCheckResult.close();
        nivelCheckStmt.close();

        if (nivelExiste) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE utilizadores SET nome_utilizador=?, data_nasc=?, nivel_acesso=? WHERE id_utilizador=?");
            stmt.setString(1, utilizador);
            stmt.setString(2, dataNasc);
            stmt.setInt(3, Integer.parseInt(nivel));
            stmt.setInt(4, idUtilizador);

            boolean res = stmt.executeUpdate() > 0;
            stmt.close();

            if(res){
                out.println("Utilizador editado com sucesso!");
                response.setHeader("refresh", "2; url=voltar.jsp");
            }else{
                out.println("Erro ao editar utilizador!");
                response.setHeader("refresh", "2; url=voltar.jsp");
            }
        } else {
            out.println("Erro: O nível de acesso especificado não existe.");
            response.setHeader("refresh", "2; url=editar_utilizadores.jsp");
        }
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
                    <a class="nav-link" href="editar_utilizadores.jsp">Voltar</a>
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
    <h1>Editar Dados Utilizador</h1>
    

    
       
            <%
            String idUtilizadorParam = request.getParameter("id_utilizador");
            if (idUtilizadorParam != null) {

                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM utilizadores WHERE id_utilizador = ?");
                stmt.setInt(1, Integer.parseInt(idUtilizadorParam));
                ResultSet result = stmt.executeQuery();

                if (result.next()) {
                    String nomeUtilizador = result.getString("nome_utilizador");
                    String dataNasc = result.getString("data_nasc");
                    int nivelAcesso = result.getInt("nivel_acesso");
            %>
            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">

            <form action = "editar_dados.jsp" method = "POST">
            <div class="mb-3">
                <label for="id_utilizador" class="form-label">ID_Utilizador</label>
                <input type="text" class="form-control" id="id_utilizador" name="id_utilizador" value="<%= idUtilizadorParam %>" readonly>
              </div>
              <div class="mb-3">
                <label for="utilizador" class="form-label">Utilizador</label>
                <input type="text" class="form-control" id="utilizador" name="utilizador" value="<%= nomeUtilizador != null ? nomeUtilizador : "" %>" required>
              </div>

              <div class="mb-3">
                <label for="data_nasc" class="form-label">Data Nascimento</label>
                <input type="date" class="form-control" id="data_nasc" name="data_nasc" value="<%= dataNasc != null ? dataNasc : "" %>" required>
              </div>
              <div class="mb-3">
                <label for="nivel" class="form-label">Nível de Acesso</label>
                <select class="form-select" id="nivel" name="nivel" required>
                  <option value="">---</option>
                  <option value="1" <%= nivelAcesso == 1 ? "selected" : "" %>>Cliente</option>
                  <option value="2" <%= nivelAcesso == 2 ? "selected" : "" %>>Funcionário</option>
                  <option value="3" <%= nivelAcesso == 3 ? "selected" : "" %>>Admin</option>
                </select>
            </div>


              <button type="submit" class="btn btn-primary">Editar</button>
            </form>
          </div>

            <%
                }
                result.close();
                stmt.close();
            }
            %>
