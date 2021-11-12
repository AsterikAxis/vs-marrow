package;

import flixel.FlxSprite;
#if desktop
import sys.FileSystem;
#end

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		#if desktop
		if (FileSystem.exists(Paths.image('icons/' + char + '-icons')))
			loadGraphic(Paths.image('icons/' + char + '-icons'), true, 150, 150);
		else
			loadGraphic(Paths.image('icons/default-icons'), true, 150, 150);

		antialiasing = true;
		animation.add(char, (char == 'delta' ? [0, 1, 2] : [0, 1]), 0, false, isPlayer);
		animation.play(char);
		#elseif !desktop
		loadGraphic(Paths.image(char + '-icons'), true, 150, 150);

		antialiasing = true;
		animation.add(char, [0, 1], 0, false, isPlayer);
		animation.play(char);
		#end

		switch(char)
		{
			case 'bf-pixel' | 'gf-pixel' | 'marrow-pixel':
				antialiasing = false;
			case '':
				visible = false;
		}

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
