package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class LeaderboardScoreRank extends GoogleDataType {

	public var rank : Int;
	public var formattedRank : String;
	public var numScores : Int;
	public var formattedNumScores : String;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#leaderboardScoreRank");
		Macro.assign(this, obj, [
			"rank",
			"formattedRank",
			"numScores",
			"formattedNumScores"
		]);
	}

/*
	public function toString() : String {
		return
'
{
	rank = $rank
	formattedRank = $formattedRank
	numScores = $numScores
	formattedNumScores = $formattedNumScores
}
';
	}
*/

}
