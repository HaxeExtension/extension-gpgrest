package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class PlayerScore extends GoogleDataType {

	public var timeSpan : TimeSpan;
	public var score : Int;
	public var formattedScore : String;
	public var scoreTag : String;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#playerScore");
		Macro.assign(this, obj, [
			"score",
			"formattedScore",
			"scoreTag"
		]);
		this.timeSpan = TimeSpan.createByName(obj.timeSpan);
	}

}
