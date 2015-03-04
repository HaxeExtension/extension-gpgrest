package com.sempaigames.gplayrest;

import haxe.Json;
import pgr.dconsole.DC;

enum LeaderboardOrder {
	LARGER_IS_BETTER;
	SMALLER_IS_BETTER;
}

class LeaderboardListResponse {
	
	// "kind": "games#leaderboardListResponse"

	public var nextPageToken : String;
 	public var items : Array<Leaderboard>;

 	public function new(data : String) {
 		var obj = Json.parse(data);
 		this.nextPageToken = obj.nextPageToken;
 		this.items = [];
 		var objs = cast(obj.items, Array<Dynamic>);
 		for (it in objs) {
 			this.items.push(new Leaderboard(Json.stringify(it)));
 		}
 	}

 	public function toString() : String {
 		return
 '
 {
    nextPageToken = $nextPageToken
    items = $items
 }
 ';
 	}

}

class LeaderboardEntry {

	// "kind": "games#leaderboardEntry"

	public var player : Player;
    public var scoreRank : Int;
    public var formattedScoreRank : String;
    public var scoreValue : Int;
    public var formattedScore : String;
    public var timeSpan : String;
    public var writeTimestampMillis : Int;
    public var scoreTag : String;

    public function new(data : String) {
    	var obj = Json.parse(data);
    	this.player = new Player(Json.stringify(obj.player));
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

    public function toString() : String {
    	return
'
{
	player = ${player.toString()}
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

}

class Leaderboard {

	// "kind": "games#leaderboard"

	public var id(default, null) : String;
	public var name(default, null) : String;
	public var iconUrl(default, null) : String;
	public var isIconUrlDefault(default, null) : Bool;
	public var order(default, null) : LeaderboardOrder;

	public function new(data : String) {
		var obj = Json.parse(data);
		Macro.assign(this, obj, [
			"id",
			"name",
			"iconUrl",
			"isIconUrlDefault"
		]);
		this.order = LeaderboardOrder.createByName(obj.order);
	}

	public function toString() {
		return
'
{
    id = $id
    name = $name
    iconUrl = $iconUrl
    isIconUrlDefault = $isIconUrlDefault
    order = $order
}
';
	}

}
