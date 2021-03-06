package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class AchievementDefinitionsListResponse extends GoogleDataType {

	public var nextPageToken(default, null) : String;
	public var items(default, null) : Array<AchievementDefinition>;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#achievementDefinitionsListResponse");
		this.nextPageToken = obj.nextPageToken;
		this.items = [];
		if (obj.items!=null) {
			for (it in cast(obj.items, Array<Dynamic>)) {
				this.items.push(new AchievementDefinition(Json.stringify(it)));
			}
		}
	}

}
