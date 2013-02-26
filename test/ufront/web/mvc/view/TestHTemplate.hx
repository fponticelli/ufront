package ufront.web.mvc.view;                
import ufront.web.mvc.view.TranslationHelper;
import ufront.web.mvc.view.HTemplateViewEngine;
import htemplate.Template;
import ufront.web.mvc.view.HTemplateView;
import ufront.web.mvc.MockController;
import ufront.web.mvc.ControllerContext;
import ufront.web.mvc.ViewContext;
//import ufront.web.mvc.view.TemplateHelper;
import haxe.ds.StringMap;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

class TestHTemplate
{                                                                                                 
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestHTemplate());
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
	 	var t = getTemplateData("{?set('a','A');}{:get('a')}");
		Assert.equals("A", t.view.render(t.viewContext, new StringMap()));
	}
	
	public function testRegisterSetGetVariable2 ()
	{           
	 	var t = getTemplateData("{?set('a','A');}{:a}");
		Assert.equals("A", t.view.render(t.viewContext, new StringMap()));
	}
	
	public function testRegisterSetGetVariable3()
	{           
	 	var t = getTemplateData("{?a = 'A';}{:get('a')}");
		Assert.equals("A", t.view.render(t.viewContext, new StringMap()));
	}
	
	public function testRegisterSetGetVariable4()
	{           
	 	var t = getTemplateData("{?var a = 'A';}{:a}");
		Assert.equals("A", t.view.render(t.viewContext, new StringMap()));
	}
	
	public function testRegisterSetGetVariable5()
	{           
	 	var t = getTemplateData("{?a = 'A';}{:a}");
		Assert.equals("A", t.view.render(t.viewContext, new StringMap()));
	}

	public function testRegisterSetGetFunction()
	{           
	 	var t = getTemplateData("{?set('a',function(){ return 'A';});}{:get('a')()}");
    	Assert.equals("A", t.view.render(t.viewContext, new StringMap()));
	}

	public function testRegisterHelperVariable()
	{        
	 	var t = getTemplateData("{:h.v}");  
		t.viewContext.viewData.set("h", new Helper());
		Assert.equals("V", t.view.render(t.viewContext, new StringMap()));
	}
	
	public function testRegisterHelperInRoot()
	{        
	 	var t = getTemplateData("{:v}");
		t.viewContext.viewData.set("", new Helper());
		Assert.raises(function() t.view.render(t.viewContext, new StringMap()), Dynamic);
	}
	
	public function testRegisterHelperFunction1()
	{        
	 	var t = getTemplateData("{:h.f()}");  
		t.viewContext.viewData.set("h", new Helper());
		Assert.equals("FV", t.view.render(t.viewContext, new StringMap()));
	} 
	
	public function testRegisterHelperFunction2()
	{        
	 	var t = getTemplateData("{:h._('x')}");  
		t.viewContext.viewData.set("h", new Helper());
		Assert.equals("X", t.view.render(t.viewContext, new StringMap()));
	}
   
    public function testRegisterTranslationHelper()
	{
    	var dic = new thx.translation.DictionaryTranslation();
		dic.addDomain("it", thx.languages.It.language);
		var helper = new TranslationHelper(dic);
		
		var t = getTemplateData("{:_('o')}");
		helper.register(t.viewContext.viewData);
		Assert.equals("o", t.view.render(t.viewContext, new StringMap()));
    }

	public static function getTemplateData(templateString : String = "")
	{
		var controller = new MockController();                                                
		var requestContext = ufront.web.mvc.TestAll.getRequestContext();        
		var controllerContext = new ControllerContext(controller, requestContext);  
		var template = new Template(templateString);
		var view = new HTemplateView(template);  
		var viewEngine = new HTemplateViewEngine(); 
		var viewData = new StringMap();   
		var viewHelpers = [];
		var viewContext = new ViewContext(controllerContext, view, viewEngine, viewData, viewHelpers);     
     	return {
	        view : view,
			viewContext : viewContext
		};
	}
}