package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class LeaderboardListResponse extends GoogleDataType {

	public var nextPageToken(default, null) : String;
	public var items(default, null) : Array<Leaderboard>;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#leaderboardListResponse");
		this.nextPageToken = obj.nextPageToken;
		this.items = [];
		var objs = cast(obj.items, Array<Dynamic>);
		for (it in objs) {
			this.items.push(new Leaderboard(Json.stringify(it)));
		}
	}

}
