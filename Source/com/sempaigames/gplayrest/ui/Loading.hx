package com.sempaigames.gplayrest.ui;

import ru.stablex.ui.widgets.*;
import ru.stablex.ui.layouts.*;
import ru.stablex.ui.events.*;
import flash.display.*;
import flash.events.*;

class Loading extends Widget {
	
	var gear : Sprite;

	public function new(w : Float, h : Float) {
		super();
		this.w = w;
		this.h = h;
		var radius = Math.min(w, h)/2;

		gear = new Sprite();

		var tmp = new Sprite();
		var gfx = tmp.graphics;
		gfx.beginFill(0xffffff);
		
		gfx.drawCircle(radius, radius, radius);
		gfx.drawRect(-radius*0.2, radius*0.8, radius*2.4, radius*0.4);
		gfx.drawRect(radius*0.8, -radius*0.2, radius*0.4, radius*2.4);

		gfx.endFill();
		tmp.x = -radius;
		tmp.y = -radius;
		gear.addChild(tmp);
		gear.y = radius*1.2;

		this.addChild(gear);
		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	function onEnterFrame(_) {
		gear.rotation += 2;
	}

}
