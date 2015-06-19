package com.sempaigames.gplayrest.ui;

import flash.display.*;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.utils.ByteArray;
import ru.stablex.ui.widgets.*;

class UrlBmp extends Bmp {

	public var bmpMask(default, set) : BitmapData;
	public var url(default, set) : String;
	public var useAvatarDefaultBmp : Bool;
	var maskSpr : Sprite;

	public function new() {
		super();
		maskSpr = new Sprite();
		this.addChild(maskSpr);
		useAvatarDefaultBmp = false;
	}

	function set_bmpMask(bmpMask : BitmapData) {
		this.bmpMask = bmpMask;
		
		while (maskSpr.numChildren>0) {
			maskSpr.removeChildAt(0);
		}
		var bmp = new Bitmap(bmpMask, true);
		maskSpr.addChild(bmp);
		
		return bmpMask;
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
			if (cachedBmp!=null) {
				onBitmapDataLoaded(cachedBmp);
			} else {
				UrlLoader.load(url,
					function(data) {
						onLoadComplete(url, data);
					},
					function() {
						if (useAvatarDefaultBmp) {
							onBitmapDataLoaded(Stablex.getAvatarDefaultBmp());
						}
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

	override function refresh() {
		super.refresh();
		maskSpr.scaleX = maskSpr.scaleY = 1;
		maskSpr.scaleX = maskSpr.scaleY = w/maskSpr.width;
	}

}
