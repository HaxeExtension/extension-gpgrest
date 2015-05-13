package com.sempaigames.gplayrest;

#if cpp
import cpp.Lib;
import cpp.net.ThreadServer;
#end

#if neko
import neko.Lib;
import neko.net.ThreadServer;
#end

import haxe.io.Bytes;
import sys.net.Socket;

typedef Client = {
  var socket : Socket;
}

typedef Message = {
  var str : String;
}

class HttpServer extends ThreadServer<Client, Message> {

	public var onGet : Socket->String->Void;

	override function clientConnected(s : Socket) : Client {
		return { socket : s };
	}

	override function readClientMessage(c:Client, buf:Bytes, pos:Int, len:Int) {
		var msg = buf.getString(pos, len);
		return {msg: {str: msg}, bytes: len};
	}

	override function clientMessage(c : Client, msg : Message) {
		try {
			if (~/GET \/+/.match(msg.str)) {
				var get = msg.str.split(" ")[1];
				if (onGet!=null) {
					onGet(c.socket, get);
				}
			}
		} catch (e : Dynamic) {
			trace(e);
		}
	}

}
