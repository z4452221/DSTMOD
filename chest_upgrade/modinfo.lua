name = "Upgradeable Chest"
description = "We need more lumber!"
author = "CC"
version = "23.6"

local whatsnew = [[)
Fix some bugs
]]

api_version = 10

dst_compatible = true

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "upgradablechest.xml"
icon = "upgradablechest.tex"

server_filter_tags = {"upgradable chest"}

forumthread = ""

local lang = locale
if locale == "zht" or locale == "zhr" then
	lang = "zh"
elseif locale == "br" then
	lang = "pt"
end

local function AddOption(data, description, hover)
	return {description = description, data = data, hover = hover}
end
local BoolOptTrans = {
	["en"] = {
		AddOption(false, "no"),
		AddOption(true, "yes"),
	},
	["zh"] = {
		AddOption(false, "否"),
		AddOption(true, "是"),
	},
	["pt"] = {
		AddOption(false, "Não"),
		AddOption(true, "Sim"),
	},
}
local BoolOpt = BoolOptTrans[lang] or BoolOptTrans["en"]
local function AddHoverBoolOpt(hovertrue, hoverfalse)
	local optfalse = hoverfalse and AddOption(false, BoolOpt[1].description, hoverfalse) or BoolOpt[1]
	local opttrue = hovertrue and AddOption(true, BoolOpt[2].description, hovertrue) or BoolOpt[2]
	return {optfalse, opttrue}
end
local SecOpt = {AddOption(false, "")}
local function AddConfig(name, label, default, options, hover, client)
	return {name = name, label = label, hover = hover, options = options, default = default, client = client}
end

configuration_options = {
	AddConfig("MAX_LV", "Max upgrade", 9,
		{
			AddOption(3, "up to 3x3", "why do you use this mod"),
			AddOption(5, "up to 5x5", "able to upgrade 1 times"),
			AddOption(7, "up to 7x7", "able to upgrade 2 times"),
			AddOption(9, "up to 9x9", "able to upgrade 3 times"),
			AddOption(11, "up to 11x11", "able to upgrade 4 times"),
			AddOption(13, "up to 13x13", "able to upgrade 5 times"),
			AddOption(63, "infinite", "to test the limits and break through? challenge accepted!"),
		}
	),

	AddConfig("", "Advanced Options:", false, SecOpt),
	AddConfig("UPG_MODE", "Upgrade Mode", 1,
		{
			AddOption(1, "normal mode", "put upgrade items on the outermost slots"),
			AddOption(2, "expensive mode", "put upgrade items to the right or to the bottom for upgrade"),
			AddOption(3, "complex mode", "both of the modes"),
		}, "Change the upgrading mode"
	),
	AddConfig("PAGEABLE", "Pageable Upgrade", false,
		AddHoverBoolOpt("After the chest is in max level, put the upgrade items to all the slots in 1st page"),
		"Make the Chest Pageable"
	),
	AddConfig("CHANGESIZE", "Change Size", false, BoolOpt, "Change the chest size scale to its level"),

	AddConfig("", "Upgradeable Containers:", false, SecOpt),
	AddConfig("C_TREASURECHEST", "Chest", true,
		AddHoverBoolOpt("1 boards in each outermost slots")
	),
	AddConfig("C_ICEBOX", "Ice Box", true,
		AddHoverBoolOpt("1 gears in each top-most slots, 1 cut stone in each other outermost slots")
	),
	AddConfig("C_SALTBOX", "Salt Box", true,
		AddHoverBoolOpt("1 salt crystal in each outermost slots, and 1 blue gem in the center-most slot")
	),
	AddConfig("C_DRAGONFLYCHEST", "Dragonfly Chest", true,
		AddHoverBoolOpt("1 boards in each outermost slots")
	),
	AddConfig("C_FISH_BOX", "Fish Box", true,
		AddHoverBoolOpt("1 rope in each outermost slots")
	),
	AddConfig("C_BOOKSTATION", "Bookcase", false,
		AddHoverBoolOpt("1 living log in each outermost slots")
	),
	AddConfig("C_TACKLECONTAINER", "Tackle Box", false,
		AddHoverBoolOpt("1 cookie cutter shell in each outermost slots")
	),
	AddConfig("C_SUPERTACKLECONTAINER", "Super Tackle Box", true,
		AddHoverBoolOpt("1 cookie cutter shell in each outermost slots")
	),
	AddConfig("C_OCEAN_TRAWLER", "Ocean Trawler", false,
		AddHoverBoolOpt("1 malbatross feather in each slots")
	),
	AddConfig("C_SHADOW_CONTAINER", "Magician's Containers", true,
		AddHoverBoolOpt("1 shadow heart in each outermost slots"),
		"Magician's Hat, Magician's Box, Shadow Chester"
	),
	AddConfig("C_BEARGERFUR_SACK", "Polar Bearger Bin", false,
		AddHoverBoolOpt("1 thick fur in each left-most slots, 1 pure brilliance in other outermost slots")
	),
	AddConfig("C_BATTLESONG_CONTAINER", "Battle Call Canister", false,
		AddHoverBoolOpt("1 boards in each outermost slots")
	),
	AddConfig("C_CHESTER", "Chester", false,
		AddHoverBoolOpt(),
		"Chester: 1 Scale in each outermost slots\nHutch: 1 Shroom Skin in each outermost slots"
	),	
	AddConfig("C_BOAT_ANCIENT_CONTAINER", "Archaic Boat", true,
		AddHoverBoolOpt("1 boards in each outermost slots")		
	),
	AddConfig("C_RABBITKINGHORN_CONTAINER", "Burrowing Horn", true,
		AddHoverBoolOpt("1 Rabbit King Cudgel in each outermost slots")
	),
	AddConfig("C_SLINGSHOTAMMO_CONTAINER", "Ammo Pouch", false,
		AddHoverBoolOpt("1 Pig Skin in each outermost slots")
	),
	AddConfig("C_ELIXIR_CONTAINER", "Picnic Casket", false,
		AddHoverBoolOpt("1 Mourning Glories in each outermost slots")
	),

	AddConfig("", "Backpack Upgrade:", false, SecOpt),
	AddConfig("BACKPACK", "Backpack Upgrade-able", false,
		AddHoverBoolOpt("put items into every slots of the backpack")
	),
	AddConfig("BACKPACKMODE", "Backpack Upgrade Mode", 2,
		{
			AddOption(1, "Normal Only"),
			AddOption(2, "Page Only"),
			AddOption(3, "Both"),
		}
	),
	AddConfig("BACKPACKSIZE", "Backpack Max Size", 2,
		{
			AddOption(1, "Expand 1 Unit Size"),
			AddOption(2, "Expand 2 Unit Size"),
			AddOption(3, "Expand 3 Unit Size"),
			AddOption(4, "Expand 4 Unit Size"),
		}
	),
	AddConfig("EXPENSIVE_BACKPACK", "Expensive Backpack", false,
		AddHoverBoolOpt(
			"item to all slots for 1 page upgrade",
			"item to 1st page for 1 page upgrade"
		),
		"Change backpack upgrade requirement"
	),
	AddConfig("BACKPACKPAGE", "Backpack Max Page", 3,
		{
			AddOption(1, "1", "Why will you turn backpack upgrade on"),
			AddOption(2, "2"),
			AddOption(3, "3"),
			AddOption(4, "4"),
			AddOption(5, "5"),
			AddOption(6, "6"),
		}
	),
	-- AddConfig("KRAMPUS_ONLY", "Krampus Sack Only", false, BoolOpt,
	-- 	"*DISABLE* all other backpack' upgrade, except Krampus Sack\nwax paper to all slots in first page for upgrading Krampus Sack"
	-- ),

	AddConfig("", "Widget UI Settings:", false, SecOpt),
	AddConfig("SHOWGUIDE", "Shows Guide", 3,
		{
			AddOption(0, "never"),
			AddOption(1, "always"),
			AddOption(2, "when empty", "Show guide when the chest is empty"),
			AddOption(3, "auto", "Turn the guide off after you upgrade the chest once."),
		},
		"Show you the upgrade requirement\nWon't show for Column/Row Upgrade(expensive mode)", true
	),
	AddConfig("SEARCHBAR", "Search UI", true, BoolOpt,
		"double click the background to open/close the search UI", true
	),
	AddConfig("SHOWALLPAGE", "Show All Page", false, BoolOpt,
		"(testing)show all page when you open your container", true
	),
	AddConfig("UI_WIDGETPOS", "Widget Position", true,
		{
			AddOption(false, "top", "unchange, above the character"),
			AddOption(true, "left", "next to the character"),
		},
		nil, true
	),
	AddConfig("DRAGGABLE", "Partial Display", false,
		{
			AddOption(false, "disable(default)"),
			AddOption(3, "3x3", "show 3x3 slots"),
			AddOption(4, "4x4", "show 4x4 slots"),
			AddOption(5, "5x5(suggest)", "show 5x5 slots"),
			AddOption(6, "6x6", "show 6x6 slots"),
			AddOption(7, "7x7", "show 7x7 slots"),
		},
		nil, true
	),
	AddConfig("PACKSTYLE", "Backpack Layout", true, 
		{
			AddOption(false, "combine"),
			AddOption(true, "single"),
		},
		'"Integrated" backpack layout\nActivate only if "Backpack Upgrade-able" option on', true
	),
	AddConfig("OVERFLOW", "Backpack Page Fusion", true, BoolOpt,
		'"Integrated" backpack layout\nShow slots in same page until the inventory bar is full', true
	),
	AddConfig("UI_ICEBOX", "Ice Box Leftward", true, BoolOpt,
		"shift the ui of ice box leftward so that it won't block your cooker", true
	),
	AddConfig("DROPALL", '"Drop All" Button', false, BoolOpt,
		"a button allow you dropping the entire content to the ground", true
	),
	AddConfig("SORTITEM", '"Sort Item" Button', false, BoolOpt,
		"a button allow you sorting the content quickly\nMy sorting style. You may not like it.", true
	),
	AddConfig("CLOSEBTN", '"Close" Button', false, BoolOpt,
		"a button allow close the chest", true
	),
	AddConfig("FILLBTN", '"Auto Fill" Button', false, BoolOpt,
		"a button allow fill the item for upgrade.", true
	),
	AddConfig("UPGBTN", '"Upgrade" Button', false, BoolOpt,
		"a button allow upgrade without closing.", true
	),
	AddConfig("UI_BGIMAGE", "Hide Background Image", false, BoolOpt, nil, true),

	AddConfig("", "Other Functions:", false, SecOpt),
	AddConfig("SCALE_FACTOR", "Size Factor", 3,
		{
			AddOption(1, "2", "Size of 6x6 chest is 2 times to the 3x3"),
			AddOption(2, "1.5", "Size of 6x6 chest is 1.5 times to the 3x3"),
			AddOption(3, "1.33", "Size of 6x6 chest is 1.33 times to the 3x3"),
			AddOption(4, "1.25", "Size of 6x6 chest is 1.25 times to the 3x3"),
			AddOption(5, "1.2"),
			AddOption(6, "1.16"),
			AddOption(10, "1.1")
		},
		'The scale for upgraded chest(in radius)\nActivate only if "Change Size" option on.'
	),
	--[[
	AddConfig("ALLCANUPG", "(testing)All Upgrade-able", false,
		AddHoverBoolOpt("waxpaper to each outermost slots"),
		"Allow most of the modded containers upgradable"
	),
	]]
	AddConfig("DEGRADABLE", "Downgrade-able", true, BoolOpt,
		"Enable downgrading the chest\nPut a hammer in the empty container"
	),
	AddConfig("INSIGHT", "Insight", true, BoolOpt,
		"Mod: Insight will shows the detailed info for chest level"
	),
	AddConfig("UNCOM_MODE", "Uncompomising Mode", false, BoolOpt,
		"Adjust some setting when use with Mod: Uncompomising Mode\n*DISABLE* all other containers' upgrade, except Dragonfly Chest"
	),
	AddConfig("RETURNITEM", "Deconstruct Return Items", false, BoolOpt,
		"Return items when decontrution"
	),

	AddConfig("", "DEBUG:", false, SecOpt),
	AddConfig("DEBUG_MAXLV", "Max Level", false, BoolOpt,
		"Containers are in max lv once builded"
	),
	AddConfig("DEBUG_IIC", "Item in Container", false, BoolOpt,
		"Put upgrade material and hammer into container once builded"
	),

	AddConfig("", "SPECIAL:", false, SecOpt),
	AddConfig("COMPATIBLE_MODE", "Compatible Mode", false, BoolOpt,
		"Make this mod more compatible with other mods"
	),
}

if lang == "zh" then
	local whatsnew_cn = [[)
修复部分错误
]]

	local tips = [[
如果模组出现问题，可以禁用这个模组，并且回档到最近正常使用的时间点。
如果游戏本体的对应机制没改动，箱子会还原成原版箱子大小，并掉落溢出内容物。
如果对这个模组失去信心或者作者停止维护，可以放心禁用噢。（升级材料不会返还）

UI设置是客户端设置, 前往 主菜单->模组->服务器模组 更改
"显示升级需求"预设为"自动"，进行过一次升级后自动关闭。可按照上述方法修改为"一直"开启
双击背景显示/隐藏"搜索栏"
]]
	description = description.."\n\n更新了啥: (ver."..version..whatsnew_cn.."\n\n"..tips

	configuration_options = {
		AddConfig("MAX_LV", "等级上限", 9,
			{
				AddOption(3, "直到3x3", "为什么你用这个模组"),
				AddOption(5, "直到5x5", "可以升级 1 次"),
				AddOption(7, "直到7x7", "可以升级 2 次"),
				AddOption(9, "直到9x9", "可以升级 3 次"),
				AddOption(11, "直到11x11", "可以升级 4 次"),
				AddOption(13, "直到13x13", "可以升级 5 次"),
				AddOption(63, "无限", "想挑战上限？接受挑战"),
			}
		),

		AddConfig("", "进阶选项:", false, SecOpt),
		AddConfig("UPG_MODE", "升级模式", 1,
			{
				AddOption(1, "普通模式", "升级材料放最外圈储存格"),
				AddOption(2, "复杂模式", "升级材料放最右列 / 最下行储存格以进行横向 / 纵向升级"),
				AddOption(3, "混合模式", "我全都要"),
			}, "变更升级模式"
		),
		AddConfig("PAGEABLE", "翻页升级", false,
			AddHoverBoolOpt("满级以后，把升级材料放满第 1 页"),
			"让箱子可翻页的升级"
		),
		AddConfig("CHANGESIZE", "改变大小", false, BoolOpt, "根据箱子等级改变箱子大小"),
	
		AddConfig("", "可升级的容器:", false, SecOpt),
		AddConfig("C_TREASURECHEST", "箱子", true,
			AddHoverBoolOpt("1 木板到每一个最外层储存格")
		),
		AddConfig("C_ICEBOX", "冰箱", true,
			AddHoverBoolOpt("1 齿轮到每一个最上层储存格，1 石砖到其他最外层储存格")
		),
		AddConfig("C_SALTBOX", "盐盒", true,
			AddHoverBoolOpt("1 盐晶到每一个最外层储存格，1 蓝宝石到最中间储存格")
		),
		AddConfig("C_DRAGONFLYCHEST", "龙鳞宝箱", true,
			AddHoverBoolOpt("1 木板到每一个最外层储存格")
		),
		AddConfig("C_FISH_BOX", "锡鱼罐", true,
			AddHoverBoolOpt("1 绳子到每一个最外层储存格")
		),
		AddConfig("C_BOOKSTATION", "书架", false,
			AddHoverBoolOpt("1 活木到每一个最外层储存格")
		),
		AddConfig("C_TACKLECONTAINER", "钓具箱", false,
			AddHoverBoolOpt("1 饼干切割机壳到每一个最外层储存格"),
			"仅钓具箱"
		),
		AddConfig("C_SUPERTACKLECONTAINER", "超级钓具箱", true,
			AddHoverBoolOpt("1 饼干切割机壳到每一个最外层储存格"),
			"仅超级钓具箱"
		),
		AddConfig("C_OCEAN_TRAWLER", "拖网捕鱼器", false,
			AddHoverBoolOpt("1 邪天翁羽毛到每一个储存格")
		),
		AddConfig("C_SHADOW_CONTAINER", "魔术师的容器", true,
			AddHoverBoolOpt("1 暗影之心到每一个最外层储存格"),
			"魔术师的礼帽, 魔术师的盒子, 暗影切斯特"
		),
		AddConfig("C_BEARGERFUR_SACK", "极地熊獾桶", false,
			AddHoverBoolOpt("1 熊皮到每一个最左储存格，1 纯粹辉煌到每一个最外层储存格")
		),
		AddConfig("C_BATTLESONG_CONTAINER", "战斗号子罐", false,
			AddHoverBoolOpt("1 木板到每一个最外层储存格")
		),
		AddConfig("C_CHESTER", "切斯特", true,
			AddHoverBoolOpt(),
			"切斯特: 1 鳞片 到每一个最外层储存格\n哈奇: 1 蘑菇皮 到每一个最外层储存格"
		),
		AddConfig("C_BOAT_ANCIENT_CONTAINER", "古董船", true,
			AddHoverBoolOpt("1 木板到每一个最外层储存格")
		),
		AddConfig("C_RABBITKINGHORN_CONTAINER", "挖洞兔号角", true,
			AddHoverBoolOpt("1 兔王棍到每一个最外层储存格")
		),
		AddConfig("C_SLINGSHOTAMMO_CONTAINER", "弹药袋", false,
			AddHoverBoolOpt("1 猪皮到每一个最外层储存格")
		),
		AddConfig("C_ELIXIR_CONTAINER", "野餐盒", false,
			AddHoverBoolOpt("1 哀悼荣耀到每一个最外层储存格")
		),

		AddConfig("", "背包升级:", false, SecOpt),
		AddConfig("BACKPACK", "背包可升级", false,
			AddHoverBoolOpt("把升级材料放满第 1 页")
		),
		AddConfig("EXPENSIVE_BACKPACK", "昂贵的背包升级", false,
			AddHoverBoolOpt(
				"每一格各 1 个物品增加 1 页",
				"第一页各 1 个物品增加 1 页"
			),
			"调整背包升级需求"
		),
		AddConfig("BACKPACKMODE", "背包升级模式", 2,
			{
				AddOption(1, "仅普通升级"),
				AddOption(2, "仅翻页升级"),
				AddOption(3, "混合模式"),
			}
		),
		AddConfig("BACKPACKSIZE", "背包最大尺寸", 2,
			{
				AddOption(1, "扩大 1 圈"),
				AddOption(2, "扩大 2 圈"),
				AddOption(3, "扩大 3 圈"),
				AddOption(4, "扩大 4 圈"),
			}
		),
		AddConfig("BACKPACKPAGE", "背包最大页数", 3,
			{
				AddOption(1, "1"),
				AddOption(2, "2"),
				AddOption(3, "3"),
				AddOption(4, "4"),
				AddOption(5, "5"),
				AddOption(6, "6"),
			}
		),
		-- AddConfig("KRAMPUS_ONLY", "仅坎普斯背包", false, BoolOpt,
		-- 	"*禁止* 所有其他背包升级, 除了坎普斯背包\n坎普斯背包升级需求改为 蜡纸 到第 1 页每个格子"
		-- ),

		AddConfig("", "UI设置:", false, SecOpt),
		AddConfig("SHOWGUIDE", "显示升级需求", 3,
			{
				AddOption(0, "永不"),
				AddOption(1, "一直"),
				AddOption(2, "当空", "当箱子为空时显示"),
				AddOption(3, "自动", "当你进行一次升级后，永久关闭显示"),
			},
			"为你显示升级所需物品\n不会显示 行/列升级（混合模式） 的需求", true
		),
		AddConfig("SEARCHBAR", "搜索栏", true, BoolOpt,
			"双击背景显示/隐藏搜索栏", true
		),
		AddConfig("SHOWALLPAGE", "显示所有页数", false, BoolOpt,
			"(测试中)打开箱子时显示所有页数", true
		),
		AddConfig("UI_WIDGETPOS", "位置", true,
			{
				AddOption(false, "上面", "原版的位置, 人物上方"),
				AddOption(true, "左面", "在人物左边"),
			},
			nil, true
		),
		AddConfig("DRAGGABLE", "局部显示组件", false,
			{
				AddOption(false, "关闭"),
				AddOption(3, "3x3", "显示3x3的数量"),
				AddOption(4, "4x4", "显示4x4的数量"),
				AddOption(5, "5x5(建议)", "显示5x5的数量"),
				AddOption(6, "6x6", "显示6x6的数量"),
				AddOption(7, "7x7", "显示7x7的数量"),
			},
			nil, true
		),
		AddConfig("PACKSTYLE", "背包样式", true, 
			{
				AddOption(false, "合并"),
				AddOption(true, "整页"),
			},
			"\"融合\"背包样式\n只在\"背包可升级\"选项开启时有效", true
		),
		AddConfig("OVERFLOW", "智能分页", true, BoolOpt,
			'"融合" 背包样式\n把溢出的格子挪到下一页', true
		),
		AddConfig("UI_ICEBOX", "冰箱UI左移", true, BoolOpt,
			"UI左移使UI不会遮挡烹饪锅", true
		),
		AddConfig("DROPALL", '"清空"按钮', false, BoolOpt,
			"一个能把箱子里所有物品扔到地上的按钮", true
		),
		AddConfig("SORTITEM", '"整理"按钮', false, BoolOpt,
		"一个能帮你整理内容物的按钮\n按我的使用习惯做的，未必适合所有人", true
		),
		AddConfig("CLOSEBTN", '"关闭"按钮', false, BoolOpt,
			"一个能关闭箱子的按钮", true
		),
		AddConfig("FILLBTN", '"填充"按钮', false, BoolOpt,
			"一个自动填充升级材料的按钮", true
		),
		AddConfig("UPGBTN", '"升级"按钮', false, BoolOpt,
			"一个无需主动关闭箱子就能升级的按钮", true
		),
		AddConfig("UI_BGIMAGE", "隐藏UI背景", false, BoolOpt, nil, true),

		AddConfig("", "其他功能:", false, SecOpt),
		AddConfig("SCALE_FACTOR", "大小比例", 3,
			{
				AddOption(1, "2", "1:2, ie. 6x6箱子2倍大(半径)"),
				AddOption(2, "1.5", "1:1.5, ie. 6x6箱子1.5倍大(半径)"),
				AddOption(3, "1.33", "1:1.33, ie. 6x6箱子1.33倍大(半径)"),
				AddOption(4, "1.25", "1:1.25, ie. 6x6箱子1.25倍大(半径)"),
				AddOption(5, "1.2"),
				AddOption(6, "1.16"),
				AddOption(10, "1.1")
			},
			'改变箱子大小的比例\n只在"改变大小"选项开启时有效'
		),
		--[[
		AddConfig("ALLCANUPG", "(测试中)全容器升级", false,
			AddHoverBoolOpt("蜡纸到每一格最外圈储存格"),
			"让大部分模组容器也能升级\n不建议用经常玩的档进行测试"
		),
		]]
		AddConfig("DEGRADABLE", "可降级", true, BoolOpt,
		"箱子可降级\n放一个锤子进空箱子"
		),
		AddConfig("INSIGHT", "Insight资讯", true, BoolOpt,
			"模组: Insight 会为你显示更多资讯"
		),
		AddConfig("UNCOM_MODE", "永不妥协", false, BoolOpt,
			"调整与 模组: Uncompomising Mode(永不妥协) 同时使用时的设定\n*禁止* 所有其他容器升级, 除了龙鳞宝箱"
		),
		AddConfig("RETURNITEM", "拆除返还材料", false, BoolOpt,
			"拆除时返还升级材料"
		),

		AddConfig("", "除错模式:", false, SecOpt),
		AddConfig("DEBUG_MAXLV", "满级", false, BoolOpt,
			"容器在建造的时候就已经满级"
		),
		AddConfig("DEBUG_IIC", "自带升级材料", false, BoolOpt,
			"容器在建造时自带升级材料和锤子"
		),

		AddConfig("", "SPECIAL:", false, SecOpt),
		AddConfig("COMPATIBLE_MODE", "兼容模式", false, BoolOpt,
			"开启这个选项可以提升这个模组的兼容性"
		),
	}

elseif false then--lang == "pt" then	--seems to be google translate, keep it for reference
	local translatedby = "\nTranslated by: BM"
	local tips = [[
As configurações da interface do usuário são configurações do cliente, altere a configuração do\nmenu principal->Mod->Mods do servidor
"Mostrar guia" padrão para "auto". Desativado após atualizar um baú. Gire "sempre" como dito acima.
Clique duas vezes na imagem de fundo para mostrar/ocultar a "barra de pesquisa"
]]
	description = description..translatedby.."\n\nWhat is new: (ver."..version..whatsnew.."\n\n"..tips

	local pt_trans = {
		{"Atualização máxima", nil,
			"up to 3x3", "por que você usa esse mod",
			"up to 5x5", "capaz de atualizar 1 vezes",
			"up to 7x7", "capaz de atualizar 2 vezes",
			"up to 9x9", "capaz de atualizar 3 vezes",
			"up to 11x11", "capaz de atualizar 4 vezes",
			"up to 13x13", "capaz de atualizar 5 vezes",
			"infinite", "infinite",
		},

		{"Opções avançadas:"},
		{"Modo de atualização", "Alterar o modo de atualização",
			"modo normal", "coloque itens de atualização nos slots mais externos",
			"modo caro", "coloque itens de atualização à direita ou na parte inferior para atualização",
			"mod complexoe", "ambos os modos",
		},
		{"Atualização paginável",  "Torne o Baú Paginável", "Depois que o baú estiver no nível máximo, coloque os itens de atualização em todos os slots na 1ª página"},
		{"Mochila com capacidade de atualização", nil, "coloque itens em todos os slots da mochila"},
		{"Alterar tamanho", "Altere a escala do tamanho do peito para o seu nível"},

		{"Contêineres atualizáveis:"},
		{"Bau", nil, "1 placas em cada slot mais externo"},
		{"Caixa de gelo", nil, "1 engrenagem em cada slot mais alto, 1 pedra cortada em cada slot mais externo"},
		{"Caixa de sal", nil, "1 cristal de sal em cada slot mais externo e 1 gema azul no slot mais central"},
		{"Baú de Libélula", nil, "1 placas em cada slot mais externo"},
		{"Caixa de Peixe", nil, "1 corda em cada slot mais externo"},
		{"Estante", nil, "1 tronco vivo em cada slot mais externo"},
		{},
		{},
		{},

		{"UI:"},
		{"Guia de shows", "Mostrar o requisito de atualização\nNão será exibido para atualização de coluna/linha (modo caro)",
			"never",
			"always",
			"when empty", "Show guide when the chest is empty",
			"auto", "Desligue o guia depois de atualizar o baú uma vez.",
		},
		{"Barra de pesquisa", "clique duas vezes no plano de fundo para abrir/fechar a interface de pesquisa"},
		{"Mostrar todas as páginas", "(testando) mostrar toda a página quando você abre seu contêiner"},
		{"Posição do widget", nil,
			"parte de cima", "inalterado, acima do personagem",
			"lado esquerdo", "ao lado do personagem",
		},
		{},
		{"Layout da mochila", "Layout de mochila \"Integrado\"\nAtive somente se a opção \"Mochila atualizável\" estiver ativada",
			"combinar",
			"único",
		},
		{"Slot de estouro paginado", "Layout da mochila \"Integrated\"\nMova os \"slots transbordados\" para a próxima página"},
		{"Caixa de gelo para a esquerda", "mude a interface do usuário da caixa de gelo para a esquerda para que ela não bloqueie seu fogão"},
		{"Botão \"Soltar tudo\"", "um botão permite que você solte todo o conteúdo no chão"},
		{"Botão \"Classificar item\"", "um botão permite classificar o conteúdo rapidamente\nMeu estilo de classificação. Você pode não gostar."},
		{"Ocultar imagem de fundo"},

		{"Outras funções:"},
		{"Fator de tamanho", "A escala para baús atualizados (em raio)\nAtive somente se a opção \"Alterar tamanho\" estiver ativada.",
			"2", "O tamanho do peito 6x6 é 2 vezes o 3x3",
			"1.5", "O tamanho do peito 6x6 é 1.5 vezes o 3x3",
			"1.33", "O tamanho do peito 6x6 é 1.33 vezes o 3x3",
			"1.25", "O tamanho do peito 6x6 é 1.25 vezes o 3x3",
			"1.2",
			"1.16",
			"1.1",
		},
		{},
		{},
		{"Capacidade de downgrade", "Ativar o downgrade do baú\nColoque um martelo no recipiente vazio"},
		{"Insight", "Mod: Insight mostrará as informações detalhadas para o nível do peito"},
		{"Uncompomising Mode", "Ajuste algumas configurações ao usar com Mod: Uncompomising Mode"},
		{"Desconstruir itens de devolução", "Função de teste\nRetorna itens ao desconstruir"},

		{"DEPURAR:"},
		{"Nível máximo", "Os contêineres estão no máximo lv uma vez construídos"},
		{"Item no Contêiner", "Coloque o material de atualização e o martelo no contêiner uma vez construído"},
	}

else

	local tips = [[
You can disable this mod at any time, and rollback if bug occurs.
Chest will transform back to normal size, and drop items that is in excess.
Remind: Upgrade materials had consumed

The UI Settings are client configs, change setting from\nmain menu->Mod->Server Mods
"Show Guide" default to "auto". Disabled after you upgrade a chest. Turn "always" as said as above.
Double click the background image to show/hide "search bar"
]]
	description = description.."\n\nWhat is new: (ver."..version..whatsnew.."\n\n"..tips
end