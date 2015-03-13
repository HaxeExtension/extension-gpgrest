package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class LeaderboardScores extends GoogleDataType {

	public var nextPageToken(default, null) : String;
	public var prevPageToken(default, null) : String;
	public var numScores(default, null) : Int;
	public var playerScore(default, null) : LeaderboardEntry;
	public var items(default, null) : Array<LeaderboardEntry>;

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

}
