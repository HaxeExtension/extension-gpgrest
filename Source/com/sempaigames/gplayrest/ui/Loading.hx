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
		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		render();
	}

	function render() {
		var radius = Math.min(w, h)/2;


		var tmp = new Sprite();
		var gfx = tmp.graphics;
		gfx.beginFill(0);
		gfx.drawRect(0, 0, radius*2, radius*2);

		gfx.beginFill(0xff00ff);
		gfx.drawCircle(radius, radius, radius*0.8);
		/*
		gfx.drawRect(-radius*0.2, radius*0.8, radius*2.4, radius*0.4);
		gfx.drawRect(radius*0.8, -radius*0.2, radius*0.4, radius*2.4);
		*/

		gfx.endFill();
		tmp.x = -radius;
		tmp.y = -radius;
		while (gear.numChildren>0) {
			gear.removeChildAt(0);
		}
		gear.addChild(tmp);
		gear.x = w/2;
		gear.y = h/2;

	}

	function onEnterFrame(_) {
		var now = Lib.getTimer();
		var diff = now - lastTime;
		gear.rotation += 0.1*diff;
		lastTime = now;
	}

	override public function onResize() : Void {
		super.onResize();
		render();
	}

}
