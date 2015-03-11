package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class SnapshotImage extends GoogleDataType {

	public var width(default, null) : Int;
    public var height(default, null) : Int;
    public var mime_type(default, null) : String;
    public var url(default, null) : String;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#snapshotImage");
		Macro.assign(this, obj, [
			"width",
			"height",
			"mime_type",
			"url"
		]);
	}

}