--[[
  三栏超大物品栏 ~80格
  - 三排布局，格数可配置
  - 快捷键作用排可配置（默认最底排）
  - 整体上移可配置（船标/船装备槽）
  - 分离/融合背包
  - 可选简易5格装备；默认关闭以便与 Mega Extra Slot 并用
]]

GLOBAL.setmetatable(env, { __index = function(_, k) return GLOBAL.rawget(GLOBAL, k) end })

local INVENTORYSIZE = GetModConfigData("INVENTORYSIZE") or 80
local HOTKEY_ROW = GetModConfigData("HOTKEY_ROW") or 3
local UI_OFFSET_Y = GetModConfigData("UI_OFFSET_Y") or 40
local ENABLE_SIMPLE_EQUIP = GetModConfigData("ENABLE_SIMPLE_EQUIP") == true
local ENABLE_BACKPACK_IN_INV = GetModConfigData("ENABLE_BACKPACK_IN_INV") == true
local SLOT_GROUP_SEP = GetModConfigData("SLOT_GROUP_SEP") ~= false

if type(INVENTORYSIZE) ~= "number" or INVENTORYSIZE < 15 then
    INVENTORYSIZE = 80
end
if HOTKEY_ROW < 1 or HOTKEY_ROW > 3 then
    HOTKEY_ROW = 3
end

--------------------------------------------------------------------------
-- 可选：简易额外装备栏（背包+护符）。与 Mega7 冲突时请在配置中关闭。
--------------------------------------------------------------------------
if ENABLE_SIMPLE_EQUIP then
    local Inv = require "widgets/inventorybar"
    GLOBAL.EQUIPSLOTS = {
        HANDS = "hands",
        HEAD = "head",
        BODY = "body",
        BACK = "back",
        NECK = "neck",
    }
    GLOBAL.EQUIPSLOT_IDS = {}
    local slot = 0
    for k, v in pairs(GLOBAL.EQUIPSLOTS) do
        slot = slot + 1
        GLOBAL.EQUIPSLOT_IDS[v] = slot
    end

    AddGlobalClassPostConstruct("widgets/inventorybar", "Inv", function(self)
        if self._tripleinv_simple_equip then
            return
        end
        self._tripleinv_simple_equip = true
        if self.AddEquipSlot ~= nil then
            self:AddEquipSlot(GLOBAL.EQUIPSLOTS.BACK, "images/hud.xml", "equip_slot.tex")
            self:AddEquipSlot(GLOBAL.EQUIPSLOTS.NECK, "images/hud.xml", "equip_slot.tex")
        end
    end)

    local function SetEquipSlotPrefab(prefab, eslot)
        AddPrefabPostInit(prefab, function(inst)
            if inst.components.equippable ~= nil then
                inst.components.equippable.equipslot = eslot
            end
        end)
    end
    -- 常见背包 / 护符（基础集，完整列表可后续扩展）
    for _, p in ipairs({ "backpack", "piggyback", "krampus_sack", "icepack", "seedpouch", "candybag", "spicepack" }) do
        SetEquipSlotPrefab(p, GLOBAL.EQUIPSLOTS.BACK)
    end
    for _, p in ipairs({ "amulet", "blueamulet", "purpleamulet", "orangeamulet", "greenamulet", "yellowamulet", "amulet_red" }) do
        -- 红护符 prefab 多为 amulet
    end
    AddPrefabPostInit("amulet", function(inst)
        if inst.components.equippable then inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK end
    end)
    AddPrefabPostInit("blueamulet", function(inst)
        if inst.components.equippable then inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK end
    end)
    AddPrefabPostInit("purpleamulet", function(inst)
        if inst.components.equippable then inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK end
    end)
    AddPrefabPostInit("orangeamulet", function(inst)
        if inst.components.equippable then inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK end
    end)
    AddPrefabPostInit("greenamulet", function(inst)
        if inst.components.equippable then inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK end
    end)
    AddPrefabPostInit("yellowamulet", function(inst)
        if inst.components.equippable then inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK end
    end)
end

--------------------------------------------------------------------------
-- 扩容核心
--------------------------------------------------------------------------
local MAXITEMSLOTS = INVENTORYSIZE

local inventory = require("components/inventory")
local inventory_replica = require("components/inventory_replica")
local inventorybar = require("widgets/inventorybar")
local InvSlot = require("widgets/invslot")
local Image = require("widgets/image")
local Widget = require("widgets/widget")
local EquipSlot = require("widgets/equipslot")
local ItemTile = require("widgets/itemtile")
local Text = require("widgets/text")
local ThreeSlice = require("widgets/threeslice")
local TEMPLATES = require("widgets/templates")
local Profile = GLOBAL.Profile

inventory.maxslots = MAXITEMSLOTS

if MAXITEMSLOTS ~= 15 then
    local SourceModifierList = require("util/sourcemodifierlist")
    local net_entity = GLOBAL.net_entity
    local makereadonly = GLOBAL.makereadonly

    local function OnDeath(inst)
        if inst.components.inventory ~= nil then
            inst.components.inventory:DropEverything(true)
        end
    end

    local function OnOwnerDespawned(inst)
        if inst.components.inventory ~= nil then
            for _, item in pairs(inst.components.inventory.itemslots) do
                if item ~= nil then
                    item:PushEvent("player_despawn")
                end
            end
            for _, equip in pairs(inst.components.inventory.equipslots) do
                if equip ~= nil then
                    equip:PushEvent("player_despawn")
                end
            end
            if inst.components.inventory.activeitem ~= nil then
                inst.components.inventory.activeitem:PushEvent("player_despawn")
            end
        end
    end

    function inventory._ctor(self, inst)
        self.inst = inst
        self.isopen = false
        self.isvisible = false
        self.ignoreoverflow = false
        self.ignorefull = false
        self.silentfull = false
        self.ignoresound = false
        self.itemslots = {}
        self.maxslots = MAXITEMSLOTS
        self.equipslots = {}
        self.heavylifting = false
        self.activeitem = nil
        self.acceptsstacks = true
        self.ignorescangoincontainer = false
        self.opencontainers = {}
        self.opencontainerproxies = {}
        self.dropondeath = true
        inst:ListenForEvent("death", OnDeath)
        self.isexternallyinsulated = SourceModifierList(inst, false, SourceModifierList.boolean)
        inst:ListenForEvent("player_despawn", OnOwnerDespawned)
        if inst.replica.inventory ~= nil and inst.replica.inventory.classified ~= nil then
            makereadonly(self, "maxslots")
            makereadonly(self, "acceptsstacks")
            makereadonly(self, "ignorescangoincontainer")
        end
    end

    function inventory_replica:GetNumSlots()
        return MAXITEMSLOTS
    end

    local function addItemSlotNetvarsInInventory(inst)
        if inst._items ~= nil and #inst._items < MAXITEMSLOTS then
            for i = #inst._items + 1, MAXITEMSLOTS do
                table.insert(inst._items, net_entity(inst.GUID, "inventory._items[" .. tostring(i) .. "]", "items[" .. tostring(i) .. "]dirty"))
            end
        end
    end
    AddPrefabPostInit("inventory_classified", addItemSlotNetvarsInInventory)
end

-- 是否允许背包进物品栏
if not ENABLE_BACKPACK_IN_INV then
    -- 保持默认：多数情况下背包仍走装备栏；具体 itemtest 由其它模组处理
end

--------------------------------------------------------------------------
-- 三排布局 + 快捷键排映射
-- 被选为快捷键的那一排使用较小的 slot 序号（从1开始），以便1-0键对应
--------------------------------------------------------------------------
local W = 68
local SEP = 12
local YSEP = 8
local INTERSEP = SLOT_GROUP_SEP and 28 or 12
local HUD_ATLAS = "images/hud.xml"

local function SplitRows(n)
    local a = math.floor(n / 3)
    local b = math.floor(n / 3)
    local c = n - a - b
    -- 尽量让快捷键所在排不少于其它排
    return a, b, c
end

local function BuildSlotOrder(n, hotkey_row)
    local r1, r2, r3 = SplitRows(n)
    local rows = { r1, r2, r3 }
    -- order[visual_row] = { slot indices }
    local visual = { {}, {}, {} }
    local next_slot = 1
    -- 先填快捷键排
    local hk = hotkey_row
    for i = 1, rows[hk] do
        visual[hk][i] = next_slot
        next_slot = next_slot + 1
    end
    for row = 1, 3 do
        if row ~= hk then
            for i = 1, rows[row] do
                visual[row][i] = next_slot
                next_slot = next_slot + 1
            end
        end
    end
    return visual, rows
end

local function XForIndexInRow(index_in_row, row_len, total_w)
    local interseps = SLOT_GROUP_SEP and math.floor((index_in_row - 1) / 5) or 0
    local x = -total_w / 2 + W / 2 + interseps * (INTERSEP - SEP) + (index_in_row - 1) * W + (index_in_row - 1) * SEP
    return x
end

local function RowTotalW(row_len)
    local interseps = SLOT_GROUP_SEP and math.floor((row_len - 1) / 5) or 0
    return row_len * W + (row_len - 1) * SEP + interseps * (INTERSEP - SEP)
end

AddGlobalClassPostConstruct("widgets/inventorybar", "Inv", function(self)
    if self._tripleinv_hooked then
        return
    end
    self._tripleinv_hooked = true

    local old_Rebuild = self.Rebuild
    function self:Rebuild()
        if MAXITEMSLOTS == 15 then
            return old_Rebuild(self)
        end

        if self.cursor ~= nil then
            self.cursor:Kill()
            self.cursor = nil
        end
        if self.toprow then self.toprow:Kill() end
        if self.midrow then self.midrow:Kill() end
        if self.bottomrow then self.bottomrow:Kill() end

        self.toprow = self.root:AddChild(Widget("toprow"))
        self.midrow = self.root:AddChild(Widget("midrow"))
        self.bottomrow = self.root:AddChild(Widget("bottomrow"))
        self.inv = {}
        self.equip = self.equip or {}
        self.backpackinv = {}

        local overflow = self.owner.replica.inventory:GetOverflowContainer()
        local controller_attached = TheInput:ControllerAttached()
        local integrated = false
        if Profile ~= nil and Profile.GetIntegratedBackpack ~= nil then
            integrated = Profile:GetIntegratedBackpack()
        end
        local do_integrated_backpack = overflow ~= nil and (controller_attached or integrated)

        local visual, rows = BuildSlotOrder(MAXITEMSLOTS, HOTKEY_ROW)
        local max_row_len = math.max(rows[1], rows[2], rows[3])
        local total_w = RowTotalW(max_row_len)

        -- 装备栏
        local eslot_order = {}
        if self.equipslotinfo ~= nil then
            for k, v in ipairs(self.equipslotinfo) do
                local slot = EquipSlot(v.slot, v.atlas, v.image, self.owner)
                self.equip[v.slot] = self.toprow:AddChild(slot)
                table.insert(eslot_order, slot)
                local item = self.owner.replica.inventory:GetEquippedItem(v.slot)
                if item then
                    slot:SetTile(ItemTile(item))
                end
            end
        end
        local num_equip = #eslot_order
        local equip_block_w = num_equip > 0 and (num_equip * W + (num_equip - 1) * SEP + INTERSEP) or 0

        -- 装备格放在最上一排左侧
        local equip_x = -total_w / 2 - equip_block_w + W / 2
        for i, slot in ipairs(eslot_order) do
            slot:SetPosition(equip_x + (i - 1) * (W + SEP), 0, 0)
        end

        local y_top = (W + YSEP)
        local y_mid = 0
        local y_bot = -(W + YSEP)
        local y_of = { y_top, y_mid, y_bot }
        local row_widgets = { self.toprow, self.midrow, self.bottomrow }

        for row = 1, 3 do
            local list = visual[row]
            for i, slot_index in ipairs(list) do
                local slot = InvSlot(slot_index, HUD_ATLAS, "inv_slot.tex", self.owner, self.owner.replica.inventory)
                self.inv[slot_index] = row_widgets[row]:AddChild(slot)
                local x = XForIndexInRow(i, #list, total_w)
                slot:SetPosition(x, 0, 0)
                slot.top_align_tip = W * 0.5 + YSEP
                local item = self.owner.replica.inventory:GetItemInSlot(slot_index)
                if item ~= nil then
                    slot:SetTile(ItemTile(item))
                end
            end
            row_widgets[row]:SetPosition(0, y_of[row], 0)
        end

        -- 融合背包：挂在底排下方
        if self.backpack then
            self.inst:RemoveEventCallback("itemget", self._triple_bp_get, self.backpack)
            self.inst:RemoveEventCallback("itemlose", self._triple_bp_lose, self.backpack)
            self.backpack = nil
        end

        if do_integrated_backpack and overflow ~= nil then
            local num = overflow:GetNumSlots()
            local bp_y = y_bot - (W + YSEP)
            for k = 1, num do
                local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, overflow)
                self.backpackinv[k] = self.bottomrow:AddChild(slot)
                local x = XForIndexInRow(k, math.max(num, max_row_len), total_w)
                slot:SetPosition(x, bp_y - y_bot, 0)
                local item = overflow:GetItemInSlot(k)
                if item ~= nil then
                    slot:SetTile(ItemTile(item))
                end
            end
            self.backpack = overflow
        end

        -- 背景缩放与位置
        local scale_x = math.max(1.15, total_w / 520)
        local scale_y = do_integrated_backpack and 2.4 or 2.1
        if self.bg ~= nil then
            self.bg:SetScale(scale_x, scale_y, 1)
            self.bg:SetPosition(Vector3(0, do_integrated_backpack and -20 or -10, 0))
        end
        if self.bgcover ~= nil then
            self.bgcover:SetScale(scale_x, 1.2, 1)
            self.bgcover:SetPosition(Vector3(0, do_integrated_backpack and -130 or -90, 0))
        end

        -- 整体上移（船标避让）
        local base_y = UI_OFFSET_Y or 0
        if self.root ~= nil then
            local pos = self.root:GetPosition()
            if pos ~= nil then
                self.root:SetPosition(pos.x or 0, (pos.y or 0) + base_y * 0.01, pos.z or 0)
            end
            -- 更稳妥：用 out_pos / in_pos 若存在
            if self.out_pos ~= nil then
                self.out_pos = Vector3(self.out_pos.x, (self.out_pos.y or 0) + base_y, self.out_pos.z or 0)
            end
            if self.in_pos ~= nil then
                self.in_pos = Vector3(self.in_pos.x, (self.in_pos.y or 0) + base_y, self.in_pos.z or 0)
            end
            if not controller_attached and self.out_pos ~= nil then
                self.root:SetPosition(self.out_pos)
            end
        end

        -- 船 widget 额外偏移（若存在，兼容部分船 HUD）
        if self.boatwidget ~= nil and self.boatwidget.inst ~= nil and self.boatwidget.inst:IsValid() then
            local bp = self.boatwidget:GetPosition()
            if bp ~= nil then
                self.boatwidget:SetPosition(Vector3(bp.x, bp.y + base_y * 0.5, bp.z or 0))
            end
        end

        self:SelectSlot(self.inv[1])
        self.current_list = self.inv
        if self.UpdateCursor ~= nil then
            self:UpdateCursor()
        end
        if self.cursor then
            self.cursor:MoveToFront()
        end
        if self.actionstring then
            self.actionstring:MoveToFront()
        end

        self.rebuild_pending = false
    end
end)

-- 注：第一版以布局与扩容为主。若与其它装备栏/UI模组冲突，请关闭「内置简易额外装备栏」。
print(string.format("[TripleInv80] loaded size=%s hotkey_row=%s offset_y=%s simple_equip=%s",
    tostring(MAXITEMSLOTS), tostring(HOTKEY_ROW), tostring(UI_OFFSET_Y), tostring(ENABLE_SIMPLE_EQUIP)))
