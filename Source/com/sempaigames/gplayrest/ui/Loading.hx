package com.sempaigames.gplayrest.ui;

import openfl.Lib;
import ru.stablex.ui.widgets.*;
import ru.stablex.ui.layouts.*;
import ru.stablex.ui.events.*;
import flash.display.*;
import flash.events.*;

class Loading extends Widget {
	
	var gear : Sprite;
	var lastTime : Int;

	public function new() {
		super();
		lastTime = 0;
		gear = new Sprite();
		this.addChild(gear);
		var bmp = new Bitmap(Stablex.getLoadingBmp());
		gear.addChild(bmp);
		gear.scaleX = gear.scaleY = 0.6;
		bmp.x = -bmp.width/2;
		bmp.y = -bmp.height/2;
		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		render();
	}

	function render() {

		gear.x = w/2;
		gear.y = h/2;

	}

	function onEnterFrame(_) {
		var now = Lib.getTimer();
		var diff = now - lastTime;
		gear.rotation += 0.15*diff;
		lastTime = now;
	}

	override public function onResize() : Void {
		super.onResize();
		render();
	}

}
