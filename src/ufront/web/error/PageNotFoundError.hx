package ufront.web.error;
import haxe.PosInfos;

class PageNotFoundError extends HttpError
{
	public function new(?pos : PosInfos)
	{
		super(404, "Page Not Found", pos); 
	}
}