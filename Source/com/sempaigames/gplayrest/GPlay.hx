package com.sempaigames.gplayrest;

import com.sempaigames.gplayrest.Auth;
import com.sempaigames.gplayrest.datatypes.*;
import haxe.Timer;
import openfl.events.*;
import openfl.net.*;
import promhx.Deferred;
import promhx.Promise;

enum LeaderBoardCollection {
	PUBLIC;
	SOCIAL;
}

enum RankType {
	ALL;
	PUBLIC;
	SOCIAL;
}

enum RequestResult {
	Ok(data : String);
	Error(code : Int);
}

#if (haxe_ver >= 3.3)
    typedef Constructible = haxe.Constraints.Constructible<String->Void>;
#else
    typedef Constructible = {
        public function new(s:String):Void;
    }
#end

class GPlay {

	public var auth : Auth;
	var pendingRequests : Array<URLLoader>;

	public function new(clientId : String, clientSecret : String) {
		this.auth = new Auth(clientId, clientSecret);
		pendingRequests = [];
	}

	function request(
			url : String,
			params : Array<{param : String, value : String}> = null,
			method : String = null
		) : Promise<RequestResult> {

		var ret = new Deferred<RequestResult>();
		
		if (auth.authStatus==AuthStatus.Ok) {
			var token = auth.token;
			if (params==null)	params = [];
			if (method==null)	method = URLRequestMethod.GET;
			if (params.length>0) {
				url = url + "?";
			}
			var removeLast = false;
			for (p in params) {
				url = url + p.param + "=" + p.value + "&";
				removeLast = true;
			}
			if (removeLast) {
				url = url.substr(0, url.length-1);
			}
			var request = new URLRequest(url);
			request.requestHeaders = [new URLRequestHeader("Authorization", "Bearer "+token)];
			request.method = method;
			var loader = new URLLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e : HTTPStatusEvent) {
				if (e.status!=200) {
					pendingRequests.remove(loader);
					ret.resolve(Error(e.status));
				}
			});
			loader.addEventListener(Event.COMPLETE, function(e : Event) {
				if (pendingRequests.remove(loader)) {
					ret.resolve(Ok(e.target.data));
				} else if (!ret.isResolved()) {
					ret.resolve(Error(-1));
				}
			});
			pendingRequests.push(loader);
			loader.load(request);
		} else {
			ret.resolve(Error(-2));
		}

		return ret.promise();
	}

	@:generic
	function handleRequestResult<T:Constructible>(result : RequestResult, ret : Deferred<T>) {
		try {
			switch (result) {
				case Ok(data):		ret.resolve(new T(data));
				case Error(code):	ret.throwError('http error: $code');
			}
		} catch(e : Dynamic) {
			ret.throwError(e);
		}
	}

	// Players
	public function Players_get(player : String) : Promise<Player> {
		var ret = new Deferred<Player>();
		request('https://www.googleapis.com/games/v1/players/${player}').then(function (data)
		{
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	// LeaderBoards
	public function Leaderboards_get(leaderboardId : String) : Promise<Leaderboard> {
		var ret = new Deferred<Leaderboard>();
		request('https://www.googleapis.com/games/v1/leaderboards/${leaderboardId}').then(function (data)
		{
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	public function Leaderboards_list() : Promise<LeaderboardListResponse> {
		var ret = new Deferred<LeaderboardListResponse>();
		request('https://www.googleapis.com/games/v1/leaderboards').then(function (data)
		{
			handleRequestResult(data, ret);
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
		).then(function(data) {
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	public function Scores_list(collection : LeaderBoardCollection,
								leaderboardId : String,
								timeSpan : TimeSpan,
								maxResults : Int = 25,
								pageToken : String = "" ) : Promise<LeaderboardScores> {
		var ret = new Deferred<LeaderboardScores>();
		var params = [];
		params.push({ param : "timeSpan", value : Std.string(timeSpan) });
		params.push({ param : "maxResults", value : Std.string(maxResults) });
		if (pageToken!=null && pageToken.length>0) {
			params.push({ param : "pageToken", value : pageToken });
		}
		request(
			'https://www.googleapis.com/games/v1/leaderboards/${leaderboardId}/scores/${collection}',
			params
		).then(function(data) {
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	public function Scores_submit(leaderboardId : String, score : Int) : Promise<PlayerScoreResponse> {
		var ret = new Deferred<PlayerScoreResponse>();
		var params = [];
		params.push({ param : "score", value : Std.string(score) });
		request(
			'https://www.googleapis.com/games/v1/leaderboards/${leaderboardId}/scores',
			params,
			URLRequestMethod.POST
		).then(function(data) {
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	// Achievements
	public function Achievements_increment(achievementId : String, stepsToIncrement : Int) : Promise<AchievementIncrementResponse> {
		var ret = new Deferred<AchievementIncrementResponse>();
		var params = [];
		params.push({ param : "stepsToIncrement", value : Std.string(stepsToIncrement) });
		params.push({ param : "requestId", value : Std.string(Std.random(0xffffff)) });
		request(
			'https://www.googleapis.com/games/v1/achievements/${achievementId}/increment',
			params,
			URLRequestMethod.POST
		).then(function(data) {
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	public function Achievements_list(	playerId : String,
										maxResults : Int = -1,
										pageToken : String = null,
										state : AchievementState = null ) : Promise<PlayerAchievementListResponse> {
		var ret = new Deferred<PlayerAchievementListResponse>();
		var params = [];
		if (maxResults>0) {
			params.push({ param : "maxResults", value : Std.string(maxResults) });
		}
		if (pageToken!=null) {
			params.push({ param : "pageToken", value : pageToken });
		}
		if (state!=null) {
			params.push({ param : "state", value : Std.string(state) });
		}
		request(
			'https://www.googleapis.com/games/v1/players/${playerId}/achievements',
			params
		).then(function(data) {
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	public function Achievements_reveal(achievementId : String) : Promise<AchievementRevealResponse> {
		var ret = new Deferred<AchievementRevealResponse>();
		request('https://www.googleapis.com/games/v1/achievements/${achievementId}/reveal', [], URLRequestMethod.POST)
		.then(function(data) {
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	public function Achievements_setStepsAtLeast(achievementId : String, steps : Int) : Promise<AchievementSetStepsAtLeastResponse> {
		var ret = new Deferred<AchievementSetStepsAtLeastResponse>();
		var params = [];
		params.push({ param : "steps", value : Std.string(steps) });
		request(
			'https://www.googleapis.com/games/v1/achievements/${achievementId}/setStepsAtLeast',
			params,
			URLRequestMethod.POST
		).then(function(data) {
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	public function Achievements_unlock(achievementId : String) : Promise<AchievementUnlockResponse> {
		var ret = new Deferred<AchievementUnlockResponse>();
		request(
			'https://www.googleapis.com/games/v1/achievements/${achievementId}/unlock',
			[],
			URLRequestMethod.POST
		).then(function(data) {
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	// AchievementDefinitions
	public function AchievementDefinitions_list(maxResults : Int = -1, pageToken : String = null) : Promise<AchievementDefinitionsListResponse> {
		var ret = new Deferred<AchievementDefinitionsListResponse>();
		var params = [];
		if (maxResults>0) {
			params.push({ param : "maxResults", value : Std.string(maxResults) });
		}
		if (pageToken!=null) {
			params.push({ param : "pageToken", value : pageToken });
		}
		request(
			'https://www.googleapis.com/games/v1/achievements',
			params
		).then(function(data) {
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	// Snapshots
	public function Snapshot_get(snapshotId : String) : Promise<Snapshot> {
		var ret = new Deferred<Snapshot>();
		request('https://www.googleapis.com/games/v1/snapshots/${snapshotId}').then(function(data) {
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	public function Snapshots_list(playerId : String, maxResults : Int = -1, pageToken : String = null ) : Promise<SnapshotListResponse> {
		var ret = new Deferred<SnapshotListResponse>();
		var params = [];
		if (maxResults>0) {
			params.push({ param : "maxResults", value : Std.string(maxResults) });
		}
		if (pageToken!=null) {
			params.push({ param : "pageToken", value : pageToken });
		}
		request(
			'https://www.googleapis.com/games/v1/players/${playerId}/snapshots',
			params
		).then(function(data) {
			handleRequestResult(data, ret);
		});
		return ret.promise();
	}

	public function cancelPendingRequests() {
		for (p in pendingRequests) {
			try {
				p.close();
				p.dispatchEvent(new Event(Event.COMPLETE));
			} catch (e : Dynamic) {
				trace("Already closed");
			}
		}
		pendingRequests = [];
	}

}
