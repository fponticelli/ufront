package ufront.web.session;
import ufront.web.IHttpSessionState;

class FileSession
{
    // added remember parameter to allow
    // for non-peristent sessions to be created.
    // default to true for PHP and to false for
    // neko, to keep compatibility with
    // existing source code.
    // This could be inconsistent between the two platforms?
    public static function create(savePath : String,?remember:Bool) : IHttpSessionState {
#if php
        return new php.ufront.web.FileSession(savePath,remember);
#elseif neko
        return new neko.ufront.web.FileSession(savePath,remember);
#elseif nodejs
		return new nodejs.ufront.web.FileSession(savePath,remember);
#else
    	NOT IMPLEMENTED PLATFORM;
#end
	}
}
