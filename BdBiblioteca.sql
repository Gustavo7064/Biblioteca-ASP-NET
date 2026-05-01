-- ============================================================
-- Banco de Dados: bdBiblioteca
-- ============================================================

create database bdBiblioteca;
use bdBiblioteca;

-- ============================================================
-- TABELAS
-- ============================================================

create table Usuarios(
    id int primary key auto_increment,
    nome varchar(100),
    email varchar(100),
    senha_hash varchar(255),
    role enum ("Bibliotecario","Admin"),
    ativo tinyint(1) default 1,
    criado_Em datetime default current_timestamp
);

CREATE TABLE editora (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE genero (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE autor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE livros (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200),
    autor int,
    editora int,
    genero int,
    ano int,
    isbn VARCHAR(32),
    quantidade_total INT,
    quantidade_disponivel INT,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE livros
    ADD CONSTRAINT fk_livros_autor
        FOREIGN KEY (autor) REFERENCES autor(id),
    ADD CONSTRAINT fk_livros_editora
        FOREIGN KEY (editora) REFERENCES editora(id),
    ADD CONSTRAINT fk_livros_genero
        FOREIGN KEY (genero) REFERENCES genero(id);


-- ============================================================
-- STORED PROCEDURES
-- ============================================================

DELIMITER $$

-- Cadastrar Usuário
DROP PROCEDURE IF EXISTS sp_usuario_criar $$
CREATE PROCEDURE sp_usuario_criar (
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_senha_hash VARCHAR(255),
    IN p_role VARCHAR(20)  -- precisa ser VARCHAR, não ENUM
)
BEGIN
    INSERT INTO Usuarios (nome, email, senha_Hash, role, ativo, criado_Em)
    VALUES (p_nome, p_email, p_senha_hash, p_role, 1, NOW());
END $$

DELIMITER ;

-- Exemplo de uso (ATENÇÃO: role deve ser 'Adm', não 'Admin')
CALL sp_usuario_criar(
    'João Admin',
    'joao@biblioteca.com',
    '$2a$11$HASHADMINEXEMPLO9876543210',
    'Adm'
);

select * from usuarios;


DELIMITER $$

-- Listar Autor, Editora e Gênero
DROP PROCEDURE IF EXISTS sp_autor_listar $$
CREATE PROCEDURE sp_autor_listar()
BEGIN
    SELECT id, nome FROM autor ORDER BY nome;
END $$

DROP PROCEDURE IF EXISTS sp_editora_listar $$
CREATE PROCEDURE sp_editora_listar()
BEGIN
    SELECT id, nome FROM editora ORDER BY nome;
END $$

DROP PROCEDURE IF EXISTS sp_genero_listar $$
CREATE PROCEDURE sp_genero_listar()
BEGIN
    SELECT id, nome FROM genero ORDER BY nome;
END $$


-- Cadastrar Editora, Gênero e Autor
DROP PROCEDURE IF EXISTS sp_editora_criar $$
CREATE PROCEDURE sp_editora_criar (
    IN p_nome VARCHAR(150)
)
BEGIN
    INSERT INTO editora (nome)
    VALUE (p_nome);
END;$$

DROP PROCEDURE IF EXISTS sp_genero_criar $$
CREATE PROCEDURE sp_genero_criar (
    IN p_nome VARCHAR(100)
)
BEGIN
    INSERT INTO genero (nome)
    VALUE (p_nome);
END;$$

DROP PROCEDURE IF EXISTS sp_autor_criar $$
CREATE PROCEDURE sp_autor_criar (
    IN p_nome VARCHAR(150)
)
BEGIN
    INSERT INTO autor (nome)
    VALUE (p_nome);
END;$$


-- Criar Livro
DROP PROCEDURE IF EXISTS sp_livro_criar $$
CREATE PROCEDURE sp_livro_criar (
    IN p_titulo VARCHAR(200),
    IN p_autor INT,
    IN p_editora INT,
    IN p_genero INT,
    IN p_ano SMALLINT,
    IN p_isbn VARCHAR(32),
    IN p_quantidade INT
)
BEGIN
    INSERT INTO livros
        (titulo, autor, editora, genero, ano, isbn, quantidade_total, quantidade_disponivel)
    VALUES
        (p_titulo, p_autor, p_editora, p_genero, p_ano, p_isbn, p_quantidade, p_quantidade);
END $$


-- Listar Livros
DROP PROCEDURE IF EXISTS sp_livro_listar $$
CREATE PROCEDURE sp_livro_listar ()
BEGIN
    SELECT
        l.id,
        l.titulo,
        l.autor,
        a.nome AS autor_nome,
        l.editora,
        e.nome AS editora_nome,
        l.genero,
        g.nome AS genero_nome,
        l.ano,
        l.isbn,
        l.quantidade_total,
        l.quantidade_disponivel,
        l.criado_em
    FROM livros l
    LEFT JOIN autor   a ON a.id = l.autor
    LEFT JOIN editora e ON e.id = l.editora
    LEFT JOIN genero  g ON g.id = l.genero
    ORDER BY l.titulo;
END $$

DELIMITER ;