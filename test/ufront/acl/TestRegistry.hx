package ufront.acl;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

class TestRegistry
{   
	public function testCRUDString()
	{
		var registry = new Registry();
		registry.add("myrole");
		Assert.isTrue(registry.exists("myrole"));
		Assert.isTrue(registry.remove("myrole"));
		Assert.isFalse(registry.exists("myrole"));
		Assert.isFalse(registry.remove("myrole"));
	}
	
	public function testHierarchy()
	{
		var registry = new Registry();
		registry.add("grand father");
		registry.add("father", "grand father");
		registry.add("son", "father");
		
		Assert.same([], registry.getParents("grand father"));
		Assert.same(["grand father"], registry.getParents("father"));
		Assert.same(["father"], registry.getParents("son"));
		
		Assert.same(["father"], registry.getChildren("grand father"));
		Assert.same(["son"], registry.getChildren("father"));
		Assert.same([], registry.getChildren("son"));
	}
	
	public function testDirectInheritance()
	{
		var registry = new Registry();
		registry.add("grand father");
		registry.add("father", "grand father");
		registry.add("son", "father");
		
		Assert.isTrue(registry.inherits("father", "grand father", true));
		Assert.isFalse(registry.inherits("son", "grand father", true));
	}
	
	public function testIndirectInheritance()
	{
		var registry = new Registry();
		registry.add("grand father");
		registry.add("father", "grand father");
		registry.add("son", "father");
		
		Assert.isTrue(registry.inherits("father", "grand father"));
		Assert.isTrue(registry.inherits("son", "grand father"));
	}
	   
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestRegistry());
	}

	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public function new(){}
}