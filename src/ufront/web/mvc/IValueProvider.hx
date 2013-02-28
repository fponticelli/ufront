package ufront.web.mvc;

/**
 * Defines the methods that are required for a value provider in Ufront
 * @author Andreas Soderlund
 */

interface IValueProvider 
{
	function containsPrefix(prefix : String) : Bool;
	function getValue(key : String) : ValueProviderResult;
}