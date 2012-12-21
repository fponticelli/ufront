package ufront.web.mvc.view;
import thx.translation.ITranslation;
import ufront.web.mvc.IViewHelper;

class TranslationHelper implements IViewHelper
{
	public var translator : ITranslation;
	public function new(translator : ITranslation)
	{
		this.translator = translator;
	}

	public function register(data : Hash<Dynamic>)
	{
		//doesnt' compile!
		//data.set("_",  translator._);
		//data.set("__", translator.__);
	}
}