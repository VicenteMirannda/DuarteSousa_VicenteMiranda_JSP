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
  
  // Processar formulário se for POST
  if ("POST".equals(request.getMethod())) {
    String descricao = request.getParameter("descricao");
    String id_rota = request.getParameter("id_rota");
    String taxa_inicial = request.getParameter("taxa_inicial");
    String taxa_paragem = request.getParameter("taxa_paragem");
    
    if (descricao != null && id_rota != null && taxa_inicial != null && taxa_paragem != null) {
        try {
            // Busca os valores atuais
            String sql_select = "SELECT taxa_inicial, taxa_paragem FROM rotas WHERE id_rota = ?";
            PreparedStatement stmt_select = conn.prepareStatement(sql_select);
            stmt_select.setInt(1, Integer.parseInt(id_rota));
            ResultSet result = stmt_select.executeQuery();
            
            if (result.next()) {
                double taxa_inicial_atual = result.getDouble("taxa_inicial");
                double taxa_paragem_atual = result.getDouble("taxa_paragem");
                
                double nova_taxa_inicial = taxa_inicial_atual * Double.parseDouble(taxa_inicial);
                double nova_taxa_paragem = taxa_paragem_atual * Double.parseDouble(taxa_paragem);
                
                result.close();
                stmt_select.close();
                
                // Atualiza as taxas de desconto na rota
                String sql = "UPDATE rotas SET taxa_inicial = ?, taxa_paragem = ? WHERE id_rota = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setDouble(1, nova_taxa_inicial);
                stmt.setDouble(2, nova_taxa_paragem);
                stmt.setInt(3, Integer.parseInt(id_rota));
                
                int res = stmt.executeUpdate();
                stmt.close();
                
                // Regista o alerta de desconto aplicado
                String sql2 = "INSERT INTO alertas (id_rota, id_viagem, descricao, tipo) VALUES (?, NULL, ?, '1')";
                PreparedStatement stmt2 = conn.prepareStatement(sql2);
                stmt2.setInt(1, Integer.parseInt(id_rota));
                stmt2.setString(2, descricao);
                
                int res2 = stmt2.executeUpdate();
                stmt2.close();
                
                if (res > 0 && res2 > 0) {
                    out.println("Desconto aplicado com sucesso!");
                    response.setHeader("refresh", "2;url=voltar.jsp");
                } else {
                    out.println("Erro ao aplicar desconto!");
                    response.setHeader("refresh", "2;url=voltar.jsp");
                }
            } else {
                out.println("Rota não encontrada!");
                response.setHeader("refresh", "2;url=voltar.jsp");
            }
        } catch (SQLException e) {
            out.println("Erro ao aplicar desconto: " + e.getMessage());
            response.setHeader("refresh", "2;url=voltar.jsp");
        } catch (NumberFormatException e) {
            out.println("Valores inválidos!");
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
                    <a class="nav-link" href="adicionar_promocao.jsp">Voltar</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
               
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2>Aplicar Desconto</h2>
    <form action="aplicar_desconto.jsp" method="POST">
    <br><br>
        Taxa Inicial:

        <select name="taxa_inicial">
            <option value="1"></option>
            <option value="0.70">30%</option>
            <option value="0.50">50%</option>
            <option value="0.25">75%</option>
        </select>

        <br><br>
        Taxa por Paragem:

        <select name="taxa_paragem">
            <option value="1"></option>
            <option value="0.70">30%</option>
            <option value="0.50">50%</option>
            <option value="0.25">75%</option>
        </select>

        <br><br>


        <div class="mb-3">
            <label for="descricao" class="form-label">Descrição do Desconto</label>
            <textarea class="form-control" id="descricao" name="descricao" rows="4" required></textarea>
            <input type="hidden" name="id_rota" value="<%= request.getParameter("id_rota") != null ? request.getParameter("id_rota") : "" %>">
        </div>
        <button type="submit" class="btn btn-danger">Aplicar Desconto</button>
    </form>
</div>

<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
