GLOBAL.setfenv(1, GLOBAL)
local params = require("containers").params

local widget_treasurechest = params.treasurechest

local widget_octopuschest = {
    widget =
    {
        slotpos = {},
        animbank = "ui_thatchpack_1x4",
        animbuild = "ui_thatchpack_1x4",
        pos = Vector3(75,200,0),
        side_align_tip = 160,
    },
    type = "chest",
}
for y = 0, 3 do
    table.insert(widget_octopuschest.widget.slotpos, Vector3(-162 +(75/2), -y*75 + 114 ,0))
end

params["trawlnetdropped"] = widget_treasurechest
params["luggagechest"] = widget_treasurechest
params["waterchest"] = widget_treasurechest
params["krakenchest"] = widget_treasurechest
params["pandoraschest_tropical"] = widget_treasurechest
params["octopuschest"] = widget_octopuschest

params["livingjungletree_halloween"] = params.livingtree_halloween

params["packim"] = widget_treasurechest
params["fat_packim"] = params.shadowchester


local widget_thatchpack = {
    widget = {
        slotpos = {},
        animbank = "ui_thatchpack_1x4",
        animbuild = "ui_thatchpack_1x4",
        pos = Vector3(-5,-70,0),
    },
    issidewidget = true,
    type = "pack",
}

for y = 0, 3 do
    table.insert(widget_thatchpack.widget.slotpos, Vector3(-162 + (75 / 2), -75 * y + 114 ,0))
end

local widget_seasack = {
    widget = {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(-5, -70, 0),
    },
    issidewidget = true,
    type = "pack",
}

for y = 0, 3 do
    table.insert(widget_seasack.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(widget_seasack.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

local widget_piratepack = {
    widget = {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(-5,-70,0),
    },
    issidewidget = true,
    type = "pack",
}

for y = 0, 3 do
    table.insert(widget_piratepack.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(widget_piratepack.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

local widget_slingshot_obsidian = deepcopy(params.slingshot2)

widget_slingshot_obsidian.widget.animbank = "ui_slingshot_obsidian"
widget_slingshot_obsidian.widget.animbuild = "ui_slingshot_obsidian"
widget_slingshot_obsidian.widget.slotpos[2].y = 64 + 32 + 8 + 4 + 32
widget_slingshot_obsidian.widget.obsidian_tool = {
    red_threshold = TUNING.OBSIDIAN_TOOL_TRESHOLD.red,
    orange_threshold = TUNING.OBSIDIAN_TOOL_TRESHOLD.orange,
    yellow_threshold = TUNING.OBSIDIAN_TOOL_TRESHOLD.yellow,
}

params["thatchpack"] = widget_thatchpack
params["seasack"] = widget_seasack
params["piratepack"] = widget_piratepack
params["slingshot_obsidian"] = widget_slingshot_obsidian

local boat_raft = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_raft",
        animbuild = "boat_hud_raft",
        pos = Vector3(0, 0, 0),
        badgepos = Vector3(0, 40, 0),
        equipslotroot = Vector3(-80, 40, 0),
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_raft",
        animbuild = "boat_inspect_raft",
        pos = Vector3(200, 0, 0),
        badgepos = Vector3(0, 5, 0),
        equipslotroot = {},
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
}

local boat_lograft = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_raft",
        animbuild = "boat_hud_raft",
        pos = Vector3(0, 0, 0),
        badgepos = Vector3(0, 40, 0),
        equipslotroot = Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_raft",
        animbuild = "boat_inspect_raft",
        pos = Vector3(200, 0, 0),
        badgepos = Vector3(0, 5, 0),
        equipslotroot = {},
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
}

local boat_row = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_row",
        animbuild = "boat_hud_row",
        pos = Vector3(0, 0, 0),
        badgepos = Vector3(0, 40, 0),
        equipslotroot = Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_row",
        animbuild = "boat_inspect_row",
        pos = Vector3(200, 0, 0),
        badgepos = Vector3(0, 40, 0),
        equipslotroot = Vector3(40, -45, 0),
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = true,
}

local boat_armoured = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_row",
        animbuild = "boat_hud_row",
        pos = Vector3(0, 0, 0),
        badgepos = Vector3(0, 40, 0),
        equipslotroot = Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_row",
        animbuild = "boat_inspect_row",
        pos = Vector3(200, 0, 0),
        badgepos = Vector3(0, 40, 0),
        equipslotroot = Vector3(40, -45, 0),
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = true,
}

local boat_encrusted = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_encrusted",
        animbuild = "boat_hud_encrusted",
        pos = Vector3(0, 0, 0),
        badgepos = Vector3(0, 40, 0),
        equipslotroot = Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_encrusted",
        animbuild = "boat_inspect_encrusted",
        pos = Vector3(200, 0, 0),
        badgepos = Vector3(0, 155, 0),
        equipslotroot = Vector3(40, 70, 0),
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = true,
}

for i = 2, 1,-1 do
    table.insert(boat_encrusted.widget.slotpos, Vector3(-13-(80*(i+2)), 40 ,0))
end

for x = 0, 1 do
    table.insert(boat_encrusted.inspectwidget.slotpos, Vector3(-40 + (x*80), 70 + (1*-75),0))
end

local boat_cargo = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_cargo",
        animbuild = "boat_hud_cargo",
        pos = Vector3(0, 0, 0),
        badgepos = Vector3(0, 40, 0),
        equipslotroot = Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_cargo",
        animbuild = "boat_inspect_cargo",
        pos = Vector3(200, 0, 0),
        badgepos = Vector3(0, 155, 0),
        equipslotroot = Vector3(40, 70, 0),
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = true,
}

for i = 6, 1,-1 do
    table.insert(boat_cargo.widget.slotpos, Vector3(-13-(80*(i+2)), 40 ,0))
end

for y = 1, 3 do
    for x = 0, 1 do
        table.insert(boat_cargo.inspectwidget.slotpos, Vector3(-40 + (x*80), 70 + (y*-75),0))
    end
end

local boat_woodlegs = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_raft",
        animbuild = "boat_hud_raft",
        pos = Vector3(0, 0, 0),
        badgepos = Vector3(0, 40, 0),
        equipslotroot = Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_raft",
        animbuild = "boat_inspect_raft",
        pos = Vector3(200, 0, 0),
        badgepos = Vector3(0, 5, 0),
        equipslotroot = Vector3(40, -45, 0),
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = true,
    hideboatequipslots = true,
}

local boat_surfboard = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_raft",
        animbuild = "boat_hud_raft",
        pos = Vector3(0, 0, 0),
        badgepos = Vector3(0, 40, 0),
        equipslotroot = Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_raft",
        animbuild = "boat_inspect_raft",
        pos = Vector3(200, 0, 0),
        badgepos = Vector3(0, 5, 0),
        equipslotroot = {},
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
}

params["boat_raft"] = boat_raft
params["boat_lograft"] = boat_lograft
params["boat_row"] = boat_row
params["boat_armoured"] = boat_armoured
params["boat_encrusted"] = boat_encrusted
params["boat_cargo"] = boat_cargo
params["boat_woodlegs"] = boat_woodlegs
params["boat_surfboard"] = boat_surfboard
params["boat_godmode"] = boat_cargo

params["winter_palmtree"] = params.winter_tree
params["winter_jungletree"] = params.winter_tree

--Hamlet

local smelter =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 64 + 32 + 8 + 4, 0),
            Vector3(0, 32 + 4, 0),
            Vector3(0, -(32 + 4), 0),
            Vector3(0, -(64 + 32 + 8 + 4), 0),
        },
        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        pos = Vector3(200, 0, 0),
        side_align_tip = 100,
        buttoninfo =
        {
            text = STRINGS.ACTIONS.SMELT,
            position = Vector3(0, -165, 0),
        }
    },
    acceptsstacks = false,
    type = "cooker",
}

function smelter.itemtestfn(container, item, slot)
    return not container.inst:HasTag("burnt") and item:HasTag("smeltable")
end

function smelter.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.COOK):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.COOK.code, inst, ACTIONS.COOK.mod_name)
    end
end

function smelter.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and inst.replica.container:IsFull()
end

local plant_container = deepcopy(params.shadowchester)
plant_container.widget.animbank = "ui_chest_roottrunk_3x4"
plant_container.widget.animbuild = "ui_chest_roottrunk_3x4"
plant_container.widget.animbank_upgraded = "ui_chest_roottrunk_upgraded_3x4"
plant_container.widget.animbuild_upgraded = "ui_chest_roottrunk_upgraded_3x4"
function plant_container.itemtestfn(container, item, slot)
    return not item:HasTag("irreplaceable")
end

local widget_antchest = {
    widget = {
        slotpos = {Vector3(-1, 3, 0)},
        animbank = "ui_antchest_honeycomb",
        animbuild = "ui_antchest_honeycomb",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for corner = 0, 5 do --asgerrr: the odd scaling factors and offset were arrived at by trial and error trying to fit the ui as well as possible
    table.insert(widget_antchest.widget.slotpos, Vector3(math.cos(corner / 6 * TWOPI) * 0.94 * 80 - 1, math.sin(corner / 6 * TWOPI) * 1.07 * 80 + 3, 0))
end

function widget_antchest.itemtestfn(contanier, item, slot)
    return item.prefab == "honey" or item.prefab == "nectar_pod"
end

params["antchest"] = widget_antchest

local widget_corkchest = {
    widget = {
        slotpos = {
            Vector3(-162 + 75 / 2, -75 * 0 + 114, 0),
            Vector3(-162 + 75 / 2, -75 * 1 + 114, 0),
            Vector3(-162 + 75 / 2, -75 * 2 + 114, 0),
            Vector3(-162 + 75 / 2, -75 * 3 + 114, 0),
        },
        animbank = "ui_thatchpack_1x4",
        animbuild = "ui_thatchpack_1x4",
        animbank_upgraded = "ui_thatchpack_upgraded_1x4",
        animbuild_upgraded = "ui_thatchpack_upgraded_1x4",
        pos = Vector3(75, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

params["corkchest"] = widget_corkchest

local armorvortexcloak = {
    widget = {
		slotpos = {},
		animbank = "ui_krampusbag_2x5",
		animbuild = "ui_krampusbag_2x5",
		pos = Vector3(-5,-70,0),
	},
    issidewidget = true,
    type = "pack",
}

for y = 0, 4 do
    table.insert(armorvortexcloak.widget.slotpos, Vector3(-162, -y*75 + 114 ,0))
    table.insert(armorvortexcloak.widget.slotpos, Vector3(-162 +75, -y*75 + 114 ,0))
end

params["smelter"] = smelter
params["plant_container"] = plant_container
params["armorvortexcloak"] = armorvortexcloak
params["ro_bin"] = params.chester

local _offering_pot_itemtestfn = params.offering_pot.itemtestfn
params.offering_pot.itemtestfn = function(container, item, ...)
return (not container.inst:HasTag("burnt") and item.prefab == "seaweed") or _offering_pot_itemtestfn(container, item, ...) end

local _offering_pot_upgraded_itemtestfn = params.offering_pot_upgraded.itemtestfn
params.offering_pot_upgraded.itemtestfn = function(container, item, ...)
return (not container.inst:HasTag("burnt") and item.prefab == "seaweed") or _offering_pot_upgraded_itemtestfn(container, item, ...) end

local shelf1 =
{
    widget = {
        slotpos = { Vector3(0, 0, 0) }
    },
    acceptsstacks = false,
}


local shelf1x3 = {
    widget = {
        slotpos = {
            Vector3(-85 + 20, 0,   0),
            Vector3(-85 + 20, -80, 0),
            Vector3(-85 + 20, 80,  0)
        },
    },
    acceptsstacks = false,
}

local shelf2x3 =
{
    widget = {
        slotpos = {
            Vector3(-165, -80, 0),
            Vector3(-85,  -80, 0),
            Vector3(-165, 0,   0),
            Vector3(-85,  0,   0),
            Vector3(-165, 80,  0),
            Vector3(-85,  80,  0)
        },
    },
    acceptsstacks = false,
}

params["shelf_displaycase_wood"] = shelf1x3
params["shelf_displaycase_metal"] = shelf1x3

params["shelf_wood"] = shelf2x3
params["shelf_basic"] = shelf2x3
params["shelf_metal"] = shelf2x3
params["shelf_marble"] = shelf2x3
params["shelf_glass"] = shelf2x3
params["shelf_ladder"] = shelf2x3
params["shelf_hutch"] = shelf2x3
params["shelf_industrial"] = shelf2x3
params["shelf_adjustable"] = shelf2x3
params["shelf_fridge"] = shelf2x3
params["shelf_cinderblocks"] = shelf2x3
params["shelf_midcentury"] = shelf2x3
params["shelf_wallmount"] = shelf2x3
params["shelf_aframe"] = shelf2x3
params["shelf_crates"] = shelf2x3
params["shelf_hooks"] = shelf2x3
params["shelf_pipe"] = shelf2x3
params["shelf_hattree"] = shelf2x3
params["shelf_pallet"] = shelf2x3
params["shelf_floating"] = shelf2x3

params["shelf_ruins"] = shelf1
params["shelf_queen_display_1"] = shelf1
params["shelf_queen_display_2"] = shelf1
params["shelf_queen_display_3"] = shelf1
params["shelf_queen_display_4"] = shelf1

params["shop_buyer"] = shelf1

params.trusty_shooter =
{
    widget =
    {
        slotpos =
        {
            Vector3(0,   32 + 4,  0),
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0, 15, 0),
    },
    type = "hand_inv",
    excludefromcrafting = true,
}

function params.trusty_shooter.itemtestfn(container, item, slot)
    return container.inst:CanTakeAmmo(item) and not (item:HasTag("irreplaceable") or item:HasTag("_container"))
end

params.wheeler_tracker =
{
    widget =
    {
        slotpos =
        {
            Vector3(0,   32 + 4,  0),
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0, 15, 0),
    },
    type = "hand_inv",
    excludefromcrafting = true,
}

function params.wheeler_tracker.itemtestfn(container, item, slot)
    return not (item:HasTag("irreplaceable") or item:HasTag("_container"))
end