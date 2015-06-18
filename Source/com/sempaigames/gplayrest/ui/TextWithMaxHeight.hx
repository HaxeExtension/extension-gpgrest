package com.sempaigames.gplayrest.ui;

import flash.text.TextFormatAlign;
import ru.stablex.ui.widgets.Text;

class TextWithMaxHeight extends Text {

	public var maxHeight(default, set) : Float;

	public function new() {
		super();
		this.format.align = TextFormatAlign.CENTER;
	}

	function set_maxHeight(maxHeight : Float) : Float {
		this.maxHeight = maxHeight;
		return maxHeight;
	}

	override function refresh() {
		super.refresh();
		var entered = false;
		while (label.height>maxHeight && text.length>0) {
			text = text.substr(0, text.length-1);
			entered = true;
		}
		if (entered && text.length>3) {
			text = text.substr(0, text.length-3) + "...";
		}
	}

}
