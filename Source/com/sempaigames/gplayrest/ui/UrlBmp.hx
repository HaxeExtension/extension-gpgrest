package com.sempaigames.gplayrest.ui;

import flash.geom.Matrix;
import ru.stablex.ui.widgets.*;
import flash.events.Event;
import flash.display.*;
import flash.utils.ByteArray;

class UrlBmp extends Bmp {

	public var url(default, set) : String;

	public function new() {
		super();
	}

	function set_url(url : String) : String {
		this.url = url;
		var size = Std.int(Math.max(this.w, this.h));
		if (url!=null) {
			url+='=-s$size';
			var cachedBmp = BmpDataCache.getInstance().get(url);
			if (cachedBmp!=null) {
				trace("load cached bmp : " + url);
				onBitmapDataLoaded(cachedBmp);
			} else {
				UrlLoader.load(url, onLoadComplete.bind(url));
			}
		}
		return url;
	}

	function onLoadComplete(url : String, e : Event) {
		var b : String = e.target.data;
		var arr = new ByteArray();
		arr.writeUTFBytes(b);
		if (arr.length==0) {
			return;
		}
		var bmpData : BitmapData = BitmapData.loadFromBytes(arr);
		BmpDataCache.getInstance().set(url, bmpData);
		onBitmapDataLoaded(bmpData);
	}

	function onBitmapDataLoaded(bmpData : BitmapData) {
		this.bitmapData = bmpData;
		this.refresh();
	}

}
