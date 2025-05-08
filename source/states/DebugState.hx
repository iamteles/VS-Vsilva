package states;

import backend.system.Discord.DiscordIO;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import backend.game.GameData.MusicBeatState;
import objects.menu.Alphabet;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.input.gamepad.FlxGamepad;
import backend.song.SongData;
import flixel.text.FlxText;

using StringTools;

class DebugState extends MusicBeatState
{
	var optionShit:Array<String> = ["play", "credits", "options"];
	static var curSelected:Int = 0;

	var optionGroup:FlxTypedGroup<Alphabet>;

	override function create()
	{
		super.create();
		CoolUtil.playMusic("freakyMenu");

		//Main.setMouse(true);

		// Updating Discord Rich Presence
		DiscordIO.changePresence("In the Main Menu...");

		/*var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(80,80,80));
		bg.screenCenter();
		add(bg);
		*/

		var logo = new FlxSprite(0, 0);
		logo.loadGraphic(Paths.image("logo"));
		logo.scale.set(0.8,0.8);
		logo.x -= 12;
		logo.y -= 80;
		add(logo);

		optionGroup = new FlxTypedGroup<Alphabet>();
		add(optionGroup);

		for(i in 0...optionShit.length)
		{
			var item = new Alphabet(0,0, "nah", false);
			item.align = CENTER;
			item.text = optionShit[i].toUpperCase();
			item.x = FlxG.width / 2;
			item.y = FlxG.height - 230 + ((item.height + 13) * i);
			item.ID = i;
			optionGroup.add(item);
			item.bold = true;
		}

		var doidoSplash:String = 'Doido Engine Kai v3.4.1k';
		var funkySplash:String = 'FNF: VS Vsilva - Remastered';

		var splashTxt = new FlxText(4, 0, 0, '$doidoSplash\n$funkySplash');
		splashTxt.setFormat(Main.gFont, 18, 0xFFFFFFFF, LEFT);
		splashTxt.setBorderStyle(OUTLINE, 0xFF000000, 1.5);
		splashTxt.y = FlxG.height - splashTxt.height - 4;
		add(splashTxt);

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(Controls.justPressed(UI_UP))
			changeSelection(-1);
		if(Controls.justPressed(UI_DOWN))
			changeSelection(1);

		if(Controls.justPressed(ACCEPT))
		{
			switch(optionShit[curSelected])
			{
				case "play":
                    Main.switchState(new states.menu.FreeplayState());
				case "credits":
					Main.switchState(new states.menu.CreditsState());
				case "options":
					openSubState(new subStates.options.OptionsSubState());
					
			}
		}
	}

	public function changeSelection(change:Int = 0)
	{
		curSelected += change;
		curSelected = FlxMath.wrap(curSelected, 0, optionShit.length - 1);

		for(item in optionGroup.members)
		{
			var daText:String = optionShit[item.ID].toUpperCase().replace("-", " ");

			var daBold = (curSelected == item.ID);

			if(daBold)
				item.text = '> ' + daText + ' <';
			else
				item.text = daText;
			item.x = FlxG.width / 2;
		}
	}
}