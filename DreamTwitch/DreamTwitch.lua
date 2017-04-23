--[[

		Script made by Dream
		ENJOY YOUR FREE ELO

		Github : https://github.com/DreamBios/BoL
		Website : http://DreamScripts.gq/   SOON
]]--

if myHero.charName ~= "Twitch" then return end

function Onload()

	Twitch();
end

class 'Twitch';

function Twitch:__init()
	self:Affichage("DreamTwitch is Loading...");
	self:Update();
end

function Twitch:Affichage(text)
	PrintChat("<font color=\"#FF3300\"><b>[DreamTwitch]</b></font> <font color=\"#ffd11a\">" .. text .. "</font>");
end

--[[  AUTO UPDATER... ]]--



function Twitch:Update()
	local version = "0.10";
	local author = "DreamScripts";
	local scriptname = "DreamTwitch";
	local serveradress = "raw.githubusercontent.com";
	local scriptadress = "/DreamBios/BoL/master/DreamTwitch.lua".."?rand="..math.random(1,10000);
	local scriptlocaladress = SCRIPT_PATH.."DreamTwitch.lua";
	local updateurl = "https://"..serveradress..scriptadress;
	local ServerData = GetWebResult(serveradress, "/DreamBios/BoL/master/DreamTwitch.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil;
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				self:Affichage("New version available "..ServerVersion);
				self:Affichage(">>Updating, please don't press F9<<");
				DelayAction(function() DownloadFile(updateurl, scriptlocaladress, function () self:Affichage("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3);
			else
				DelayAction(function() self:Affichage("Hello, "..GetUser()..". You got the latest version! ("..ServerVersion..")") end, 3);
				self:Lancement();
			end
		end
	else
		self:Affichage("Error downloading version info");
	end
end

function Twitch:Lancement()
	self:Menu();
	self:Var();
	self:Orbwalker();
	self:VPred();
	AddTickCallBack(function() 
	self:CurrentMode();
	self:Cooldowns();
	self.Target = self:GetTarget();
	if self.Mode == "Combo" then
		self:Combo();
	end
	if self.Mode == "Harass" then
		self:Harass();
	end
	if self.Mode == "LastHit" then
		self:LastHit();
	end
	if self.Mode == "LaneClear" then
		self:Laneclear();
	end
	end)
end

function Twitch:CurrentMode()
    if _G.AutoCarry and _G.AutoCarry.Keys and _G.Reborn_Loaded ~= nil then
        if _G.AutoCarry.Keys.AutoCarry then 
            if self.Mode ~= "Combo" then
                self.Mode = "Combo";
            end
        elseif _G.AutoCarry.Keys.MixedMode then 
            if self.Mode ~= "Harass" then
                self.Mode = "Harass";
            end
        elseif _G.AutoCarry.Keys.LaneClear then 
            if self.Mode ~= "Harass" then
                self.Mode = "LaneClear";
            end
        elseif _G.AutoCarry.Keys.LastHit then
            if self.Mode ~= "LastHit" then
                self.Mode = "LastHit";
            end
        else
            if self.Mode ~= "None" then
                self.Mode = "None";
            end
        end

    elseif _G.MMA_IsLoaded then

        if _G.MMA_IsOrbwalking then 
            if self.Mode ~= "Combo" then
                self.Mode = "Combo";
            end
        elseif _G.MMA_IsDualCarrying then 
            if self.Mode ~= "Harass" then
                self.Mode = "Harass";
            end
        elseif _G.MMA_IsLaneClearing then 
            if self.Mode ~= "LaneClear" then
                self.Mode = "LaneClear";
            end
        elseif _G.MMA_IsLastHitting then
            if self.Mode ~= "LastHit" then
                self.Mode = "LastHit";
            end
        else
            if self.Mode ~= "None" then
                self.Mode = "None";
            end
        end

    elseif _Pewalk then

        if _G._Pewalk.GetActiveMode().Carry then 
            if self.Mode ~= "Combo" then
                self.Mode = "Combo";
            end
        elseif _G._Pewalk.GetActiveMode().Mixed then 
            if self.Mode ~= "Harass" then
                self.Mode = "Harass";
            end
        elseif _G._Pewalk.GetActiveMode().LaneClear then
            if self.Mode ~= "LaneClear" then
                self.Mode = "LaneClear";
            end
        elseif _G._Pewalk.GetActiveMode().Farm then 
            if self.Mode ~= "LastHit" then
                self.Mode = "LastHit";
            end
        else
            if self.Mode ~= "None" then
                self.Mode = "None";
            end
        end

    elseif _G.NebelwolfisOrbWalkerLoaded then

        if _G.NebelwolfisOrbWalker.Config.k.Combo then
            if self.Mode ~= "Combo" then
                self.Mode = "Combo";
            end
        elseif _G.NebelwolfisOrbWalker.Config.k.Harass then
            if self.Mode ~= "Harass" then
                self.Mode = "Harass";
            end
        elseif _G.NebelwolfisOrbWalker.Config.k.LastHit then
            if self.Mode ~= "LastHit" then
                self.Mode = "LastHit";
            end
        elseif _G.NebelwolfisOrbWalker.Config.k.LaneClear then
            if self.Mode ~= "LaneClear" then
                self.Mode = "LaneClear";
            end
        else
            if self.Mode ~= "None" then
                self.Mode = "None";
            end
        end
    end
end


function Twitch:GetTarget()
	if _G.AutoCarry and _G.AutoCarry.Keys and _G.Reborn_Loaded ~= nil then
		t = _G.AutoCarry.Crosshair:GetTarget();
	elseif _G.MMA_IsLoaded then
		t = _G.MMA_Target();
	elseif _Pewalk then
		t = _Pewalk.GetTarget();
	elseif _G.NebelwolfisOrbWalkerLoaded then
		t = _G.NebelwolfisOrbWalker:GetTarget();
	end
	if ValidTarget(t) and t.type == myHero.type then
		return t
	else
		return nil
	end
end


function Twitch:Cooldowns()
	if myHero:CanUseSpell(_Q) == READY then
		self.Q = true;
	else
		self.Q = false;
	end
	if myHero:CanUseSpell(_W) == READY then
		self.W = true;
	else
		self.W = false;
	end
	if myHero:CanUseSpell(_E) == READY then
		self.E = true;
	else
		self.E = false;
	end
	if myHero:CanUseSpell(_R) == READY then
		self.R = true;
	else
		self.R = false;
	end
end




--[[	MODE FUNCTION	]]--

function Twitch:Combo()
  if self.Q and self.Param.Combo.Q then
  	CastSpell(_Q)
  end
  if self.W and self.Param.Combo.W then
    if self.Target ~= nil then
      if self:Distance(self.Target, myHero) > self.AARange then
        CastW(self.Target)
      end
    end
  end
  if self.E then
  	if self.Target ~= nil then
  		if self:Distance(self.Target, myHero) <= self.ERange and self.FinalEDmg >= self.Target.health then
  			CastSpell(_E)
  		end
  	end
  end
end

function Twitch:Distance(a, b)
  local distance = math.sqrt((b.x-a.x)*(b.x-a.x) + (b.z-a.z)*(b.z-a.z))
  return distance
 end

function Twitch:GetEDamage(target)
	if myHero:GetSpellData(_E).level < 1 then
		return 0
	end
	if E_is_Ready then
		if DeadlyVenom[target.networkID] ~= nil then
			local BaseDamage = { 20, 35, 50, 65, 80}
			local StackDamage = { 15, 20, 25, 30, 35}
			local trueDmg = BaseDamage[myHero:GetSpellData(_E).level] + (((StackDamage[myHero:GetSpellData(_E).level]) + ((myHero.ap * (1 + myHero.apPercent)) * 0.2) + (myHero.addDamage * 0.25)) * DeadlyVenom[target.networkID].stacks)
			if iHaveBeenExhausted then
				self.FinaEDmg = ((trueDmg * (100 / (100 + target.armor))) * 0.6)
			else
				self.FinaEDmg = trueDmg * (100 / (100 + target.armor))
			end
			return self.FinaEDmg
		elseif DeadlyVenomMinions[target.networkID] ~= nil then
			local BaseDamage = { 20, 35, 50, 65, 80}
			local StackDamage = { 15, 20, 25, 30, 35}
			local trueDmg = BaseDamage[myHero:GetSpellData(_E).level] + (((StackDamage[myHero:GetSpellData(_E).level]) + ((myHero.ap * (1 + myHero.apPercent)) * 0.2) + (myHero.addDamage * 0.25)) * DeadlyVenomMinions[target.networkID].stacks)
			if iHaveBeenExhausted then
				self.FinaEDmg = ((trueDmg * (100 / (100 + target.armor))) * 0.6)
			else
				self.FinaEDmg = trueDmg * (100 / (100 + target.armor))
			end
			return FinalDmg
		elseif DeadlyVenomJungle[target.networkID] ~= nil then
			local BaseDamage = { 20, 35, 50, 65, 80}
			local StackDamage = { 15, 20, 25, 30, 35}
			local trueDmg = BaseDamage[myHero:GetSpellData(_E).level] + (((StackDamage[myHero:GetSpellData(_E).level]) + ((myHero.ap * (1 + myHero.apPercent)) * 0.2) + (myHero.addDamage * 0.25)) * DeadlyVenomJungle[target.networkID].stacks)
			if iHaveBeenExhausted then
				self.FinaEDmg = ((trueDmg * (100 / (100 + target.armor))) * 0.6)
			else
				self.FinaEDmgg = trueDmg * (100 / (100 + target.armor))
			end
			return self.FinaEDmg
		else
			return 0
		end
	else
		return 0
	end
end






--[[ A COOL MENU ]]--

function Twitch:Menu()
	self.Param = scriptConfig("[DreamScripts] Twitch", "Twitch");

	self.Param:addSubMenu("Harass Settings", "Harass");
		self.Param.Harass:addParam("W", "Use W :", SCRIPT_PARAM_ONOFF, true);
		self.Param.Harass:addParam("ManaW", "Set a value for W in Mana :", SCRIPT_PARAM_SLICE, 40, 0, 100);
		self.Param.Harass:addParam("E", "Use E :", SCRIPT_PARAM_ONOFF, true);
		self.Param.Harass:addParam("ManaE", "Set a value for E in Mana :", SCRIPT_PARAM_SLICE, 40, 0, 100);


	self.Param:addSubMenu("Combo Settings", "Combo");
		self.Param.Combo:addParam("Q", "Use Q :", SCRIPT_PARAM_ONOFF, true);
		self.Param.Combo:addParam("W", "Use W :", SCRIPT_PARAM_ONOFF, true);

	self.Param:addSubMenu("LaneClear Settings", "WaveClear");
		self.Param.WaveClear:addParam("W", "Use W :", SCRIPT_PARAM_ONOFF, false);
		self.Param.WaveClear:addParam("ManaW", "Set a value for W in Mana :", SCRIPT_PARAM_SLICE, 40, 0, 100);


	self.Param:addSubMenu("Last Hit Settings", "LastHit");
		self.Param.LastHit:addParam("E", "Use E :", SCRIPT_PARAM_ONOFF, true);


	self.Param:addSubMenu("Drawings Settings", "Draw");
		self.Param.Draw:addSubMenu("Spells Settings", "Spell");
			self.Param.Draw.Spell:addParam("Q", "Display Q :", SCRIPT_PARAM_ONOFF, false);
			self.Param.Draw.Spell:addParam("W", "Display W :", SCRIPT_PARAM_ONOFF, false);
			self.Param.Draw.Spell:addParam("E", "Display E :", SCRIPT_PARAM_ONOFF, false);
			self.Param.Draw.Spell:addParam("R", "Display R :", SCRIPT_PARAM_ONOFF, false);
end

function Twitch:Orbwalker()
	if _G.Reborn_Loaded ~= nil then
   	elseif _Pewalk then
	elseif _G.MMA_IsLoaded then
	elseif _G.NebelwolfisOrbWalkerLoaded then
	else
		self:Affichage('You seems have no orbwalker please download Nebelwolfi Orbwalker...')
	end
end

function Twitch:VPred()
    if FileExist(LIB_PATH .. "/VPrediction.lua") then
        require("VPrediction");
        VP = VPrediction();
    else
        local Host = "raw.githubusercontent.com";
        local Path = "/SidaBoL/Scripts/master/Common/VPrediction.lua".."?rand="..math.random(1,10000);
        self:Affichage("VPrediction not found downloading...");
        DownloadFile("https://"..Host..Path, LibPath, function ()  end);
        DelayAction(function () require("VPrediction") end, 5);
    end
end



--[[	TWITCH CONFIG 		]]--

function Twitch:Var()
	self.Q = false;
	self.W = false;
	self.E = false;
	self.R = false; 
	self.Mode = nil;
	self.Target = nil;
	self.Stacks = nil;
	self.AARange = 550;
end




--[[ CAST FUNCTION ]]--

function CastW(unit)
  if unit == nil then return end
  local CastPosition, HitChance = VP:GetLineCastPosition(unit, VARS.W.DELAY, 60, VARS.W.RANGE, VARS.W.SPEED, myHero, true)
  if HitChance >= Menu.Prediction.WVPHC then
    CastSpell(_W, CastPosition.x, CastPosition.z)
  end
end