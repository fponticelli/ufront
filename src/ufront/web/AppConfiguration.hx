package ufront.web;

/**
 * Used in ufront.web.mvc.MvcApplication
 */
class AppConfiguration
{
	public var modRewrite : Bool;
	public var controllerPackages : Array<String>;
	public var attributePackages : Array<String>;
	
	public function new(?controllerPackage : String, ?modRewrite : Bool)
	{
		this.modRewrite = modRewrite == null ? false : modRewrite;
		
		this.controllerPackages = [controllerPackage == null ? "" : controllerPackage];
		this.attributePackages = ["ufront.web.mvc"];
	}
}