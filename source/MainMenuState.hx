package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var mainMenuStatePixel:Bool = true;

	var curSelected:Int = FlxG.save.data.daSelected;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'credits', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var gameVer:String = "RELEASE 1.0";

	var sterile:FlxSprite;
	var bg:FlxSprite;
	var freeplay:FlxSprite;
	var magenta:FlxSprite;
	var newBackground:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		if (mainMenuStatePixel == false)
		{
			trace('no preload for metro');
		}
		else
		{
			trace('preload for metro');
		}

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		sterile = new FlxSprite(-100).loadGraphic(Paths.image('menuDesat'));
		sterile.scrollFactor.x = 0;
		sterile.scrollFactor.y = 0.10;
		sterile.setGraphicSize(Std.int(sterile.width * 1.1));
		sterile.updateHitbox();
		sterile.screenCenter();
		sterile.antialiasing = true;
		add(sterile);

		freeplay = new FlxSprite(-100).loadGraphic(Paths.image('menuBGBlue'));
		freeplay.scrollFactor.x = 0;
		freeplay.scrollFactor.y = 0.10;
		freeplay.setGraphicSize(Std.int(freeplay.width * 1.1));
		freeplay.updateHitbox();
		freeplay.screenCenter();
		freeplay.antialiasing = true;
		add(freeplay);

		bg = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		newBackground = new FlxSprite(-100).loadGraphic(Paths.image('menuDesat'));
		newBackground.scrollFactor.x = 0;
		newBackground.scrollFactor.y = 0.10;
		newBackground.setGraphicSize(Std.int(newBackground.width * 1.1));
		newBackground.updateHitbox();
		newBackground.screenCenter();
		newBackground.antialiasing = true;
		add(newBackground);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		switch (FlxG.save.data.daSelected)
		{
			case 0:
				sterile.color = 0xFFFFDF3F;
				bg.alpha = 1;
				newBackground.alpha = 0;
				freeplay.alpha = 0;
			case 1:
				sterile.color = 0xFF8E72F7;
				bg.alpha = 0;
				newBackground.alpha = 0;
				freeplay.alpha = 1;
			case 2:
				sterile.color = 0xFF64F795;
				newBackground.color = 0xFF64F795;
				bg.alpha = 0;
				newBackground.alpha = 1;
				freeplay.alpha = 0;
			case 3:
				sterile.color = 0xFFFFFFFF;
				newBackground.color = 0xFFFFFFFF;
				bg.alpha = 0;
				newBackground.alpha = 1;
				freeplay.alpha = 0;
		}

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		// rewrite this part later. doin this sloppy because release is right now
		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		var socialCredit = Paths.getSparrowAtlas('menu_credits');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			if (i != 2)
				menuItem.frames = tex;
			else
				menuItem.frames = socialCredit;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			finishedFunnyMove = true;
			// changeItem();
			menuItem.y = 60 + (i * 160);
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		FlxG.save.data.startFullscreen = FlxG.fullscreen;

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing && !selectedSomethin)
			{
				var randomSong:String = FlxG.random.bool(0.1) ? 'freakyMenu' : 'freakyMenuRare';
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		}

		if (!selectedSomethin)
		{
			/*
			// totally "original"
			var daChoice:String = optionShit[FlxG.save.data.daSelected];
			*/

			if (controls.UP_P || FlxG.mouse.wheel == 1)
			{
				FlxTween.cancelTweensOf(newBackground);
				FlxTween.cancelTweensOf(bg);
				FlxTween.cancelTweensOf(freeplay);
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P || FlxG.mouse.wheel == -1)
			{
				FlxTween.cancelTweensOf(newBackground);
				FlxTween.cancelTweensOf(bg);
				FlxTween.cancelTweensOf(freeplay);
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK || FlxG.mouse.justPressedRight)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT || FlxG.mouse.justPressed)
			{
				if (optionShit[FlxG.save.data.daSelected] == 'donate')
				{
					fancyOpenURL("https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (FlxG.save.data.daSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function goToState()
	{
		var daChoice:String = optionShit[FlxG.save.data.daSelected];

		switch (daChoice)
		{
			case 'story mode':
				GameOverSubstate.pixelSequence = false;
				PlayState.storyPlaylist = ['Lounge', 'Metro', 'Rails'];
				PlayState.isStoryMode = true;
				PlayState.storyDifficulty = 2;
				PlayState.SONG = Song.loadFromJson(StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase() + '-hard', StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase());
				PlayState.storyWeek = 0;
				PlayState.campaignScore = 0;
				FlxG.save.data.seenCutscene = false;
				LoadingState.loadAndSwitchState(new PlayState(), true);
				trace('Story Mode\nLoading Gameplay...');
				// FlxG.switchState(new StoryMenuState());
				// trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());
				trace("Freeplay Menu Selected");
			case 'credits':
				CreditsState.gameBeaten = false;
				FlxG.switchState(new CreditsState());
			case 'options':
				FlxG.switchState(new OptionsMenu());
				trace("Options Menu Selected");
		}
	}

	function changeItem(huh:Int = 0)
	{
		/*
		if (huh == 0)
		{
			if (FlxG.save.data.daSelected == 0)
				newBackground.color = 0x00000000;
			else
				newBackground.color = FlxG.save.data.daColor;
		}
		*/

		if (finishedFunnyMove)
		{
			FlxG.save.data.daSelected += huh;

			if (FlxG.save.data.daSelected >= menuItems.length)
				FlxG.save.data.daSelected = 0;
			if (FlxG.save.data.daSelected < 0)
				FlxG.save.data.daSelected = menuItems.length - 1;

			FlxG.save.flush();
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == FlxG.save.data.daSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});

		switch (FlxG.save.data.daSelected)
		{
			case 0:
				sterile.color = 0xFFFFDF3F;
				FlxTween.color(bg, 0.6, bg.color, 0xFFFFFFFF);
				FlxTween.color(newBackground, 0.6, newBackground.color, 0x00000000);
				FlxTween.color(freeplay, 0.6, freeplay.color, 0x00000000);
			case 1:
				sterile.color = 0xFF8E72F7;
				FlxTween.color(freeplay, 0.6, freeplay.color, 0xFFFFFFFF);
				FlxTween.color(newBackground, 0.6, newBackground.color, 0x00000000);
				FlxTween.color(bg, 0.6, bg.color, 0x00000000);
			case 2:
				FlxG.save.data.daColor = 0xFF64F795;
				sterile.color = 0xFF64F795;
				FlxTween.color(newBackground, 0.6, newBackground.color, FlxG.save.data.daColor);
				FlxTween.color(bg, 0.6, bg.color, 0x00000000);
				FlxTween.color(freeplay, 0.6, freeplay.color, 0x00000000);
			case 3:
				FlxG.save.data.daColor = 0xFFFFFFFF;
				sterile.color = 0xFFFFFFFF;
				FlxTween.color(newBackground, 0.6, newBackground.color, FlxG.save.data.daColor);
				FlxTween.color(bg, 0.6, bg.color, 0x00000000);
				FlxTween.color(freeplay, 0.6, freeplay.color, 0x00000000);
		}
	}
}
