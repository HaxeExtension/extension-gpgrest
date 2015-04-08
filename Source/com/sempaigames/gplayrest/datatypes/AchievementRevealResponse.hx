package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class AchievementRevealResponse extends GoogleDataType {

	public var currentState(default, null) : AchievementState;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#achievementRevealResponse");
		this.currentState = obj.currentState;
	}

}