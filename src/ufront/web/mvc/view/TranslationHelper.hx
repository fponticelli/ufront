package ufront.web.mvc.view;
import thx.translation.ITranslation;
import ufront.web.mvc.IViewHelper;
import haxe.ds.StringMap;

class TranslationHelper implements IViewHelper
{
	public var translator : ITranslation;
	public function new(translator : ITranslation)
	{
		this.translator = translator;
	}

	public function register(data : StringMap<Dynamic>)
	{
		//doesnt' compile!
		//data.set("_",  translator._);
		//data.set("__", translator.__);
	}
}