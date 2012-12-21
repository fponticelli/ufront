package ufront.web.mvc.view;

import utest.Runner;
import utest.ui.Report;
import utest.Assert;
import ufront.web.mvc.view.HtmlHelper;
import ufront.web.mvc.view.UrlHelper;

class TestHtmlHelper{
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestHtmlHelper());
	}

	private var helper : HtmlHelperInst;

	public function new(){
		helper =new HtmlHelperInst(new UrlHelperInst(null));
	}  
	
	private function assertAttributeEncodedAs(attribute,expected){
		Assert.equals(expected,helper.attributeEncode(attribute));
	}


	public function test_attributeEncode_NullEncodedAsEmptyString()
	{           
	 	assertAttributeEncodedAs(null, "");
	}

	public function test_attributeEncode_WithoutSpecialCharsEncodedUnchanged()
	{           
	 	assertAttributeEncodedAs("ciao", "ciao");
	}

	public function test_attributeEncode_QuotesEncoded()
	{           
	 	assertAttributeEncodedAs('"ciao"', "&quote;ciao&quote;");
	}
	public function test_attributeEncode_AposEncoded()
	{           
	 	assertAttributeEncodedAs("'ciao'", "&apos;ciao&apos;");
	}
	public function test_attributeEncode_AposQuoteEncoded()
	{           
	 	assertAttributeEncodedAs("'ciao'\"", "&apos;ciao&apos;&quote;");
	}
	public function test_attributeEncode_AmpEncoded()
	{           
	 	assertAttributeEncodedAs("'ciao&apos", "&apos;ciao&amp;apos");
	}

	public function test_attributeEncode_LtEncoded()
	{           
	 	assertAttributeEncodedAs("<ciao", "&lt;ciao");
	}

}