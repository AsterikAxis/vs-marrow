package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

// i literally took this from freeplay lol
// in order to activate this, go to Main.hx, Options.hx, and OptionsMenu.hx and uncomment stuff
// im not gonna tell you what needs to be SPECIFICALLY uncommented, because it should be obvious, plus, i gave you hints
// make sure to look closely at the code, or you might miss something, and then the game breaks. not my fault if that happens
// this might be broken, so i removed it because i don't want anyone to lose their save files
// weird things might happen
class SaveFileState extends MusicBeatState
{
	public static var saveData:Array<String> = ['rez', 'delta', 'not_anon', 'noodle', 'geothemakugamer', 'theunholybeing', 'dais', 'wisteriaplayz', 'cris.', 'dealgaro'];
	private var _saveData:Array<String> = saveData;
	private var allsavedata:FlxTypedGroup<Alphabet>;

	override function create()
	{
		/*
		// find a fix for dis some other time
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Selecting A Save File", null);
		#end
		*/

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		allsavedata = new FlxTypedGroup<Alphabet>();
		add(allsavedata);

		var daLetter:String = '';
		for (i in 0...saveData.length)
		{
			switch (i)
			{
				case 0:
					daLetter = 'a';
				case 1:
					daLetter = 'b';
				case 2:
					daLetter = 'c';
				case 3:
					daLetter = 'd';
				case 4:
					daLetter = 'e';
				case 5:
					daLetter = 'f';
				case 6:
					daLetter = 'g';
				case 7:
					daLetter = 'h';
				case 8:
					daLetter = 'i';
				case 9:
					daLetter = 'j';
			}
			var saveText:Alphabet = new Alphabet(0, (70 * i) + 30, 'Save File ' + daLetter, true, false, true);
			saveText.targetY = i;
			allsavedata.add(saveText);
		}

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.save.data.startFullscreen = FlxG.fullscreen;

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = FlxG.keys.justPressed.ENTER;

		if (upP || FlxG.mouse.wheel == 1)
		{
			changeSelection(-1);
		}
		if (downP || FlxG.mouse.wheel == -1)
		{
			changeSelection(1);
		}

		if (accepted || FlxG.mouse.justPressed)
		{
			FlxG.save.flush();
			FlxG.save.bind('marrow', saveData[FlxG.save.data.fileNum]);
			FlxG.switchState(new TitleState());
		}
	}

	function changeSelection(saveData:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		FlxG.save.data.fileNum += saveData;

		if (FlxG.save.data.fileNum < 0)
			FlxG.save.data.fileNum = _saveData.length - 1;
		if (FlxG.save.data.fileNum >= _saveData.length)
			FlxG.save.data.fileNum = 0;

		var spacer:Int = 0;

		for (item in allsavedata.members)
		{
			item.targetY = spacer - FlxG.save.data.fileNum;
			spacer++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
