
package ufront.web.session;
import ufront.web.IHttpSessionState;

class FileSession
{

    public static function create(savePath : String) : IHttpSessionState {

#if php
        return new php.ufront.web.FileSession(savePath);
#elseif neko
        return new neko.ufront.web.FileSession(savePath);
#elseif nodejs
		return new nodejs.ufront.web.FileSession(savePath);
#else
    	NOT IMPLEMENTED PLATFORM;
#end
	}
}
