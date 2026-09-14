name = "三栏超大物品栏 (约80格)"
description = [[三栏超大物品栏（目标约80格）
· 三排布局，格数可配置
· 快捷键可选作用在第1/2/3排（默认最底排，兼容官方最多15键）
· 可配置整体上移，减少挡住船标/船装备槽
· 兼容分离/融合背包
· 建议与 Mega Extra Slot 等额外装备栏模组一起使用（本模组默认不强制改装备栏）

基于45格整合版思路 + 单机超大物品栏三栏布局参考，面向DST与岛屿冒险环境。
]]
author = "Custom (based on community refs)"
version = "0.1.0"
forumthread = ""
api_version = 10
priority = 0

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
hamlet_compatible = false

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"utility", "qol", "inventory"}

local function Opt(desc, data, hover)
    local t = { description = desc, data = data }
    if hover then t.hover = hover end
    return t
end

configuration_options =
{
    {
        name = "INVENTORYSIZE",
        label = "物品栏格数",
        hover = "三排总格数。80为推荐默认；可按屏幕与装备栏情况调整。",
        options =
        {
            Opt("60", 60, "三排约20格"),
            Opt("75", 75, "三排约25格"),
            Opt("80", 80, "推荐"),
            Opt("85", 85, "接近单机超大栏"),
        },
        default = 80,
    },
    {
        name = "HOTKEY_ROW",
        label = "快捷键作用排",
        hover = "数字键1-0（及设置中最多15个）绑定到哪一排。默认最底排。",
        options =
        {
            Opt("第1排(最上)", 1),
            Opt("第2排(中间)", 2),
            Opt("第3排(最底)", 3, "默认，接近原版习惯"),
        },
        default = 3,
    },
    {
        name = "UI_OFFSET_Y",
        label = "物品栏整体上移",
        hover = "正值向上移，减轻挡住船标/船装备槽。可按分辨率与海难船微调。",
        options =
        {
            Opt("+0", 0),
            Opt("+20", 20),
            Opt("+40", 40),
            Opt("+60", 60),
            Opt("+80", 80),
            Opt("+100", 100),
            Opt("+120", 120),
        },
        default = 40,
    },
    {
        name = "ENABLE_SIMPLE_EQUIP",
        label = "内置简易额外装备栏",
        hover = "开启后增加背包栏+护符栏(共约5格装备)。若使用Mega Extra Slot等7格模组请关闭此项避免冲突。",
        options =
        {
            Opt("关闭(推荐配合Mega7)", false),
            Opt("开启(背包+护符)", true),
        },
        default = false,
    },
    {
        name = "ENABLE_BACKPACK_IN_INV",
        label = "允许背包放进物品栏",
        hover = "是否允许将背包作为普通物品放进物品栏格子。",
        options =
        {
            Opt("否", false),
            Opt("是", true),
        },
        default = false,
    },
    {
        name = "SLOT_GROUP_SEP",
        label = "格子分组间隔",
        hover = "开启后每5格一组间距略大；关闭则横向等距。",
        options =
        {
            Opt("分组(每5格)", true),
            Opt("等距", false),
        },
        default = true,
    },
}
