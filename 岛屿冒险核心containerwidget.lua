local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local BoatEquipSlot = require("widgets/boatequipslot")
local BoatBadge = require("widgets/boatbadge")
local ItemTile = require("widgets/itemtile")
local InvSlot = require("widgets/invslot")
local Widget = require("widgets/widget")
local Text = require("widgets/text")
local UIAnim = require("widgets/uianim")
local ImageButton = require("widgets/imagebutton")
local ContainerWidget = require("widgets/containerwidget")

local DOUBLECLICKTIME = .33
local HUD_ATLAS = "images/hud/ia_hud.xml"

local _Open = ContainerWidget.Open
function ContainerWidget:Open(container, doer, ...)
    local _GetWidget = container.replica.container.GetWidget
    container.replica.container.GetWidget = container.replica.container.GetOpenerWidget
    _Open(self, container, doer, ...)
    local widget = container.replica.container:GetWidget()
    local isinfinitestacksize = container.replica.container:IsInfiniteStackSize()
    container.replica.container.GetWidget = _GetWidget

    self.onitemboatequipfn = function(inst, data) self:OnItemBoatEquip(data.item, data.eslot) end
    self.inst:ListenForEvent("equip", self.onitemboatequipfn, container)

    self.onitemboatunequipfn = function(inst, data) self:OnItemBoatUnequip(data.item, data.eslot) end
    self.inst:ListenForEvent("unequip", self.onitemboatunequipfn, container)

    if container.replica.container.type == "boat" then
        self.boatbadge:SetPosition(widget.badgepos.x, widget.badgepos.y)
        self.boatbadge:Show()
        if container and container.replica.boathealth then
            self.inst:ListenForEvent("boathealthchange", function(boat, data) self:BoatDelta(boat, data) end, container)
            self.boatbadge:SetPercent(container.replica.boathealth:GetPercent(), container.replica.boathealth:GetMaxHealth())
        end

        if container.replica.container:HasBoatEquipSlots() then
            self:AddBoatEquipSlot(BOATEQUIPSLOTS.BOAT_SAIL, HUD_ATLAS, "equip_slot_boat_utility.tex")
            self:AddBoatEquipSlot(BOATEQUIPSLOTS.BOAT_LAMP, HUD_ATLAS, "equip_slot_boat_light.tex")
            local lastX = widget.equipslotroot.x
            local lastY = widget.equipslotroot.y
            local spacing = 80
            local eslot_order = {}
            for k, v in ipairs(self.boatEquipInfo) do
                local slot = BoatEquipSlot(v.slot, v.atlas, v.image, self.owner)
                self.boatEquip[v.slot] = self:AddChild(slot)
                slot:SetPosition(lastX, lastY, 0)
                lastX = lastX - spacing
                local obj = container.replica.container:GetBoatEquippedItem(v.slot)
                if obj then
                    local tile = ItemTile(obj)
                    slot:SetTile(tile)
                end
                if container.replica.container.hideboatequipslots then
                    slot:Hide()
                end
            end
        end
        self.boatbadge:MoveToFront()

        self:Refresh()
    end

    if widget.obsidian_tool ~= nil then
        local tresh = widget.obsidian_tool
        local animbuild = isinfinitestacksize and widget.animbuild_upgraded or widget.animbuild
        self.onchargechangefn = function(inst, data) self:OnObsidianChargeChanged(data and data.percent or nil, tresh, animbuild) end
        self.inst:ListenForEvent("obsidianchargechange", self.onchargechangefn, container)
        if container.replica.inventoryitem then
            self:OnObsidianChargeChanged(container.replica.inventoryitem:GetObsidianChargePercent(), tresh, animbuild)
        end
    end
end

function ContainerWidget:OnObsidianChargeChanged(percentage, tresh, build)
    if percentage == nil then return end
    local stage = percentage >= tresh.red_threshold and OBSIDIAN_TOOL_STAGE.red
        or percentage >= tresh.orange_threshold and OBSIDIAN_TOOL_STAGE.orange
        or percentage >= tresh.yellow_threshold and OBSIDIAN_TOOL_STAGE.yellow
    local stage = percentage >= tresh.red_threshold and OBSIDIAN_TOOL_STAGE.red
        or percentage >= tresh.orange_threshold and OBSIDIAN_TOOL_STAGE.orange
        or percentage >= tresh.yellow_threshold and OBSIDIAN_TOOL_STAGE.yellow
        or nil
    
    local suffix = stage ~= nil and ("_" .. INVERTED_OBSIDIAN_TOOL_STAGE[stage]) or ""
    self.bganim:GetAnimState():OverrideSymbol("art", build, "art" .. suffix)
    self.bganim:GetAnimState():OverrideSymbol("art", build, "art" .. suffix)
end

function ContainerWidget:AddBoatEquipSlot(slot, atlas, image, sortkey)
    sortkey = sortkey or #self.boatEquipInfo
    table.insert(self.boatEquipInfo, {slot = slot, atlas = atlas, image = image, sortkey = sortkey})
    table.sort(self.boatEquipInfo, function(a,b) return a.sortkey < b.sortkey end)
end

function ContainerWidget:BoatDelta(boat, data)
    if data.damage then
        self:Shake(0.25, 0.05, 5)
    end

    self.boatbadge:SetPercent(data.percent, data.maxhealth)

    if data.percent <= .25 then
        self.boatbadge:StartWarning()
    else
        self.boatbadge:StopWarning()
    end

    if self.prev_boat_pct and data.percent > self.prev_boat_pct then
        self.boatbadge:PulseGreen()
        --TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/health_up")
    elseif self.prev_boat_pct and data.damage and data.percent < self.prev_boat_pct then
        self.boatbadge:PulseRed()
        --TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/health_down")
    end
    self.prev_boat_pct = data.percent
end

function ContainerWidget:OnItemBoatEquip(item, slot)
    if slot ~= nil and self.boatEquip[slot] ~= nil then
        self.boatEquip[slot]:SetTile(ItemTile(item))
    end
end

function ContainerWidget:OnItemBoatUnequip(item, slot)
    if slot ~= nil and self.boatEquip[slot] ~= nil then
        self.boatEquip[slot]:SetTile(nil)
    end
end


local _Refresh = ContainerWidget.Refresh
function ContainerWidget:Refresh(...)
    _Refresh(self, ...)
    local boatequips = self.container.replica.container.GetBoatEquips and self.container.replica.container:GetBoatEquips() or {}
    for k, v in pairs(self.boatEquip) do
        local item = boatequips[k]
        if item == nil then
            if v.tile ~= nil then
                v:SetTile(nil)
            end
        elseif v.tile == nil or v.tile.item ~= item then
            v:SetTile(ItemTile(item))
        else
            v.tile:Refresh()
        end
    end
end

local _Close = ContainerWidget.Close
function ContainerWidget:Close(...)
    if self.isopen then
        if self.container ~= nil then
            if self.onitemboatequipfn ~= nil then
                self.inst:RemoveEventCallback("equip", self.onitemboatequipfn, self.container)
                self.onitemboatequipfn = nil
            end
            if self.onitemboatunequipfn ~= nil then
                self.inst:RemoveEventCallback("unequip", self.onitemboatunequipfn, self.container)
                self.onitemboatunequipfn = nil
            end
            if self.onchargechangefn ~= nil then
                self.inst:RemoveEventCallback("obsidianchargechange", self.onchargechangefn, self.container)
                self.onchargechangefn = nil
            end
        end
        _Close(self, ...)
        self.boatbadge:Hide()
        for i,v in pairs(self.boatEquip) do
            v:Kill()
        end
    else
        return _Close(self, ...)
    end
end

IAENV.AddClassPostConstruct("widgets/containerwidget", function(self)
    self.boatEquipInfo = {}
    self.boatEquip = {}

    self.boatbadge = self:AddChild(BoatBadge(self.owner, self))
    self.boatbadge:Hide()
end)