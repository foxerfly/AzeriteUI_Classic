local LibCast = CogWheel:Set("LibAura", -1)
if (not LibCast) then
	return
end

local LibMessage = CogWheel("LibMessage")
assert(LibMessage, "LibCast requires LibMessage to be loaded.")

local LibEvent = CogWheel("LibEvent")
assert(LibEvent, "LibCast requires LibEvent to be loaded.")

local LibFrame = CogWheel("LibFrame")
assert(LibFrame, "LibCast requires LibFrame to be loaded.")

LibMessage:Embed(LibCast)
LibEvent:Embed(LibCast)
LibFrame:Embed(LibCast)

-- Lua API
local _G = _G
local assert = assert
local date = date
local debugstack = debugstack
local error = error
local pairs = pairs
local select = select
local string_join = string.join
local string_match = string.match
local tonumber = tonumber
local type = type

-- WoW API
local GetSpellInfo = GetSpellInfo

-- Library registries
LibCast.embeds = LibCast.embeds or {}
LibCast.casts = LibCast.casts or {}
LibCast.castTimeDecrease = LibCast.castTimeDecrease or {}
LibCast.castTimeIncrease = LibCast.castTimeIncrease or {}
LibCast.channeled = LibCast.channeled or {}
LibCast.crowdControl = LibCast.crowdControl or {}

-- Quality of Life
local Casts = LibCast.casts
local CastDecrease = LibCast.castTimeDecrease
local CastIncrease = LibCast.castTimeIncrease
local Channeled = LibCast.channeled
local CrowdControl = LibCast.crowdControl

-- Utility Functions
--------------------------------------------------------------------------
-- Syntax check 
local check = function(value, num, ...)
	assert(type(num) == "number", ("Bad argument #%.0f to '%s': %s expected, got %s"):format(2, "Check", "number", type(num)))
	for i = 1,select("#", ...) do
		if type(value) == select(i, ...) then 
			return 
		end
	end
	local types = string_join(", ", ...)
	local name = string_match(debugstack(2, 2, 0), ": in function [`<](.-)['>]")
	error(("Bad argument #%.0f to '%s': %s expected, got %s"):format(num, name, types, type(value)), 3)
end

-- Retrieve localized spell name from spell ID 
-- and put it into a given database in the format
-- dataBase[spellName] = value 
local Set = function(dataBase, spellID, value)
	dataBase[(GetSpellInfo(spellID))] = value
end

local embedMethods = {
}

LibCast.Embed = function(self, target)
	for method in pairs(embedMethods) do
		target[method] = self[method]
	end
	self.embeds[target] = true
	return target
end

-- Upgrade existing embeds, if any
for target in pairs(LibCast.embeds) do
	LibCast:Embed(target)
end

-- Cast Databases
--------------------------------------------------------------------------
-- Spell casts. Storing spellID to retrieve spell icon later on. 
do 
	Set(Casts, 25262, 25262) -- Abomination Spit
	Set(Casts,  3979,  3979) -- Accurate Scope
	Set(Casts, 12280, 12280) -- Acid of Hakkar
	Set(Casts, 24334, 24334) -- Acid Spit
	Set(Casts,  6306,  6306) -- Acid Splash
	Set(Casts, 26419, 26419) -- Acid Spray
	Set(Casts,  4239,  4239) -- Activating Defenses
	Set(Casts,  8352,  8352) -- Adjust Attitude
	Set(Casts, 12081, 12081) -- Admiral's Hat
	Set(Casts,  3965,  3965) -- Advanced Target Dummy
	Set(Casts, 20904, 20904) -- Aimed Shot
	Set(Casts, 23096, 23096) -- Alarm-O-Bot
	Set(Casts, 17632, 17632) -- Alchemist's Stone
	Set(Casts, 12248, 12248) -- Amplify Damage
	Set(Casts,  9482,  9482) -- Amplify Flames
	Set(Casts, 20777, 20777) -- Ancestral Spirit
	Set(Casts, 24168, 24168) -- Animist's Caress
	Set(Casts, 16991, 16991) -- Annihilator
	Set(Casts, 19645, 19645) -- Anti-Magic Shield
	Set(Casts,  7934,  7934) -- Anti-Venom
	Set(Casts, 15627, 15627) -- Applying the Lure
	Set(Casts, 19512, 19512) -- Apply Salve
	Set(Casts, 15119, 15119) -- Apply Seduction Gland
	Set(Casts,  8089,  8089) -- Aquadynamic Fish Attractor
	Set(Casts,  8532,  8532) -- Aquadynamic Fish Lens
	Set(Casts, 21358, 21358) -- Aqual Quintessence - Dowse Molten Core Rune
	Set(Casts, 13901, 13901) -- Arcane Bolt
	Set(Casts, 19821, 19821) -- Arcane Bomb
	Set(Casts, 11461, 11461) -- Arcane Elixir
	Set(Casts, 11975, 11975) -- Arcane Explosion
	Set(Casts, 22598, 22598) -- Arcane Mantle of the Dawn
	Set(Casts,  1450,  1450) -- Arcane Spirit II
	Set(Casts,  1451,  1451) -- Arcane Spirit III
	Set(Casts,  1452,  1452) -- Arcane Spirit IV
	Set(Casts,  1453,  1453) -- Arcane Spirit V
	Set(Casts, 25181, 25181) -- Arcane Weakness
	Set(Casts, 16990, 16990) -- Arcanite Champion
	Set(Casts, 19830, 19830) -- Arcanite Dragonling
	Set(Casts, 16994, 16994) -- Arcanite Reaper
	Set(Casts, 20201, 20201) -- Arcanite Rod
	Set(Casts, 19669, 19669) -- Arcanite Skeleton Key
	Set(Casts, 22844, 22844) -- Arcanum of Focus
	Set(Casts, 22846, 22846) -- Arcanum of Protection
	Set(Casts, 22840, 22840) -- Arcanum of Rapidity
	Set(Casts,  7430,  7430) -- Arclight Spanner
	Set(Casts, 16081, 16081) -- Arctic Wolf
	Set(Casts,  8000,  8000) -- Area Burn
	Set(Casts, 23664, 23664) -- Argent Boots
	Set(Casts, 23665, 23665) -- Argent Shoulders
	Set(Casts,  2832,  2832) -- Armor +16
	Set(Casts,  2833,  2833) -- Armor +24
	Set(Casts, 10344, 10344) -- Armor +32
	Set(Casts, 19057, 19057) -- Armor +40
	Set(Casts,  2831,  2831) -- Armor +8
	Set(Casts,  7124,  7124) -- Arugal's Gift
	Set(Casts, 10418, 10418) -- Arugal spawn-in spell
	Set(Casts, 25149, 25149) -- Arygos's Vengeance
	Set(Casts,  6422,  6422) -- Ashcrombe's Teleport
	Set(Casts,  6421,  6421) -- Ashcrombe's Unlock
	Set(Casts, 21332, 21332) -- Aspect of Neptulon
	Set(Casts,   556,   556) -- Astral Recall
	Set(Casts,  9594,  9594) -- Attach Medallion to Shaft
	Set(Casts,  9595,  9595) -- Attach Shaft to Medallion
	Set(Casts, 10436, 10436) -- Attack
	Set(Casts,  8386,  8386) -- Attacking
	Set(Casts, 16629, 16629) -- Attuned Dampener
	Set(Casts, 17536, 17536) -- Awaken Kerlonian
	Set(Casts, 12346, 12346) -- Awaken the Soulflayer
	Set(Casts, 10258, 10258) -- Awaken Vault Warder
	Set(Casts, 18375, 18375) -- Aynasha's Arrow
	Set(Casts,  8795,  8795) -- Azure Shoulders
	Set(Casts,  8766,  8766) -- Azure Silk Belt
	Set(Casts,  8786,  8786) -- Azure Silk Cloak
	Set(Casts,  3854,  3854) -- Azure Silk Gloves
	Set(Casts,  8760,  8760) -- Azure Silk Hood
	Set(Casts,  8758,  8758) -- Azure Silk Pants
	Set(Casts,  3859,  3859) -- Azure Silk Vest
	Set(Casts,  6753,  6753) -- Backhand
	Set(Casts, 13982, 13982) -- Bael'Gar's Fiery Essence
	Set(Casts, 18247, 18247) -- Baked Salmon
	Set(Casts, 23151, 23151) -- Balance of Light and Shadow
	Set(Casts,  5414,  5414) -- Balance of Nature
	Set(Casts,  5412,  5412) -- Balance of Nature Failure
	Set(Casts, 28299, 28299) -- Ball Lightning
	Set(Casts, 18647, 18647) -- Banish
	Set(Casts,  4130,  4130) -- Banish Burning Exile
	Set(Casts,  4131,  4131) -- Banish Cresting Exile
	Set(Casts,  4132,  4132) -- Banish Thundering Exile
	Set(Casts,  5884,  5884) -- Banshee Curse
	Set(Casts, 16868, 16868) -- Banshee Wail
	Set(Casts,  3779,  3779) -- Barbaric Belt
	Set(Casts, 23399, 23399) -- Barbaric Bracers
	Set(Casts,  3771,  3771) -- Barbaric Gloves
	Set(Casts,  6661,  6661) -- Barbaric Harness
	Set(Casts,  9818,  9818) -- Barbaric Iron Boots
	Set(Casts,  9813,  9813) -- Barbaric Iron Breastplate
	Set(Casts,  9820,  9820) -- Barbaric Iron Gloves
	Set(Casts,  9814,  9814) -- Barbaric Iron Helm
	Set(Casts,  9811,  9811) -- Barbaric Iron Shoulders
	Set(Casts,  7149,  7149) -- Barbaric Leggings
	Set(Casts,  2395,  2395) -- Barbaric Linen Vest
	Set(Casts,  7151,  7151) -- Barbaric Shoulders
	Set(Casts,  4094,  4094) -- Barbecued Buzzard Wing
	Set(Casts, 16051, 16051) -- Barrier of Light
	Set(Casts,   818,   818) -- Basic Campfire
	Set(Casts, 11759, 11759) -- Basilisk Sample
	Set(Casts,  1179,  1179) -- Beast Claws
	Set(Casts,  1849,  1849) -- Beast Claws II
	Set(Casts,  3133,  3133) -- Beast Claws III
	Set(Casts, 23677, 23677) -- Beasts Deck
	Set(Casts,  2795,  2795) -- Beer Basted Boar Ribs
	Set(Casts, 22686, 22686) -- Bellowing Roar
	Set(Casts, 22866, 22866) -- Belt of the Archmage
	Set(Casts,  8856,  8856) -- Bending Shinbone
	Set(Casts, 27660, 27660) -- Big Bag of Enchantment
	Set(Casts,  3397,  3397) -- Big Bear Steak
	Set(Casts, 10001, 10001) -- Big Black Mace
	Set(Casts,  3950,  3950) -- Big Bronze Bomb
	Set(Casts,  3491,  3491) -- Big Bronze Knife
	Set(Casts,  3967,  3967) -- Big Iron Bomb
	Set(Casts, 10562, 10562) -- Big Voodoo Cloak
	Set(Casts, 10531, 10531) -- Big Voodoo Mask
	Set(Casts, 10560, 10560) -- Big Voodoo Pants
	Set(Casts, 10520, 10520) -- Big Voodoo Robe
	Set(Casts, 20529, 20529) -- Bind Chapter 1
	Set(Casts, 20530, 20530) -- Bind Chapter 2
	Set(Casts, 20531, 20531) -- Bind Chapter 3
	Set(Casts, 25719, 25719) -- Bind Draconic For Dummies
	Set(Casts, 23231, 23231) -- Binding Volume I
	Set(Casts, 23232, 23232) -- Binding Volume II
	Set(Casts, 23233, 23233) -- Binding Volume III
	Set(Casts,  7398,  7398) -- Birth
	Set(Casts, 22779, 22779) -- Biznicks 247x128 Accurascope
	Set(Casts, 23638, 23638) -- Black Amnesty
	Set(Casts, 20733, 20733) -- Black Arrow
	Set(Casts, 22719, 22719) -- Black Battlestrider
	Set(Casts, 20855, 20855) -- Black Dragonscale Boots
	Set(Casts, 19085, 19085) -- Black Dragonscale Breastplate
	Set(Casts, 19107, 19107) -- Black Dragonscale Leggings
	Set(Casts, 19094, 19094) -- Black Dragonscale Shoulders
	Set(Casts, 23639, 23639) -- Blackfury
	Set(Casts, 27589, 27589) -- Black Grasp of the Destroyer
	Set(Casts, 23652, 23652) -- Blackguard
	Set(Casts, 12073, 12073) -- Black Mageweave Boots
	Set(Casts, 12053, 12053) -- Black Mageweave Gloves
	Set(Casts, 12072, 12072) -- Black Mageweave Headband
	Set(Casts, 12049, 12049) -- Black Mageweave Leggings
	Set(Casts, 12050, 12050) -- Black Mageweave Robe
	Set(Casts, 12074, 12074) -- Black Mageweave Shoulders
	Set(Casts, 12048, 12048) -- Black Mageweave Vest
	Set(Casts,  7836,  7836) -- Blackmouth Oil
	Set(Casts, 17461, 17461) -- Black Ram
	Set(Casts,  6695,  6695) -- Black Silk Pack
	Set(Casts,  7279,  7279) -- Black Sludge
	Set(Casts,   470,   470) -- Black Stallion
	Set(Casts,  3873,  3873) -- Black Swashbuckler's Shirt
	Set(Casts, 22718, 22718) -- Black War Kodo
	Set(Casts, 22720, 22720) -- Black War Ram
	Set(Casts, 22721, 22721) -- Black War Raptor
	Set(Casts, 22717, 22717) -- Black War Steed
	Set(Casts, 22723, 22723) -- Black War Tiger
	Set(Casts, 22724, 22724) -- Black War Wolf
	Set(Casts,  9070,  9070) -- Black Whelp Cloak
	Set(Casts, 24940, 24940) -- Black Whelp Tunic
	Set(Casts,   578,   578) -- Black Wolf
	Set(Casts, 16978, 16978) -- Blazing Rapier
	Set(Casts, 16965, 16965) -- Bleakwood Hew
	Set(Casts, 28898, 28898) -- Blessed Wizard Oil
	Set(Casts, 16599, 16599) -- Blessing of Shahram
	Set(Casts, 10011, 10011) -- Blight
	Set(Casts,  6510,  6510) -- Blinding Powder
	Set(Casts, 15783, 15783) -- Blizzard
	Set(Casts,  3264,  3264) -- Blood Howl
	Set(Casts,  3371,  3371) -- Blood Sausage
	Set(Casts, 24136, 24136) -- Bloodsoul Breastplate
	Set(Casts, 24138, 24138) -- Bloodsoul Gauntlets
	Set(Casts, 24137, 24137) -- Bloodsoul Shoulders
	Set(Casts, 16986, 16986) -- Blood Talon
	Set(Casts, 24124, 24124) -- Blood Tiger Breastplate
	Set(Casts, 24125, 24125) -- Blood Tiger Shoulders
	Set(Casts, 24093, 24093) -- Bloodvine Boots
	Set(Casts, 24356, 24356) -- Bloodvine Goggles
	Set(Casts, 24092, 24092) -- Bloodvine Leggings
	Set(Casts, 24357, 24357) -- Bloodvine Lens
	Set(Casts, 24091, 24091) -- Bloodvine Vest
	Set(Casts, 19077, 19077) -- Blue Dragonscale Breastplate
	Set(Casts, 24654, 24654) -- Blue Dragonscale Leggings
	Set(Casts, 19089, 19089) -- Blue Dragonscale Shoulders
	Set(Casts, 23067, 23067) -- Blue Firework
	Set(Casts,  9995,  9995) -- Blue Glittering Axe
	Set(Casts,  7633,  7633) -- Blue Linen Robe
	Set(Casts,  2394,  2394) -- Blue Linen Shirt
	Set(Casts,  7630,  7630) -- Blue Linen Vest
	Set(Casts, 10969, 10969) -- Blue Mechanostrider
	Set(Casts,  7639,  7639) -- Blue Overalls
	Set(Casts,  6897,  6897) -- Blue Ram
	Set(Casts, 26423, 26423) -- Blue Rocket Cluster
	Set(Casts, 17463, 17463) -- Blue Skeletal Horse
	Set(Casts, 11365, 11365) -- Bly's Band's Escape
	Set(Casts,  6499,  6499) -- Boiled Clams
	Set(Casts,  2963,  2963) -- Bolt of Linen Cloth
	Set(Casts,  3865,  3865) -- Bolt of Mageweave
	Set(Casts, 18401, 18401) -- Bolt of Runecloth
	Set(Casts,  3839,  3839) -- Bolt of Silk Cloth
	Set(Casts,  2964,  2964) -- Bolt of Woolen Cloth
	Set(Casts,  9143,  9143) -- Bomb
	Set(Casts,  1980,  1980) -- Bombard
	Set(Casts,  3015,  3015) -- Bombard II
	Set(Casts, 28280, 28280) -- Bombard Slime
	Set(Casts, 17014, 17014) -- Bone Shards
	Set(Casts,  8778,  8778) -- Boots of Darkness
	Set(Casts,  3860,  3860) -- Boots of the Enchanter
	Set(Casts, 18455, 18455) -- Bottomless Bag
	Set(Casts, 23392, 23392) -- Boulder
	Set(Casts, 24006, 24006) -- Bounty of the Harvest
	Set(Casts, 28474, 28474) -- Bramblewood Belt
	Set(Casts, 28473, 28473) -- Bramblewood Boots
	Set(Casts, 28472, 28472) -- Bramblewood Helm
	Set(Casts,  7962,  7962) -- Break Big Stuff
	Set(Casts,  7437,  7437) -- Break Stuff
	Set(Casts,  4954,  4954) -- Break Tool
	Set(Casts, 18571, 18571) -- Breath
	Set(Casts, 28352, 28352) -- Breath of Sargeras
	Set(Casts,  8090,  8090) -- Bright Baubles
	Set(Casts,  7359,  7359) -- Bright Campfire
	Set(Casts, 18420, 18420) -- Brightcloth Cloak
	Set(Casts, 18415, 18415) -- Brightcloth Gloves
	Set(Casts, 18439, 18439) -- Brightcloth Pants
	Set(Casts, 18414, 18414) -- Brightcloth Robe
	Set(Casts, 12587, 12587) -- Bright-Eye Goggles
	Set(Casts,  3869,  3869) -- Bright Yellow Shirt
	Set(Casts, 25123, 25123) -- Brilliant Mana Oil
	Set(Casts,  7751,  7751) -- Brilliant Smallfish
	Set(Casts, 25122, 25122) -- Brilliant Wizard Oil
	Set(Casts,  7755,  7755) -- Bristle Whisker Catfish
	Set(Casts,  2741,  2741) -- Bronze Axe
	Set(Casts,  9987,  9987) -- Bronze Battle Axe
	Set(Casts,  3953,  3953) -- Bronze Framework
	Set(Casts,  9986,  9986) -- Bronze Greatsword
	Set(Casts,  2740,  2740) -- Bronze Mace
	Set(Casts,  2742,  2742) -- Bronze Shortsword
	Set(Casts,  3938,  3938) -- Bronze Tube
	Set(Casts,  9985,  9985) -- Bronze Warhammer
	Set(Casts, 25992, 25992) -- Brood of Nozdormu Factoin +1000
	Set(Casts,   458,   458) -- Brown Horse
	Set(Casts, 18990, 18990) -- Brown Kodo
	Set(Casts,  3914,  3914) -- Brown Linen Pants
	Set(Casts,  7623,  7623) -- Brown Linen Robe
	Set(Casts,  3915,  3915) -- Brown Linen Shirt
	Set(Casts,  2385,  2385) -- Brown Linen Vest
	Set(Casts,  6899,  6899) -- Brown Ram
	Set(Casts, 17464, 17464) -- Brown Skeletal Horse
	Set(Casts,  6654,  6654) -- Brown Wolf
	Set(Casts, 17293, 17293) -- Burning Winds
	Set(Casts, 26381, 26381) -- Burrow
	Set(Casts, 20364, 20364) -- Bury Samuel's Remains
	Set(Casts, 27720, 27720) -- Buttermilk Delight
	Set(Casts, 23123, 23123) -- Cairne's Hoofprint
	Set(Casts, 23041, 23041) -- Call Anathema
	Set(Casts, 25167, 25167) -- Call Ancients
	Set(Casts, 23042, 23042) -- Call Benediction
	Set(Casts,  7487,  7487) -- Call Bleak Worg
	Set(Casts, 25166, 25166) -- Call Glyphs of Warding
	Set(Casts,  7489,  7489) -- Call Lupine Horror
	Set(Casts, 11654, 11654) -- Call of Sul'thraze
	Set(Casts,  5137,  5137) -- Call of the Grave
	Set(Casts, 21249, 21249) -- Call of the Nether
	Set(Casts,   271,   271) -- Call of the Void
	Set(Casts, 11024, 11024) -- Call of Thund
	Set(Casts, 25159, 25159) -- Call Prismatic Barrier
	Set(Casts,  7488,  7488) -- Call Slavering Worg
	Set(Casts, 21648, 21648) -- Call to Ivus
	Set(Casts, 17501, 17501) -- Cannon Fire
	Set(Casts,  9095,  9095) -- Cantation of Manifestation
	Set(Casts, 14250, 14250) -- Capture Grark
	Set(Casts, 15998, 15998) -- Capture Worg Pup
	Set(Casts, 20274, 20274) -- Capturing Termites
	Set(Casts, 15863, 15863) -- Carrion Surprise
	Set(Casts, 27571, 27571) -- Cascade of Roses
	Set(Casts, 12609, 12609) -- Catseye Elixir
	Set(Casts, 12607, 12607) -- Catseye Ultra Goggles
	Set(Casts, 15120, 15120) -- Cenarion Beacon
	Set(Casts, 27724, 27724) -- Cenarion Herb Bag
	Set(Casts, 11085, 11085) -- Chain Bolt
	Set(Casts,  8211,  8211) -- Chain Burn
	Set(Casts, 15549, 15549) -- Chained Bolt
	Set(Casts, 10623, 10623) -- Chain Heal
	Set(Casts, 10605, 10605) -- Chain Lightning
	Set(Casts,   512,   512) -- Chains of Ice
	Set(Casts, 16570, 16570) -- Charged Arcane Bolt
	Set(Casts, 22434, 22434) -- Charged Scale of Onyxia
	Set(Casts, 11537, 11537) -- Charge Stave of Equinex
	Set(Casts,  1538,  1538) -- Charging
	Set(Casts,  2538,  2538) -- Charred Wolf Meat
	Set(Casts,  6648,  6648) -- Chestnut Mare
	Set(Casts,  3132,  3132) -- Chilling Breath
	Set(Casts, 19063, 19063) -- Chimeric Boots
	Set(Casts, 19053, 19053) -- Chimeric Gloves
	Set(Casts, 19073, 19073) -- Chimeric Leggings
	Set(Casts, 19081, 19081) -- Chimeric Vest
	Set(Casts, 22926, 22926) -- Chromatic Cloak
	Set(Casts, 23708, 23708) -- Chromatic Gauntlets
	Set(Casts, 22599, 22599) -- Chromatic Mantle of the Dawn
	Set(Casts, 24576, 24576) -- Chromatic Mount
	Set(Casts,  4506,  4506) -- CHU's QUEST SPELL
	Set(Casts, 12088, 12088) -- Cindercloth Boots
	Set(Casts, 18418, 18418) -- Cindercloth Cloak
	Set(Casts, 18412, 18412) -- Cindercloth Gloves
	Set(Casts, 18434, 18434) -- Cindercloth Pants
	Set(Casts, 12069, 12069) -- Cindercloth Robe
	Set(Casts, 18408, 18408) -- Cindercloth Vest
	Set(Casts,  6501,  6501) -- Clam Chowder
	Set(Casts,  4977,  4977) -- Cleanse Thunderhorn Well
	Set(Casts,  4978,  4978) -- Cleanse Wildmane Well
	Set(Casts,  4975,  4975) -- Cleanse Winterhoof Well
	Set(Casts, 24973, 24973) -- Clean Up Stink Bomb
	Set(Casts, 27794, 27794) -- Cleave
	Set(Casts, 18422, 18422) -- Cloak of Fire
	Set(Casts, 22870, 22870) -- Cloak of Warding
	Set(Casts, 27890, 27890) -- Clone
	Set(Casts, 21652, 21652) -- Closing
	Set(Casts,  3929,  3929) -- Coarse Blasting Powder
	Set(Casts,  9002,  9002) -- Coarse Dynamite
	Set(Casts,  3326,  3326) -- Coarse Grinding Stone
	Set(Casts,  2665,  2665) -- Coarse Sharpening Stone
	Set(Casts,  3116,  3116) -- Coarse Weightstone
	Set(Casts, 15491, 15491) -- Collect Blessed Water
	Set(Casts, 15649, 15649) -- Collect Corrupted Water
	Set(Casts, 20814, 20814) -- Collect Dire Water
	Set(Casts, 12709, 12709) -- Collecting Fallout
	Set(Casts, 21884, 21884) -- Collect Orange Crystal Liquid
	Set(Casts, 15958, 15958) -- Collect Rookery Egg
	Set(Casts, 12047, 12047) -- Colorful Kilt
	Set(Casts, 26167, 26167) -- Colossal Smash
	Set(Casts, 19720, 19720) -- Combine Pendants
	Set(Casts, 16781, 16781) -- Combining Charms
	Set(Casts, 10490, 10490) -- Comfortable Leather Hat
	Set(Casts,  3963,  3963) -- Compact Harvest Reaper Kit
	Set(Casts, 21267, 21267) -- Conjure Altar of Summoning
	Set(Casts, 21646, 21646) -- Conjure Circle of Calling
	Set(Casts, 25813, 25813) -- Conjure Dream Rift
	Set(Casts, 21100, 21100) -- Conjure Elegant Letter
	Set(Casts, 28612, 28612) -- Conjure Food
	Set(Casts, 18831, 18831) -- Conjure Lily Root
	Set(Casts,   759,   759) -- Conjure Mana Agate
	Set(Casts, 10053, 10053) -- Conjure Mana Citrine
	Set(Casts,  3552,  3552) -- Conjure Mana Jade
	Set(Casts, 10054, 10054) -- Conjure Mana Ruby
	Set(Casts, 19797, 19797) -- Conjure Torch of Retribution
	Set(Casts, 10140, 10140) -- Conjure Water
	Set(Casts, 28891, 28891) -- Consecrated Weapon
	Set(Casts,  2545,  2545) -- Cooked Crab Claw
	Set(Casts, 18239, 18239) -- Cooked Glossy Mightfish
	Set(Casts,  5174,  5174) -- Cookie's Cooking
	Set(Casts,  2738,  2738) -- Copper Axe
	Set(Casts,  3293,  3293) -- Copper Battle Axe
	Set(Casts,  2663,  2663) -- Copper Bracers
	Set(Casts,  2661,  2661) -- Copper Chain Belt
	Set(Casts,  3319,  3319) -- Copper Chain Boots
	Set(Casts,  2662,  2662) -- Copper Chain Pants
	Set(Casts,  3321,  3321) -- Copper Chain Vest
	Set(Casts,  9983,  9983) -- Copper Claymore
	Set(Casts,  8880,  8880) -- Copper Dagger
	Set(Casts,  2737,  2737) -- Copper Mace
	Set(Casts,  3926,  3926) -- Copper Modulator
	Set(Casts,  2739,  2739) -- Copper Shortsword
	Set(Casts,  3924,  3924) -- Copper Tube
	Set(Casts, 29331, 29331) -- Copy of Dark Desire
	Set(Casts, 30001, 30001) -- Copy of Fear
	Set(Casts, 29163, 29163) -- Copy of Frostbolt
	Set(Casts, 28305, 28305) -- Copy of Great Heal
	Set(Casts, 28304, 28304) -- Copy of Healing Wave
	Set(Casts, 27642, 27642) -- Copy of Increase Reputation
	Set(Casts, 25662, 25662) -- Copy of Nightfin Soup
	Set(Casts, 28146, 28146) -- Copy of Portal: Undercity
	Set(Casts, 14804, 14804) -- Copy of Release Rageclaw
	Set(Casts, 22727, 22727) -- Core Armor Kit
	Set(Casts, 26087, 26087) -- Core Felcloth Bag
	Set(Casts, 23709, 23709) -- Corehound Belt
	Set(Casts, 20853, 20853) -- Corehound Boots
	Set(Casts, 22795, 22795) -- Core Marksman Rifle
	Set(Casts, 23313, 23313) -- Corrosive Acid
	Set(Casts, 21047, 21047) -- Corrosive Acid Spit
	Set(Casts,  3396,  3396) -- Corrosive Poison
	Set(Casts, 20629, 20629) -- Corrosive Venom Spit
	Set(Casts, 25311, 25311) -- Corruption
	Set(Casts, 18666, 18666) -- Corrupt Redpath
	Set(Casts,  6619,  6619) -- Cowardly Flight Potion
	Set(Casts,  2541,  2541) -- Coyote Steak
	Set(Casts,  2544,  2544) -- Crab Cake
	Set(Casts,  3930,  3930) -- Crafted Heavy Shot
	Set(Casts,  3920,  3920) -- Crafted Light Shot
	Set(Casts,  3947,  3947) -- Crafted Solid Shot
	Set(Casts,  3966,  3966) -- Craftsman's Monocle
	Set(Casts,  5403,  5403) -- Crash of Waves
	Set(Casts, 21957, 21957) -- Create Amulet of Union
	Set(Casts,  4983,  4983) -- Create Cleansing Totem
	Set(Casts, 26299, 26299) -- Create Cluster Rocket Launcher
	Set(Casts, 19029, 19029) -- Create Coagulated Rot
	Set(Casts, 17777, 17777) -- Create Commission
	Set(Casts,  9082,  9082) -- Create Containment Coffer
	Set(Casts, 24885, 24885) -- Create Crest of Beckoning: Air
	Set(Casts, 24887, 24887) -- Create Crest of Beckoning: Earth
	Set(Casts, 24874, 24874) -- Create Crest of Beckoning: Fire
	Set(Casts, 24888, 24888) -- Create Crest of Beckoning: Water
	Set(Casts, 26265, 26265) -- Create Elune Stone
	Set(Casts,   898,   898) -- Create Fervor Potion
	Set(Casts,  4960,  4960) -- Create Fervor Potion (New)
	Set(Casts,  9010,  9010) -- Create Filled Containment Coffer
	Set(Casts, 17951, 17951) -- Create Firestone
	Set(Casts, 17952, 17952) -- Create Firestone (Greater)
	Set(Casts,  6366,  6366) -- Create Firestone (Lesser)
	Set(Casts, 17953, 17953) -- Create Firestone (Major)
	Set(Casts, 26298, 26298) -- Create Firework Rocket Launcher
	Set(Casts, 28023, 28023) -- Create Healthstone
	Set(Casts, 11729, 11729) -- Create Healthstone (Greater)
	Set(Casts,  6202,  6202) -- Create Healthstone (Lesser)
	Set(Casts, 11730, 11730) -- Create Healthstone (Major)
	Set(Casts,  6201,  6201) -- Create Healthstone (Minor)
	Set(Casts, 16195, 16195) -- Create Knucklebone Pouch
	Set(Casts,  9156,  9156) -- Create Mage's Orb
	Set(Casts,  9157,  9157) -- Create Mage's Robe
	Set(Casts, 11435, 11435) -- Create Mallet of Zul'Farrak
	Set(Casts, 18887, 18887) -- Create Nimboya's Laden Pike
	Set(Casts, 17133, 17133) -- Create Pamela's Doll
	Set(Casts, 15066, 15066) -- Create PX83-Enigmatron
	Set(Casts, 18987, 18987) -- Create Relic Bundle
	Set(Casts,  9079,  9079) -- Create Rift
	Set(Casts, 24201, 24201) -- Create Rune of the Dawn
	Set(Casts, 13714, 13714) -- Create Samophlange Manual
	Set(Casts,  9200,  9200) -- Create Sapta
	Set(Casts, 24896, 24896) -- Create Scepter of Beckoning: Air
	Set(Casts, 24897, 24897) -- Create Scepter of Beckoning: Earth
	Set(Casts, 24895, 24895) -- Create Scepter of Beckoning: Fire
	Set(Casts, 24898, 24898) -- Create Scepter of Beckoning: Water
	Set(Casts, 21939, 21939) -- Create Scepter of Celebras
	Set(Casts,  6671,  6671) -- Create Scroll
	Set(Casts,  9489,  9489) -- Create Scrying Bowl
	Set(Casts, 24179, 24179) -- Create Seal of the Dawn
	Set(Casts, 21544, 21544) -- Create Shredder
	Set(Casts, 24890, 24890) -- Create Signet of Beckoning: Air
	Set(Casts, 24891, 24891) -- Create Signet of Beckoning: Earth
	Set(Casts, 24889, 24889) -- Create Signet of Beckoning: Fire
	Set(Casts, 24892, 24892) -- Create Signet of Beckoning: Water
	Set(Casts, 20755, 20755) -- Create Soulstone
	Set(Casts, 20756, 20756) -- Create Soulstone (Greater)
	Set(Casts, 20752, 20752) -- Create Soulstone (Lesser)
	Set(Casts, 20757, 20757) -- Create Soulstone (Major)
	Set(Casts,   693,   693) -- Create Soulstone (Minor)
	Set(Casts,  2362,  2362) -- Create Spellstone
	Set(Casts, 17727, 17727) -- Create Spellstone (Greater)
	Set(Casts, 17728, 17728) -- Create Spellstone (Major)
	Set(Casts, 21979, 21979) -- Create The Pariah's Instructions
	Set(Casts,  5026,  5026) -- Create Water of the Seers
	Set(Casts,  9055,  9055) -- Create Witherbark Totem Bundle
	Set(Casts,  7155,  7155) -- CreatureSpecial
	Set(Casts, 14532, 14532) -- Creeper Venom
	Set(Casts,  2840,  2840) -- Creeping Anguish
	Set(Casts,  6278,  6278) -- Creeping Mold
	Set(Casts,  2838,  2838) -- Creeping Pain
	Set(Casts,  2841,  2841) -- Creeping Torment
	Set(Casts, 17496, 17496) -- Crest of Retribution
	Set(Casts,  8772,  8772) -- Crimson Silk Belt
	Set(Casts,  8789,  8789) -- Crimson Silk Cloak
	Set(Casts,  8804,  8804) -- Crimson Silk Gloves
	Set(Casts,  8799,  8799) -- Crimson Silk Pantaloons
	Set(Casts,  8802,  8802) -- Crimson Silk Robe
	Set(Casts,  8793,  8793) -- Crimson Silk Shoulders
	Set(Casts,  8791,  8791) -- Crimson Silk Vest
	Set(Casts, 11443, 11443) -- Cripple
	Set(Casts, 11202, 11202) -- Crippling Poison
	Set(Casts,  3421,  3421) -- Crippling Poison II
	Set(Casts, 15935, 15935) -- Crispy Bat Wing
	Set(Casts,  6418,  6418) -- Crispy Lizard Tail
	Set(Casts,  3373,  3373) -- Crocolisk Gumbo
	Set(Casts,  3370,  3370) -- Crocolisk Steak
	Set(Casts,  3974,  3974) -- Crude Scope
	Set(Casts, 16594, 16594) -- Crypt Scarabs
	Set(Casts,  5106,  5106) -- Crystal Flash
	Set(Casts,  3635,  3635) -- Crystal Gaze
	Set(Casts, 30021, 30021) -- Crystal Infused Bandage
	Set(Casts,  3636,  3636) -- Crystalline Slumber
	Set(Casts, 30047, 30047) -- Crystal Throat Lozenge
	Set(Casts, 13399, 13399) -- Cultivate Packet of Seeds
	Set(Casts, 27552, 27552) -- Cupid's Arrow
	Set(Casts,  3818,  3818) -- Cured Heavy Hide
	Set(Casts, 28133, 28133) -- Cure Disease
	Set(Casts,  3816,  3816) -- Cured Light Hide
	Set(Casts,  3817,  3817) -- Cured Medium Hide
	Set(Casts, 19047, 19047) -- Cured Rugged Hide
	Set(Casts, 10482, 10482) -- Cured Thick Hide
	Set(Casts,  3376,  3376) -- Curiously Tasty Omelet
	Set(Casts,  8282,  8282) -- Curse of Blood
	Set(Casts, 18502, 18502) -- Curse of Hakkar
	Set(Casts,  7098,  7098) -- Curse of Mending
	Set(Casts, 16597, 16597) -- Curse of Shahram
	Set(Casts, 13524, 13524) -- Curse of Stalvan
	Set(Casts, 18702, 18702) -- Curse of the Darkmaster
	Set(Casts, 13583, 13583) -- Curse of the Deadwood
	Set(Casts, 18159, 18159) -- Curse of the Fallen Magram
	Set(Casts, 16071, 16071) -- Curse of the Firebrand
	Set(Casts, 17738, 17738) -- Curse of the Plague Rat
	Set(Casts, 21048, 21048) -- Curse of the Tribes
	Set(Casts, 16247, 16247) -- Curse of Thorns
	Set(Casts,  3237,  3237) -- Curse of Thule
	Set(Casts, 17505, 17505) -- Curse of Timmy
	Set(Casts,  8552,  8552) -- Curse of Weakness
	Set(Casts,  5267,  5267) -- Dalaran Wizard Disguise
	Set(Casts,  7084,  7084) -- Damage Car
	Set(Casts, 27723, 27723) -- Dark Desire
	Set(Casts,  5514,  5514) -- Darken Vision
	Set(Casts, 19799, 19799) -- Dark Iron Bomb
	Set(Casts, 24399, 24399) -- Dark Iron Boots
	Set(Casts, 20874, 20874) -- Dark Iron Bracers
	Set(Casts, 20897, 20897) -- Dark Iron Destroyer
	Set(Casts,  5268,  5268) -- Dark Iron Dwarf Disguise
	Set(Casts, 23637, 23637) -- Dark Iron Gauntlets
	Set(Casts, 23636, 23636) -- Dark Iron Helm
	Set(Casts, 11802, 11802) -- Dark Iron Land Mine
	Set(Casts, 20876, 20876) -- Dark Iron Leggings
	Set(Casts, 15293, 15293) -- Dark Iron Mail
	Set(Casts, 15296, 15296) -- Dark Iron Plate
	Set(Casts, 15292, 15292) -- Dark Iron Pulverizer
	Set(Casts, 20890, 20890) -- Dark Iron Reaver
	Set(Casts, 19796, 19796) -- Dark Iron Rifle
	Set(Casts, 15295, 15295) -- Dark Iron Shoulders
	Set(Casts, 15294, 15294) -- Dark Iron Sunderer
	Set(Casts,  3766,  3766) -- Dark Leather Belt
	Set(Casts,  2167,  2167) -- Dark Leather Boots
	Set(Casts,  2168,  2168) -- Dark Leather Cloak
	Set(Casts,  3765,  3765) -- Dark Leather Gloves
	Set(Casts,  7135,  7135) -- Dark Leather Pants
	Set(Casts,  3769,  3769) -- Dark Leather Shoulders
	Set(Casts,  2169,  2169) -- Dark Leather Tunic
	Set(Casts, 16588, 16588) -- Dark Mending
	Set(Casts, 23765, 23765) -- Darkmoon Faire Fortune
	Set(Casts,  7106,  7106) -- Dark Restore
	Set(Casts, 24914, 24914) -- Darkrune Breastplate
	Set(Casts, 24912, 24912) -- Darkrune Gauntlets
	Set(Casts, 24913, 24913) -- Darkrune Helm
	Set(Casts,  3870,  3870) -- Dark Silk Shirt
	Set(Casts,  3335,  3335) -- Dark Sludge
	Set(Casts, 24139, 24139) -- Darksoul Breastplate
	Set(Casts, 24140, 24140) -- Darksoul Leggings
	Set(Casts, 24141, 24141) -- Darksoul Shoulders
	Set(Casts, 16987, 16987) -- Darkspear
	Set(Casts, 16587, 16587) -- Dark Whispers
	Set(Casts,  3146,  3146) -- Daunting Growl
	Set(Casts, 16660, 16660) -- Dawnbringer Shoulders
	Set(Casts, 16970, 16970) -- Dawn's Edge
	Set(Casts, 17045, 17045) -- Dawn's Gambit
	Set(Casts, 23705, 23705) -- Dawn Treaders
	Set(Casts, 10005, 10005) -- Dazzling Mithril Rapier
	Set(Casts,  3936,  3936) -- Deadly Blunderbuss
	Set(Casts,  3295,  3295) -- Deadly Bronze Poniard
	Set(Casts,  2835,  2835) -- Deadly Poison
	Set(Casts,  2837,  2837) -- Deadly Poison II
	Set(Casts, 11355, 11355) -- Deadly Poison III
	Set(Casts, 11356, 11356) -- Deadly Poison IV
	Set(Casts, 25347, 25347) -- Deadly Poison V
	Set(Casts, 12459, 12459) -- Deadly Scope
	Set(Casts,  7395,  7395) -- Deadmines Dynamite
	Set(Casts,  6894,  6894) -- Death Bed
	Set(Casts,  5395,  5395) -- Death Capsule
	Set(Casts, 17481, 17481) -- Deathcharger
	Set(Casts, 11433, 11433) -- Death & Decay
	Set(Casts, 24161, 24161) -- Death's Embrace
	Set(Casts, 15303, 15303) -- DEBUG Create Samophlange Manual
	Set(Casts,  7901,  7901) -- Decayed Agility
	Set(Casts, 13528, 13528) -- Decayed Strength
	Set(Casts, 12617, 12617) -- Deepdive Helmet
	Set(Casts, 12890, 12890) -- Deep Slumber
	Set(Casts, 22725, 22725) -- Defense +3
	Set(Casts,  5169,  5169) -- Defias Disguise
	Set(Casts, 22999, 22999) -- Defibrillate
	Set(Casts,  9743,  9743) -- Delete Me
	Set(Casts, 19815, 19815) -- Delicate Arcanite Converter
	Set(Casts, 16667, 16667) -- Demon Forged Breastplate
	Set(Casts, 18559, 18559) -- Demon Pick
	Set(Casts, 22372, 22372) -- Demon Portal
	Set(Casts, 25793, 25793) -- Demon Summoning Torch
	Set(Casts, 19788, 19788) -- Dense Blasting Powder
	Set(Casts, 23063, 23063) -- Dense Dynamite
	Set(Casts, 16639, 16639) -- Dense Grinding Stone
	Set(Casts, 16641, 16641) -- Dense Sharpening Stone
	Set(Casts, 16640, 16640) -- Dense Weightstone
	Set(Casts,  3964,  3964) -- Deprecated BKP "Impact" Shot
	Set(Casts,  3921,  3921) -- Deprecated Solid Shot
	Set(Casts, 24726, 24726) -- Deputize Agent of Nozdormu
	Set(Casts, 24377, 24377) -- Destroy Bijou
	Set(Casts, 19873, 19873) -- Destroy Egg
	Set(Casts, 19571, 19571) -- Destroy Ghost Magnet
	Set(Casts, 17015, 17015) -- Destroy Tent
	Set(Casts,  5140,  5140) -- Detonate
	Set(Casts,  9435,  9435) -- Detonation
	Set(Casts,  7955,  7955) -- Deviate Scale Belt
	Set(Casts,  7953,  7953) -- Deviate Scale Cloak
	Set(Casts,  7954,  7954) -- Deviate Scale Gloves
	Set(Casts, 19084, 19084) -- Devilsaur Gauntlets
	Set(Casts, 19097, 19097) -- Devilsaur Leggings
	Set(Casts, 11757, 11757) -- Digging for Cobalt
	Set(Casts,  6417,  6417) -- Dig Rat Stew
	Set(Casts,  6700,  6700) -- Dimensional Portal
	Set(Casts, 23486, 23486) -- Dimensional Ripper - Everlook
	Set(Casts, 13692, 13692) -- Dire Growl
	Set(Casts,  6653,  6653) -- Dire Wolf
	Set(Casts, 25659, 25659) -- Dirge's Kickin' Chimaerok Chops
	Set(Casts,  1842,  1842) -- Disarm Trap
	Set(Casts,  4508,  4508) -- Discolored Healing Potion
	Set(Casts,  3959,  3959) -- Discombobulator Ray
	Set(Casts, 27891, 27891) -- Disease Buffet
	Set(Casts, 11397, 11397) -- Diseased Shot
	Set(Casts,  6907,  6907) -- Diseased Slime
	Set(Casts, 17745, 17745) -- Diseased Spit
	Set(Casts, 13262, 13262) -- Disenchant
	Set(Casts,  2641,  2641) -- Dismiss Pet
	Set(Casts, 25808, 25808) -- Dispel
	Set(Casts, 21954, 21954) -- Dispel Poison
	Set(Casts, 16613, 16613) -- Displacing Temporal Rift
	Set(Casts,  5099,  5099) -- Disruption
	Set(Casts, 15746, 15746) -- Disturb Rookery Egg
	Set(Casts,  6310,  6310) -- Divining Scroll Spell
	Set(Casts,  5017,  5017) -- Divining Trance
	Set(Casts, 20604, 20604) -- Dominate Mind
	Set(Casts, 17405, 17405) -- Domination
	Set(Casts, 16053, 16053) -- Dominion of Soul
	Set(Casts,  3848,  3848) -- Double-stitched Woolen Shoulders
	Set(Casts,  6805,  6805) -- Dousing
	Set(Casts, 12253, 12253) -- Dowse Eternal Flame
	Set(Casts, 11758, 11758) -- Dowsing
	Set(Casts, 16007, 16007) -- Draco-Incarcinatrix 900
	Set(Casts, 15906, 15906) -- Dragonbreath Chili
	Set(Casts, 10650, 10650) -- Dragonscale Breastplate
	Set(Casts, 10619, 10619) -- Dragonscale Gauntlets
	Set(Casts, 24815, 24815) -- Draw Ancient Glyphs
	Set(Casts, 12304, 12304) -- Drawing Kit
	Set(Casts,  5219,  5219) -- Draw of Thistlenettle
	Set(Casts, 19564, 19564) -- Draw Water Sample
	Set(Casts, 15833, 15833) -- Dreamless Sleep Potion
	Set(Casts, 24703, 24703) -- Dreamscale Breastplate
	Set(Casts, 12092, 12092) -- Dreamweave Circlet
	Set(Casts, 12067, 12067) -- Dreamweave Gloves
	Set(Casts, 12070, 12070) -- Dreamweave Vest
	Set(Casts,  3368,  3368) -- Drink Minor Potion
	Set(Casts,  3359,  3359) -- Drink Potion
	Set(Casts, 11547, 11547) -- Drive Nimboya's Laden Pike
	Set(Casts,  8040,  8040) -- Druid's Slumber
	Set(Casts, 20436, 20436) -- Drunken Pit Crew
	Set(Casts,  2546,  2546) -- Dry Pork Ribs
	Set(Casts,  3361,  3361) -- Dummy NPC Summon
	Set(Casts, 21912, 21912) -- Dummy Nuke
	Set(Casts,  9206,  9206) -- Dusky Belt
	Set(Casts,  9207,  9207) -- Dusky Boots
	Set(Casts,  9201,  9201) -- Dusky Bracers
	Set(Casts,  9196,  9196) -- Dusky Leather Armor
	Set(Casts,  9195,  9195) -- Dusky Leather Leggings
	Set(Casts, 26072, 26072) -- Dust Cloud
	Set(Casts,  8800,  8800) -- Dynamite
	Set(Casts,   513,   513) -- Earth Elemental
	Set(Casts,  9147,  9147) -- Earthen Leather Shoulders
	Set(Casts,  8797,  8797) -- Earthen Silk Belt
	Set(Casts,  8764,  8764) -- Earthen Vest
	Set(Casts,  8376,  8376) -- Earthgrab Totem
	Set(Casts, 23650, 23650) -- Ebon Hand
	Set(Casts, 10013, 10013) -- Ebon Shiv
	Set(Casts, 21913, 21913) -- Edge of Winter
	Set(Casts, 21144, 21144) -- Egg Nog
	Set(Casts, 29335, 29335) -- Elderberry Pie
	Set(Casts, 11820, 11820) -- Electrified Net
	Set(Casts,   849,   849) -- Elemental Armor
	Set(Casts, 19773, 19773) -- Elemental Fire
	Set(Casts,   877,   877) -- Elemental Fury
	Set(Casts, 23679, 23679) -- Elementals Deck
	Set(Casts, 22757, 22757) -- Elemental Sharpening Stone
	Set(Casts, 11449, 11449) -- Elixir of Agility
	Set(Casts, 17557, 17557) -- Elixir of Brute Force
	Set(Casts,  3177,  3177) -- Elixir of Defense
	Set(Casts, 11477, 11477) -- Elixir of Demonslaying
	Set(Casts, 11478, 11478) -- Elixir of Detect Demon
	Set(Casts,  3453,  3453) -- Elixir of Detect Lesser Invisibility
	Set(Casts, 11460, 11460) -- Elixir of Detect Undead
	Set(Casts, 11468, 11468) -- Elixir of Dream Vision
	Set(Casts,  7845,  7845) -- Elixir of Firepower
	Set(Casts,  3450,  3450) -- Elixir of Fortitude
	Set(Casts, 21923, 21923) -- Elixir of Frost Power
	Set(Casts,  8240,  8240) -- Elixir of Giant Growth
	Set(Casts, 11472, 11472) -- Elixir of Giants
	Set(Casts, 11467, 11467) -- Elixir of Greater Agility
	Set(Casts, 11450, 11450) -- Elixir of Greater Defense
	Set(Casts, 26277, 26277) -- Elixir of Greater Firepower
	Set(Casts, 11465, 11465) -- Elixir of Greater Intellect
	Set(Casts, 22808, 22808) -- Elixir of Greater Water Breathing
	Set(Casts,  2333,  2333) -- Elixir of Lesser Agility
	Set(Casts,  2329,  2329) -- Elixir of Lion's Strength
	Set(Casts,  3230,  3230) -- Elixir of Minor Agility
	Set(Casts,  7183,  7183) -- Elixir of Minor Defense
	Set(Casts,  2334,  2334) -- Elixir of Minor Fortitude
	Set(Casts,  3188,  3188) -- Elixir of Ogre's Strength
	Set(Casts,  3174,  3174) -- Elixir of Poison Resistance
	Set(Casts, 11476, 11476) -- Elixir of Shadow Power
	Set(Casts, 17554, 17554) -- Elixir of Superior Defense
	Set(Casts, 17571, 17571) -- Elixir of the Mongoose
	Set(Casts, 17555, 17555) -- Elixir of the Sages
	Set(Casts,  2336,  2336) -- Elixir of Tongues
	Set(Casts,  7179,  7179) -- Elixir of Water Breathing
	Set(Casts, 11447, 11447) -- Elixir of Waterwalking
	Set(Casts,  3171,  3171) -- Elixir of Wisdom
	Set(Casts, 26636, 26636) -- Elune's Candle
	Set(Casts, 16533, 16533) -- Emberseer Start
	Set(Casts,  2161,  2161) -- Embossed Leather Boots
	Set(Casts,  2162,  2162) -- Embossed Leather Cloak
	Set(Casts,  3756,  3756) -- Embossed Leather Gloves
	Set(Casts,  3759,  3759) -- Embossed Leather Pants
	Set(Casts,  2160,  2160) -- Embossed Leather Vest
	Set(Casts,  8395,  8395) -- Emerald Raptor
	Set(Casts, 22647, 22647) -- Empower Pet
	Set(Casts, 16197, 16197) -- Empty Charm Pouch
	Set(Casts, 25853, 25853) -- Empty Festive Mug
	Set(Casts, 11513, 11513) -- Empty Phial
	Set(Casts,  7081,  7081) -- Encage
	Set(Casts,  4962,  4962) -- Encasing Webs
	Set(Casts, 16973, 16973) -- Enchanted Battlehammer
	Set(Casts, 20269, 20269) -- Enchanted Gaea Seed
	Set(Casts, 17181, 17181) -- Enchanted Leather
	Set(Casts, 27658, 27658) -- Enchanted Mageweave Pouch
	Set(Casts,  3443,  3443) -- Enchanted Quickness
	Set(Casts, 20513, 20513) -- Enchanted Resonite Crystal
	Set(Casts, 27659, 27659) -- Enchanted Runecloth Bag
	Set(Casts, 17180, 17180) -- Enchanted Thorium
	Set(Casts, 16745, 16745) -- Enchanted Thorium Breastplate
	Set(Casts, 16742, 16742) -- Enchanted Thorium Helm
	Set(Casts, 16744, 16744) -- Enchanted Thorium Leggings
	Set(Casts,  3857,  3857) -- Enchanter's Cowl
	Set(Casts,  6296,  6296) -- Enchant: Fiery Blaze
	Set(Casts, 16798, 16798) -- Enchanting Lullaby
	Set(Casts, 27287, 27287) -- Energy Siphon
	Set(Casts, 22661, 22661) -- Enervate
	Set(Casts, 11963, 11963) -- Enfeeble
	Set(Casts, 27860, 27860) -- Engulfing Shadows
	Set(Casts,  3112,  3112) -- Enhance Blunt Weapon
	Set(Casts,  3113,  3113) -- Enhance Blunt Weapon II
	Set(Casts,  3114,  3114) -- Enhance Blunt Weapon III
	Set(Casts,  9903,  9903) -- Enhance Blunt Weapon IV
	Set(Casts, 16622, 16622) -- Enhance Blunt Weapon V
	Set(Casts,  8365,  8365) -- Enlarge
	Set(Casts, 12655, 12655) -- Enlightenment
	Set(Casts, 11726, 11726) -- Enslave Demon
	Set(Casts,  9853,  9853) -- Entangling Roots
	Set(Casts,  6728,  6728) -- Enveloping Winds
	Set(Casts, 20589, 20589) -- Escape Artist
	Set(Casts, 24302, 24302) -- Eternium Fishing Line
	Set(Casts, 23442, 23442) -- Everlook Transporter
	Set(Casts,  3233,  3233) -- Evil Eye
	Set(Casts, 12458, 12458) -- Evil God Counterspell
	Set(Casts, 28354, 28354) -- Exorcise Atiesh
	Set(Casts, 23208, 23208) -- Exorcise Spirits
	Set(Casts,  7896,  7896) -- Exploding Shot
	Set(Casts, 12719, 12719) -- Explosive Arrow
	Set(Casts,  3955,  3955) -- Explosive Sheep
	Set(Casts,  6441,  6441) -- Explosive Shells
	Set(Casts, 15495, 15495) -- Explosive Shot
	Set(Casts, 24264, 24264) -- Extinguish
	Set(Casts, 26134, 26134) -- Eye Beam
	Set(Casts, 22909, 22909) -- Eye of Immol'thar
	Set(Casts,   126,   126) -- Eye of Kilrogg
	Set(Casts, 21160, 21160) -- Eye of Sulfuras
	Set(Casts,  6272,  6272) -- Eye of Yesmur (PT)
	Set(Casts,  1002,  1002) -- Eyes of the Beast
	Set(Casts, 23000, 23000) -- Ez-Thro Dynamite
	Set(Casts,  8339,  8339) -- EZ-Thro Dynamite
	Set(Casts, 23069, 23069) -- EZ-Thro Dynamite II
	Set(Casts,  6950,  6950) -- Faerie Fire
	Set(Casts,  8682,  8682) -- Fake Shot
	Set(Casts, 24162, 24162) -- Falcon's Call
	Set(Casts,  5262,  5262) -- Fanatic Blade
	Set(Casts,  6196,  6196) -- Far Sight
	Set(Casts,  6115,  6115) -- Far Sight (PT)
	Set(Casts,  6215,  6215) -- Fear
	Set(Casts,    16,    16) -- Fear (NYI)
	Set(Casts, 10647, 10647) -- Feathered Breastplate
	Set(Casts,   457,   457) -- Feeblemind
	Set(Casts,   509,   509) -- Feeblemind II
	Set(Casts,   855,   855) -- Feeblemind III
	Set(Casts, 26086, 26086) -- Felcloth Bag
	Set(Casts, 18437, 18437) -- Felcloth Boots
	Set(Casts, 22867, 22867) -- Felcloth Gloves
	Set(Casts, 18442, 18442) -- Felcloth Hood
	Set(Casts, 18419, 18419) -- Felcloth Pants
	Set(Casts, 18451, 18451) -- Felcloth Robe
	Set(Casts, 18453, 18453) -- Felcloth Shoulders
	Set(Casts, 12938, 12938) -- Fel Curse
	Set(Casts,  3488,  3488) -- Felstrom Resurrection
	Set(Casts,   555,   555) -- Feral Spirit
	Set(Casts,   968,   968) -- Feral Spirit II
	Set(Casts, 26403, 26403) -- Festive Red Dress
	Set(Casts, 26407, 26407) -- Festive Red Pant Suit
	Set(Casts,  8139,  8139) -- Fevered Fatigue
	Set(Casts,  8600,  8600) -- Fevered Plague
	Set(Casts, 22704, 22704) -- Field Repair Bot 74A
	Set(Casts,  6297,  6297) -- Fiery Blaze
	Set(Casts, 13900, 13900) -- Fiery Burst
	Set(Casts, 20872, 20872) -- Fiery Chain Girdle
	Set(Casts, 20873, 20873) -- Fiery Chain Shoulders
	Set(Casts, 16655, 16655) -- Fiery Plate Gauntlets
	Set(Casts, 18241, 18241) -- Filet of Redgill
	Set(Casts, 22562, 22562) -- Fill Amethyst Phial
	Set(Casts,  9052,  9052) -- Fill Deino's Flask
	Set(Casts,  6415,  6415) -- Fillet of Frenzy
	Set(Casts, 16073, 16073) -- Filling
	Set(Casts, 15699, 15699) -- Filling Empty Jar
	Set(Casts,  8919,  8919) -- Fill Jennea's Flask
	Set(Casts, 14929, 14929) -- Fill Nagmara's Vial
	Set(Casts,  5512,  5512) -- Fill Phial
	Set(Casts, 12735, 12735) -- Fill the Egg of Hakkar
	Set(Casts, 17474, 17474) -- Find Relic Fragment
	Set(Casts,  3763,  3763) -- Fine Leather Belt
	Set(Casts,  2158,  2158) -- Fine Leather Boots
	Set(Casts,  2159,  2159) -- Fine Leather Cloak
	Set(Casts,  2164,  2164) -- Fine Leather Gloves
	Set(Casts,  7133,  7133) -- Fine Leather Pants
	Set(Casts,  3761,  3761) -- Fine Leather Tunic
	Set(Casts, 10149, 10149) -- Fireball
	Set(Casts, 17203, 17203) -- Fireball Volley
	Set(Casts, 11763, 11763) -- Firebolt
	Set(Casts,   690,   690) -- Firebolt II
	Set(Casts,  1084,  1084) -- Firebolt III
	Set(Casts,  1096,  1096) -- Firebolt IV
	Set(Casts,  6250,  6250) -- Fire Cannon
	Set(Casts,   895,   895) -- Fire Elemental
	Set(Casts, 12594, 12594) -- Fire Goggles
	Set(Casts,  7837,  7837) -- Fire Oil
	Set(Casts,  7257,  7257) -- Fire Protection Potion
	Set(Casts,   134,   134) -- Fire Shield
	Set(Casts,   184,   184) -- Fire Shield II
	Set(Casts,  2601,  2601) -- Fire Shield III
	Set(Casts,  2602,  2602) -- Fire Shield IV
	Set(Casts, 13899, 13899) -- Fire Storm
	Set(Casts, 29332, 29332) -- Fire-toasted Bun
	Set(Casts, 25177, 25177) -- Fire Weakness
	Set(Casts, 25465, 25465) -- Firework
	Set(Casts, 26443, 26443) -- Firework Cluster Launcher
	Set(Casts, 26442, 26442) -- Firework Launcher
	Set(Casts,  7162,  7162) -- First Aid
	Set(Casts, 16601, 16601) -- Fist of Shahram
	Set(Casts, 23061, 23061) -- Fix Ritual Node
	Set(Casts,  7101,  7101) -- Flame Blast
	Set(Casts, 16396, 16396) -- Flame Breath
	Set(Casts, 16168, 16168) -- Flame Buffet
	Set(Casts,  6305,  6305) -- Flame Burst
	Set(Casts, 15575, 15575) -- Flame Cannon
	Set(Casts, 15743, 15743) -- Flamecrack
	Set(Casts,  3944,  3944) -- Flame Deflector
	Set(Casts,  3356,  3356) -- Flame Lash
	Set(Casts, 22593, 22593) -- Flame Mantle of the Dawn
	Set(Casts, 10854, 10854) -- Flames of Chaos
	Set(Casts, 12534, 12534) -- Flames of Retribution
	Set(Casts, 16596, 16596) -- Flames of Shahram
	Set(Casts,  6725,  6725) -- Flame Spike
	Set(Casts, 11021, 11021) -- Flamespit
	Set(Casts, 10733, 10733) -- Flame Spray
	Set(Casts, 10216, 10216) -- Flamestrike
	Set(Casts, 20849, 20849) -- Flarecore Gloves
	Set(Casts, 23667, 23667) -- Flarecore Leggings
	Set(Casts, 20848, 20848) -- Flarecore Mantle
	Set(Casts, 23666, 23666) -- Flarecore Robe
	Set(Casts, 22759, 22759) -- Flarecore Wraps
	Set(Casts,  8243,  8243) -- Flash Bomb
	Set(Casts, 27608, 27608) -- Flash Heal
	Set(Casts, 19943, 19943) -- Flash of Light
	Set(Casts, 17638, 17638) -- Flask of Chromatic Resistance
	Set(Casts, 17636, 17636) -- Flask of Distilled Wisdom
	Set(Casts, 17634, 17634) -- Flask of Petrification
	Set(Casts, 17637, 17637) -- Flask of Supreme Power
	Set(Casts, 17635, 17635) -- Flask of the Titans
	Set(Casts, 19833, 19833) -- Flawless Arcanite Rifle
	Set(Casts,  9092,  9092) -- Flesh Eating Worm
	Set(Casts,  9145,  9145) -- Fletcher's Gloves
	Set(Casts, 14292, 14292) -- Fling Torch
	Set(Casts, 17458, 17458) -- Fluorescent Green Mechanostrider
	Set(Casts,  3934,  3934) -- Flying Tiger Goggles
	Set(Casts,  3678,  3678) -- Focusing
	Set(Casts, 24189, 24189) -- Force Punch
	Set(Casts, 22797, 22797) -- Force Reactive Disk
	Set(Casts,  8912,  8912) -- Forge Verigan's Fist
	Set(Casts, 18711, 18711) -- Forging
	Set(Casts, 28697, 28697) -- Forgiveness
	Set(Casts,  8435,  8435) -- Forked Lightning
	Set(Casts,  3871,  3871) -- Formal White Shirt
	Set(Casts, 28324, 28324) -- Forming Frame of Atiesh
	Set(Casts, 23193, 23193) -- Forming Lok'delar
	Set(Casts, 23192, 23192) -- Forming Rhok'delar
	Set(Casts, 10849, 10849) -- Form of the Moonstalker (no invis)
	Set(Casts,  7054,  7054) -- Forsaken Skills
	Set(Casts, 29480, 29480) -- Fortitude of the Scourge
	Set(Casts,  6624,  6624) -- Free Action Potion
	Set(Casts, 18763, 18763) -- Freeze
	Set(Casts, 15748, 15748) -- Freeze Rookery Egg
	Set(Casts, 16028, 16028) -- Freeze Rookery Egg - Prototype
	Set(Casts, 11836, 11836) -- Freeze Solid
	Set(Casts, 19755, 19755) -- Frightalon
	Set(Casts, 10180, 10180) -- Frostbolt
	Set(Casts,  8398,  8398) -- Frostbolt Volley
	Set(Casts,  3131,  3131) -- Frost Breath
	Set(Casts, 23187, 23187) -- Frost Burn
	Set(Casts, 16992, 16992) -- Frostguard
	Set(Casts,  9198,  9198) -- Frost Leather Cloak
	Set(Casts,  6957,  6957) -- Frostmane Strength
	Set(Casts, 22594, 22594) -- Frost Mantle of the Dawn
	Set(Casts,  3595,  3595) -- Frost Oil
	Set(Casts,  7258,  7258) -- Frost Protection Potion
	Set(Casts, 17460, 17460) -- Frost Ram
	Set(Casts, 16056, 16056) -- Frostsaber
	Set(Casts, 19066, 19066) -- Frostsaber Boots
	Set(Casts, 19087, 19087) -- Frostsaber Gloves
	Set(Casts, 19074, 19074) -- Frostsaber Leggings
	Set(Casts, 19104, 19104) -- Frostsaber Tunic
	Set(Casts,  3497,  3497) -- Frost Tiger Blade
	Set(Casts, 25178, 25178) -- Frost Weakness
	Set(Casts, 18411, 18411) -- Frostweave Gloves
	Set(Casts, 18424, 18424) -- Frostweave Pants
	Set(Casts, 18404, 18404) -- Frostweave Robe
	Set(Casts, 18403, 18403) -- Frostweave Tunic
	Set(Casts, 23509, 23509) -- Frostwolf Howler
	Set(Casts, 25840, 25840) -- Full Heal
	Set(Casts,   474,   474) -- Fumble
	Set(Casts,   507,   507) -- Fumble II
	Set(Casts,   867,   867) -- Fumble III
	Set(Casts,  6405,  6405) -- Furbolg Form
	Set(Casts, 28210, 28210) -- Gaea's Embrace
	Set(Casts, 16997, 16997) -- Gargoyle Strike
	Set(Casts,  8901,  8901) -- Gas Bomb
	Set(Casts, 10630, 10630) -- Gauntlets of the Sea
	Set(Casts,  3325,  3325) -- Gemmed Copper Gauntlets
	Set(Casts, 19470, 19470) -- Gem of the Serpent
	Set(Casts,  3778,  3778) -- Gem-studded Leather Belt
	Set(Casts, 12802, 12802) -- Getting Tide Pool Sample #1
	Set(Casts, 12805, 12805) -- Getting Tide Pool Sample #2
	Set(Casts, 12806, 12806) -- Getting Tide Pool Sample #3
	Set(Casts, 12808, 12808) -- Getting Tide Pool Sample #4
	Set(Casts, 11473, 11473) -- Ghost Dye
	Set(Casts, 18410, 18410) -- Ghostweave Belt
	Set(Casts, 18413, 18413) -- Ghostweave Gloves
	Set(Casts, 18441, 18441) -- Ghostweave Pants
	Set(Casts, 18416, 18416) -- Ghostweave Vest
	Set(Casts,  2645,  2645) -- Ghost Wolf
	Set(Casts,  7213,  7213) -- Giant Clam Scorcho
	Set(Casts, 11466, 11466) -- Gift of Arthas
	Set(Casts,  6925,  6925) -- Gift of the Xavian
	Set(Casts, 21143, 21143) -- Gingerbread Cookie
	Set(Casts, 22921, 22921) -- Girdle of Insight
	Set(Casts, 23632, 23632) -- Girdle of the Dawn
	Set(Casts, 28208, 28208) -- Glacial Cloak
	Set(Casts, 28205, 28205) -- Glacial Gloves
	Set(Casts,  3143,  3143) -- Glacial Roar
	Set(Casts, 28207, 28207) -- Glacial Vest
	Set(Casts, 28209, 28209) -- Glacial Wrists
	Set(Casts, 26105, 26105) -- Glare
	Set(Casts, 15972, 15972) -- Glinting Steel Dagger
	Set(Casts,  3852,  3852) -- Gloves of Meditation
	Set(Casts, 18454, 18454) -- Gloves of Spell Mastery
	Set(Casts, 23633, 23633) -- Gloves of the Dawn
	Set(Casts, 21943, 21943) -- Gloves of the Greatfather
	Set(Casts,  6974,  6974) -- Gnome Camera Connection
	Set(Casts, 12906, 12906) -- Gnomish Battle Chicken
	Set(Casts,  3971,  3971) -- Gnomish Cloaking Device
	Set(Casts, 12759, 12759) -- Gnomish Death Ray
	Set(Casts, 12897, 12897) -- Gnomish Goggles
	Set(Casts, 12904, 12904) -- Gnomish Ham Radio
	Set(Casts, 12903, 12903) -- Gnomish Harm Prevention Belt
	Set(Casts, 12907, 12907) -- Gnomish Mind Control Cap
	Set(Casts, 12902, 12902) -- Gnomish Net-o-Matic Projector
	Set(Casts, 12905, 12905) -- Gnomish Rocket Boots
	Set(Casts, 12899, 12899) -- Gnomish Shrink Ray
	Set(Casts, 23453, 23453) -- Gnomish Transporter
	Set(Casts,  9269,  9269) -- Gnomish Universal Remote
	Set(Casts, 12755, 12755) -- Goblin Bomb Dispenser
	Set(Casts, 12720, 12720) -- Goblin "Boom" Box
	Set(Casts,  7023,  7023) -- Goblin Camera Connection
	Set(Casts, 12718, 12718) -- Goblin Construction Helmet
	Set(Casts,  6500,  6500) -- Goblin Deviled Clams
	Set(Casts, 12908, 12908) -- Goblin Dragon Gun
	Set(Casts,  9273,  9273) -- Goblin Jumper Cables
	Set(Casts, 23078, 23078) -- Goblin Jumper Cables XL
	Set(Casts, 10837, 10837) -- Goblin Land Mine
	Set(Casts, 12717, 12717) -- Goblin Mining Helmet
	Set(Casts, 12716, 12716) -- Goblin Mortar
	Set(Casts, 12722, 12722) -- Goblin Radio
	Set(Casts,  8895,  8895) -- Goblin Rocket Boots
	Set(Casts, 11456, 11456) -- Goblin Rocket Fuel
	Set(Casts, 12715, 12715) -- Goblin Rocket Fuel Recipe
	Set(Casts, 12758, 12758) -- Goblin Rocket Helmet
	Set(Casts, 12760, 12760) -- Goblin Sapper Charge
	Set(Casts,  3495,  3495) -- Golden Iron Destroyer
	Set(Casts, 23706, 23706) -- Golden Mantle of the Dawn
	Set(Casts, 14379, 14379) -- Golden Rod
	Set(Casts, 16060, 16060) -- Golden Sabercat
	Set(Casts,  3515,  3515) -- Golden Scale Boots
	Set(Casts,  7223,  7223) -- Golden Scale Bracers
	Set(Casts,  3503,  3503) -- Golden Scale Coif
	Set(Casts,  3511,  3511) -- Golden Scale Cuirass
	Set(Casts, 11643, 11643) -- Golden Scale Gauntlets
	Set(Casts,  3507,  3507) -- Golden Scale Leggings
	Set(Casts,  3505,  3505) -- Golden Scale Shoulders
	Set(Casts, 19667, 19667) -- Golden Skeleton Key
	Set(Casts, 12584, 12584) -- Gold Power Core
	Set(Casts,    27,    27) -- Goldshire Portal
	Set(Casts, 13028, 13028) -- Goldthorn Tea
	Set(Casts, 24967, 24967) -- Gong
	Set(Casts, 11434, 11434) -- Gong Zul'Farrak Gong
	Set(Casts,  3377,  3377) -- Gooey Spider Cake
	Set(Casts, 22789, 22789) -- Gordok Green Grog
	Set(Casts, 22813, 22813) -- Gordok Ogre Suit
	Set(Casts,  2542,  2542) -- Goretusk Liver Pie
	Set(Casts, 22924, 22924) -- Grasping Vines
	Set(Casts, 18989, 18989) -- Gray Kodo
	Set(Casts,  6777,  6777) -- Gray Ram
	Set(Casts,   459,   459) -- Gray Wolf
	Set(Casts,  2403,  2403) -- Gray Woolen Robe
	Set(Casts,  2406,  2406) -- Gray Woolen Shirt
	Set(Casts, 23249, 23249) -- Great Brown Kodo
	Set(Casts,  7643,  7643) -- Greater Adept's Robe
	Set(Casts, 15441, 15441) -- Greater Arcane Amalgamation
	Set(Casts, 17573, 17573) -- Greater Arcane Elixir
	Set(Casts, 17577, 17577) -- Greater Arcane Protection Potion
	Set(Casts, 24997, 24997) -- Greater Dispel
	Set(Casts, 24366, 24366) -- Greater Dreamless Sleep Potion
	Set(Casts, 17574, 17574) -- Greater Fire Protection Potion
	Set(Casts, 17575, 17575) -- Greater Frost Protection Potion
	Set(Casts, 25314, 25314) -- Greater Heal
	Set(Casts,  7181,  7181) -- Greater Healing Potion
	Set(Casts, 17579, 17579) -- Greater Holy Protection Potion
	Set(Casts, 10228, 10228) -- Greater Invisibility
	Set(Casts, 14807, 14807) -- Greater Magic Wand
	Set(Casts, 11448, 11448) -- Greater Mana Potion
	Set(Casts, 14810, 14810) -- Greater Mystic Wand
	Set(Casts, 17576, 17576) -- Greater Nature Protection Potion
	Set(Casts, 17578, 17578) -- Greater Shadow Protection Potion
	Set(Casts, 17570, 17570) -- Greater Stoneshield Potion
	Set(Casts, 23248, 23248) -- Great Gray Kodo
	Set(Casts, 25807, 25807) -- Great Heal
	Set(Casts,  6618,  6618) -- Great Rage Potion
	Set(Casts, 23247, 23247) -- Great White Kodo
	Set(Casts, 19050, 19050) -- Green Dragonscale Breastplate
	Set(Casts, 24655, 24655) -- Green Dragonscale Gauntlets
	Set(Casts, 19060, 19060) -- Green Dragonscale Leggings
	Set(Casts, 23068, 23068) -- Green Firework
	Set(Casts, 21945, 21945) -- Green Holiday Shirt
	Set(Casts,  3334,  3334) -- Green Iron Boots
	Set(Casts,  3501,  3501) -- Green Iron Bracers
	Set(Casts,  3336,  3336) -- Green Iron Gauntlets
	Set(Casts,  3508,  3508) -- Green Iron Hauberk
	Set(Casts,  3502,  3502) -- Green Iron Helm
	Set(Casts,  3506,  3506) -- Green Iron Leggings
	Set(Casts,  3504,  3504) -- Green Iron Shoulders
	Set(Casts, 18991, 18991) -- Green Kodo
	Set(Casts,  3772,  3772) -- Green Leather Armor
	Set(Casts,  3774,  3774) -- Green Leather Belt
	Set(Casts,  3776,  3776) -- Green Leather Bracers
	Set(Casts, 12622, 12622) -- Green Lens
	Set(Casts,  3841,  3841) -- Green Linen Bracers
	Set(Casts,  2396,  2396) -- Green Linen Shirt
	Set(Casts, 17453, 17453) -- Green Mechanostrider
	Set(Casts, 26424, 26424) -- Green Rocket Cluster
	Set(Casts,  8784,  8784) -- Green Silk Armor
	Set(Casts,  8774,  8774) -- Green Silken Shoulders
	Set(Casts,  6693,  6693) -- Green Silk Pack
	Set(Casts, 17465, 17465) -- Green Skeletal Warhorse
	Set(Casts,  3956,  3956) -- Green Tinted Goggles
	Set(Casts,  9197,  9197) -- Green Whelp Armor
	Set(Casts,  9202,  9202) -- Green Whelp Bracers
	Set(Casts,  3758,  3758) -- Green Woolen Bag
	Set(Casts,  7636,  7636) -- Green Woolen Robe
	Set(Casts,  2399,  2399) -- Green Woolen Vest
	Set(Casts, 18240, 18240) -- Grilled Squid
	Set(Casts, 24195, 24195) -- Grom's Tribute
	Set(Casts,  3773,  3773) -- Guardian Armor
	Set(Casts,  3775,  3775) -- Guardian Belt
	Set(Casts,  7153,  7153) -- Guardian Cloak
	Set(Casts,  7156,  7156) -- Guardian Gloves
	Set(Casts,  3777,  3777) -- Guardian Leather Bracers
	Set(Casts,  7147,  7147) -- Guardian Pants
	Set(Casts,  4153,  4153) -- Guile of the Raptor
	Set(Casts, 24266, 24266) -- Gurubashi Mojo Madness
	Set(Casts,  6982,  6982) -- Gust of Wind
	Set(Casts,  3961,  3961) -- Gyrochronatom
	Set(Casts, 23077, 23077) -- Gyrofreeze Ice Reflector
	Set(Casts, 12590, 12590) -- Gyromatic Micro-Adjustor
	Set(Casts, 16988, 16988) -- Hammer of the Titans
	Set(Casts, 24239, 24239) -- Hammer of Wrath
	Set(Casts,  3922,  3922) -- Handful of Copper Bolts
	Set(Casts, 18762, 18762) -- Hand of Iruxos
	Set(Casts,  8780,  8780) -- Hands of Darkness
	Set(Casts,  3753,  3753) -- Handstitched Leather Belt
	Set(Casts,  2149,  2149) -- Handstitched Leather Boots
	Set(Casts,  9059,  9059) -- Handstitched Leather Bracers
	Set(Casts,  9058,  9058) -- Handstitched Leather Cloak
	Set(Casts,  2153,  2153) -- Handstitched Leather Pants
	Set(Casts,  7126,  7126) -- Handstitched Leather Vest
	Set(Casts,  3842,  3842) -- Handstitched Linen Britches
	Set(Casts,  3492,  3492) -- Hardened Iron Shortsword
	Set(Casts,  5166,  5166) -- Harvest Silithid Egg
	Set(Casts,  7277,  7277) -- Harvest Swarm
	Set(Casts, 16336, 16336) -- Haunting Phantoms
	Set(Casts,  7057,  7057) -- Haunting Spirits
	Set(Casts,  8812,  8812) -- Heal
	Set(Casts, 22458, 22458) -- Healing Circle
	Set(Casts,  3447,  3447) -- Healing Potion
	Set(Casts,  4209,  4209) -- Healing Tongue
	Set(Casts,  4221,  4221) -- Healing Tongue II
	Set(Casts,  9888,  9888) -- Healing Touch
	Set(Casts,  4971,  4971) -- Healing Ward
	Set(Casts, 10396, 10396) -- Healing Wave
	Set(Casts, 11895, 11895) -- Healing Wave of Antu'sul
	Set(Casts, 21885, 21885) -- Heal Vylestem Vine
	Set(Casts,  8690,  8690) -- Hearthstone
	Set(Casts, 24214, 24214) -- Heart of Hakkar - Molthor chucks the heart
	Set(Casts, 16995, 16995) -- Heartseeker
	Set(Casts,  3780,  3780) -- Heavy Armor Kit
	Set(Casts,  3945,  3945) -- Heavy Blasting Powder
	Set(Casts,  3296,  3296) -- Heavy Bronze Mace
	Set(Casts,  3292,  3292) -- Heavy Copper Broadsword
	Set(Casts,  7408,  7408) -- Heavy Copper Maul
	Set(Casts, 24418, 24418) -- Heavy Crocolisk Stew
	Set(Casts,  4062,  4062) -- Heavy Dynamite
	Set(Casts,  9149,  9149) -- Heavy Earthen Gloves
	Set(Casts,  3337,  3337) -- Heavy Grinding Stone
	Set(Casts, 15910, 15910) -- Heavy Kodo Stew
	Set(Casts, 20649, 20649) -- Heavy Leather
	Set(Casts,  9194,  9194) -- Heavy Leather Ammo Pouch
	Set(Casts, 23190, 23190) -- Heavy Leather Ball
	Set(Casts,  3276,  3276) -- Heavy Linen Bandage
	Set(Casts,  3840,  3840) -- Heavy Linen Gloves
	Set(Casts, 10841, 10841) -- Heavy Mageweave Bandage
	Set(Casts,  9993,  9993) -- Heavy Mithril Axe
	Set(Casts,  9968,  9968) -- Heavy Mithril Boots
	Set(Casts,  9959,  9959) -- Heavy Mithril Breastplate
	Set(Casts,  9928,  9928) -- Heavy Mithril Gauntlet
	Set(Casts,  9970,  9970) -- Heavy Mithril Helm
	Set(Casts,  9933,  9933) -- Heavy Mithril Pants
	Set(Casts,  9926,  9926) -- Heavy Mithril Shoulder
	Set(Casts, 27585, 27585) -- Heavy Obsidian Belt
	Set(Casts,  9193,  9193) -- Heavy Quiver
	Set(Casts, 18630, 18630) -- Heavy Runecloth Bandage
	Set(Casts, 19070, 19070) -- Heavy Scorpid Belt
	Set(Casts, 19048, 19048) -- Heavy Scorpid Bracers
	Set(Casts, 19064, 19064) -- Heavy Scorpid Gauntlets
	Set(Casts, 19088, 19088) -- Heavy Scorpid Helm
	Set(Casts, 19075, 19075) -- Heavy Scorpid Leggings
	Set(Casts, 19100, 19100) -- Heavy Scorpid Shoulders
	Set(Casts, 19051, 19051) -- Heavy Scorpid Vest
	Set(Casts,  2674,  2674) -- Heavy Sharpening Stone
	Set(Casts,  7929,  7929) -- Heavy Silk Bandage
	Set(Casts, 23628, 23628) -- Heavy Timbermaw Belt
	Set(Casts, 23629, 23629) -- Heavy Timbermaw Boots
	Set(Casts,  3117,  3117) -- Heavy Weightstone
	Set(Casts,  3278,  3278) -- Heavy Wool Bandage
	Set(Casts,  3844,  3844) -- Heavy Woolen Cloak
	Set(Casts,  3843,  3843) -- Heavy Woolen Gloves
	Set(Casts,  3850,  3850) -- Heavy Woolen Pants
	Set(Casts, 30297, 30297) -- Heightened Senses
	Set(Casts,   711,   711) -- Hellfire
	Set(Casts,  1124,  1124) -- Hellfire II
	Set(Casts,  2951,  2951) -- Hellfire III
	Set(Casts, 10632, 10632) -- Helm of Fire
	Set(Casts, 16728, 16728) -- Helm of the Great Chief
	Set(Casts,  9146,  9146) -- Herbalist's Gloves
	Set(Casts,  8604,  8604) -- Herb Baked Egg
	Set(Casts,  2368,  2368) -- Herb Gathering
	Set(Casts, 22566, 22566) -- Hex
	Set(Casts,  7655,  7655) -- Hex of Ravenclaw
	Set(Casts, 18658, 18658) -- Hibernate
	Set(Casts, 22927, 22927) -- Hide of the Wild
	Set(Casts, 12619, 12619) -- Hi-Explosive Bomb
	Set(Casts, 12596, 12596) -- Hi-Impact Mithril Slugs
	Set(Casts,  3767,  3767) -- Hillman's Belt
	Set(Casts,  3760,  3760) -- Hillman's Cloak
	Set(Casts,  3764,  3764) -- Hillman's Leather Gloves
	Set(Casts,  3762,  3762) -- Hillman's Leather Vest
	Set(Casts,  3768,  3768) -- Hillman's Shoulders
	Set(Casts, 15261, 15261) -- Holy Fire
	Set(Casts, 25292, 25292) -- Holy Light
	Set(Casts,  7255,  7255) -- Holy Protection Potion
	Set(Casts,  9481,  9481) -- Holy Smite
	Set(Casts, 10318, 10318) -- Holy Wrath
	Set(Casts, 24962, 24962) -- Honor Points +138
	Set(Casts, 24963, 24963) -- Honor Points +228
	Set(Casts, 24966, 24966) -- Honor Points +2388
	Set(Casts, 24964, 24964) -- Honor Points +378
	Set(Casts, 24923, 24923) -- Honor Points +398
	Set(Casts, 24960, 24960) -- Honor Points +50
	Set(Casts, 24961, 24961) -- Honor Points +82
	Set(Casts, 24165, 24165) -- Hoodoo Hex
	Set(Casts, 14030, 14030) -- Hooked Net
	Set(Casts,  3398,  3398) -- Hot Lion Chops
	Set(Casts, 18242, 18242) -- Hot Smoked Bass
	Set(Casts, 15856, 15856) -- Hot Wolf Ribs
	Set(Casts,  7481,  7481) -- Howling Rage
	Set(Casts, 17928, 17928) -- Howl of Terror
	Set(Casts, 16971, 16971) -- Huge Thorium Battleaxe
	Set(Casts, 23124, 23124) -- Human Orphan Whistle
	Set(Casts, 11760, 11760) -- Hyena Sample
	Set(Casts, 23081, 23081) -- Hyper-Radiant Flame Reflector
	Set(Casts, 28244, 28244) -- Icebane Bracers
	Set(Casts, 28242, 28242) -- Icebane Breastplate
	Set(Casts, 28243, 28243) -- Icebane Gauntlets
	Set(Casts, 28526, 28526) -- Icebolt
	Set(Casts,  3957,  3957) -- Ice Deflector
	Set(Casts, 28163, 28163) -- Ice Guard
	Set(Casts, 16869, 16869) -- Ice Tomb
	Set(Casts, 11131, 11131) -- Icicle
	Set(Casts, 17459, 17459) -- Icy Blue Mechanostrider
	Set(Casts,  3862,  3862) -- Icy Cloak
	Set(Casts, 28224, 28224) -- Icy Scale Bracers
	Set(Casts, 28222, 28222) -- Icy Scale Breastplate
	Set(Casts, 28223, 28223) -- Icy Scale Gauntlets
	Set(Casts,  6741,  6741) -- Identify Brood
	Set(Casts, 23316, 23316) -- Ignite Flesh
	Set(Casts, 23054, 23054) -- Igniting Kroshius
	Set(Casts,  6487,  6487) -- Ilkrud's Guardians
	Set(Casts, 25309, 25309) -- Immolate
	Set(Casts, 16647, 16647) -- Imperial Plate Belt
	Set(Casts, 16657, 16657) -- Imperial Plate Boots
	Set(Casts, 16649, 16649) -- Imperial Plate Bracers
	Set(Casts, 16663, 16663) -- Imperial Plate Chest
	Set(Casts, 16658, 16658) -- Imperial Plate Helm
	Set(Casts, 16730, 16730) -- Imperial Plate Leggings
	Set(Casts, 16646, 16646) -- Imperial Plate Shoulders
	Set(Casts, 10451, 10451) -- Implosion
	Set(Casts, 16996, 16996) -- Incendia Powder
	Set(Casts, 23308, 23308) -- Incinerate
	Set(Casts,  6234,  6234) -- Incineration
	Set(Casts, 27290, 27290) -- Increase Reputation
	Set(Casts,  4981,  4981) -- Inducing Vision
	Set(Casts,  1122,  1122) -- Inferno
	Set(Casts, 22868, 22868) -- Inferno Gloves
	Set(Casts,  7739,  7739) -- Inferno Shell
	Set(Casts,  9612,  9612) -- Ink Spray
	Set(Casts, 11454, 11454) -- Inlaid Mithril Cylinder
	Set(Casts, 12895, 12895) -- Inlaid Mithril Cylinder Plans
	Set(Casts, 16967, 16967) -- Inlaid Thorium Hammer
	Set(Casts,  8681,  8681) -- Instant Poison
	Set(Casts,  8686,  8686) -- Instant Poison II
	Set(Casts,  8688,  8688) -- Instant Poison III
	Set(Casts, 11338, 11338) -- Instant Poison IV
	Set(Casts, 11339, 11339) -- Instant Poison V
	Set(Casts, 11343, 11343) -- Instant Poison VI
	Set(Casts,  6651,  6651) -- Instant Toxin
	Set(Casts, 22478, 22478) -- Intense Pain
	Set(Casts,  6576,  6576) -- Intimidating Growl
	Set(Casts,   885,   885) -- Invisibility
	Set(Casts, 11464, 11464) -- Invisibility Potion
	Set(Casts,  9478,  9478) -- Invis Placing Bear Trap
	Set(Casts, 16746, 16746) -- Invulnerable Mail
	Set(Casts,  6518,  6518) -- Iridescent Hammer
	Set(Casts,  8768,  8768) -- Iron Buckle
	Set(Casts,  7222,  7222) -- Iron Counterweight
	Set(Casts, 19086, 19086) -- Ironfeather Breastplate
	Set(Casts, 19062, 19062) -- Ironfeather Shoulders
	Set(Casts,  8367,  8367) -- Ironforge Breastplate
	Set(Casts,  8366,  8366) -- Ironforge Chain
	Set(Casts,  8368,  8368) -- Ironforge Gauntlets
	Set(Casts,  4068,  4068) -- Iron Grenade
	Set(Casts,  7221,  7221) -- Iron Shield Spike
	Set(Casts,  3958,  3958) -- Iron Strut
	Set(Casts, 28463, 28463) -- Ironvine Belt
	Set(Casts, 28461, 28461) -- Ironvine Breastplate
	Set(Casts, 28462, 28462) -- Ironvine Gloves
	Set(Casts, 10795, 10795) -- Ivory Raptor
	Set(Casts,  3493,  3493) -- Jade Serpentblade
	Set(Casts, 27586, 27586) -- Jagged Obsidian Shield
	Set(Casts, 23122, 23122) -- Jaina's Autograph
	Set(Casts,  9744,  9744) -- Jarkal's Translation
	Set(Casts, 23140, 23140) -- J'eevee summons object
	Set(Casts, 11438, 11438) -- Join Map Fragments
	Set(Casts,  8348,  8348) -- Julie's Blessing
	Set(Casts,  9654,  9654) -- Jumping Lightning
	Set(Casts, 15861, 15861) -- Jungle Stew
	Set(Casts, 12684, 12684) -- Kadrak's Flag
	Set(Casts, 12512, 12512) -- Kalaran Conjures Torch
	Set(Casts,  6412,  6412) -- Kaldorei Spider Kabob
	Set(Casts,  3121,  3121) -- Kev
	Set(Casts, 10166, 10166) -- Khadgar's Unlocking
	Set(Casts, 22799, 22799) -- King of the Gordok
	Set(Casts,  5244,  5244) -- Kodo Hide Bag
	Set(Casts, 18153, 18153) -- Kodo Kombobulator
	Set(Casts, 22790, 22790) -- Kreeg's Stout Beatdown
	Set(Casts, 26420, 26420) -- Large Blue Rocket
	Set(Casts, 26426, 26426) -- Large Blue Rocket Cluster
	Set(Casts,  3937,  3937) -- Large Copper Bomb
	Set(Casts, 26421, 26421) -- Large Green Rocket
	Set(Casts, 26427, 26427) -- Large Green Rocket Cluster
	Set(Casts, 26422, 26422) -- Large Red Rocket
	Set(Casts, 26428, 26428) -- Large Red Rocket Cluster
	Set(Casts,  4075,  4075) -- Large Seaforium Charge
	Set(Casts,   580,   580) -- Large Timber Wolf
	Set(Casts, 23707, 23707) -- Lava Belt
	Set(Casts, 12075, 12075) -- Lavender Mageweave Shirt
	Set(Casts,  6419,  6419) -- Lean Venison
	Set(Casts, 15853, 15853) -- Lean Wolf Steak
	Set(Casts, 27146, 27146) -- Left Piece of Lord Valthalak's Amulet
	Set(Casts, 15463, 15463) -- Legendary Arcane Amalgamation
	Set(Casts, 10788, 10788) -- Leopard
	Set(Casts, 11534, 11534) -- Leper Cure!
	Set(Casts, 15402, 15402) -- Lesser Arcane Amalgamation
	Set(Casts,  2053,  2053) -- Lesser Heal
	Set(Casts,  2337,  2337) -- Lesser Healing Potion
	Set(Casts, 27624, 27624) -- Lesser Healing Wave
	Set(Casts,    66,    66) -- Lesser Invisibility
	Set(Casts,  3448,  3448) -- Lesser Invisibility Potion
	Set(Casts, 14293, 14293) -- Lesser Magic Wand
	Set(Casts, 25120, 25120) -- Lesser Mana Oil
	Set(Casts,  3173,  3173) -- Lesser Mana Potion
	Set(Casts, 14809, 14809) -- Lesser Mystic Wand
	Set(Casts,  4942,  4942) -- Lesser Stoneshield Potion
	Set(Casts, 25119, 25119) -- Lesser Wizard Oil
	Set(Casts,  6690,  6690) -- Lesser Wizard's Robe
	Set(Casts,  8256,  8256) -- Lethal Toxin
	Set(Casts,  3243,  3243) -- Life Harvest
	Set(Casts, 19793, 19793) -- Lifelike Mechanical Toad
	Set(Casts,  9172,  9172) -- Lift Seal
	Set(Casts,  2152,  2152) -- Light Armor Kit
	Set(Casts,  2881,  2881) -- Light Leather
	Set(Casts,  9065,  9065) -- Light Leather Bracers
	Set(Casts,  9068,  9068) -- Light Leather Pants
	Set(Casts,  9060,  9060) -- Light Leather Quiver
	Set(Casts,  8598,  8598) -- Lightning Blast
	Set(Casts, 15207, 15207) -- Lightning Bolt
	Set(Casts, 20627, 20627) -- Lightning Breath
	Set(Casts,  6535,  6535) -- Lightning Cloud
	Set(Casts, 28297, 28297) -- Lightning Totem
	Set(Casts, 27588, 27588) -- Light Obsidian Belt
	Set(Casts,  7364,  7364) -- Light Torch
	Set(Casts, 27871, 27871) -- Lightwell
	Set(Casts,  2157,  2157) -- Light Winter Boots
	Set(Casts,  2156,  2156) -- Light Winter Cloak
	Set(Casts, 15633, 15633) -- Lil' Smoky
	Set(Casts,  3175,  3175) -- Limited Invulnerability Potion
	Set(Casts,  3755,  3755) -- Linen Bag
	Set(Casts,  3275,  3275) -- Linen Bandage
	Set(Casts,  8776,  8776) -- Linen Belt
	Set(Casts,  2386,  2386) -- Linen Boots
	Set(Casts,  2387,  2387) -- Linen Cloak
	Set(Casts, 15712, 15712) -- Linken's Boomerang
	Set(Casts, 16729, 16729) -- Lionheart Helm
	Set(Casts, 24367, 24367) -- Living Action Potion
	Set(Casts, 19095, 19095) -- Living Breastplate
	Set(Casts, 19078, 19078) -- Living Leggings
	Set(Casts, 19061, 19061) -- Living Shoulders
	Set(Casts,  5401,  5401) -- Lizard Bolt
	Set(Casts, 18245, 18245) -- Lobster Stew
	Set(Casts,  7754,  7754) -- Loch Frenzy Delight
	Set(Casts, 28785, 28785) -- Locust Swarm
	Set(Casts,  7753,  7753) -- Longjaw Mud Snapper
	Set(Casts,  1536,  1536) -- Longshot II
	Set(Casts,  3007,  3007) -- Longshot III
	Set(Casts, 25247, 25247) -- Longsight
	Set(Casts,  3861,  3861) -- Long Silken Cloak
	Set(Casts,  3939,  3939) -- Lovingly Crafted Boomstick
	Set(Casts, 26373, 26373) -- Lunar Invititation
	Set(Casts, 10346, 10346) -- Machine Gun
	Set(Casts, 17117, 17117) -- Magatha Incendia Powder
	Set(Casts, 24365, 24365) -- Mageblood Potion
	Set(Casts,  3659,  3659) -- Mage Sight
	Set(Casts, 12065, 12065) -- Mageweave Bag
	Set(Casts, 10840, 10840) -- Mageweave Bandage
	Set(Casts, 11453, 11453) -- Magic Resistance Potion
	Set(Casts, 20565, 20565) -- Magma Blast
	Set(Casts, 19484, 19484) -- Majordomo Teleport Visual
	Set(Casts, 17556, 17556) -- Major Healing Potion
	Set(Casts, 17580, 17580) -- Major Mana Potion
	Set(Casts, 23079, 23079) -- Major Recombobulator
	Set(Casts, 22732, 22732) -- Major Rejuvenation Potion
	Set(Casts, 24368, 24368) -- Major Troll's Blood Potion
	Set(Casts, 10876, 10876) -- Mana Burn
	Set(Casts,  3452,  3452) -- Mana Potion
	Set(Casts, 21097, 21097) -- Manastorm
	Set(Casts, 18113, 18113) -- Manifestation Cleansing
	Set(Casts, 21960, 21960) -- Manifest Spirit
	Set(Casts, 23304, 23304) -- Manna-Enriched Horse Feed
	Set(Casts, 23663, 23663) -- Mantle of the Timbermaw
	Set(Casts, 15128, 15128) -- Mark of Flames
	Set(Casts, 12198, 12198) -- Marksman Hit
	Set(Casts,  4526,  4526) -- Mass Dispell
	Set(Casts, 25839, 25839) -- Mass Healing
	Set(Casts, 22421, 22421) -- Massive Geyser
	Set(Casts,  3498,  3498) -- Massive Iron Axe
	Set(Casts, 19825, 19825) -- Master Engineer's Goggles
	Set(Casts, 16993, 16993) -- Masterwork Stormhammer
	Set(Casts, 19814, 19814) -- Masterwork Target Dummy
	Set(Casts, 29134, 29134) -- Maypole
	Set(Casts,  7920,  7920) -- Mebok Smart Drink
	Set(Casts,  3969,  3969) -- Mechanical Dragonling
	Set(Casts, 15057, 15057) -- Mechanical Patch Kit
	Set(Casts, 15255, 15255) -- Mechanical Repair Kit
	Set(Casts,  4055,  4055) -- Mechanical Squirrel
	Set(Casts,  2165,  2165) -- Medium Armor Kit
	Set(Casts, 20648, 20648) -- Medium Leather
	Set(Casts, 11082, 11082) -- Megavolt
	Set(Casts, 21050, 21050) -- Melodious Rapture
	Set(Casts,  5159,  5159) -- Melt Ore
	Set(Casts, 16032, 16032) -- Merging Oozes
	Set(Casts, 25145, 25145) -- Merithra's Wake
	Set(Casts, 14008, 14008) -- Miblon's Bait
	Set(Casts, 29333, 29333) -- Midsummer Sausage
	Set(Casts, 18246, 18246) -- Mightfish Steak
	Set(Casts, 21154, 21154) -- Might of Ragnaros
	Set(Casts, 16600, 16600) -- Might of Shahram
	Set(Casts, 29483, 29483) -- Might of the Scourge
	Set(Casts, 23703, 23703) -- Might of the Timbermaw
	Set(Casts,  3297,  3297) -- Mighty Iron Hammer
	Set(Casts, 17552, 17552) -- Mighty Rage Potion
	Set(Casts,  3451,  3451) -- Mighty Troll's Blood Potion
	Set(Casts, 10947, 10947) -- Mind Blast
	Set(Casts, 10912, 10912) -- Mind Control
	Set(Casts,  5761,  5761) -- Mind-numbing Poison
	Set(Casts,  8693,  8693) -- Mind-numbing Poison II
	Set(Casts, 11399, 11399) -- Mind-numbing Poison III
	Set(Casts,   606,   606) -- Mind Rot
	Set(Casts,  8272,  8272) -- Mind Tremor
	Set(Casts, 23675, 23675) -- Minigun
	Set(Casts,  2576,  2576) -- Mining
	Set(Casts,  3611,  3611) -- Minion of Morganth
	Set(Casts,  3537,  3537) -- Minions of Malathrom
	Set(Casts,  2330,  2330) -- Minor Healing Potion
	Set(Casts,  3172,  3172) -- Minor Magic Resistance Potion
	Set(Casts, 25118, 25118) -- Minor Mana Oil
	Set(Casts,  2331,  2331) -- Minor Mana Potion
	Set(Casts,  3952,  3952) -- Minor Recombobulator
	Set(Casts,  2332,  2332) -- Minor Rejuvenation Potion
	Set(Casts, 25117, 25117) -- Minor Wizard Oil
	Set(Casts,  5567,  5567) -- Miring Mud
	Set(Casts,  8138,  8138) -- Mirkfallon Fungus
	Set(Casts, 26218, 26218) -- Mistletoe
	Set(Casts, 12595, 12595) -- Mithril Blunderbuss
	Set(Casts, 12599, 12599) -- Mithril Casing
	Set(Casts,  9961,  9961) -- Mithril Coif
	Set(Casts, 12421, 12421) -- Mithril Frag Bomb
	Set(Casts, 12621, 12621) -- Mithril Gyro-Shot
	Set(Casts, 20916, 20916) -- Mithril Headed Trout
	Set(Casts, 12614, 12614) -- Mithril Heavy-bore Rifle
	Set(Casts, 12624, 12624) -- Mithril Mechanical Dragonling
	Set(Casts,  9937,  9937) -- Mithril Scale Bracers
	Set(Casts,  9942,  9942) -- Mithril Scale Gloves
	Set(Casts,  9931,  9931) -- Mithril Scale Pants
	Set(Casts,  9966,  9966) -- Mithril Scale Shoulders
	Set(Casts,  9781,  9781) -- Mithril Shield Spike
	Set(Casts,  9783,  9783) -- Mithril Spurs
	Set(Casts, 12589, 12589) -- Mithril Tube
	Set(Casts, 12900, 12900) -- Mobile Alarm
	Set(Casts, 23710, 23710) -- Molten Belt
	Set(Casts, 15095, 15095) -- Molten Blast
	Set(Casts, 20854, 20854) -- Molten Helm
	Set(Casts,  5213,  5213) -- Molten Metal
	Set(Casts, 25150, 25150) -- Molten Rain
	Set(Casts, 22922, 22922) -- Mongoose Boots
	Set(Casts, 15933, 15933) -- Monster Omelet
	Set(Casts, 18560, 18560) -- Mooncloth
	Set(Casts, 18445, 18445) -- Mooncloth Bag
	Set(Casts, 19435, 19435) -- Mooncloth Boots
	Set(Casts, 18452, 18452) -- Mooncloth Circlet
	Set(Casts, 22869, 22869) -- Mooncloth Gloves
	Set(Casts, 18440, 18440) -- Mooncloth Leggings
	Set(Casts, 22902, 22902) -- Mooncloth Robe
	Set(Casts, 18448, 18448) -- Mooncloth Shoulders
	Set(Casts, 18447, 18447) -- Mooncloth Vest
	Set(Casts,  8322,  8322) -- Moonglow Vest
	Set(Casts,  3954,  3954) -- Moonsight Rifle
	Set(Casts,  3496,  3496) -- Moonsteel Broadsword
	Set(Casts, 20528, 20528) -- Mor'rogal Enchant
	Set(Casts, 16084, 16084) -- Mottled Red Raptor
	Set(Casts,  3372,  3372) -- Murloc Fin Soup
	Set(Casts,  6702,  6702) -- Murloc Scale Belt
	Set(Casts,  6705,  6705) -- Murloc Scale Bracers
	Set(Casts,  6703,  6703) -- Murloc Scale Breastplate
	Set(Casts, 15865, 15865) -- Mystery Stew
	Set(Casts, 14928, 14928) -- Nagmara's Love Potion
	Set(Casts, 25688, 25688) -- Narain!
	Set(Casts,  7967,  7967) -- Naralex's Nightmare
	Set(Casts, 22597, 22597) -- Nature Mantle of the Dawn
	Set(Casts,  7259,  7259) -- Nature Protection Potion
	Set(Casts, 25180, 25180) -- Nature Weakness
	Set(Casts, 16069, 16069) -- Nefarius Attack 001
	Set(Casts,  7673,  7673) -- Nether Gem
	Set(Casts,  8088,  8088) -- Nightcrawlers
	Set(Casts, 23653, 23653) -- Nightfall
	Set(Casts, 18243, 18243) -- Nightfin Soup
	Set(Casts, 16055, 16055) -- Nightsaber
	Set(Casts, 10558, 10558) -- Nightscape Boots
	Set(Casts, 10550, 10550) -- Nightscape Cloak
	Set(Casts, 10507, 10507) -- Nightscape Headband
	Set(Casts, 10548, 10548) -- Nightscape Pants
	Set(Casts, 10516, 10516) -- Nightscape Shoulders
	Set(Casts, 10499, 10499) -- Nightscape Tunic
	Set(Casts,  9074,  9074) -- Nimble Leather Gloves
	Set(Casts,  6199,  6199) -- Nostalgia
	Set(Casts,  7994,  7994) -- Nullify Mana
	Set(Casts, 16528, 16528) -- Numbing Pain
	Set(Casts, 27590, 27590) -- Obsidian Mail Tunic
	Set(Casts, 10798, 10798) -- Obsidian Raptor
	Set(Casts, 11451, 11451) -- Oil of Immolation
	Set(Casts, 19106, 19106) -- Onyxia Scale Breastplate
	Set(Casts, 19093, 19093) -- Onyxia Scale Cloak
	Set(Casts,  6249,  6249) -- Opening
	Set(Casts, 15276, 15276) -- Opening Bar Door
	Set(Casts,  6529,  6529) -- Opening Benedict's Chest
	Set(Casts,  5107,  5107) -- Opening Booty Chest
	Set(Casts, 11792, 11792) -- Opening Cage
	Set(Casts, 11437, 11437) -- Opening Chest
	Set(Casts, 13564, 13564) -- Opening Dark Coffer
	Set(Casts, 26588, 26588) -- Opening Greater Scarab Coffer
	Set(Casts, 22810, 22810) -- Opening - No Text
	Set(Casts, 13478, 13478) -- Opening Relic Coffer
	Set(Casts, 11535, 11535) -- Opening Safe
	Set(Casts, 26587, 26587) -- Opening Scarab Coffer
	Set(Casts, 14125, 14125) -- Opening Secret Safe
	Set(Casts, 13565, 13565) -- Opening Secure Safe
	Set(Casts, 17432, 17432) -- Opening Stratholme Postbox
	Set(Casts,  8517,  8517) -- Opening Strongbox
	Set(Casts, 18952, 18952) -- Opening Termite Barrel
	Set(Casts, 12061, 12061) -- Orange Mageweave Shirt
	Set(Casts, 12064, 12064) -- Orange Martial Shirt
	Set(Casts, 23125, 23125) -- Orcish Orphan Whistle
	Set(Casts,  9957,  9957) -- Orcish War Leggings
	Set(Casts,  9979,  9979) -- Ornate Mithril Boots
	Set(Casts,  9972,  9972) -- Ornate Mithril Breastplate
	Set(Casts,  9950,  9950) -- Ornate Mithril Gloves
	Set(Casts,  9980,  9980) -- Ornate Mithril Helm
	Set(Casts,  9945,  9945) -- Ornate Mithril Pants
	Set(Casts,  9952,  9952) -- Ornate Mithril Shoulders
	Set(Casts,  6458,  6458) -- Ornate Spyglass
	Set(Casts, 16969, 16969) -- Ornate Thorium Handaxe
	Set(Casts, 26063, 26063) -- Ouro Submerge Visual
	Set(Casts,  8153,  8153) -- Owl Form
	Set(Casts, 16379, 16379) -- Ozzie Explodes
	Set(Casts,   471,   471) -- Palamino Stallion
	Set(Casts, 16082, 16082) -- Palomino Stallion
	Set(Casts, 10787, 10787) -- Panther
	Set(Casts, 17176, 17176) -- Panther Cage Key
	Set(Casts, 12616, 12616) -- Parachute Cloak
	Set(Casts,  8363,  8363) -- Parasite
	Set(Casts,  6758,  6758) -- Party Fever
	Set(Casts,  2672,  2672) -- Patterned Bronze Bracers
	Set(Casts,  6521,  6521) -- Pearl-clasped Cloak
	Set(Casts,  6517,  6517) -- Pearl-handled Dagger
	Set(Casts,  5668,  5668) -- Peasant Disguise
	Set(Casts,  5669,  5669) -- Peon Disguise
	Set(Casts, 11048, 11048) -- Perm. Illusion Bishop Tyriona
	Set(Casts, 11067, 11067) -- Perm. Illusion Tyrion
	Set(Casts, 27830, 27830) -- Persuader
	Set(Casts, 15628, 15628) -- Pet Bombling
	Set(Casts, 10007, 10007) -- Phantom Blade
	Set(Casts, 11459, 11459) -- Philosophers' Stone
	Set(Casts,  3868,  3868) -- Phoenix Gloves
	Set(Casts,  3851,  3851) -- Phoenix Pants
	Set(Casts,  6461,  6461) -- Pick Lock
	Set(Casts,  5967,  5967) -- Pickpocket (PT)
	Set(Casts, 16429, 16429) -- Piercing Shadow
	Set(Casts,  9148,  9148) -- Pilferer's Gloves
	Set(Casts,  4982,  4982) -- Pillar Delving
	Set(Casts, 12080, 12080) -- Pink Mageweave Shirt
	Set(Casts,   472,   472) -- Pinto Horse
	Set(Casts, 25783, 25783) -- Place Arcanite Buoy
	Set(Casts, 19588, 19588) -- Place Ghost Magnet
	Set(Casts,  6717,  6717) -- Place Lion Carcass
	Set(Casts, 23204, 23204) -- Place Scryer
	Set(Casts, 15118, 15118) -- Place Threshadon Carcass
	Set(Casts,  6620,  6620) -- Place Toxic Fogger
	Set(Casts, 22905, 22905) -- Place Unfired Blade
	Set(Casts, 16057, 16057) -- Place Unforged Seal
	Set(Casts, 17016, 17016) -- Placing Beacon Torch
	Set(Casts,  9437,  9437) -- Placing Bear Trap
	Set(Casts,  8001,  8001) -- Placing Pendant
	Set(Casts, 19250, 19250) -- Placing Smokey's Explosives
	Set(Casts, 15728, 15728) -- Plague Cloud
	Set(Casts,  3429,  3429) -- Plague Mind
	Set(Casts, 13484, 13484) -- Plant Gor'tesh Head
	Set(Casts, 16989, 16989) -- Planting Banner
	Set(Casts, 21355, 21355) -- Planting Guse's Beacon
	Set(Casts, 21728, 21728) -- Planting Ichman's Beacon
	Set(Casts, 21370, 21370) -- Planting Jeztor's Beacon
	Set(Casts, 21371, 21371) -- Planting Mulverick's Beacon
	Set(Casts, 21537, 21537) -- Planting Ryson's Beacon
	Set(Casts, 21729, 21729) -- Planting Slidore's Beacon
	Set(Casts, 21730, 21730) -- Planting Vipore's Beacon
	Set(Casts, 19069, 19069) -- Plant Magic Beans
	Set(Casts,  5206,  5206) -- Plant Seeds
	Set(Casts,  9220,  9220) -- "Plucky" Resumes Chicken Form
	Set(Casts, 22906, 22906) -- Plunging Blade into Onyxia
	Set(Casts, 18244, 18244) -- Poached Sunscale Salmon
	Set(Casts, 28614, 28614) -- Pointy Spike
	Set(Casts, 21067, 21067) -- Poison Bolt
	Set(Casts, 11790, 11790) -- Poison Cloud
	Set(Casts,  5208,  5208) -- Poisoned Harpoon
	Set(Casts,  8275,  8275) -- Poisoned Shot
	Set(Casts,  4286,  4286) -- Poisonous Spit
	Set(Casts, 25748, 25748) -- Poison Stinger
	Set(Casts, 28221, 28221) -- Polar Bracers
	Set(Casts, 28220, 28220) -- Polar Gloves
	Set(Casts, 28089, 28089) -- Polarity Shift
	Set(Casts, 28219, 28219) -- Polar Tunic
	Set(Casts,  3513,  3513) -- Polished Steel Boots
	Set(Casts, 28271, 28271) -- Polymorph
	Set(Casts, 28270, 28270) -- Polymorph: Cow
	Set(Casts,  3960,  3960) -- Portable Bronze Mortar
	Set(Casts, 11419, 11419) -- Portal: Darnassus
	Set(Casts, 11416, 11416) -- Portal: Ironforge
	Set(Casts, 28148, 28148) -- Portal: Karazhan
	Set(Casts, 11417, 11417) -- Portal: Orgrimmar
	Set(Casts, 23680, 23680) -- Portals Deck
	Set(Casts, 10059, 10059) -- Portal: Stormwind
	Set(Casts, 11420, 11420) -- Portal: Thunder Bluff
	Set(Casts, 11418, 11418) -- Portal: Undercity
	Set(Casts,  7638,  7638) -- Potion Toss
	Set(Casts, 23787, 23787) -- Powerful Anti-Venom
	Set(Casts, 23008, 23008) -- Powerful Seaforium Charge
	Set(Casts, 10850, 10850) -- Powerful Smelling Salts
	Set(Casts, 29467, 29467) -- Power of the Scourge
	Set(Casts,  8334,  8334) -- Practice Lock
	Set(Casts, 25841, 25841) -- Prayer of Elune
	Set(Casts, 25316, 25316) -- Prayer of Healing
	Set(Casts,  3109,  3109) -- Presence of Death
	Set(Casts, 24149, 24149) -- Presence of Might
	Set(Casts, 24164, 24164) -- Presence of Sight
	Set(Casts, 24123, 24123) -- Primal Batskin Bracers
	Set(Casts, 24122, 24122) -- Primal Batskin Gloves
	Set(Casts, 24121, 24121) -- Primal Batskin Jerkin
	Set(Casts, 16058, 16058) -- Primal Leopard
	Set(Casts, 13912, 13912) -- Princess Summons Portal
	Set(Casts, 24167, 24167) -- Prophetic Aura
	Set(Casts,  7120,  7120) -- Proudmoore's Defense
	Set(Casts, 15050, 15050) -- Psychometry
	Set(Casts, 17572, 17572) -- Purification Potion
	Set(Casts, 16072, 16072) -- Purify and Place Food
	Set(Casts, 22313, 22313) -- Purple Hands
	Set(Casts, 17455, 17455) -- Purple Mechanostrider
	Set(Casts, 23246, 23246) -- Purple Skeletal Warhorse
	Set(Casts, 18809, 18809) -- Pyroblast
	Set(Casts, 28745, 28745) -- Quest - Prepare Field Duty Papers
	Set(Casts,  5408,  5408) -- Quest - Sergra Darkthorn Spell
	Set(Casts, 12537, 12537) -- Quest - Summon Treant
	Set(Casts, 24221, 24221) -- Quest - Teleport Spawn-out
	Set(Casts, 24258, 24258) -- Quest - Troll Hero Summon Visual
	Set(Casts,  3229,  3229) -- Quick Bloodlust
	Set(Casts, 14930, 14930) -- Quickdraw Quiver
	Set(Casts,  4979,  4979) -- Quick Flame Ward
	Set(Casts,  4980,  4980) -- Quick Frost Ward
	Set(Casts, 16645, 16645) -- Radiant Belt
	Set(Casts, 16656, 16656) -- Radiant Boots
	Set(Casts, 16648, 16648) -- Radiant Breastplate
	Set(Casts, 16659, 16659) -- Radiant Circlet
	Set(Casts, 16654, 16654) -- Radiant Gloves
	Set(Casts, 16725, 16725) -- Radiant Leggings
	Set(Casts,  9771,  9771) -- Radiation Bolt
	Set(Casts,  3387,  3387) -- Rage of Thule
	Set(Casts,  6617,  6617) -- Rage Potion
	Set(Casts, 20568, 20568) -- Ragnaros Emerge
	Set(Casts,  7827,  7827) -- Rainbow Fin Albacore
	Set(Casts,  4629,  4629) -- Rain of Fire
	Set(Casts, 28353, 28353) -- Raise Dead
	Set(Casts, 17235, 17235) -- Raise Undead Scarab
	Set(Casts,  5316,  5316) -- Raptor Feather
	Set(Casts,  4097,  4097) -- Raptor Hide Belt
	Set(Casts,  4096,  4096) -- Raptor Hide Harness
	Set(Casts,  5280,  5280) -- Razor Mane
	Set(Casts, 20748, 20748) -- Rebirth
	Set(Casts, 22563, 22563) -- Recall
	Set(Casts, 21950, 21950) -- Recite Words of Celebras
	Set(Casts,  4093,  4093) -- Reconstruction
	Set(Casts, 17456, 17456) -- Red & Blue Mechanostrider
	Set(Casts, 19054, 19054) -- Red Dragonscale Breastplate
	Set(Casts, 23254, 23254) -- Redeeming the Soul
	Set(Casts, 20773, 20773) -- Redemption
	Set(Casts, 23066, 23066) -- Red Firework
	Set(Casts,  6686,  6686) -- Red Linen Bag
	Set(Casts,  2389,  2389) -- Red Linen Robe
	Set(Casts,  2392,  2392) -- Red Linen Shirt
	Set(Casts,  7629,  7629) -- Red Linen Vest
	Set(Casts, 12079, 12079) -- Red Mageweave Bag
	Set(Casts, 12066, 12066) -- Red Mageweave Gloves
	Set(Casts, 12084, 12084) -- Red Mageweave Headband
	Set(Casts, 12060, 12060) -- Red Mageweave Pants
	Set(Casts, 12078, 12078) -- Red Mageweave Shoulders
	Set(Casts, 12056, 12056) -- Red Mageweave Vest
	Set(Casts, 10873, 10873) -- Red Mechanostrider
	Set(Casts,  2547,  2547) -- Redridge Goulash
	Set(Casts, 26425, 26425) -- Red Rocket Cluster
	Set(Casts, 17462, 17462) -- Red Skeletal Horse
	Set(Casts, 22722, 22722) -- Red Skeletal Warhorse
	Set(Casts,  8489,  8489) -- Red Swashbuckler's Shirt
	Set(Casts,  9072,  9072) -- Red Whelp Gloves
	Set(Casts, 16080, 16080) -- Red Wolf
	Set(Casts,  6688,  6688) -- Red Woolen Bag
	Set(Casts,  3847,  3847) -- Red Woolen Boots
	Set(Casts, 22430, 22430) -- Refined Scale of Onyxia
	Set(Casts,  9858,  9858) -- Regrowth
	Set(Casts, 25952, 25952) -- Reindeer Dust Effect
	Set(Casts,  2397,  2397) -- Reinforced Linen Cape
	Set(Casts,  3849,  3849) -- Reinforced Woolen Shoulders
	Set(Casts, 23180, 23180) -- Release Imp
	Set(Casts, 23136, 23136) -- Release J'eevee
	Set(Casts, 10617, 10617) -- Release Rageclaw
	Set(Casts, 12851, 12851) -- Release the Hounds
	Set(Casts, 17166, 17166) -- Release Umi's Yeti
	Set(Casts, 16502, 16502) -- Release Winna's Kitten
	Set(Casts, 16031, 16031) -- Releasing Corrupt Ooze
	Set(Casts,  6656,  6656) -- Remote Detonate
	Set(Casts, 22027, 22027) -- Remove Insignia
	Set(Casts,  8362,  8362) -- Renew
	Set(Casts, 11923, 11923) -- Repair the Blade of Heroes
	Set(Casts,   455,   455) -- Replenish Spirit
	Set(Casts,   932,   932) -- Replenish Spirit II
	Set(Casts, 26001, 26001) -- Reputation - Ahn'Qiraj Temple Boss
	Set(Casts, 28393, 28393) -- Reputation - Booty Bay +500
	Set(Casts, 28396, 28396) -- Reputation - Everlook +500
	Set(Casts, 28397, 28397) -- Reputation - Gadgetzan +500
	Set(Casts, 28394, 28394) -- Reputation - Ratchet +500
	Set(Casts, 29475, 29475) -- Resilience of the Scourge
	Set(Casts, 11452, 11452) -- Restorative Potion
	Set(Casts,  4961,  4961) -- Resupply
	Set(Casts, 20770, 20770) -- Resurrection
	Set(Casts, 30081, 30081) -- Retching Plague
	Set(Casts,  5161,  5161) -- Revive Dig Rat
	Set(Casts,   982,   982) -- Revive Pet
	Set(Casts, 15591, 15591) -- Revive Ringo
	Set(Casts,  3872,  3872) -- Rich Purple Silk Shirt
	Set(Casts, 18363, 18363) -- Riding Kodo
	Set(Casts, 30174, 30174) -- Riding Turtle
	Set(Casts,  9614,  9614) -- Rift Beacon
	Set(Casts,   461,   461) -- Righteous Flame On
	Set(Casts, 27738, 27738) -- Right Piece of Lord Valthalak's Amulet
	Set(Casts, 18540, 18540) -- Ritual of Doom
	Set(Casts, 18541, 18541) -- Ritual of Doom Effect
	Set(Casts,   698,   698) -- Ritual of Summoning
	Set(Casts,  7720,  7720) -- Ritual of Summoning Effect
	Set(Casts,  2540,  2540) -- Roasted Boar Meat
	Set(Casts,  6414,  6414) -- Roasted Kodo Meat
	Set(Casts, 15855, 15855) -- Roast Raptor
	Set(Casts,  8770,  8770) -- Robe of Power
	Set(Casts, 18457, 18457) -- Robe of the Archmage
	Set(Casts, 18458, 18458) -- Robe of the Void
	Set(Casts, 18436, 18436) -- Robe of Winter Night
	Set(Casts,  6692,  6692) -- Robes of Arcana
	Set(Casts,  1940,  1940) -- Rocket Blast
	Set(Casts,  7828,  7828) -- Rockscale Cod
	Set(Casts, 15750, 15750) -- Rookery Whelp Spawn-in Spell
	Set(Casts, 12618, 12618) -- Rose Colored Goggles
	Set(Casts, 26137, 26137) -- Rotate Trigger
	Set(Casts,  3918,  3918) -- Rough Blasting Powder
	Set(Casts,  3925,  3925) -- Rough Boomstick
	Set(Casts,  7817,  7817) -- Rough Bronze Boots
	Set(Casts,  2671,  2671) -- Rough Bronze Bracers
	Set(Casts,  2670,  2670) -- Rough Bronze Cuirass
	Set(Casts,  2668,  2668) -- Rough Bronze Leggings
	Set(Casts,  3328,  3328) -- Rough Bronze Shoulders
	Set(Casts,  4064,  4064) -- Rough Copper Bomb
	Set(Casts, 12260, 12260) -- Rough Copper Vest
	Set(Casts,  3919,  3919) -- Rough Dynamite
	Set(Casts,  3320,  3320) -- Rough Grinding Stone
	Set(Casts,  2660,  2660) -- Rough Sharpening Stone
	Set(Casts,  3115,  3115) -- Rough Weightstone
	Set(Casts, 19058, 19058) -- Rugged Armor Kit
	Set(Casts, 22331, 22331) -- Rugged Leather
	Set(Casts,  9064,  9064) -- Rugged Leather Pants
	Set(Casts, 20875, 20875) -- Rumsey Rum
	Set(Casts, 25804, 25804) -- Rumsey Rum Black Label
	Set(Casts, 25722, 25722) -- Rumsey Rum Dark
	Set(Casts, 25037, 25037) -- Rumsey Rum Light
	Set(Casts, 18405, 18405) -- Runecloth Bag
	Set(Casts, 18629, 18629) -- Runecloth Bandage
	Set(Casts, 18402, 18402) -- Runecloth Belt
	Set(Casts, 18423, 18423) -- Runecloth Boots
	Set(Casts, 18409, 18409) -- Runecloth Cloak
	Set(Casts, 18417, 18417) -- Runecloth Gloves
	Set(Casts, 18444, 18444) -- Runecloth Headband
	Set(Casts, 18438, 18438) -- Runecloth Pants
	Set(Casts, 18406, 18406) -- Runecloth Robe
	Set(Casts, 18449, 18449) -- Runecloth Shoulders
	Set(Casts, 18407, 18407) -- Runecloth Tunic
	Set(Casts, 20051, 20051) -- Runed Arcanite Rod
	Set(Casts,  2666,  2666) -- Runed Copper Belt
	Set(Casts,  2664,  2664) -- Runed Copper Bracers
	Set(Casts,  2667,  2667) -- Runed Copper Breastplate
	Set(Casts,  3323,  3323) -- Runed Copper Gauntlets
	Set(Casts,  3324,  3324) -- Runed Copper Pants
	Set(Casts,  7421,  7421) -- Runed Copper Rod
	Set(Casts, 13628, 13628) -- Runed Golden Rod
	Set(Casts, 10009, 10009) -- Runed Mithril Hammer
	Set(Casts,  7795,  7795) -- Runed Silver Rod
	Set(Casts, 24902, 24902) -- Runed Stygian Belt
	Set(Casts, 24903, 24903) -- Runed Stygian Boots
	Set(Casts, 24901, 24901) -- Runed Stygian Leggings
	Set(Casts, 13702, 13702) -- Runed Truesilver Rod
	Set(Casts, 16980, 16980) -- Rune Edge
	Set(Casts,  3407,  3407) -- Rune of Opening
	Set(Casts, 16731, 16731) -- Runic Breastplate
	Set(Casts, 19102, 19102) -- Runic Leather Armor
	Set(Casts, 19072, 19072) -- Runic Leather Belt
	Set(Casts, 19065, 19065) -- Runic Leather Bracers
	Set(Casts, 19055, 19055) -- Runic Leather Gauntlets
	Set(Casts, 19082, 19082) -- Runic Leather Headband
	Set(Casts, 19091, 19091) -- Runic Leather Pants
	Set(Casts, 19103, 19103) -- Runic Leather Shoulders
	Set(Casts, 16665, 16665) -- Runic Plate Boots
	Set(Casts, 16726, 16726) -- Runic Plate Helm
	Set(Casts, 16732, 16732) -- Runic Plate Leggings
	Set(Casts, 16664, 16664) -- Runic Plate Shoulders
	Set(Casts, 22761, 22761) -- Runn Tum Tuber Surprise
	Set(Casts, 21403, 21403) -- Ryson's All Seeing Eye
	Set(Casts, 21425, 21425) -- Ryson's Eye in the Sky
	Set(Casts,  1050,  1050) -- Sacrifice
	Set(Casts,  1916,  1916) -- Sacrifice (NSE)
	Set(Casts, 10459, 10459) -- Sacrifice Spinneret
	Set(Casts, 27832, 27832) -- Sageblade
	Set(Casts, 25954, 25954) -- Sagefish Delight
	Set(Casts, 19566, 19566) -- Salt Shaker
	Set(Casts, 26102, 26102) -- Sand Blast
	Set(Casts, 20716, 20716) -- Sand Breath
	Set(Casts, 24849, 24849) -- Sandstalker Bracers
	Set(Casts, 24851, 24851) -- Sandstalker Breastplate
	Set(Casts, 24850, 24850) -- Sandstalker Gauntlets
	Set(Casts,  3204,  3204) -- Sapper Explode
	Set(Casts,  6490,  6490) -- Sarilus's Elementals
	Set(Casts, 27725, 27725) -- Satchel of Cenarius
	Set(Casts, 28161, 28161) -- Savage Guard
	Set(Casts,  8238,  8238) -- Savory Deviate Delight
	Set(Casts, 14327, 14327) -- Scare Beast
	Set(Casts,  9232,  9232) -- Scarlet Resurrection
	Set(Casts, 15125, 15125) -- Scarshield Portal
	Set(Casts, 10207, 10207) -- Scorch
	Set(Casts, 11761, 11761) -- Scorpid Sample
	Set(Casts,  6413,  6413) -- Scorpid Surprise
	Set(Casts, 13630, 13630) -- Scraping
	Set(Casts,  7960,  7960) -- Scry on Azrethoc
	Set(Casts, 22949, 22949) -- Seal Felvine Shard
	Set(Casts,  9552,  9552) -- Searing Flames
	Set(Casts, 15973, 15973) -- Searing Golden Blade
	Set(Casts, 17923, 17923) -- Searing Pain
	Set(Casts,  2549,  2549) -- Seasoned Wolf Kabob
	Set(Casts,  6358,  6358) -- Seduction
	Set(Casts, 17196, 17196) -- Seeping Willow
	Set(Casts,  5407,  5407) -- Segra Darkthorn Effect
	Set(Casts,  9879,  9879) -- Self Destruct
	Set(Casts,  9575,  9575) -- Self Detonation
	Set(Casts, 18976, 18976) -- Self Resurrection
	Set(Casts, 16983, 16983) -- Serenity
	Set(Casts,  6270,  6270) -- Serpentine Cleansing
	Set(Casts,  6626,  6626) -- Set NG-5 Charge (Blue)
	Set(Casts,  6630,  6630) -- Set NG-5 Charge (Red)
	Set(Casts, 10955, 10955) -- Shackle Undead
	Set(Casts, 22681, 22681) -- Shadowblink
	Set(Casts, 11661, 11661) -- Shadow Bolt
	Set(Casts, 14871, 14871) -- Shadow Bolt Misfire
	Set(Casts, 14887, 14887) -- Shadow Bolt Volley
	Set(Casts,  3500,  3500) -- Shadow Crescent Axe
	Set(Casts, 12082, 12082) -- Shadoweave Boots
	Set(Casts, 12071, 12071) -- Shadoweave Gloves
	Set(Casts, 12086, 12086) -- Shadoweave Mask
	Set(Casts, 12052, 12052) -- Shadoweave Pants
	Set(Casts, 12055, 12055) -- Shadoweave Robe
	Set(Casts, 12076, 12076) -- Shadoweave Shoulders
	Set(Casts, 22979, 22979) -- Shadow Flame
	Set(Casts,  3940,  3940) -- Shadow Goggles
	Set(Casts, 28165, 28165) -- Shadow Guard
	Set(Casts,  3858,  3858) -- Shadow Hood
	Set(Casts, 22596, 22596) -- Shadow Mantle of the Dawn
	Set(Casts,  1112,  1112) -- Shadow Nova II
	Set(Casts,  3449,  3449) -- Shadow Oil
	Set(Casts,  7136,  7136) -- Shadow Port
	Set(Casts, 17950, 17950) -- Shadow Portal
	Set(Casts,  7256,  7256) -- Shadow Protection Potion
	Set(Casts,  9657,  9657) -- Shadow Shell
	Set(Casts, 22711, 22711) -- Shadowskin Gloves
	Set(Casts, 25183, 25183) -- Shadow Weakness
	Set(Casts,  7761,  7761) -- Shared Bonds
	Set(Casts,  2828,  2828) -- Sharpen Blade
	Set(Casts,  2829,  2829) -- Sharpen Blade II
	Set(Casts,  2830,  2830) -- Sharpen Blade III
	Set(Casts,  9900,  9900) -- Sharpen Blade IV
	Set(Casts, 16138, 16138) -- Sharpen Blade V
	Set(Casts, 22756, 22756) -- Sharpen Weapon - Critical
	Set(Casts, 11402, 11402) -- Shay's Bell
	Set(Casts,  3651,  3651) -- Shield of Reflection
	Set(Casts, 22928, 22928) -- Shifting Cloak
	Set(Casts,  2675,  2675) -- Shining Silver Breastplate
	Set(Casts,  8087,  8087) -- Shiny Bauble
	Set(Casts, 28099, 28099) -- Shock
	Set(Casts,  1698,  1698) -- Shockwave
	Set(Casts,  2480,  2480) -- Shoot Bow
	Set(Casts,  7919,  7919) -- Shoot Crossbow
	Set(Casts,  7918,  7918) -- Shoot Gun
	Set(Casts, 25031, 25031) -- Shoot Missile
	Set(Casts, 25030, 25030) -- Shoot Rocket
	Set(Casts, 21559, 21559) -- Shredder Armor Melt
	Set(Casts, 10096, 10096) -- Shrink
	Set(Casts, 14227, 14227) -- Signing
	Set(Casts, 26069, 26069) -- Silence
	Set(Casts,  8137,  8137) -- Silithid Pox
	Set(Casts,  7928,  7928) -- Silk Bandage
	Set(Casts,  8762,  8762) -- Silk Headband
	Set(Casts,  3973,  3973) -- Silver Contact
	Set(Casts,  3331,  3331) -- Silvered Bronze Boots
	Set(Casts,  2673,  2673) -- Silvered Bronze Breastplate
	Set(Casts,  3333,  3333) -- Silvered Bronze Gauntlets
	Set(Casts, 12259, 12259) -- Silvered Bronze Leggings
	Set(Casts,  3330,  3330) -- Silvered Bronze Shoulders
	Set(Casts,  3949,  3949) -- Silver-plated Shotgun
	Set(Casts,  7818,  7818) -- Silver Rod
	Set(Casts, 19666, 19666) -- Silver Skeleton Key
	Set(Casts, 12077, 12077) -- Simple Black Dress
	Set(Casts,  8465,  8465) -- Simple Dress
	Set(Casts, 12046, 12046) -- Simple Kilt
	Set(Casts, 12045, 12045) -- Simple Linen Boots
	Set(Casts, 12044, 12044) -- Simple Linen Pants
	Set(Casts,  7077,  7077) -- Simple Teleport
	Set(Casts,  7078,  7078) -- Simple Teleport Group
	Set(Casts,  7079,  7079) -- Simple Teleport Other
	Set(Casts,  8980,  8980) -- Skeletal Horse
	Set(Casts,  6469,  6469) -- Skeletal Miner Explode
	Set(Casts, 29059, 29059) -- Skeletal Steed
	Set(Casts,  8617,  8617) -- Skinning
	Set(Casts, 11605, 11605) -- Slam
	Set(Casts,  8809,  8809) -- Slave Drain
	Set(Casts,  1090,  1090) -- Sleep
	Set(Casts, 28311, 28311) -- Slime Bolt
	Set(Casts,  6530,  6530) -- Sling Dirt
	Set(Casts,  3650,  3650) -- Sling Mud
	Set(Casts,  7752,  7752) -- Slitherskin Mackerel
	Set(Casts,  7992,  7992) -- Slowing Poison
	Set(Casts,  3332,  3332) -- Slow Poison
	Set(Casts,  1056,  1056) -- Slow Poison II
	Set(Casts,  6814,  6814) -- Sludge Toxin
	Set(Casts, 26416, 26416) -- Small Blue Rocket
	Set(Casts,  4066,  4066) -- Small Bronze Bomb
	Set(Casts, 26417, 26417) -- Small Green Rocket
	Set(Casts,  9062,  9062) -- Small Leather Ammo Pouch
	Set(Casts, 26418, 26418) -- Small Red Rocket
	Set(Casts,  3933,  3933) -- Small Seaforium Charge
	Set(Casts,  3813,  3813) -- Small Silk Pack
	Set(Casts,  2659,  2659) -- Smelt Bronze
	Set(Casts,  2657,  2657) -- Smelt Copper
	Set(Casts, 14891, 14891) -- Smelt Dark Iron
	Set(Casts, 22967, 22967) -- Smelt Elementium
	Set(Casts,  3308,  3308) -- Smelt Gold
	Set(Casts,  3307,  3307) -- Smelt Iron
	Set(Casts, 10097, 10097) -- Smelt Mithril
	Set(Casts,  2658,  2658) -- Smelt Silver
	Set(Casts,  3569,  3569) -- Smelt Steel
	Set(Casts, 16153, 16153) -- Smelt Thorium
	Set(Casts,  3304,  3304) -- Smelt Tin
	Set(Casts, 10098, 10098) -- Smelt Truesilver
	Set(Casts, 10934, 10934) -- Smite
	Set(Casts, 27572, 27572) -- Smitten
	Set(Casts,  8607,  8607) -- Smoked Bear Meat
	Set(Casts, 24801, 24801) -- Smoked Desert Dumplings
	Set(Casts, 25704, 25704) -- Smoked Sagefish
	Set(Casts, 15596, 15596) -- Smoking Heart of the Mountain
	Set(Casts, 23507, 23507) -- Snake Burst Firework
	Set(Casts, 12460, 12460) -- Sniper Scope
	Set(Casts, 21848, 21848) -- Snowman
	Set(Casts, 21935, 21935) -- SnowMaster 9000
	Set(Casts,  8283,  8283) -- Snufflenose Command
	Set(Casts,  3845,  3845) -- Soft-soled Linen Boots
	Set(Casts,  3206,  3206) -- Sol H
	Set(Casts, 12585, 12585) -- Solid Blasting Powder
	Set(Casts, 12586, 12586) -- Solid Dynamite
	Set(Casts,  9920,  9920) -- Solid Grinding Stone
	Set(Casts,  3494,  3494) -- Solid Iron Maul
	Set(Casts,  9918,  9918) -- Solid Sharpening Stone
	Set(Casts,  9921,  9921) -- Solid Weightstone
	Set(Casts,  3120,  3120) -- Sol L
	Set(Casts,  3205,  3205) -- Sol M
	Set(Casts,  3207,  3207) -- Sol U
	Set(Casts,  9901,  9901) -- Soothe Animal
	Set(Casts,  3400,  3400) -- Soothing Turtle Bisque
	Set(Casts, 11016, 11016) -- Soul Bite
	Set(Casts, 17506, 17506) -- Soul Breaker
	Set(Casts, 17048, 17048) -- Soul Claim
	Set(Casts, 12667, 12667) -- Soul Consumption
	Set(Casts,  7295,  7295) -- Soul Drain
	Set(Casts, 17924, 17924) -- Soul Fire
	Set(Casts, 26085, 26085) -- Soul Pouch
	Set(Casts, 10771, 10771) -- Soul Shatter
	Set(Casts, 20762, 20762) -- Soulstone Resurrection
	Set(Casts,  6252,  6252) -- Southsea Cannon Fire
	Set(Casts,  5264,  5264) -- South Seas Pirate Disguise
	Set(Casts, 21027, 21027) -- Spark
	Set(Casts, 16447, 16447) -- Spawn Challenge to Urok
	Set(Casts,  3644,  3644) -- Speak with Heads
	Set(Casts,   110,   110) -- Spell Deflection (NYI)
	Set(Casts, 12615, 12615) -- Spellpower Goggles Xtreme
	Set(Casts, 19794, 19794) -- Spellpower Goggles Xtreme Plus
	Set(Casts, 15915, 15915) -- Spiced Chili Crab
	Set(Casts,  2539,  2539) -- Spiced Wolf Meat
	Set(Casts, 31364, 31364) -- Spice Mortar
	Set(Casts,  3863,  3863) -- Spider Belt
	Set(Casts, 21175, 21175) -- Spider Sausage
	Set(Casts,  3855,  3855) -- Spidersilk Boots
	Set(Casts,  3856,  3856) -- Spider Silk Slippers
	Set(Casts, 28615, 28615) -- Spike Volley
	Set(Casts,  8016,  8016) -- Spirit Decay
	Set(Casts, 17680, 17680) -- Spirit Spawn-out
	Set(Casts,  3477,  3477) -- Spirit Steal
	Set(Casts, 24846, 24846) -- Spitfire Bracers
	Set(Casts, 24848, 24848) -- Spitfire Breastplate
	Set(Casts, 24847, 24847) -- Spitfire Gauntlets
	Set(Casts, 10789, 10789) -- Spotted Frostsaber
	Set(Casts, 10792, 10792) -- Spotted Panther
	Set(Casts, 18238, 18238) -- Spotted Yellowtail
	Set(Casts, 17155, 17155) -- Sprinkling Purified Water
	Set(Casts,  3975,  3975) -- Standard Scope
	Set(Casts,  3864,  3864) -- Star Belt
	Set(Casts, 25298, 25298) -- Starfire
	Set(Casts, 28327, 28327) -- Steam Tonk Controller
	Set(Casts,  9916,  9916) -- Steel Breastplate
	Set(Casts, 15781, 15781) -- Steel Mechanostrider
	Set(Casts,  9935,  9935) -- Steel Plate Helm
	Set(Casts,  7224,  7224) -- Steel Weapon Chain
	Set(Casts, 15533, 15533) -- Stoned - Channel Cast Visual
	Set(Casts, 10254, 10254) -- Stone Dwarf Awaken Visual
	Set(Casts, 17551, 17551) -- Stonescale Oil
	Set(Casts, 28995, 28995) -- Stoneskin
	Set(Casts,  5265,  5265) -- Stonesplinter Trogg Disguise
	Set(Casts, 20685, 20685) -- Storm Bolt
	Set(Casts, 12090, 12090) -- Stormcloth Boots
	Set(Casts, 12063, 12063) -- Stormcloth Gloves
	Set(Casts, 12083, 12083) -- Stormcloth Headband
	Set(Casts, 12062, 12062) -- Stormcloth Pants
	Set(Casts, 12087, 12087) -- Stormcloth Shoulders
	Set(Casts, 12068, 12068) -- Stormcloth Vest
	Set(Casts, 16661, 16661) -- Storm Gauntlets
	Set(Casts, 23510, 23510) -- Stormpike Battle Charger
	Set(Casts, 19079, 19079) -- Stormshroud Armor
	Set(Casts, 26279, 26279) -- Stormshroud Gloves
	Set(Casts, 19067, 19067) -- Stormshroud Pants
	Set(Casts, 19090, 19090) -- Stormshroud Shoulders
	Set(Casts, 18163, 18163) -- Strength of Arko'narin
	Set(Casts,  4539,  4539) -- Strength of the Ages
	Set(Casts,  6416,  6416) -- Strider Stew
	Set(Casts, 26181, 26181) -- Strike
	Set(Casts, 24245, 24245) -- String Together Heads
	Set(Casts,  8394,  8394) -- Striped Frostsaber
	Set(Casts, 10793, 10793) -- Striped Nightsaber
	Set(Casts,  7935,  7935) -- Strong Anti-Venom
	Set(Casts, 16741, 16741) -- Stronghold Gauntlets
	Set(Casts,  3176,  3176) -- Strong Troll's Blood Potion
	Set(Casts,  7355,  7355) -- Stuck
	Set(Casts, 16497, 16497) -- Stun Bomb
	Set(Casts, 21188, 21188) -- Stun Bomb Attack
	Set(Casts,  7892,  7892) -- Stylish Blue Shirt
	Set(Casts,  7893,  7893) -- Stylish Green Shirt
	Set(Casts,  3866,  3866) -- Stylish Red Shirt
	Set(Casts, 26234, 26234) -- Submerge Visual
	Set(Casts,  2548,  2548) -- Succulent Pork Ribs
	Set(Casts, 21161, 21161) -- Sulfuron Hammer
	Set(Casts, 15734, 15734) -- Summon
	Set(Casts, 23004, 23004) -- Summon Alarm-o-Bot
	Set(Casts, 10713, 10713) -- Summon Albino Snake
	Set(Casts, 23428, 23428) -- Summon Albino Snapjaw
	Set(Casts, 15033, 15033) -- Summon Ancient Spirits
	Set(Casts, 10685, 10685) -- Summon Ancona
	Set(Casts, 13978, 13978) -- Summon Aquementas
	Set(Casts, 22567, 22567) -- Summon Ar'lia
	Set(Casts, 12151, 12151) -- Summon Atal'ai Skeleton
	Set(Casts, 10696, 10696) -- Summon Azure Whelpling
	Set(Casts, 25849, 25849) -- Summon Baby Shark
	Set(Casts, 15794, 15794) -- Summon Blackhand Dreadweaver
	Set(Casts, 15792, 15792) -- Summon Blackhand Veteran
	Set(Casts, 10714, 10714) -- Summon Black Kingsnake
	Set(Casts, 26656, 26656) -- Summon Black Qiraji Battle Tank
	Set(Casts, 17567, 17567) -- Summon Blood Parrot
	Set(Casts, 13463, 13463) -- Summon Bloodpetal Mini Pests
	Set(Casts, 25953, 25953) -- Summon Blue Qiraji Battle Tank
	Set(Casts, 10715, 10715) -- Summon Blue Racer
	Set(Casts,  8286,  8286) -- Summon Boar Spirit
	Set(Casts, 15048, 15048) -- Summon Bomb
	Set(Casts, 10673, 10673) -- Summon Bombay
	Set(Casts, 10699, 10699) -- Summon Bronze Whelpling
	Set(Casts, 10716, 10716) -- Summon Brown Snake
	Set(Casts, 17169, 17169) -- Summon Carrion Scarab
	Set(Casts, 23214, 23214) -- Summon Charger
	Set(Casts, 10680, 10680) -- Summon Cockatiel
	Set(Casts, 10681, 10681) -- Summon Cockatoo
	Set(Casts, 10688, 10688) -- Summon Cockroach
	Set(Casts, 15647, 15647) -- Summon Common Kitten
	Set(Casts, 10674, 10674) -- Summon Cornish Rex
	Set(Casts, 15648, 15648) -- Summon Corrupted Kitten
	Set(Casts, 10710, 10710) -- Summon Cottontail Rabbit
	Set(Casts, 10717, 10717) -- Summon Crimson Snake
	Set(Casts, 10697, 10697) -- Summon Crimson Whelpling
	Set(Casts,  8606,  8606) -- Summon Cyclonian
	Set(Casts,  4945,  4945) -- Summon Dagun
	Set(Casts, 10695, 10695) -- Summon Dark Whelpling
	Set(Casts, 10701, 10701) -- Summon Dart Frog
	Set(Casts,  9097,  9097) -- Summon Demon of the Orb
	Set(Casts, 17708, 17708) -- Summon Diablo
	Set(Casts, 25162, 25162) -- Summon Disgusting Oozeling
	Set(Casts, 23161, 23161) -- Summon Dreadsteed
	Set(Casts, 10705, 10705) -- Summon Eagle Owl
	Set(Casts, 12189, 12189) -- Summon Echeyakee
	Set(Casts, 11840, 11840) -- Summon Edana Hatetalon
	Set(Casts, 16473, 16473) -- Summoned Urok
	Set(Casts,  8677,  8677) -- Summon Effect
	Set(Casts, 10721, 10721) -- Summon Elven Wisp
	Set(Casts, 10869, 10869) -- Summon Embers
	Set(Casts, 10698, 10698) -- Summon Emerald Whelpling
	Set(Casts, 10700, 10700) -- Summon Faeling
	Set(Casts, 13548, 13548) -- Summon Farm Chicken
	Set(Casts,   691,   691) -- Summon Felhunter
	Set(Casts,  5784,  5784) -- Summon Felsteed
	Set(Casts, 16531, 16531) -- Summon Frail Skeleton
	Set(Casts, 19561, 19561) -- Summon Gnashjaw
	Set(Casts, 13258, 13258) -- Summon Goblin Bomb
	Set(Casts, 10707, 10707) -- Summon Great Horned Owl
	Set(Casts, 26056, 26056) -- Summon Green Qiraji Battle Tank
	Set(Casts, 10718, 10718) -- Summon Green Water Snake
	Set(Casts, 10683, 10683) -- Summon Green Wing Macaw
	Set(Casts,  7762,  7762) -- Summon Gunther's Visage
	Set(Casts, 27241, 27241) -- Summon Gurky
	Set(Casts, 10706, 10706) -- Summon Hawk Owl
	Set(Casts, 23432, 23432) -- Summon Hawksbill Snapjaw
	Set(Casts,  4950,  4950) -- Summon Helcular's Puppets
	Set(Casts, 30156, 30156) -- Summon Hippogryph Hatchling
	Set(Casts, 10682, 10682) -- Summon Hyacinth Macaw
	Set(Casts, 15114, 15114) -- Summon Illusionary Dreamwatchers
	Set(Casts,  6905,  6905) -- Summon Illusionary Nightmare
	Set(Casts,  8986,  8986) -- Summon Illusionary Phantasm
	Set(Casts, 17231, 17231) -- Summon Illusory Wraith
	Set(Casts,   688,   688) -- Summon Imp
	Set(Casts, 12740, 12740) -- Summon Infernal Servant
	Set(Casts, 12199, 12199) -- Summon Ishamuhale
	Set(Casts, 10702, 10702) -- Summon Island Frog
	Set(Casts, 23811, 23811) -- Summon Jubling
	Set(Casts, 20737, 20737) -- Summon Karang's Banner
	Set(Casts, 23431, 23431) -- Summon Leatherback Snapjaw
	Set(Casts, 19772, 19772) -- Summon Lifelike Toad
	Set(Casts,  5110,  5110) -- Summon Living Flame
	Set(Casts, 23429, 23429) -- Summon Loggerhead Snapjaw
	Set(Casts, 20693, 20693) -- Summon Lost Amulet
	Set(Casts, 18974, 18974) -- Summon Lunaclaw
	Set(Casts,  7132,  7132) -- Summon Lupine Delusions
	Set(Casts, 27291, 27291) -- Summon Magic Staff
	Set(Casts, 18166, 18166) -- Summon Magram Ravager
	Set(Casts, 10675, 10675) -- Summon Maine Coon
	Set(Casts, 12243, 12243) -- Summon Mechanical Chicken
	Set(Casts, 18476, 18476) -- Summon Minion
	Set(Casts, 28739, 28739) -- Summon Mr. Wiggles
	Set(Casts, 25018, 25018) -- Summon Murki
	Set(Casts, 24696, 24696) -- Summon Murky
	Set(Casts,  4141,  4141) -- Summon Myzrael
	Set(Casts, 22876, 22876) -- Summon Netherwalker
	Set(Casts, 23430, 23430) -- Summon Olive Snapjaw
	Set(Casts, 17646, 17646) -- Summon Onyxia Whelp
	Set(Casts, 10676, 10676) -- Summon Orange Tabby
	Set(Casts, 23012, 23012) -- Summon Orphan
	Set(Casts, 17707, 17707) -- Summon Panda
	Set(Casts, 28505, 28505) -- Summon Poley
	Set(Casts, 10686, 10686) -- Summon Prairie Chicken
	Set(Casts, 10709, 10709) -- Summon Prairie Dog
	Set(Casts, 19774, 19774) -- Summon Ragnaros
	Set(Casts, 13143, 13143) -- Summon Razelikh
	Set(Casts, 26054, 26054) -- Summon Red Qiraji Battle Tank
	Set(Casts,  3605,  3605) -- Summon Remote-Controlled Golem
	Set(Casts, 10719, 10719) -- Summon Ribbon Snake
	Set(Casts,  3363,  3363) -- Summon Riding Gryphon
	Set(Casts, 17618, 17618) -- Summon Risen Lackey
	Set(Casts, 15049, 15049) -- Summon Robot
	Set(Casts, 16381, 16381) -- Summon Rockwing Gargoyles
	Set(Casts, 15745, 15745) -- Summon Rookery Whelp
	Set(Casts, 10720, 10720) -- Summon Scarlet Snake
	Set(Casts, 12699, 12699) -- Summon Screecher Spirit
	Set(Casts, 10684, 10684) -- Summon Senegal
	Set(Casts, 12258, 12258) -- Summon Shadowcaster
	Set(Casts, 21181, 21181) -- Summon Shadowstrike
	Set(Casts,  3655,  3655) -- Summon Shield Guard
	Set(Casts, 16796, 16796) -- Summon Shy-Rotam
	Set(Casts, 10677, 10677) -- Summon Siamese
	Set(Casts, 10678, 10678) -- Summon Silver Tabby
	Set(Casts, 17204, 17204) -- Summon Skeleton
	Set(Casts, 11209, 11209) -- Summon Smithing Hammer
	Set(Casts, 16450, 16450) -- Summon Smolderweb
	Set(Casts, 10711, 10711) -- Summon Snowshoe Rabbit
	Set(Casts, 10708, 10708) -- Summon Snowy Owl
	Set(Casts,  6918,  6918) -- Summon Snufflenose
	Set(Casts, 13895, 13895) -- Summon Spawn of Bael'Gar
	Set(Casts, 28738, 28738) -- Summon Speedy
	Set(Casts,  3657,  3657) -- Summon Spell Guard
	Set(Casts, 11548, 11548) -- Summon Spider God
	Set(Casts, 10712, 10712) -- Summon Spotted Rabbit
	Set(Casts, 15067, 15067) -- Summon Sprite Darter Hatchling
	Set(Casts,   712,   712) -- Summon Succubus
	Set(Casts,  9461,  9461) -- Summon Swamp Ooze
	Set(Casts,  9636,  9636) -- Summon Swamp Spirit
	Set(Casts,  3722,  3722) -- Summon Syndicate Spectre
	Set(Casts, 28487, 28487) -- Summon Terky
	Set(Casts,  7076,  7076) -- Summon Tervosh's Minion
	Set(Casts,  3658,  3658) -- Summon Theurgist
	Set(Casts, 21180, 21180) -- Summon Thunderstrike
	Set(Casts,  5666,  5666) -- Summon Timberling
	Set(Casts, 23531, 23531) -- Summon Tiny Green Dragon
	Set(Casts, 23530, 23530) -- Summon Tiny Red Dragon
	Set(Casts, 26010, 26010) -- Summon Tranquil Mechanical Yeti
	Set(Casts, 20702, 20702) -- Summon Treant Allies
	Set(Casts, 12554, 12554) -- Summon Treasure Horde
	Set(Casts, 12564, 12564) -- Summon Treasure Horde Visual
	Set(Casts, 10704, 10704) -- Summon Tree Frog
	Set(Casts,  7949,  7949) -- Summon Viper
	Set(Casts,   697,   697) -- Summon Voidwalker
	Set(Casts, 13819, 13819) -- Summon Warhorse
	Set(Casts, 17162, 17162) -- Summon Water Elemental
	Set(Casts, 28740, 28740) -- Summon Whiskers
	Set(Casts, 10679, 10679) -- Summon White Kitten
	Set(Casts, 10687, 10687) -- Summon White Plymouth Rock
	Set(Casts, 30152, 30152) -- Summon White Tiger Cub
	Set(Casts, 11017, 11017) -- Summon Witherbark Felhunter
	Set(Casts, 10703, 10703) -- Summon Wood Frog
	Set(Casts, 15999, 15999) -- Summon Worg Pup
	Set(Casts, 23152, 23152) -- Summon Xorothian Dreadsteed
	Set(Casts, 26055, 26055) -- Summon Yellow Qiraji Battle Tank
	Set(Casts, 17709, 17709) -- Summon Zergling
	Set(Casts, 16590, 16590) -- Summon Zombie
	Set(Casts, 25186, 25186) -- Super Crystal
	Set(Casts, 11457, 11457) -- Superior Healing Potion
	Set(Casts, 15869, 15869) -- Superior Healing Ward
	Set(Casts, 17553, 17553) -- Superior Mana Potion
	Set(Casts, 26103, 26103) -- Sweep
	Set(Casts, 27722, 27722) -- Sweet Surprise
	Set(Casts, 23241, 23241) -- Swift Blue Raptor
	Set(Casts,  9208,  9208) -- Swift Boots
	Set(Casts, 23238, 23238) -- Swift Brown Ram
	Set(Casts, 23229, 23229) -- Swift Brown Steed
	Set(Casts, 23250, 23250) -- Swift Brown Wolf
	Set(Casts, 23220, 23220) -- Swift Dawnsaber
	Set(Casts, 22923, 22923) -- Swift Flight Bracers
	Set(Casts, 23221, 23221) -- Swift Frostsaber
	Set(Casts, 23239, 23239) -- Swift Gray Ram
	Set(Casts, 23252, 23252) -- Swift Gray Wolf
	Set(Casts, 23225, 23225) -- Swift Green Mechanostrider
	Set(Casts, 23219, 23219) -- Swift Mistsaber
	Set(Casts,  2335,  2335) -- Swiftness Potion
	Set(Casts, 23242, 23242) -- Swift Olive Raptor
	Set(Casts, 23243, 23243) -- Swift Orange Raptor
	Set(Casts, 23227, 23227) -- Swift Palomino
	Set(Casts, 24242, 24242) -- Swift Razzashi Raptor
	Set(Casts, 23338, 23338) -- Swift Stormsaber
	Set(Casts, 23251, 23251) -- Swift Timber Wolf
	Set(Casts, 23223, 23223) -- Swift White Mechanostrider
	Set(Casts, 23240, 23240) -- Swift White Ram
	Set(Casts, 23228, 23228) -- Swift White Steed
	Set(Casts, 23222, 23222) -- Swift Yellow Mechanostrider
	Set(Casts, 24252, 24252) -- Swift Zulian Tiger
	Set(Casts,  7841,  7841) -- Swim Speed Potion
	Set(Casts, 28481, 28481) -- Sylvan Crown
	Set(Casts, 28482, 28482) -- Sylvan Shoulders
	Set(Casts, 28480, 28480) -- Sylvan Vest
	Set(Casts,  8593,  8593) -- Symbol of Life
	Set(Casts, 24160, 24160) -- Syncretist's Sigil
	Set(Casts,  3718,  3718) -- Syndicate Bomb
	Set(Casts,  5266,  5266) -- Syndicate Disguise
	Set(Casts, 18969, 18969) -- Taelan Death
	Set(Casts, 17161, 17161) -- Taking Moon Well Sample
	Set(Casts,  9795,  9795) -- Talvash's Necklace Repair
	Set(Casts, 20041, 20041) -- Tammra Sapling
	Set(Casts,  3932,  3932) -- Target Dummy
	Set(Casts,  3399,  3399) -- Tasty Lion Steak
	Set(Casts, 16059, 16059) -- Tawny Sabercat
	Set(Casts,  2817,  2817) -- Teach Bark of Doom
	Set(Casts, 18992, 18992) -- Teal Kodo
	Set(Casts,  7791,  7791) -- Teleport
	Set(Casts,  3721,  3721) -- Teleport Altar of the Tides
	Set(Casts,  1936,  1936) -- Teleport Anvilmar
	Set(Casts,   443,   443) -- Teleport Barracks
	Set(Casts,   446,   446) -- Teleport Cemetary
	Set(Casts,   445,   445) -- Teleport Darkshire
	Set(Casts,  3565,  3565) -- Teleport: Darnassus
	Set(Casts,    34,    34) -- Teleport Duskwood
	Set(Casts,    35,    35) -- Teleport Elwynn
	Set(Casts, 12521, 12521) -- Teleport from Azshara Tower
	Set(Casts,    31,    31) -- Teleport Goldshire
	Set(Casts,  3562,  3562) -- Teleport: Ironforge
	Set(Casts,   444,   444) -- Teleport Lighthouse
	Set(Casts,   427,   427) -- Teleport Monastery
	Set(Casts,   428,   428) -- Teleport Moonbrook
	Set(Casts, 18960, 18960) -- Teleport: Moonglade
	Set(Casts,   442,   442) -- Teleport Northshire Abbey
	Set(Casts,  3567,  3567) -- Teleport: Orgrimmar
	Set(Casts,  3561,  3561) -- Teleport: Stormwind
	Set(Casts,  3566,  3566) -- Teleport: Thunder Bluff
	Set(Casts, 12509, 12509) -- Teleport to Azshara Tower
	Set(Casts,  9268,  9268) -- Teleport to Darnassus - Event
	Set(Casts,   447,   447) -- Teleport Treant
	Set(Casts,  3563,  3563) -- Teleport: Undercity
	Set(Casts,    33,    33) -- Teleport Westfall
	Set(Casts,  6755,  6755) -- Tell Joke
	Set(Casts, 16378, 16378) -- Temperature Reading
	Set(Casts, 22480, 22480) -- Tender Wolf Steak
	Set(Casts,  9456,  9456) -- Tharnariun Cure 1
	Set(Casts,  9457,  9457) -- Tharnariun's Heal
	Set(Casts, 12562, 12562) -- The Big One
	Set(Casts, 22989, 22989) -- The Breaking
	Set(Casts, 21953, 21953) -- The Feast of Winter Veil
	Set(Casts, 22990, 22990) -- The Forming
	Set(Casts, 13240, 13240) -- The Mortar: Reloaded
	Set(Casts, 10003, 10003) -- The Shatterer
	Set(Casts, 10487, 10487) -- Thick Armor Kit
	Set(Casts, 20650, 20650) -- Thick Leather
	Set(Casts, 14932, 14932) -- Thick Leather Ammo Pouch
	Set(Casts,  6704,  6704) -- Thick Murloc Armor
	Set(Casts, 27587, 27587) -- Thick Obsidian Breastplate
	Set(Casts,  3294,  3294) -- Thick War Axe
	Set(Casts,  9513,  9513) -- Thistle Tea
	Set(Casts, 16642, 16642) -- Thorium Armor
	Set(Casts, 16643, 16643) -- Thorium Belt
	Set(Casts, 16652, 16652) -- Thorium Boots
	Set(Casts, 16644, 16644) -- Thorium Bracers
	Set(Casts, 16960, 16960) -- Thorium Greatsword
	Set(Casts, 19790, 19790) -- Thorium Grenade
	Set(Casts, 16653, 16653) -- Thorium Helm
	Set(Casts, 16662, 16662) -- Thorium Leggings
	Set(Casts, 19792, 19792) -- Thorium Rifle
	Set(Casts, 19800, 19800) -- Thorium Shells
	Set(Casts, 16651, 16651) -- Thorium Shield Spike
	Set(Casts, 19795, 19795) -- Thorium Tube
	Set(Casts, 19791, 19791) -- Thorium Widget
	Set(Casts, 24649, 24649) -- Thousand Blades
	Set(Casts, 24314, 24314) -- Threatening Gaze
	Set(Casts,  5781,  5781) -- Threatening Growl
	Set(Casts, 16075, 16075) -- Throw Axe
	Set(Casts, 27662, 27662) -- Throw Cupid's Dart
	Set(Casts, 14814, 14814) -- Throw Dark Iron Ale
	Set(Casts,  7978,  7978) -- Throw Dynamite
	Set(Casts, 25004, 25004) -- Throw Nightmare Object
	Set(Casts,  4164,  4164) -- Throw Rock
	Set(Casts,  4165,  4165) -- Throw Rock II
	Set(Casts, 10790, 10790) -- Tiger
	Set(Casts, 23704, 23704) -- Timbermaw Brawlers
	Set(Casts, 23312, 23312) -- Time Lapse
	Set(Casts, 25158, 25158) -- Time Stop
	Set(Casts,  6470,  6470) -- Tiny Bronze Key
	Set(Casts,  6471,  6471) -- Tiny Iron Key
	Set(Casts, 27829, 27829) -- Titanic Leggings
	Set(Casts, 29334, 29334) -- Toasted Smorc
	Set(Casts, 29116, 29116) -- Toast Smorc
	Set(Casts, 27739, 27739) -- Top Piece of Lord Valthalak's Amulet
	Set(Casts, 12511, 12511) -- Torch Combine
	Set(Casts,  6257,  6257) -- Torch Toss
	Set(Casts, 28806, 28806) -- Toss Fuel on Bonfire
	Set(Casts, 24706, 24706) -- Toss Stink Bomb
	Set(Casts,  3108,  3108) -- Touch of Death
	Set(Casts,  3263,  3263) -- Touch of Ravenclaw
	Set(Casts,  2166,  2166) -- Toughened Leather Armor
	Set(Casts,  3770,  3770) -- Toughened Leather Gloves
	Set(Casts, 10554, 10554) -- Tough Scorpid Boots
	Set(Casts, 10533, 10533) -- Tough Scorpid Bracers
	Set(Casts, 10525, 10525) -- Tough Scorpid Breastplate
	Set(Casts, 10542, 10542) -- Tough Scorpid Gloves
	Set(Casts, 10570, 10570) -- Tough Scorpid Helm
	Set(Casts, 10568, 10568) -- Tough Scorpid Leggings
	Set(Casts, 10564, 10564) -- Tough Scorpid Shoulders
	Set(Casts, 16554, 16554) -- Toxic Bolt
	Set(Casts,  7125,  7125) -- Toxic Saliva
	Set(Casts,  7951,  7951) -- Toxic Spit
	Set(Casts, 19877, 19877) -- Tranquilizing Shot
	Set(Casts, 26011, 26011) -- Tranquil Mechanical Yeti
	Set(Casts,  7821,  7821) -- Transform Victim
	Set(Casts, 17559, 17559) -- Transmute: Air to Fire
	Set(Casts, 17187, 17187) -- Transmute: Arcanite
	Set(Casts, 17566, 17566) -- Transmute: Earth to Life
	Set(Casts, 17561, 17561) -- Transmute: Earth to Water
	Set(Casts, 25146, 25146) -- Transmute: Elemental Fire
	Set(Casts, 17560, 17560) -- Transmute: Fire to Earth
	Set(Casts, 11479, 11479) -- Transmute: Iron to Gold
	Set(Casts, 17565, 17565) -- Transmute: Life to Earth
	Set(Casts, 11480, 11480) -- Transmute: Mithril to Truesilver
	Set(Casts, 17563, 17563) -- Transmute: Undeath to Water
	Set(Casts, 17562, 17562) -- Transmute: Water to Air
	Set(Casts, 17564, 17564) -- Transmute: Water to Undeath
	Set(Casts,  4320,  4320) -- Trelane's Freezing Touch
	Set(Casts, 20804, 20804) -- Triage
	Set(Casts,  8782,  8782) -- Truefaith Gloves
	Set(Casts, 18456, 18456) -- Truefaith Vestments
	Set(Casts,   785,   785) -- True Fulfillment
	Set(Casts,  9974,  9974) -- Truesilver Breastplate
	Set(Casts, 10015, 10015) -- Truesilver Champion
	Set(Casts,  9954,  9954) -- Truesilver Gauntlets
	Set(Casts, 14380, 14380) -- Truesilver Rod
	Set(Casts, 19668, 19668) -- Truesilver Skeleton Key
	Set(Casts, 23071, 23071) -- Truesilver Transformer
	Set(Casts, 10348, 10348) -- Tune Up
	Set(Casts, 10326, 10326) -- Turn Undead
	Set(Casts, 10796, 10796) -- Turquoise Raptor
	Set(Casts, 10518, 10518) -- Turtle Scale Bracers
	Set(Casts, 10511, 10511) -- Turtle Scale Breastplate
	Set(Casts, 10509, 10509) -- Turtle Scale Gloves
	Set(Casts, 10552, 10552) -- Turtle Scale Helm
	Set(Casts, 10556, 10556) -- Turtle Scale Leggings
	Set(Casts, 12093, 12093) -- Tuxedo Jacket
	Set(Casts, 12089, 12089) -- Tuxedo Pants
	Set(Casts, 12085, 12085) -- Tuxedo Shirt
	Set(Casts, 10340, 10340) -- Uldaman Boss Agro
	Set(Casts,  9577,  9577) -- Uldaman Key Staff
	Set(Casts, 11568, 11568) -- Uldaman Sub-Boss Agro
	Set(Casts, 23082, 23082) -- Ultra-Flash Shadow Reflector
	Set(Casts, 23489, 23489) -- Ultrasafe Transporter - Gadgetzan
	Set(Casts, 20626, 20626) -- Undermine Clam Chowder
	Set(Casts, 20006, 20006) -- Unholy Curse
	Set(Casts, 10738, 10738) -- Unlocking
	Set(Casts,  3670,  3670) -- Unlock Maury's Foot
	Set(Casts, 17454, 17454) -- Unpainted Mechanostrider
	Set(Casts, 24024, 24024) -- Unstable Concoction
	Set(Casts, 12591, 12591) -- Unstable Trigger
	Set(Casts, 24263, 24263) -- UNUSED Quest - Create Empowered Mojo Bundle
	Set(Casts, 16562, 16562) -- Urok Minions Vanish
	Set(Casts, 19719, 19719) -- Use Bauble
	Set(Casts, 24194, 24194) -- Uther's Tribute
	Set(Casts,  7068,  7068) -- Veil of Shadow
	Set(Casts,  6354,  6354) -- Venom's Bane
	Set(Casts, 15664, 15664) -- Venom Spit
	Set(Casts, 27721, 27721) -- Very Berry Cream
	Set(Casts, 18115, 18115) -- Viewing Room Student Transform - Effect
	Set(Casts, 10799, 10799) -- Violet Raptor
	Set(Casts, 17529, 17529) -- Vitreous Focuser
	Set(Casts, 24163, 24163) -- Vodouisant's Vigilant Embrace
	Set(Casts, 19819, 19819) -- Voice Amplification Modulator
	Set(Casts, 21066, 21066) -- Void Bolt
	Set(Casts,  5252,  5252) -- Voidwalker Guardian
	Set(Casts, 18149, 18149) -- Volatile Infection
	Set(Casts, 19076, 19076) -- Volcanic Breastplate
	Set(Casts, 16984, 16984) -- Volcanic Hammer
	Set(Casts, 19059, 19059) -- Volcanic Leggings
	Set(Casts, 19101, 19101) -- Volcanic Shoulders
	Set(Casts,  1540,  1540) -- Volley
	Set(Casts,  3013,  3013) -- Volley II
	Set(Casts, 17009, 17009) -- Voodoo
	Set(Casts,  8277,  8277) -- Voodoo Hex
	Set(Casts, 17639, 17639) -- Wail of the Banshee
	Set(Casts,  3436,  3436) -- Wandering Plague
	Set(Casts, 19068, 19068) -- Warbear Harness
	Set(Casts, 19080, 19080) -- Warbear Woolies
	Set(Casts, 23678, 23678) -- Warlord Deck
	Set(Casts, 16801, 16801) -- Warosh's Transform
	Set(Casts, 20549, 20549) -- War Stomp
	Set(Casts,  7383,  7383) -- Water Bubble
	Set(Casts,  9583,  9583) -- Water Sample
	Set(Casts,  6949,  6949) -- Weak Frostbolt
	Set(Casts,  3170,  3170) -- Weak Troll's Blood Potion
	Set(Casts,  7220,  7220) -- Weapon Chain
	Set(Casts,  7218,  7218) -- Weapon Counterweight
	Set(Casts,  2543,  2543) -- Westfall Stew
	Set(Casts, 11410, 11410) -- Whirling Barrage
	Set(Casts,  3942,  3942) -- Whirring Bronze Gizmo
	Set(Casts, 12059, 12059) -- White Bandit Mask
	Set(Casts,  2163,  2163) -- White Leather Jerkin
	Set(Casts,  7624,  7624) -- White Linen Robe
	Set(Casts,  2393,  2393) -- White Linen Shirt
	Set(Casts, 15779, 15779) -- White Mechanostrider
	Set(Casts,  6898,  6898) -- White Ram
	Set(Casts, 16724, 16724) -- Whitesoul Helm
	Set(Casts,   468,   468) -- White Stallion
	Set(Casts,  8483,  8483) -- White Swashbuckler's Shirt
	Set(Casts, 12091, 12091) -- White Wedding Dress
	Set(Casts,  8467,  8467) -- White Woolen Dress
	Set(Casts, 19098, 19098) -- Wicked Leather Armor
	Set(Casts, 19092, 19092) -- Wicked Leather Belt
	Set(Casts, 19052, 19052) -- Wicked Leather Bracers
	Set(Casts, 19049, 19049) -- Wicked Leather Gauntlets
	Set(Casts, 19071, 19071) -- Wicked Leather Headband
	Set(Casts, 19083, 19083) -- Wicked Leather Pants
	Set(Casts,  9997,  9997) -- Wicked Mithril Blade
	Set(Casts,  4520,  4520) -- Wide Sweep
	Set(Casts, 28732, 28732) -- Widow's Embrace
	Set(Casts, 10566, 10566) -- Wild Leather Boots
	Set(Casts, 10574, 10574) -- Wild Leather Cloak
	Set(Casts, 10546, 10546) -- Wild Leather Helmet
	Set(Casts, 10572, 10572) -- Wild Leather Leggings
	Set(Casts, 10529, 10529) -- Wild Leather Shoulders
	Set(Casts, 10544, 10544) -- Wild Leather Vest
	Set(Casts,  9616,  9616) -- Wild Regeneration
	Set(Casts, 16650, 16650) -- Wildthorn Mail
	Set(Casts, 11458, 11458) -- Wildvine Potion
	Set(Casts, 16598, 16598) -- Will of Shahram
	Set(Casts, 23339, 23339) -- Wing Buffet
	Set(Casts, 21736, 21736) -- Winterax Wisdom
	Set(Casts, 17229, 17229) -- Winterspring Frostsaber
	Set(Casts,   581,   581) -- Winter Wolf
	Set(Casts, 23662, 23662) -- Wisdom of the Timbermaw
	Set(Casts, 22662, 22662) -- Wither
	Set(Casts,  4974,  4974) -- Wither Touch
	Set(Casts, 25121, 25121) -- Wizard Oil
	Set(Casts, 18421, 18421) -- Wizardweave Leggings
	Set(Casts, 18446, 18446) -- Wizardweave Robe
	Set(Casts, 18450, 18450) -- Wizardweave Turban
	Set(Casts, 10621, 10621) -- Wolfshead Helm
	Set(Casts,  3277,  3277) -- Wool Bandage
	Set(Casts,  3757,  3757) -- Woolen Bag
	Set(Casts,  2401,  2401) -- Woolen Boots
	Set(Casts,  2402,  2402) -- Woolen Cape
	Set(Casts,     1,     1) -- Word of Recall (OLD)
	Set(Casts, 28800, 28800) -- Word of Thawing
	Set(Casts, 23129, 23129) -- World Enlarger
	Set(Casts, 30732, 30732) -- Worm Sweep
	Set(Casts, 13227, 13227) -- Wound Poison
	Set(Casts, 13228, 13228) -- Wound Poison II
	Set(Casts, 13229, 13229) -- Wound Poison III
	Set(Casts, 13230, 13230) -- Wound Poison IV
	Set(Casts,  9912,  9912) -- Wrath
	Set(Casts,  3607,  3607) -- Yenniku's Release
	Set(Casts, 24422, 24422) -- Zandalar Signet of Might
	Set(Casts, 24421, 24421) -- Zandalar Signet of Mojo
	Set(Casts, 24420, 24420) -- Zandalar Signet of Serenity
end 

-- Channeled spells
-- CLEU doesn't return cast time for these, nor icon, 
-- so were adding the spellID to the data to retrieve the icon later on. 
do
	Set(Channeled,  5143, {  4.5,  5143 }) -- Arcane Missiles (Mage)
	Set(Channeled,    10, {  7.5,    10 }) -- Blizzard (Mage)
	Set(Channeled, 20577, { 10.0, 20577 }) -- Cannibalize
	Set(Channeled,   689, {  4.5,   689 }) -- Drain Life (Warlock)
	Set(Channeled,  5138, {  4.5,  5138 }) -- Drain Mana (Warlock)
	Set(Channeled,  1120, { 14.5,  1120 }) -- Drain Soul (Warlock)
	Set(Channeled,  6197, { 60.0,  6197 }) -- Eagle Eye (Hunter)
	Set(Channeled, 12051, {  8.0, 12051 }) -- Evocation (Mage)
	Set(Channeled,   126, { 45.0,   126 }) -- Eye of Kilrogg (Warlock)
	Set(Channeled,  1002, { 60.0,  1002 }) -- Eyes of the Beast (Hunter)
	Set(Channeled,   746, {  7.0,   746 }) -- First Aid
	Set(Channeled, 13278, {  4.0, 13278 }) -- Gnomish Death Ray
	Set(Channeled,   755, { 10.0,   755 }) -- Health Funnel (Warlock)
	Set(Channeled,  1949, { 15.0,  1949 }) -- Hellfire (Warlock)
	Set(Channeled, 17401, {  9.5, 17401 }) -- Hurricane (Druid)
	Set(Channeled,   605, {  3.0,   605 }) -- Mind Control (Priest)
	Set(Channeled, 15407, {  3.0, 15407 }) -- Mind Flay (Priest)
	Set(Channeled,  2096, { 60.0,  2096 }) -- Mind Vision (Priest)
	Set(Channeled,  5740, {  7.5,  5740 }) -- Rain of Fire (Warlock)
	Set(Channeled, 10797, {  6.0, 10797 }) -- Starshards
	Set(Channeled,   740, {  9.5,   740 }) -- Tranquility (Druid)
	Set(Channeled,  1510, {  6.0,  1510 }) -- Volley (Hunter)
end 

-- Spells that increases the cast time of other spells
do
	Set(CastIncrease, 19365, 50) -- Ancient Dread (NPC)
	Set(CastIncrease, 14538, 35) -- Aural Shock (NPC)
	Set(CastIncrease,  8140, 50) -- Befuddlement (NPC)
	Set(CastIncrease, 23153, 50) -- Brood Power: Blue (NPC)
	Set(CastIncrease, 22642, 50) -- Brood Power: Bronze (NPC)
	Set(CastIncrease,  7102, 25) -- Contagion of Rot (NPC)
	Set(CastIncrease, 10651, 20) -- Curse of the Eye (NPC)
	Set(CastIncrease,  1714, 60) -- Curse of Tongues (Warlock)
	Set(CastIncrease, 12255, 15) -- Curse of Tuten'kash (NPC)
	Set(CastIncrease,  3603, 35) -- Distracting Pain (NPC)
	Set(CastIncrease,  1098, 30) -- Enslave Demon (Warlock)
	Set(CastIncrease, 22909, 50) -- Eye of Immol'thar (NPC)
	Set(CastIncrease, 17331, 10) -- Fang of the Crystal Spider (Item)
	Set(CastIncrease,  5760, 60) -- Mind-Numbing Poison (Rogue)
	Set(CastIncrease,  8272, 20) -- Mind Tremor (NPC)
	Set(CastIncrease, 24415, 50) -- Slow (NPC)
	Set(CastIncrease, 22247, 80) -- Suppression Aura (NPC)
	Set(CastIncrease,  7127, 20) -- Wavering Will (NPC)
	Set(CastIncrease, 28732, 25) -- Widow's Embrace (NPC)
end 
-- Spells that have talents to reduce their cast time
-- Values here indicate the reduction
do
	Set(CastDecrease,   421, 1  ) -- Chain Lightning
	--Set(CastDecrease,   133, 0.5) -- Fireball (commonly skipped, so we're excluding this one)
	Set(CastDecrease,   116, 0.5) -- Frostbolt
	Set(CastDecrease,  2645, 2  ) -- Ghost Wolf
	Set(CastDecrease, 25314, 0.5) -- Greater Heal
	Set(CastDecrease,  2054, 0.5) -- Heal
	Set(CastDecrease,  5185, 0.5) -- Healing Touch
	Set(CastDecrease,   331, 0.5) -- Healing Wave
	Set(CastDecrease, 14914, 0.5) -- Holy Fire
	Set(CastDecrease,   348, 0.5) -- Immolate
	Set(CastDecrease,   403, 1  ) -- Lightning Bolt
	Set(CastDecrease,  8129, 0.5) -- Mana Burn
	Set(CastDecrease,   686, 0.5) -- Shadow Bolt
	Set(CastDecrease,   585, 0.5) -- Smite
	Set(CastDecrease,  6353, 2  ) -- Soul Fire
	Set(CastDecrease,  2912, 0.5) -- Starfire
	Set(CastDecrease,   691, 4  ) -- Summon Felhunter
	Set(CastDecrease,   688, 4  ) -- Summon Imp
	Set(CastDecrease,   712, 4  ) -- Summon Succubus
	Set(CastDecrease,   697, 4  ) -- Summon Voidwalker
	Set(CastDecrease,  5176, 0.5) -- Wrath
end 

-- Crowd control that causes casts to be canceled
-- (no CLEU event fires for this)
do
	Set(CrowdControl,  5211, 1) -- Bash
	Set(CrowdControl, 15269, 1) -- Blackout
	Set(CrowdControl,  2094, 1) -- Blind
	Set(CrowdControl,  7922, 1) -- Charge Stun
	Set(CrowdControl,  1833, 1) -- Cheap Shot
	Set(CrowdControl, 12809, 1) -- Concussion Blow
	Set(CrowdControl, 18469, 1) -- Counterspell (Silence)
	Set(CrowdControl,  6789, 1) -- Death Coil
	Set(CrowdControl,  5782, 1) -- Fear
	Set(CrowdControl,  3355, 1) -- Freezing Trap
	Set(CrowdControl,  1776, 1) -- Gouge
	Set(CrowdControl,   853, 1) -- Hammer of Justice
	Set(CrowdControl,  2637, 1) -- Hibernate
	Set(CrowdControl,  5484, 1) -- Howl of Terror
	Set(CrowdControl, 12355, 1) -- Impact
	Set(CrowdControl, 19410, 1) -- Improved Concussive Shot
	Set(CrowdControl, 16922, 1) -- Improved Starfire
	Set(CrowdControl, 22703, 1) -- Inferno Effect (Summon Infernal)
	Set(CrowdControl, 20253, 1) -- Intercept Stun
	Set(CrowdControl,  5246, 1) -- Intimidating Shout
	Set(CrowdControl, 24394, 1) -- Intimidation
	Set(CrowdControl, 18425, 1) -- Kick (Silence)
	Set(CrowdControl,   408, 1) -- Kidney Shot
	Set(CrowdControl,  5530, 1) -- Mace Stun
	Set(CrowdControl,   605, 1) -- Mind Control
	Set(CrowdControl,   118, 1) -- Polymorph
	Set(CrowdControl, 28272, 1) -- Polymorph: Pig
	Set(CrowdControl, 28271, 1) -- Polymorph: Turtle
	Set(CrowdControl,  9005, 1) -- Pounce
	Set(CrowdControl,  8122, 1) -- Psychic Scream
	Set(CrowdControl, 18093, 1) -- Pyroclasm
	Set(CrowdControl, 20066, 1) -- Repentance
	Set(CrowdControl, 12798, 1) -- Revenge Stun
	Set(CrowdControl,  6770, 1) -- Sap
	Set(CrowdControl,  1513, 1) -- Scare Beast
	Set(CrowdControl, 19503, 1) -- Scatter Shot
	Set(CrowdControl, 20170, 1) -- Seal of Justice Stun
	Set(CrowdControl,  6358, 1) -- Seduction
	Set(CrowdControl, 18498, 1) -- Shield Bash (Silence)
	Set(CrowdControl, 15487, 1) -- Silence
	Set(CrowdControl, 24259, 1) -- Spell Lock
	Set(CrowdControl, 20549, 1) -- War Stomp
	Set(CrowdControl, 19386, 1) -- Wyvern Sting
end 

-- Items that causes casts to be canceled
-- (no CLEU event fires for this)
do
	Set(CrowdControl, 19821, 1) -- Arcane Bomb Silence
	Set(CrowdControl,  4067, 1) -- Big Bronze Bomb
	Set(CrowdControl,  4069, 1) -- Big Iron Bomb
	Set(CrowdControl, 19784, 1) -- Dark Iron Bomb
	Set(CrowdControl,  5134, 1) -- Flash Bomb Fear
	Set(CrowdControl, 26108, 1) -- Glimpse of Madness
	Set(CrowdControl, 13181, 1) -- Gnomish Mind Control Cap
	Set(CrowdControl, 13237, 1) -- Goblin Mortar
	Set(CrowdControl, 12543, 1) -- Hi-Explosive Bomb
	Set(CrowdControl,  4068, 1) -- Iron Grenade
	Set(CrowdControl,  4065, 1) -- Large Copper Bomb
	Set(CrowdControl, 13808, 1) -- M73 Frag Grenade
	Set(CrowdControl, 12421, 1) -- Mithril Frag Bomb
	Set(CrowdControl,   835, 1) -- Tidal Charm
	Set(CrowdControl, 12562, 1) -- The Big One
	Set(CrowdControl, 19769, 1) -- Thorium Grenade
	Set(CrowdControl, 13327, 1) -- Reckless Charge
	Set(CrowdControl,  4064, 1) -- Rough Copper Bomb
	Set(CrowdControl,  1090, 1) -- Sleep
	Set(CrowdControl,  4066, 1) -- Small Bronze Bomb
	Set(CrowdControl,    56, 1) -- Stun (Weapon Proc)
	Set(CrowdControl, 15283, 1) -- Stunning Blow (Weapon Proc)
end
