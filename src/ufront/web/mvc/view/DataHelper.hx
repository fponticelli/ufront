package ufront.web.mvc.view;
import udo.error.Error;
import udo.error.NullArgument; 
import udo.type.UType;

class DataHelper implements IViewHelper, implements Dynamic
{     
	var _fields : Array<String>;
	public function new(data : Dynamic)
	{   
		NullArgument.throwIfNull(data, "data");
		if(!UType.isAnonymous(data))
			throw new Error("data should be an anonymous object");
		_fields = Reflect.fields(data);
		for(field in _fields)
			Reflect.setField(this, field, Reflect.field(data, field));
	}
	public function getHelperFieldNames() 
	{
		return _fields;
	}
}