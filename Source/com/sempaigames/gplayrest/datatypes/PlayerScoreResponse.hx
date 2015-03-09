package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class PlayerScoreResponse extends GoogleDataType {

	var beatenScoreTimeSpans : Array<TimeSpan>;
	var unbeatenScores : Array<PlayerScore>;
	var formattedScore : String;
	var leaderboardId : String;
	var scoreTag : String;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#playerScoreResponse");
		Macro.assign(this, obj, [
			"formattedScore",
			"leaderboardId",
			"scoreTag"
		]);
		this.beatenScoreTimeSpans = [];
		if (obj.beatenScoreTimeSpans!=null) {
			for (it in cast(obj.beatenScoreTimeSpans, Array<Dynamic>)) {
				this.beatenScoreTimeSpans.push(TimeSpan.createByName(Json.stringify(it)));
			}
		}
		this.unbeatenScores = [];
		if (obj.unbeatenScores!=null) {
			for (it in cast(obj.unbeatenScores, Array<Dynamic>)) {
				this.unbeatenScores.push(new PlayerScore(Json.stringify(it)));
			}
		}
	}

}
