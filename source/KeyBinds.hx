import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

class KeyBinds
{

    public static function resetBinds():Void{

        FlxG.save.data.upBind = "W";
        FlxG.save.data.downBind = "S";
        FlxG.save.data.leftBind = "A";
        FlxG.save.data.rightBind = "D";
        FlxG.save.data.killBind = "R";

        /*
        FlxG.save.data.upUI = 'UP';
        FlxG.save.data.downUI = 'DOWN';
        FlxG.save.data.leftUI = 'LEFT';
        FlxG.save.data.rightUI = 'RIGHT';
        */

        PlayerSettings.player1.controls.loadKeyBinds();

        // program later
        // PlayerSettings.player1.controls.loadUIBinds();

	}

    public static function keyCheck():Void
    {
        if(FlxG.save.data.upBind == null){
            FlxG.save.data.upBind = "W";
            trace("No UP");
        }
        if(FlxG.save.data.downBind == null){
            FlxG.save.data.downBind = "S";
            trace("No DOWN");
        }
        if(FlxG.save.data.leftBind == null){
            FlxG.save.data.leftBind = "A";
            trace("No LEFT");
        }
        if(FlxG.save.data.rightBind == null){
            FlxG.save.data.rightBind = "D";
            trace("No RIGHT");
        }
        if(FlxG.save.data.killBind == null){
            FlxG.save.data.killBind = "R";
            trace("No KILL");
        }

        /*
        if (FlxG.save.data.upUI == null)
        {
            FlxG.save.data.upUI = "UP";
        }
        if (FlxG.save.data.downUI == null)
        {
            FlxG.save.data.downUI = "DOWN";
        }
        if (FlxG.save.data.leftUI == null)
        {
            FlxG.save.data.leftUI = "LEFT";
        }
        if (FlxG.save.data.rightUI == null)
        {
            FlxG.save.data.rightUI = "RIGHT";
        }
        */
    }
}