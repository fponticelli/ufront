package ufront.web.error;
import haxe.PosInfos;

class UnprocessableEntityError extends HttpError
{                                 
	public function new(?pos : PosInfos)
	{
		super(422, "Unprocessable Entity", pos); 
	}
}