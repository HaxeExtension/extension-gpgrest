package com.sempaigames.gplayrest.ui;

import ru.stablex.ui.widgets.*;
import flash.events.*;
import flash.net.*;
import flash.display.*;
import flash.utils.ByteArray;

class UrlBmp extends Bmp {
	
	var size : Float;

	public function new(url : String, size : Float) {
		super();
		this.autoSize = true;
		var req = new URLRequest(url);
		var ldr = new URLLoader();
		ldr.addEventListener(Event.COMPLETE, onLoadComplete);
		ldr.load(req);
		this.size = size;
		var gfx = this.graphics;
		gfx.beginFill(0x222222);
		gfx.drawRect(0, 0, size, size);
		gfx.endFill();
	}

	function onLoadComplete(e : Event) {
		
		var b : String = e.target.data;
		var arr = new ByteArray();
		arr.writeUTFBytes(b);
		if (arr.length==0) {
			return;
		}
		var bmpData : BitmapData = BitmapData.loadFromBytes(arr);
		this.bitmapData = bmpData;

		this.refresh();

		if (bmpData.width!=0) {
			this.scaleX = size / bmpData.width;
		}

		if (bmpData.height!=0) {
			this.scaleY = size / bmpData.height;
		}

	}

}
