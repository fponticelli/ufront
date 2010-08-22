package ufront.web;

class VirtualUrl extends PartialUrl
{                
	public var isPhysical : Bool; 
	
	public function new()
	{
		super();
		isPhysical = false;
	}

	public static function parse(url : String)
	{               
		var u = new VirtualUrl();
        feed(u, url);
		return u;
	}         
	
	public static function feed(u : VirtualUrl, url : String)
	{        
		PartialUrl.feed(u, url);   
		if(u.segments[0] == "~")
		{
			u.segments.shift();
			if(u.segments.length == 1 && u.segments[0] == "")
				u.segments.pop();
			u.isPhysical = true;
		} else {
			u.isPhysical = false;
		}
	}
}