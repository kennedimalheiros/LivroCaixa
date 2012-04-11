drop database caixa
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

CREATE INDEX ixNome usuarios(nome)
CREATE INDEX ixUsuario usuarios(usuario)
CREATE INDEX ixNivel usuarios(nivel)

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
  codcaixa INT , -- Cod referente a caixa  / se o codcaixa = 0  entao o caixa e de abertura 
  PRIMARY KEY (cod),
  FOREIGN KEY (usuario)
	REFERENCES usuarios (cod), 
  FOREIGN KEY (codcaixa)
	REFERENCES caixas (cod) 	
  )


CREATE INDEX ixValor caixas(valor)

EXEC SpAberturaCaixa

-- -----------------------------------------------------
-- Table Tipos
-- -----------------------------------------------------

--COMMENT = 'Tipo Opera??o\nSangria\nSuprimento\nCompra material\nCompra etc.'

CREATE  TABLE tipos (
  cod INT Identity(1,1) ,
  descricao VARCHAR(45) NOT NULL ,
  acao BIT NOT NULL, -- COMMENT 0 Debito 1 Credito
  PRIMARY KEY (cod) 
  )

CREATE INDEX ixDescricao tipos(descricao)

  INSERT INTO tipos (descricao, acao) VALUES ('ABRI_CAIXA', 1)
  INSERT INTO tipos (descricao, acao) VALUES ('SANGRIA', 0)
  INSERT INTO tipos (descricao, acao) VALUES ('COMPRA', 0)
  INSERT INTO tipos (descricao, acao) VALUES ('SUPRIMENTO', 1)

 
  
-- -----------------------------------------------------
-- Table Movimentac?es
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

CREATE INDEX ixData movimentacoes(data)


INSERT INTO movimentacoes (data, usuario, tipo, caixa, valor) 
				   VALUES (GETDATE(),  1,   1,      1,    100 ) 


--INSERT INTO movimentacoes (data, usuario, tipo, caixa, valor) 
--				   VALUES (GETDATE(),  1,   1,      1,    100 ) 

--Implementações (Como pegar a data, para verificar se na data 11/04 tem um caixa DIA fechado, nao deixa abri outro, apenas NOTURNO.)

--INICIL DA PROCEDURE SpAberturaCaixa
CREATE PROCEDURE SpAberturaCaixa (@usuario INT, @valor DECIMAL(8,2), @periodo BIT)
AS
Begin tran
if ( (SELECT COUNT(*) FROM caixas WHERE situacao=0) <=0 )
  BEGIN
	INSERT INTO caixas (data, usuario, valor, periodo, situacao, codcaixa)
			values (GETDATE(), @usuario, @valor, @periodo, 0, 0)
	IF(@@ERROR = 0)
		BEGIN
		    COMMIT
		    SELECT 'OPERAÇÃO REALIZADA COM SUCESSO.'
		END
	ELSE 
		BEGIN
		    ROLLBACK
		    SELECT 'ERRO FOI ENCONTRADO AO REALIZAR ESTA OPERAÇÃO'
		END

END

ELSE
  BEGIN
	ROLLBACK
	SELECT 'ERRO: EXISTE OUTRO CAIXA EM ABERTO, NECESSARIO FECHAR PARA CONTINUAR.'

END
--FIM DA PROCEDURE SpAberturaCaixa

-- INICIL DA PROCEDURE SpFecharCaixa
CREATE PROCEDURE SpFecharCaixa (@usuario int, @valor decimal(8,2))
AS
BEGIN TRAN
IF ((SELECT COUNT(*) FROM caixas where situacao=0)=1)
 BEGIN
 
   DECLARE @codCaixaAberto INT
   SET @codCaixaAberto = (SELECT COD FROM caixas WHERE situacao=0)
   DECLARE @periodoAberto INT
   SET @periodoAberto = (SELECT periodo FROM caixas where cod=@codCaixaAberto)
 
    INSERT INTO caixas (data, usuario, valor, periodo, situacao, codcaixa)
			values (GETDATE(), @usuario, @valor, @periodoAberto, 1, @codCaixaAberto)
	
	IF (@@ERROR = 0)
		BEGIN
		  SELECT 'CAIXA FECHADO INSERIDO COM SUCESSO'
		  UPDATE caixas SET situacao=1 where cod=@codCaixaAberto
		  IF (@@ERROR=0)
	   		  BEGIN
			  COMMIT
			  SELECT 'ATUALIZAÇÃO CAIXA ABERTO PARA FECHADO COM SUCESSO'
			  END
		  ELSE 
			  BEGIN
			  ROLLBACK
			  SELECT 'ERRO AO TENTAR ATUALIZAÇÃO CAIXA ABERTO PARA FECHADO COM SUCESSO'
			  END
		END
	ELSE 
	    BEGIN
		      ROLLBACK
		      SELECT 'ERRO AO INSERI CAIXA FECHAR'
	    END


END		
ELSE 
	BEGIN
		ROLLBACK
		SELECT 'NÃO EXISTE CAIXA EM ABERTO'
    END

-- FIM DA PROCEDURE SpFecharCaixa			
	
	

select * from usuarios
select * from caixas
select * from tipos
select * from movimentacoes
update caixas set situacao=1

drop procedure SpFecharCaixa
exec SpAberturaCaixa 1, 200,1  -- Usuario , Valor Abertura de Caixa, Periodo
exec SpFecharCaixa 1, 300      -- Usuario , Valor em Caixa

