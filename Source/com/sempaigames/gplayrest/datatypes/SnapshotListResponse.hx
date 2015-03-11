package com.sempaigames.gplayrest.datatypes;

import haxe.Json;

class SnapshotListResponse extends GoogleDataType {

	public var nextPageToken(default, null) : String;
	public var items(default, null) : Array<Snapshot>;

	public function new(data : String) {
		super();
		var obj = Json.parse(data);
		verifyKind(obj, "games#snapshotListResponse");
		this.nextPageToken = obj.nextPageToken;
		this.items = [];
		for (it in cast(obj.items, Array<Dynamic>)) {
			this.items.push(new Snapshot(Json.stringify(it)));
		}
	}
}
