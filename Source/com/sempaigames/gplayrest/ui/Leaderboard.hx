package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.GPlay;
import com.sempaigames.gplayrest.datatypes.*;
import flash.Lib;
import flash.display.Sprite;
import flash.events.Event;
import promhx.Promise;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.events.*;
import ru.stablex.ui.layouts.*;
import ru.stablex.ui.skins.*;
import ru.stablex.ui.widgets.*;

class Leaderboard extends Sprite {
	
	static var instanceCount : Int = 0;
	var instanceId : Int;
	
	var gPlay : GPlay;
	var leaderboardId : String;
	
	var ui : Widget;
	var scroll : Scroll;
	var scrolling : Bool;

	var vbox : VBox;

	var firstPagePrevPageToken : String;
	var lastPageNextPageToken : String;

	var loadingScores : Bool;

	public function new(gPlay : GPlay, leaderboardId : String) {
		super();
		
		this.gPlay = gPlay;
		this.leaderboardId = leaderboardId;
		
		this.instanceId = instanceCount++;
		UIBuilder.init();
		ui = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/leaderboard.xml')();
		
		scroll = ui.getChildAs("scroll", Scroll);
		scroll.addEventListener(WidgetEvent.SCROLL_START, function(_) scrolling=true);
		scroll.addEventListener(WidgetEvent.SCROLL_STOP, function(_) scrolling=false);

		Lib.current.stage.addEventListener(Event.RESIZE, onResize);
		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

		vbox = ui.getChildAs("vbox", VBox);

		this.addChild(ui);
		onResize(null);

		addScoresFirstTime();

	}

	function onEnterFrame(_) {
		if (scrolling && !loadingScores) {
			if (scroll.scrollY == scroll.h - scroll.box.h && firstPagePrevPageToken!=null) {
				addScoresTop(firstPagePrevPageToken);
			} else if (scroll.scrollY==0 && lastPageNextPageToken!=null) {
				addScoresBottom(lastPageNextPageToken);
			}
		}
	}

	function addScoresTop(pageToken : String = null) {
		loadingScores = true;
		gPlay.Scores_list(
			LeaderBoardCollection.PUBLIC,
			leaderboardId,
			TimeSpan.ALL_TIME,
			25,
			pageToken)
		.then(function(leaderboardScores) {
			firstPagePrevPageToken = leaderboardScores.prevPageToken;
			for (i in 0...leaderboardScores.items.length) {
				var it = leaderboardScores.items[leaderboardScores.items.length-i-1];
				vbox.addChildAt(new UILeaderBoardEntry(it, ui), 0);
			}
			loadingScores = false;
		});
	}

	function addScoresBottom(pageToken : String = null) {
		loadingScores = true;
		gPlay.Scores_list(
			LeaderBoardCollection.PUBLIC,
			leaderboardId,
			TimeSpan.ALL_TIME,
			25,
			pageToken)
		.then(function(leaderboardScores) {
			lastPageNextPageToken = leaderboardScores.nextPageToken;
			for (it in leaderboardScores.items) {
				vbox.addChild(new UILeaderBoardEntry(it, ui));
			}
			loadingScores = false;
		});
	}

	function addScoresFirstTime() {

		loadingScores = true;
		var box = new Box();
		vbox.addChild(box);
		box.widthPt = ui.w;
		var row = new Row();
		row.hAlign = 'center';
		box.layout = row;
		var ldng = new Loading(100, 100);
		box.addChild(ldng);

		var leaderBoardPromise = gPlay.Leaderboards_get(leaderboardId);
		var leaderBoardScoresPromise = gPlay.Scores_list(LeaderBoardCollection.PUBLIC, leaderboardId, TimeSpan.ALL_TIME, 25);
		
		// Workarround for https://github.com/jdonaldson/promhx/issues/51
		leaderBoardPromise.then(function(leaderBoard) {
			leaderBoardScoresPromise.then(function(leaderboardScores) {
				vbox.removeChild(box);
				vbox.addChild(new LeaderBoardTitle(leaderBoard, ui));
				firstPagePrevPageToken = leaderboardScores.prevPageToken;
				lastPageNextPageToken = leaderboardScores.nextPageToken;
				for (it in leaderboardScores.items) {
					vbox.addChild(new UILeaderBoardEntry(it, ui));
				}
				loadingScores = false;
				onResize(null);
			});
		});

		/*
		Promise.when(leaderBoardPromise, leaderBoardScoresPromise).then(function(leaderBoard, leaderboardScores) {
			vbox.removeChild(box);
			vbox.addChild(new LeaderBoardTitle(leaderBoard));
			firstPagePrevPageToken = leaderboardScores.prevPageToken;
			lastPageNextPageToken = leaderboardScores.nextPageToken;
			for (it in leaderboardScores.items) {
				vbox.addChild(new UILeaderBoardEntry(it, ui));
			}
			loadingScores = false;
			onResize(null);
		});
		*/

	}

	function onResize(_) {

		trace("resize instance: " + instanceId);
		ui.left = Lib.current.stage.stageWidth*0.1;
		ui.top = Lib.current.stage.stageHeight*0.1;
		ui.w = Lib.current.stage.stageWidth*0.8;
		ui.h = Lib.current.stage.stageHeight*0.8;

		vbox.w = ui.w;

		for (i in 0...vbox.numChildren) {
			var widget = cast(vbox.getChildAt(i), Widget);
			widget.w = vbox.w;
			widget.refresh();
		}

		ui.refresh();
		vbox.refresh();

	}

}
