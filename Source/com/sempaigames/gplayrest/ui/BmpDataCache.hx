package com.sempaigames.gplayrest.ui;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import haxe.crypto.Md5;

class BmpDataCache {

	static var instance : BmpDataCache;
	var so : SharedObject;

	public static function getInstance() {
		if (instance==null) {
			instance = new BmpDataCache();
		}
		return instance;
	}

	function new() {
		so = SharedObject.getLocal("gplusweb_bmpcache");
	}

	public function get(name : String) : BitmapData {
		var ret = Reflect.getProperty(so.data, Md5.encode(name));
		return ret;
	}

	public function set(name : String, bmpData : BitmapData) {
		Reflect.setField(so.data, Md5.encode(name), bmpData);
	}

}
