package com.sempaigames.gplayrest;

import openfl.Lib;
import openfl.events.*;
import openfl.net.*;
import haxe.ds.Option;
import haxe.Timer;
import promhx.Deferred;
import promhx.Promise;
import pgr.dconsole.DC;
import extension.webview.WebView;

class Auth {
	
	var clientId : String;
	var clientSecret : String;
	var storage : SharedObject;

	var pendingTokenPromise : Promise<String>;
	var token : String;
	var tokenExpireTime : Float;

	public function new(clientId : String, clientSecret : String) {
		this.storage = SharedObject.getLocal("gplayrest"); 
		this.clientId = clientId;
		this.clientSecret = clientSecret;
		this.token = null;
		this.pendingTokenPromise = null;
	}

	static var stripString = "http://localhost/?code=";
	function getAuthCode() : Promise<String> {
		var ret = new Deferred<String>();
		var clientId = "client_id=" + this.clientId;
		var responseType = "response_type=" + "code";
		var redirectUri = "redirect_uri=" + "http://localhost";
		var scope = "scope=" + StringTools.urlEncode("https://www.googleapis.com/auth/games");
		var authCodeUrl = 'https://accounts.google.com/o/oauth2/auth?$clientId&$responseType&$redirectUri&$scope';
		#if (android || iphone)
		WebView.onURLChanging = function(url : String) {
			if (StringTools.startsWith(url, stripString)) {
				var code = StringTools.replace(url, stripString, "");
				ret.resolve(code);
			}
		}
		WebView.onClose = function() pgr.dconsole.DC.log("Close webview");
		WebView.open(authCodeUrl, true, [".*google.*"]);
		#else
		Lib.getURL(new URLRequest(authCodeUrl));
		ret.resolve("");
		#end
		return ret.promise();
	}

	function getNewTokenUsingCode(code : String) : Promise<String> {

		DC.log("Get token using code: " + code);

		var request = new URLRequest("https://www.googleapis.com/oauth2/v3/token");
		var variables = new URLVariables();
		var ret = new Deferred<String>();
		variables.grant_type = "authorization_code";
		variables.code = code;
		variables.client_id = clientId;
		variables.client_secret = clientSecret;
		variables.redirect_uri = "http://localhost";
		request.data = variables;
		request.method = URLRequestMethod.POST;
		var loader = new URLLoader();
		loader.addEventListener(Event.COMPLETE, function(e : Event) {
			var response = haxe.Json.parse(e.target.data);
			var accessToken = response.access_token;
			var refreshToken = response.refresh_token;

			if (accessToken==null || refreshToken==null) {
				throw "Couldn't get auth tokens";
			}

			var expiresIn : Int = response.expires_in;
			
			this.token = accessToken;
			this.tokenExpireTime = Timer.stamp() + expiresIn;
			this.storage.data.refreshToken = refreshToken;
			this.storage.flush();

			ret.resolve(accessToken);
		});
		loader.load(request);
		return ret.promise();
	}

	function getNewTokenUsingRefreshToken(refreshToken : String) : Promise<String> {
		DC.log("Use refresh token...");
		var ret = new Deferred<String>();
		var request = new URLRequest("https://www.googleapis.com/oauth2/v3/token");
		var variables = new URLVariables();
		variables.refresh_token = refreshToken;
		variables.client_id = clientId;
		variables.client_secret = clientSecret;
		variables.grant_type = "refresh_token";
		request.data = variables;
		request.method = URLRequestMethod.POST;
		var loader = new URLLoader();
		loader.addEventListener(Event.COMPLETE, function(e : Event) {
			var response = haxe.Json.parse(e.target.data);
			var accessToken = response.access_token;
			var expiresIn : Int = response.expires_in;
			this.token = accessToken;
			this.tokenExpireTime = Timer.stamp() + expiresIn;
			ret.resolve(accessToken);
		});
		
		loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e : HTTPStatusEvent) {
			DC.log("http status: " + e);
			if (e.status==400) {
				//AuthCodeGetter.getAuthCode(clientId).then(updateTokenUsingCode);
				throw "InvalidRefreshToken";
			}
		});
		
		loader.load(request);
		return ret.promise();
	}

	function getNewToken() : Promise<String> {
		if (storage.data.refreshToken!=null) {
			// Use refresh token
			return getNewTokenUsingRefreshToken(storage.data.refreshToken);
		} else {
			// No refresh_token:
			return getAuthCode().pipe(getNewTokenUsingCode);
		}
	}

	public function getToken() : Promise<String> {
		#if (android || iphone)
		if (token!=null && Timer.stamp()<tokenExpireTime) {
			var ret = new Deferred<String>();
			ret.resolve(token);
			DC.log("return cached");
			return ret.promise();
		} else if (this.pendingTokenPromise!=null) {
			DC.log("return pending");
			return this.pendingTokenPromise;
		} else {
			this.pendingTokenPromise = getNewToken();
			return this.pendingTokenPromise;
		}
		#else
		var ret = new Deferred<String>();
		ret.resolve("notset");
		return ret.promise();
		#end
	}

}