package ufront.web.mvc.view;                
import ufront.web.mvc.view.TranslationHelper;
import ufront.web.mvc.view.HTemplateViewEngine;
import htemplate.Template;
import ufront.web.mvc.view.HTemplateView;
import ufront.web.mvc.MockController;
import ufront.web.mvc.ControllerContext;
import ufront.web.mvc.ViewContext;
import ufront.web.mvc.view.HTemplateData;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

class TestHTemplateData
{                                                                                                 
	public static function addTests(runner : Runner)
	{
		// TODO: Tests are broken
		runner.addCase(new TestHTemplateData());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public function new();  
	
	public function testRegisterSetGetVariable()
	{           
	 	var t = getHTemplateData("{?set('a','A');}{:get('a')}");
		t.templateData.register();
		Assert.equals("A", t.view.render(t.viewContext));
	}

	public function testRegisterSetGetFunction()
	{           
//	 	var t = getHTemplateData("{?set('a',function(){ return 'A';});}{:get('a')()}");
		var t = getHTemplateData("{?var f = function(){ return 'A';};}{:f()}");
		t.templateData.register();
    	Assert.equals("A", t.view.render(t.viewContext));
	}

	public function testRegisterHelperVariable()
	{        
	 	var t = getHTemplateData("{:h.v}");  
		t.templateData.registerHelper("h", new Helper());
		Assert.equals("V", t.view.render(t.viewContext));
	}
	
	public function testRegisterHelperInRoot()
	{        
	 	var t = getHTemplateData("{:v}");
		t.templateData.registerHelper("", new Helper());
		Assert.raises(function() t.view.render(t.viewContext), Dynamic);
	}
	
	public function testRegisterHelperFunction1()
	{        
	 	var t = getHTemplateData("{:h.f()}");  
		t.templateData.registerHelper("h", new Helper());
		Assert.equals("FV", t.view.render(t.viewContext));
	} 
	
	public function testRegisterHelperFunction2()
	{        
	 	var t = getHTemplateData("{:h._('x')}");  
		t.templateData.registerHelper("h", new Helper());
		Assert.equals("X", t.view.render(t.viewContext));
	}
   
#if hxculture
    public function testRegisterTranslationHelper()
	{
    	var dic = new hxculture.translation.DictionaryTranslation();
		dic.addDomain("it", hxculture.languages.It.language);
		var helper = new TranslationHelper(dic);
		
		var t = getHTemplateData("{:t._('o')}");  
		t.templateData.registerHelper("t", helper);
		Assert.equals("o", t.view.render(t.viewContext));
    }   
#end

	public static function getHTemplateData(templateString : String = "")
	{
		var controller = new MockController();                                                
		var requestContext = ufront.web.mvc.TestAll.getRequestContext();        
		var controllerContext = new ControllerContext(controller, requestContext);  
		var template = new Template(templateString);
		var view = new HTemplateView(template);  
		var viewEngine = new HTemplateViewEngine(); 
		var viewData = new Hash();   
		var viewHelpers = [];
		var viewContext = new ViewContext(controllerContext, view, viewEngine, viewData, viewHelpers);     
     	return {
			templateData : new HTemplateData(viewContext, view),
	        view : view,
			viewContext : viewContext
		};
	}  
}      

private class Helper { 
	var fv : String;
	public function new() {
		v = "V";    
		fv = "FV";
	}                    
	public function f() {
		return fv;
	}
	public function _(s : String, ?a : String) {
		if(null != a)
			return (s + a).toUpperCase(); 
		else
			return s.toUpperCase();
	}
	public var v : String;
	
}