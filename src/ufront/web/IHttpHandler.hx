package ufront.web;
import ufront.web.HttpContext;

interface IHttpHandler {
	public function processRequest(context : HttpContext, async : hxevents.Async) : Void;
}