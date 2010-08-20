package ufront.web.error;
import haxe.PosInfos;

class InternalServerError extends HttpError
{              
	public function new(?pos : PosInfos)
	{
		super(500, "Internal Server Error", pos); 
	}
}