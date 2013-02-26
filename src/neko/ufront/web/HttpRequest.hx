package neko.ufront.web;

/**
 * ...
 * @author Franco Ponticelli
 */

import haxe.io.Bytes;
import thx.error.Error;
import thx.sys.Lib;        
import ufront.web.IHttpHandler;
import ufront.web.IHttpUploadHandler;
import ufront.web.EmptyUploadHandler;
import ufront.web.UserAgent;
import haxe.ds.StringMap;
using Strings;
using StringTools;

class HttpRequest extends ufront.web.HttpRequest
{
	public static function encodeName(s : String)
	{
		return s.urlEncode().replace('.', '%2E');
	}
	
	public function new()
	{
		_uploadHandler = new EmptyUploadHandler();
		_init();
	}
	
	override function get_queryString()
	{
		if (null == queryString)
			queryString = new String(_get_params_string());
		return queryString;
	}
	
	override function get_postString()
	{
		if (httpMethod == "GET")
			return "";
		if (null == postString)
		{
			var v = _get_post_data();
			if( v == null )
				postString = null;
			else
				postString =  new String(v);
			if (null == postString)
				postString = "";
		}
		return postString;
	}
	
	var _uploadHandler : IHttpUploadHandler;
	var _parsed : Bool;
	function _parseMultipart()
	{
		if (_parsed)
			return;
		_parsed = true;
		var post = get_post();
		var handler = _uploadHandler;
		var isFile = false, partName = null, firstData = false, lastWasFile = false;
		var onPart = function(pn : String, pf : String)
		{
			if (lastWasFile)
			{
				// close previous upload
				handler.uploadEnd();
			}
			isFile = null != pf && "" != pf;
			partName = pn.urlDecode();
			if (isFile)
			{
				post.set(partName, pf);
				handler.uploadStart(partName, pf);
				firstData = true;
				lastWasFile = true;
			} else {
				lastWasFile = false;
			}
		};
		var onData = function(bytes : Bytes, pos : Int, len : Int)
		{
			if (firstData)
			{
				firstData = false;
				if (isFile)
				{
					if (len > 0)
					{
						handler.uploadProgress(bytes, pos, len);
					}
				} else {
					post.set(partName, bytes.readString(pos, len));
				}
			} else {
				if (isFile)
				{
					if(len > 0)
						handler.uploadProgress(bytes, pos, len);
				} else {
					post.set(partName, post.get(partName) + bytes.readString(pos, len));
				}
			}
		};
		_parse_multipart(
			function(p,f) { onPart(new String(p),if( f == null ) null else new String(f)); },
			function(buf,pos,len) { onData(untyped new haxe.io.Bytes(__dollar__ssize(buf),buf),pos,len); }
		);
		if (isFile)
		{
			// close last upload
			handler.uploadEnd();
		}
	}

	override public function setUploadHandler(handler : IHttpUploadHandler)
	{
		if (_parsed)
			throw new Error("multipart has been already parsed");
		_uploadHandler = handler;
		_parseMultipart();
	}
	
	override function get_query()
	{
		if (null == query)
			query = getHashFromString(queryString);
		return query;
	}
	
	override function get_userAgent()
	{
		if (null == userAgent)
			userAgent = UserAgent.fromString(clientHeaders.get("User-Agent"));
		return userAgent;
	}
	
	override function get_post()
	{
		if (httpMethod == "GET")
			return new StringMap();
		if (null == post)
		{
			post = getHashFromString(postString);
			if (!post.iterator().hasNext())
				_parseMultipart();
		}
		return post;
	}
	
	override function get_cookies()
	{
		if (null == cookies)
		{
			var p = _get_cookies();
			cookies = new StringMap<String>();
			var k = "";
			while( p != null ) {
				untyped k.__s = p[0];
				cookies.set(k,new String(p[1]));
				p = untyped p[2];
			}
		}
		return cookies;
	}
	
	override function get_hostName()
	{
		if (null == hostName)
			hostName = new String(_get_host_name());
		return hostName;
	}
	
	override function get_clientIP()
	{
		if (null == clientIP)
			clientIP = new String(_get_client_ip());
		return clientIP;
	}
	
	/**
	 *  @todo the page processor removal is quite hackish
	 */
	override function get_uri()
	{
		if (null == uri) {
			uri = new String(_get_uri()); 
			if(uri.endsWith(".n")) {
				var p = uri.split("/");
				p.pop();
				uri = p.join("/") + "/";
			}
		}
		return uri;
	}
	
	override function get_clientHeaders()
	{
		if (null == clientHeaders)
		{
			clientHeaders = new StringMap();
			var v = _get_client_headers();
			while( v != null ) {
				clientHeaders.set(new String(v[0]), new String(v[1]));
				v = cast v[2];
			}
		}
		return clientHeaders;
	}
	
	override function get_httpMethod()
	{
		if (null == httpMethod)
		{
			httpMethod = new String(_get_http_method());
			if (null == httpMethod) httpMethod = "";
		}
		return httpMethod;
	}
	
	override function get_scriptDirectory()
	{
		if (null == scriptDirectory)
		{
			scriptDirectory = new String(_get_cwd());
		}
		return scriptDirectory;
	}
	
	override function get_authorization()
	{
		if (null == authorization)
		{
			authorization = { user : null, pass : null };
			var h = clientHeaders.get("Authorization");
			var reg = ~/^Basic ([^=]+)=*$/;
			if( h != null && reg.match(h) ){
				var val = reg.matched(1);
				untyped val = new String(_base_decode(val.__s,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".__s));
				var a = val.split(":");
				if( a.length != 2 ){
					throw new Error("Unable to decode authorization.");
				}
				authorization.user = a[0];
				authorization.pass = a[1];
			}
		}
		return authorization;
	}
	
	static var paramPattern = ~/^([^=]+)=(.*?)$/;
	static function getHashFromString(s : String)
	{
		var hash = new StringMap();
		for (part in s.split("&"))
		{
			if (!paramPattern.match(part))
				continue;
			hash.set(
				StringTools.urlDecode(paramPattern.matched(1)),
				StringTools.urlDecode(paramPattern.matched(2)));
		}
		return hash;
	}
	
	static var _get_params_string : Dynamic;
	static var _get_post_data : Dynamic;
	static var _get_cookies : Dynamic;
	static var _get_host_name : Dynamic;
	static var _get_client_ip : Dynamic;
	static var _get_uri : Dynamic;
	static var _get_client_headers : Dynamic;
	static var _get_cwd : Dynamic;
	static var _get_http_method : Dynamic;
	static var _parse_multipart : Dynamic;
	static var _inited = false;
	static function _init()
	{                  
		if(_inited)
			return;
		_inited = true;
		var get_env = Lib.load("std", "get_env", 1);
		var ver = untyped get_env("MOD_NEKO".__s);
		var lib = "mod_neko" + if ( ver == untyped "1".__s ) "" else ver;
		_get_params_string = Lib.load(lib, "get_params_string", 0);
		_get_post_data = Lib.load(lib, "get_post_data", 0);
		_get_cookies = Lib.load(lib, "get_cookies", 0);
		_get_host_name = Lib.load(lib, "get_host_name", 0);
		_get_client_ip = Lib.load(lib, "get_client_ip", 0);
		_get_uri = Lib.load(lib, "get_uri", 0);
		_get_client_headers = Lib.loadLazy(lib, "get_client_headers", 0);
		_get_cwd = Lib.load(lib, "cgi_get_cwd", 0);
		_get_http_method = Lib.loadLazy(lib,"get_http_method",0);
		_parse_multipart = Lib.loadLazy(lib, "parse_multipart_data", 2);
	}
}