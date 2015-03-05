package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class PlayerLeaderboardScoreListResponse extends GoogleDataType {

	public var nextPageToken : String;
	public var player : Player;
	public var items : Array<PlayerLeaderboardScore>;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#playerLeaderboardScoreListResponse");
		this.nextPageToken = obj.nextPageToken;
		this.player = new Player(Json.stringify(obj.player));
		this.items = [];
		for (it in cast(obj.items, Array<Dynamic>)) {
			this.items.push(new PlayerLeaderboardScore(Json.stringify(it)));
		}
	}

/*
	public function toString() : String {
		return
'
{
	nextPageToken = $nextPageToken
	player = ${player}
	items = $items
}
';
	}
*/

}
