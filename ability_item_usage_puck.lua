---------------------------------------------
-- Generated from Mirana Compiler version 1.6.2
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory().."/utility")
local ability_item_usage_generic = require(GetScriptDirectory().."/ability_item_usage_generic")
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
local npcBot = GetBot()
if npcBot:IsIllusion() then
    return
end
if npcBot:IsIllusion() then
    return
end
local AbilityNames, Abilities, Talents = fun1:InitAbility()
local AbilityToLevelUp = {
    AbilityNames[1],
    AbilityNames[3],
    AbilityNames[1],
    AbilityNames[2],
    AbilityNames[1],
    AbilityNames[5],
    AbilityNames[1],
    AbilityNames[3],
    AbilityNames[2],
    "talent",
    AbilityNames[2],
    AbilityNames[5],
    AbilityNames[2],
    AbilityNames[3],
    "talent",
    AbilityNames[3],
    "nil",
    AbilityNames[5],
    "nil",
    "talent",
    "nil",
    "nil",
    "nil",
    "nil",
    "talent",
}
local TalentTree = {
    function()
        return Talents[2]
    end,
    function()
        return Talents[3]
    end,
    function()
        return Talents[6]
    end,
    function()
        return Talents[8]
    end,
}
utility.CheckAbilityBuild(AbilityToLevelUp)
function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end
local cast = {}
cast.Desire = {}
cast.Target = {}
cast.Type = {}
local CanCast = {}
CanCast[1] = fun1.NormalCanCastFunction
CanCast[2] = fun1.NormalCanCastFunction
CanCast[3] = function(t)
    return not fun1:IsInvulnerable(t) or not fun1:ShouldNotBeAttacked(t)
end
CanCast[4] = function()
    return true
end
CanCast[5] = fun1.NormalCanCastFunction
local level
local attackRange
local health
local maxHealth
local healthPercent
local mana
local maxMana
local manaPercent
local netWorth
local allEnemies
local enemies
local enemyCount
local friends
local friendCount
local enemyCreeps
local friendCreeps
local neutralCreeps
local tower
local illusoryOrbCastLocation
local illusoryOrbMaxTravelDistance
local illusoryOrbRemainingTime
local isPhaseShifting
local Consider = {}
local function GetIllusoryOrb()
    return fun1:First(GetLinearProjectiles(), function(t)
        return t.ability and t.ability:GetName() == "puck_illusory_orb" and t.caster == npcBot
    end)
end
local illusoryOrb = GetIllusoryOrb()
Consider[1] = function()
    local ability = Abilities[1]
    if not ability:IsFullyCastable() then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange()
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local damage = ability:GetDamage()
    local forbiddenCreeps = fun1:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and (t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + fun1:AttackOnceDamage(npcBot, t) * (0.9 + #enemyCreeps * 0.1) or GetUnitToUnitDistance(tower, t) <= 700)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end
    if fun1:NotRetreating(npcBot) then
        do
            local target = fun1:GetTargetIfGood(npcBot)
            if target then
                coroutine.yield(BOT_ACTION_DESIRE_HIGH, target:GetLocation())
            end
        end
        do
            local target = fun1:GetTargetIfBad(npcBot)
            if target then
                if mana >= 650 then
                    coroutine.yield(BOT_ACTION_DESIRE_MODERATE, target:GetLocation())
                end
            end
        end
    end
    if fun1:IsFarmingOrPushing(npcBot) then
        if #enemyCreeps > 3 and #forbiddenCreeps == 0 and mana > 0.6 * maxMana + manaCost then
            coroutine.yield(BOT_ACTION_DESIRE_MODERATE, enemyCreeps[2]:GetLocation())
        end
    elseif fun1:IsRetreating(npcBot) then
        coroutine.yield(BOT_ACTION_DESIRE_HIGH, fun1:GetAncientLocation(npcBot))
    end
    return 0
end
local phaseShiftStartTime
local phaseShiftRemainingTime
local phaseShiftReasons = {}
Consider[3] = function()
    local ability = Abilities[3]
    if not ability:IsFullyCastable() then
        return 0
    end
    if fun1:HasSeverelyDisableProjectiles(npcBot) then
        table.insert(phaseShiftReasons, "projectiles")
        return BOT_ACTION_DESIRE_HIGH
    end
    return 0
end
fun1:AutoModifyConsiderFunction(npcBot, Consider, Abilities)
function AbilityUsageThink()
    isPhaseShifting = npcBot:HasModifier "modifier_puck_phase_shift"
    if phaseShiftRemainingTime then
        phaseShiftRemainingTime = phaseShiftRemainingTime - fun1:GetDeltaTime()
    end
    if npcBot:IsUsingAbility() or npcBot:IsSilenced() then
        return
    end
    if npcBot:IsChanneling() then
        if isPhaseShifting then
            local reason = phaseShiftReasons.reason
            if reason == "projectiles" then
                if #npcBot:GetIncomingTrackingProjectiles() == 0 then
                    npcBot:Action_ClearActions(false)
                    return
                end
            end
        else
            phaseShiftReasons = {}
        end
    end
    level = npcBot:GetLevel()
    attackRange = npcBot:GetAttackRange()
    health = npcBot:GetHealth()
    maxHealth = npcBot:GetMaxHealth()
    healthPercent = fun1:GetHealthPercent(npcBot)
    mana = npcBot:GetMana()
    maxMana = npcBot:GetMaxMana()
    manaPercent = fun1:GetManaPercent(npcBot)
    netWorth = npcBot:GetNetWorth()
    allEnemies = fun1:GetNearbyHeroes(npcBot, 1200)
    enemies = allEnemies:Filter(function(t)
        return fun1:MayNotBeIllusion(npcBot, t)
    end)
    enemyCount = fun1:GetEnemyHeroNumber(npcBot, enemies)
    friends = fun1:GetNearbyNonIllusionHeroes(npcBot, 1500, true)
    friendCount = fun1:GetEnemyHeroNumber(npcBot, friends)
    enemyCreeps = fun1:GetNearbyAttackableCreeps(npcBot, 900)
    friendCreeps = fun1:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange() + 150, false)
    neutralCreeps = npcBot:GetNearbyNeutralCreeps(900)
    tower = fun1:GetLaningTower(npcBot)
    cast = ability_item_usage_generic.ConsiderAbility(Abilities, Consider)
    local abilityIndex, target, castType = ability_item_usage_generic.UseAbility(Abilities, cast)
    if abilityIndex == 1 then
        illusoryOrbCastLocation = npcBot:GetLocation()
        illusoryOrbMaxTravelDistance = Abilities[1]:GetSpecialValueInt("max_distance") - 50
        illusoryOrbRemainingTime = illusoryOrbMaxTravelDistance / Abilities[1]:GetSpecialValueInt "orb_speed"
    elseif abilityIndex == 3 then
        phaseShiftStartTime = DotaTime()
        phaseShiftRemainingTime = Abilities[3]:GetSpecialValueFloat "duration" - 0.08
    end
end
function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
