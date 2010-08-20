package ufront.web;
import ufront.web.HttpRequest;
import ufront.web.UrlDirection;

interface IUrlFilter 
{
   public function filter(url : String, request : HttpRequest, direction : UrlDirection) : String;
}