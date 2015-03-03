package com.sempaigames.gplayrest;

import haxe.Json;

class Rank {

    // "kind": "games#leaderboardScoreRank",

    var rank : Int;
    var formattedRank : String;
    var numScores : Int;
    var formattedNumScores : String;

    public function new(data : String) {
        var obj = Json.parse(data);
        Macro.assign(this, obj, [
            "rank",
            "formattedRank",
            "numScores",
            "formattedNumScores"
        ]);
    }

    public function toString() : String {
        return
'
{
    rank = $rank
    formattedRank = $formattedRank
    numScores = $numScores
    formattedNumScores = $formattedNumScores
}
';
    }

}

class PlayerLeaderboardScore {

    // "kind": "games#playerLeaderboardScore"

    var leaderboard_id : String;
    var scoreValue : Int;
    var scoreString : String;
    var publicRank : Rank;
    var socialRank : Rank;
    var timeSpan : String;
    var writeTimestamp : Int;
    var scoreTag : String;

    public function new(data : String) {
        var obj = Json.parse(data);
        Macro.assign(this, obj, [
            "leaderboard_id",
            "scoreValue",
            "scoreString",
            "timeSpan",
            "writeTimestamp",
            "scoreTag"
        ]);
        this.publicRank = new Rank(obj.publicRank);
        this.socialRank = new Rank(obj.socialRank);
    }

    public function toString() : String {
        return
'
{
    leaderboard_id = $leaderboard_id
    scoreValue = $scoreValue
    scoreString = $scoreString
    publicRank = ${publicRank.toString()}
    socialRank = ${socialRank.toString()}
    timeSpan = $timeSpan
    writeTimestamp = $writeTimestamp
    scoreTag = $scoreTag
}
';
    }

}

class Score {

	// "kind": "games#playerLeaderboardScoreListResponse"
  	var nextPageToken : String;
	var player : Player;
  	var items : Array<PlayerLeaderboardScore>;

    public function new(data : String) {
        var obj = Json.parse(data);
        this.nextPageToken = obj.nextPageToken;
        this.items = [];
        for (it in obj.items) {
            items.push(new PlayerLeaderboardScore(it));
        }
    }

    public function toString() : String {
        return
'
{
    nextPageToken = $nextPageToken
    player = ${player.toString()}
    items = $items
}
';
    }

}
