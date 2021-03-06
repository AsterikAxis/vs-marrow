package;

import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end
#if desktop
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var subwaybg:FlxSprite;
	var train:FlxSprite;
	var pixelsubwaybg:FlxSprite;
	var pixelTrain:FlxSprite;
	var rezIsAReallyGreatAnimator:FlxSprite;

	private static var creditCheck:String;

	public static var pixelPreload:Bool = true;

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;
	var gfCam:FlxObject;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	// i seriously need to reconsider being
	// a coder if all i did here is copy
	// and paste stuff
	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;
	public static var pixelStrumNotes:FlxTypedGroup<FlxSprite> = null;
	public static var pixelPlayerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var pixelCPUStrums:FlxTypedGroup<FlxSprite> = null;
	private static var daArrow:FlxSprite;
	private var pixelNow:Bool = false;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	public var dialogueHUD:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var postDialogue:Array<String> = [':dad:blah blah blah', ':bf:coolswag'];
	public var preDialogue:Array<String> = [':dad:blah blah blah', ':bf:coolswag'];
	public var dialogue:Array<String> = [':dad:blah blah blah', ':bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }


	override public function create()
	{
		creditCheck = (SONG.song);
		if (MainMenuState.mainMenuStatePixel == false)
		{
			pixelPreload = false;
		}

		instance = this;

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(PlayState.SONG.song.toLowerCase()  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode:";
		}
		else
		{
			detailsText = "Freeplay:";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		dialogueHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		dialogueHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(dialogueHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);

		if (isStoryMode)
		{
			#if !desktop
			var a=SONG.song.toLowerCase();if(a=='lounge'){preDialogue=CoolUtil.coolTextFile(Paths.txt(a+'/'+a+'PreDialogue'));}if(a=='rails'||a=='test'){postDialogue=CoolUtil.coolTextFile(Paths.txt(a+'/'+a+'PostDialogue'));}dialogue=CoolUtil.coolTextFile(Paths.txt(a+'/'+a+'Dialogue'));
			#elseif desktop
			var daSong:String = SONG.song.toLowerCase();
			var _dialogue:Array<String> = [':dad:blah blah blah', ':bf:coolswag'];

			if (FileSystem.exists(Paths.txt(daSong + '/' + daSong + 'PreDialogue')))
				preDialogue = CoolUtil.coolTextFile(Paths.txt(daSong + '/' + daSong + 'PreDialogue'));
			else
				preDialogue = _dialogue;
			if (FileSystem.exists(Paths.txt(daSong + '/' + daSong + 'Dialogue')))
				dialogue = CoolUtil.coolTextFile(Paths.txt(daSong + '/' + daSong + 'Dialogue'));
			else
				dialogue = _dialogue;
			if (FileSystem.exists(Paths.txt(daSong + '/' + daSong + 'PostDialogue')))
				postDialogue = CoolUtil.coolTextFile(Paths.txt(daSong + '/' + daSong + 'PostDialogue'));
			else
				postDialogue = _dialogue;
			#end
		}

		switch(SONG.stage)
		{
			case 'stage':
			{
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
			}
			case 'subway':
			{
				curStage = 'subway';

				defaultCamZoom = 0.9;

				subwaybg = new FlxSprite(-995, -100);
				subwaybg.frames = Paths.getSparrowAtlas('subwaybg', 'subway');
				subwaybg.animation.addByPrefix('move', 'trainbg', 30);
				subwaybg.scrollFactor.set(0.88, 0.88);
				subwaybg.active = true;
				add(subwaybg);
				subwaybg.animation.play('move');

				train = new FlxSprite(-600, -300).loadGraphic(Paths.image('traincabin', 'subway'));
				train.scrollFactor.set(0.92, 0.92);
				train.scale.set(1, 1.1);
				train.active = true;
				add(train);

				if (SONG.song.toUpperCase() == 'METRO')
				{
					pixelsubwaybg = new FlxSprite(-995, -100).loadGraphic(Paths.image('subwaybgpixel', 'subway'));
					subwaybg.scrollFactor.set(0.88, 0.88);
					subwaybg.active = true;
					add(pixelsubwaybg);
					pixelsubwaybg.visible = false;

					pixelTrain = new FlxSprite(-600, -300).loadGraphic(Paths.image('traincabinpixel', 'subway'));
					pixelTrain.scrollFactor.set(0.92, 0.92);
					pixelTrain.scale.set(1, 1.1);
					pixelTrain.active = true;
					add(pixelTrain);
					pixelTrain.visible = false;
				}

				var debugger:String = SONG.song == 'Metro' ? 'bgCharactersMetro' : 'bgCharactersRails';

				rezIsAReallyGreatAnimator = new FlxSprite(-825, -200);
				rezIsAReallyGreatAnimator.frames = Paths.getSparrowAtlas(debugger, 'subway');
				rezIsAReallyGreatAnimator.animation.addByPrefix('dance', debugger, 24, false);
				rezIsAReallyGreatAnimator.scrollFactor.set(0.92, 0.92);
				rezIsAReallyGreatAnimator.scale.set(0.7, 0.7);
				rezIsAReallyGreatAnimator.active = true;
				add(rezIsAReallyGreatAnimator);
			}
			default:
			{
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
			}
		}
		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			default:
				gfVersion = 'gf';
		}

		gfCam = new FlxObject(360, -170);
		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
		}
		
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				if(FlxG.save.data.distractions){
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				}


				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'subway':
				gf.y -= 60;
				gf.x -= 40;
				gf.scrollFactor.set(0.92, 0.92);
				dad.scrollFactor.set(0.92, 0.92);
		}

		if (SONG.song == "Rails")
		{
			add(gfCam);
			gfCam.visible = false;
		}

		add(gf);
		add(dad);
		add(boyfriend);

		if (SONG.song.toLowerCase() == 'lounge' && !FlxG.save.data.skipDialogue && !FlxG.save.data.seenCutscene)
		{
			gf.alpha = 0;
			dad.alpha = 0;
			boyfriend.alpha = 0;
		}

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses', repPresses);
			FlxG.watch.addQuick('rep releases', repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		var daSecondDoof:DialogueBox = new DialogueBox(false, preDialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		daSecondDoof.scrollFactor.set();
		daSecondDoof.finishThing = function()
		{
			dialogueIntro(doof);
			new FlxTimer().start(0.8, function(tmr:FlxTimer) {
				blacknessInside.alpha -= (1/24);
				if (blacknessInside.alpha > 0) {
					tmr.reset(1/24);
				}
				else {
					remove(blacknessInside);
				}
			});
		}
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		pixelStrumNotes = new FlxTypedGroup<FlxSprite>();
		pixelPlayerStrums = new FlxTypedGroup<FlxSprite>();
		pixelCPUStrums = new FlxTypedGroup<FlxSprite>();
		add(pixelStrumNotes);
		pixelStrumNotes.visible = false;

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		// fixes the camera coming from the top issue in rails maybe
		// hopefully this doesn't ruin anything else
		gfCam.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);
		if (SONG.song == 'Rails')
		{
			FlxG.camera.follow(gfCam, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
			// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
			FlxG.camera.focusOn(gfCam.getPosition());
		}
		else
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
			// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
			FlxG.camera.focusOn(camFollow.getPosition());
		}
		FlxG.camera.zoom = defaultCamZoom;

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
		{
			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);
			
			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, 90000);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);
			songName.cameras = [camHUD];
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		if (FlxG.save.data.healthPlus)
		{
			var a;
			var b;
			switch (SONG.player1.toLowerCase())
			{
				case 'bf':
				{
					b = 0xFF31B0D1;
				}
				case 'bf-pixel':
				{
					b = 0xFF7BD6F6;
				}
				case 'gf':
				{
					b = 0xFFA5004D;
				}
				case 'marrow':
				{
					b = 0xFFB2B2B2;
				}
				case 'marrow-pixel':
				{
					b = 0xFF939393;
				}
				case 'dad':
				{
					b = 0xFFAF66CE;
				}
				case 'bf-old':
				{
					b = 0xFFE9FF48;
				}
				default:
					b=0xFFFF0000;
			}
			switch (SONG.player2.toLowerCase())
			{
				case 'bf':
				{
					a = 0xFF31B0D1;
				}
				case 'bf-pixel':
				{
					a = 0xFF7BD6F6;
				}
				case 'gf':
				{
					a = 0xFFA5004D;
				}
				case 'marrow':
				{
					a = 0xFFB2B2B2;
				}
				case 'marrow-pixel':
				{
					a = 0xFF939393;
				}
				case 'dad':
				{
					a = 0xFFAF66CE;
				}
				case 'bf-old':
				{
					a = 0xFFE9FF48;
				}
				default:
					a=0xFF66FF33;
			}
			healthBar.createFilledBar(a, b);
		}
		else
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy"), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		if(FlxG.save.data.botplay)
			scoreTxt.x = FlxG.width / 2 - 20;													  
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		
		if (FlxG.save.data.botplay && !loadRep)
			add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		pixelStrumNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [dialogueHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];
		daSecondDoof.cameras = [dialogueHUD];
		//
		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case 'lounge':
					dialogueHUD.visible = true;
					blacknessInside = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
					blacknessInside.screenCenter(XY);
					add(blacknessInside);
					FlxG.save.data.resetLock = true;
					remove(rezIsAReallyGreatAnimator);
					if (!FlxG.save.data.skipDialogue && !FlxG.save.data.seenCutscene)
					{
						preDialogueIntro(daSecondDoof);
					}
					else
					{
						remove(blacknessInside);
						startCountdown();
					}
				case 'metro':
					dialogueHUD.visible = true;
					FlxG.save.data.resetLock = true;
					pixelTransformation();
					if (pixelPreload == true)
					{
						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							if (!FlxG.save.data.skipDialogue && !FlxG.save.data.seenCutscene)
								dialogueIntro(doof);
							else
								startCountdown();
						});
					}
					else
					{
						if (!FlxG.save.data.skipDialogue && !FlxG.save.data.seenCutscene)
							dialogueIntro(doof);
						else
							startCountdown();
					}
				case 'rails':
					dialogueHUD.visible = true;
					FlxG.save.data.resetLock = true;
					if (!FlxG.save.data.skipDialogue && !FlxG.save.data.seenCutscene)
						dialogueIntro(doof);
					else
						startCountdown();
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				case 'lounge':
					FlxG.save.data.resetLock = true;
					remove(rezIsAReallyGreatAnimator);
					startCountdown();
				case 'metro':
					FlxG.save.data.resetLock = true;
					pixelTransformation();
					if (pixelPreload == true)
					{
						new FlxTimer().start(2, function(tmr:FlxTimer)
						{
							startCountdown();
						});
					}
					else
					{
						startCountdown();
					}
				case 'rails':
					FlxG.save.data.resetLock = true;
					startCountdown();
				default:
					FlxG.save.data.resetLock = true;
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		// Starting Point #2

		super.create();
	}

	var blacknessInside:FlxSprite;

	function pixelTransformation()
	{
		camHUD.visible = false;
		inCutscene = true;
		if (pixelPreload == true)
		{
			new FlxTimer().start(0, function(tmr:FlxTimer)
			{
				// preloading pixel characters
				var miniLoadingScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				miniLoadingScreen.scrollFactor.set();
				miniLoadingScreen.screenCenter(XY);
				add(miniLoadingScreen);
				remove(gf);
				remove(dad);
				remove(boyfriend);
				gf = new Character(400, 130, 'gf-pixel');
				dad = new Character(100, 100, 'marrow-pixel');
				boyfriend = new Boyfriend(770, 450, 'bf-pixel');
				add(gf);
				add(dad);
				add(boyfriend);
				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					// removing them and switching them back to normal characters
					remove(gf);
					remove(dad);
					remove(boyfriend);
					gf = new Character(400, 130, SONG.gfVersion);
					dad = new Character(100, 100, SONG.player2);
					boyfriend = new Boyfriend(770, 450, SONG.player1);
					gf.y -= 60;
					gf.x -= 40;
					gf.scrollFactor.set(0.92, 0.92);
					dad.scrollFactor.set(0.92, 0.92);
					add(gf);
					add(dad);
					add(boyfriend);
					new FlxTimer().start(0, function(tmr:FlxTimer)
					{
						if (isStoryMode && !FlxG.save.data.skipDialogue)
						{
							remove(miniLoadingScreen);
							MainMenuState.mainMenuStatePixel = false;
							pixelPreload = false;
						}
						else
						{
							miniLoadingScreen.alpha -= 0.02;
							if (miniLoadingScreen.alpha > 0)
							{
								tmr.reset(0.01);
							}
							else
							{
								remove(miniLoadingScreen);
								MainMenuState.mainMenuStatePixel = false;
								pixelPreload = false;
							}
						}
					});
				});
			});
		}
	}

	function dialogueIntro(?dialogueBox:DialogueBox):Void
	{
		camHUD.visible = false;
		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), '\nIn a Cutscene: Reading Dialogue', iconRPC);
		#end
		inCutscene = true;
		canPause = false;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);
		if (SONG.song == 'Metro' || SONG.song == 'Rails')
			remove(black);
		new FlxTimer().start(1 / 24, function(tmr:FlxTimer)
		{
			black.alpha -= (25/6);

			if (black.alpha > 0)
			{
				tmr.reset(1 / 24);
			}
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (dialogueBox != null)
					{
						add(dialogueBox);
					}
					else
					{
						FlxG.save.data.seenCutscene = true;
						startCountdown();
						camHUD.visible = true;
					}
					remove(black);
				});
			}
		});
	}

	function preDialogueIntro(?preDialogueBox:DialogueBox):Void
	{
		camHUD.visible = false;
		inCutscene = true;
		canPause = false;
		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), '\nIn a Cutscene: Reading Dialogue', iconRPC);
		#end
		new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			FlxG.sound.music.volume = 0;
			FlxG.sound.music.pause();
			FlxG.sound.music.stop();
			vocals.volume = 0;
			vocals.pause();
			vocals.stop();
			if (preDialogueBox != null)
			{
				add(preDialogueBox);
			}
		});
	}

	function postDialogueIntro(?postDialogueBox:DialogueBox):Void
	{
		paused = true;
		camHUD.visible = false;
		inCutscene = true;
		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), '\nIn a Cutscene: Reading Dialogue', iconRPC);
		#end
		FlxG.sound.music.stop();
		canPause = false;
		FlxG.save.data.resetLock = true;
		postDialogueBox = new DialogueBox(false, postDialogue);
		postDialogueBox.cameras = [dialogueHUD];
		postDialogueBox.finishThing = endSong;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);
		black.alpha = 0;
		new FlxTimer().start(0, function(tmr:FlxTimer)
		{
			FlxG.sound.music.stop();
			black.alpha += (1 / 25);
			camHUD.alpha -= (1 / 25);
			if (black.alpha < 1)
				tmr.reset(0.01);
			else
			{
				if (postDialogueBox != null)
					add(postDialogueBox);
			}
		});
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					FlxG.save.data.seenCutscene = true;
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		if (SONG.song == 'Lounge')
		{
			var uselessMe:Float = 0;
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				uselessMe += 0.04;

				boyfriend.alpha = uselessMe;
				gf.alpha = uselessMe;
				dad.alpha = uselessMe;
			}, 25);
		}

		inCutscene = false;
		camHUD.visible = true;

		FlxG.save.data.resetLock = false;

		generateNormalArrows(0);
		generateNormalArrows(1);
		generatePixelArrows(0);
		generatePixelArrows(1);

		#if windows
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		if (!FlxG.save.data.skipIntro)
		{
			trace("the intro plays or sum");
			Conductor.songPosition -= Conductor.crochet * 5;

			var swagCounter:Int = 0;

			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				dad.dance();
				gf.dance();
				boyfriend.playAnim('idle');

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', "set", "go"]);
				introAssets.set('school', [
					'weeb/pixelUI/ready-pixel',
					'weeb/pixelUI/set-pixel',
					'weeb/pixelUI/date-pixel'
				]);
				introAssets.set('schoolEvil', [
					'weeb/pixelUI/ready-pixel',
					'weeb/pixelUI/set-pixel',
					'weeb/pixelUI/date-pixel'
				]);

				var introAlts:Array<String> = introAssets.get('default');
				var altSuffix:String = "";

				for (value in introAssets.keys())
				{
					if (value == curStage)
					{
						introAlts = introAssets.get(value);
						altSuffix = '-pixel';
					}
				}

				switch (swagCounter)

				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
					case 1:
						var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						ready.scrollFactor.set();
						ready.updateHitbox();

						if (curStage.startsWith('school'))
							ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

						ready.screenCenter();
						add(ready);
						FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								ready.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
					case 2:
						var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						set.scrollFactor.set();

						if (curStage.startsWith('school'))
							set.setGraphicSize(Std.int(set.width * daPixelZoom));

						set.screenCenter();
						add(set);
						FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								set.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
					case 3:
						var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						go.scrollFactor.set();

						if (curStage.startsWith('school'))
							go.setGraphicSize(Std.int(go.width * daPixelZoom));

						go.updateHitbox();

						go.screenCenter();
						add(go);
						FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								go.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
					case 4:
				}

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
		else
		{
			startTimer = new FlxTimer().start(0, function(tmr:FlxTimer){});
			trace("the intro skips or sum");
		}
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = function()
		{
			if (SONG.song == 'Rails' && isStoryMode)
			{
				FlxG.sound.music.volume = 0;
				FlxG.sound.music.pause();
				FlxG.sound.music.stop();
				vocals.volume = 0;
				vocals.pause();
				vocals.stop();
				if (!FlxG.save.data.skipDialogue)
					postDialogueIntro();
				else
					endSong();
			}
			else
				endSong();
		}
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
		var songPath = 'assets/data/' + StringTools.replace(PlayState.SONG.song," ", "-").toLowerCase() + '/';
		for (file in sys.FileSystem.readDirectory(songPath))
		{
			var path = haxe.io.Path.join([songPath, file]);
			if (!sys.FileSystem.isDirectory(path))
			{
				if (path.endsWith('.offset'))
				{
					trace('Found offset file: ' + path);
					songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
					break;
				}
				else
				{
					trace('Offset file not found. Creating one @: ' + songPath);
					sys.io.File.saveContent(songPath + songOffset + '.offset', '');
				}
			}
		}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);
			var a:Array<Int> = [0,1,2,3,8,9,10,11,16,17,18,19];

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1]);

				var gottaHitNote:Bool = section.mustHitSection;

				if (!a.contains(songNotes[1]))
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	// Starting Point #1
	private function generateNormalArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			daArrow = new FlxSprite(0, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
					daArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					daArrow.animation.add('green', [6]);
					daArrow.animation.add('red', [7]);
					daArrow.animation.add('blue', [5]);
					daArrow.animation.add('purplel', [4]);

					daArrow.setGraphicSize(Std.int(daArrow.width * daPixelZoom));
					daArrow.updateHitbox();
					daArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							daArrow.x += Note.swagWidth * 0;
							daArrow.animation.add('static', [0]);
							daArrow.animation.add('pressed', [4, 8], 12, false);
							daArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							daArrow.x += Note.swagWidth * 1;
							daArrow.animation.add('static', [1]);
							daArrow.animation.add('pressed', [5, 9], 12, false);
							daArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							daArrow.x += Note.swagWidth * 2;
							daArrow.animation.add('static', [2]);
							daArrow.animation.add('pressed', [6, 10], 12, false);
							daArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							daArrow.x += Note.swagWidth * 3;
							daArrow.animation.add('static', [3]);
							daArrow.animation.add('pressed', [7, 11], 12, false);
							daArrow.animation.add('confirm', [15, 19], 24, false);
					}

				case 'normal':
					daArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					daArrow.animation.addByPrefix('green', 'arrowUP');
					daArrow.animation.addByPrefix('blue', 'arrowDOWN');
					daArrow.animation.addByPrefix('purple', 'arrowLEFT');
					daArrow.animation.addByPrefix('red', 'arrowRIGHT');

					daArrow.antialiasing = true;
					daArrow.setGraphicSize(Std.int(daArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							daArrow.x += Note.swagWidth * 0;
							daArrow.animation.addByPrefix('static', 'arrowLEFT');
							daArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							daArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							daArrow.x += Note.swagWidth * 1;
							daArrow.animation.addByPrefix('static', 'arrowDOWN');
							daArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							daArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							daArrow.x += Note.swagWidth * 2;
							daArrow.animation.addByPrefix('static', 'arrowUP');
							daArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							daArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							daArrow.x += Note.swagWidth * 3;
							daArrow.animation.addByPrefix('static', 'arrowRIGHT');
							daArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							daArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

				default:
					daArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					daArrow.animation.addByPrefix('green', 'arrowUP');
					daArrow.animation.addByPrefix('blue', 'arrowDOWN');
					daArrow.animation.addByPrefix('purple', 'arrowLEFT');
					daArrow.animation.addByPrefix('red', 'arrowRIGHT');

					daArrow.antialiasing = true;
					daArrow.setGraphicSize(Std.int(daArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							daArrow.x += Note.swagWidth * 0;
							daArrow.animation.addByPrefix('static', 'arrowLEFT');
							daArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							daArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							daArrow.x += Note.swagWidth * 1;
							daArrow.animation.addByPrefix('static', 'arrowDOWN');
							daArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							daArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							daArrow.x += Note.swagWidth * 2;
							daArrow.animation.addByPrefix('static', 'arrowUP');
							daArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							daArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							daArrow.x += Note.swagWidth * 3;
							daArrow.animation.addByPrefix('static', 'arrowRIGHT');
							daArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							daArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			daArrow.updateHitbox();
			daArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				daArrow.y -= 10;
				daArrow.alpha = 0;
				FlxTween.tween(daArrow, {y: daArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			daArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(daArrow);
				case 1:
					playerStrums.add(daArrow);
			}

			daArrow.animation.play('static');
			daArrow.x += 50;
			daArrow.x += ((FlxG.width / 2) * player);

			cpuStrums.forEach(function(spr:FlxSprite)
			{
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(daArrow);
		}
	}

	private function generatePixelArrows(player:Int):Void{
		for(individualDirections in 0...4){
			daArrow=new FlxSprite(0, strumLine.y);
			daArrow.loadGraphic(Paths.image('thatmomentwhenyoubecomepixel/arrows-pixels','subway'),true,17,17);
			daArrow.animation.add('green',[6]);
			daArrow.animation.add('red',[7]);
			daArrow.animation.add('blue',[5]);
			daArrow.animation.add('purple',[4]);
			daArrow.setGraphicSize(Std.int(daArrow.width*daPixelZoom));
			daArrow.updateHitbox();
			daArrow.antialiasing=false;
			switch(Math.abs(individualDirections)){
				case 0:{
					daArrow.x+=Note.swagWidth*0;
					daArrow.animation.add('static',[0]);
					daArrow.animation.add('pressed',[4,8],12,false);
					daArrow.animation.add('confirm',[12,16],24,false);
				}case 1:{
					daArrow.x+=Note.swagWidth*1;
					daArrow.animation.add('static',[1]);
					daArrow.animation.add('pressed',[5,9],12,false);
					daArrow.animation.add('confirm',[13, 17],24,false);
				}case 2:{
					daArrow.x+=Note.swagWidth*2;
					daArrow.animation.add('static',[2]);
					daArrow.animation.add('pressed',[6,10],12,false);
					daArrow.animation.add('confirm',[14,18],12,false);
				}case 3:{
					daArrow.x+=Note.swagWidth*3;
					daArrow.animation.add('static',[3]);
					daArrow.animation.add('pressed',[7,11],12,false);
					daArrow.animation.add('confirm',[15,19],24,false);
				}
			}
			daArrow.updateHitbox();
			daArrow.scrollFactor.set();
			if(!isStoryMode){
				daArrow.y-=10;
				daArrow.alpha=0;
				FlxTween.tween(daArrow,{y:daArrow.y+10,alpha:1},1,{ease:FlxEase.circOut,startDelay:0.5+(0.2*individualDirections)});
			}
			daArrow.ID=individualDirections;
			switch(player){
				case 0:{
					pixelCPUStrums.add(daArrow);
				}case 1:{
					pixelPlayerStrums.add(daArrow);
				}
			}
			daArrow.animation.play('static');
			daArrow.x+=50;
			daArrow.x+=((FlxG.width/2)*player);
			pixelCPUStrums.forEach(function(spr:FlxSprite){
				spr.centerOffsets();
			});
			pixelStrumNotes.add(daArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	function tweenCamOut():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 0.7}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		FlxG.save.data.startFullscreen = FlxG.fullscreen;

		#if windows
		if (SONG.song == 'Metro')
		{
			if (curBeat >= 224 && curBeat <= 288 && !FileSystem.exists(Paths.txt('lock')))
			{
				iconRPC = 'marrow-pixel';
			}
			else
			{
				iconRPC = SONG.player2;
			}
		}
		#end
		#if !debug
		perfectMode = false;
		#end

		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');
			var pp1 = luaModchart.getVar("pixelStrum1Visible", 'bool');
			var pp2 = luaModchart.getVar("pixelStrum1Visible", 'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
			// ugh
			for (ind in 0...4)
			{
				pixelStrumNotes.members[ind].visible = pp1;
				if (ind <= pixelPlayerStrums.length)
				{
					pixelPlayerStrums.members[ind].visible = pp2;
				}
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (SONG.song == 'Metro')
			{
				if (curBeat >= 224 && curBeat <= 288)
				{
					if (iconP1.animation.curAnim.name == 'bf-old')
						iconP1.animation.play('bf-pixel');
					else
						iconP1.animation.play('bf-old');
				}
				else
				{
					if (iconP1.animation.curAnim.name == 'bf-old')
						iconP1.animation.play(SONG.player1);
					else
						iconP1.animation.play('bf-old');
				}
			}
			else
			{
				if (iconP1.animation.curAnim.name == 'bf-old')
					iconP1.animation.play(SONG.player1);
				else
					iconP1.animation.play('bf-old');
			}
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.text = "Score: " + songScore;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}
				if (PlayState.SONG.song.toLowerCase() == 'metro')
				{
					if (curBeat >= 224 && curBeat <= 288)
					{
						camFollow.x = dad.getMidpoint().x;
						camFollow.y = dad.getMidpoint().x - 50;
					}
				}


				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'subway':
						if (PlayState.SONG.song.toLowerCase() == 'metro')
						{
							if (curBeat >= 224 && curBeat <= 288)
							{
								camFollow.x = boyfriend.getMidpoint().x - 200;
								camFollow.y = boyfriend.getMidpoint().x - 525;
							}
						}
				}
			}
		}

		if (SONG.song == 'Rails')
		{
			if (!(curBeat >= 133 && curBeat <= 136))
			{
				gfCam.setPosition(camFollow.x, camFollow.y);
			}
		}


		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (SONG.song == 'Lounge' || curSong == 'Lounge')
		{
			switch (curBeat)
			{
				case 0:
					gfSpeed = 2;
				case 96:
					gfSpeed = 1;
				case 144:
					gfSpeed = 2;
			}
		}
		if (curSong == 'Rails' || SONG.song == 'Rails')
		{
			switch (curBeat)
			{
				case 0:
					gfSpeed = 16;
				case 8:
					gfSpeed = 1;
				case 132:
					gfSpeed = 4;
				case 136:
					gfSpeed = 1;
			}
		}
		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R && !FlxG.save.data.resetLock)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{	

				// instead of doing stupid y > FlxG.height
				// we be men and actually calculate the time :)
				if (daNote.tooLate)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}
				
				if (!daNote.modifiedByLua)
				{
					if (FlxG.save.data.downscroll)
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
						if(daNote.isSustainNote)
						{
							// Remember = minus makes notes go up, plus makes them go down
							if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
								daNote.y += daNote.prevNote.height;
							else
								daNote.y += daNote.height / 2;

							// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
							if (!FlxG.save.data.botplay)
							{
								if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
									swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
								swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
					}
					else
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
						if(daNote.isSustainNote)
						{
							daNote.y -= daNote.height / 2;

							if(!FlxG.save.data.botplay)
							{
								if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
							}
						}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";
	
					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					if (SONG.song == 'Rails')
					{
						switch (Math.abs(daNote.noteData))
						{
							case 0:
								if (!(curBeat >= 134 && curBeat <=  136))
									dad.playAnim('singLEFT' + altAnim, true);
							case 1:
								if (!(curBeat >= 134 && curBeat <=  136))
									dad.playAnim('singDOWN' + altAnim, true);
							case 2:
								if (!(curBeat >= 134 && curBeat <=  136))
									dad.playAnim('singUP' + altAnim, true);
							case 3:
								if (!(curBeat >= 134 && curBeat <=  136))
									dad.playAnim('singRIGHT' + altAnim, true);
						}
					}
					else
					{
						switch (Math.abs(daNote.noteData))
						{
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
						}
					}
						
					if (FlxG.save.data.cpuStrums)
					{
						cpuStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(daNote.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
							if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
							else
								spr.centerOffsets();
						});
						pixelCPUStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(daNote.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
							spr.centerOffsets();
						});
					}
	
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
					#end

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.active = false;


					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (daNote.mustPress && !daNote.modifiedByLua)
				{
					daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
					daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
				}
				else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
				{
					daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
					daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
				}



				if (daNote.isSustainNote)
					daNote.x += daNote.width / 2 + 17;


					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
				if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
				{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
						}
						else
						{
							health -= 0.075;
							vocals.volume = 0;
							if (theFunne)
								noteMiss(daNote.noteData, daNote);
						}
	
						daNote.visible = false;
						daNote.kill();
						notes.remove(daNote, true);
				}
					
			});
		}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
			pixelCPUStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay(saveNotes);
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			if (!FlxG.random.bool(0.1))
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			else
				FlxG.sound.playMusic(Paths.music('freakyMenuRare'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					if (!FlxG.random.bool(0.1))
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
					else
						FlxG.sound.playMusic(Paths.music('freakyMenuRare'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					FlxG.save.data.seenCutscene = false;

					if (FlxG.save.data.showCredits && !FlxG.save.data.botplay)
					{
						persistentUpdate = false;
						persistentDraw = true;
						paused = true;
						CreditsState.gameBeaten = true;
						FlxG.switchState(new CreditsState());
						DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), '\nIn a Cutscene: Viewing Credits', iconRPC);
					}
					else
						FlxG.switchState(new MainMenuState());

					// FlxG.switchState(new StoryMenuState());

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					if (SONG.song.toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					FlxG.save.data.seenCutscene = false;
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
		var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		coolText.y -= 350;
		coolText.cameras = [camHUD];
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Float = 350;

		if (FlxG.save.data.accuracyMod == 1)
			totalNotesHit += wife;

		var daRating = daNote.rating;

		switch(daRating)
		{
			case 'shit':
				score = -300;
				combo = 0;
				misses++;
				health -= 0.2;
				ss = false;
				shits++;
				if (FlxG.save.data.accuracyMod == 0)
					totalNotesHit += 0.25;
			case 'bad':
				daRating = 'bad';
				score = 0;
				health -= 0.06;
				ss = false;
				bads++;
				if (FlxG.save.data.accuracyMod == 0)
					totalNotesHit += 0.50;
			case 'good':
				daRating = 'good';
				score = 200;
				ss = false;
				goods++;
				if (health < 2)
					health += 0.04;
				if (FlxG.save.data.accuracyMod == 0)
					totalNotesHit += 0.75;
			case 'sick':
				if (health < 2)
					health += 0.1;
				if (FlxG.save.data.accuracyMod == 0)
					totalNotesHit += 1;
				sicks++;
		}

		// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

		if (daRating != 'shit' || daRating != 'bad')
		{


			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
			var pixelShitPart3:String = '';

			switch (pixelNow)
			{
				case true:
				{
					pixelShitPart1 = "thatmomentwhenyoubecomepixel/";
					pixelShitPart2 = "-pixel";
					pixelShitPart3 = 'subway';
				}
				case false:
				{
					pixelShitPart1 = "";
					pixelShitPart2 = "";
					pixelShitPart3 = '';
				}
			}

			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			if (pixelShitPart3 != '')
				rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2, pixelShitPart3));
			else
				rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay)
				msTiming = 0;							   

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if (!FlxG.save.data.botplay)
				add(currentTimingShown);

			var comboSpr:FlxSprite;
			if (pixelShitPart3 != '')
				comboSpr = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2, pixelShitPart3));
			else
				comboSpr = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!FlxG.save.data.botplay)
				add(rating);
	
			if (curStage.startsWith('school') || pixelNow)
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				rating.antialiasing = false;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
				comboSpr.antialiasing = false;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite;
				if (pixelShitPart3 == '')
					numScore = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				else
					numScore = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2, pixelShitPart3));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (curStage.startsWith('school') || pixelNow)
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				else
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				if (combo >= 10 || combo == 0)
					add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;	

	private function keyShit():Void // I've invested in emma stocks
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [
			controls.LEFT_P,
			controls.DOWN_P,
			controls.UP_P,
			controls.RIGHT_P
		];
		var releaseArray:Array<Bool> = [
			controls.LEFT_R,
			controls.DOWN_R,
			controls.UP_R,
			controls.RIGHT_R
		];
		#if windows
		if (luaModchart != null){
		if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
		if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
		if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
		if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
		};
		#end
 
		// Prevent player input if botplay is on
		if(FlxG.save.data.botplay)
		{
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
			releaseArray = [false, false, false, false];
		} 
		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
					goodNoteHit(daNote);
			});
		}
 
		// PRESSES, check for note hits
		if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			boyfriend.holdTimer = 0;
 
			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later
 
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directionList.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
							{ // if it's the same note twice at < 10ms distance, just delete it
								// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
								dumbNotes.push(daNote);
								break;
							}
							else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
							{ // if daNote is earlier than existing note (coolNote), replace
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});
 
			for (note in dumbNotes)
			{
				FlxG.log.add("killing dumb ass note at " + note.strumTime);
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
 
			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
 
			var dontCheck = false;

			for (i in 0...pressArray.length)
			{
				if (pressArray[i] && !directionList.contains(i))
					dontCheck = true;
			}

			if (perfectMode)
				goodNoteHit(possibleNotes[0]);
			else if (possibleNotes.length > 0 && !dontCheck)
			{
				if (!FlxG.save.data.ghost)
				{
					for (shit in 0...pressArray.length)
						{ // if a direction is hit that shouldn't be
							if (pressArray[shit] && !directionList.contains(shit))
								noteMiss(shit, null);
						}
				}
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
					{
						if (mashViolations != 0)
							mashViolations--;
						scoreTxt.color = FlxColor.WHITE;
						/*
						if (coolNote.harmful)
						{
							health -= 0.45;
							coolNote.wasGoodHit = true;
							coolNote.canBeHit = false;
							coolNote.kill();
							notes.remove(coolNote, true);
							coolNote.destroy();
						}
						else
						*/
							goodNoteHit(coolNote);
					}
				}
			}
			else if (!FlxG.save.data.ghost)
				{
					for (shit in 0...pressArray.length)
						if (pressArray[shit])
							noteMiss(shit, null);
				}

			if (dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
			{
				if (mashViolations > 8)
				{
					trace('mash violations ' + mashViolations);
					scoreTxt.color = FlxColor.RED;
					noteMiss(0,null);
				}
				else
					mashViolations++;
			}

		}
				
		notes.forEachAlive(function(daNote:Note)
		{
			if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
			!FlxG.save.data.downscroll && daNote.y < strumLine.y)
			{
				// Force good note hit regardless if it's too late to hit it or not as a fail safe
				if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
				FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
				{
					if(loadRep)
					{
						//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
						if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
						{
							goodNoteHit(daNote);
							boyfriend.holdTimer = daNote.sustainLength;
						}
					}else {
						goodNoteHit(daNote);
						boyfriend.holdTimer = daNote.sustainLength;
					}
				}
			}
		});
				
		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.playAnim('idle');
		}
 
		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
				spr.animation.play('pressed');
			if (!holdArray[spr.ID])
				spr.animation.play('static');
			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});

		pixelPlayerStrums.forEach(function(spr:FlxSprite)
		{
			if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
				spr.animation.play('pressed');
			if (!holdArray[spr.ID])
				spr.animation.play('static');
			spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		note.rating = Ratings.CalculateRating(noteDiff);

		/* if (loadRep)
		{
			if (controlArray[note.noteData])
				goodNoteHit(note, false);
			else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
			{
				if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
				{
					goodNoteHit(note, false);
				}
			}
		} */
		
		if (controlArray[note.noteData])
		{
			goodNoteHit(note, (mashing > getKeyPresses(note)));
			
			/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
			{
				mashViolations++;

				goodNoteHit(note, (mashing > getKeyPresses(note)));
			}
			else if (mashViolations > 2)
			{
				// this is bad but fuck you
				playerStrums.members[0].animation.play('static');
				playerStrums.members[1].animation.play('static');
				playerStrums.members[2].animation.play('static');
				playerStrums.members[3].animation.play('static');
				health -= 0.4;
				trace('mash ' + mashing);
				if (mashing != 0)
					mashing = 0;
			}
			else
				goodNoteHit(note, false);*/

		}
	}

	function goodNoteHit(note:Note, resetMashViolation = true):Void
	{

		if (mashing != 0)
			mashing = 0;

		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		note.rating = Ratings.CalculateRating(noteDiff);

		// add newest note to front of notesHitArray
		// the oldest notes are at the end and are removed first
		if (!note.isSustainNote)
			notesHitArray.unshift(Date.now());

		if (!resetMashViolation && mashViolations >= 1)
			mashViolations--;

		if (mashViolations < 0)
			mashViolations = 0;

		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note);
				combo += 1;
			}
			else
				totalNotesHit += 1;


			switch (note.noteData)
			{
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 0:
					boyfriend.playAnim('singLEFT', true);
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
			#end


			if(!loadRep && note.mustPress)
				saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));
			
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			pixelPlayerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});
			
			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();
			
			updateAccuracy();
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (FlxG.save.data.distractions)
		{
			if (trainSound.time >= 4700)
			{
				startedMoving = true;
				gf.playAnim('hairBlow');
			}

			if (startedMoving)
			{
				phillyTrain.x -= 400;

				if (phillyTrain.x < -2000 && !trainFinishing)
				{
					phillyTrain.x = -1150;
					trainCars -= 1;

					if (trainCars <= 0)
						trainFinishing = true;
				}

				if (phillyTrain.x < -4000 && trainFinishing)
					trainReset();
			}
		}

	}

	function trainReset():Void
	{
		if (FlxG.save.data.distractions)
		{
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end



		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
			{
				switch (SONG.song)
				{
					case 'Rails':
					{
						if (curBeat > 7 && !(curBeat >= 134 && curBeat <= 136))
						{
							if (curBeat % 2 == 0)
								dad.dance();
						}
					}

					default:
					{
						if (curBeat % 2 == 0)
							dad.dance();
					}
				}
			}
		}

		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (curBeat % 2 == 0)
		{
			switch (SONG.song)
			{
				case 'Lounge':
				{
					if (!boyfriend.animation.curAnim.name.startsWith("sing") && !(curBeat >= 96 && curBeat <= 144))
					{
						boyfriend.playAnim('idle');
					}
					if (!dad.animation.curAnim.name.startsWith("sing") && !(curBeat >= 96 && curBeat <= 144))
					{
						dad.playAnim('idle');
					}
				}

				case 'Metro':
				{
					if (!boyfriend.animation.curAnim.name.startsWith("sing"))
					{
						boyfriend.playAnim('idle');
					}
					if (!dad.animation.curAnim.name.startsWith("sing"))
					{
						dad.playAnim('idle');
					}
					rezIsAReallyGreatAnimator.animation.play('dance');
				}

				case 'Rails':
				{
					if (curBeat > 7)
					{
						if (!boyfriend.animation.curAnim.name.startsWith("sing"))
						{
							boyfriend.playAnim('idle');
						}
						if (!dad.animation.curAnim.name.startsWith("sing"))
						{
							if (!(curBeat >= 134 && curBeat <=  136))
								dad.playAnim('idle');
							else
							{
								dad.playAnim('idle');
							}
						}
						rezIsAReallyGreatAnimator.animation.play('dance');
					}
				}

				default:
				{
					if (!boyfriend.animation.curAnim.name.startsWith("sing"))
					{
						boyfriend.playAnim('idle');
					}
					if (!dad.animation.curAnim.name.startsWith("sing"))
					{
						dad.playAnim('idle');
					}
				}
			}
		}

		switch (SONG.song)
		{
			case 'Lounge':
			{
				switch (curBeat)
				{
					case 111:
					{
						gf.playAnim('cheer');
					}

					case 164:
					{
						gf.playAnim('cheer');
						boyfriend.playAnim('hey', true);
					}

					default:
					{
						if (boyfriend.alpha < 1)
						{
							boyfriend.alpha += 0.25;
							gf.alpha += 0.25;
							dad.alpha += 0.25;
						}
						if (curBeat >= 96 && curBeat <= 144)
						{
							if (!boyfriend.animation.curAnim.name.startsWith("sing"))
							{
								boyfriend.playAnim('idle');
							}
							if (!dad.animation.curAnim.name.startsWith("sing"))
							{
								dad.playAnim('idle');
							}
						}
					}
				}
			}

			case 'Metro':
			{
				// for da color change
				var a:Float;
				var b:Float;
				var c:Float;

				switch (curBeat)
				{
					case 222:
					{
						a = 1;
						b = 1;
						c = 1;

						new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							a -= 0.01;
							b -= 0.03;
							c -= 0.04;

							pixelsubwaybg.setColorTransform(a, a, a);
							subwaybg.setColorTransform(a, a, a);

							pixelTrain.setColorTransform(b, b, b);
							train.setColorTransform(b, b, b);

							boyfriend.setColorTransform(c, c, c);
							dad.setColorTransform(c, c, c);
							gf.setColorTransform(c, c, c);
							rezIsAReallyGreatAnimator.setColorTransform(c, c, c);
						}, 25);
					}

					case 224:
					{
						GameOverSubstate.pixelSequence = true;

						pixelsubwaybg.visible = true;
						pixelTrain.visible = true;
						pixelNow = true;
						pixelStrumNotes.visible = true;
						rezIsAReallyGreatAnimator.visible = false;
						strumLineNotes.visible = false;

						remove(boyfriend);
						remove(dad);
						remove(gf);

						boyfriend = new Boyfriend(770, 450, 'bf-pixel');
						dad = new Character(100, 100, 'marrow-pixel');
						gf = new Character(400, 130, 'gf-pixel');

						boyfriend.x += 200;
						boyfriend.y += 150;

						gf.x += 200;
						gf.y += 250;

						dad.x -= 50;
						dad.y += 150;

						dad.scrollFactor.set(1, 1);
						gf.scrollFactor.set(1, 1);

						// this has to be in a specific order or the layers will be messed up
						add(gf);
						add(dad);
						add(boyfriend);

						boyfriend.setColorTransform(0, 0, 0);
						dad.setColorTransform(0, 0, 0);
						gf.setColorTransform(0, 0, 0);

						if (!iconP1.animation.curAnim.name.startsWith('bf-old'))
						{
							iconP1.animation.play('bf-pixel');
						}
						iconP2.animation.play('marrow-pixel');

						a = 0.75;
						b = 0.25;
						c = 0;

						new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							a += 0.01;
							b += 0.03;
							c += 0.04;

							subwaybg.setColorTransform(a, a, a);

							pixelTrain.setColorTransform(b, b, b);
							train.setColorTransform(b, b, b);

							boyfriend.setColorTransform(c, c, c);
							dad.setColorTransform(c, c, c);
							gf.setColorTransform(c, c, c);
							rezIsAReallyGreatAnimator.setColorTransform(c, c, c);

							if (tmr.elapsedLoops == 25)
							{
								boyfriend.setColorTransform(1, 1, 1);
								dad.setColorTransform(1, 1, 1);
								gf.setColorTransform(1, 1, 1);
								pixelTrain.setColorTransform(1, 1, 1);
								rezIsAReallyGreatAnimator.setColorTransform(1, 1, 1);
								subwaybg.setColorTransform(1, 1, 1);
								train.setColorTransform(1, 1, 1);
							}
						}, 25);
					}

					case 286:
					{
						a = 1;
						b = 1;
						c = 1;

						new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							a -= 0.01;
							b -= 0.03;
							c -= 0.04;

							subwaybg.setColorTransform(a, a, a);

							pixelTrain.setColorTransform(b, b, b);
							train.setColorTransform(b, b, b);

							boyfriend.setColorTransform(c, c, c);
							dad.setColorTransform(c, c, c);
							gf.setColorTransform(c, c, c);
							rezIsAReallyGreatAnimator.setColorTransform(c, c, c);
						}, 25);
					}

					case 288:
					{
						GameOverSubstate.pixelSequence = false;

						pixelsubwaybg.visible = false;
						pixelTrain.visible = false;
						pixelNow = false;
						pixelStrumNotes.visible = false;
						rezIsAReallyGreatAnimator.visible = true;
						strumLineNotes.visible = true;

						boyfriend.x -= 200;
						boyfriend.y -= 150;

						gf.x -= 200;
						gf.y -= 250;

						dad.x += 50;
						dad.y -= 150;

						remove(boyfriend);
						remove(dad);
						remove(gf);

						boyfriend = new Boyfriend(770, 450, SONG.player1);
						dad = new Character(100, 100, SONG.player2);
						gf = new Character(400, 130, SONG.gfVersion);

						gf.y -= 60;
						gf.x -= 40;

						dad.scrollFactor.set(0.92, 0.92);
						gf.scrollFactor.set(0.92, 0.92);

						add(gf);
						add(dad);
						add(boyfriend);

						boyfriend.setColorTransform(0, 0, 0);
						dad.setColorTransform(0, 0, 0);
						gf.setColorTransform(0, 0, 0);

						if (!iconP1.animation.curAnim.name.startsWith('bf-old'))
						{
							iconP1.animation.play(SONG.player1);
						}
						iconP2.animation.play(SONG.player2);

						a = 0.75;
						b = 0.25;
						c = 0;

						new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							a += 0.01;
							b += 0.03;
							c += 0.04;

							subwaybg.setColorTransform(a, a, a);

							pixelTrain.setColorTransform(b, b, b);
							train.setColorTransform(b, b, b);

							gf.setColorTransform(c, c, c);
							boyfriend.setColorTransform(c, c, c);
							dad.setColorTransform(c, c, c);
							rezIsAReallyGreatAnimator.setColorTransform(c, c, c);

							if (tmr.elapsedLoops == 25)
							{
								subwaybg.setColorTransform(1, 1, 1);
								pixelTrain.setColorTransform(1, 1, 1);
								train.setColorTransform(1, 1, 1);
								gf.setColorTransform(1, 1, 1);
								boyfriend.setColorTransform(1, 1, 1);
								dad.setColorTransform(1, 1, 1);
								rezIsAReallyGreatAnimator.setColorTransform(1, 1, 1);
							}
						}, 25);	
					}

					default:
					{
						// i'll add it later here
					}
				}
			}

			case 'Rails':
			{
				var a:Float;

				switch (curBeat)
				{
					case 133:
					{
						tweenCamOut();
						gfCam.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);

						a = 1;

						new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							a -= 0.04;
							camHUD.alpha = a;
						}, 25);
					}

					case 134:
					{
						tweenCamOut();
						dad.playAnim('hereWeGo', true);
					}

					case 135:
					{
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
					}

					case 136:
					{
						a = 0;

						new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							a += 0.04;
							camHUD.alpha = a;
						}, 25);
					}

					default:
					{
						// adding a cool feature here later
					}
				}
			}

			default:
			{
				// bonus song tools
					// coming soon though
			}
		}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions)
				{
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions)
				{
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case "philly":
				if(FlxG.save.data.distractions)
				{
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
					}
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;
}
