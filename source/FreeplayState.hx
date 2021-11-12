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

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = FlxG.save.data.daFreeplaySelected;
	var curDifficulty:Int = FlxG.save.data.daDifficulty;

	var scoreText:FlxText;
	// var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
		}

		/*
		if ((Highscore.getScore('Lounge', 2) > 0) && (Highscore.getScore('Metro', 2) > 0) && (Highscore.getScore('Rails', 2) > 0) && (Highscore.getWeekScore(0, 2) > 0))
		{
			songs.push(new SongMetadata('', -1, ''));
		}
		*/

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 55, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		/*
		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);
		*/

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.save.data.startFullscreen = FlxG.fullscreen;

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		#if PRELOAD_ALL
		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.inst(songs[FlxG.save.data.daFreeplaySelected].songName), 0);
		}
		#elseif !PRELOAD_ALL
		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				var randomSong:String = FlxG.random.bool(0.1) ? 'freakyMenu' : 'freakyMenuRare';
				FlxG.sound.playMusic(Paths.music(randomSong));
			}
		}
		#end

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP || FlxG.mouse.wheel == 1)
		{
			changeSelection(-1);
		}
		if (downP || FlxG.mouse.wheel == -1)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK || FlxG.mouse.justPressedRight)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted || FlxG.mouse.justPressed)
		{
			/*
			if (((songs.length - 1) == FlxG.save.data.daFreeplaySelected) && (Highscore.getScore('Lounge', 2) > 0) && (Highscore.getScore('Metro', 2) > 0) && (Highscore.getScore('Rails', 2) > 0) && (Highscore.getWeekScore(0, 2) > 0))
			{
				PlayState.SONG = Song.loadFromJson(Highscore.formatSong('conjunction', FlxG.save.data.daDifficulty), 'conjunction');
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = FlxG.save.data.daDifficulty;
				PlayState.storyWeek = songs[FlxG.save.data.daFreeplaySelected].week;
				LoadingState.loadAndSwitchState(new PlayState());
			}
			else
			{
			*/
				trace(StringTools.replace(songs[FlxG.save.data.daFreeplaySelected].songName," ", "-").toLowerCase());

				var poop:String = Highscore.formatSong(StringTools.replace(songs[FlxG.save.data.daFreeplaySelected].songName," ", "-").toLowerCase(), FlxG.save.data.daDifficulty);

				trace(poop);

				PlayState.SONG = Song.loadFromJson(poop, StringTools.replace(songs[FlxG.save.data.daFreeplaySelected].songName," ", "-").toLowerCase());
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = FlxG.save.data.daDifficulty;
				PlayState.storyWeek = songs[FlxG.save.data.daFreeplaySelected].week;
				trace('CUR WEEK' + PlayState.storyWeek);
				LoadingState.loadAndSwitchState(new PlayState());
			/*
			}
			*/
		}
	}

	function changeDiff(change:Int = 0)
	{
		FlxG.save.data.daDifficulty += change;

		/*
		if (FlxG.save.data.daDifficulty < 0)
			FlxG.save.data.daDifficulty = 2;
		if (FlxG.save.data.daDifficulty > 2)
			FlxG.save.data.daDifficulty = 0;
		*/

		FlxG.save.data.daDifficulty = 2;

		#if !switch
		intendedScore = Highscore.getScore(songs[FlxG.save.data.daFreeplaySelected].songName, FlxG.save.data.daDifficulty);
		#end

		/*
		switch (FlxG.save.data.daDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
		*/
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		FlxG.save.data.daFreeplaySelected += change;

		if (FlxG.save.data.daFreeplaySelected < 0)
			FlxG.save.data.daFreeplaySelected = songs.length - 1;
		if (FlxG.save.data.daFreeplaySelected >= songs.length)
			FlxG.save.data.daFreeplaySelected = 0;
		FlxG.save.flush();

		// selector.y = (70 * FlxG.save.data.daFreeplaySelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[FlxG.save.data.daFreeplaySelected].songName, FlxG.save.data.daDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[FlxG.save.data.daFreeplaySelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[FlxG.save.data.daFreeplaySelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - FlxG.save.data.daFreeplaySelected;
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

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
