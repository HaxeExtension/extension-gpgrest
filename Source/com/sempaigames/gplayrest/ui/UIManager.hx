package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.GPlay;
import extension.nativedialog.NativeDialog;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.system.Capabilities;

class UIManager {

	static var instance : UIManager = null;
	var maxScreenResolution : Float;
	var pushedUIelements : Array<DisplayObject>;
	var viewsStack : Array<UI>;

	public static function getInstance() {
		if (instance==null) {
			instance = new UIManager();
		}
		return instance;
	}

	function new() {
		maxScreenResolution = Math.max(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
		pushedUIelements = [];
		viewsStack = [];
		Lib.current.stage.addEventListener(Event.RESIZE, onResize);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, 1000);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, 1000);
	}

	function pushOriginalUIDown() {
		for (i in 0...Lib.current.stage.numChildren) {
			var c = Lib.current.stage.getChildAt(i);
			if ( !(Std.is(c, UI) && Lambda.has(viewsStack, cast(c, UI))) ) {
				c.y += maxScreenResolution;
				pushedUIelements.push(c);
			}
		}
	}

	function restoreOriginalUI() {
		for (c in pushedUIelements) {
			c.y -= maxScreenResolution;
		}
		pushedUIelements = [];
	}

	function updateOriginalUIStatus() {
		if (viewsStack.length>0 && pushedUIelements.length==0) {
			pushOriginalUIDown();
		} else if (viewsStack.length==0 && pushedUIelements.length>0) {
			restoreOriginalUI();
		}
	}

	function onKeyDown(e : KeyboardEvent) {
		e.stopImmediatePropagation();
	}

	function onKeyUp(e : KeyboardEvent) {
		var v = viewsStack[viewsStack.length-1];
		if (v!=null) {
			v.onKeyUp(e);
		}
		e.stopImmediatePropagation();
		e.stopPropagation();
	}

	function onResize(e : Event) {
		var v = viewsStack[viewsStack.length-1];
		if (v!=null) {
			v.onResize(e);
		}
	}

	public function showAchievements(gplay : GPlay) {
		var v = new AchievementsUI(gplay);
		viewsStack.push(v);
		Lib.current.stage.addChild(v);
		v.onResize(null);
		updateOriginalUIStatus();
	}

	public function showAllLeaderboards(gplay : GPlay) {
		var v = new AllLeaderboardsUI(gplay);
		viewsStack.push(v);
		Lib.current.stage.addChild(v);
		v.onResize(null);
		updateOriginalUIStatus();
	}

	public function showLeaderboard(gplay : GPlay, id : String) {
		var v = new LeaderboardUI(gplay, id);
		viewsStack.push(v);
		Lib.current.stage.addChild(v);
		v.onResize(null);
		updateOriginalUIStatus();
	}

	public function closeCurrentView() {
		if (viewsStack.length>0) {
			var v = viewsStack.pop();
			Lib.current.stage.removeChild(v);
			v.onClose();
		}
		updateOriginalUIStatus();
	}

	public function onNetworkError() {
		NativeDialog.showMessage("Network error", "", "Ok");
		while (viewsStack.length>0) {
			closeCurrentView();
		}
	}

}
