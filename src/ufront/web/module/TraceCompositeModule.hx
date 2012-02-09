package ufront.web.module;

import haxe.PosInfos;
using Values;
using Arrays;

class TraceCompositeModule implements ITraceModule
{
	var tracers : Array<ITraceModule>;
	public function new(?tracers : Array<ITraceModule>)
	{
		this.tracers = tracers.alt([]);
	}
	public function add(tracer : ITraceModule)
	{
		tracers.push(tracer);
	}
	public function init(application : HttpApplication) : Void
	{
		tracers.each(function(tracer, _) {
			tracer.init(application);
		});
	}
	public function trace(msg : Dynamic, ?pos : PosInfos) : Void
	{
		tracers.each(function(tracer, _) {
			tracer.trace(msg, pos);
		});
	}
	public function dispose()
	{
		tracers.each(function(tracer, _) {
			tracer.dispose();
		});
		tracers = [];
	}
}