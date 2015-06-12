package com.sempaigames.gplayrest.ui;

import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import ru.stablex.ui.widgets.*;

class TitleBar extends Widget {

	public var title(default, set) : String;
	public var onBack : Void->Void;

	var txtField : TextField;
	var backBtn : Sprite;
	var backBtnImg : Sprite;

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

		backBtn.addEventListener(MouseEvent.CLICK, __onBack);
		
		backBtnImg.scaleX = backBtnImg.scaleY = 1;
		var scale = Math.min(100/backBtnImg.width, this.h*0.5/backBtnImg.height);
		backBtnImg.scaleX = backBtnImg.scaleY = scale;

		addChild(backBtn);

		onResize();
	}

	function __onBack(_) {
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

	override public function onResize() : Void {
		super.onResize();
		
		txtField.x = w/2 - txtField.width/2;
		txtField.y = h/2 - txtField.height/2;

		backBtn.graphics.clear();
		backBtn.graphics.beginFill(Stablex.color1);
		backBtn.graphics.drawRect(0, 0, this.h, this.h);
		backBtn.graphics.endFill();

		backBtnImg.x = backBtn.width/2 - backBtnImg.width/2;
		backBtnImg.y = backBtn.height/2 - backBtnImg.height/2;

		var gfx = this.graphics;
		gfx.beginFill(Stablex.color1);
		gfx.drawRect(0, 0, this.w, this.h);
		gfx.endFill();

	}

}
