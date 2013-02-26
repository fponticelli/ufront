package ufront.web.module;

import haxe.PosInfos;
import ufront.web.HttpApplication;
import ufront.web.IHttpModule;

interface ITraceModule extends IHttpModule
{
	public function trace(msg : Dynamic, ?pos : PosInfos) : Void;
}