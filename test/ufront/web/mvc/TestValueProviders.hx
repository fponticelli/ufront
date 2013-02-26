package ufront.web.mvc;                           

import umock.Mock;
import utest.Assert;
import utest.Runner;
import utest.ui.Report;
import haxe.ds.StringMap;

class TestValueProviders
{      
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestValueProviders());
	}

	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public function new(){}

	public function testValueProviderUtil()
	{
		var output = ValueProviderUtil.getPrefixes("foo.bar[baz].quux");
		
		Assert.same(["foo.bar[baz].quux", "foo.bar[baz]", "foo.bar", "foo"], output);
	}
	
	public function testValueProviderCollection()
	{
		var mockProvider1 = new Mock<IValueProvider>(IValueProvider);
		var mockProvider2 = new Mock<IValueProvider>(IValueProvider);
		
		mockProvider1.setupMethod("getValue").returns(null);
		mockProvider2.setupMethod("getValue").returns(new ValueProviderResult(true, "true"));
		
		var collection = new ValueProviderCollection([mockProvider1.object, mockProvider2.object]);
		var output = collection.getValue("mock");
		
		Assert.isTrue(output.rawValue);
		Assert.equals("true", output.attemptedValue);
	}
	
	public function testHashValueProvider()
	{
		var input = new StringMap<Dynamic>();
		input.set("a", "AAA");
		input.set("test.b", "BBB");
		input.set("c", 123);
		
		var provider = new HashValueProvider(input);

		Assert.isTrue(provider.containsPrefix(""));
		Assert.isTrue(provider.containsPrefix("a"));
		Assert.isTrue(provider.containsPrefix("test"));
		Assert.isTrue(provider.containsPrefix("test.b"));
		Assert.isTrue(provider.containsPrefix("c"));
		
		Assert.equals("AAA", provider.getValue("a").attemptedValue);
		Assert.equals("AAA", provider.getValue("a").rawValue);
		
		Assert.equals("BBB", provider.getValue("test.b").attemptedValue);
		Assert.equals("BBB", provider.getValue("test.b").rawValue);
		
		Assert.equals("123", provider.getValue("c").attemptedValue);
		Assert.equals(123, provider.getValue("c").rawValue);
	}
}