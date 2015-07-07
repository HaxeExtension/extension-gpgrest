package com.sempaigames.gplayrest.ui;

import flash.display.BitmapData;
import flash.text.Font;
import flash.utils.ByteArray;
import ru.stablex.ui.UIBuilder;

@:bitmap("Assets/avatar_default.png") class AvatarDefault extends BitmapData {}
@:bitmap("Assets/gplusweb_back.png") class BackBmp extends BitmapData {}
@:bitmap("Assets/loading.png") class LoadingBmp extends BitmapData {}
@:bitmap("Assets/mask.png") class MaskBmp extends BitmapData {}
@:bitmap("Assets/options_icon.png") class OptionsIcon extends BitmapData {}
@:bitmap("Assets/options_icon2.png") class OptionsIcon2 extends BitmapData {}
@:file("Assets/gamesleaderboard.json") class GamesLeaderBoard extends ByteArray {}
@:file("Assets/leaderboardscores.json") class LeaderboardsScores extends ByteArray {}
@:file("Assets/leaderboardslistresponse.json") class LeaderboardsListResponse extends ByteArray {}

class Stablex {

	static var initted : Bool = false;

	public static var color1 : Int = 0x064030;
	public static var color2 : Int = 0x228866;
	public static var color3 : Int = 0x1c7054;

	public static function init() {

		if (!initted) {

			UIBuilder.regClass('Grid');
			UIBuilder.regClass('LeaderboardOptions');
			UIBuilder.regClass('Loading');
			UIBuilder.regClass('ProgressBmp');
			UIBuilder.regClass('TextWithMaxHeight');
			UIBuilder.regClass('TitleBar');
			UIBuilder.regClass('UrlBmp');

			UIBuilder.setTheme('com.sempaigames.gplayrest.ui.theme');
			UIBuilder.init('com/sempaigames/gplayrest/ui/xml/defaults.xml');

			initted = true;
		}

	}

	public static function getAvatarDefaultBmp() {
		return new AvatarDefault(0, 0);
	}

	public static function getBackBmp() {
		return new BackBmp(0, 0);
	}

	public static function getLoadingBmp() {
		return new LoadingBmp(0, 0);
	}

	public static function getMaskBmp() {
		return new MaskBmp(0, 0);
	}

	public static function getOptionsIcon() {
		return new OptionsIcon(0, 0);
	}

	public static function getOptionsIcon2() {
		return new OptionsIcon2(0, 0);
	}

	public static function getGamesLeaderBoard() {
		return new GamesLeaderBoard().toString();
	}

	public static function getLeaderBaordScores() {
		return new LeaderboardsScores().toString();
	}

	public static function getLeaderboardsListResponse() {
		return new LeaderboardsListResponse().toString();
	}

}
