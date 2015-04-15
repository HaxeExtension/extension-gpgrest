package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.datatypes.*;
import com.sempaigames.gplayrest.GPlay;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.*;
import flash.events.*;
import flash.display.Sprite;
import flash.Lib;
import openfl.system.Capabilities;

class AllLeaderboardsUI extends Sprite {

	var allLeaderboards : Widget;
	var loading : Widget;
	var btnLeaderboardId : Map<Widget, String>;
	var gPlay : GPlay;

	public function new(gPlay : GPlay) {
		super();
		this.gPlay = gPlay;
		Stablex.init();
		this.btnLeaderboardId = new Map<Widget, String>();
		loading = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/loading.xml')();
		allLeaderboards = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/all_leaderboards.xml')();

		Lib.current.stage.addEventListener(Event.RESIZE, onResize);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		this.addChild(loading);
		gPlay.Leaderboards_list().then(function(leaderboards) {
			loadLeaderBoards(leaderboards);
			this.addChild(allLeaderboards);
			this.removeChild(loading);
		});

		onResize(null);

	}

	function onKeyUp(k : KeyboardEvent) {
		if (k.keyCode==27) {
			k.stopImmediatePropagation();
			close();
		}
	}

	function onResize(_) {
		var scale = Capabilities.screenDPI / 200;
		loading.w = Lib.current.stage.stageWidth;
		loading.h = Lib.current.stage.stageHeight;
		allLeaderboards.w = Lib.current.stage.stageWidth/scale;
		allLeaderboards.h = Lib.current.stage.stageHeight/scale;
		allLeaderboards.scaleX = allLeaderboards.scaleY = scale;
		loading.refresh();
		allLeaderboards.refresh();
	}

	function onClick(w : Widget) {
		trace("asasdasd:::: " + btnLeaderboardId[w]);
		Lib.current.stage.addChild(new LeaderboardUI(gPlay, btnLeaderboardId[w]));
	}

	function loadLeaderBoards(leaderboards : LeaderboardListResponse) {
		var entriesBox = allLeaderboards.getChildAs("all_leaderboards_entries", Widget);
		for (leaderboard in leaderboards.items) {
			var entryUI = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/all_leaderboardsentry.xml')();
			entryUI.getChildAs("img", UrlBmp).url = leaderboard.iconUrl;
			entryUI.getChildAs("title", Text).text = leaderboard.name;
			entriesBox.addChild(entryUI);
			btnLeaderboardId.set(entryUI, leaderboard.id);

			allLeaderboards.onResize();
			allLeaderboards.refresh();
			
		}
	}

	function close() {
		if (this.parent!=null) {
			Lib.current.stage.removeEventListener(Event.RESIZE, onResize);
			Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			var p = this.parent;
			p.removeChild(this);
			allLeaderboards.free();
			loading.free();
		}
	}

}
