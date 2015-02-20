package;

import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.*;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLVariables;
import com.sempaigames.gplayrest.*;
import pgr.dconsole.DC;
import promhx.Promise;
import promhx.Deferred;

class Main extends Sprite {

	public function new() {
		
		super();

		Lib.current.stage.addChild(this);
		DC.init(100);
		DC.showConsole();

		var gplay = new GPlayRest(
			"579524295561-3ouahfhaemm43o9nc9sv82tssipikqnq.apps.googleusercontent.com",
			"04AV4MBll5Wcy3A1xl3GDzPA"
		);
		gplay.getPlayer().then(function(data) DC.log(data));
	}

}
