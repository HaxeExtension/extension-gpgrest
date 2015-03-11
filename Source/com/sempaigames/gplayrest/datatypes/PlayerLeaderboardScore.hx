package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class PlayerLeaderboardScore extends GoogleDataType {
    
    public var leaderboard_id(default, null) : String;
    public var scoreValue(default, null) : Int;
    public var scoreString(default, null) : String;
    public var publicRank(default, null) : LeaderboardScoreRank;
    public var socialRank(default, null) : LeaderboardScoreRank;
    public var timeSpan(default, null) : String;
    public var writeTimestamp(default, null) : Int;
    public var scoreTag(default, null) : String;

    public function new(data : String) {
        super();
        var obj = Json.parse(data);
        verifyKind(obj, "games#playerLeaderboardScore");
        Macro.assign(this, obj, [
            "leaderboard_id",
            "scoreValue",
            "scoreString",
            "timeSpan",
            "writeTimestamp",
            "scoreTag"
        ]);
        if (obj.publicRank!=null) {
            this.publicRank = new LeaderboardScoreRank(Json.stringify(obj.publicRank));
        }
        if (obj.socialRank!=null) {
            this.socialRank = new LeaderboardScoreRank(Json.stringify(obj.socialRank));
        }
    }

}
