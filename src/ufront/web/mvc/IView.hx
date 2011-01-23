package ufront.web.mvc;

interface IView 
{
	// TODO outputData should be removed if not needed anymore after HtmlViewResult has been moved to filter
	public function render(viewContext : ViewContext, outputData : Hash<Dynamic>) : String;
}