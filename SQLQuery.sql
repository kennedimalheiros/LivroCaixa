Create database caixa
use caixa
-- -----------------------------------------------------
-- Table Usuarios
-- -----------------------------------------------------


CREATE  TABLE usuarios (
  cod INT Identity(1,1) ,
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
  cod INT Identity(1,1) ,
  data DATETIME NULL ,
  usuario INT NOT NULL ,
  valor DECIMAL(8,2) NOT NULL ,
  periodo BIT NOT NULL, -- COMMENT 0 Dia  1 Noite\n
  situacao BIT NOT NULL, -- 0 Aberto  1 Fechado
  codcaixa INT NOT NULL, -- Cod referente a caixa
  PRIMARY KEY (cod),
  FOREIGN KEY (usuario)
	REFERENCES usuarios (cod), 
  FOREIGN KEY (codcaixa)
	REFERENCES caixas (cod) 	
  )

INSERT INTO caixas (dataAbertura, dataFechamento, usuarioAbertura, usuarioFechamento, valorAbertura, valorFechamento, periodo)
					values (GETDATE(),null, 1,null, 100, null, 0, 0)

-- -----------------------------------------------------
-- Table Tipos
-- -----------------------------------------------------

--COMMENT = 'Tipo Operação\nSangria\nSuprimento\nCompra material\nCompra etc.'

CREATE  TABLE tipos (
  cod INT Identity(1,1) ,
  descricao VARCHAR(45) NOT NULL ,
  acao BIT NOT NULL, -- COMMENT 0 Debito 1 Credito
  PRIMARY KEY (cod) 
  )
  INSERT INTO tipos (descricao, acao) VALUES ('ABRI_CAIXA', 1)
  INSERT INTO tipos (descricao, acao) VALUES ('SANGRIA', 0)
  INSERT INTO tipos (descricao, acao) VALUES ('COMPRA', 0)
  INSERT INTO tipos (descricao, acao) VALUES ('SUPRIMENTO', 1)

 
  
-- -----------------------------------------------------
-- Table Movimentacões
-- -----------------------------------------------------

CREATE  TABLE movimentacoes (
  cod INT Identity(1,1) ,
  data DATETIME NOT NULL ,
  usuario INT NOT NULL ,
  tipo INT NOT NULL, -- COMMENT Suprimento, Sangria...
  caixa INT NOT NULL, -- COMMENT 0 Dia  1 Noite
  valor DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (cod),
  FOREIGN KEY (usuario)
	REFERENCES usuarios (cod),
  FOREIGN KEY (caixa)
	REFERENCES caixas (cod)   
  )

INSERT INTO movimentacoes (data, usuario, tipo, caixa, valor) 
				   VALUES (GETDATE(),  1,   1,      1,    100 ) 

INSERT INTO movimentacoes (data, usuario, tipo, caixa, valor) 
				   VALUES (GETDATE(),  1,   1,      1,    100 ) 



Create procedure SpMovimentacao
AS
Begin Tran
if 



select * from caixas where dataFechamento != NULL
