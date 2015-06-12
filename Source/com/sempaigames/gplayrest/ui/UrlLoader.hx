package com.sempaigames.gplayrest.ui;

import flash.events.*;
import flash.net.*;

class UrlLoader {
	
	static var availableConnections : Int = 8;
	static var pendingLoads : Array<{url : String, onLoadComplete : String->Void}> = [];

	public static function load(url : String, onLoadComplete : String->Void, onLoadFailed : Void->Void = null) {
		if (availableConnections<=0) {
			pendingLoads.push({url : url, onLoadComplete : onLoadComplete});
		} else {
			availableConnections--;
			
			var ldr = new URLLoader();
			ldr.addEventListener(Event.COMPLETE, function(e : Event) {
				var s : String = e.target.data;
				onLoadComplete(s);
				onDownloadFinished();
			} );
			ldr.addEventListener(IOErrorEvent.IO_ERROR, function(_) {
				if (onLoadFailed!=null) {
					onLoadFailed();
				}
				onDownloadFinished();
			});
			ldr.load(new URLRequest(url));
		}
	}

	static function onDownloadFinished() {
		availableConnections++;
		if (pendingLoads.length>0) {
			var ld = pendingLoads.shift();
			load(ld.url, ld.onLoadComplete);
		}
	}

}
