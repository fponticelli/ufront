package ufront.web.mvc;
import haxe.rtti.CType;

/**
 * Contains information that describes a parameter. 
 * @author Andreas Soderlund
 */

class ParameterDescriptor 
{
	/** Gets the name of the parameter. */
	public var name : String;

	/** Gets the type of the parameter. */
	public var type : String;

	/** Gets the RTTI type info of the parameter. */
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