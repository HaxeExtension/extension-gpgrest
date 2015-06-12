package com.sempaigames.gplayrest.ui;

import flash.display.*;
import flash.events.Event;
import flash.geom.Matrix;
import flash.utils.ByteArray;
import ru.stablex.ui.widgets.*;

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
			var cachedBmp = null;
			try {
				cachedBmp = BmpDataCache.getInstance().get(url);
			} catch (d : Dynamic) { trace("Catched: " + d); }
			if (cachedBmp!=null && false) {
				onBitmapDataLoaded(cachedBmp);
			} else {
				UrlLoader.load(url,
					function(data) {
						onLoadComplete(url, data);
					},
					function() {
						onBitmapDataLoaded(Stablex.getAvatarDefaultBmp());
					}
				);
			}
		}
		return url;
	}

	function onLoadComplete(url : String, data : String) {
		var arr = new ByteArray();
		arr.writeUTFBytes(data);
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
