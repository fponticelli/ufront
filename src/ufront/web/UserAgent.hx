package ufront.web;

/**
 * ...
 * @author Franco Ponticelli
 */

class UserAgent 
{
	// info from: http://www.quirksmode.org/js/detect.html
	static var dataBrowser:Array<{
			subString:String,
			?versionSearch:String,
			identity:String
		}> = [ 
		{
			subString: "Chrome",
			identity: "Chrome"
		},
		{
			subString: "OmniWeb",
			versionSearch: "OmniWeb/",
			identity: "OmniWeb"
		},
		{
			subString: "Apple",
			identity: "Safari",
			versionSearch: "Version"
		},
		{
			subString: "Opera",
			versionSearch: "Version",
			identity: "Opera"
		},

		{
			subString: "iCab",
			identity: "iCab"
		},
		{
			subString: "KDE",
			identity: "Konqueror"
		},
		{
			subString: "Firefox",
			identity: "Firefox"
		},
		{
			subString: "Camino",
			identity: "Camino"
		},
		{		// for newer Netscapes (6+)
			subString: "Netscape",
			identity: "Netscape"
		},
		{
			subString: "MSIE",
			identity: "Explorer",
			versionSearch: "MSIE"
		},
		{
			subString: "Gecko",
			identity: "Mozilla",
			versionSearch: "rv"
		},
		{
			subString: "Mozilla",
			identity: "Netscape",
			versionSearch: "Mozilla"
		}
	];

	static var dataOS = [
		{
			subString: "Win",
			identity: "Windows"
		},
		{
			subString: "Mac",
			identity: "Mac"
		},
		{
			subString: "iPhone",
			identity: "iPhone/iPod"
	    },
		{
			subString: "Linux",
			identity: "Linux"
		}
	];

	public var browser(default, null) : String;
	public var version(default, null) : String;
	public var majorVersion(default, null) : Int;
	public var minorVersion(default, null) : Int;
	public var platform(default, null) : String;
	
	public function new(browser : String, version : String, majorVersion : Int, minorVersion : Int, platform : String) 
	{
		this.browser = browser;
		this.version = version;
		this.majorVersion = majorVersion;
		this.minorVersion = minorVersion;
		this.platform = platform;
	}
	
	public function toString()
	{
		return browser + " v." + majorVersion + "." + minorVersion + " (" + version + ") on " + platform;
	}
	
	public static function fromString(s : String)
	{
		var ua = new UserAgent("unknown", "", 0, 0, "unknown");
		
		var info = searchString(dataBrowser, s);
		if (null != info)
		{
			ua.browser = info.app;
			var version = extractVersion(info.versionString, s);
			if (null != version)
			{
				ua.version = version.version;
				ua.majorVersion = version.majorVersion;
				ua.minorVersion = version.minorVersion;
			}
		}
		var info = searchString(dataOS, s);
		if (null != info)
		{
			ua.platform = info.app;
		}
		return ua;
	}
	
	static function extractVersion(searchString : String, s : String)
	{
		var index = s.indexOf(searchString);
		if (index < 0)
			return null;
		var re = ~/(\d+)\.(\d+)[^ ();]*/;
		if (!re.match(s.substr(index + searchString.length + 1)))
			return null;
		return {
			version : re.matched(0),
			majorVersion : Std.parseInt(re.matched(1)),
			minorVersion : Std.parseInt(re.matched(2))
		};
	}
	
	static function searchString(data : Array<Dynamic>, s : String)
	{
		for (d in data)
		{
			if (s.indexOf(d.subString) >= 0)
			{
				return {
					app           : d.identity,
					versionString : null == d.versionSearch ? d.identity : d.versionSearch
				}
			}
		}
		return null;
	}
}