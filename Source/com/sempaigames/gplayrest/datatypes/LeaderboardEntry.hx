package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class LeaderboardEntry extends GoogleDataType {

	public var player(default, null) : Player;
	public var scoreRank(default, null) : Int;
	public var formattedScoreRank(default, null) : String;
	public var scoreValue(default, null) : Int;
	public var formattedScore(default, null) : String;
	public var timeSpan(default, null) : String;
	public var writeTimestampMillis(default, null) : Int;
	public var scoreTag(default, null) : String;

	public function new(data : String) {
		super();
		var obj : Dynamic = Json.parse(data);
		verifyKind(obj, "games#leaderboardEntry");
		if (obj.player!=null) {
			this.player = new Player(Json.stringify(obj.player));
		}
		Macro.assign(this, obj, [
			"scoreRank",
			"formattedScoreRank",
			"scoreValue",
			"formattedScore",
			"timeSpan",
			"writeTimestampMillis",
			"scoreTag"
		]);
	}

/*
	public function toString() : String {
		return
'
{
	player = ${player}
	scoreRank = $scoreRank
	formattedScoreRank = $formattedScoreRank
	scoreValue = $scoreValue
	formattedScore = $formattedScore
	timeSpan = $timeSpan
	writeTimestampMillis = $writeTimestampMillis
	scoreTag = $scoreTag
}
';
	}
*/

}
