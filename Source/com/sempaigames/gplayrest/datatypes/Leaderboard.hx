package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class Leaderboard extends GoogleDataType {

	public var id(default, null) : String;
	public var name(default, null) : String;
	public var iconUrl(default, null) : String;
	public var isIconUrlDefault(default, null) : Bool;
	public var order(default, null) : LeaderboardOrder;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#leaderboard");
		Macro.assign(this, obj, [
			"id",
			"name",
			"iconUrl",
			"isIconUrlDefault"
		]);
		try {
			this.order = LeaderboardOrder.createByName(obj.order);
		} catch (d:Dynamic) {
			this.order = LeaderboardOrder.LARGER_IS_BETTER;
		}
	}

}
