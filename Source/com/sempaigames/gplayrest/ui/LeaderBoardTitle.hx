package com.sempaigames.gplayrest.ui;

import com.sempaigames.gplayrest.datatypes.*;
import ru.stablex.ui.events.*;
import ru.stablex.ui.layouts.*;
import ru.stablex.ui.widgets.*;

class LeaderBoardTitle extends Widget {
	
	var title : Text;

	public function new(leaderboard : Leaderboard, rootWidget : Widget) {
		super();

		var icon = new UrlBmp(leaderboard.iconUrl, 50);
		this.addChild(icon);

		title = new Text();
		title.label.selectable = false;
		title.text = leaderboard.name;
		title.format.size = 40;
		title.refresh();
		this.addChild(title);

		var closeBtn = new UrlBmp("", 50);
		this.addChild(closeBtn);

		var layout = new Column();
		layout.cols = [50, -1, 50];
		this.layout = layout;

		this.w = rootWidget.w;
		this.h = 45;

		this.layout.as(Column).vAlign = "middle";

		this.refresh();

	}

}
