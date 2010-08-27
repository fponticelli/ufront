/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import haxe.io.Bytes;
import thx.collections.HashList;
import thx.neutral.io.FileOutput;
import thx.neutral.io.File;

using StringTools;

class SaveToDirectoryUploadHandler implements IHttpUploadHandler
{
	var _directory : String;
	var _output : FileOutput;
	public var uploadedFilesInfo : HashList<{ size : Int, filename : String }>;
	var _size : Int;
	public function new(directory : String)
	{
		uploadedFilesInfo = new HashList();
		_directory = directory.replace("\\", "/");
		if (!_directory.endsWith("/"))
			_directory += "/";
	}
	public function uploadStart(name : String, filename : String) : Void
	{
		uploadedFilesInfo.set(name, { size : 0, filename : filename } );
		_size = 0;
		_output = File.write(_directory + filename, true);
	}
	
	public function uploadProgress(name : String, bytes : Bytes, pos : Int, len : Int) : Void
	{
		_size += len;
		_output.writeBytes(bytes, pos, len);
	}
	
	public function uploadEnd(name : String) : Void
	{
		_output.close();
		var ob = uploadedFilesInfo.get(name);
		ob.size = _size;
	}
}