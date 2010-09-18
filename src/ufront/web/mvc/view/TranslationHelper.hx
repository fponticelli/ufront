package ufront.web.mvc.view;
import hxculture.ITranslation;

class TranslationHelper
{                      
	var _translator : ITranslation;
	public function new(translator : ITranslation)
	{                
		this._translator = translator;
	}        
	
 	public function _(id : String, ?domain : String) 
	{                 
		return _translator._(id, domain);
	}                                    
	
	public function __(ids : String, idp : String, quantifier : Int, ?domain : String) 
	{     
		return _translator.__(ids, idp, quantifier, domain);
	}
}