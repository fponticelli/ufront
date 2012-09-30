/**
 * ...
 * @author Andreas Söderlund
 * @author Andrea Parodi
 */

package php.ufront.web;
import ufront.web.IHttpSessionState;

import thx.sys.Lib;
import sys.FileSystem;

import sys.io.File;
import haxe.BaseCode;
import haxe.Unserializer;
import haxe.Serializer;

/** @todo compare with neko implementation */
class FileSession implements IHttpSessionState
{

	private function add(name:String,value:String ,expire:Int){
		var result:Bool=false;

		untyped __php__("
			if ($expire!=0)
				$expire=time()+$expire;
			
			$result=( 1==setcookie ( $name , $value,$expire ) );
		");
		if (!result)
			throw "Cookie could not be set. Output already started.";
	}




	private function getCookie(){
		var result=null;
		 untyped __php__("
			if (array_key_exists('ufront', $_COOKIE)) 
				$result=$_COOKIE['ufront'];
		");
		 return result;
	}
	private function getId(){
		return Std.string(untyped __php__("uniqid()"));
	}

	private var savePath : String;

	private var content: Hash<Dynamic>;
	
	private var sessionId: String;

	private var sessionStoragePath: String;

	//added sessionId as parameter to allow authentication not
	//base on session (not sure it's the best way to do this)
	public function new(savePath : String,?sessionId:String=null)
	{
		this.savePath=savePath;
		this.content=new Hash<Dynamic>();
		this.sessionId=sessionId;
		
		
		setupSessionId();
		
		if (!FileSystem.exists(savePath))
			FileSystem.createDirectory(savePath);


		if (!FileSystem.exists(sessionStoragePath))
			FileSystem.createDirectory(sessionStoragePath);

		
           
	}


	private function setupSessionId(){
		if (this.sessionId==null){
			var cookie=getCookie();
			if (cookie==null){
				this.sessionId=getId();
				add("ufront",this.sessionId,0);
				
			} else {

				/** @todo sanitize coockie id to avoid directory escapes */
				/** @todo rebuild a new coockie id on every request and rename storage folder? */ 
				var id=cookie;	
				if (!FileSystem.exists(this.savePath+"/"+id)){
					//this code is to prevent session fixation. create a new cookie
					//because session storage does not exists
					id=getId();
					add("ufront",id,0);	
				}



				this.sessionId=id;
			}
		} 

		/** @todo check for existence of directory for provided session ids	*/ 
		/** @todo MD5 the sessionId to avoid knowledge of the cookie looking at filesystem */ 
		this.sessionStoragePath=this.savePath+"/"+this.sessionId;

		// var writer=File.append("c:\\log.txt",false);
		// writer.writeString("Login "+this.sessionStoragePath+"\n");
		// writer.close();	
	}
	
	public function setLifeTime(lifetime:Int)
	{

		add("ufront",this.sessionId,lifetime);	
		
	 	
	}

	public function dispose() : Void
	{
		
	}

	public function clear() : Void
	{
		for (file in FileSystem.readDirectory(sessionStoragePath))
			FileSystem.deleteFile(sessionStoragePath+"/"+file);	
		
		FileSystem.deleteDirectory(sessionStoragePath);	
		
	}



	public function get(name : String) : Dynamic
	{
		return Unserializer.run(File.getContent(getVarPath(name)));
	}

	/** @todo sanitize name to avoid directory escapes*/ 
	private function getVarPath(name : String){
		return sessionStoragePath+"/"+name;
	}

	public function set(name : String, value : Dynamic) : Void
	{
		File.saveContent(getVarPath(name),Serializer.run(value));	
	}
	
	public function exists(name : String) : Bool
	{
		return FileSystem.exists(getVarPath(name));	
	}

	public function remove(name : String) : Void
	{
	 	FileSystem.deleteFile(getVarPath(name));		
	}
	
	public function id() : String
	{
		return this.sessionId;
	}
}