package ufront.web;
import ufront.web.UrlDirection;

interface IUrlFilter 
{
   public function filter(url : String, direction : UrlDirection) : String;
}