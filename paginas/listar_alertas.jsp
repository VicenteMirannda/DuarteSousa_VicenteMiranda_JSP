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
%>

<%
// Obter parâmetros de filtro
String tipo_alerta = request.getParameter("tipo_alerta");
String ordenar_por = request.getParameter("ordenar_por");

if (tipo_alerta == null) tipo_alerta = "";
if (ordenar_por == null) ordenar_por = "";

// Construir query com filtros
String sql = "SELECT * FROM alertas";
String whereClause = "";
String orderClause = "";

// Aplicar filtro por tipo de alerta
if (!tipo_alerta.isEmpty()) {
    whereClause = " WHERE tipo = ?";
}

// Aplicar ordenação
if (!ordenar_por.isEmpty()) {
    switch (ordenar_por) {
        case "promocoes":
            orderClause = " ORDER BY tipo = '1' DESC, id_alerta DESC";
            break;
        case "cancelamento":
            orderClause = " ORDER BY tipo = '2' DESC, id_alerta DESC";
            break;
        case "altera_horario":
            orderClause = " ORDER BY tipo = '3' DESC, id_alerta DESC";
            break;
        default:
            orderClause = " ORDER BY id_alerta DESC";
            break;
    }
} else {
    orderClause = " ORDER BY id_alerta DESC";
}

sql += whereClause + orderClause;
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Filtrar Alertas - FelixBus</title>
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
                    <a class="nav-link" href="listar_alertas.jsp">Voltar</a>
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
    <h1>Alertas Filtrados</h1>
    <br>

    <form method="post" action="filtro_alertas.jsp">
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <label for="tipo_alerta" class="form-label">Tipo de Alerta</label>
                <select name="tipo_alerta" id="tipo_alerta" class="form-select">
                    <option value="">Todos os tipos</option>
                    <option value="1" <%= "1".equals(tipo_alerta) ? "selected" : "" %>>Promoções</option>
                    <option value="2" <%= "2".equals(tipo_alerta) ? "selected" : "" %>>Cancelamento</option>
                    <option value="3" <%= "3".equals(tipo_alerta) ? "selected" : "" %>>Alteração de Horários</option>
                </select>
            </div>
            
            <div class="col-md-4">
                <label for="ordenar_por" class="form-label">Ordenar por</label>
                <select name="ordenar_por" id="ordenar_por" class="form-select">
                    <option value="">Padrão</option>
                    <option value="promocoes" <%= "promocoes".equals(ordenar_por) ? "selected" : "" %>>Promoções</option>
                    <option value="altera_horario" <%= "altera_horario".equals(ordenar_por) ? "selected" : "" %>>Alteração de Horários</option>
                    <option value="cancelamento" <%= "cancelamento".equals(ordenar_por) ? "selected" : "" %>>Cancelamento</option>
                </select>
            </div>
            
            <div class="col-md-4 d-flex align-items-end">
                <button type="submit" class="btn btn-primary me-2">Filtrar/Ordenar</button>
                <a href="filtro_alertas.jsp" class="btn btn-secondary">Limpar</a>
            </div>
        </div>
    </form>

    <table class="table">
      <thead>
          <tr>
              <th>Alerta</th>
              <th>Rota</th>
              <th>Id_Viagem</th>
              <th>Tipo</th>
              <th>Ações</th>
          </tr>
      </thead>
      <tbody>
          <%
          try {
              PreparedStatement stmt = conn.prepareStatement(sql);
              
              // Definir parâmetros se houver filtro
              if (!tipo_alerta.isEmpty()) {
                  stmt.setString(1, tipo_alerta);
              }
              
              ResultSet result = stmt.executeQuery();
              boolean hasResults = false;
              
              while (result.next()) {
                  hasResults = true;
                  
                  // Obter descrição do tipo de alerta
                  String descricao = "";
                  String tipo = result.getString("tipo");
                  if (tipo != null && !tipo.isEmpty()) {
                      try {
                          String sql2 = "SELECT descricao FROM tipo_alerta WHERE id_tipo = ?";
                          PreparedStatement stmt2 = conn.prepareStatement(sql2);
                          stmt2.setInt(1, Integer.parseInt(tipo));
                          ResultSet result2 = stmt2.executeQuery();
                          if (result2.next()) {
                              descricao = result2.getString("descricao") != null ? result2.getString("descricao") : "";
                          }
                          result2.close();
                          stmt2.close();
                      } catch (NumberFormatException e) {
                          // Tipo inválido, manter descrição vazia
                      }
                  }
                  
                  // Obter nome da rota
                  String nome_rota = "";
                  String id_rota_str = result.getString("id_rota");
                  if (id_rota_str != null && !id_rota_str.isEmpty()) {
                      try {
                          int id_rota = Integer.parseInt(id_rota_str);
                          String sql3 = "SELECT nome_rota FROM rotas WHERE id_rota = ?";
                          PreparedStatement stmt3 = conn.prepareStatement(sql3);
                          stmt3.setInt(1, id_rota);
                          ResultSet result3 = stmt3.executeQuery();
                          if (result3.next()) {
                              nome_rota = result3.getString("nome_rota") != null ? result3.getString("nome_rota") : "";
                          }
                          result3.close();
                          stmt3.close();
                      } catch (NumberFormatException e) {
                          // ID da rota inválido, manter nome vazio
                      }
                  }
                  
                  // Obter id_viagem
                  String id_viagem = result.getString("id_viagem") != null ? result.getString("id_viagem") : "";
                  String id_alerta = result.getString("id_alerta") != null ? result.getString("id_alerta") : "";
          %>
                  <tr>
                      <td><%= id_alerta %></td>
                      <td><%= nome_rota %></td>
                      <td><%= id_viagem %></td>
                      <td><%= descricao %></td>
                      <td>
                          <form action='descricao_alertas.jsp' method='POST'>
                              <input type='hidden' name='id_alerta' value='<%= id_alerta %>'>
                              <button type='submit' class='btn btn-primary btn-sm'>Ver Descrição</button>
                          </form>
                      </td>
                  </tr>
          <%
              }
              
              if (!hasResults) {
          %>
                  <tr>
                      <td colspan="5" class="text-center">Nenhum alerta encontrado com os filtros aplicados.</td>
                  </tr>
          <%
              }
              
              result.close();
              stmt.close();
          } catch (SQLException e) {
              out.println("Erro ao carregar alertas: " + e.getMessage());
          }
          %>
      </tbody>
  </table>

  <br>
  </div>

<!-- Bootstrap JS (local) -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
