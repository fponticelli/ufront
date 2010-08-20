package ufront.web.error;
import haxe.PosInfos;

class MethodNotAllowedError extends HttpError
{                   
	public function new(?pos : PosInfos)
	{
		super(405, "Method Not Allowed", pos); 
	}
}