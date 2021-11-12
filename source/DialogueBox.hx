package;

import lime.app.Application;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var marrow:FlxSprite;
	var bf:FlxSprite;
	var gf:FlxSprite;

	//var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var daError:Bool;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		daError = false;
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.screenCenter(XY);
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			bgFade.alpha += 0.01;
			if (bgFade.alpha < 0.7)
				tmr.reset(1/24);
			// instead of 0.01, 1/24 because of 24
			// frames per second
		});

		box = new FlxSprite(-20, 375);
		/*
		if (PlayState.SONG.song == 'Lounge')
		{
		//	FlxG.sound.play(Paths.sound('metro_noises', 'subway'));
		}
		*/
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'lounge' | 'metro' | 'rails':
				hasDialog = true;
		}
		// obviously dialog is true because all songs have some form of dialouge, right?
		box.frames = Paths.getSparrowAtlas('dialogue/dialogueBox', 'subway');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24);
		box.animation.addByPrefix('normal', 'speech bubble normal', 24);
		box.animation.addByPrefix('loudOpen', 'speech bubble loud open', 24);
		// as requested by fellow dev members
		box.animation.addByPrefix('loud', 'AHH speech bubble', 24, false);

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		marrow = new FlxSprite(200, 140);
		marrow.frames = Paths.getSparrowAtlas('dialogue/boneMarrow', 'subway');
		marrow.animation.addByPrefix('normal', 'marrowNeutral', 24, false);
		marrow.animation.addByPrefix('confused', 'marrowConfused', 24, false);
		marrow.animation.addByPrefix('friendly', 'marrowFriendly', 24, false);
		marrow.animation.addByPrefix('happy', 'marrowHappy', 24, false);
		marrow.animation.addByPrefix('mad', 'marrowPissed', 24, false);
		marrow.animation.addByPrefix('sus', 'marrowSuspicious', 24, false);
		marrow.updateHitbox();
		marrow.scrollFactor.set();
		add(marrow);
		marrow.visible = false;

		bf = new FlxSprite(800, 160);
		bf.frames = Paths.getSparrowAtlas('dialogue/boyfriendMidget', 'subway');
		bf.animation.addByPrefix('normal', 'bfIdle', 24, false);
		bf.animation.addByPrefix('nervous', 'bfNervous', 24, false);
		bf.animation.addByPrefix('messedUp', 'bfOfucc', 24, false);
		bf.animation.addByPrefix('surprised', 'bfSurprised', 24, false);
		bf.updateHitbox();
		bf.scrollFactor.set();
		add(bf);
		bf.visible = false;

		gf = new FlxSprite(800, 150);
		gf.frames = Paths.getSparrowAtlas('dialogue/girlfriendPog', 'subway');
		gf.animation.addByPrefix('normal', 'girlfriendIdle', 24, false);
		gf.animation.addByPrefix('happy', 'girlfriendHappy', 24, false);
		gf.animation.addByPrefix('crying', 'girlfriendCry', 24, false);
		gf.animation.addByPrefix('sad', 'girlfriendSad', 24, false);
		gf.animation.addByPrefix('smile', 'girlfriendSmile', 24, false);
		gf.updateHitbox();
		gf.scrollFactor.set();
		add(gf);
		gf.visible = false;

		/*
		switch (curCharacter)
		{
			case 'marrowPissed' | 'bfOfucc':
				box.animation.play('loudOpen', false);
				box.flipX = false;
			
			default:
				box.animation.play('normalOpen', false);
				box.flipX = true;
		}
		*/
		switch (curCharacter)
		{
			case 'bfOfucc' | 'gfCrying' | 'marrowPissed':
			{
				new FlxTimer().start(3 / 24, function(tmr:FlxTimer)
				{
					box.flipX = false;
					box.animation.play('loudOpen', true);
				});
			}
			default:
			{
				new FlxTimer().start(5 / 24, function(tmr:FlxTimer)
				{
					box.flipX = true;
					box.animation.play('normalOpen', true);
				});
			}
		}

		add(box);
		box.screenCenter(X);

		//handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox', 'week6'));
		//add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(100, 502, Std.int(FlxG.width * 0.8), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(100, 500, Std.int(FlxG.width * 0.8), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var testVariable:Bool = false;

	override function update(elapsed:Float)
	{
		FlxG.save.data.startFullscreen = FlxG.fullscreen;

		switch (curCharacter)
		{
			case 'dad' | 'marrow' | 'marrowConfused' | 'marrowFriendly' | 'marrowHappy' | 'marrowSuspicious':
				swagDialogue.color = 0xFF000000;
				dropText.alpha = 0;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('marrow', 'subway'), 0.6)];
				box.flipX = true;
				box.y = 375;
			case 'marrowPissed':
				swagDialogue.color = 0xFF000000;
				dropText.alpha = 0;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('marrowPissed', 'subway'), 1)];
				box.flipX = false;
				box.y = 300;
			case 'bf' | 'bfNervous' | 'bfSuprised':
				swagDialogue.color = 0xFF000000;
				dropText.alpha = 0;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfdialougenoise', 'subway'), 1)];
				box.flipX = false;
				box.y = 375;
			case 'bfOfucc':
				swagDialogue.color = 0xFF000000;
				dropText.alpha = 0;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfShocked', 'subway'), 0.6)];
				box.flipX = false;
				box.y = 300;
			case 'gf' | 'gfHappy' | 'gfSmiling':
				swagDialogue.color = 0xFF3F2021;
				dropText.alpha = 0;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];//[FlxG.sound.load(Paths.sound('GF_2'/*'GF_' + (FlxG.random.int(1, 4))*/, 'subway'), 0.5)];
				box.flipX = false;
				box.y = 375;
			case 'gfSad':
				swagDialogue.color = 0xFF3F2021;
				dropText.alpha = 0;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];//[FlxG.sound.load(Paths.sound('GF_2'/*'GF_' + (FlxG.random.int(1, 4))*/, 'subway'), 0.3)];
				box.flipX = false;
				box.y = 375;
			case 'gfCrying':
				swagDialogue.color = 0xFF3F2021;
				dropText.alpha = 0;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];//[FlxG.sound.load(Paths.sound('GF_2'/*'GF_' + (FlxG.random.int(1, 4))*/, 'subway'), 0.3)];
				box.flipX = false;
				box.y = 300;
			case '':
				swagDialogue.color = 0xFFFFFFFF;
				dropText.alpha = 0;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0)];
				box.flipX = false;
				box.y = 375;
			case '?':
				swagDialogue.color = 0xFF939393;
				dropText.alpha = 1;
				dropText.color = 0xFF000000;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.3)];
				box.flipX = false;
				box.y = 300;
		}
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			switch (curCharacter)
			{
				case 'marrowPissed' | 'bfOfucc' | 'gfCrying':
					if (box.animation.curAnim.name == 'loudOpen' && box.animation.curAnim.finished)
					{
						box.animation.play('loud', true);
					}
				default:
					if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
					{
						box.animation.play('normal', true);
					}
			}
			dialogueOpened = true;
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if ((FlxG.keys.justPressed.ANY || FlxG.mouse.justPressed)  && dialogueStarted == true && !FlxG.keys.justPressed.SPACE && !daError)
		{
			remove(dialogue);
			FlxG.sound.play(Paths.sound('nextText', 'subway'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					FlxG.save.data.seenCutscene = true;
					daError = true;
					isEnding = true;
					switch (PlayState.SONG.song.toLowerCase())
					{
						case 'senpai' | 'thorns':
							FlxG.sound.music.fadeOut(2.3, 0);
					}

					new FlxTimer().start(0.04, function(tmr:FlxTimer)
					{
						box.alpha -= 0.04;
						bgFade.alpha -= 0.028;
						marrow.visible = false;
						bf.visible = false;
						gf.visible = false;
						swagDialogue.alpha -= 0.04;
						dropText.alpha = swagDialogue.alpha;
						//handSelect.alpha -= 0.04;
					}, 25);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		if (FlxG.keys.justPressed.SPACE && !daError)
		{
			FlxG.save.data.seenCutscene = true;
			daError = true;
			remove(dialogue);
			FlxG.sound.play(Paths.sound('nextText', 'subway'), 0.8);

			if (!isEnding)
			{
				isEnding = true;
				switch (PlayState.SONG.song.toLowerCase())
				{
					case 'senpai' | 'thorns':
						FlxG.sound.music.fadeOut(2.3, 0);
				}

				new FlxTimer().start(0.04, function(tmr:FlxTimer)
				{
					box.alpha -= 0.04;
					bgFade.alpha -= 0.028;
					marrow.visible = false;
					bf.visible = false;
					gf.visible = false;
					swagDialogue.alpha -= 0.04;
					dropText.alpha = swagDialogue.alpha;
					//handSelect.alpha -= 0.04;
				}, 25);

				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					finishThing();
					kill();
				});
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			// shadman stuff
			case 'dad' | 'marrow':
				bf.visible = false;
				gf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!marrow.visible)
				{
					marrow.visible = true;
					marrow.animation.play('normal');
				}
				else
				{
					marrow.animation.play('normal');
				}
			case 'marrowConfused':
				bf.visible = false;
				gf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!marrow.visible)
				{
					marrow.visible = true;
					marrow.animation.play('confused');
				}
				else
				{
					marrow.animation.play('confused');
				}
			case 'marrowFriendly':
				bf.visible = false;
				gf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!marrow.visible)
				{
					marrow.visible = true;
					marrow.animation.play('friendly');
				}
				else
				{
					marrow.animation.play('friendly');
				}
			case 'marrowHappy':
				bf.visible = false;
				gf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!marrow.visible)
				{
					marrow.visible = true;
					marrow.animation.play('happy');
				}
				else
				{
					marrow.animation.play('happy');
				}
			case 'marrowSuspicious':
				bf.visible = false;
				gf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!marrow.visible)
				{
					marrow.visible = true;
					marrow.animation.play('sus');
				}
				else
				{
					marrow.animation.play('sus');
				}
			case 'marrowPissed':
				bf.visible = false;
				gf.visible = false;
				box.visible = true;
				box.animation.play('loud', true);
				if (!marrow.visible)
				{
					marrow.visible = true;
					marrow.animation.play('mad');
				}
				else
				{
					marrow.animation.play('mad');
				}
			// bf stuff
			case 'bf':
				marrow.visible = false;
				gf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!bf.visible)
				{
					bf.visible = true;
					bf.animation.play('normal');
				}
				else
				{
					bf.animation.play('normal');
				}
			case 'bfNervous':
				marrow.visible = false;
				gf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!bf.visible)
				{
					bf.visible = true;
					bf.animation.play('nervous');
				}
				else
				{
					bf.animation.play('nervous');
				}
			case 'bfOfucc':
				marrow.visible = false;
				gf.visible = false;
				box.visible = true;
				box.animation.play('loud', true);
				if (!bf.visible)
				{
					bf.visible = true;
					bf.animation.play('messedUp');
				}
				else
				{
					bf.animation.play('messedUp');
				}
			case 'bfSuprised':
				marrow.visible = false;
				gf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!bf.visible)
				{
					bf.visible = true;
					bf.animation.play('surprised');
				}
				else
				{
					bf.animation.play('surprised');
				}
			// gf stuff
			case 'gf':
				//swagDialogue.delay = 0.075;
				marrow.visible = false;
				bf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!gf.visible)
				{
					gf.visible = true;
					gf.animation.play('normal');
				}
				else
				{
					gf.animation.play('normal');
				}
			case 'gfHappy':
				//swagDialogue.delay = 0.075;
				marrow.visible = false;
				bf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!gf.visible)
				{
					gf.visible = true;
					gf.animation.play('happy');
				}
				else
				{
					gf.animation.play('happy');
				}
			case 'gfSmiling':
				//swagDialogue.delay = 0.075;
				marrow.visible = false;
				bf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!gf.visible)
				{
					gf.visible = true;
					gf.animation.play('smile');
				}
				else
				{
					gf.animation.play('smile');
				}
			case 'gfSad':
				//swagDialogue.delay = 0.075;
				marrow.visible = false;
				bf.visible = false;
				box.visible = true;
				box.animation.play('normal', true);
				if (!gf.visible)
				{
					gf.visible = true;
					gf.animation.play('sad');
				}
				else
				{
					gf.animation.play('sad');
				}
			case 'gfCrying':
				//swagDialogue.delay = 0.075;
				marrow.visible = false;
				bf.visible = false;
				box.visible = true;
				box.animation.play('loud', true);
				if (!gf.visible)
				{
					gf.visible = true;
					gf.animation.play('crying');
				}
				else
				{
					gf.animation.play('crying');
				}
			case '':
				marrow.visible = false;
				bf.visible = false;
				gf.visible = false;
				box.visible = false;
				box.animation.play('normal', true);
			case '?':
				marrow.visible = false;
				bf.visible = false;
				gf.visible = false;
				box.visible = true;
				box.animation.play('loud', true);
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
