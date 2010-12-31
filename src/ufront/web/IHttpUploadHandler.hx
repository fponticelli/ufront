/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import haxe.io.Bytes;

interface IHttpUploadHandler
{
	public function uploadStart(name : String, filename : String) : Void;
	public function uploadProgress(bytes : Bytes, pos : Int, len : Int) : Void;
	public function uploadEnd() : Void;
}