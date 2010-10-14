package ufront.web;

/**
 * Used in ufront.web.mvc.MvcApplication for example, to set url filters.
 */
class ServerConfiguration
{
	public var modRewrite : Bool;
	
	public function new()
	{
		modRewrite = false;
	}
}