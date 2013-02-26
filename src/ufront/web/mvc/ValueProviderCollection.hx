package ufront.web.mvc;
import ufront.web.mvc.ValueProviderResult;

/**
 * ...
 * @author Andreas Soderlund
 */

class ValueProviderCollection extends List<IValueProvider> implements IValueProvider
{
	public function new(?list : Array<IValueProvider>)
	{
		super();
		
		if (list != null)
		{
			for(v in list)
				this.add(v);
		}
	}
	
	public function containsPrefix(prefix : String) : Bool 
	{
		for (v in this)
			if (v.containsPrefix(prefix))
				return true;
				
		return false;
	}
	
	public function getValue(key : String) : ValueProviderResult 
	{
		for (v in this)
		{   
			var output = v.getValue(key);
			if (output != null) return output;
		}
		
		return null;
	}	
}