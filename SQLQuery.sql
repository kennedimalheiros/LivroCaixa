Create database caixa
use caixa
-- -----------------------------------------------------
-- Table Usuarios
-- -----------------------------------------------------



CREATE  TABLE usuarios (
  cod INT Identity(1,1) NOT NULL ,
  nome VARCHAR(60) NOT NULL ,
  usuario VARCHAR(45) NOT NULL ,
  senha VARCHAR(45) NOT NULL ,
  data DATETIME NOT NULL ,
  nivel INT NOT NULL,-- COMMENT 0 Administrador  1 Usuario Com Relatorios  2 Usuarios Basico
  PRIMARY KEY (cod) 
  )

INSERT INTO usuarios (nome, usuario, senha, data, nivel) VALUES ('master', 'Adiministrador', '123', getdate(), 0)


-- -----------------------------------------------------
-- Table Caixas
-- -----------------------------------------------------

CREATE  TABLE caixas (
  cod INT NOT NULL ,
  dataAbertura DATETIME NOT NULL ,
  dataFechamento DATETIME NULL ,
  usuarioAbertura INT NOT NULL ,
  usuarioFechamento INT NULL ,
  valorAbertura DECIMAL(8,2) NOT NULL ,
  valorFechamento DECIMAL(8,2) NULL ,
  periodo BIT NOT NULL, -- COMMENT 0 Dia  1 Noite\n
  PRIMARY KEY (cod),
  FOREIGN KEY (usuarioAbertura)
	REFERENCES usuarios (cod), 
  FOREIGN KEY (usuarioFechamento)
	REFERENCES usuarios (cod) 	
  )

INSERT INTO caixas (dataAbertura, dataFechamento, usuarioAbertura, usuarioFechamento, valorAbertura, valorFechamento, periodo)
					values (GETDATE(),null, 1,null, 100, null, 0)

-- -----------------------------------------------------
-- Table Tipos
-- -----------------------------------------------------

--COMMENT = 'Tipo Operação\nSangria\nSuprimento\nCompra material\nCompra etc.'

CREATE  TABLE tipos (
  cod INT NOT NULL ,
  descricao VARCHAR(45) NOT NULL ,
  acao BIT NOT NULL, -- COMMENT 0 Debito 1 Credito
  PRIMARY KEY (cod) 
  )



-- -----------------------------------------------------
-- Table Movimentacões
-- -----------------------------------------------------

CREATE  TABLE movimentacoes (
  cod INT NOT NULL ,
  data DATETIME NOT NULL ,
  usuario INT NOT NULL ,
  tipo INT NOT NULL, -- COMMENT Suprimento, Sangria
  caixa INT NOT NULL, -- COMMENT 0 Dia  1 Noite
  PRIMARY KEY (cod),
  FOREIGN KEY (usuario)
	REFERENCES usuarios (cod),
  FOREIGN KEY (caixa)
	REFERENCES caixas (cod)   
  )


Create procedure SpAberturaCaixa
AS
