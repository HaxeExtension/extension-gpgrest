package com.sempaigames.gplayrest.ui;

import flash.display.CapsStyle;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class ProgressBmp extends UrlBmp {

	public var txt : TextField;
	public var progress(default, set) : Float;
	public var textColor(default, set) : Int;
	public var textSize(default, set) : Float;
	public var color1(default, set) : Int;
	public var color2(default, set) : Int;

	public function new() {
		super();
		txt = new TextField();
		addChildAt(txt, 0);
		txt.autoSize = TextFieldAutoSize.LEFT;
		textColor = 0xffffff;
		color1 = Stablex.color3;
		color2 = 0x8bc34a;
		progress = 0;
		render();
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

	function render() {
		#if neko
		if (color1==null || color2==null || progress==null) {
			return;
		}
		#end
		var gfx = this.graphics;
		gfx.clear();
		var lWidth = w*0.15;
		gfx.lineStyle(lWidth, color1);
		gfx.drawCircle(w/2, h/2, w/2 - lWidth/2);
		gfx.lineStyle(lWidth, color2, true, CapsStyle.NONE);
		drawArc(this, w/2, h/2, w/2 - lWidth/2, -90, 360*progress-90, 0.2);
		txt.text = Std.int(progress*100) + "%";
		updateTextFormat();

	}

	function set_color1(color1 : Int) : Int {
		this.color1 = color1;
		render();
		return color1;
	}

	function set_color2(color2 : Int) : Int {
		this.color2 = color2;
		render();
		return color2;
	}

	function set_progress(progress : Float) : Float {
		this.progress = Math.min(Math.max(progress, 0.0), 1.0);
		render();
		return progress;
	}

	function updateTextFormat() {
		var format = new TextFormat("Arial", textSize, textColor, TextFormatAlign.CENTER);
		txt.setTextFormat(format);
		onResize();
	}

	function set_textColor(color : Int) : Int {
		this.textColor = color;
		updateTextFormat();
		return color;
	}

	function set_textSize(textSize : Float) : Float {
		this.textSize = textSize;
		updateTextFormat();
		return textSize;
	}

	override public function onResize() : Void {
		super.onResize();
		txt.x = w/2 - txt.width/2;
		txt.y = h/2 - txt.height/2;
	}

	override function refresh() {
		super.refresh();
		txt.visible = this.bitmapData==null;
	}

}
