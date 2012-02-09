package ufront.web;
import thx.util.Imports;

/**
 * Used in ufront.web.mvc.MvcApplication
 */
class AppConfiguration
{
	public var modRewrite : Bool;
	public var controllerPackages : Array<String>;
	public var attributePackages : Array<String>;
	public var basePath : String;
	public var logFile : Null<String>;

	public function new(?controllerPackage : String, ?modRewrite : Bool, ?basePath = "/", ?logFile : String)
	{
		this.modRewrite = modRewrite == null ? false : modRewrite;
		this.basePath = basePath;
		this.controllerPackages = [controllerPackage == null ? "" : controllerPackage];

		Imports.pack("ufront.web.mvc.attributes", true);
		this.attributePackages = ["ufront.web.mvc.attributes"];
		this.logFile = logFile;
	}
}