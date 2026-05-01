using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MySql.Data.MySqlClient;
using ProjetoBiblioteca.Data;
using ProjetoBiblioteca.Models;
using System.Data;

namespace ProjetoBiblioteca.Controllers
{
    public class LivroController : Controller
    {
        private readonly Database db = new Database();

        // Helpers para carregar os selects via SP
        private List<SelectListItem> CarregarAutores(MySqlConnection conn)
        {
            var list = new List<SelectListItem>();
            using var cmd = new MySqlCommand("sp_autor_listar", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            using var rd = cmd.ExecuteReader();
            while (rd.Read())
            {
                list.Add(new SelectListItem { Value = rd.GetInt32("id").ToString(), Text = rd.GetString("nome") });
            }
            return list;
        }

        private List<SelectListItem> CarregarEditoras(MySqlConnection conn)
        {
            var list = new List<SelectListItem>();
            using var cmd = new MySqlCommand("sp_editora_listar", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            using var rd = cmd.ExecuteReader();
            while (rd.Read())
            {
                list.Add(new SelectListItem { Value = rd.GetInt32("id").ToString(), Text = rd.GetString("nome") });
            }
            return list;
        }

        private List<SelectListItem> CarregarGeneros(MySqlConnection conn)
        {
            var list = new List<SelectListItem>();
            using var cmd = new MySqlCommand("sp_genero_listar", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            using var rd = cmd.ExecuteReader();
            while (rd.Read())
            {
                list.Add(new SelectListItem { Value = rd.GetInt32("id").ToString(), Text = rd.GetString("nome") });
            }
            return list;
        }

        [HttpGet]
        public IActionResult Index()
        {
            var lista = new List<Livros>();
            using var conn = db.GetConnection();
            using var cmd = new MySqlCommand("sp_livro_listar", conn) { CommandType = System.Data.CommandType.StoredProcedure };
            using var rd = cmd.ExecuteReader();
            while (rd.Read())
            {
                lista.Add(new Livros
                {
                    Id = rd.GetInt32("id"),
                    Titulo = rd.GetString("titulo"),
                    AutorId = rd["autor"] == DBNull.Value ? null : (int?)rd.GetInt32("autor"),
                    EditoraId = rd["editora"] == DBNull.Value ? null : (int?)rd.GetInt32("editora"),
                    GeneroId = rd["genero"] == DBNull.Value ? null : (int?)rd.GetInt32("genero"),
                    Autor = rd["autor_nome"] as string,
                    Editora = rd["editora_nome"] as string,
                    Genero = rd["genero_nome"] as string,
                    Ano = rd["ano"] == DBNull.Value ? null : (short?)rd.GetInt16("ano"),
                    Isbn = rd["isbn"] as string,
                    QuantidadeTotal = rd.GetInt32("quantidade_total"),
                    QuantidadeDisponivel = rd.GetInt32("quantidade_disponivel"),
                    CriadoEm = rd.GetDateTime("criado_em")
                });
            }
            return View(lista);
        }

        [HttpGet]
        public IActionResult Criar()
        {
            using var conn = db.GetConnection();
            ViewBag.Autores = CarregarAutores(conn);
            ViewBag.Editoras = CarregarEditoras(conn);
            ViewBag.Generos = CarregarGeneros(conn);
            return View();
        }

        [HttpPost, ValidateAntiForgeryToken]
        public IActionResult Criar(Livros model, IFormFile? capa)
        {
            // Salvar capa (opcional)
            string? relPath = null;
            if (capa != null && capa.Length > 0)
            {
                var ext = Path.GetExtension(capa.FileName);
                // (opcional) validar extensão
                var fileName = $"{Guid.NewGuid()}{ext}";
                var saveDir = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "capas");
                Directory.CreateDirectory(saveDir);
                var absPath = Path.Combine(saveDir, fileName);
                using var fs = new FileStream(absPath, FileMode.Create);
                capa.CopyTo(fs);
                relPath = Path.Combine("capas", fileName).Replace("\\", "/"); // caminho relativo p/ src="~/"
            }

            using var conn2 = db.GetConnection();
            using var cmd = new MySqlCommand("sp_livro_criar", conn2) { CommandType = CommandType.StoredProcedure };

            cmd.Parameters.AddWithValue("p_titulo", model.Titulo);
            cmd.Parameters.AddWithValue("p_autor", model.AutorId ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("p_editora", model.EditoraId ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("p_genero", model.GeneroId ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("p_ano", model.Ano ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("p_isbn", (object)model.Isbn ?? DBNull.Value);
            cmd.Parameters.AddWithValue("p_quantidade", model.QuantidadeTotal);
            cmd.Parameters.AddWithValue("p_capa_arquivo", (object)relPath ?? DBNull.Value);

            cmd.ExecuteNonQuery();

            TempData["ok"] = "Livro cadastrado!";
            return RedirectToAction(nameof(Index));
        }
    }
}