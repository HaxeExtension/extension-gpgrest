package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class AchievementDefinition extends GoogleDataType {

	var id : String;
	var name : String;
	var description : String;
	var achievementType : AchievementType;
	var totalSteps : Int;
	var formattedTotalSteps : String;
	var revealedIconUrl : String;
	var isRevealedIconUrlDefault : Bool;
	var unlockedIconUrl : String;
	var isUnlockedIconUrlDefault : Bool;
	var initialState : AchievementState;
	var experiencePoints : Int;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#achievementDefinition");
		Macro.assign(this, obj, [
			"id",
			"name",
			"description",
			"totalSteps",
			"formattedTotalSteps",
			"revealedIconUrl",
			"isRevealedIconUrlDefault",
			"unlockedIconUrl",
			"isUnlockedIconUrlDefault",
			"experiencePoints"
		]);
		this.achievementType = AchievementType.createByName(obj.achievementType);
		this.initialState = AchievementState.createByName(obj.initialState);
	}
	
}
