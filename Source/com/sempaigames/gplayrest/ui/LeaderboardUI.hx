package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.GPlay;
import flash.events.Event;
import flash.display.Sprite;
import flash.Lib;
import ru.stablex.ui.widgets.*;
import ru.stablex.ui.UIBuilder;
import com.sempaigames.gplayrest.datatypes.Leaderboard;
import com.sempaigames.gplayrest.datatypes.LeaderboardScores;
import com.sempaigames.gplayrest.datatypes.TimeSpan;

class LeaderboardUI extends Sprite {

	var leaderboard : Widget;
	var loading : Widget;

	var gPlay : GPlay;
	var leaderboardId : String;

	var nextPageToken : String;
	var isLoading : Bool;

	public function new(gPlay : GPlay, leaderboardId : String) {
		super();
		UIBuilder.setTheme('ru.stablex.ui.themes.android4');
		UIBuilder.init('com/sempaigames/gplayrest/ui/xml/defaults.xml');
		UIBuilder.regClass('UrlBmp');
		UIBuilder.regClass('Loading');
		
		loading = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/loading.xml')();
		leaderboard = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/leaderboard.xml')();
		nextPageToken = "";
		isLoading = true;

		this.gPlay = gPlay;
		this.leaderboardId = leaderboardId;

		this.addChild(loading);
		this.addEventListener(Event.ADDED_TO_STAGE, onResize);
		Lib.current.stage.addEventListener(Event.RESIZE, onResize);

		gPlay.Leaderboards_get(leaderboardId)
			.catchError(function(err) trace("Error :'( " + err))
			.then(function (leaderboard) {
				updateTitleBar(leaderboard.iconUrl, leaderboard.name);
				isLoading = false;
			});

	}

	function onResize(_) {
		loading.w = leaderboard.w = Lib.current.stage.stageWidth;
		loading.h = leaderboard.h = Lib.current.stage.stageHeight;
		loading.refresh();
		leaderboard.refresh();
	}
	
	function onEnterFrame() {

		//var scroll = cast(leaderboard, Scroll);
		/*
		if (scroll.scrollY == scroll.h - scroll.box.h && !isLoading) {
			trace("aca");
			isLoading = true;
			gPlay.Scores_list(LeaderBoardCollection.PUBLIC, leaderboardId, TimeSpan.ALL_TIME, 25, nextPageToken)
				.catchError(function(err) trace("Error :'( " + err))
				.then(function (scores) {
					addResults(scores);
					isLoading = false;
				});
		}
		*/
		/* else if (scroll.scrollY==0) {
			
		}
		*/
	}

	function onTimeLapseChange(timeLapse : Dynamic) {
		trace(timeLapse);
	}

	function onRankTypeChange(rankType : Dynamic) {
		trace(rankType);
	}

	function clearResults() {

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
			var score = entryUI.getChildAs("entry_name", Text);
			rank.text = entry.formattedScoreRank;
			image.url = entry.player.avatarImageUrl;
			name.text = entry.player.displayName;
			score.text = entry.formattedScore;
			entriesBox.addChild(entryUI);
		}
	}

}
