# 📚 Biblioteca ASP.NET

Sistema de gerenciamento de biblioteca desenvolvido em ASP.NET Core MVC com banco de dados MySQL. Permite o controle de livros, usuários, empréstimos e autenticação por sessão.

---

## 🚀 Tecnologias Utilizadas

- **ASP.NET Core MVC** — framework web principal
- **C#** — linguagem de programação
- **MySQL** — banco de dados relacional
- **MySql.Data** — conector MySQL para .NET
- **HTML/CSS/Razor** — frontend das views

---

## ⚙️ Funcionalidades

- 📖 Cadastro, listagem, edição e remoção de livros
- 👤 Gerenciamento de usuários (Bibliotecário e Admin)
- 🔄 Controle de empréstimos de livros
- 🔐 Autenticação por sessão com controle de acesso por perfil
- 📦 Cadastro de autores, editoras e gêneros
- 🖼️ Upload de capa dos livros

---

## 🗄️ Banco de Dados

O projeto utiliza **MySQL**. O script de criação do banco está no arquivo `BdBiblioteca.sql` na raiz do projeto.

**Tabelas principais:**
- `Usuarios` — usuários do sistema com roles (Bibliotecário/Admin)
- `livros` — acervo de livros com quantidade disponível
- `autor`, `editora`, `genero` — dados relacionados aos livros
- `emprestimo` — registro dos empréstimos

---

## 🛠️ Como Rodar o Projeto

### Pré-requisitos

- [.NET SDK 6.0+](https://dotnet.microsoft.com/download)
- [MySQL Server](https://dev.mysql.com/downloads/)
- [Visual Studio 2022](https://visualstudio.microsoft.com/) ou VS Code

### Passo a passo

1. **Clone o repositório**

git clone https://github.com/seu-usuario/Biblioteca-ASP-NET.git
cd Biblioteca-ASP-NET

2. **Configure o banco de dados**
   - Abra o MySQL e execute o script: `source BdBiblioteca.sql;`

3. **Configure a string de conexão**
   - Em `ProjetoBiblioteca/Data/Database.cs`, ajuste a string de conexão com seu usuário e senha do MySQL.

4. **Rode o projeto**

cd ProjetoBiblioteca
dotnet run

Ou abra a solution `ProjetoBiblioteca.sln` no Visual Studio e pressione `F5`.

---

## 📁 Estrutura do Projeto

Biblioteca-ASP-NET/
├── BdBiblioteca.sql
├── ProjetoBiblioteca.sln
└── ProjetoBiblioteca/
    ├── Autenticacao/
    ├── Controllers/
    ├── Data/
    ├── Models/
    ├── Views/
    └── Program.cs

---

## 👥 Perfis de Acesso

| Perfil | Permissões |
|---|---|
| Admin | Acesso total ao sistema |
| Bibliotecario | Gerencia livros e empréstimos |

---

## 📄 Licença

Este projeto foi desenvolvido para fins educacionais.
