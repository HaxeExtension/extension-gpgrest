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

	public function new(gPlay : GPlay) {
		super();
		this.gPlay = gPlay;
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
			var leaderboards = new LeaderboardListResponse(openfl.Assets.getText("assets/leaderboardslistresponse.json"));
			loadLeaderBoards(leaderboards);
			this.addChild(allLeaderboards);
			this.removeChild(loading);
			var entriesBox = allLeaderboards.getChildAs("all_leaderboards_entries", Widget);
			entriesBox.applyLayout();
		}, 1);
		#end
	}

	override public function onResize(_) {
		var scale = Capabilities.screenDPI / 200;
		loading.w = Capabilities.screenResolutionX;
		loading.h = Capabilities.screenResolutionY;
		allLeaderboards.w = Capabilities.screenResolutionX/scale;
		allLeaderboards.h = Capabilities.screenResolutionY/scale;
		allLeaderboards.scaleX = allLeaderboards.scaleY = scale;
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

}
