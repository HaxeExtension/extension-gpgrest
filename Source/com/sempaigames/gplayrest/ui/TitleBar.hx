package com.sempaigames.gplayrest.ui;

import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import ru.stablex.ui.widgets.*;

class TitleBar extends Widget {

	public var title(default, set) : String;
	public var onBack : Void->Void;

	var txtField : TextField;
	var backBtn : Sprite;
	public var backBtnImg : Sprite;

	public var leftMargin(default, set) : Float;
	public var logoImg(default, set) : Bmp;
	public var rightMargin(default, set) : Float;

	public function new() {
		super();
		
		txtField = new TextField();
		txtField.selectable = false;
		txtField.text = "Test";
		txtField.autoSize = TextFieldAutoSize.LEFT;
		
		addChild(txtField);

		this.widthPt = 100;
		this.h = 100;

		backBtn = new Sprite();
		backBtnImg = new Sprite();
		backBtnImg.addChild(new Bitmap(Stablex.getBackBmp(), PixelSnapping.ALWAYS, true));
		backBtn.addChild(backBtnImg);

		this.addEventListener(MouseEvent.CLICK, onClick);
		
		backBtnImg.scaleX = backBtnImg.scaleY = 1;
		var scale = Math.min(100/backBtnImg.width, this.h*0.5/backBtnImg.height);
		backBtnImg.scaleX = backBtnImg.scaleY = scale;

		addChild(backBtn);

		logoImg = null;

		leftMargin = rightMargin = 0;

		onResize();
	}

	function onClick(m : MouseEvent) {
		if (m.stageX<this.width/3) {
			__onBack();
		}
	}

	function __onBack() {
		if (onBack!=null) {
			onBack();
		}
	}

	function set_title(title : String) : String {
		this.title = title;
		txtField.text = title;
		
		var format = new TextFormat(30, 0xffffff);
		format.font = "Arial";
		format.bold = true;
		txtField.setTextFormat(format);

		onResize();

		return title;
	}

	public function set_logoImg(bmp : Bmp) : Bmp {
		if (bmp==null) {
			return null;
		}
		removeChild(logoImg);
		addChild(bmp);
		return this.logoImg = bmp;
	}

	public function set_leftMargin(margin : Float) : Float {
		this.leftMargin = margin;
		onResize();
		return margin;
	}

	public function set_rightMargin(margin : Float) : Float {
		this.rightMargin = margin;
		onResize();
		return margin;
	}

	override public function onResize() : Void {
		super.onResize();
		
		txtField.x = w/2 - txtField.width/2;
		txtField.y = h/2 - txtField.height/2;

		backBtn.graphics.clear();
		backBtn.graphics.beginFill(Stablex.color1);
		backBtn.graphics.drawRect(0, 0, this.h, this.h);
		backBtn.graphics.endFill();

		backBtnImg.x = leftMargin;
		backBtnImg.y = backBtn.height/2 - backBtnImg.height/2;

		if (logoImg!=null) {
			logoImg.x = Lib.current.stage.stageWidth - rightMargin - logoImg.width;
		}

		var gfx = this.graphics;
		gfx.beginFill(Stablex.color1);
		gfx.drawRect(0, 0, this.w, this.h);
		gfx.endFill();

		backBtnImg.x = 15;

	}

}
