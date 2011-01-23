package ufront.web.mvc.view;

/**
 * ...
 * @author Franco Ponticelli
 */

class Helper { 
	var fv : String;
	public function new() {
		v = "V";    
		fv = "FV";
	}                    
	public function f() {
		return fv;
	}
	public function _(s : String, ?a : String) {
		if(null != a)
			return (s + a).toUpperCase(); 
		else
			return s.toUpperCase();
	}
	public var v : String;
	
}