-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 02-Jul-2025 às 13:58
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `felixbus`
--
CREATE DATABASE IF NOT EXISTS `felixbus` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `felixbus`;

-- --------------------------------------------------------

--
-- Estrutura da tabela `alertas`
--

CREATE TABLE `alertas` (
  `id_alerta` int(11) NOT NULL,
  `id_rota` int(11) DEFAULT NULL,
  `id_viagem` int(11) DEFAULT NULL,
  `descricao` varchar(255) NOT NULL,
  `tipo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `alertas`
--

INSERT INTO `alertas` (`id_alerta`, `id_rota`, `id_viagem`, `descricao`, `tipo`) VALUES
(10, NULL, 8, 'Furo pneu de trás', 2),
(11, NULL, 7, 'Transito', 3);

-- --------------------------------------------------------

--
-- Estrutura da tabela `bilhete`
--

CREATE TABLE `bilhete` (
  `id_bilhete` int(11) NOT NULL,
  `id_viagem` int(11) NOT NULL,
  `id_utilizador` int(100) NOT NULL,
  `cidade_origem` varchar(100) NOT NULL,
  `cidade_destino` varchar(100) NOT NULL,
  `data_viagem` date NOT NULL,
  `hora` time NOT NULL,
  `preco` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `bilhete`
--

INSERT INTO `bilhete` (`id_bilhete`, `id_viagem`, `id_utilizador`, `cidade_origem`, `cidade_destino`, `data_viagem`, `hora`, `preco`) VALUES
(13, 7, 11, 'Lisboa', 'Leiria', '2025-05-27', '16:50:52', 6);

-- --------------------------------------------------------

--
-- Estrutura da tabela `carteiras`
--

CREATE TABLE `carteiras` (
  `id_carteira` int(11) NOT NULL,
  `id_utilizador` int(11) NOT NULL,
  `saldo` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `carteiras`
--

INSERT INTO `carteiras` (`id_carteira`, `id_utilizador`, `saldo`) VALUES
(5, 11, 34),
(6, 7, 0),
(7, 9, 0),
(8, 8, 0),
(9, 12, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `cidades`
--

CREATE TABLE `cidades` (
  `id_cidade` int(11) NOT NULL,
  `nome_cidade` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `cidades`
--

INSERT INTO `cidades` (`id_cidade`, `nome_cidade`) VALUES
(2, 'Castelo Branco'),
(8, 'Coimbra'),
(4, 'Covilhã'),
(5, 'Fundão'),
(6, 'Guarda'),
(7, 'Leiria'),
(1, 'Lisboa'),
(3, 'Porto');

-- --------------------------------------------------------

--
-- Estrutura da tabela `estratos_bancarios`
--

CREATE TABLE `estratos_bancarios` (
  `id_transacao` int(11) NOT NULL,
  `id_carteira` int(11) NOT NULL,
  `id_utilizador` int(11) NOT NULL,
  `data_transacao` date NOT NULL,
  `valor` int(11) NOT NULL,
  `tipo_transacao` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `estratos_bancarios`
--

INSERT INTO `estratos_bancarios` (`id_transacao`, `id_carteira`, `id_utilizador`, `data_transacao`, `valor`, `tipo_transacao`) VALUES
(10, 5, 11, '2025-06-17', 100, 1),
(11, 5, 11, '2025-06-17', 50, 0),
(12, 5, 11, '2025-06-17', 6, 0),
(13, 5, 11, '2025-06-17', 11, 0),
(14, 5, 11, '2025-06-17', 11, 1),
(15, 5, 8, '2025-06-17', 4, 0),
(16, 5, 11, '2025-06-17', 6, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `nivel_acesso`
--

CREATE TABLE `nivel_acesso` (
  `nivel_acesso` int(11) NOT NULL,
  `descricao` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `nivel_acesso`
--

INSERT INTO `nivel_acesso` (`nivel_acesso`, `descricao`) VALUES
(1, 'Cliente'),
(2, 'Funcionario'),
(3, 'Admin');

-- --------------------------------------------------------

--
-- Estrutura da tabela `registos`
--

CREATE TABLE `registos` (
  `id_registo` int(11) NOT NULL,
  `nome_utilizador` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `data_nasc` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `rotas`
--

CREATE TABLE `rotas` (
  `id_rota` int(11) NOT NULL,
  `nome_rota` varchar(100) NOT NULL,
  `taxa_inicial` int(100) NOT NULL,
  `taxa_paragem` int(100) NOT NULL,
  `num_paragens` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `rotas`
--

INSERT INTO `rotas` (`id_rota`, `nome_rota`, `taxa_inicial`, `taxa_paragem`, `num_paragens`) VALUES
(1, 'Linha Beira Baixa', 5, 1, 7),
(2, 'linha do norte', 3, 1, 8);

-- --------------------------------------------------------

--
-- Estrutura da tabela `rotas_cidade`
--

CREATE TABLE `rotas_cidade` (
  `id_rotas_cidade` int(11) NOT NULL,
  `id_rota` int(11) NOT NULL,
  `id_cidade` int(11) NOT NULL,
  `num_paragem` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `rotas_cidade`
--

INSERT INTO `rotas_cidade` (`id_rotas_cidade`, `id_rota`, `id_cidade`, `num_paragem`) VALUES
(1, 1, 1, 1),
(2, 1, 7, 2),
(3, 1, 2, 3),
(4, 1, 5, 4),
(5, 1, 4, 5),
(6, 1, 6, 6),
(10, 1, 8, 7),
(11, 2, 3, 5),
(12, 2, 8, 6),
(13, 2, 4, 7),
(14, 2, 5, 8);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tipo_alerta`
--

CREATE TABLE `tipo_alerta` (
  `id_tipo` int(11) NOT NULL,
  `descricao` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `tipo_alerta`
--

INSERT INTO `tipo_alerta` (`id_tipo`, `descricao`) VALUES
(1, 'Promocao'),
(2, 'Cancelamento'),
(3, 'Alteração de horário');

-- --------------------------------------------------------

--
-- Estrutura da tabela `utilizadores`
--

CREATE TABLE `utilizadores` (
  `id_utilizador` int(100) NOT NULL,
  `nome_utilizador` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `data_nasc` date NOT NULL,
  `nivel_acesso` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `utilizadores`
--

INSERT INTO `utilizadores` (`id_utilizador`, `nome_utilizador`, `password`, `email`, `data_nasc`, `nivel_acesso`) VALUES
(7, 'admin', '$2y$10$1PtiVf3MZvk8pDOp04Tzk.e3jDNBQCQo6zJN.hIkdiTtsQBjumtPq', 'admin@ipcb.pt', '2004-06-08', 3),
(8, 'funcionario', '$2y$10$yOItugAzQVNsOliSHkfOOu4rGNrju1lT3KMRrY9rm4FRyf9GNILkC', 'funcionario@ipcb.pt', '2001-12-31', 2),
(9, 'cliente', '$2y$10$vaCpnDIC7gbd/2rT0xTZFuAqfU5Y0Db2YFmqKZzZEGp013ViXrW8a', 'cliente@ipcb.pt', '2004-06-09', 1),
(11, 'vicente', '$2y$10$X8ktoKrXbMlAW4BCNGug7uI5yOpOeio.LJWzJBerGJsjnotKdEDji', 'vicente.miranda@ipcbcampus.pt', '2004-10-20', 1),
(12, 'Jerónimo', '$2y$10$irziWPWIWeyP1c69D/93zeVNwHhZsbmeMrX9WnpRIKIJKtM.a.dPy', 'jeronimo@gmail.com', '2025-03-11', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `veiculos`
--

CREATE TABLE `veiculos` (
  `id_veiculo` int(11) NOT NULL,
  `nome_veiculo` varchar(100) NOT NULL,
  `num_passageiros` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `veiculos`
--

INSERT INTO `veiculos` (`id_veiculo`, `nome_veiculo`, `num_passageiros`) VALUES
(1, '45-TFY', 37);

-- --------------------------------------------------------

--
-- Estrutura da tabela `viagem`
--

CREATE TABLE `viagem` (
  `id_viagem` int(11) NOT NULL,
  `id_rota` int(11) NOT NULL,
  `id_veiculo` int(11) NOT NULL,
  `data` date NOT NULL,
  `hora_partida` time NOT NULL,
  `hora_chegada` time NOT NULL,
  `vagas` int(11) NOT NULL,
  `estado_viagem` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `viagem`
--

INSERT INTO `viagem` (`id_viagem`, `id_rota`, `id_veiculo`, `data`, `hora_partida`, `hora_chegada`, `vagas`, `estado_viagem`) VALUES
(7, 1, 1, '2025-05-27', '16:50:52', '19:00:00', 35, 1),
(8, 1, 1, '2025-05-31', '14:20:00', '20:00:00', 32, 0),
(9, 1, 1, '2026-06-17', '16:40:00', '18:25:00', 100, 1),
(10, 2, 1, '2025-06-30', '10:00:00', '10:00:00', 40, 1);

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `alertas`
--
ALTER TABLE `alertas`
  ADD PRIMARY KEY (`id_alerta`),
  ADD KEY `fk_tipo` (`tipo`),
  ADD KEY `fk_alerta_viagem` (`id_viagem`),
  ADD KEY `fk_alerta_rota` (`id_rota`);

--
-- Índices para tabela `bilhete`
--
ALTER TABLE `bilhete`
  ADD PRIMARY KEY (`id_bilhete`),
  ADD KEY `fk_viagem` (`id_viagem`),
  ADD KEY `fk_uti` (`id_utilizador`);

--
-- Índices para tabela `carteiras`
--
ALTER TABLE `carteiras`
  ADD PRIMARY KEY (`id_carteira`),
  ADD KEY `fk_utilizador` (`id_utilizador`);

--
-- Índices para tabela `cidades`
--
ALTER TABLE `cidades`
  ADD PRIMARY KEY (`id_cidade`),
  ADD UNIQUE KEY `cidade_unique` (`nome_cidade`);

--
-- Índices para tabela `estratos_bancarios`
--
ALTER TABLE `estratos_bancarios`
  ADD PRIMARY KEY (`id_transacao`),
  ADD KEY `fk_carteira` (`id_carteira`),
  ADD KEY `fk_estrato_uti` (`id_utilizador`);

--
-- Índices para tabela `nivel_acesso`
--
ALTER TABLE `nivel_acesso`
  ADD PRIMARY KEY (`nivel_acesso`);

--
-- Índices para tabela `registos`
--
ALTER TABLE `registos`
  ADD PRIMARY KEY (`id_registo`);

--
-- Índices para tabela `rotas`
--
ALTER TABLE `rotas`
  ADD PRIMARY KEY (`id_rota`);

--
-- Índices para tabela `rotas_cidade`
--
ALTER TABLE `rotas_cidade`
  ADD PRIMARY KEY (`id_rotas_cidade`),
  ADD KEY `fk_id_rota` (`id_rota`),
  ADD KEY `fk_id_cidade` (`id_cidade`);

--
-- Índices para tabela `tipo_alerta`
--
ALTER TABLE `tipo_alerta`
  ADD PRIMARY KEY (`id_tipo`);

--
-- Índices para tabela `utilizadores`
--
ALTER TABLE `utilizadores`
  ADD PRIMARY KEY (`id_utilizador`),
  ADD UNIQUE KEY `emailUnique` (`email`),
  ADD UNIQUE KEY `nome_utilizador` (`nome_utilizador`),
  ADD KEY `fk_nivelacesso` (`nivel_acesso`);

--
-- Índices para tabela `veiculos`
--
ALTER TABLE `veiculos`
  ADD PRIMARY KEY (`id_veiculo`);

--
-- Índices para tabela `viagem`
--
ALTER TABLE `viagem`
  ADD PRIMARY KEY (`id_viagem`),
  ADD KEY `fk_rotas` (`id_rota`),
  ADD KEY `fk_veiculo` (`id_veiculo`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `alertas`
--
ALTER TABLE `alertas`
  MODIFY `id_alerta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de tabela `bilhete`
--
ALTER TABLE `bilhete`
  MODIFY `id_bilhete` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `carteiras`
--
ALTER TABLE `carteiras`
  MODIFY `id_carteira` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `cidades`
--
ALTER TABLE `cidades`
  MODIFY `id_cidade` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `estratos_bancarios`
--
ALTER TABLE `estratos_bancarios`
  MODIFY `id_transacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de tabela `registos`
--
ALTER TABLE `registos`
  MODIFY `id_registo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `rotas`
--
ALTER TABLE `rotas`
  MODIFY `id_rota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `rotas_cidade`
--
ALTER TABLE `rotas_cidade`
  MODIFY `id_rotas_cidade` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de tabela `tipo_alerta`
--
ALTER TABLE `tipo_alerta`
  MODIFY `id_tipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `utilizadores`
--
ALTER TABLE `utilizadores`
  MODIFY `id_utilizador` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de tabela `veiculos`
--
ALTER TABLE `veiculos`
  MODIFY `id_veiculo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `viagem`
--
ALTER TABLE `viagem`
  MODIFY `id_viagem` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `alertas`
--
ALTER TABLE `alertas`
  ADD CONSTRAINT `fk_alerta_rota` FOREIGN KEY (`id_rota`) REFERENCES `rotas` (`id_rota`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_alerta_viagem` FOREIGN KEY (`id_viagem`) REFERENCES `viagem` (`id_viagem`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tipo` FOREIGN KEY (`tipo`) REFERENCES `tipo_alerta` (`id_tipo`);

--
-- Limitadores para a tabela `bilhete`
--
ALTER TABLE `bilhete`
  ADD CONSTRAINT `fk_uti` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_viagem` FOREIGN KEY (`id_viagem`) REFERENCES `viagem` (`id_viagem`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `carteiras`
--
ALTER TABLE `carteiras`
  ADD CONSTRAINT `fk_utilizador` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `estratos_bancarios`
--
ALTER TABLE `estratos_bancarios`
  ADD CONSTRAINT `fk_carteira` FOREIGN KEY (`id_carteira`) REFERENCES `carteiras` (`id_carteira`),
  ADD CONSTRAINT `fk_estrato_uti` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`);

--
-- Limitadores para a tabela `rotas_cidade`
--
ALTER TABLE `rotas_cidade`
  ADD CONSTRAINT `fk_id_cidade` FOREIGN KEY (`id_cidade`) REFERENCES `cidades` (`id_cidade`),
  ADD CONSTRAINT `fk_id_rota` FOREIGN KEY (`id_rota`) REFERENCES `rotas` (`id_rota`);

--
-- Limitadores para a tabela `utilizadores`
--
ALTER TABLE `utilizadores`
  ADD CONSTRAINT `fk_nivelacesso` FOREIGN KEY (`nivel_acesso`) REFERENCES `nivel_acesso` (`nivel_acesso`);

--
-- Limitadores para a tabela `viagem`
--
ALTER TABLE `viagem`
  ADD CONSTRAINT `fk_rotas` FOREIGN KEY (`id_rota`) REFERENCES `rotas` (`id_rota`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_veiculo` FOREIGN KEY (`id_veiculo`) REFERENCES `veiculos` (`id_veiculo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
