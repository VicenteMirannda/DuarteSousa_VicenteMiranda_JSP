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
  
  // Processar formulário se for POST e tiver os campos necessários
  if ("POST".equals(request.getMethod())) {
    String id_alerta_param = request.getParameter("id_alerta");
    String descricao = request.getParameter("descricao");
    
    if (id_alerta_param != null && descricao != null) {
        try {
            int id_alerta = Integer.parseInt(id_alerta_param);
            descricao = descricao.trim();
            
            if (descricao.isEmpty()) {
                out.println("<div class='alert alert-danger'>Erro: A descrição não pode estar vazia.</div>");
            } else {
                String sql = "UPDATE alertas SET descricao = ? WHERE id_alerta = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, descricao);
                stmt.setInt(2, id_alerta);
                
                int result = stmt.executeUpdate();
                stmt.close();
                
                if (result > 0) {
                    out.println("<div class='alert alert-success'>Descrição do alerta atualizada com sucesso!</div>");
                    response.setHeader("refresh", "2;url=voltar.jsp");
                } else {
                    out.println("<div class='alert alert-danger'>Erro ao atualizar a descrição.</div>");
                    response.setHeader("refresh", "2;url=voltar.jsp");
                }
            }
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger'>ID do alerta inválido.</div>");
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger'>Erro ao atualizar a descrição: " + e.getMessage() + "</div>");
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
                    <a class="nav-link" href="editar_alerta.jsp">Voltar</a>
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
    <h1>Editar Alerta</h1>

    <%
            String id_alerta_display = request.getParameter("id_alerta");
            if (id_alerta_display != null) {
                try {
                    String sql = "SELECT * FROM alertas WHERE id_alerta = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, Integer.parseInt(id_alerta_display));
                    ResultSet result = stmt.executeQuery();
                    
                    if (result.next()) {
                        // Buscar descrição do tipo de alerta
                        String descricao_tipo = "";
                        String tipo = result.getString("tipo");
                        if (tipo != null && !tipo.isEmpty()) {
                            try {
                                String sql_tipo = "SELECT descricao FROM tipo_alerta WHERE id_tipo = ?";
                                PreparedStatement stmt_tipo = conn.prepareStatement(sql_tipo);
                                stmt_tipo.setInt(1, Integer.parseInt(tipo));
                                ResultSet result_tipo = stmt_tipo.executeQuery();
                                if (result_tipo.next()) {
                                    descricao_tipo = result_tipo.getString("descricao") != null ? result_tipo.getString("descricao") : "";
                                }
                                result_tipo.close();
                                stmt_tipo.close();
                            } catch (NumberFormatException e) {
                                // Tipo inválido, manter descrição vazia
                            }
                        }
                        
                        String id_rota = result.getString("id_rota");
                        String id_viagem = result.getString("id_viagem");
                        
                        // Buscar nome da rota
                        String nome_rota = "";
                        if (id_rota != null && !id_rota.isEmpty()) {
                            try {
                                String sql_rota = "SELECT nome_rota FROM rotas WHERE id_rota = ?";
                                PreparedStatement stmt_rota = conn.prepareStatement(sql_rota);
                                stmt_rota.setInt(1, Integer.parseInt(id_rota));
                                ResultSet result_rota = stmt_rota.executeQuery();
                                if (result_rota.next()) {
                                    nome_rota = result_rota.getString("nome_rota") != null ? result_rota.getString("nome_rota") : "";
                                }
                                result_rota.close();
                                stmt_rota.close();
                            } catch (NumberFormatException e) {
                                // ID da rota inválido, manter nome vazio
                            }
                        }
    %>
            <div class="col-md-4 offset-md-4 align-items-center justify-content-center container"  style="margin-top: 5%;">
            
            <form action = "update_alertas.jsp" method = "POST">
            <div class="mb-3">
                <label for="id_alerta" class="form-label">ID_Alerta</label>
                <input type="text" class="form-control" id="id_alerta" name="id_alerta" value="<%= id_alerta_display %>" readonly>
              </div>
              <div class="mb-3">
                <label for="rota" class="form-label">Nome Rota</label>
                <input type="text" class="form-control" id="rota" name="rota" value="<%= nome_rota %>" readonly>
              </div>

              <div class="mb-3">
                <label for="id_viagem" class="form-label">ID Viagem</label>
                <input type="text" class="form-control" id="id_viagem" name="id_viagem" value="<%= id_viagem != null ? id_viagem : "" %>" readonly>
              </div>

              <div class="mb-3">
                <label for="descricao" class="form-label">Descrição</label>
                <input type="text" class="form-control" id="descricao" name="descricao" value="<%= result.getString("descricao") != null ? result.getString("descricao") : "" %>" required>
              </div>

              <div class="mb-3">
                <label for="tipo" class="form-label">Tipo</label>
                <input type="text" class="form-control" id="tipo" name="tipo" value="<%= descricao_tipo %>" readonly>
              </div>
              
              <button type="submit" class="btn btn-primary">Editar</button>
            </form>
          </div>
              
              
              
    <%
                    }
                    result.close();
                    stmt.close();
                } catch (SQLException e) {
                    out.println("Erro ao carregar dados do alerta: " + e.getMessage());
                } catch (NumberFormatException e) {
                    out.println("ID do alerta inválido.");
                }
            }
    %>

</div>

<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
