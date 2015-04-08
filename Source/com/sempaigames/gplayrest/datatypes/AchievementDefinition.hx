package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class AchievementDefinition extends GoogleDataType {

	public var id(default, null) : String;
	public var name(default, null) : String;
	public var description(default, null) : String;
	public var achievementType(default, null) : AchievementType;
	public var totalSteps(default, null) : Int;
	public var formattedTotalSteps(default, null) : String;
	public var revealedIconUrl(default, null) : String;
	public var isRevealedIconUrlDefault(default, null) : Bool;
	public var unlockedIconUrl(default, null) : String;
	public var isUnlockedIconUrlDefault(default, null) : Bool;
	public var initialState(default, null) : AchievementState;
	public var experiencePoints(default, null) : Int;

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
