package com.sempaigames.gplayrest.datatypes;

import haxe.macro.Expr;
import haxe.macro.Context;

class Macro {
	
	macro static public function assign(x : Expr, y : Expr, fields : Array<String>) : Expr {
		var exprs = [];
		for (field in fields) {
			exprs.push(macro { $x.$field = $y.$field; });
		}
		return macro $b{exprs};
	}

}
