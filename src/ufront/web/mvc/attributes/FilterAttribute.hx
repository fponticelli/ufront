package ufront.web.mvc.attributes;
import thx.error.Error;

/** Represents the base class for action and result filter attributes. */
class FilterAttribute
{
	/** Gets or sets the order in which the action filters are executed. */
	public var order : Int;	
	public function new() { order = -1; }
}