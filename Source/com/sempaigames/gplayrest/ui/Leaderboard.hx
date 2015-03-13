package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.datatypes.*;
import com.sempaigames.gplayrest.GPlay;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

import ru.stablex.ui.widgets.*;
import ru.stablex.ui.skins.*;
import ru.stablex.ui.events.*;

import ru.stablex.ui.UIBuilder;

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
		UIBuilder.regClass('com.sempaigames.gplayrest.ui.Leaderboard');
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

	function createPlayerScoreBox(entry : LeaderboardEntry) : Widget {
		var txt = new Text();
		txt.text = entry.player.displayName + " - score: " + entry.scoreValue;
		txt.format.size = 30;
		txt.refresh();
		return txt;
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
				vbox.addChildAt(createPlayerScoreBox(it), 0);
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
				vbox.addChild(createPlayerScoreBox(it));
			}
			loadingScores = false;
		});
	}

	function addScoresFirstTime() {
		loadingScores = true;
		gPlay.Scores_list(
			LeaderBoardCollection.PUBLIC,
			leaderboardId,
			TimeSpan.ALL_TIME,
			25)
		.then(function(leaderboardScores) {
			firstPagePrevPageToken = leaderboardScores.prevPageToken;
			lastPageNextPageToken = leaderboardScores.nextPageToken;
			for (it in leaderboardScores.items) {
				vbox.addChild(createPlayerScoreBox(it));
			}
			loadingScores = false;
		});
	}

	function onResize(_) {

		trace("resize instance: " + instanceId);
		ui.left = Lib.current.stage.stageWidth*0.1;
		ui.top = Lib.current.stage.stageHeight*0.1;
		ui.w = Lib.current.stage.stageWidth*0.8;
		ui.h = Lib.current.stage.stageHeight*0.8;
		/*
		var vbox = ui.getChild("vbox");
		trace(vbox);
		var txt = new Text();
		txt.text = "Random " + Std.random(100);
		txt.format.size = 30;
		txt.refresh();
		vbox.addChildAt(txt, 0);
		*/
	}

}
