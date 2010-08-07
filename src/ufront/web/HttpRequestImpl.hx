/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;

import haxe.io.Bytes;
import udo.error.Error;
import udo.neutral.Lib;
using udo.text.UString;
using StringTools;

class HttpRequestImpl extends HttpRequest
{
	public static var instance(getInstance, null) : HttpRequest;
	static function getInstance()
	{
		if (null == instance)
			instance = new HttpRequestImpl();
		return instance;
	}
	
	public static function encodeName(s : String)
	{
		return s.urlEncode().replace('.', '%2E');
	}
	
	public function new()
	{
		_uploadHandler = new EmptyUploadHandler();
	}
	
	override function getQueryString()
	{
		if (null == queryString)
		{
#if php
			queryString = untyped __var__('_SERVER', 'QUERY_STRING');
#elseif neko
			queryString = new String(_get_params_string());
#end
		}
		return queryString;
	}
	
	override function getPostString()
	{
		if (httpMethod == "GET")
			return "";
		if (null == postString)
		{
#if php
			var h = untyped __call__("fopen", "php://input", "r");
			var bsize = 8192;
			var max = 32;
			postString = null;
			var counter = 0;
			while (!untyped __call__("feof", h) && counter < max) {
				postString += untyped __call__("fread", h, bsize);
				counter++;
			}
			untyped __call__("fclose", h);
#elseif neko
			var v = _get_post_data();
			if( v == null )
				postString = null;
			else
				postString =  new String(v);
#end
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
		var post = getPost();
		var handler = _uploadHandler;
#if neko
		var isFile = false, partName = null, firstData = false, lastWasFile = false;
		var onPart = function(pn : String, pf : String)
		{
			if (lastWasFile)
			{
				// close previous upload
				handler.uploadEnd(partName);
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
						handler.uploadProgress(partName, bytes, pos, len);
					}
				} else {
					post.set(partName, bytes.readString(pos, len));
				}
			} else {
				if (isFile)
				{
					if(len > 0)
						handler.uploadProgress(partName, bytes, pos, len);
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
			handler.uploadEnd(partName);
		}
#elseif php
		untyped if (__call__("isset", __php__("$_POST")))
		{
			var na : php.NativeArray = __call__("array");
			__php__("foreach($_POST as $k => $v) { $na[urldecode($k)] = $v; }");
			var h = php.Lib.hashOfAssociativeArray(na);
			for (k in h.keys())
				post.set(k, h.get(k));
		}
		if(!untyped __call__("isset", __php__("$_FILES"))) return;
		var parts : Array<String> = untyped __call__("new _hx_array",__call__("array_keys", __php__("$_FILES")));
		untyped for(part in parts) {
			var info : Dynamic = __php__("$_FILES[$part]");
			var file : String = info['name'];
			var tmp : String = info['tmp_name'];
			
			//var name = __call__("urldecode", part);
			var name = StringTools.urldecode(part);
			post.set(name, file);
			
			if (tmp == '')
				continue;
			
			var err : Int = info['error'];

			if(err > 0) {
				switch(err) {
					case 1: throw new Error("The uploaded file exceeds the max size of {0}", untyped __call__('ini_get', 'upload_max_filesize'));
					case 2: throw new Error("The uploaded file exceeds the max file size directive specified in the HTML form (max is {0})", untyped __call__('ini_get', 'post_max_size'));
					case 3: throw new Error("The uploaded file was only partially uploaded");
					case 4: continue; // No file was uploaded
					case 6: throw new Error("Missing a temporary folder");
					case 7: throw new Error("Failed to write file to disk");
					case 8: throw new Error("File upload stopped by extension");
				}
			}
			handler.uploadStart(name, file);
			var h = __call__("fopen", tmp, "r");
			var bsize = 8192;
			while (!__call__("feof", h)) {
				var buf : String = __call__("fread", h, bsize);
				var size : Int = __call__("strlen", buf);
				handler.uploadProgress(name, Bytes.ofString(buf), 0, size);
			}
			untyped __call__("fclose", h);
			handler.uploadEnd(name);
			untyped __call__("unlink", tmp);
		}
#end
	}

	override public function setUploadHandler(handler : IHttpUploadHandler)
	{
		if (_parsed)
			throw new Error("multipart has been already parsed");
		_uploadHandler = handler;
		_parseMultipart();
	}
	
	override function getQuery()
	{
		if (null == query)
			query = getHashFromString(queryString);
		return query;
	}
	
	override function getPost()
	{
		if (httpMethod == "GET")
			return new Hash();
		if (null == post)
		{
			post = getHashFromString(postString);
			if (!post.iterator().hasNext())
				_parseMultipart();
		}
		return post;
	}
	
	override function getCookies()
	{
		if (null == cookies)
		{
#if php
			cookies = Lib.hashOfAssociativeArray(untyped __php__("$_COOKIE"));
#elseif neko
			var p = _get_cookies();
			cookies = new Hash<String>();
			var k = "";
			while( p != null ) {
				untyped k.__s = p[0];
				cookies.set(k,new String(p[1]));
				p = untyped p[2];
			}
#end
		}
		return cookies;
	}
	
	override function getHostName()
	{
		if (null == hostName)
		{
#if php
			hostName = untyped __php__("$_SERVER['SERVER_NAME']");
#elseif neko
			hostName = new String(_get_host_name());
#end
		}
		return hostName;
	}
	
	override function getClientIP()
	{
		if (null == clientIP)
		{
#if php
			clientIP = untyped __php__("$_SERVER['REMOTE_ADDR']");
#elseif neko
			clientIP = new String(_get_client_ip());
#end
		}
		return clientIP;
	}
	
	override function getUri()
	{
		if (null == uri)
		{
#if php
			var s : String = untyped __php__("$_SERVER['REQUEST_URI']");
			uri = s.split("?")[0];
#elseif neko
			uri = new String(_get_uri());
#end
		}
		return uri;
	}
	
	override function getClientHeaders()
	{
		if (null == clientHeaders)
		{
			clientHeaders = new Hash();
#if php
			var h = Lib.hashOfAssociativeArray(untyped __php__("$_SERVER"));
			for(k in h.keys()) {
				if(k.substr(0,5) == "HTTP_") {
					clientHeaders.set(k.substr(5).toLowerCase().replace("_", "-").ucwords(), h.get(k));
				}
			}
#elseif neko
			var v = _get_client_headers();
			while( v != null ) {
				clientHeaders.set(new String(v[0]), new String(v[1]));
				v = cast v[2];
			}
#end
		}
		return clientHeaders;
	}
	
	override function getHttpMethod()
	{
		if (null == httpMethod)
		{
#if php
			untyped if(__php__("isset($_SERVER['REQUEST_METHOD'])"))
				httpMethod =  __php__("$_SERVER['REQUEST_METHOD']");
#elseif neko
			httpMethod = new String(_get_http_method());
#end
			if (null == httpMethod) httpMethod = "";
		}
		return httpMethod;
	}
	
	override function getScriptDirectory()
	{
		if (null == scriptDirectory)
		{
#if php
			scriptDirectory =  untyped __php__('dirname($_SERVER["SCRIPT_FILENAME"])') + "/";
#else
			scriptDirectory = new String(_get_cwd());
#end
		}
		return scriptDirectory;
	}
	
	override function getAuthorization()
	{
		if (null == authorization)
		{
			authorization = { user : null, pass : null };
#if php
			untyped if(__php__("isset($_SERVER['PHP_AUTH_USER'])"))
			{
				authorization.user = __php__("$_SERVER['PHP_AUTH_USER']");
				authorization.pass = __php__("$_SERVER['PHP_AUTH_PW']");
			}
#else
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
#end
		}
		return authorization;
	}
	
	static var paramPattern = ~/^([^=]+)=(.*?)$/;
	static function getHashFromString(s : String)
	{
		var hash = new Hash();
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
	
#if php
	static function getHashFrom(a : php.NativeArray)
	{
		if(untyped __call__("get_magic_quotes_gpc"))
			untyped __php__("reset($a); while(list($k, $v) = each($a)) $a[$k] = stripslashes((string)$v)");
		return Lib.hashOfAssociativeArray(a);
	}
#elseif neko
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
	static function __init__()
	{
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
#end
}