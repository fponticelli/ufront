package ufront.web.error;
import haxe.PosInfos;
import thx.error.Error;

class HttpError extends Error
{
	public var code : Int;
	public function new(code : Int, message : String, ?params : Array<Dynamic>, ?param : Dynamic, ?pos : PosInfos)
	{
		super("Error " + code + ": " + message, params, param, pos); 
		this.code = code;
	}
}