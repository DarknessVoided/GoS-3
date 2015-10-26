require('Inspired')

Config = Menu("Garen", "Garen")
Config:SubMenu("c", "Combo")
Config.c:Boolean("R", "Use R", true)
Config.c:Boolean("D", "Draw RDmg", true)

OnTick (function (myHero)
	for _,target in pairs(GetEnemyHeroes()) do
	
	if GotBuff(target,"garenpassivegrit")>0 then
		local isMarked=true
	elseif GotBuff(target,"garenpassivegrit")<1 then
		local isMarked=false
	end
	
	local RDmg=174*GetCastLevel(myHero,_R) + ((GetMaxHP(target)-GetCurrentHP(target))*(0.219+0.067*GetCastLevel(myHero, _R)))
	
	if Config.c.D:Value() and CanUseSpell(myHero,_R) == READY and ValidTarget(target,1000) then
		if isMarked then
			DrawDmgOverHpBar(target,GetCurrentHP(target),0,RDmg,0xffffffff)
		elseif not isMarked then
			DrawDmgOverHpBar(target,GetCurrentHP(target),0,CalcDamage(myHero, target, 0, RDmg),0xffffffff)
		end
	end
	
	if Config.c.R:Value() and CanUseSpell(myHero,_R) == READY and ValidTarget(target, GetCastRange(myHero,_R)) then
		if not isMarked and GetCurrentHP(target)+GetDmgShield(target) < CalcDamage(myHero, target, 0, RDmg) then
			CastTargetSpell(target,_R)
		elseif isMarkend and GetCurrentHP(target)+GetDmgShield(target) < RDmg then
			CastTargetSpell(target,_R)
		end
	end	
	end
end)

PrintChat("Garen Auto R - Logge")
