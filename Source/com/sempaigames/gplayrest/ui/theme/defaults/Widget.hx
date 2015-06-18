package com.sempaigames.gplayrest.ui.theme.defaults;

import com.sempaigames.gplayrest.ui.theme.Main;
import ru.stablex.ui.skins.Paint;
import ru.stablex.ui.UIBuilder;


/**
* Defaults for Widget
*
*/
class Widget {

    /**
    * Horisontal ruler
    *
    */
    static public function HR (w:ru.stablex.ui.widgets.Widget) : Void {
        w.h = 1;
        w.widthPt = 100;
        w.skinName = 'hr';
    }//function HR()


    /**
    * Horisontal ruler with slightly lighter color
    *
    */
    static public function HRLight (w:ru.stablex.ui.widgets.Widget) : Void {
        UIBuilder.defaults.get('Widget').get('HR')(w);
        w.skin.as(Paint).color = 0xa9a9a9;
    }//function HRLight()

}//class Widget