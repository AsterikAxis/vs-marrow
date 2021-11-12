package;

import openfl.Lib;
#if windows
import llua.Lua;
#end
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

#if windows
import Discord.DiscordClient;
#end

class CreditsState extends MusicBeatState
{
	public static var gameBeaten:Bool = false;
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	// i hate dis so much
	var menuItems:Array<String> = [
		'Credits',
		'',
		'Creator',
		'Rez',
		'',
		'Artists',
		'Rez',
		'GeoTheMakuGamer',
		'Delta',
		'TheUnholyBeing',
		'WisteriaPlayz',
		'',
		'Musicians',
		'Blook',
		'GeoTheMakuGamer',
		'Not Anon',
		'',
		'Charters and Playtesters',
		'Delta', 'WisteriaPlayz',
		'',
		'Storyboard',
		'Dais',
		'',
		'Coders',
		'Cris.',
		'Not Anon'
	];
	var iconNames:Array<String> = [
		'',
		'',
		'',
		'rez',
		'',
		'',
		'rez',
		'geothemakugamer',
		'delta',
		'theunholybeing',
		'wisteriaplayz',
		'',
		'',
		'blook',
		'geothemakugamer',
		'not_anon',
		'',
		'',
		'delta',
		'wisteriaplayz',
		'',
		'',
		'dais',
		'',
		'',
		'cris.',
		'not_anon'
	];
	var iconArray:Array<HealthIcon> = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	override function create()
	{
		super.create();

		// i watched breaking bad during my summer break
		// and i don't care if i didn't put all of the game beaten
		// statements together or not.
		var negro_y_azul:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(negro_y_azul);
		if (gameBeaten)
			negro_y_azul.color = 0xFF000000;
		else
			negro_y_azul.color = 0xFF64F795;

		if (gameBeaten)
		{
			pauseMusic = new FlxSound().loadEmbedded(Paths.music('normal_pills'), true, true);
			pauseMusic.volume = 0;
			pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

			FlxG.sound.list.add(pauseMusic);
		}

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);

			var icon:HealthIcon = new HealthIcon(iconNames[i]);
			icon.sprTracker = songText;
			iconArray.push(icon);
			add(icon);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		if (gameBeaten)
		{
			new FlxTimer().start(1.6, function(tmr:FlxTimer)
			{
				FlxTween.color(negro_y_azul, 0.6, 0x000000, 0x64F795);
			});
		}

		#if windows
		// Updating Discord Rich Presence
		if (!gameBeaten)
			DiscordClient.changePresence("In the Credits Menu", null);
		#end
	}

	override function update(elapsed:Float)
	{
		FlxG.save.data.startFullscreen = FlxG.fullscreen;

		if (!gameBeaten)
		{
			if (FlxG.sound.music.volume < 0.8)
			{
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			}
	
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
				{
					var randomSong:String = FlxG.random.bool(0.1) ? 'freakyMenu' : 'freakyMenuRare';
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
				}
			}
		}	
		else
		{
			if (pauseMusic.volume < 0.5)
				pauseMusic.volume += 0.01 * elapsed;
		}

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP || FlxG.mouse.wheel == 1)
		{
			changeSelection(-1);
   
		}
		else if (downP || FlxG.mouse.wheel == -1)
		{
			changeSelection(1);
		}

		if (accepted || FlxG.mouse.justPressed)
		{
			if (gameBeaten)
			{
				GameOverSubstate.pixelSequence = false;
				if (PlayState.loadRep)
				{
					FlxG.save.data.botplay = false;
					FlxG.save.data.scrollSpeed = 1;
					FlxG.save.data.downscroll = false;
				}
				PlayState.loadRep = false;
				#if windows
				if (PlayState.luaModchart != null)
				{
					PlayState.luaModchart.die();
					PlayState.luaModchart = null;
				}
				#end
				if (FlxG.save.data.fpsCap > 290)
					(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);
			}
			FlxG.switchState(new MainMenuState());
			gameBeaten = false;
		}
	}

	override function destroy()
	{
		if (gameBeaten)
			pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		// here's where i die because i am coding instead
		// of taking the opportunity to bring up my grades
		// for the classes that i am currently failing..
		// fancy statement btw
		switch (curSelected)
		{
			case 1 | 4 | 11 | 16 | 20 | 23:
			{
				curSelected += change;
			}
		}

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.7;
		}

		// extra code because i can
		// do anything i put my mind to
		// IF i feel like it and IF
		// it's worth the effort
		if ((curSelected - 2) >= 0)
		{
			for (i in 0...(curSelected - 2))
			{
				iconArray[i].alpha = 0.5;
			}
		}

		if ((curSelected - 3) >= 0)
		{
			for (i in 0...(curSelected - 3))
			{
				iconArray[i].alpha = 0.3;
			}
		}

		if ((curSelected + 2) <= (menuItems.length - 1))
		{
			for (i in (curSelected + 2)...(menuItems.length - 1))
			{
				iconArray[i].alpha = 0.5;
			}
		}

		if ((curSelected + 3) <= (menuItems.length - 1))
		{
			for (i in (curSelected + 3)...(menuItems.length - 1))
			{
				iconArray[i].alpha = 0.3;
			}
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}