local L = locale ~= "zh" and locale ~= "zhr"

version = "2.0.3"

name = not L and "超级额外装备栏"
or "Mega Extra Slot"

author = "晴浅，小花朵"

description = not L and [[
󰀍将默认的 3 个装备栏扩展为最多 7 个：
- 手
- 头部（普通）
- 头部（启迪之冠）
- 身体（护甲）
- 身体（衣服）
- 身体（护符）
- 身体（背包）

󰀍局外设置页面需要勾选模组之后才能看到自定义按钮

󰀔支持玩家自定义添加喜欢的装备并设置装备的位置， 需要注意的是个别装备改变位置后会造成贴图消失。但功能不变。 
󰀩支持假人装备模组衣服，护符， 护甲，背包。 
󰀕部分模组物品不支持强行改变位置， 如果崩档，请取消相关设置。

模组开发主要用于适配模组【丰耘秘境】https://steamcommunity.com/sharedfiles/filedetails/?id=3609964985


模组版本：]]..version
or
[[Expand the default 3 equip slots up to 7:
- Hands
- Head
- Head (Enlightened Crown)
- Body (Armor)
- Body (Clothing)
- Body (Amulet)
- Body (Backpack)

Mod Version: ]]..version

api_version = 10
priority = -10000

all_clients_require_mod = true
client_only_mod = false

dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true

server_filter_tags = {
    "Extra Slot",
    "额外装备栏",
    "equipment",
}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

local INFO_STRINGS = {
    SLOT_SETTINGS = {
        CH = "额外槽位",
        EN = "Extra Slots",
    },
    ENABLE_HEAD2 = {
        LABEL = {
            CH = "启迪之冠槽",
            EN = "Crown Slot",
        },
        HOVER = {
            CH = "开启第二个头部装备栏，用于启迪之冠等特殊头部装备。",
            EN = "Enable the second head equip slot for Enlightened Crown style items.",
        },
        OPTIONS = {
            OFF = {
                CH = "关闭",
                EN = "Off",
            },
            ON = {
                CH = "开启",
                EN = "On",
            },
        },
    },
    ENABLE_BODY_ARMOR = {
        LABEL = {
            CH = "护甲槽",
            EN = "Armor Slot",
        },
        HOVER = {
            CH = "为护甲类身体装备保留原版身体槽。关闭后，护甲会回退到其他仍启用的身体槽；如果四个身体槽都关闭，则仍会使用原版身体槽兜底。",
            EN = "Reserve the vanilla body slot for armor items. When disabled, armor falls back to another enabled body slot. If all four body slot types are disabled, the vanilla body slot is still used as a failsafe.",
        },
        OPTIONS = {
            OFF = {
                CH = "关闭",
                EN = "Off",
            },
            ON = {
                CH = "开启",
                EN = "On",
            },
        },
    },
    ENABLE_BODY_CLOTHING = {
        LABEL = {
            CH = "衣服槽",
            EN = "Clothing Slot",
        },
        HOVER = {
            CH = "开启独立的身体衣服槽，衣服类装备会优先进入该槽位。",
            EN = "Enable an independent body clothing slot.",
        },
        OPTIONS = {
            OFF = {
                CH = "关闭",
                EN = "Off",
            },
            ON = {
                CH = "开启",
                EN = "On",
            },
        },
    },
    ENABLE_BODY_AMULET = {
        LABEL = {
            CH = "护符槽",
            EN = "Amulet Slot",
        },
        HOVER = {
            CH = "开启独立的身体护符槽，护符类装备会优先进入该槽位。",
            EN = "Enable an independent body amulet slot.",
        },
        OPTIONS = {
            OFF = {
                CH = "关闭",
                EN = "Off",
            },
            ON = {
                CH = "开启",
                EN = "On",
            },
        },
    },
    ENABLE_BODY_BACKPACK = {
        LABEL = {
            CH = "背包槽",
            EN = "Backpack Slot",
        },
        HOVER = {
            CH = "开启独立的身体背包槽，背包类装备会优先进入该槽位。",
            EN = "Enable an independent body backpack slot.",
        },
        OPTIONS = {
            OFF = {
                CH = "关闭",
                EN = "Off",
            },
            ON = {
                CH = "开启",
                EN = "On",
            },
        },
    },
    SLOT_OPTION = {
        AUTO = {
            CH = "自动判断",
            EN = "Auto",
        },
        HEAD = {
            CH = "帽子（普通）",
            EN = "Head",
        },
        HEAD2 = {
            CH = "帽子（启迪之冠）",
            EN = "Head (Crown)",
        },
        ARMOR = {
            CH = "护甲",
            EN = "Body (Armor)",
        },
        CLOTHING = {
            CH = "衣服",
            EN = "Body (Clothing)",
        },
        AMULET = {
            CH = "护符",
            EN = "Body (Amulet)",
        },
        BACKPACK = {
            CH = "背包",
            EN = "Body (Backpack)",
        },
    },
    COMPATIBILITY = {
        CH = "兼容设置",
        EN = "Compatibility",
    },
    SLOT_RULE_NOTE = {
        CH = "可选槽位会随已启用的槽位动态刷新。若某个身体槽被关闭，会回退到仍启用的身体槽；若四个身体槽都关闭，则自动回退到原版身体槽。",
        EN = "The slot list refreshes with the slot types that are currently enabled. Disabled body slots fall back to another enabled body slot, and if all four body slot types are off, the vanilla body slot is used automatically.",
    },
}

local function GetString(key1, key2, key3)
    if key1 == nil then
        return ""
    elseif key2 == nil then
        return INFO_STRINGS[key1][L and "EN" or "CH"]
    elseif key3 == nil then
        return INFO_STRINGS[key1][key2][L and "EN" or "CH"]
    else
        return INFO_STRINGS[key1][key2][key3][L and "EN" or "CH"]
    end
end

local function Lang(ch, en)
    return not L and ch or en
end

local function Title(key)
    return {
        name = "Title",
        label = GetString(key),
        options = {{description = "", data = ""}},
        default = "",
    }
end

local function OnOffOptions(key)
    return {
        { description = GetString(key, "OPTIONS", "OFF"), data = false },
        { description = GetString(key, "OPTIONS", "ON"), data = true },
    }
end

local SLOT_DEFAULTS = {
    ENABLE_HEAD2 = true,
    ENABLE_BODY_ARMOR = true,
    ENABLE_BODY_CLOTHING = true,
    ENABLE_BODY_AMULET = true,
    ENABLE_BODY_BACKPACK = true,
}

local ENABLE_SLOT_SETTINGS = {
    "ENABLE_HEAD2",
    "ENABLE_BODY_ARMOR",
    "ENABLE_BODY_CLOTHING",
    "ENABLE_BODY_AMULET",
    "ENABLE_BODY_BACKPACK",
}

local SLOT_CHOICES = {
    { name = "AUTO" },
    { name = "HEAD" },
    { name = "HEAD2", enable = "ENABLE_HEAD2" },
    { name = "ARMOR", enable = "ENABLE_BODY_ARMOR" },
    { name = "CLOTHING", enable = "ENABLE_BODY_CLOTHING" },
    { name = "AMULET", enable = "ENABLE_BODY_AMULET" },
    { name = "BACKPACK", enable = "ENABLE_BODY_BACKPACK" },
}

local BODY_SLOT_CONFIGS = {
    "ARMOR",
    "CLOTHING",
    "AMULET",
    "BACKPACK",
}

local EQUIPMENT_CONFIG_DEFAULTS = {
    siving_suit_gold = "ARMOR",
}

local LEGACY_EQUIPMENT_CONFIG_NAMES = {
    siving_suit_gold = "SIVING_SUIT_GOLD_SLOT",
	boltwingout = "BOLTWINGOUT",
    soraclothes = "SORACLOTHES_SLOT",
    mone_nightspace_cape = "MONE_NIGHTSPACE_CAPE_SLOT",
    myxl_dreambook = "MYXL_DREAMBOOK_SLOT",
    ccs_skirt1 = "CCS_SKIRT1_SLOT",
    yongbutuoxie = "YONGBUTUOXIE_SLOT",
    example = "EXAMPLE_SLOT",
}

local EQUIPMENT_CONFIGS = {}
local CUSTOM_COMPAT_DATA_OPTION = "ES_CUSTOM_COMPAT_DATA"

local function SlotOption(choice)
    return {
        description = GetString("SLOT_OPTION", choice.name),
        data = choice.name,
    }
end

local function has_any_enabled_body_slot(slot_settings)
    for i = 1, #BODY_SLOT_CONFIGS do
        local key = "ENABLE_BODY_" .. BODY_SLOT_CONFIGS[i]
        if slot_settings[key] ~= false then
            return true
        end
    end

    return false
end

local function build_allowed_slot_set(allowed_slots)
    if allowed_slots == nil then
        return nil
    end

    local result = {}
    local has_value = false
    for i = 1, #allowed_slots do
        local slot_name = allowed_slots[i]
        if slot_name ~= nil and slot_name ~= "" then
            result[slot_name] = true
            has_value = true
        end
    end

    return has_value and result or nil
end

local function is_slot_choice_enabled(choice, slot_settings)
    if choice.enable == nil or slot_settings[choice.enable] ~= false then
        return true
    end

    return choice.name == "ARMOR" and not has_any_enabled_body_slot(slot_settings)
end

local function BuildSlotOptions(include_disabled, slot_settings, allowed_slots)
    local options = {}
    slot_settings = slot_settings or SLOT_DEFAULTS
    local allowed_slot_set = build_allowed_slot_set(allowed_slots)

    for i = 1, #SLOT_CHOICES do
        local choice = SLOT_CHOICES[i]
        if (allowed_slot_set == nil or allowed_slot_set[choice.name])
            and (include_disabled or is_slot_choice_enabled(choice, slot_settings)) then
            options[#options + 1] = SlotOption(choice)
        end
    end

    return options
end

local function SlotOptions(allowed_slots)
    return BuildSlotOptions(false, SLOT_DEFAULTS, allowed_slots)
end

local function SlotHover(hover)
    return hover .. "\n\n" .. GetString("SLOT_RULE_NOTE")
end

local function SlotSetting(name, label, hover, default, allowed_slots)
    return {
        name = name,
        label = label,
        hover = SlotHover(hover),
        options = SlotOptions(allowed_slots),
        default = default or "AUTO",
    }
end

local function AddEquipmentConfig(code_name, label, hover, allowed_slots)
    EQUIPMENT_CONFIGS[#EQUIPMENT_CONFIGS + 1] = {
        code_name = code_name,
        name = code_name .. "_SLOT",
        label = label,
        hover = hover,
        default = EQUIPMENT_CONFIG_DEFAULTS[code_name] or "AUTO",
        legacy_name = LEGACY_EQUIPMENT_CONFIG_NAMES[code_name],
        allowed_slots = allowed_slots,
    }
end

local function AppendOption(options, value)
    options[#options + 1] = value
end

local function AppendEnableSettings(options)
    for i = 1, #ENABLE_SLOT_SETTINGS do
        local key = ENABLE_SLOT_SETTINGS[i]
        AppendOption(options, {
            name = key,
            label = GetString(key, "LABEL"),
            hover = GetString(key, "HOVER"),
            options = OnOffOptions(key),
            default = SLOT_DEFAULTS[key],
        })
    end
end

local function AppendEquipmentConfigs(options)
    for i = 1, #EQUIPMENT_CONFIGS do
        local def = EQUIPMENT_CONFIGS[i]
        AppendOption(options, SlotSetting(def.name, def.label, def.hover, def.default, def.allowed_slots))
    end
end

local function CustomCompatDataOption()
    return {
        name = CUSTOM_COMPAT_DATA_OPTION,
        label = "",
        hover = "",
        options = {{description = "", data = ""}},
        default = "",
    }
end

AddEquipmentConfig(
    "siving_suit_gold",
    Lang("【棱镜】子圭釜槽位 槽位", "siving_suit_gold slot"),
    Lang(
        "设置 【棱镜】子圭釜槽位 优先进入的装备槽位。AUTO 表示继续交给分类器自动判断。",
        "Choose which equip slot siving_suit_gold should prefer. AUTO keeps classifier-driven routing."
    ),
    { "AUTO", "ARMOR", "CLOTHING", "AMULET", "BACKPACK" }
)

AddEquipmentConfig(
    "boltwingout",
    Lang("【棱镜】金蟾脱壳 槽位", "boltwingout slot"),
    Lang(
        "设置金蟾脱壳优先进入的装备槽位。AUTO 表示继续交给分类器自动判断。",
        "Choose which equip slot boltwingout should prefer. AUTO keeps classifier-driven routing."
    ),
    { "AUTO", "ARMOR", "CLOTHING", "AMULET", "BACKPACK" }
)

AddEquipmentConfig(
    "soraclothes",
    Lang("【小穹】穹的护 槽位 槽位", "soraclothes slot"),
    Lang(
        "设置 【小穹】穹的护 槽位 优先进入的装备槽位。AUTO 表示继续交给分类器自动判断。",
        "Choose which equip slot soraclothes should prefer. AUTO keeps classifier-driven routing."
    ),
    { "AUTO", "ARMOR", "CLOTHING", "AMULET", "BACKPACK" }
)

AddEquipmentConfig(
    "mone_nightspace_cape",
    Lang("【更多物品】黑色披风 槽位", "mone_nightspace_cape slot"),
    Lang(
        "设置黑披风优先进入的装备槽位。AUTO 表示继续交给分类器自动判断。",
        "Choose which equip slot mone_nightspace_cape should prefer. AUTO keeps classifier-driven routing."
    ),
    { "AUTO", "ARMOR", "CLOTHING", "AMULET", "BACKPACK" }
)

AddEquipmentConfig(
    "myxl_dreambook",
    Lang("【璇儿】云篆天书 槽位", "myxl_dreambook slot"),
    Lang(
        "设置云篆天书优先进入的装备槽位。AUTO 表示继续交给分类器自动判断。",
        "Choose which equip slot myxl_dreambook should prefer. AUTO keeps classifier-driven routing."
    ),
    { "AUTO", "ARMOR", "CLOTHING", "AMULET", "BACKPACK" }
)

AddEquipmentConfig(
    "ccs_skirt1",
    Lang("【魔卡少女小樱】樱的衣服 槽位", "ccs_skirt1 slot"),
    Lang(
        "设置樱的衣服优先进入的装备槽位。AUTO 表示继续交给分类器自动判断。",
        "Choose which equip slot ccs_skirt1 should prefer. AUTO keeps classifier-driven routing."
    ),
    { "AUTO", "ARMOR", "CLOTHING", "AMULET", "BACKPACK" }
)



es_equipment_configs = EQUIPMENT_CONFIGS
es_slot_choices = SLOT_CHOICES
es_all_slot_options = BuildSlotOptions(true)

configuration_options = {}

AppendOption(configuration_options, Title("SLOT_SETTINGS"))
AppendEnableSettings(configuration_options)

AppendOption(configuration_options, Title())
AppendOption(configuration_options, Title("COMPATIBILITY"))
AppendEquipmentConfigs(configuration_options)
AppendOption(configuration_options, CustomCompatDataOption())
