package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.datatypes.*;
import com.sempaigames.gplayrest.GPlay;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.*;
import flash.events.*;
import flash.display.Sprite;
import flash.Lib;
import openfl.system.Capabilities;

class AllLeaderboardsUI extends UI {

	var allLeaderboards : Widget;
	var loading : Widget;
	var btnLeaderboardId : Map<Widget, String>;
	var gPlay : GPlay;
	var lastTime : Int;

	public function new(gPlay : GPlay) {
		super();
		this.gPlay = gPlay;
		this.lastTime = Lib.getTimer();
		Stablex.init();
		this.btnLeaderboardId = new Map<Widget, String>();
		loading = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/loading.xml')();
		allLeaderboards = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/all_leaderboards.xml')();

		this.addChild(loading);
		#if mobile
		gPlay.Leaderboards_list().then(function(leaderboards) {
			loadLeaderBoards(leaderboards);
			this.addChild(allLeaderboards);
			this.removeChild(loading);
			allLeaderboards.getChildAs("all_leaderboards_entries", Widget).applyLayout();
		});
		#else
		haxe.Timer.delay(function() {
			var leaderboards = new LeaderboardListResponse(Stablex.getLeaderboardsListResponse());
			loadLeaderBoards(leaderboards);
			this.addChild(allLeaderboards);
			this.removeChild(loading);
			var entriesBox = allLeaderboards.getChildAs("all_leaderboards_entries", Widget);
			entriesBox.applyLayout();
		}, 1);
		#end
	}

	override public function onResize(_) {
		//var scale = Capabilities.screenDPI / 114;
		var scale = 1;
		trace("scale: " + scale);
		/*
		#if desktop
		*/
		var sx = Lib.current.stage.stageWidth;
		var sy = Lib.current.stage.stageHeight;
		/*
		#else
		var sx = Capabilities.screenResolutionX;
		var sy = Capabilities.screenResolutionY;
		#end
		*/
		loading.w = sx;
		loading.h = sy;
		allLeaderboards.w = sx/scale;
		allLeaderboards.h = sy/scale;
		//allLeaderboards.scaleX = allLeaderboards.scaleY = scale;
		loading.refresh();
		allLeaderboards.refresh();
	}

	function onClick(w : Widget) {
		UIManager.getInstance().showLeaderboard(gPlay, btnLeaderboardId[w]);
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

	override public function onClose() {
		allLeaderboards.free();
		loading.free();
	}

	override public function onKeyUp(k : KeyboardEvent) {
		k.stopImmediatePropagation();
		if (k.keyCode==27) {
			UIManager.getInstance().closeCurrentView();
		}
	}

	function onEnterFrame() {
		var now = Lib.getTimer();
		var delta = Math.abs(now-lastTime);
		if (delta>100) {
			trace("Frozen: " + delta/1000 + "s");
		}
		lastTime = now;
	}

}
