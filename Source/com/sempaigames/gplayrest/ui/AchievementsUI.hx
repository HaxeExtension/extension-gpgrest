package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.GPlay;
import com.sempaigames.gplayrest.datatypes.AchievementDefinition;
import com.sempaigames.gplayrest.datatypes.AchievementDefinitionsListResponse;
import com.sempaigames.gplayrest.datatypes.AchievementState;
import com.sempaigames.gplayrest.datatypes.PlayerAchievement;
import com.sempaigames.gplayrest.datatypes.PlayerAchievementListResponse;
import flash.events.*;
import flash.display.Sprite;
import flash.Lib;
import openfl.system.Capabilities;
import promhx.Promise;
import ru.stablex.ui.widgets.*;
import ru.stablex.ui.UIBuilder;

class AchievementsUI extends UI {

	var achievementsUI : Widget;
	var achievementsToAdd : Array<{definition : AchievementDefinition, state : PlayerAchievement}>;
	var loading : Widget;

	public function new(gPlay : GPlay) {
		super();
		achievementsToAdd = [];
		Stablex.init();
		achievementsUI = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/achievements.xml')();
		loading = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/loading.xml')();
		this.addChild(loading);
		
		var pAchievementsDefinition = gPlay.AchievementDefinitions_list();
		var pAchievementsState = gPlay.Achievements_list("me");
		pAchievementsDefinition.catchError(function(err) {
			trace("Error :'( " + err);
		});
		pAchievementsState.catchError(function(err) {
			trace("Error :'( " + err);
		});

		Promise.when(pAchievementsDefinition, pAchievementsState)
			.then(function(achievementsDefinition, achievementsState) {
				this.removeChild(loading);
				this.addChild(achievementsUI);
				loadAchievements(achievementsDefinition, achievementsState);
			});

	}

	override public function onResize(_) {
		var scale = Capabilities.screenDPI / 200;
		#if desktop
		var sx = Lib.current.stage.stageWidth;
		var sy = Lib.current.stage.stageHeight;
		#else
		var sx = Capabilities.screenResolutionX;
		var sy = Capabilities.screenResolutionY;
		#end
		loading.w = sx;
		loading.h = sy;
		achievementsUI.w = sx/scale;
		achievementsUI.h = sy/scale;
		achievementsUI.scaleX = achievementsUI.scaleY = scale;
		loading.refresh();
		achievementsUI.refresh();
	}

	function onEnterFrame() {
		if (achievementsToAdd.length==0) {
			return;
		}
		var ach = null;
		for (state in [AchievementState.UNLOCKED, AchievementState.REVEALED, AchievementState.HIDDEN]) {
			for (a in achievementsToAdd) {
				if (a.state.achievementState==state) {
					ach = a;
					break;
				}
			}
			if (ach!=null) {
				break;
			}
		}
		if (ach!=null) {
			achievementsToAdd.remove(ach);
			var definition = ach.definition;
			var state = ach.state;
			var entriesBox = achievementsUI.getChildAs("achievements_entries", VBox);
			var entryUI = UIBuilder.buildFn('com/sempaigames/gplayrest/ui/xml/achievemententry.xml')();
			var image = entryUI.getChildAs("entry_image", ProgressBmp);
			var title = entryUI.getChildAs("entry_title", Text);
			var description = entryUI.getChildAs("entry_description", Text);
			var experience = entryUI.getChildAs("entry_experience", Text);
			var date = entryUI.getChildAs("entry_date", Text);
			title.text = definition.name;
			description.text = definition.description;
			experience.text = Std.string(definition.experiencePoints) + " XP";

			if (state.lastUpdatedTimestamp>0) {
				var d = Date.fromTime(state.lastUpdatedTimestamp);
				date.text = '${d.getFullYear()}/${d.getMonth()}/${d.getDay()}';
			} else {
				date.text = "";
			}

			switch (state.achievementState) {
				case UNLOCKED:	{
					image.url = definition.unlockedIconUrl;
				}
				case REVEALED: {
					switch (definition.achievementType) {
						case STANDARD: 		image.url = definition.revealedIconUrl;
						case INCREMENTAL:	image.progress = state.currentSteps/definition.totalSteps;
					}
				}
				case HIDDEN: {
					title.text = "Secret";
					description.text = "Keep playing to discover more.";
					experience.text = "";
					date.text = "";
				}
				default: {}
			}
			entriesBox.addChild(entryUI);
		}
	}

	function loadAchievements(achievementsDefinition : AchievementDefinitionsListResponse, achievementState : PlayerAchievementListResponse) {
		var nUnlocked = 0;
		for (def in achievementsDefinition.items) {
			for (state in achievementState.items) {
				if (state.id == def.id) {
					achievementsToAdd.push({definition : def, state : state});
					if (state.achievementState==AchievementState.UNLOCKED) {
						nUnlocked++;
					}
				}
			}
		}
		achievementsUI.getChildAs("txt_progress", Text).text = '$nUnlocked/${achievementsDefinition.items.length}';
	}

	override public function onClose() {
		achievementsUI.free();
		loading.free();
	}

	override public function onKeyUp(k : KeyboardEvent) {
		if (k.keyCode==27) {
			k.stopImmediatePropagation();
			UIManager.getInstance().closeCurrentView();
		}
	}

}
