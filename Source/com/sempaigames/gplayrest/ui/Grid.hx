package com.sempaigames.gplayrest.ui;

import ru.stablex.ui.widgets.*;
import ru.stablex.ui.layouts.*;
import ru.stablex.ui.events.*;

class Grid extends Layout {

	public var childWidth(default, set) : Float;
	public var childHeight(default, set) : Float;
	public var childPadding(default, set) : Float;

	public function new() {
		super();
		childWidth = 300;
		childHeight = 400;
		childPadding = 15;
	}

	function set_childWidth(w : Float) : Float {
		this.childWidth = w;
		//arrangeChildren();
		return w;
	}

	function set_childHeight(h : Float) : Float {
		this.childHeight = h;
		//arrangeChildren();
		return h;
	}

	function set_childPadding(p : Float) : Float {
		this.childPadding = p;
		//arrangeChildren();
		return p;
	}

	override public function arrangeChildren(holder : Widget) : Void {

		if (#if neko
			childWidth==null  || childHeight==null || childPadding==null ||
			#end
			childWidth<=0 || childHeight<=0 || childPadding<=0 ) {
				return;
		}

		var childs = [];
		for (i in 0...holder.numChildren) {
			childs.push(holder.getChildAt(i));
		}

		var cols = Std.int((holder.w-childPadding)/(childWidth+childPadding));
		var colPos = 0;
		var rowPos = 0;
		var xCorrection = (holder.w - (childPadding*(cols-1) + (cols)*childWidth))/2;
		for (c in childs) {

			var ch = cast(c, Widget);
			ch.x = childPadding*(colPos) + colPos*childWidth + ((childs.length>=cols) ? xCorrection : childPadding);
			ch.y = childPadding*(rowPos+1) + rowPos*childHeight;
			ch.w = childWidth;
			ch.h = childHeight;

			colPos++;
			if (colPos>=cols) {
				colPos = 0;
				rowPos++;
			}

		}

		rowPos = colPos==0 ? rowPos-1 : rowPos;
		holder.h = (rowPos+1) * (childHeight+childPadding) + childPadding;

    }

}
