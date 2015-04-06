package com.sempaigames.gplayrest.ui;

import flash.geom.Matrix;
import ru.stablex.ui.widgets.*;
import flash.events.*;
import flash.net.*;
import flash.display.*;
import flash.utils.ByteArray;

class UrlBmp extends Bmp {
	
	public var url(default, set) : String;

	public function new() {
		super();
	}

	function set_url(url : String) : String {
		this.url = url;
		var req = new URLRequest(url);
		var ldr = new URLLoader();
		if (url!=null) {
			ldr.addEventListener(Event.COMPLETE, onLoadComplete);
			ldr.load(req);
		}
		return url;
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

	}

}
