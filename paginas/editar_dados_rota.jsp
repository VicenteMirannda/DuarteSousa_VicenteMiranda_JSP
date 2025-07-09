<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>
<%
  // Verificar sessão
  Integer nivel = (Integer) session.getAttribute("nivel");
  if(nivel == null || nivel != 3){
    response.sendRedirect("voltar.jsp");
    return;
  }
  
  // Processar formulário se for POST e tiver todos os campos necessários
  if("POST".equals(request.getMethod())){
    String id_rota_param = request.getParameter("id_rota");
    String rota = request.getParameter("rota");
    String taxa_inicial = request.getParameter("taxa_inicial");
    String taxa_paragem = request.getParameter("taxa_paragem");
    String num_paragens = request.getParameter("num_paragens");
    
    if (id_rota_param != null && rota != null && taxa_inicial != null && taxa_paragem != null && num_paragens != null) {
        try {
            int id_rota = Integer.parseInt(id_rota_param);
            double taxa_inicial_val = Double.parseDouble(taxa_inicial);
            double taxa_paragem_val = Double.parseDouble(taxa_paragem);
            int num_paragens_val = Integer.parseInt(num_paragens);
            
            if (taxa_inicial_val < 0 || taxa_paragem_val < 0 || num_paragens_val < 0) {
                out.println("<div class='alert alert-danger'>Erro: Os valores de Taxa Inicial, Taxa Paragem e Número de Paragens não podem ser negativos.</div>");
            } else {
                String sql = "UPDATE rotas SET nome_rota = ?, taxa_inicial = ?, taxa_paragem = ?, num_paragens = ? WHERE id_rota = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, rota);
                stmt.setDouble(2, taxa_inicial_val);
                stmt.setDouble(3, taxa_paragem_val);
                stmt.setInt(4, num_paragens_val);
                stmt.setInt(5, id_rota);
                
                int result = stmt.executeUpdate();
                stmt.close();
                
                if (result > 0) {
                    out.println("<div class='alert alert-success'>Rota atualizada com sucesso!</div>");
                    response.setHeader("refresh", "2;url=voltar.jsp");
                } else {
                    out.println("<div class='alert alert-danger'>Erro ao atualizar a rota.</div>");
                    response.setHeader("refresh", "2;url=voltar.jsp");
                }
            }
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger'>Erro: Valores numéricos inválidos.</div>");
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger'>Erro ao atualizar a rota: " + e.getMessage() + "</div>");
            response.setHeader("refresh", "2;url=voltar.jsp");
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
                    <a class="nav-link" href="editar_rotas.jsp">Voltar</a>
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
    <h1>Editar Rota</h1>

    <%
            String id_rota_display = request.getParameter("id_rota");
            if (id_rota_display != null) {
                try {
                    String sql = "SELECT * FROM rotas WHERE id_rota = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, Integer.parseInt(id_rota_display));
                    ResultSet result = stmt.executeQuery();
                    
                    if (result.next()) {
    %>
            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
            
            <form action = "editar_dados_rota.jsp" method = "POST">
            <div class="mb-3">
                <label for="id_rota" class="form-label">ID_Rota</label>
                <input type="text" class="form-control" id="id_rota" name="id_rota" value="<%= id_rota_display %>" readonly>
              </div>
              <div class="mb-3">
                <label for="rota" class="form-label">Nome Rota</label>
                <input type="text" class="form-control" id="rota" name="rota" value="<%= result.getString("nome_rota") != null ? result.getString("nome_rota") : "" %>" required>
              </div>
              
              <div class="mb-3">
                <label for="taxa_inicial" class="form-label">Taxa Inicial</label>
                <input type="number" class="form-control" id="taxa_inicial" name="taxa_inicial" value="<%= result.getString("taxa_inicial") != null ? result.getString("taxa_inicial") : "" %>" required>
              </div>
             
            <div class="mb-3">
                <label for="taxa_paragem" class="form-label">Taxa Paragem</label>
                <input type="number" class="form-control" id="taxa_paragem" name="taxa_paragem" value="<%= result.getString("taxa_paragem") != null ? result.getString("taxa_paragem") : "" %>" required>
              </div>
            <div class="mb-3">
                <label for="num_paragens" class="form-label">Número de Paragens</label>
                <input type="number" class="form-control" id="num_paragens" name="num_paragens" value="<%= result.getString("num_paragens") != null ? result.getString("num_paragens") : "" %>" required>
              </div>
              
              <button type="submit" class="btn btn-primary">Editar</button>
            </form>
          </div>
    <%
                    }
                    result.close();
                    stmt.close();
                } catch (SQLException e) {
                    out.println("Erro ao carregar dados da rota: " + e.getMessage());
                } catch (NumberFormatException e) {
                    out.println("ID da rota inválido.");
                }
            }
    %>

</div>

<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
