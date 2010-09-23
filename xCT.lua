--[[

xCT by affli @ RU-Howling Fjord
All rights reserved.
Thanks ALZA and Shestak for making this mod possible.

]]--
ct={}
-- config starts
ct.damage=true -- show outgoing damage in it's own frame
ct.icons=false -- show outgoing damage icons
ct.damagestyle=true -- set to true to change default damage/healing font above mobs/player heads. you need to restart WoW to see changes!
ct.font,ct.fontsize,ct.fontstyle="Interface\\Addons\\xCT\\HOOGE.TTF",12,"OUTLINE" -- "Fonts\\ARIALN.ttf" is default WoW font.
ct.damagefont="Interface\\Addons\\xCT\\HOOGE.TTF"  -- "Fonts\\FRIZQT__.ttf" is default WoW damage font.
ct.timevisible=3 -- time (seconds) a single message will be visible.
ct.stopvespam=true -- automaticly turns off healing spam for priests in shadowform. HIDE THOSE GREEN NUMBERS PLX!
ct.showdkrunes=true -- show deatchknight rune recharge.
ct.iconsize=30 -- icon size of spells in outgoing damage frame
ct.treshold=1 -- minimum damage to show in damage frame
-- config ends



--do not edit below unless you know what you are doing
-- code starts
-- detect vechile
local numf
if(ct.damage)then
	 numf=4
else
	 numf=3
end

local function SetUnit()
	if(UnitHasVehicleUI("player"))then
		ct.unit="vehicle"
	else
		ct.unit="player"
	end
	CombatTextSetActiveUnit(ct.unit)
end

--limit lines
local function LimitLines()
	for i=1,#ct.frames do
		f=ct.frames[i]
		f:SetMaxLines(f:GetHeight()/ct.fontsize)
	end
end
-- msg flow direction
local function ScrollDirection()
	if (COMBAT_TEXT_FLOAT_MODE=="2") then
		ct.mode="TOP"
	else
		ct.mode="BOTTOM"
	end
	for i=1,3 do
		ct.frames[i]:Clear()
		ct.frames[i]:SetInsertMode(ct.mode)
	end
end
-- partial resists styler
local part="-%s (%s %s)"

-- the function, handles everything
local function OnEvent(self,event,subevent,...)
if(event=="COMBAT_TEXT_UPDATE")then
	if (SHOW_COMBAT_TEXT=="0")then
		return
	else
	if subevent=="DAMAGE"then
		xCT1:AddMessage("-"..arg2,.75,.1,.1)
	elseif subevent=="DAMAGE_CRIT"then
		xCT1:AddMessage("c-"..arg2,1,.1,.1)
	elseif subevent=="SPELL_DAMAGE"then
		xCT1:AddMessage("-"..arg2,.75,.3,.85)
	elseif subevent=="SPELL_DAMAGE_CRIT"then
		xCT1:AddMessage("c-"..arg2,1,.3,.5)

	elseif subevent=="HEAL"then
		xCT2:AddMessage("+"..arg3,.1,.75,.1)
	elseif subevent=="HEAL_CRIT"then
		xCT2:AddMessage("c+"..arg3,.1,1,.1)
	elseif subevent=="PERIODIC_HEAL"then
		xCT2:AddMessage("+"..arg3,.1,.5,.1)

	elseif subevent=="SPELL_CAST"then
		xCT3:AddMessage(arg2,1,.82,0)

	
	elseif subevent=="MISS"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(MISS,.5,.5,.5)
	elseif subevent=="DODGE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(DODGE,.5,.5,.5)
	elseif subevent=="PARRY"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(PARRY,.5,.5,.5)
	elseif subevent=="EVADE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(EVADE,.5,.5,.5)
	elseif subevent=="IMMUNE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(IMMUNE,.5,.5,.5)
	elseif subevent=="DEFLECT"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(DEFLECT,.5,.5,.5)
	elseif subevent=="REFLECT"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(REFLECT,.5,.5,.5)
	elseif subevent=="SPELL_MISS"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(MISS,.5,.5,.5)
	elseif subevent=="SPELL_DODGE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(DODGE,.5,.5,.5)
	elseif subevent=="SPELL_PARRY"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(PARRY,.5,.5,.5)
	elseif subevent=="SPELL_EVADE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(EVADE,.5,.5,.5)
	elseif subevent=="SPELL_IMMUNE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(IMMUNE,.5,.5,.5)
	elseif subevent=="SPELL_DEFLECT"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(DEFLECT,.5,.5,.5)
	elseif subevent=="SPELL_REFLECT"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(REFLECT,.5,.5,.5)

	elseif subevent=="RESIST"and(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
		if(arg3)then
			xCT1:AddMessage(part:format(arg2,RESIST,arg3),.75,.5,.5)
		else
			xCT1:AddMessage(RESIST,.5,.5,.5)
		end
	elseif subevent=="BLOCK"and(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
		if(arg3)then
			xCT1:AddMessage(part:format(arg2,BLOCK,arg3),.75,.5,.5)
		else
			xCT1:AddMessage(BLOCK,.5,.5,.5)
		end
	elseif subevent=="ABSORB"and(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
		if(arg3)then
			xCT1:AddMessage(part:format(arg2,ABSORB,arg3),.75,.5,.5)
		else
			xCT1:AddMessage(ABSORB,.5,.5,.5)
		end
	elseif subevent=="SPELL_RESIST"and(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
		if(arg3)then
			xCT1:AddMessage(part:format(arg2,RESIST,arg3),.75,.5,.5)
		else
			xCT1:AddMessage(RESIST,.5,.5,.5)
		end
	elseif subevent=="SPELL_BLOCK"and(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
		if (arg3)then
			xCT1:AddMessage(part:format(arg2,BLOCK,arg3),.75,.5,.5)
		else
			xCT1:AddMessage(BLOCK,.5,.5,.5)
		end
	elseif subevent=="SPELL_ABSORB"and(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
		if(arg3)then
			xCT1:AddMessage(part:format(arg2,ABSORB,arg3),.75,.5,.5)
		else
			xCT1:AddMessage(ABSORB,.5,.5,.5)
		end

	elseif subevent=="ENERGIZE"and(COMBAT_TEXT_SHOW_ENERGIZE=="1")then
		xCT3:AddMessage("+"..arg2,.1,.1,1)

	elseif subevent=="PERIODIC_ENERGIZE"and(COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE=="1")then
		xCT3:AddMessage("+"..arg2,.1,.1,.75)

	elseif subevent=="SPELL_AURA_START"and(COMBAT_TEXT_SHOW_AURAS=="1")then
		xCT3:AddMessage("+"..arg2,1,.5,.5)
	elseif subevent=="SPELL_AURA_END"and(COMBAT_TEXT_SHOW_AURAS=="1")then
		xCT3:AddMessage("-"..arg2,.5,.5,.5)
	elseif subevent=="SPELL_AURA_START_HARMFUL"and(COMBAT_TEXT_SHOW_AURAS=="1")then
		xCT3:AddMessage("+"..arg2,1,.1,.1)
	elseif subevent=="SPELL_AURA_END_HARMFUL"and(COMBAT_TEXT_SHOW_AURAS=="1")then
		xCT3:AddMessage("-"..arg2,.1,1,.1)

	elseif subevent=="HONOR_GAINED"and(COMBAT_TEXT_SHOW_HONOR_GAINED=="1")then
		xCT3:AddMessage(HONOR.." +"..arg2,.1,.1,1)

	elseif subevent=="FACTION"and(COMBAT_TEXT_SHOW_REPUTATION=="1")then
		xCT3:AddMessage(arg2.." +"..arg3,.1,.1,1)

	elseif subevent=="SPELL_ACTIVE"and(COMBAT_TEXT_SHOW_REACTIVES=="1")then
		xCT3:AddMessage(arg2,1,.82,0)
	end
end

elseif event=="UNIT_HEALTH"and(COMBAT_TEXT_SHOW_LOW_HEALTH_MANA=="1")then
	if arg1==ct.unit then
		if(UnitHealth(ct.unit)/UnitHealthMax(ct.unit)<=COMBAT_TEXT_LOW_HEALTH_THRESHOLD)then
			if (not lowHealth) then
				xCT3:AddMessage(HEALTH_LOW,1,.1,.1)
				lowHealth=true
			end
		else
			lowHealth=nil
		end
	end

elseif event=="UNIT_MANA"and(COMBAT_TEXT_SHOW_LOW_HEALTH_MANA=="1")then
	if arg1==ct.unit then
		local _,powerToken=UnitPowerType(ct.unit)
		if (powerToken=="MANA"and(UnitPower(ct.unit)/UnitPowerMax(ct.unit))<=COMBAT_TEXT_LOW_MANA_THRESHOLD)then
			if (not lowMana)then
				xCT3:AddMessage(MANA_LOW,1,.1,.1)
				lowMana=true
			end
		else
			lowMana=nil
		end
	end

elseif event=="PLAYER_REGEN_ENABLED"and(COMBAT_TEXT_SHOW_COMBAT_STATE=="1")then
		xCT3:AddMessage("-"..LEAVING_COMBAT,.1,1,.1)

elseif event=="PLAYER_REGEN_DISABLED"and(COMBAT_TEXT_SHOW_COMBAT_STATE=="1")then
		xCT3:AddMessage("+"..ENTERING_COMBAT,1,.1,.1)

elseif event=="UNIT_COMBO_POINTS"and(COMBAT_TEXT_SHOW_COMBO_POINTS=="1")then
	if(arg1==ct.unit)then
		local cp=GetComboPoints(ct.unit,"target")
			if(cp>0)then
				r,g,b=1,.82,.0
				if (cp==MAX_COMBO_POINTS)then
					r,g,b=0,.82,1
				end
				xCT3:AddMessage(format(COMBAT_TEXT_COMBO_POINTS,cp),r,g,b)
			end
	end

elseif event=="RUNE_POWER_UPDATE"then
	if(arg2==true)then
		local rune=GetRuneType(arg1);
		local msg=COMBAT_TEXT_RUNE[rune];
		if(rune==1)then 
			r=.75
			g=0
			b=0
		elseif(rune==2)then
			r=.75
			g=1
			b=0
		elseif(rune==3)then
			r=0
			g=1
			b=1	
		end
		if(rune and rune<4)then
			xCT3:AddMessage("+"..msg,r,g,b)
		end
	end

elseif event=="UNIT_ENTERED_VEHICLE"or event=="UNIT_EXITING_VEHICLE"then
	if(arg1=="player")then
		SetUnit()
	end

elseif event=="PLAYER_ENTERING_WORLD"then
	SetUnit()
	ScrollDirection()
	LimitLines()
end
end
-- change damage font (if desired)
if(ct.damagestyle)then
	DAMAGE_TEXT_FONT=ct.damagefont
end

-- the frames
ct.locked=true
ct.frames={}
for i=1,numf do
	local f=CreateFrame("ScrollingMessageFrame","xCT"..i,UIParent)
	f:SetFont(ct.font,ct.fontsize,ct.fontstyle)
	f:SetShadowColor(0,0,0,0)
	f:SetFadeDuration(0.5)
	f:SetTimeVisible(ct.timevisible)
	f:SetMaxLines(1)
	f:SetSpacing(2)
	f:SetWidth(128)
	f:SetHeight(128)
	f:SetJustifyH"LEFT"
	f:SetPoint("CENTER",0,0)
	f:SetMovable(true)
	f:SetResizable(true)
	f:SetMinResize(128,128)
	f:SetMaxResize(768,768)
	if(i==1)then
		f:SetJustifyH"LEFT"
		f:SetPoint("CENTER",-192,-32)
	elseif(i==2)then
		f:SetJustifyH"RIGHT"
		f:SetPoint("CENTER",192,-32)
	elseif(i==3)then
		f:SetJustifyH"CENTER"
		f:SetWidth(256)
		f:SetPoint("CENTER",0,192)
	else
		f:SetJustifyH"RIGHT"
		f:SetPoint("CENTER",320,0)
		if (ct.icons)then
			f:SetSpacing(ct.iconsize)
		end
	end
	ct.frames[i] = f
end

-- register events
local xCT=CreateFrame"Frame"
xCT:RegisterEvent"COMBAT_TEXT_UPDATE"
xCT:RegisterEvent"UNIT_HEALTH"
xCT:RegisterEvent"UNIT_MANA"
xCT:RegisterEvent"PLAYER_REGEN_DISABLED"
xCT:RegisterEvent"PLAYER_REGEN_ENABLED"
xCT:RegisterEvent"UNIT_COMBO_POINTS"
if(ct.showdkrunes and select(2,UnitClass"player")=="DEATHKNIGHT")then
	xCT:RegisterEvent"RUNE_POWER_UPDATE"
end
xCT:RegisterEvent"UNIT_ENTERED_VEHICLE"
xCT:RegisterEvent"UNIT_EXITING_VEHICLE"
xCT:RegisterEvent"PLAYER_ENTERING_WORLD"
xCT:SetScript("OnEvent",OnEvent)

-- turn off blizz ct
CombatText:UnregisterAllEvents()
CombatText:SetScript("OnLoad",nil)
CombatText:SetScript("OnEvent",nil)
CombatText:SetScript("OnUpdate",nil)

-- steal external messages sent by other addons using CombatText_AddMessage
Blizzard_CombatText_AddMessage=CombatText_AddMessage
function CombatText_AddMessage(message,scrollFunction,r,g,b,displayType,isStaggered)
xCT3:AddMessage(message,r,g,b)
end

-- hide some blizz options
InterfaceOptionsCombatTextPanelFriendlyHealerNames:Hide()
COMBAT_TEXT_SCROLL_ARC="" --may cause unexpected bugs, use with caution!

-- hook blizz float mode selector. blizz sucks, because changing  cVar combatTextFloatMode doesn't fire CVAR_UPDATE
hooksecurefunc("InterfaceOptionsCombatTextPanelFCTDropDown_OnClick",ScrollDirection)

-- modify blizz ct options title lol
InterfaceOptionsCombatTextPanelTitle:SetText(COMBATTEXT_LABEL.." (powered by |cffFF0000x|rCT)")

-- color printer
local pr = function(msg)
    print("|cffFF0000x|rCT:", tostring(msg))
end

-- awesome configmode and testmode
local StartConfigmode=function()
	for i=1,numf do
		f=ct.frames[i]
		f:SetBackdrop({
			bgFile="Interface/Tooltips/UI-Tooltip-Background",
			edgeFile="Interface/Tooltips/UI-Tooltip-Border",
			tile=false,tileSize=0,edgeSize=2,
			insets={left=0,right=0,top=0,bottom=0}})
		f:SetBackdropColor(.1,.1,.1,.8)
		f:SetBackdropBorderColor(.1,.1,.1,.5)

		f.fs=f:CreateFontString(nil,"OVERLAY")
		f.fs:SetFont(ct.font,ct.fontsize,ct.fontstyle)
		f.fs:SetPoint("BOTTOM",f,"TOP",0,0)
		if(i==1)then
			f.fs:SetText(DAMAGE.." (drag me)")
			f.fs:SetTextColor(1,.1,.1,.9)
		elseif(i==2)then
			f.fs:SetText(SHOW_COMBAT_HEALING.."(drag me)")
			f.fs:SetTextColor(.1,1,.1,.9)
		elseif(i==3)then
			f.fs:SetText(COMBATTEXT_LABEL.."(drag me)")
			f.fs:SetTextColor(.1,.1,1,.9)
		else
			f.fs:SetText(DAMAGE)
			f.fs:SetTextColor(1,1,0,.9)
		end

		f.t=f:CreateTexture"ARTWORK"
		f.t:SetPoint("TOPLEFT",f,"TOPLEFT",1,-1)
		f.t:SetPoint("TOPRIGHT",f,"TOPRIGHT",-1,-19)
		f.t:SetHeight(20)
		f.t:SetTexture(.5,.5,.5)
		f.t:SetAlpha(.3)

		f.d=f:CreateTexture"ARTWORK"
		f.d:SetHeight(16)
		f.d:SetWidth(16)
		f.d:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-1,1)
		f.d:SetTexture(.5,.5,.5)
		f.d:SetAlpha(.3)

		f.tr=f:CreateTitleRegion()
		f.tr:SetPoint("TOPLEFT",f,"TOPLEFT",0,0)
		f.tr:SetPoint("TOPRIGHT",f,"TOPRIGHT",0,0)
		f.tr:SetHeight(20)

		f:EnableMouse(true)
		f:RegisterForDrag"LeftButton"
		f:SetScript("OnDragStart",f.StartSizing)
		f:SetScript("OnSizeChanged",function(self)
			self:SetMaxLines(self:GetHeight()/ct.fontsize)
			self:Clear()
		end)

		f:SetScript("OnDragStop",f.StopMovingOrSizing)
		ct.locked=false
	end
end

local function EndConfigmode()
	for i=1,numf do
		f=ct.frames[i]
		f:SetBackdrop(nil)
		f.fs:Hide()
		f.fs=nil
		f.t:Hide()
		f.t=nil
		f.d:Hide()
		f.d=nil
		f.tr=nil
		f:EnableMouse(false)
		f:SetScript("OnDragStart",nil)
		f:SetScript("OnDragStop",nil)
		
	end
	ct.locked=true
	pr("Window positions unsaved, don't forget to reload UI.")
end

local function StartTestMode()
--init really random number generator.
	math.random(time()); math.random(); math.random(time())
	
	local TimeSinceLastUpdate=0
	local UpdateInterval
	for i=1,#ct.frames do
	ct.frames[i]:SetScript("OnUpdate",function(self,elapsed)
		UpdateInterval=math.random(65,1000)/250
		TimeSinceLastUpdate=TimeSinceLastUpdate+elapsed
		if(TimeSinceLastUpdate>UpdateInterval)then
			if(i==1)then
			ct.frames[i]:AddMessage("-"..math.random(100000),1,math.random(255)/255,math.random(255)/255)
			elseif(i==2)then
			ct.frames[i]:AddMessage("+"..math.random(50000),.1,math.random(128,255)/255,.1)
			elseif(i==3)then
			ct.frames[i]:AddMessage(COMBAT_TEXT_LABEL,math.random(255)/255,math.random(255)/255,math.random(255)/255)
			else
			if(#ct.frames==4)then
				msg=math.random(40000)
				local _,_,icon=GetSpellInfo(msg)
				if(icon)then
					msg=msg.." \124T"..icon..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:4:60:4:60\124t"
				end
				ct.frames[i]:AddMessage(msg,unpack(dmgcolor[dmindex[math.random(#dmindex)]]))
			end
			TimeSinceLastUpdate = 0
		end
		end
		
	end)
	ct.testmode=true
end
end

local function EndTestMode()
	for i=1,#ct.frames do
		ct.frames[i]:SetScript("OnUpdate",nil)
		ct.frames[i]:Clear()
	end
	ct.testmode=false
	end

-- /xct lock popup dialog
StaticPopupDialogs["XCT_LOCK"]={
	text="To save |cffFF0000x|rCT window positions you need to reload your UI.\n Click "..ACCEPT.." to reload UI.\nClick "..CANCEL.." to do it later.",
	button1=ACCEPT,
	button2=CANCEL,
	OnAccept=ReloadUI,
	OnCancel=EndConfigmode,
	timeout=0,
	whileDead=1,
	hideOnEscape=true,
	showAlert=true,
}

-- slash commands
SLASH_XCT1="/xct"
SlashCmdList["XCT"]=function(input)
	input=string.lower(input)
	if(input=="unlock")then
		if (ct.locked)then
			StartConfigmode()
			pr("unlocked.")
		else
			pr("already unlocked.")
		end
	elseif(input=="lock")then
		if (ct.locked) then
			pr("already locked.")
		else
			StaticPopup_Show("XCT_LOCK")
		end
	elseif(input=="test")then
		if (ct.testmode) then
			EndTestMode()
			pr("test mode disabled.")
		else
			StartTestMode()
			pr("test mode enabled.")
		end

	else
		pr("use |cffFF0000/xct unlock|r to move and resize frames.")
		pr("use |cffFF0000/xct lock|r to lock frames.")
		pr("use |cffFF0000/xct test|r to toggle testmode (sample xCT output).")
	end
end

-- awesome shadow priest helper
if(ct.stopvespam and select(2,UnitClass"player")=="PRIEST")then
	local sp=CreateFrame("Frame")
	local function spOnEvent(...)
		if(GetShapeshiftForm()==1)then
			SetCVar('CombatHealing',0)
		else
			SetCVar('CombatHealing',1)
		end
	end	
	sp:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	sp:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
	sp:SetScript("OnEvent",spOnEvent)
end
dmgcolor={}
dmgcolor[1]={1,1,0} -- physical
dmgcolor[2]={1,.9,.5} -- holy
dmgcolor[4]={1,.5,0} -- fire
dmgcolor[8]={.3,1,.3} -- nature
dmgcolor[16]={.5,1,1} -- frost
dmgcolor[32]={.5,.5,1} -- shadow
dmgcolor[64]={1,.5,1} -- arcane
dmindex={}
dmindex[1]=1
dmindex[2]=2
dmindex[3]=4
dmindex[4]=8
dmindex[5]=16
dmindex[6]=32
dmindex[7]=64
--print( myTable[ math.random( #myTable ) ] )
--print(dmgcolor[dmindex[math.random(#dmindex)]])
--unpack(dmgcolor[dmindex[math.random(#dmindex)]])
--[[
if (ct.damage) then
InterfaceOptionsCombatTextPanelTargetDamage:Hide()
InterfaceOptionsCombatTextPanelPeriodicDamage:Hide()
InterfaceOptionsCombatTextPanelPetDamage:Hide()
local xCT4=CreateFrame("ScrollingMessageFrame","xCT4",UIParent)

	xCT4:SetFont(ct.font,ct.fontsize,ct.fontstyle)
	xCT4:SetShadowColor(0,0,0,0)
	xCT4:SetFadeDuration(0.2)
	xCT4:SetTimeVisible(3)
	xCT4:SetMaxLines(128)
	xCT4:SetSpacing(1)
	xCT4:SetJustifyH"LEFT"
	xCT4:SetPoint("CENTER",0,0)
	xCT4:SetMovable(true)
	xCT4:SetResizable(true)
	xCT4:SetMinResize(128,128)
	xCT4:SetMaxResize(768,768)
	xCT4:SetJustifyH"RIGHT"
	xCT4:SetHeight(768)
	xCT4:SetWidth(128)
	xCT4:SetPoint("CENTER",0,192)
--	TukuiDB.SetTemplate(xCT4)
	xCT4:EnableMouse(true)
	xCT4:RegisterForDrag"LeftButton"
	xCT4:SetScript("OnDragStart",xCT4.StartMoving)
	xCT4:SetScript("OnDragStop",xCT4.StopMovingOrSizing)
xCT4:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
local dmgcolor={}
dmgcolor[1]={1,1,0} -- physical
dmgcolor[2]={1,.9,.5} -- holy
dmgcolor[4]={1,.5,0} -- fire
dmgcolor[8]={.3,1,.3} -- nature
dmgcolor[16]={.5,1,1} -- frost
dmgcolor[32]={.5,.5,1} -- shadow
dmgcolor[64]={1,.5,1} -- arcane

local clu=function(self,event,...)
	if (arg3==UnitGUID"player")or(arg3==UnitGUID"pet")then
		if(arg2=="SWING_DAMAGE")then
			xCT4:AddMessage(arg9)
		elseif(arg2=="SPELL_DAMAGE")or(arg2=="SPELL_PERIODIC_DAMAGE")then
			if(arg12>=ct.treshold)then
				local _,_,icon=GetSpellInfo(arg10)
				if (icon) then
					msg=arg12.." \124T"..icon..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:4:60:4:60\124t"
				else
					msg=arg12
				end
			--	if (arg18) then
			--		msg=msg.."!"
			--	end
				xCT4:AddMessage(msg,unpack(dmgcolor[arg11]))
			end
		elseif(arg2=="SWING_MISSED")then
			xCT4:AddMessage(arg9)

		elseif(arg2=="SPELL_MISSED")then
			xCT4:AddMessage(arg12)






		end
	end
end
xCT4:SetScript("OnEvent",clu)
end
]]
