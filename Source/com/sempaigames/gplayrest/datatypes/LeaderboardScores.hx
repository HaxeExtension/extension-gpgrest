package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class LeaderboardScores extends GoogleDataType {

	public var nextPageToken : String;
	public var prevPageToken : String;
	public var numScores : Int;
	public var playerScore : LeaderboardEntry;
	public var items : Array<LeaderboardEntry>;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#leaderboardScores");
		if (obj.playerScore!=null) {
			this.playerScore = new LeaderboardEntry(Json.stringify(obj.playerScore));
		}
		this.items = [];
		for (it in cast(obj.items, Array<Dynamic>)) {
			this.items.push(new LeaderboardEntry(Json.stringify(it)));
		}
		Macro.assign(this, obj, [
			"nextPageToken",
			"prevPageToken",
			"numScores"
		]);
	}

/*
	public function toString() : String {
		return
'
{
	nextPageToken = $nextPageToken
	prevPageToken = $prevPageToken
	numScores = $numScores
	playerScore = ${playerScore}
	items = $items
}
';
	}
*/

}
