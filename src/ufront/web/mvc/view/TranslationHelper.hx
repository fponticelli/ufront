package ufront.web.mvc.view;
import hxculture.ITranslation;

class TranslationHelper implements IViewHelper
{                      
	public var translator : ITranslation;
	public function new(translator : ITranslation)
	{                
		this.translator = translator;
	}        

	public function register(data : Hash<Dynamic>)
	{
		data.set("_",  translator._);
		data.set("__", translator.__);
	}
}