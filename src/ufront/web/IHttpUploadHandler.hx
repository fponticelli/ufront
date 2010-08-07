/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import haxe.io.Bytes;

interface IHttpUploadHandler
{
	public function uploadStart(name : String, filename : String) : Void;
	public function uploadProgress(name : String, bytes : Bytes, pos : Int, len : Int) : Void;
	public function uploadEnd(name : String) : Void;
}