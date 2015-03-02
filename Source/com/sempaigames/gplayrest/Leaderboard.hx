package com.sempaigames.gplayrest;

import haxe.Json;

enum LeaderboardOrder {
	LARGER_IS_BETTER;
	SMALLER_IS_BETTER;
}

class Leaderboard {
	
	public var id(default, null) : String;
	public var name(default, null) : String;
	public var iconUrl(default, null) : String;
	public var isIconUrlDefault(default, null) : Bool;
	public var order(default, null) : LeaderboardOrder;

	public function new(data : String) {
		var obj = Json.parse(data);
		this.id = obj.id;
		this.name = obj.name;
		this.iconUrl = obj.iconUrl;
		this.isIconUrlDefault = obj.isIconUrlDefault;
		this.order = switch (obj.order) {
			case "LARGER_IS_BETTER": LARGER_IS_BETTER;
			case "SMALLER_IS_BETTER": SMALLER_IS_BETTER;
			default: LARGER_IS_BETTER;
		}

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
