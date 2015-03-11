package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class Snapshot extends GoogleDataType {

	public var id(default, null) : String;
	public var driveId(default, null) : String;
	public var uniqueName(default, null) : String;
	public var type(default, null) : String;
	public var title(default, null) : String;
	public var description(default, null) : String;
	public var coverImage(default, null) : SnapshotImage;
	public var lastModifiedMillis(default, null) : Int;
	public var durationMillis(default, null) : Int;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#snapshot");
		Macro.assign(this, obj, [
			"id",
			"driveId",
			"uniqueName",
			"type",
			"title",
			"description",
			"lastModifiedMillis",
			"durationMillis"
		]);
		if (obj.coverImage!=null) {
			this.coverImage = new SnapshotImage(Json.stringify(obj.coverImage));
		}
	}

}
