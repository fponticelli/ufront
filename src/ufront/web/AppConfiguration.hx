package ufront.web;
import thx.util.Imports;

/**
 * Used in ufront.web.mvc.MvcApplication
 */
class AppConfiguration
{
	public var modRewrite(default, null) : Bool;
	public var controllerPackages : Array<String>;
	public var attributePackages : Array<String>;
	public var basePath(default, null) : String;
	public var logFile(default, null) : Null<String>;
	public var disableBrowserTrace(default, null) : Bool;

	public function new(?controllerPackage : String, ?modRewrite : Bool, ?basePath = "/", ?logFile : String, ?disableBrowserTrace = false)
	{
		this.modRewrite = modRewrite == null ? false : modRewrite;
		this.basePath = basePath;
		this.controllerPackages = [controllerPackage == null ? "" : controllerPackage];

		Imports.pack("ufront.web.mvc.attributes", true);
		this.attributePackages = ["ufront.web.mvc.attributes"];
		this.logFile = logFile;
		this.disableBrowserTrace = disableBrowserTrace;
	}
}