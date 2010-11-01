package ufront.web.mvc;

import hxevents.Dispatcher;

interface IResultFilter
{
	public var onResultExecuted(default, null) : Dispatcher<ResultExecutedContext>;
	public var onResultExecuting(default, null) : Dispatcher<ResultExecutingContext>;
}