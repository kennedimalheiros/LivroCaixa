Create database caixa
use caixa
-- -----------------------------------------------------
-- Table `usuarios`
-- -----------------------------------------------------



CREATE  TABLE usuarios (
  cod INT Identity(1,1) NOT NULL ,
  nome VARCHAR(60) NOT NULL ,
  login VARCHAR(45) NOT NULL ,
  senha VARCHAR(45) NOT NULL ,
  data DATETIME NOT NULL ,
  nivel INT NOT NULL,-- COMMENT '0 Administrador\n1 Usuario Com Relatorios\n2 Usuarios Basico'
  PRIMARY KEY (cod) 
  )


-- -----------------------------------------------------
-- Table `caixas`
-- -----------------------------------------------------

CREATE  TABLE caixas (
  cod INT NOT NULL ,
  dataAbertura DATETIME NOT NULL ,
  dataFechamento DATETIME NULL ,
  usuarioAbertura INT NOT NULL ,
  usuarioFechamento INT NULL ,
  valorAbertura DECIMAL(8,2) NOT NULL ,
  valorFechamento DECIMAL(8,2) NULL ,
  periodo BIT NOT NULL, -- COMMENT '0 Dia\n1 Noite\n'
  PRIMARY KEY (cod),
  FOREIGN KEY (usuarioAbertura)
	REFERENCES usuarios (cod), 
  FOREIGN KEY (usuarioFechamento)
	REFERENCES usuarios (cod) 	
  )

-- -----------------------------------------------------
-- Table `tipos`
-- -----------------------------------------------------

--COMMENT = 'Tipo Operação\nSangria\nSuprimento\nCompra material\nCompra etc.' /* comment truncated */ ;

CREATE  TABLE tipos (
  cod INT NOT NULL ,
  descricao VARCHAR(45) NOT NULL ,
  acao BIT NOT NULL, -- COMMENT '0 Debito \n1 Credito'
  PRIMARY KEY (cod) 
  )



-- -----------------------------------------------------
-- Table `movimentacoes`
-- -----------------------------------------------------

CREATE  TABLE movimentacoes (
  cod INT NOT NULL ,
  data DATETIME NOT NULL ,
  usuario INT NOT NULL ,
  tipo INT NOT NULL, -- COMMENT 'Suprimento\nSangria\n'
  caixa INT NOT NULL, -- COMMENT '0 Dia\n1 Noite'
  PRIMARY KEY (cod),
  FOREIGN KEY (usuario)
	REFERENCES usuarios (cod),
  FOREIGN KEY (caixa)
	REFERENCES caixas (cod)   
  )


Create procedure SPAberturaCaixa
AS
