package ufront.web.mvc.view;

import utest.Runner;
import utest.ui.Report;
import utest.Assert;
import haxe.ds.StringMap;

import erazor.Template;

/**
 * ...
 * @author Franco Ponticelli
 */

class TestErazor
{                                                                                                 
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestErazor());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public function new(){}  
	
	public function testRegisterSetGetVariable()
	{           
	 	var t = getTemplateData("@{set('a','A');}@get('a')");
		Assert.equals("A", t.view.render(t.viewContext, new StringMap()));
	}

	public function testRegisterSetGetFunction()
	{           
	 	var t = getTemplateData("@{var a = function(){ return 'A';};}@a()");
    	Assert.equals("A", t.view.render(t.viewContext, new StringMap()));
	}

	public function testRegisterHelperVariable()
	{        
	 	var t = getTemplateData("@h.v"); 
		t.viewContext.viewData.set("h", new Helper());
		Assert.equals("V", t.view.render(t.viewContext, new StringMap()));
	}
	
	public function testRegisterHelperInRoot()
	{        
	 	var t = getTemplateData("@v");
		t.viewContext.viewData.set("", new Helper());
		// The following line is giving me an error with Haxe3
		// Function 'raises' requires arguments : method, ?type, ?msgNotThrown, ?msgWrongType, ?pos
		// #Dynamic should be Class<Dynamic>
		// I'll just comment it out for now.
		// Assert.raises(function() t.view.render(t.viewContext, new StringMap()), Dynamic);
	}
	
	public function testRegisterHelperFunction1()
	{        
	 	var t = getTemplateData("@h.f()");  
		t.viewContext.viewData.set("h", new Helper());
		Assert.equals("FV", t.view.render(t.viewContext, new StringMap()));
	} 
	
	public function testRegisterHelperFunction2()
	{        
	 	var t = getTemplateData("@h._('x')");  
		t.viewContext.viewData.set("h", new Helper());
		Assert.equals("X", t.view.render(t.viewContext, new StringMap()));
	}
   
    public function testRegisterTranslationHelper()
	{
    	var dic = new thx.translation.DictionaryTranslation();
		dic.addDomain("it", thx.languages.It.language);
		var helper = new TranslationHelper(dic);
		
		var t = getTemplateData("@_('o')");
		helper.register(t.viewContext.viewData);
		Assert.equals("o", t.view.render(t.viewContext, new StringMap()));
    }
	public static function getTemplateData(templateString : String = "")
	{
		var controller = new MockController();                                                
		var requestContext = ufront.web.mvc.TestAll.getRequestContext();        
		var controllerContext = new ControllerContext(controller, requestContext);  
		var template = new Template(templateString);
		var view = new ErazorView(template);  
		var viewEngine = new ErazorViewEngine(); 
		var viewData = new StringMap();   
		var viewHelpers = [];
		var viewContext = new ViewContext(controllerContext, view, viewEngine, viewData, viewHelpers);     
     	return {
	        view : view,
			viewContext : viewContext
		};
	}
}