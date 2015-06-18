package com.sempaigames.gplayrest.ui.theme;

/**
* Main class of a theme
*
*/
class Main extends ru.stablex.ui.Theme{

    /** main font name */
    static public var FONT : String = '';


    /**
    * This method will be automatically called after UIBuilder.init()
    * It's not required to define this method in theme.
    *
    */
    static public function main () : Void {
        //due to bug in openfl-html5 we need to set font name manually
        FONT = #if html5 'Roboto Regular' #else "Arial" #end;
    }//function main()

}//class Main