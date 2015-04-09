package com.sempaigames.gplayrest.ui;

import flash.events.*;
import flash.net.*;

class UrlLoader {
	
	static var availableConnections : Int = 8;
	static var pendingLoads : Array<{url : String, onLoadComplete : Event->Void}> = [];

	public static function load(url : String, onLoadComplete : Event->Void) {
		if (availableConnections<=0) {
			pendingLoads.push({url : url, onLoadComplete : onLoadComplete});
		} else {
			availableConnections--;
			var ldr = new URLLoader();
			ldr.addEventListener(Event.COMPLETE, function(e) { onDownloadFinished(); onLoadComplete(e); } );
			ldr.addEventListener(IOErrorEvent.IO_ERROR, function(_) onDownloadFinished());
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
