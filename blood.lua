local myCR 		= 'DarkNCR'							-- Change this to something Unique
local myClass 	= 'DeathKnight'						-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Blood'							-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass			-- Do not change unless you know what your doing
local Sidnum 	= DNCRlib.classSpecNum(myClass ..mySpec)
local config 	= {
	key 	 = mKey,
	profiles = true,
	title 	 = '|T'..DarkNCR.Interface.Logo..':10:10|t' ..myCR.. ' ',
	subtitle = ' ' ..mySpec.. ' '..myClass.. ' Settings',
	color 	 = NeP.Core.classColor('player'),	
	width 	 = 250,
	height 	 = 500,
	config 	 = DNCRClassMenu.Config(Sidnum)
}
NeP.Interface.buildGUI(config)
local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key, 100) end

local exeOnLoad = function()
	DarkNCR.Splash()
	DarkNCR.ClassSetting(mKey)
end
----------	END of do not change area ----------

---------- This Starts the Area of your Rotaion ----------
local Survival = {
	
	{'55233',(function() return F('vampB') end)}, -- Vampiric Blood
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},


--	{'#trinket1', (function() return F('trink1') end)},
--	{'#trinket2', (function() return F('trink2') end)},
}

local Interrupts = {
    -- Place skills that interrupt casts below:        Example: {'skillid'},
    {'47528'},
}

local Cooldowns = {

}

local AoE = {

}

local ST = {
--Vamp blood
	{'55233', 'player.health <= 40'},
--Dancing Rune Weapon	
	{'49028', 'player.health <= 70'},
--BloodBoil to get blood plague	
	{'50842', '!target.debuff(55078)'},
--cast death and decay when you proc crimson scourge(81141)
	{'43265', {'player.buff(81141)', 'player.buff(188290).duration <=4'}}, 
--Marrowrend when Boneshield is low
	{'195182', 'player.buff(195181).count <= 6' },
--Death and Decay if you dont have the Death and Decay buff
	{'43265', {'player.buff(195181).count >= 1', '!player.buff(188290)'}},
--Death Strike to dump Runic Power.
	{'49998', 'player.energy >= 90'},
--Heart Strike as a filler to build Runic Power.
	{'206930'},
--Bloodboil
	{'50842', 'player.spell(50842).charges >= 1'},
}

local Keybinds = {
	-- Pause
	{'pause', 'modifier.alt'},
	
}

local outCombat = {
	{Keybinds},
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{Keybinds},
		{Survival, 'player.health < 100'},
		{Interrupts, 'target.interruptAt(15)'},
		{Cooldowns, 'modifier.cooldowns'},
		{AoE, 'player.area(8).enemies >= 3'},
		{ST, 'target.range <= 6'}
	}, outCombat, exeOnLoad)