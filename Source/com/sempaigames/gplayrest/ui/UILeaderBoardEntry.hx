package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.datatypes.*;
import com.sempaigames.gplayrest.datatypes.LeaderboardEntry;
import ru.stablex.ui.events.*;
import ru.stablex.ui.layouts.*;
import ru.stablex.ui.widgets.*;

class UILeaderBoardEntry extends Widget {

	public function new(entry : LeaderboardEntry, rootWidget : Widget) {
		super();

		var txtRank = new Text();
		txtRank.label.selectable = false;
		txtRank.text = entry.formattedScoreRank;
		txtRank.format.size = 20;

		txtRank.refresh();
		this.addChild(txtRank);

		var img = new UrlBmp(entry.player.avatarImageUrl, 30);
		this.addChild(img);

		var txtName = new Text();
		txtName.label.selectable = false;
		txtName.text = entry.player.displayName;
		txtName.format.size = 20;

		txtName.refresh();
		this.addChild(txtName);

		var txtScore = new Text();
		txtScore.label.selectable = false;
		txtScore.text = entry.formattedScore;
		txtScore.format.size = 20;

		txtScore.refresh();
		this.addChild(txtScore);

		this.w = rootWidget.w;

		var layout = new Column();
		layout.cols = [50, 30, -1, 0];
		this.layout = layout;

		this.applyLayout();

		var parentH = txtRank.wparent.height;
		txtRank.y = parentH/2 - txtRank.height/2;
		txtName.y = parentH/2 - txtName.height/2;
		txtScore.y = parentH/2 - txtScore.height/2;

	}

}
