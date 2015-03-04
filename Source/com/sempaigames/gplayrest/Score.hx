package com.sempaigames.gplayrest;

import com.sempaigames.gplayrest.Leaderboard;
import haxe.Json;
import pgr.dconsole.DC;

class Rank {

    // "kind": "games#leaderboardScoreRank",

    public var rank : Int;
    public var formattedRank : String;
    public var numScores : Int;
    public var formattedNumScores : String;

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

    public var leaderboard_id : String;
    public var scoreValue : Int;
    public var scoreString : String;
    public var publicRank : Rank;
    public var socialRank : Rank;
    public var timeSpan : String;
    public var writeTimestamp : Int;
    public var scoreTag : String;

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
        this.publicRank = new Rank(Json.stringify(obj.publicRank));
        this.socialRank = new Rank(Json.stringify(obj.socialRank));
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

class LeaderboardScores {

    // "kind": "games#leaderboardScores"
    public var nextPageToken : String;
    public var prevPageToken : String;
    public var numScores : Int;
    public var playerScore : LeaderboardEntry;
    public var items : Array<LeaderboardEntry>;

    public function new(data : String) {
        var obj = Json.parse(data);
        this.playerScore = new LeaderboardEntry(Json.stringify(obj.playerScore));
        this.items = [];
        for (it in cast(obj.items, Array<Dynamic>)) {
            this.items.push(new LeaderboardEntry(Json.stringify(it)));
        }
        Macro.assign(this, obj, [
            "nextPageToken",
            "prevPageToken",
            "numScores"
        ]);
    }

    public function toString() : String {
        return
'
{
    nextPageToken = $nextPageToken
    prevPageToken = $prevPageToken
    numScores = $numScores
    playerScore = ${playerScore.toString()}
    items = $items
}
';
    }

}

class Score {

	// "kind": "games#playerLeaderboardScoreListResponse"
  	public var nextPageToken : String;
	public var player : Player;
  	public var items : Array<PlayerLeaderboardScore>;

    public function new(data : String) {
        var obj = Json.parse(data);
        this.nextPageToken = obj.nextPageToken;
        this.player = new Player(Json.stringify(obj.player));
        this.items = [];
        for (it in cast(obj.items, Array<Dynamic>)) {
            this.items.push(new PlayerLeaderboardScore(Json.stringify(it)));
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
