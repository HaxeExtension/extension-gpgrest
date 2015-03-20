package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class Player extends GoogleDataType {

	public var playerId(default, null) : String;
	public var displayName(default, null) : String;
	public var avatarImageUrl(default, null) : String;

	public var familyName(default, null) : String;
	public var givenName(default, null) : String;

	public var title(default, null) : String;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#player");
		Macro.assign(this, obj, [
			"playerId",
			"displayName",
			"avatarImageUrl",
			"familyName",
			"givenName",
			"title"
		]);
	}

}
