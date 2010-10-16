package ufront.web.mvc;
import haxe.rtti.CType;

/**
 * ...
 * @author Andreas Soderlund
 */

class ParameterDescriptor 
{
	public var name : String;
	public var type : String;
	public var ctype : CType;
	
	public var defaultValue : Dynamic;

	public function new(name : String, type : String, ?ctype : CType)
	{
		this.name = name;
		this.type = type;
		this.ctype = ctype;
	}
	
	public function toString()
	{
		return "ParameterDescriptor { name : " + name + ", type : " + type + ", ctype : " + ctype + "}";
	}
	// TODO: Attributes through metadata
}