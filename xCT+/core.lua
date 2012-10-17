--[[   ____    ______      
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___ 
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/
 
 [=====================================]
 [  Author: Dandruff @ Whisperwind-US  ]
 [  xCT+ Version 3.x.x                 ]
 [  �2012. All Rights Reserved.        ]
 [====================================]]

-- Get Addon's name and Blizzard's Addon Stub
local AddonName, addon = ...

local sgsub, pairs, type, string_format, table_insert = string.gsub, pairs, type, string.format, table.insert
xCT_Plus = addon.engine
local X = xCT_Plus

-- =====================================================
-- Invisible Table Copy Functio, by me :)
-- inv_tcopy(
--    t1,  [table] - Check this table (edited)
--    t2,  [table] - against this table (NOT edited)
--  )
--    Check table 1 against table 2. if a value is found
--  that is not defined in table 1, copy the default
--  value from table 2. Will also examine "subtables".
-- =====================================================
local function inv_tcopy(t1, t2)
  for k, v in pairs(t2) do
    if t1[k] == nil then -- found new key
      t1[k] = t2[k]
    elseif type(t1[k]) == 'table' then
      inv_tcopy(t1[k], t2[k])
    end
  end
end

-- Important Addon Event Handlers
function X:OnInitialize()
  if not xCTSavedDB then
    xCTSavedDB = { }
  end

  self.db = LibStub('AceDB-3.0'):New('xCTSavedDB')
  self.db:RegisterDefaults(addon.defaults)
  self.db.RegisterCallback(self, 'OnProfileChanged', 'RefreshConfig')
  self.db.RegisterCallback(self, 'OnProfileCopied', 'RefreshConfig')
  self.db.RegisterCallback(self, 'OnProfileReset', 'RefreshConfig')
  
  self.db:GetCurrentProfile()
  
  addon.options.args['Profiles'] = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
  
  --[==[if not self.db.profile.frames then
    self.db.profile.frames = { }
  end
  
  inv_tcopy(self.db.profile.frames, addon.DefaultProfile.frames)
  
  if not self.db.profile.spells then
    self.db.profile.spells = { }
  end

  inv_tcopy(self.db.profile.spells, addon.DefaultProfile.spells)
  ]==]
  
  X:UpdatePlayer()
  X:UpdateFrames()
  X:UpdateCombatTextEvents(true)
  X:UpdateSpamSpells()
  X:UpdateItemTypes()
  
  if self.db.profile.showStartupText then
    print("Loaded |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r. To configure, type: |cffFF0000/xct|r")
  end
  
end

function X:RefreshConfig()
  X:UpdateFrames()
  X:UpdateSpamSpells()
  X:UpdateItemTypes()
  collectgarbage()
end

function X:UpdateSpamSpells()
  local spells = addon.options.args.spells.args.spellList.args
  for spellID, entry in pairs(self.db.profile.spells.merge) do
    if entry.class == X.player.class then
      spells[tostring(spellID)] = {
        order = 3,
        type = 'toggle',
        name = GetSpellInfo(spellID),
        desc = "|cffFF0000ID|r " .. spellID,
        get = function(info) return self.db.profile.spells.merge[tonumber(info[#info])].enabled end,
        set = function(info, value) self.db.profile.spells.merge[tonumber(info[#info])].enabled = value end,
      }
    end
  end
end

-- Because of Localization, I have to dynamically create the lists
function X:UpdateItemTypes()
	local itemTypes = { GetAuctionItemClasses() }
  
  local allTypes = {
    order = 100,
    name = "Filter Item Types" .. X.new,
    type = 'group',
    childGroups = "select",
    args = { },
  }
  
	for i, itype in ipairs(itemTypes) do
    local subtypes = { GetAuctionItemSubClasses(i) }
		local group = {
      order = i,
      name = itype,
      type = 'group',
      args = { },
    }
    
    if self.db.profile.spells.items[itype] == nil then
      self.db.profile.spells.items[itype] = { }
    end
    
    if #subtypes > 0 then
      group.args['enableHeader'] = {
        order = 100,
        type = 'header',
        name = "",
        width = "full",
      }
      
      group.args['disableAll'] = {
        order = 101,
        type = 'execute',
        name = "|cffDDDD00Enable All|r",
        width = "half",
        func = function()
            for key in pairs(self.db.profile.spells.items[itype]) do
              self.db.profile.spells.items[itype][key] = true
            end
          end,
      }
      
      group.args['enableAll'] = {
        order = 102,
        type = 'execute',
        name = "|cffDD0000Disable All|r",
        width = "half",
        func = function()
            for key in pairs(self.db.profile.spells.items[itype]) do
              self.db.profile.spells.items[itype][key] = false
            end
          end,
      }
    else
    
      -- Quest Items... maybe others
      if self.db.profile.spells.items[itype][itype] == nil then
        self.db.profile.spells.items[itype][itype] = true
      end
      
      group.args[itype] = {
        order = j,
        type = 'toggle',
        name = "Enable",
        get = function(info) return self.db.profile.spells.items[itype][itype] end,
        set = function(info, value) self.db.profile.spells.items[itype][itype] = value end, 
      }
      
    end
    
		for j, subtype in ipairs(subtypes) do
      if self.db.profile.spells.items[itype][subtype] == nil then
        self.db.profile.spells.items[itype][subtype] = true
      end
      group.args[subtype] = {
        order = j,
        type = 'toggle',
        name = subtype,
        get = function(info) return self.db.profile.spells.items[itype][subtype] end,
        set = function(info, value) self.db.profile.spells.items[itype][subtype] = value end, 
      }
		end
    
    allTypes.args[itype] = group
	end
  
  
  addon.options.args["Frames"].args["loot"].args["typeFilter"] = allTypes
end


function X:UpdateComboPointOptions(force)
  if X.LOADED_COMBO_POINTS_OPTIONS and not force then return end

  local myClass, offset = X.player.class, 1
  
  local comboSpells = {
    order = 100,
    name = "Tracking Spells" .. X.new,
    type = 'group',
    guiInline = true,
    args = { },
  }
  
  local haveAllSpec = false
  
  -- Add "All Specializations" Entries
  for name in pairs(X.db.profile.spells.combo[myClass]) do
  
    if not tonumber(name) then
      if not haveAllSpec then
        haveAllSpec = true
        comboSpells.args['allSpecsHeader'] = {
          order = 0,
          type = 'header',
          name = "All Specializations",
          width = "full",
        }
      end
      comboSpells.args['entry' .. offset] = {
        order = offset,
        type = 'toggle',
        name = name,
        get = function(info) return self.db.profile.spells.combo[myClass][name] end,
        set = function(info, value) self.db.profile.spells.combo[myClass][name] = value end, 
      }
      offset = offset + 1
    end
  end
  
  -- Add the each spec
  for spec in ipairs(X.db.profile.spells.combo[myClass]) do
    local haveSpec = false
    for index, entry in pairs(X.db.profile.spells.combo[myClass][spec] or { }) do
      if not haveSpec then
        haveSpec = true
        local mySpecName = select(2, GetSpecializationInfo(spec)) or "Tree " .. spec
        
        comboSpells.args['mySpecHeader' .. offset] = {
            order = offset,
            type = 'header',
            name = "Specialization: " .. mySpecName,
            width = "full",
          }
        offset = offset + 1
      end
    
      if tonumber(index) then
        comboSpells.args['entry' .. offset] = {
          order = offset,
          type = 'toggle',
          name = GetSpellInfo(entry.id),
          desc = "Unit to track: |cffFF0000" .. entry.unit,
          get = function(info) return self.db.profile.spells.combo[myClass][spec][index].enabled end,
          set = function(info, value) self.db.profile.spells.combo[myClass][spec][index].enabled = value end, 
        }
      else
        -- Special Combo Point ( Unit Power )
        comboSpells.args['entry' .. offset] = {
          order = offset,
          type = 'toggle',
          name = index,
          get = function(info) return self.db.profile.spells.combo[myClass][spec][index] end,
          set = function(info, value) self.db.profile.spells.combo[myClass][spec][index] = value end, 
        }
      end
      
      offset = offset + 1
    end
  end
  
  addon.options.args["Frames"].args["class"].args["tracker"] = comboSpells
  
  X.LOADED_COMBO_POINTS_OPTIONS = true
end

-- Unused for now
function X:OnEnable() end
function X:OnDisable() end

-- This allows us to create our config dialog
local AC = LibStub('AceConfig-3.0')
local ACD = LibStub('AceConfigDialog-3.0')
local ACR = LibStub('AceConfigRegistry-3.0')

-- Register the Options
ACD:SetDefaultSize(AddonName, 800, 550)
AC:RegisterOptionsTable(AddonName, addon.options)

-- Register Slash Commands
X:RegisterChatCommand('xct', 'OpenXCTCommand')

-- Process the slash command ('input' contains whatever follows the slash command)
function X:OpenXCTCommand(input)
  if string.lower(input):match('lock') then
    if X.configuring then
      X:SaveAllFrames()
      X.EndConfigMode()
      print("|cffFF0000x|r|cffFFFF00CT+|r  Frames have been saved. Please fasten your seat belts.")
    else
      X.StartConfigMode()
      print("|cffFF0000x|r|cffFFFF00CT+|r  You are now free to move about the cabin.")
      print("      |cffFF0000/xct lock|r      - Saves your frames")
      print("      |cffFF0000/xct cancel|r  - Cancels all your recent frame movements")
    end
    
    -- return before you can do anything else
    return
  end
  
  if string.lower(input):match('cancel') then
    if X.configuring then
      X:UpdateFrames();
      X.EndConfigMode()
      print("|cffFF0000x|r|cffFFFF00CT+|r  There is nothing to cancel.")
    else
      print("|cffFF0000x|r|cffFFFF00CT+|r  There is nothing to cancel.")
    end
    return
  end
  
  if string.lower(input) == 'help' then
    print("|cffFF0000x|r|cffFFFF00CT+|r  Commands:")
    print("      |cffFF0000/xct lock|r - Locks and unlocks the frame movers.")
    return
  end
  
  -- Open/Close the config menu
  local mode = 'Close'
  if not ACD.OpenFrames[AddonName] then
    mode = 'Open'
  end
  
  if not X.configuring then
    ACD[mode](ACD, AddonName)
  end
end
