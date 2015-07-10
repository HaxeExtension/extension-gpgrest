package com.sempaigames.gplayrest;

import com.sempaigames.gplayrest.datatypes.*;
import com.sempaigames.gplayrest.GPlay;
import com.sempaigames.gplayrest.ui.*;
import flash.Lib;

class GooglePlayGames {

	public static inline var ACHIEVEMENT_STATUS_LOCKED:Int = 0;
	public static inline var ACHIEVEMENT_STATUS_UNLOCKED:Int = 1;
	static var gPlayInstance : GPlay;

	//////////////////////////////////////////////////////////////////////
	///////////// LOGIN & INIT
	//////////////////////////////////////////////////////////////////////

	public static function login() : Void {
		if (!isInitted()) {
			return;
		}
		gPlayInstance.auth.getToken();
	}

	static function isInitted() : Bool {
		return (gPlayInstance!=null);
	}

	public static function init(clientId : String, clientSecret : String) {
		gPlayInstance = new GPlay(clientId, clientSecret);
	}

	public static function cancelPendingRequests() {
		if (!isInitted()) {
			return;
		}
		gPlayInstance.cancelPendingRequests();
	}

	//////////////////////////////////////////////////////////////////////
	///////////// LEADERBOARDS
	//////////////////////////////////////////////////////////////////////

	public static function displayScoreboard(id:String) : Bool {
		if (!isInitted()) {
			return false;
		}
		UIManager.getInstance().showLeaderboard(gPlayInstance, id);
		return false;
	}

	public static function displayAllScoreboards() : Bool {
		if (!isInitted()) {
			return false;
		}
		UIManager.getInstance().showAllLeaderboards(gPlayInstance);
		return false;
	}

	public static function setScore(id:String, score:Int) : Bool {
		if (!isInitted()) {
			return false;
		}
		gPlayInstance.Scores_submit(id, score);
		return true;
	}

	//////////////////////////////////////////////////////////////////////
	///////////// ACHIEVEMENTS
	//////////////////////////////////////////////////////////////////////

	public static function displayAchievements() : Bool {
		UIManager.getInstance().showAchievements(gPlayInstance);
		return false;
	}

	public static function unlock(id:String) : Bool {
		if (!isInitted()) {
			return false;
		}
		gPlayInstance.Achievements_unlock(id);
		return true;
	}

	public static function increment(id:String, step:Int) : Bool {
		if (!isInitted()) {
			return false;
		}
		gPlayInstance.Achievements_increment(id, step);
		return true;
	}

	public static function reveal(id:String) : Bool {
		if (!isInitted()) {
			return false;
		}
		gPlayInstance.Achievements_reveal(id);
		return true;
	}

	public static function setSteps(id:String, steps:Int) : Bool {
		if (!isInitted()) {
			return false;
		}
		gPlayInstance.Achievements_setStepsAtLeast(id, steps);
		return true;
	}

	//////////////////////////////////////////////////////////////////////
	///////////// COULD STORAGE
	//////////////////////////////////////////////////////////////////////

	public static function cloudSet(key:Int,value:String) : Bool {
		return false;
	}

	public static function cloudGet(key:Int):Bool{
		return false;
	}

	public static var onCloudGetComplete:Int->String->Void=null;
	public static var onCloudGetConflict:Int->String->String->Void=null;

	public static var onLoadGameComplete:String->String->Void=null;
	public static var onLoadGameConflict:String->String->String->Void=null;

	public static var displaySavedGames(default,null) : String->Bool->Bool->Int->Void = function(title:String, allowAddButton:Bool, allowDelete:Bool, maxNumberOfSavedGamesToShow:Int):Void{}
	public static var discardAndCloseGame(default,null) : Void->Bool = function():Bool { return false; }
	public static var commitAndCloseGame(default,null) : String->String->Bool = function(data:String, description:String):Bool { return false; }
	public static var loadSavedGame(default,null) : String->Void = function(name:String):Void{}

	//////////////////////////////////////////////////////////////////////
	///////////// UTILS: ID MANAGEMENT
	//////////////////////////////////////////////////////////////////////

	public static var id(default,null):Map<String,String>=new Map<String,String>();

	public static function loadResourcesFromXML(text:String){
		text=text.split("<resources>")[1];
		text=StringTools.replace(text,"<string name=\"","");
		for(line in text.split("</string>")){
			var arr=StringTools.trim(line).split("\">");
			if(arr.length!=2) continue;
			id.set(arr[0],arr[1]);
		}
	}

	public static function getID(alias:String):String{
		if(!id.exists(alias)){
			trace("CANT FIND ID FOR ALIAS: "+alias);
			trace("PLEASE MAKE SURE YOU'VE LOADED RESOURCES USING loadResourcesFromXML FIRST!");
			return null;
		}
		return id.get(alias);
	}

	public static var onLoginResult:Int->Void=null;

	//////////////////////////////////////////////////////////////////////
	///////////// GET PLAYER SCORE
	//////////////////////////////////////////////////////////////////////

	public static var onGetPlayerScore:String->Int->Void=null;

	public static function getPlayerScore(id:String) : Bool {
		if (!isInitted()) {
			return false;
		}
		gPlayInstance.Scores_get("me", id, TimeSpan.ALL_TIME).then(function(scoresResponse) {
			for (score in scoresResponse.items) {
				onGetScoreboard(score.leaderboard_id, score.scoreValue);
			}
		});
		return true;
	}

	static function onGetScoreboard(idScoreboard:String, score:Int) {
		if (onGetPlayerScore != null) onGetPlayerScore(idScoreboard, score);
	}

	//////////////////////////////////////////////////////////////////////
	///////////// ACHIEVEMENT STATUS
	//////////////////////////////////////////////////////////////////////

	public static var onGetPlayerAchievementStatus:String->Int->Void=null;

	static function _getAchievementStatus(id : String, pageToken : String = null) : Void {
		gPlayInstance.Achievements_list(id, 25, pageToken).then(function(result) {
			for (it in result.items) {
				if (it.id == id) {
					var state = switch (it.achievementState) {
						case UNLOCKED: 	ACHIEVEMENT_STATUS_UNLOCKED;
						default:		ACHIEVEMENT_STATUS_LOCKED;
					}
					onGetAchievementStatus(id, state);
				}
			}
			if (result.nextPageToken!=null) {
				_getAchievementStatus(id, pageToken);
			}
		});
	}

	public static function getAchievementStatus(id : String) : Bool {
		if (!isInitted()) {
			return false;
		}
		_getAchievementStatus(id);
		return true;
	}

	static function onGetAchievementStatus(idAchievement:String, state:Int) {
		if (onGetPlayerAchievementStatus != null) onGetPlayerAchievementStatus(idAchievement, state);
	}

	//////////////////////////////////////////////////////////////////////
	///////////// ACHIEVEMENTS CURRENT STEPS
	//////////////////////////////////////////////////////////////////////

	public static var onGetPlayerCurrentSteps:String->Int->Void=null;

	static function _getCurrentAchievementSteps(id : String, pageToken : String = null) : Void {
		gPlayInstance.Achievements_list(id, 25, pageToken).then(function(result) {
			for (it in result.items) {
				if (it.id == id) {
					onGetAchievementSteps(id, it.currentSteps);
				}
			}
			if (result.nextPageToken!=null) {
				_getCurrentAchievementSteps(id, pageToken);
			}
		});
	}

	public static function getCurrentAchievementSteps(id:String) : Bool {
		if (!isInitted()) {
			return false;
		}
		_getCurrentAchievementSteps(id);
		return true;
	}

	static function onGetAchievementSteps(idAchievement:String, steps:Int) {
		if (onGetPlayerCurrentSteps != null) onGetPlayerCurrentSteps(idAchievement, steps);
	}

}
