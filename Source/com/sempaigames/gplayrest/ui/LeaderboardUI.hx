package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.GPlay;
import flash.events.*;
import flash.display.Sprite;
import flash.Lib;
import ru.stablex.ui.widgets.*;
import ru.stablex.ui.UIBuilder;
import com.sempaigames.gplayrest.datatypes.Leaderboard;
import com.sempaigames.gplayrest.datatypes.LeaderboardScores;
import com.sempaigames.gplayrest.datatypes.TimeSpan;
import openfl.system.Capabilities;

class LeaderboardUI extends UI {

	var leaderboard : Widget;
	var loading : Widget;

	var gPlay : GPlay;
	var leaderboardId : String;

	var nextPageToken : String;
	var isLoading : Bool;
	var isFirstLoad : Bool;
	var errorCount : Int;

	var displayingTimeSpan : TimeSpan;
	var loadedTimeSpan : TimeSpan;
	var displayingRankType : LeaderBoardCollection;
	var loadedRankType : LeaderBoardCollection;

	public function new(gPlay : GPlay, leaderboardId : String) {
		super();
		Stablex.init();
		
		loading = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/loading.xml')();
		leaderboard = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/leaderboard.xml')();
		nextPageToken = "";
		isLoading = true;
		isFirstLoad = true;
		errorCount = 0;

		this.gPlay = gPlay;
		this.leaderboardId = leaderboardId;

		this.addChild(loading);

		gPlay.Leaderboards_get(leaderboardId)
			.catchError(function(err) {
				trace("Error :'( " + err);
				isLoading = false;
			}).then(function (leaderboard) {
				updateTitleBar(leaderboard.iconUrl, leaderboard.name);
				isLoading = false;
			});

		displayingTimeSpan = loadedTimeSpan = TimeSpan.ALL_TIME;
		displayingRankType = loadedRankType = LeaderBoardCollection.PUBLIC;

	}

	override public function onResize(_) {
		//var scale = Capabilities.screenDPI / 200;
		var scale = 1;
		loading.w = Capabilities.screenResolutionX;
		loading.h = Capabilities.screenResolutionY;
		leaderboard.w = Capabilities.screenResolutionX/scale;
		leaderboard.h = Capabilities.screenResolutionX/scale;
		leaderboard.scaleX = leaderboard.scaleY = scale;
		loading.refresh();
		leaderboard.refresh();
	}
	
	function onEnterFrame() {
		var scroll = cast(leaderboard, Scroll);
		if (displayingRankType!=loadedRankType || displayingTimeSpan!=loadedTimeSpan) {
			clearResults();
			isFirstLoad = true;
			nextPageToken = "";
		}
		if (scroll.h - scroll.box.h - scroll.scrollY >= 0 && !isLoading && errorCount<5 &&
			(nextPageToken!="" || isFirstLoad) && nextPageToken!=null) {
			isLoading = true;
			isFirstLoad = false;
			var loadingRankType = LeaderBoardCollection.createByIndex(displayingRankType.getIndex());
			var loadingTimeSpan = TimeSpan.createByIndex(displayingTimeSpan.getIndex());
			gPlay.Scores_list(loadingRankType, leaderboardId, loadingTimeSpan, 25, nextPageToken)
				.catchError(function(err) {
					trace("Error :'( " + err + ", err count: " + errorCount);
					isLoading = false;
					errorCount++;
				}).then(function (scores) {
					addResults(scores);
					nextPageToken = scores.nextPageToken;
					loadedRankType = loadingRankType;
					loadedTimeSpan = loadingTimeSpan;
					isLoading = false;
				});
		}
	}

	function onTimeLapseChange(timeSpan : Dynamic) {
		errorCount = 0;
		switch (timeSpan) {
			case 1: displayingTimeSpan = TimeSpan.ALL_TIME;
			case 2: displayingTimeSpan = TimeSpan.WEEKLY;
			case 3: displayingTimeSpan = TimeSpan.DAILY;
			default: {}
		}
	}

	function onRankTypeChange(leaderboardCollection : Dynamic) {
		errorCount = 0;
		switch (leaderboardCollection) {
			case 1: displayingRankType = LeaderBoardCollection.PUBLIC;
			case 2: displayingRankType = LeaderBoardCollection.SOCIAL;
			default: {}
		}
	}

	function clearResults() {
		var entriesBox = leaderboard.getChildAs("leaderboard_player_entries", VBox);
		while (entriesBox.numChildren>0) {
			var c = entriesBox.getChildAt(0);
			if (c!=null) {
				entriesBox.removeChild(c);
				cast(c, Widget).free();
			}
		}
	}

	function updateTitleBar(imageUrl : String, title : String) {
		leaderboard.getChildAs("title_icon", UrlBmp).url = imageUrl;
		leaderboard.getChildAs("title_text", Text).text = title;
		this.removeChild(loading);
		this.removeChild(leaderboard);
		this.addChild(leaderboard);
	}

	function addResults(results : LeaderboardScores) {
		var entriesBox = leaderboard.getChildAs("leaderboard_player_entries", VBox);
		for (entry in results.items) {
			var entryUI = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/leaderboardentry.xml')();
			var rank = entryUI.getChildAs("entry_ranking", Text);
			var image = entryUI.getChildAs("entry_image", UrlBmp);
			var name = entryUI.getChildAs("entry_name", Text);
			var score = entryUI.getChildAs("entry_score", Text);
			rank.text = entry.formattedScoreRank;
			image.url = entry.player.avatarImageUrl;
			name.text = entry.player.displayName;
			score.text = entry.formattedScore;
			entriesBox.addChild(entryUI);
		}
	}

	override public function onClose() {
		leaderboard.free();
		loading.free();
	}

	override public function onKeyUp(k : KeyboardEvent) {
		if (k.keyCode==27) {
			UIManager.getInstance().closeCurrentView();
		}
	}

}
