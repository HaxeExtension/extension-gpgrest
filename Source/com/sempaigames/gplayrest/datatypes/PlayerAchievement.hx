package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class PlayerAchievement extends GoogleDataType {

	var id : String;
	var currentSteps : Int;
	var formattedCurrentStepsString : String;
	var achievementState : String;
	var lastUpdatedTimestamp : Int;
	var experiencePoints : Int;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#playerAchievement");
		Macro.assign(this, obj, [
			"id",
			"currentSteps",
			"formattedCurrentStepsString",
			"achievementState",
			"lastUpdatedTimestamp",
			"experiencePoints"
		]);
	}

}
