package ufront.web.mvc.view;

#if uform
import uform.model.core.Model;
import uform.ui.comp.Form;
import uform.ui.build.html5.Html5Builder;
import uform.ui.comp.Trigger;
import ufront.web.mvc.IViewHelper;
import haxe.ds.StringMap;

using Strings;
using Types;

/**
 * ...
 * @author Franco Ponticelli
 */

class UFormHelper implements IViewHelper
{
	static inline var CSS_VAR = "styleSheets";

	public var cssPath(default, null) : Null<String>;
	public function new(csspath = "~/css/uform.css")
	{
		cssPath = csspath;
	}

	public function injectCss(data : StringMap<Dynamic>)
	{
		if (null == cssPath)
			return;
		data.get("push")(CSS_VAR, { href : cssPath } );
	}

	public function register(data : StringMap<Dynamic>)
	{
		var me = this;
		data.set("uform", function(form : Form, ?t : String -> String -> String, ?lang : String) {
			me.injectCss(data);

			if (null == t)
			{
				t = data.get("_");
				if(null == t)
					t = function(v, _) return v;
			}
			if (null == form)
				return t("null form", lang);
			else if (!Std.is(form, Form))
				return t("wrong form type; expected '{0}' but was '{1}'", lang).format(["uform.ui.comp.Form", form.fullName()]);
			try {
				return Html5Builder.buildString(form, function(s) return t(s, lang));
			} catch (e : Dynamic) {
				return t("unable to build form: {0}", lang).format([Std.string(e)]);
			}
		});
	}
}
#end