package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class PlayerLeaderboardScore extends GoogleDataType {
    
    public var leaderboard_id : String;
    public var scoreValue : Int;
    public var scoreString : String;
    public var publicRank : LeaderboardScoreRank;
    public var socialRank : LeaderboardScoreRank;
    public var timeSpan : String;
    public var writeTimestamp : Int;
    public var scoreTag : String;

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
        this.publicRank = new LeaderboardScoreRank(Json.stringify(obj.publicRank));
        this.socialRank = new LeaderboardScoreRank(Json.stringify(obj.socialRank));
    }

/*
    public function toString() : String {
        return
'
{
    leaderboard_id = $leaderboard_id
    scoreValue = $scoreValue
    scoreString = $scoreString
    publicRank = ${publicRank}
    socialRank = ${socialRank}
    timeSpan = $timeSpan
    writeTimestamp = $writeTimestamp
    scoreTag = $scoreTag
}
';
    }
*/

}
