package com.sempaigames.gplayrest.ui;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import haxe.crypto.Md5;
#if (cpp || neko)
import sys.FileSystem;
import sys.io.File;
#end

class BmpDataCache {

	static var cacheDir = "data";
	static var instance : BmpDataCache;
	static var maxDaysOld = 10;

	public static function getInstance() {
		if (instance==null) {
			instance = new BmpDataCache();
		}
		return instance;
	}

	function new() {
		#if (cpp || neko)
		try {
			if (!FileSystem.exists(cacheDir)) {
				FileSystem.createDirectory(cacheDir);
			}
		} catch (d : Dynamic) {

		}
		#end
	}

	function daysOld(path : String) : Int {
		#if (cpp || neko)
		try {
			var d = Date.now().getDay()-FileSystem.stat(path).mtime.getDay();
			return d<0 ? -d : d;
		} catch (d : Dynamic) {
			return 9999;
		}
		#else
			return 0;
		#end
	}

	public function get(name : String) : BitmapData {
		#if (cpp || neko)
		try {
			var path = cacheDir + "/" + Md5.encode(name);
			if (FileSystem.exists(path) && daysOld(path)<maxDaysOld) {
				var arr = File.getBytes(path);
				#if openfl_legacy
				var bmp = BitmapData.loadFromBytes(ByteArray.fromBytes(arr));
				#else
				var bmp = BitmapData.fromBytes(ByteArray.fromBytes(arr));
				#end
				return bmp;
			} else {
				return null;
			}
		} catch (error : Dynamic) {
			trace("d: " + error);
		}
		#end
		return null;
	}

	public function set(name : String, bmpData : BitmapData) {
		#if (cpp || neko)
		var path = cacheDir + "/" + Md5.encode(name);
		#if openfl_legacy
		var arr = bmpData.encode("png", 1);
		#else
		var arr = bmpData.encode(new Rectangle(0, 0, bmpData.width, bmpData.height), "png");
		#end
		File.saveBytes(path, arr);
		#end
	}

}
