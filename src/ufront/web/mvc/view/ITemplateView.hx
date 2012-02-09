package ufront.web.mvc.view;

import thx.collection.HashList;

/**
 * ...
 * @author Franco Ponticelli
 */

interface ITemplateView<Template> implements IView
{
	public var template(default, null) : Template; 
	public var wrappers(default, null) : HashList<Template>;
// TODO remove
//	public function get(key : String) : Dynamic;
//	public function set(key : String, value : Dynamic) : Void{}
//	public function exists(key : String) : Bool;
//	public function keys() : Iterator<String>;
	public function data() : Hash<Dynamic>;
	public function executeTemplate(template : Template, data : Hash<Dynamic>) : String;
}