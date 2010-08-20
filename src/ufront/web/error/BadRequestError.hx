package ufront.web.error;
import haxe.PosInfos;

class BadRequestError extends HttpError
{       
	public function new(?pos : PosInfos)
	{
		super(400, "Bad Request", pos); 
	}
}