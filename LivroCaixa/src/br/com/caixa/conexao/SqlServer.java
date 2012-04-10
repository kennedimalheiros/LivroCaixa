/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.caixa.conexao;

import java.sql.*; // Importando biblioteca java SQL para conexões.

/**
 * Criando Conexão com o Banco de dados SQL Server
 *
 * @author Kennedi Paulo S. Malheiros
 * @author Colaboradores
 * @version 1.0 09/04/2012
 * @since 1.0
 */
public class SqlServer {

    /**
     * Fazendo conexão com o banco de dados
     * @return Uma Conexão
     * @throws SQLException 
     */
    public static Connection getConexaoSQL() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection("jdbc:sqlserver://localhost:1433; databaseName=caixa; user=kennedysql; password=123");

        } catch (ClassNotFoundException e) {
            throw new SQLException(e.getMessage());
        }
    }
}
