using Microsoft.AspNetCore.Mvc;

namespace ProjetoBiblioteca.Controllers
{
    public class LivroController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
