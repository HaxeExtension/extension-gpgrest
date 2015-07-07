package com.sempaigames.gplayrest.ui;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import openfl.system.Capabilities;

class UI extends Sprite {

	var sx : Float;
	var sy : Float;

	function new() {
		super();
		#if mobile
		this.sx = Capabilities.screenResolutionX;
		this.sy = Capabilities.screenResolutionY;
		#else
		this.sx = Lib.current.stage.stageWidth;
		this.sy = Lib.current.stage.stageHeight;
		#end
	}

	public function onClose() : Void {}
	public function onKeyUp(e : KeyboardEvent) : Void {}
	public function onResize(e : Event) : Void {}

}
