package ufront.web.mvc;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Expr;
#else
import thx.error.NullArgument;
#end

class ControllerBuilder 
{
#if !macro
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
	
	public function addPackageToList(pack : String)
	{
		_packs.add(pack);
	}
	
	public function packages()
	{
		return _packs.iterator();
	}
#end
	@:macro public static function addPackage(pack : Expr)
	{
		var alternative = {
			expr : ECall( {
				expr : EField({ 
					expr : EField({
						expr : EType({
						   expr : EField({
							   expr : EField({
								   expr : EConst(CIdent("ufront")),
								   pos : pack.pos 
							   },"web"), 
							   pos : pack.pos
						   },"mvc"),
						   pos : pack.pos },"ControllerBuilder"),
					   pos : pack.pos }, "current"),
					pos : pack.pos },"addPackageToList"),
			   pos : pack.pos },
			   [pack]),
		   pos : pack.pos
		};
		
		switch(pack.expr)
		{
			case EConst(c):
				switch(c)
				{
					case CString(s):
						Compiler.include(s, false);
					default:
						//
				}
			default:
				//
		}
		return alternative;
	}
}