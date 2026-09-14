local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local Widget = require "widgets/widget"

local W = 68
local SEP = 12
local INTERSEP = 28

----------------------------------------------------------------------------------------
local InventoryBar = require("widgets/inventorybar")
local HudCompass_Wheeler = require("widgets/hudcompass_wheeler")

local _GetInventoryLists = InventoryBar.GetInventoryLists
function InventoryBar:GetInventoryLists(same_container_only, ...)
    same_container_only = false
    local lists = _GetInventoryLists(self, same_container_only, ...)
    if not same_container_only then
        local firstcontainer = self.owner.HUD:GetFirstOpenContainerWidget()
        if firstcontainer then
            if firstcontainer.boatEquip and not (firstcontainer.container and firstcontainer.container.replica.container and firstcontainer.container.replica.container.hideboatequipslots) then
                table.insert(lists, firstcontainer.boatEquip)
            end
        end
        local containers = self.owner.HUD:GetOpenContainerWidgets()
        if containers then
            for k,v in pairs(containers) do
                if v and v ~= firstcontainer then
                    table.insert(lists, v.inv)
                    if v.boatEquip and not (v.container and v.container.replica.container and v.container.replica.container.hideboatequipslots) then
                        table.insert(lists, v.boatEquip)
                    end
                end
            end
        end
    end
    return lists
end

local function RebuildBoatInvWidget(self, right)
    local target_pos = right and self.boat_inv_right_pos or self.boat_inv_left_pos
    if self.boat_inv_right ~= right and not self.rebuild_snapping then
        local cur_pos = self.boat_inv_right and self.boat_inv_right_pos or self.boat_inv_left_pos
        self.boat_inv:MoveTo(cur_pos, target_pos, .2)
    else
        self.boat_inv:CancelMoveTo()
        self.boat_inv:SetPosition(target_pos)
    end
    self.boat_inv_right = right
end

local function ShouldBoatInvBeOnLeft(self)
    for child in pairs(self.hand_inv:GetChildren()) do
        if child.isopen then
            return true
        end
    end

    if self.hudcompass ~= nil and self.hudcompass.isopen then
        return true
    end

    if self.hudcompass_wheeler ~= nil and self.hudcompass_wheeler.isopen then
        return true
    end

    return false
end

function InventoryBar:RebuildBoatInv()
    local right = not ShouldBoatInvBeOnLeft(self)

    RebuildBoatInvWidget(self, right)
    self.rebuild_boat_inv_pending = nil
end

local _RebuildLayout = IAUpvalueHacker.GetUpvalue(InventoryBar.Rebuild, "RebuildLayout")
local function RebuildLayout(self, inventory, overflow, do_integrated_backpack, do_self_inspect, ...)
    _RebuildLayout(self, inventory, overflow, do_integrated_backpack, do_self_inspect, ...)

    local num_slots = inventory:GetNumSlots()
    local num_equip = #self.equipslotinfo
    local num_buttons = do_self_inspect and 1 or 0
    local num_slotintersep = math.ceil(num_slots / 5)
    local num_equipintersep = num_buttons > 0 and 1 or 0
    local total_w = (num_slots + num_equip + num_buttons) * W + (num_slots + num_equip + num_buttons - num_slotintersep - num_equipintersep - 1) * SEP + (num_slotintersep + num_equipintersep) * INTERSEP
    local equipslot_x = (W - total_w) * .5 + num_slots * W + (num_slots - num_slotintersep) * SEP + num_slotintersep * INTERSEP

    local y = do_integrated_backpack and 115 or 75
    self.boat_inv_right_pos = Vector3((total_w - W) * .5 - 2, y, 0)
    self.boat_inv_left_pos = Vector3(equipslot_x - (W + SEP) * 2, y, 0)

    local x = equipslot_x
    for k, v in ipairs(self.equipslotinfo) do
        if v.slot == EQUIPSLOTS.HANDS and self.hudcompass_wheeler ~= nil then
            self.hudcompass_wheeler:SetBasePosition(x, do_integrated_backpack and 80 or 40, 0)
        end

        x = x + W + SEP
    end

    self:RebuildBoatInv()

    local bg_scale = (1.15 * total_w) / (1480) -- This is a bit ugly, the hardcoded 1480 is the standard width for a regular inventory total_w
    self.bg:SetScale(bg_scale, 1, 1)
    self.bgcover:SetScale(bg_scale, 1, 1)
end
IAUpvalueHacker.SetUpvalue(InventoryBar.Rebuild, RebuildLayout, "RebuildLayout")

local _OnUpdate = InventoryBar.OnUpdate
function InventoryBar:OnUpdate(...)
    local right = not ShouldBoatInvBeOnLeft(self)
    if (self.boat_inv_right ~= right or self.rebuild_boat_inv_pending) and not self.rebuild_pending then
        self:RebuildBoatInv()
    end
    return _OnUpdate(self, ...)
end

-- Boat_inv should not scale with the controller inventory
local function RefreshBoatInvScale(self)
    for child in pairs(self.boat_inv:GetChildren()) do
        child:CancelScaleTo()
        child:SetScale(self.base_scale, self.base_scale)
    end
end

local _OpenControllerInventory = InventoryBar.OpenControllerInventory
function InventoryBar:OpenControllerInventory(...)
    _OpenControllerInventory(self, ...)
    RefreshBoatInvScale(self)
end

-- NOTE (HALF): Still running this on boat_inv widgets for mods ig
local _OnNewContainerWidget = InventoryBar.OnNewContainerWidget
function InventoryBar:OnNewContainerWidget(...)
    _OnNewContainerWidget(self, ...)
	RefreshBoatInvScale(self)
end

local _CloseControllerInventory = InventoryBar.CloseControllerInventory
function InventoryBar:CloseControllerInventory(...)
    _CloseControllerInventory(self, ...)
	RefreshBoatInvScale(self)
end

IAENV.AddClassPostConstruct("widgets/inventorybar", function(self)
    self.boat_inv = self.root:AddChild(Widget("boat_inv"))
    self.boat_inv:SetScale(1/.6, 1/.6)
    self.boat_inv:MoveToBack()

    self.boat_inv_right = true
    self.boat_inv_right_pos = Vector3(0, 0, 0)
    self.boat_inv_left_pos = Vector3(0, 0, 0)

    self.hudcompass_wheeler = self.root:AddChild(HudCompass_Wheeler(self.owner, true))
    self.hudcompass_wheeler:SetScale(1.5, 1.5)
    self.hudcompass_wheeler:SetMaster()
    self.hudcompass_wheeler:MoveToBack()
end)