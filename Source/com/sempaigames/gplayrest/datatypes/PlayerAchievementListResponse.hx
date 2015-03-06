package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class PlayerAchievementListResponse extends GoogleDataType {

	var nextPageToken : String;
	var items : Array<PlayerAchievement>;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#playerAchievementListResponse");
		this.nextPageToken = obj.nextPageToken;
		this.items = [];
		for (it in cast(obj.items, Array<Dynamic>)) {
			this.items.push(new PlayerAchievement(Json.stringify(it)));
		}
	}

}
