package com.sempaigames.gplayrest.ui;

import flash.display.BitmapData;
import ru.stablex.ui.UIBuilder;

@:bitmap("Assets/gplusweb_back.png") class BackBmp extends BitmapData {}

class Stablex {
	
	static var initted : Bool = false;

	public static function init() {
		if (!initted) {
			UIBuilder.setTheme('ru.stablex.ui.themes.android4');
			UIBuilder.init('com/sempaigames/gplayrest/ui/xml/defaults.xml');
			UIBuilder.regClass('UrlBmp');
			UIBuilder.regClass('ProgressBmp');
			UIBuilder.regClass('Loading');
			UIBuilder.regClass('Grid');
			initted = true;
		}
	}

	public static function getBackBmp() {
		return new BackBmp(0, 0);
	}


}
