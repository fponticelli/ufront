package ufront.web.error;
import haxe.PosInfos;

class UnauthorizedError extends HttpError
{             
	public function new(?pos : PosInfos)
	{
		super(401, "Unauthorized Access", pos); 
	}
}