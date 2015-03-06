package com.sempaigames.gplayrest;

import com.sempaigames.gplayrest.datatypes.*;
import openfl.events.*;
import openfl.net.*;
import promhx.Promise;
import promhx.Deferred;
import pgr.dconsole.DC;

enum LeaderBoardCollection {
	PUBLIC;
	SOCIAL;
}

enum RankType {
	ALL;
	PUBLIC;
	SOCIAL;
}

enum HttpResult {
	Ok(data : String);
	Error(code : Int);
}

class GPlay {
	
	var auth : Auth;

	public function new(clientId : String, clientSecret : String) {
		this.auth = new Auth(clientId, clientSecret);
	}

	function request(url : String, params : Array<{param : String, value : String}> = null) : Promise<HttpResult> {
		var ret = new Deferred<HttpResult>();
		auth.getToken().then(function(token) {
			if (params==null) params = [];
			url = url + "?";
			for (p in params) {
				url = url + p.param + "=" + p.value + "&";
			}
			url = url + 'access_token=$token';
			var request = new URLRequest(url);
			var loader = new URLLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e : HTTPStatusEvent) {
				if (e.status!=200) {
					ret.resolve(Error(e.status));
				}
			});
			loader.addEventListener(Event.COMPLETE, function(e : Event) {
				ret.resolve(Ok(e.target.data));
			});
			loader.load(request);
		});
		return ret.promise();
	}

	// Players
	public function Players_get(player : String) : Promise<Player> {
		var ret = new Deferred<Player>();
		request('https://www.googleapis.com/games/v1/players/${player}').then(function (data)
		{
			switch (data) {
				case Ok(data): 		ret.resolve(new Player(data));
				case Error(code):	ret.throwError('http error: $code');
			}
		});
		return ret.promise();
	}

	// LeaderBoards
	public function Leaderboards_get(leaderboardId : String) : Promise<Leaderboard> {
		var ret = new Deferred<Leaderboard>();
		request('https://www.googleapis.com/games/v1/leaderboards/${leaderboardId}').then(function (data)
		{
			switch (data) {
				case Ok(data): 		ret.resolve(new Leaderboard(data));
				case Error(code):	ret.throwError('http error: $code');
			}
		});
		return ret.promise();
	}

	public function Leaderboards_list() : Promise<LeaderboardListResponse> {
		var ret = new Deferred<LeaderboardListResponse>();
		request('https://www.googleapis.com/games/v1/leaderboards').then(function (data)
		{
			switch (data) {
				case Ok(data): 		ret.resolve(new LeaderboardListResponse(data));
				case Error(code):	ret.throwError('http error: $code');
			}
		});
		return ret.promise();
	}

	// Scores
	public function Scores_get(	playerId : String,
								leaderboardId : String,
								timeSpan : TimeSpan,
								includeRankType : RankType = null,
								maxResults : Int = 25,
								pageToken : String = "") : Promise<PlayerLeaderboardScoreListResponse> {
		if (includeRankType==null) {
			includeRankType = RankType.PUBLIC;
		}
		if (timeSpan==TimeSpan.ALL_TIME && includeRankType==RankType.ALL) {
			throw "You cannot ask for 'ALL' leaderboards and 'ALL' timeSpans in the same request.";
		}
		var ret = new Deferred<PlayerLeaderboardScoreListResponse>();
		var params = [];
		params.push({ param : "timeSpan", value : Std.string(timeSpan) });
		params.push({ param : "includeRankType", value : Std.string(includeRankType) });
		params.push({ param : "maxResults", value : Std.string(maxResults) });
		if (pageToken.length>0) {
			params.push({ param : "pageToken", value : pageToken });
		}
		request(
			'https://www.googleapis.com/games/v1/players/${playerId}/leaderboards/${leaderboardId}/scores/${timeSpan}',
			params
		).then(function (data) {
			switch (data) {
				case Ok(data): 		ret.resolve(new PlayerLeaderboardScoreListResponse(data));
				case Error(code):	ret.throwError('http error: $code');
			}
		});
		return ret.promise();
	}

	public function Scores_list( collection : LeaderBoardCollection,
								 leaderboardId : String,
								 timeSpan : TimeSpan,
								 maxResults : Int = 25,
								 pageToken : String = "" ) : Promise<LeaderboardScores> {
		var ret = new Deferred<LeaderboardScores>();
		var params = [];
		params.push({ param : "timeSpan", value : Std.string(timeSpan) });
		params.push({ param : "maxResults", value : Std.string(maxResults) });
		if (pageToken.length>0) {
			params.push({ param : "pageToken", value : pageToken });
		}
		request(
			'https://www.googleapis.com/games/v1/leaderboards/${leaderboardId}/scores/${collection}',
			params
		).then(function (data) {
			switch (data) {
				case Ok(data):		ret.resolve(new LeaderboardScores(data));
				case Error(code):	ret.throwError('http error: $code');
			}
		});
		return ret.promise();
	}

	public function Scores_submit(leaderboardId : String, score : Int) : Promise<PlayerScoreResponse> {
		var ret = new Deferred<PlayerScoreResponse>();
		var params = [];
		params.push({ param : "score", value : Std.string(score) });
		request(
			'https://www.googleapis.com/games/v1/leaderboards/${leaderboardId}/scores',
			params
		).then(function (data) {
			switch (data) {
				case Ok(data): 		ret.resolve(new PlayerScoreResponse(data));
				case Error(code):	ret.throwError('http error: $code');
			}
		});
		return ret.promise();
	}

}
