package ufront.web.mvc.view;
import uform.ui.comp.Form;
import ufront.web.mvc.Controller;
import uform.ui.comp.Control;
import uform.ui.comp.Trigger;
import uform.ui.build.html5.Html5Builder;
using StringTools;
using Types;

/**
 * ...
 * @author Franco Ponticelli
 */

class UFormControllerAdapter
{

	public static function executeForm(controller : Controller, form : Form)
	{
		var request = controller.controllerContext.request;
		var params = request.params;
		var prefix = form.name;
		if (null != prefix && prefix != "")
		{
			prefix += ".";
			prefix = Html5Builder.pathToName(prefix);
		}
		var actions = [];
		for (param in params.keys())
		{
			var path = param;
			var isaction = path.startsWith("!");
			if (isaction)
				path = path.substr(1);
			if (!path.startsWith(prefix))
				continue;
			path = Html5Builder.nameToPath(path);
			if (isaction)
			{
				actions.push(path);
				continue;
			}
			var value = params.get(param);
			try
			{
				switch(form.model.validateStringAt(path, value))
				{
					case Ok:
						form.model.setString(path, value);
					case Failure(e):
						trace(path + ": " + value + ", " + e);
						form.componentByPath(path).ifIs(Control, function(input) {
							input.value.set(cast value);
						});
				}
			} catch (e : Dynamic) {
				trace(e);
			}
		}
		for (path in actions)
		{
			var component = form.componentByPath(path);
			if (null == component)
				continue;
			try
			{
				component.ifIs(Trigger, function(t) {
					t.trigger();
				});
			} catch (e : Dynamic) {
				trace(e);
			}
		}
	}
}