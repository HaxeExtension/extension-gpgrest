package com.sempaigames.gplayrest.ui;

import ru.stablex.ui.UIBuilder;

class Stablex {
	
	static var initted : Bool = false;

	public static function init() {
		if (!initted) {
			UIBuilder.setTheme('ru.stablex.ui.themes.android4');
			UIBuilder.init('com/sempaigames/gplayrest/ui/xml/defaults.xml');
			UIBuilder.regClass('UrlBmp');
			UIBuilder.regClass('Loading');
			initted = true;
		}
	}

}
