package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class ValueProviderFactoryCollection //extends Array<ValueProviderFactory>
{
	var internalArray : Array<ValueProviderFactory>;
	
	public function new(?array : Array<ValueProviderFactory>)
	{
		internalArray = new Array<ValueProviderFactory>();
		
		if(array != null)
			for (v in array)
				internalArray.push(v);
	}
	
	public function getValueProvider(controllerContext : ControllerContext) : IValueProvider
	{
		var output = Lambda.map(internalArray, function(v : ValueProviderFactory) {
			return v.getValueProvider(controllerContext);
		});
		
		return new ValueProviderCollection(Lambda.array(output));
	}
}