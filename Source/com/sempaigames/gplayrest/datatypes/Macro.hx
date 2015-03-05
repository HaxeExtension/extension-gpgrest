package com.sempaigames.gplayrest.datatypes;

import haxe.macro.Expr;
import haxe.macro.Context;

class Macro {
	
	macro static public function assign(receptor : Expr, origen : Expr, fields : Array<String>) : Expr {
		var exprs : Array<Expr> = [];
		for (field in fields) {
			var x_ : Expr = { expr : EField(receptor, field), pos : Context.currentPos() };
			var y_ : Expr = { expr : EField(origen, field), pos : Context.currentPos() };
			var assign : Expr = { expr : EBinop(OpAssign, x_, y_), pos : Context.currentPos() };
			exprs.push(assign);
		}
		var ret : Expr = {
			expr : EBlock(exprs),
			pos : Context.currentPos()
		}
		return ret;
	}

}
