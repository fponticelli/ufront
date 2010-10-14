package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class ValueProviderUtil 
{
	// Given "foo.bar[baz].quux", this method will return:
	// - "foo.bar[baz].quux"
	// - "foo.bar[baz]"
	// - "foo.bar"
	// - "foo"
	public static function getPrefixes(key : String) : Array<String>
	{
		var output = [key];
		var length = key.length;
		
		for (i in 0 ... length)
		{
			var char = key.charAt(length - i);
			if (char == "." || char == "[")
				output.push(key.substr(0, length - i));
		}
		
		return output;
	}
}