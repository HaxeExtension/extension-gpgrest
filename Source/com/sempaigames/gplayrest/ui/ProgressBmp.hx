package com.sempaigames.gplayrest.ui;

import flash.display.CapsStyle;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class ProgressBmp extends UrlBmp {
	
	var txt : TextField;
	public var progress(default, set) : Float;

	public function new() {
		super();
		txt = new TextField();
		addChild(txt);
		txt.textColor = 0xffffff;
		txt.autoSize = TextFieldAutoSize.LEFT;
		var format = new TextFormat(30, 0xffffff);
		format.font = "Arial";
		txt.defaultTextFormat = format;
	}

	public inline static function degToRad(deg:Float) : Float {
	    return Math.PI / 180 * deg;
	}

	public function drawArc(
			mc : Sprite,
			centerX : Float,
			centerY : Float,
			radius : Float,
			angleFrom : Float,
			angleTo : Float,
			precision : Float) {
		var angleDiff = angleTo - angleFrom;
		var steps = Math.round(angleDiff*precision);
		var angle = angleFrom;
		var px = centerX + radius*Math.cos(degToRad(angle));
		var py = centerY + radius*Math.sin(degToRad(angle));
		mc.graphics.moveTo(px, py);
		for (i in 1...(steps+1)) {
			angle=angleFrom+angleDiff/steps*i;
			mc.graphics.lineTo(centerX+radius*Math.cos(degToRad(angle)), centerY+radius*Math.sin(degToRad(angle)));
		}
	}

	function set_progress(progress : Float) : Float {
		this.progress = Math.min(Math.max(progress, 0.0), 1.0);
		var gfx = this.graphics;
		gfx.clear();
		gfx.lineStyle(2, 0xeeeeee);
		gfx.drawCircle(w/2, h/2, w/2);
		var lWidth = w*0.15;
		gfx.lineStyle(lWidth, 0x119911, true, CapsStyle.NONE);
		drawArc(this, w/2, h/2, w/2-lWidth/2-1, -90, 360*progress-90, 0.2);
		txt.text = Std.int(progress*100) + "%";
		onResize();
		return progress;
	}

	override public function onResize() : Void {
		super.onResize();
		txt.x = w/2 - txt.width/2;
		txt.y = h/2 - txt.height/2;
    }

}
