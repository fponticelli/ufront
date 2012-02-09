package ufront.web;
import thx.collection.HashList;

class PartialUrl
{
	public var segments : Array<String>;
	public var query : HashList<{ value : String, encoded : Bool }>;
	public var fragment : String;

	public function new()
	{
		segments = [];
		query    = new HashList();
		fragment = null;
	}

	public static function parse(url : String)
	{
		var u = new PartialUrl();
        feed(u, url);
		return u;
	}

	public static function feed(u : PartialUrl, url : String)
	{
		var parts = url.split("#");
		if(parts.length > 1)
			u.fragment = parts[1];
		parts = parts[0].split("?");
		if(parts.length > 1)
		{
			var pairs = parts[1].split("&");
			for(s in pairs)
			{
				var pair = s.split("=");
				u.query.set(pair[0], { value : pair[1], encoded : true });
			}
		}
		var segments = parts[0].split("/");
		if(segments[0] == "")
		     segments.shift();
		if(segments.length == 1 && segments[0] == "")
			segments.pop();
		u.segments = segments;
	}

	public function queryString()
	{
		var params = [];
		for(param in query.keys())
		{
			var item = query.get(param);
			params.push(param + "=" + (item.encoded ? item.value : StringTools.urlEncode(item.value)));
		}
		return params.join("&");
	}

	public function toString()
	{
		var url = "/" + segments.join("/");
		var qs = queryString();
		if(qs.length > 0)
			url += "?" + qs;
		if(null != fragment)
			url += "#" + fragment;
		return url;
	}
}