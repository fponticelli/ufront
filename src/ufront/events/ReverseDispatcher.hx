package ufront.events;
import hxevents.Dispatcher;

/**
 * ...
 * @author Andreas Soderlund
 */
class ReverseDispatcher<T> extends Dispatcher<T>
{
	public function new() { super(); }
	
	override public function add(h : T -> Void) : T -> Void {
		handlers.unshift(h);
		return h;
	}
}