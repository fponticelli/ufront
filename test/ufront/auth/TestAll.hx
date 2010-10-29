package ufront.auth;

import utest.Runner;
import utest.ui.Report;

import ufront.auth.storage.SessionStorage;
import ufront.auth.storage.MemoryStorage; 
import ufront.auth.Auth;
import ufront.auth.AuthResult;
import ufront.auth.adapter.Digest;

class TestAll
{
	public static function addTests(runner : Runner)
	{
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
}