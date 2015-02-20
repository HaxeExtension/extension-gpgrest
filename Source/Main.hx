package;

import openfl.display.Sprite;
import openfl.Lib;
import com.sempaigames.gplayrest.Auth;
import com.sempaigames.gplayrest.GPlayRest;
import pgr.dconsole.DC;

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
		
		gplay.getPlayer("me").then(DC.log.bind());
			
		gplay.listWindow("CgkIiffb8u4QEAIQBw", LeaderBoardCollection.PUBLIC, LeaderBoardTimeSpan.ALL_TIME)
			.then(DC.log.bind());

	}

}
