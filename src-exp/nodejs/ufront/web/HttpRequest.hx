/**
 * ...
 * @author Franco Ponticelli
 */

package nodejs.ufront.web;
import thx.error.NotImplemented;

import haxe.io.Bytes;
import thx.error.Error;      
import ufront.web.IHttpHandler;
import ufront.web.IHttpUploadHandler;
import ufront.web.EmptyUploadHandler;   
import js.Node;
import haxe.ds.StringMap;
using StringTools;

class HttpRequest extends ufront.web.HttpRequest
{
	public static function encodeName(s : String)
	{
		return s.urlEncode().replace('.', '%2E');
	}
	
	var _r : Request;
	var _u : UrlObj;
	public function new(request : Request)
	{
     	_r = request;
		_u = Node.url.parse(_r.url);
	}
	
	override function getQueryString() : String
	{
		return _u.search;
	}
	
	override function getPostString() : String
	{
		return throw new NotImplemented();
	}
/*	
	var _uploadHandler : IHttpUploadHandler;
	var _parsed : Bool;
	function _parseMultipart()
	{
		if (_parsed)
			return;
		_parsed = true;
		var post = getPost();
		var handler = _uploadHandler;
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
	}
 */
	override public function setUploadHandler(handler : IHttpUploadHandler)
	{     
		throw new NotImplemented();
/*		
		if (_parsed)
			throw new Error("multipart has been already parsed");
		_uploadHandler = handler;
		_parseMultipart();  
*/
	}
	
	override function getQuery() : StringMap<String>
	{
		if(null == query) 
			query = getHashFromString(queryString);
		return query;
	}
	
	override function getPost() : StringMap<String>
	{   
		if (httpMethod == "GET")
			return new StringMap();
		if (null == post)
		{
			post = getHashFromString(postString);
//			if (!post.iterator().hasNext())
//				_parseMultipart();
		}        
		return post;
	}
	
	override function getCookies() : StringMap<String>
	{
		return throw new NotImplemented();
	}
	
	override function getHostName() : String
	{
		return _u.hostname;
	}
	
	override function getClientIP() : String
	{
		return throw new NotImplemented();
	}
	
	override function getUri() : String
	{
		return _u.pathname;
	}
	
	override function getClientHeaders() : StringMap<String>
	{                                                 
		return throw new NotImplemented();
	}
	
	override function getHttpMethod() : String
	{
		return _r.method;
	}
	
	override function getScriptDirectory() : String
	{         
		return Node.process.cwd() + "/";      
	}
	
	override function getAuthorization() : { user : String, pass : String }
	{
		return throw new NotImplemented();
	}
	
	static var paramPattern = ~/^([^=]+)=(.*?)$/;
	static function getHashFromString(s : String)
	{
		var hash = new StringMap();   
		if(null == s)
			return hash;
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
}