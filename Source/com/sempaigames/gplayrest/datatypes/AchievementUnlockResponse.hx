package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class AchievementUnlockResponse extends GoogleDataType {
	
	var newlyUnlocked : Bool;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#achievementUnlockResponse");
		this.newlyUnlocked = obj.newlyUnlocked;
	}

}
