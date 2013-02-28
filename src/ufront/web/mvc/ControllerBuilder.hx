package ufront.web.mvc;

import thx.error.NullArgument;

/**  Represents a class that is responsible for dynamically building a controller. */
class ControllerBuilder
{
	public static var current = new ControllerBuilder();

	public var packages(default, null) : List<String>;
	public var attributes(default, null) : List<String>;

	/** Gets or sets the associated controller factory. */
	public var controllerFactory(get, set) : IControllerFactory;
	var _controllerFactory : IControllerFactory;

	public function new()
	{
		packages = new List();
		attributes = new List();
	}

	public function get_controllerFactory() : IControllerFactory
	{
		if (_controllerFactory == null)
			_controllerFactory = new DefaultControllerFactory(this, DependencyResolver.current);

		return _controllerFactory;
	}

	public function set_controllerFactory(controllerFactory : IControllerFactory)
	{
		NullArgument.throwIfNull(controllerFactory);
		this._controllerFactory = controllerFactory;

		return controllerFactory;
	}
}