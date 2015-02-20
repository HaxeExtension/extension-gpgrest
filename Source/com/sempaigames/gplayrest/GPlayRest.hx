package com.sempaigames.gplayrest;

import openfl.events.*;
import openfl.net.*;
import promhx.Promise;
import promhx.Deferred;

class GPlayRest {
	
	var auth : Auth;

	public function new(clientId : String, clientSecret : String) {
		this.auth = new Auth(clientId, clientSecret);
	}
	
	public function getPlayer() : Promise<String> {
		var ret = new Deferred<String>();
		auth.getToken().then(function(token) {
			var request = new URLRequest("https://www.googleapis.com/games/v1/players/" + "me" + "?access_token=" + token);
			var loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(e : Event) ret.resolve(e.target.data));
			//loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e : HTTPStatusEvent) DC.log("http status: " + e));
			loader.load(request);
		});
		return ret.promise();
	}

}
