package com.sempaigames.gplayrest;

import openfl.events.*;
import openfl.net.*;
import promhx.Promise;
import promhx.Deferred;
import pgr.dconsole.DC;

enum LeaderBoardCollection {
	PUBLIC;
	SOCIAL;
}

enum LeaderBoardTimeSpan {
	ALL_TIME;
	DAILY;
	WEEKLY;
}

class GPlay {
	
	var auth : Auth;

	public function new(clientId : String, clientSecret : String) {
		this.auth = new Auth(clientId, clientSecret);
	}

	function request(url : String) : Promise<String> {
		var ret = new Deferred<String>();
		auth.getToken().then(function(token) {
			var request = new URLRequest('$url?access_token=$token');
			/*
			var urlVariables = new URLVariables();
			urlVariables.access_token = token;
			request.data = urlVariables;
			request.verbose = true;
			DC.log("DATA = " + request.data.toString());
			*/
			var loader = new URLLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e : HTTPStatusEvent) {
				if (e.status!=200) throw("Status ${e.status} in request ${request.toString()}");
			});
			loader.addEventListener(Event.COMPLETE, function(e : Event) ret.resolve(e.target.data));
			loader.load(request);
		});
		return ret.promise();
	}

	// Player
	public function getPlayer(player : String) : Promise<Player> {
		var ret = new Deferred<Player>();
		request('https://www.googleapis.com/games/v1/players/${player}').then(function (data)
		{
			ret.resolve(new Player(data));
		});
		return ret.promise();
	}

	// Leaderboard
	public function getLeaderBoard(leaderboardId : String) : Promise<Leaderboard> {
		var ret = new Deferred<Leaderboard>();
		request('https://www.googleapis.com/games/v1/leaderboards/${leaderboardId}').then(function (data)
		{
			ret.resolve(new Leaderboard(data));
		});
		return ret.promise();
	}

	/*
	public function listWindow(leaderboardId : String, collection : LeaderBoardCollection, timeSpan : LeaderBoardTimeSpan) : Promise<String> {
		var ret = new Deferred<String>();
		auth.getToken().then(function(token) {
			var request = new URLRequest('https://www.googleapis.com/games/v1/leaderboards/${leaderboardId}/window/${collection}?timeSpan=${timeSpan}&access_token=${token}');
			var loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(e : Event) ret.resolve(e.target.data));
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e : HTTPStatusEvent) DC.log("listWindow http status: " + e));
			loader.load(request);
		});
		return ret.promise();
	}
	*/

}
