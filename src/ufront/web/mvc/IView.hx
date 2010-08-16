package ufront.web.mvc;

interface IView 
{
	public function render(viewContext : ViewContext) : String;
}