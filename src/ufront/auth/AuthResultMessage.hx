package ufornt.auth;
import udo.util.Message;

enum AuthResultMessage
{
	Success;
	Failure(?msg : Message)
	IdentityNotFound(?msg : Message);  
	InvalidCredential(?msg : Message);
}