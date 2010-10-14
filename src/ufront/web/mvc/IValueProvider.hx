package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

interface IValueProvider 
{
	function containsPrefix(prefix : String) : Bool;
	function getValue(key : String) : ValueProviderResult;
}