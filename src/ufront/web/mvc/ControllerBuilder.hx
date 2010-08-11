package ufront.web.mvc;
import udo.error.NullArgument;

class ControllerBuilder 
{
	public static var current = new ControllerBuilder();
	
	var _packs : List<String>;
	var _controllerFactory : IControllerFactory;
	public function new()
	{
		_packs = new List();
		_controllerFactory = new DefaultControllerFactory(this);
	}
	
	public function getControllerFactory() : IControllerFactory
	{
		return _controllerFactory;
	}
	
	public function setControllerFactory(controllerFactory : IControllerFactory)
	{
		NullArgument.throwIfNull(controllerFactory, "controllerFactory");
		this._controllerFactory = controllerFactory;
	}
	
	public function addPackage(pack : String)
	{
		_packs.add(pack);
	}
	
	public function packages()
	{
		return _packs.iterator();
	}
}