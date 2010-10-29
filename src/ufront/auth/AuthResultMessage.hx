package ufront.auth;
import thx.util.Message;

enum AuthResultMessage
{
	Success;
	Failure(?msg : Message);
	IdentityNotFound(?msg : Message);
	IdentityAmbiguous(?msg : Message);  
	InvalidCredential(?msg : Message);
}