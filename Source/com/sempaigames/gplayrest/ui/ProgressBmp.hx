package com.sempaigames.gplayrest.ui;

class ProgressBmp extends UrlBmp {
	
	public var progress(default, set) : Float;

	public function new() {
		super();
	}

	function set_progress(progress : Float) : Float {
		this.progress = Math.min(Math.max(progress, 0.0), 1.0);
		var gfx = this.graphics;
		gfx.clear();
		gfx.beginFill(0xffffff);
		gfx.drawRect(0, 0, w, h);
		gfx.beginFill(0x119911);
		gfx.drawRect(0, h-h*progress, w, h*progress);
		gfx.endFill();
		return progress;
	}

}
