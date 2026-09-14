modimport("main/mods_change.lua")

ChestUpgradePreInit()

TUNING.CHESTUPGRADE = {	--add to tuning so that they can be easily tuned
	MAX_LV			= GetModConfigData("MAX_LV"),
	MAX_PAGE		= GetModConfigData("PAGEABLE") and 10 or 1,

	DEGRADE_RATIO	= .5,						--math.min(GetModConfigData("DEGRADE_RATIO"), 1)
	DEGRADE_USE		= 1,						--GetModConfigData("DEGRADE_USE")

	SCALE_FACTOR	= GetModConfigData("SCALE_FACTOR"),

	MAXPACKSIZE		= GetModConfigData("BACKPACK") and GetModConfigData("BACKPACKSIZE") or 0,
	MAXPACKPAGE 	= GetModConfigData("BACKPACK") and GetModConfigData("BACKPACKPAGE") or 1,
}

AddReplicableComponent("chestupgrade")

GLOBAL.ChestUpgrade = {}
GLOBAL.ChestUpgrade.AllUpgradeRecipes = {}

env.ChestUpgrade = GLOBAL.ChestUpgrade
env.AllUpgradeRecipes = ChestUpgrade.AllUpgradeRecipes

AllUpgradeRecipes.GetParams = function(allrecipes, prefab)
	local recipe = allrecipes[prefab]
	if recipe ~= nil and recipe.GetParams ~= nil then
		return recipe:GetParams()
	end
end

local containers = require("containers")

local chestmaxlv = (TUNING.CHESTUPGRADE.MAX_LV + 1) * (TUNING.CHESTUPGRADE.MAX_LV + 2) * TUNING.CHESTUPGRADE.MAX_PAGE
local packmaxlv = (TUNING.CHESTUPGRADE.MAXPACKSIZE * 2 + 3) * (TUNING.CHESTUPGRADE.MAXPACKSIZE * 2 + 8) * TUNING.CHESTUPGRADE.MAXPACKPAGE
containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, chestmaxlv, GetModConfigData("BACKPACK") and packmaxlv or 0)

modimport("main/strings.lua")
modimport("main/setup.lua")
modimport("main/recipes.lua")
modimport("main/container_upgrade.lua")
modimport("main/rpcs.lua")

if false then
	modimport("main/allupgable.lua")
end

modimport("main/widgets/container.lua")
modimport("main/widgets/inventorybar.lua")

--custom change
GLOBAL.ChestUpgrade.DISABLERS = {
	INV = false,				--widgets/inventorybar
	CONTAINER = true,			--components/container
	INVENTORY = true,			--prefabs/inventory_classifier
}

modimport("main/modules/inventorybar.lua")
modimport("main/modules/container.lua")
modimport("main/modules/inventory_classifier.lua")
--modimport("main/modules/container_classifier.lua")

ChestUpgradePostInit()