package ufront.web;
import ufront.web.HttpRequest;
import ufront.web.UrlDirection;

interface IUrlFilter 
{
  	public function filterIn(url : PartialUrl, request : HttpRequest) : Void;
	public function filterOut(url : VirtualUrl, request : HttpRequest) : Void;
}