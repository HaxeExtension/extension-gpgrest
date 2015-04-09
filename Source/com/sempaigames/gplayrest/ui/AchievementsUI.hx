package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.GPlay;
import com.sempaigames.gplayrest.datatypes.AchievementDefinition;
import com.sempaigames.gplayrest.datatypes.AchievementDefinitionsListResponse;
import com.sempaigames.gplayrest.datatypes.PlayerAchievementListResponse;
import flash.events.Event;
import flash.display.Sprite;
import flash.Lib;
import ru.stablex.ui.widgets.*;
import ru.stablex.ui.UIBuilder;

class AchievementsUI extends Sprite {

	var achievementsUI : Widget;
	var achievementsToAdd : Array<AchievementDefinition>;
	var loading : Widget;

	public function new(gPlay : GPlay) {
		super();
		achievementsToAdd = [];
		Stablex.init();
		achievementsUI = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/achievements.xml')();
		loading = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/loading.xml')();
		this.addChild(loading);
		this.addEventListener(Event.ADDED_TO_STAGE, onResize);
		Lib.current.stage.addEventListener(Event.RESIZE, onResize);
		gPlay.AchievementDefinitions_list().catchError(function(err) {
			trace("Error :'( " + err);
		}).then(function(achievements) {
			this.removeChild(loading);
			this.addChild(achievementsUI);
			loadAchievements(achievements);
		});
	}

	function onResize(_) {
		loading.w = achievementsUI.w = Lib.current.stage.stageWidth;
		loading.h = achievementsUI.h = Lib.current.stage.stageHeight;
		loading.refresh();
		achievementsUI.refresh();
	}

	function onEnterFrame() {
		var ach = achievementsToAdd.shift();
		if (ach!=null) {
			var entriesBox = achievementsUI.getChildAs("achievements_entries", VBox);
			var entryUI = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/achievemententry.xml')();
			var image = entryUI.getChildAs("entry_image", UrlBmp);
			var title = entryUI.getChildAs("entry_title", Text);
			var description = entryUI.getChildAs("entry_description", Text);
			var experience = entryUI.getChildAs("entry_experience", Text);
			var date = entryUI.getChildAs("entry_date", Text);
			title.text = ach.name;
			image.url = ach.unlockedIconUrl;
			description.text = ach.description;
			experience.text = Std.string(ach.experiencePoints);
			entriesBox.addChild(entryUI);
		}
	}

	function loadAchievements(achievements : AchievementDefinitionsListResponse) {
		for (ach in achievements.items) {
			achievementsToAdd.push(ach);
		}
	}

}
