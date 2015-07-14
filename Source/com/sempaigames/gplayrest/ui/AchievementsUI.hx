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
	var freed : Bool;

	public function new(gPlay : GPlay) {
		super();
		freed = false;
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
			}).catchError(function (e) {
				UIManager.getInstance().onNetworkError();
			});

	}

	override public function onResize(_) {
		if (freed) {
			return;
		}
		var scale = 1;
		loading.w = sx;
		loading.h = sy;
		achievementsUI.w = sx/scale;
		achievementsUI.h = sy/scale;
		achievementsUI.scaleX = achievementsUI.scaleY = scale;
		loading.refresh();
		achievementsUI.refresh();
	}

	function onEnterFrame() {
		if (freed || achievementsToAdd.length==0) {
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
						case INCREMENTAL: {
							try {
								image.progress = state.currentSteps/definition.totalSteps;
							} catch (d : Dynamic) {
								image.progress = 0;
							}
						}
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

		if (freed) {
			return;
		}

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

		var titleBar = achievementsUI.getChildAs("title_bar", TitleBar);
		titleBar.title = "Achievements";
		var bmp = new ProgressBmp();
		bmp.w = titleBar.h*0.8;
		bmp.h = titleBar.h*0.8;
		bmp.x = titleBar.w - titleBar.h*0.8 - titleBar.h*0.1 - 5;
		bmp.y = titleBar.h/2 - bmp.h/2;
		bmp.progress = nUnlocked / achievementsDefinition.items.length;
		bmp.textSize = 19;
		titleBar.logoImg = bmp;
		titleBar.backBtnImg.x = 15;

	}

	override public function onClose() {
		achievementsUI.free();
		loading.free();
		freed = true;
	}

	override public function onKeyUp(k : KeyboardEvent) {
		if (freed) {
			return;
		}
		if (k.keyCode==27) {
			k.stopImmediatePropagation();
			UIManager.getInstance().closeCurrentView();
		}
	}

}
