package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class PlayerAchievement extends GoogleDataType {

	public var id(default, null) : String;
	public var currentSteps(default, null) : Int;
	public var formattedCurrentStepsString(default, null) : String;
	public var achievementState(default, null) : AchievementState;
	public var lastUpdatedTimestamp(default, null) : Float;
	public var experiencePoints(default, null) : Int;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#playerAchievement");
		Macro.assign(this, obj, [
			"id",
			"currentSteps",
			"formattedCurrentStepsString",
			"lastUpdatedTimestamp",
			"experiencePoints"
		]);
		if (obj.achievementState!=null) {
			this.achievementState = AchievementState.createByName(obj.achievementState);
		}
	}

}
