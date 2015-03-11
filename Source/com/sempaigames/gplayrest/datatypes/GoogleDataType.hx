package com.sempaigames.gplayrest.datatypes;

class GoogleDataType {

	public function new() {

	}

	function verifyKind(obj : Dynamic, kind : String) {
		if (obj.kind==null) {
			throw 'Invalid kind, expected: $kind, got null';
		}
		if (obj.kind!=kind) {
			throw 'Invalid kind, expected: $kind, got ${obj.kind}';
		}
	}

	public function toString() {
		var str = "{\n";
		for (field in Reflect.fields(this)) {
			str += '$field = ${Reflect.field(this, field)}\n';
		}
		str += "}\n";
		return str;
	}

}
