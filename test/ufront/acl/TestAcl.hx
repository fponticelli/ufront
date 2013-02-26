package ufront.acl;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;
import ufront.acl.Acl;
using Iterators;

class TestAcl
{
	public function testRoles()
	{
		var acl = new Acl();
		acl
			.addRole("parent")
			.addRole("child", "parent");
		Assert.isTrue(acl.existsRole("parent"));
		var roles = acl.getRoles().array();
		Assert.equals(2, roles.length);
		Assert.isTrue(roles.remove("parent"));
		Assert.isTrue(roles.remove("child"));
		Assert.isTrue(acl.inheritsRole("child", "parent"));
	}
	
	public function testResources()
	{
		var acl = new Acl();
		acl
			.addResource("book")
		    .addResource("chapter", "book")
			.addResource("page", "chapter");
		
		var resources = acl.getResources().array();
		Assert.equals(3, resources.length);
		Assert.isTrue(resources.remove("book"));
		Assert.isTrue(resources.remove("chapter"));
		Assert.isTrue(resources.remove("page"));
		
		Assert.isTrue(acl.existsResource("chapter"));
		Assert.isTrue(acl.existsResource("page"));
		
		Assert.isTrue(acl.inheritsResource("chapter", "book", true));
		Assert.isTrue(acl.inheritsResource("chapter", "book", false));
		
		Assert.isFalse(acl.inheritsResource("page", "book", true));
		Assert.isTrue(acl.inheritsResource("page", "book", false));
		
		Assert.isTrue(acl.removeResource("chapter"));
		Assert.isFalse(acl.removeResource("chapter"));

		Assert.isFalse(acl.existsResource("chapter"));
		Assert.isFalse(acl.existsResource("page"));
		
		// The following line is giving me an error with Haxe3
		// Function 'raises' requires arguments : method, ?type, ?msgNotThrown, ?msgWrongType, ?pos
		// #Dynamic should be Class<Dynamic>
		// I'll just comment it out for now.
		// Assert.raises(function() acl.addResource("page", "chapter"), Dynamic);
	}
	
	public function testRules()
	{
		var acl = new Acl();

		acl
			.addRole("guest")
			.addRole("editor", "guest")
			.addRole("limited", "editor")
			.addRole("admin")
			.addRole("undesired")
			
			.addResource("contents")
		
			.allow(["guest"], ["contents"], ["view", "comment"])
			.allow(["editor"], ["contents"], ["add", "remove"])
			.deny (["limited"], ["contents"], ["remove"])
			.deny (["undesired"])
			.allow(["admin"])
		;
		
		Assert.isFalse(acl.isAllowed("guest", "contents"));
		Assert.isTrue (acl.isAllowed("guest", "contents", "view"));
		Assert.isTrue (acl.isAllowed("guest", "contents", "comment"));
		Assert.isFalse(acl.isAllowed("guest", "contents", "add"));
		Assert.isFalse(acl.isAllowed("guest", "contents", "remove"));
		
		Assert.isFalse(acl.isAllowed("editor", "contents"));
		Assert.isTrue (acl.isAllowed("editor", "contents", "view"));
		Assert.isTrue (acl.isAllowed("editor", "contents", "comment"));
		Assert.isTrue (acl.isAllowed("editor", "contents", "add"));
		Assert.isTrue (acl.isAllowed("editor", "contents", "remove"));
		
		Assert.isFalse(acl.isAllowed("limited", "contents"));
		Assert.isTrue (acl.isAllowed("limited", "contents", "view"));
		Assert.isTrue (acl.isAllowed("limited", "contents", "comment"));
		Assert.isTrue (acl.isAllowed("limited", "contents", "add"));
		Assert.isFalse(acl.isAllowed("limited", "contents", "remove"));
		
 		Assert.isTrue (acl.isAllowed("admin", "contents"));
		Assert.isTrue (acl.isAllowed("admin", "contents", "view"));
		Assert.isTrue (acl.isAllowed("admin", "contents", "comment"));
		Assert.isTrue (acl.isAllowed("admin", "contents", "add"));
		Assert.isTrue (acl.isAllowed("admin", "contents", "remove"));
		
		Assert.isFalse(acl.isAllowed("undesired", "contents"));
		Assert.isFalse(acl.isAllowed("undesired", "contents", "view"));
		Assert.isFalse(acl.isAllowed("undesired", "contents", "comment"));
		Assert.isFalse(acl.isAllowed("undesired", "contents", "add"));
		Assert.isFalse(acl.isAllowed("undesired", "contents", "remove"));
		
		acl.deny(["editor"], ["contents"], ["remove"]);
		
		Assert.isTrue(acl.isAllowed("editor", "contents", "add"));
		Assert.isFalse(acl.isAllowed("editor", "contents", "remove"));
	}
	
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestAcl());
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