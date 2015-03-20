package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.datatypes.*;
import ru.stablex.ui.widgets.*;
import ru.stablex.ui.layouts.*;
import ru.stablex.ui.events.*;

class UILeaderBoardEntry extends Widget {
	
	public function new(entry : LeaderboardEntry, rootWidget : Widget) {
		super();
		
		var txtRank = new Text();
		txtRank.label.selectable = false;
		txtRank.text = entry.formattedScoreRank;
		
		txtRank.refresh();
		this.addChild(txtRank);

		var img = new UrlBmp(entry.player.avatarImageUrl, 30);
		this.addChild(img);

		var txtName = new Text();
		txtName.label.selectable = false;
		txtName.text = entry.player.displayName;
		
		txtName.refresh();
		this.addChild(txtName);

		var txtScore = new Text();
		txtScore.label.selectable = false;
		txtScore.text = entry.formattedScore;
		
		txtScore.refresh();
		this.addChild(txtScore);

		this.w = rootWidget.w;

		var layout = new Column();
		layout.cols = [0, 30, -1, 0];
		this.layout = layout;
		this.applyLayout();

	}

}