/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;

interface IHttpModule
{
	public function init(application : HttpApplication) : Void;
	public function dispose() : Void;
}