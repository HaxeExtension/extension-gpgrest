package com.sempaigames.gplayrest;

import haxe.Json;

class Player {

  	//"kind": "games#player",

	public var playerId(default, null) : String;
	public var displayName(default, null) : String;
	public var avatarImageUrl(default, null) : String;

	public var familyName(default, null) : String;
	public var givenName(default, null) : String;

	public var title(default, null) : String;

	public function new(data : String) {
		var obj = Json.parse(data);
		this.playerId = obj.playerId;
		this.displayName = obj.displayName;
		this.avatarImageUrl = obj.avatarImageUrl;
		this.familyName = obj.familyName;
		this.givenName = obj.givenName;
		this.title = obj.title;
	}

	public function toString() : String {
		return
'
{
    playerId = $playerId
    displayName = $displayName
    avatarImageUrl = $avatarImageUrl
    familyName = $familyName
    givenName = $givenName
    title = $title
}
';
	}

	/*
	"lastPlayedWith": {
	    "kind": "games#played",
	    "timeMillis": long,
	    "autoMatched": boolean
  	},
  	*/

	/*
	"experienceInfo": {
		
		"kind": "games#playerExperienceInfo",
		"currentExperiencePoints": long,
		"lastLevelUpTimestampMillis": long,
		
		"currentLevel": {
			"kind": "games#playerLevel",
			"level": integer,
			"minExperiencePoints": long,
			"maxExperiencePoints": long
		},

		"nextLevel": {
			"kind": "games#playerLevel",
			"level": integer,
			"minExperiencePoints": long,
			"maxExperiencePoints": long
		}
  	},
  	*/

}
