/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import haxe.io.Bytes;
import thx.collection.HashList;
import thx.sys.io.FileOutput;
import thx.sys.io.File;

using StringTools;

class SaveToDirectoryUploadHandler implements IHttpUploadHandler
{
	var _directory : String;
	var _output : FileOutput;
	public var uploadedFilesInfo : HashList<UploadInfo>;
	var _current : UploadInfo;
	public function new(directory : String)
	{
		uploadedFilesInfo = new HashList();
		_directory = directory.replace("\\", "/");
		if (!_directory.endsWith("/"))
			_directory += "/";
	}
	public function uploadStart(name : String, filename : String) : Void
	{
		_current = { size : 0, filename : filename };
		uploadedFilesInfo.set(name, _current);
		_output = File.write(_directory + filename, true);
	}

	public function uploadProgress(bytes : Bytes, pos : Int, len : Int) : Void
	{
		_current.size += len;
		_output.writeBytes(bytes, pos, len);
	}

	public function uploadEnd() : Void
	{
		_output.close();
		_current = null;
	}
}

typedef UploadInfo = {
	size : Int,
	filename : String
}