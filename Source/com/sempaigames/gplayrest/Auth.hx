package com.sempaigames.gplayrest;

#if (android || iphone)
import extension.webview.WebView;
#end

import haxe.ds.Option;
import haxe.Timer;
import openfl.events.*;
import openfl.Lib;
import openfl.net.*;
import promhx.Deferred;
import promhx.Promise;

#if cpp
import cpp.vm.Thread;
#end

#if neko
import neko.vm.Thread;
import sys.net.Host;
#end

enum AuthStatus {
	Ok;
	Failed;
	Pending;
	Virgin;
}

class Auth {

	public var authStatus(default, null) : AuthStatus;
	public var token(default, null) : String;

	var clientId : String;
	var clientSecret : String;
	var storage : SharedObject;
	var tokenExpireTime : Float;
	var stopSrvLoop : Bool;

	var onLoginEventListeners : Array<Void->Void>;

	public function new(clientId : String, clientSecret : String) {
		this.storage = SharedObject.getLocal("gplayrest");
		this.clientId = clientId;
		this.clientSecret = clientSecret;
		this.token = null;
		this.authStatus = Virgin;
		this.onLoginEventListeners = [];
		this.stopSrvLoop = false;
	}

	static var stripString = "http://localhost:8099/?";
	static var redirectUri = "http://localhost:8099/";

	function onActivate(_) {
		stopSrvLoop = true;
	}

	function getAuthCode() : Promise<String> {

		var ret = new Deferred<String>();
		var clientId = "client_id=" + this.clientId;
		var responseType = "response_type=" + "code";

		var scope = "scope=" + StringTools.urlEncode("https://www.googleapis.com/auth/games");
		var authCodeUrl = 'https://accounts.google.com/o/oauth2/auth?${clientId}&${responseType}&${"redirect_uri="+redirectUri}&${scope}&include_granted_scopes=true';

		#if (android || iphone)

		WebView.onURLChanging = function(url : String) {
			if (StringTools.startsWith(url, stripString)) {
				var url = StringTools.replace(url, stripString, "");
				for (p in url.split("&")) {
					var pair = p.split("=");
					if (pair.length!=2) {
						continue;
					}
					if (pair[0]=="code") {
						ret.resolve(pair[1]);
					}
				}
			}
		}
		WebView.open(authCodeUrl, true, null, ["(http|https)://localhost(.*)"]);

		#else

		Thread.create(function() {
			var s = new sys.net.Socket();
			s.bind(new sys.net.Host("localhost"), 8099);
			s.listen(1);
			stopSrvLoop = false;
			Lib.current.stage.addEventListener(Event.ACTIVATE, onActivate);
			do {
				var result = sys.net.Socket.select([s], [], [], 0.5);
				if (result.read.length>0) {
					var c = s.accept();
					var str = null;
					var error:Bool = true;
					while (str!="") {
						str = c.input.readLine();
						if (~/GET \/+/.match(str)) {
							if (!~/error=+/.match(str)) error = false;
							var get = str.split(" ")[1];
							var code = ~/.*code=/.replace(str, "");
							code = code.split("&")[0];
							ret.resolve(code);
						}
					}
					c.write(error?getErrorHTML():getSuccessHTML());
					c.close();
					stopSrvLoop = true;
				}
			} while (!stopSrvLoop);
			s.close();
			if (!ret.isResolved()) {
				ret.throwError("User canceled Google Login");
			}
			Lib.current.stage.removeEventListener(Event.ACTIVATE, onActivate);
		});

		Lib.getURL(new URLRequest(authCodeUrl));

		#end

		return ret.promise();
	}

	function getNewTokenUsingCode(code : String) : Promise<String> {
		var request = new URLRequest("https://www.googleapis.com/oauth2/v3/token");
		var variables = new URLVariables();
		var ret = new Deferred<String>();
		variables.grant_type = "authorization_code";
		variables.code = code;
		variables.client_id = clientId;
		variables.client_secret = clientSecret;
		variables.redirect_uri = redirectUri;
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
		loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e : HTTPStatusEvent) {
			if (e.status!=200) {
				//throw 'Refresh token error: ${e.status}';
				ret.throwError('getNewTokenUsingCode error: ${e.status}');
				//prom.reject('Refresh token error: ${e.status}');
			}
		});
		loader.load(request);
		return ret.promise();
	}

	function getNewTokenUsingRefreshToken(refreshToken : String) : Promise<String> {
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
			if (e.status!=200) {
				//throw 'Refresh token error: ${e.status}';
				ret.throwError('Refresh token error: ${e.status}');
				//prom.reject('Refresh token error: ${e.status}');
			}
		});

		loader.load(request);
		return ret.promise();
	}

	function setTokenOk(token : String) : Void {
		this.token = token; authStatus = Ok;
		for (f in onLoginEventListeners) {
			f();
		}
		onLoginEventListeners = [];
	}

	function loginUsingAuthCode(userInitiated : Bool) {
		if (userInitiated) {
			getAuthCode().pipe(getNewTokenUsingCode).catchError(function(e) {
				trace("auth code failed: " + e);
				authStatus = Failed;
				onLoginEventListeners = [];
			}).then(function(token) {
				setTokenOk(token);
			});
		} else {
			trace("cant login showing Google login screen unless user initiated event");
			authStatus = Failed;
			onLoginEventListeners = [];
		}
	}

	public function addOnLoginEventListener(f : Void->Void) {
		if (authStatus!=Ok) {
			onLoginEventListeners.push(f);
		} else {
			f();
		}
	}

	public function login(userInitiated : Bool) {
		if (authStatus==Ok || authStatus==Pending) {
			return;
		}
		authStatus = Pending;
		if (storage.data.refreshToken!=null) {
			// Use refresh token
			var tokenUsingRefresh = getNewTokenUsingRefreshToken(storage.data.refreshToken);
			tokenUsingRefresh.catchError(function (x){
				trace("login using refresh token failed");
				loginUsingAuthCode(userInitiated);
			}).then(function (token){
				setTokenOk(token);
			});
		} else {
			// Show Google login screen
			loginUsingAuthCode(userInitiated);
		}
	}

	private function getSuccessHTML():String {
		return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
				<head>
				    <title>Google Play Games - Login Successful</title>
				    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=0.8, maximum-scale=0.8,user-scalable=no" />
				</head>
				<body style="background-color:#ffffff;margin: 0;padding: 0;border: 0;">

				<table style="width:100%;position:absolute;height:100%;margin:auto 0"><tr>
				    <td valign="center">
				        <center>
				        <h1>LOGIN SUCCESSFUL</h1>
				        <p>You can now close this browser and begin<br/> to play using Google Play Games...</p>
				        </center>
				    </td>
				</tr></table>

				<script type="text/javascript">
				//window.open("","_self").close();
				</script>

				</body>
				</html>';
	}

	private function getErrorHTML():String {
		return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
				<head>
				    <title>Google Play Games - Login Error</title>
				    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=0.8, maximum-scale=0.8,user-scalable=no" />
				</head>
				<body style="background-color:#ffffff;margin: 0;padding: 0;border: 0;">

				<table style="width:100%;position:absolute;height:100%;margin:auto 0"><tr>
				    <td valign="center">
						<center>
						<h1>LOGIN ERROR</h1>
						<p>
						There was an error dungin the login.
						<br/>
						<strong>Don\'t panic:</strong> This is not really needed to play this game :)
						<br/>
						<br/>
						<i>You can close this browser and begin to play without Google Play Games (or you can retry later if you wish).</i>
						</p>
						</center>
				    </td>
				</tr></table>

				<script type="text/javascript">
				//window.open("","_self").close();
				</script>

				</body>
				</html>';
	}

}
