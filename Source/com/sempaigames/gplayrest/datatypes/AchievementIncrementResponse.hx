package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class AchievementIncrementResponse extends GoogleDataType {

	public var currentSteps : Int;
	public var newlyUnlocked : Bool;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#achievementIncrementResponse");
		Macro.assign(this, obj, [
			"currentSteps",
			"newlyUnlocked"
		]);
	}

}
