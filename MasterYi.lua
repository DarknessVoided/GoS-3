if GetObjectName(GetMyHero()) ~= "MasterYi" then return end

require("Inspired")
require("IOW")

local myHero=GetMyHero()
local delay=0
local spelltype=0

--FORMAT:
--Delay,spelltype,Hotkey/Name
--spelltype: 0 Normal
--spelltype: 1 Targeted
--spelltype: 2 Nuke
--spelltype: 3 Gapcloser

Q_ON = {
["Aatrox"]		= {0,0,_R},
["Ahri"]		= {0,0,_E},
["Akali"]		= {0,1,_Q},
["Alistar"]		= {0,0,_Q,0,1,_W},
["Amumu"]		= {0,0,_Q,0,0,_R},
["Anivia"]		= {0,1,_E},
["Annie"]		= {0,1,_Q,0,2,_R},
["Ashe"]		= {0,0,_R},
["Azir"]		= {0,0,_R},
["Blitzcrank"]		= {0,0,_Q},
["Brand"]		= {0,1,_R},
["Caitlyn"]		= {0,3,_E,0,1,_R},
["Cassiopeia"]		= {0,0,_R},
["Darius"]		= {0,2,_R},
["Draven"]		= {0,0,_R},
["Diana"]		= {0,1,_R},
["Elise"]		= {0,0,_E},		-- ADD NAME HUMAN FORM
["Ezreal"]		= {0,3,_E},
["Fizz"]		= {0,0,_R},
--[Fiora"]		= {0,0,_W},
["Garen"]		= {0,2,_R},
["Gragas"]		= {0,3,_E,0,0,_R},
["Graves"]		= {0,2,_R},
["Hecarim"]		= {0,3,_R},
["JarvanIV"]		= {0,3,"JarvanIVEQ",0,0,_R},
["Jinx"]		= {0,2,_R},
["Kassadin"]		= {0,3,_R},
["Katarina"]		= {0,1,_Q},
["KhaZix"]		= {0,3,_E},
["LeeSin"]		= {0,2,_R},
["Lissandra"]		= {0,2,_R},
["Lulu"]		= {0,1,_W},
["Lucian"]		= {0,3,_E},
["Lux"]			= {0,0,_Q},
["Malphite"]		= {0,0,_R},
["Malzahar"]		= {0,1,_R},
["Morgana"]		= {0,0,_Q,0,1,_R},
["Nautilus"]		= {0,1,_R},
["Nocturne"]		= {0,1,"NocturneParanoia2"},
["Orianna"]		= {0,0,_R},
["Pantheon"]		= {0,1,_W},
["Quinn"]		= {0,0,_Q,0,1,_E},
["Rammus"]		= {0,1,_E},
["RekSai"]		= {0,3,_E},
--["Renekton"]		= {0,1,_W},		--It's the aa
["Rumble"]		= {0,0,_R},
["Ryze"]		= {0,1,_W},
["Sejuani"]		= {0,0,_R},
--["Shaco"]		= {0,3,_Q},			--too fast
["Shen"]		= {0,3,_E},
["Singed"]		= {0,1,_E},
["Skarner"]		= {0,1,_R},
["Sona"]		= {0,0,_R},
["Syndra"]		= {20,1,_R},
["Talon"]		= {0,1,_R},		--needs test
["Taric"]		= {10,1,_E},
["Teemo"]		= {10,1,_Q},
["Thresh"]		= {0,0,_E},
["Tryndamere"]		= {0,3,_E},
["TwistedFate"]		= {0,1,"goldcardpreattack"},		--special 
["Urgot"]		= {0,1,_R},
["Varus"]		= {0,0,_R},
["Vayne"]		= {0,1,_E},
["Veigar"]		= {0,1,_R},
["Vi"]			= {10,1,_R},
["Vladimir"]		= {4950,2,_R},
--["Warwick"]		= {0,1,_R},			--toofast
["Xerath"]		= {0,0,_E},
["Trundle"]		= {0,1,_R},
["Tristana"]		= {0,3,_W,0,3,_R},
["Yasuo"]		= {0,0,"yasuoq3",0,0,"yasuoq3w"},		--special
["Zyra"]		= {0,0,_E},

["Riven"]		= {0,0,"rivenizunablade"},
--["Rengar"]		= {0,1,"RengarBasicAttack",0,1,"RengarBasicAttack2"},
["Jax"]		= {1050,0,_E},
["Karthus"]		= {3000,1,_R},
["Zed"]		= {0,1,_R}
}

-- Menu
local Config = Menu("Master Yi", "MY")
Config:SubMenu("c", "Combo")
Config.c:Boolean("E", "Use E", true)
Config.c:Boolean("W", "Use W antinuke", true)
Config.c:Boolean("KSQ", "Killsteal with Q", false)

Config:SubMenu("q","Q config")
Config.q:Boolean("AQ","Use awesome Q",true)

Config:SubMenu("m", "Misc")
Config.m:Boolean("AL","AutoLevel", true)
Config.m:Boolean("It","Items", true)
Config.m:Boolean("Debug","Print Messages",true)



-- Start
OnLoop(function(myHero)
	if not IsDead(myHero) then
		local unit = GoS:GetTarget(1500, DAMAGE_NORMAL)		
		ks()
		ALvL()
		UseItems()
	end
end)


OnProcessSpell(function(unit, spellProc)
	if not IsDead(myHero) and Config.q.AQ:Value() and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero and Q_ON[GetObjectName(unit)] then
	--PrintChat(GetObjectType(unit)..":"..spellProc.name)						--DEBUG
	--	PrintChat(GetObjectName(spellProc.target))
		for n,slot in pairs(Q_ON[GetObjectName(unit)]) do
			if n%3==1 then
				delay=slot
			elseif n%3==2 then
				spelltype=slot
			elseif n%3==0 then
--				PrintChat("Looking for Spell: "..GetCastName(unit,slot).." spelltype: "..spelltype)
				if slot==_Q or slot==_W or slot==_E or slot==_R or spellProc.name==slot then						
					--print("Looking for "..GetCastName(unit,slot))			--DEBUG
					if (spellProc.name==GetCastName(unit,slot) or spellProc.name==slot) then
--						if GetObjectName(unit)=="Rengar" and not GotBuff("RengarR") then return end
						if (spelltype==0 or spelltype==1 or spelltype==3) then
							if GoS:GetDistance(unit,myHero)<GetCastRange(myHero,_Q) then
							GoS:DelayAction( 
								function()
									if GoS:ValidTarget(unit,GetCastRange(myHero,_Q)) then
										if Config.m.Debug:Value() then PrintChat("Q'd on "..GetObjectName(unit)..":"..spellProc.name.." with "..delay.."ms delay") end
										CastTargetSpell(unit,_Q)
									end
								end
								,delay)
							elseif spelltype==1 then 
							PrintChat("Q'd on Creep "..spellProc.name.." with "..delay.."ms delay")
							jump2creep()
							end
						elseif spelltype==2 and CanUseSpell(myHero, _W)==0 and GoS:GetDistance(unit,myHero)<GetCastRange(myHero,_Q) and Config.c.W.Value() then
							GoS:DelayAction(
							function()
								if Config.m.Debug:Value() then PrintChat("W'd on "..GetObjectName(unit)..":"..spellProc.name.." with "..delay.."ms delay") end
								CastSpell(_W)
							end
							,delay)
						else
							PrintChat("Error 01: No spell reaction found for "..spellProc.name)
						end
						delay=0
					end
				end
			end
		end
	end
	if (spellProc.name:find("MasterYiBasicAttack") or spellProc.name:find("MasterYiBasicAttack2")) and Config.c.E:Value() and GoS:GetDistance(myHero,GoS:ClosestEnemy(pos))<150 and CanUseSpell(myHero, _E)==0 then
		CastSpell(_E)
	end
end)

function jump2creep()
	GoS:DelayAction( 
	function()
		for _,creep in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
			if GoS:GetDistance(creep,myHero)<GetCastRange(myHero,_Q) then
				CastTargetSpell(creep,_Q)
			end
		end
	end
	,delay)
end


function ks()
	for i,unit in pairs(GoS:GetEnemyHeroes()) do
		if Config.c.KSQ:Value() and CanUseSpell(myHero,_Q) and GoS:ValidTarget(unit,GetCastRange(myHero,_Q)) and GetCurrentHP(unit) < GoS:CalcDamage(myHero, unit, 0, (35*GetCastLevel(myHero,_Q)-5+GetBonusDmg(myHero)))+GetDmgShield(unit) then 
				CastTargetSpell(unit,_Q)
		end
	end
end

LvLSeq={_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W}
function ALvL()
	if Config.m.AL:Value() then
		if GetLevel(myHero)==3 then --ARAM AutoLvL
			if LevelSpell(LvLSeq[3]) then
				LevelSpell(LvLSeq[1])
				LevelSpell(LvLSeq[2])
				end
		else
			LevelSpell(LvLSeq[GetLevel(myHero)])
		end
	end
end

--Q,E,W; 1R,2Q,3E,4W
meeleItems={3153,3144,3142,3074,3077,3143}
--	    Botr,Bilg,Ghos,Hydr,Tiam,Rand
cleanseItems={3140,3139}
--	     Merc,QSS

function UseItems()
	if Config.m.It:Value() then 
	local unit = GoS:GetTarget(1500, DAMAGE_NORMAL)
		for _,id in pairs(cleanseItems) do
			if GetItemSlot(myHero,id) > 0 and GotBuff(myHero, "rocketgrab2") > 0 or GotBuff(myHero, "charm") > 0 or GotBuff(myHero, "fear") > 0 or GotBuff(myHero, "flee") > 0 or GotBuff(myHero, "snare") > 0 or GotBuff(myHero, "taunt") > 0 or GotBuff(myHero, "suppression") > 0 or GotBuff(myHero, "stun") > 0 or GotBuff(myHero, "zedultexecute") > 0 or GotBuff(myHero, "summonerexhaust") > 0  then
				CastTargetSpell(myHero, GetItemSlot(myHero,id))
			end
		end
		if IOW:Mode() == "Combo" then
			for _,id in pairs(meeleItems) do
				if GetItemSlot(myHero,id) > 0 and GoS:ValidTarget(unit, 550) then
				CastTargetSpell(unit, GetItemSlot(myHero,id))
				end
			end
		end
	end
end



PrintChat("Yi Loaded - Enjoy your game - Logge")
