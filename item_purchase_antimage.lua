----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local p = {
    "item_tango",
    "item_tango",
    "item_flask",
    "item_wraith_band",
    "item_power_treads",
    "item_orb_of_corrosion",
    "item_diffusal_blade",
    "item_manta",
    "item_basher",
    "item_abyssal_blade",
    "item_black_king_bar",
    "item_butterfly",
    "item_ultimate_scepter_2",
    "item_moon_shard",
}
ItemPurchaseSystem:CreateItemInformationTable(GetBot(), p)

function ItemPurchaseThink()
    ItemPurchaseSystem:ItemPurchaseExtend()
end
