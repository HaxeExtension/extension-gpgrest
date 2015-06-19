package com.sempaigames.gplayrest.ui;

import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.Lib;
import ru.stablex.ui.events.WidgetEvent;
import ru.stablex.ui.skins.*;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.*;

class LeaderboardOptions extends Button {

	public var options(default, set) : Array<Array<Dynamic>>;
	public var value(get, set) : Dynamic;

	var box : Box;
	var list : Floating;
	var optionDefaults : String = 'Default';
	var selectedIdx(default, set) : Int;

	public function new() {

		super();
		selectedIdx = 0;

		this.list = UIBuilder.create(Floating);
		this.format.font = "Arial";
		this.format.size = 30;
		this.format.color = 0xffffff;

		this.box = UIBuilder.create(Box);
		box.padding = 0;
		box.childPadding = 4;
		box.skin = new Paint();
		cast(box.skin, Paint).color = Stablex.color2;
		this.list.addChild(this.box);

		this.addEventListener(MouseEvent.CLICK, this.toggleList);
		this.list.addEventListener(MouseEvent.CLICK, this.toggleList);

		this.ico.bitmapData = Stablex.getOptionsIcon();
		this.ico.scaleX = this.ico.scaleY = 1.5;
		this.icoBeforeLabel = false;
		this.apart = true;
		this.paddingRight = 30;

		this.onHout = function(_) { refresh(); };
		this.onHover = function(_) { refresh(); };
		this.onPress = function(_) { refresh(); };
		this.onRelease = function(_) { refresh(); };

	}

	function get_value() : Dynamic {
		if (this.options == null || this.options.length <= this.selectedIdx) {
			return null;
		} else {
			return this.options[this.selectedIdx][1];
		}
	}

	function set_value(v:Dynamic) : Dynamic {
		if (this.options != null) {
			for (i in 0...this.options.length) {
				if (this.options[i][1] == v) {
					this.selectedIdx = i;
					break;
				}
			}
		}
		return v;
	}

	function set_selectedIdx(idx:Int) : Int {
		if (idx!=this.selectedIdx && this.options!=null) {
			this.selectedIdx = idx;
			this.text = this.options[idx][0];
			this.dispatchEvent(new WidgetEvent(WidgetEvent.CHANGE));
			refresh();
		}
		return idx;
	}

	function set_options(options : Array<Array<Dynamic>>) : Array<Array<Dynamic>> {
		this.options = options;
		this.text = options[0][0];
		buildList();
		selectedIdx = 0;
		return options;
	}

	private function buildList() : Void {
		if (this.options == null) {
			return;
		}
		this.box.freeChildren();
		var btns = [];
		for (i in 0...this.options.length) {
			var btn = UIBuilder.create(Toggle, {
				defaults : this.optionDefaults,
				selected : (this.selectedIdx == i),
				name     : Std.string(i),
				text     : this.options[i][0],
				w        : this.w,
				h        : 60
			});
			btn.format.font = "Arial";
			btn.format.size = 25;
			this.box.addChild(btn).addEventListener(MouseEvent.CLICK, this._onSelectOption);
		}
		this.box.refresh();
		this.list.refresh();
	}

	public function toggleList(e : MouseEvent = null) : Void {
		if (this.list.shown) {
			Lib.current.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this._onClickStage);
			this.list.hide();
			this.ico.bitmapData = Stablex.getOptionsIcon();
		} else {
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, this._onClickStage);
			this.list.show();
			this.ico.bitmapData = Stablex.getOptionsIcon2();
		}
		var p : Point = this.getAlignedListCoordinates();
		this.list.left = p.x;
		this.list.top  = p.y;
		refresh();
	}

	private function _onSelectOption(e:MouseEvent) : Void {
		var obj : Button = cast e.currentTarget;
		if (obj!=null) {
			var idx : Int = Std.parseInt(obj.name);
			if (this.options!=null && this.options.length>idx) {
				this.selectedIdx = idx;
			}
		}
	}

	override public function free(recursive:Bool = true) : Void {
		this.list.free();
		super.free(recursive);
	}

	override public function refresh() {
		super.refresh();
		for (i in 0...box.numChildren) {
			var c : Toggle = cast box.getChildAt(i);
			c.w = this.w;
			if (i==selectedIdx && !c.selected || i!=selectedIdx && c.selected) {
				c.toggle();
			}
		}
		this.label.x = this.w/2 - this.label.width/2;
	}

	function getAlignedListCoordinates() : Point {
		var target = this.list.getRenderTarget();
		var p : Point = this.localToGlobal(new Point(0, 0));
		p = target.globalToLocal(p);
		p.x += (this.w - this.list.w) / 2;
		p.y += this.h + 2;
		return p;
	}

	private function _onClickStage (e:MouseEvent) : Void {
		if (!this.list.shown) return;

		var obj : DisplayObject = e.target;
		while (obj != null) {
			//clicked this widget
			if (obj==this || obj==this.list) {
				return;
			}
			obj = obj.parent;
		}

		this.toggleList();
	}

}
