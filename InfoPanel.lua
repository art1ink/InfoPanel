InfoPanel={}
local version=1.56
local lang=GetCVar("language.2")
local fs=7.2
ZO_CreateStringId("SI_BINDING_NAME_IP_TIMER_START", "Start timer")
ZO_CreateStringId("SI_BINDING_NAME_IP_TIMER_STOP", "Stop timer")
local icon_m_size,icon_p_size1,icon_p_size2,icon_p_size3=24,16,18,26
local ExpDelay,TimeStartExp,TimeLastExp,StartExp,LastExp=60000*5,0,0,0,0
local informedAchievement={}
local ExpIcon={"/esoui/art/icons/icon_experience.dds",GetCurrencyKeyboardIcon(CURT_ALLIANCE_POINTS),"",GetCurrencyKeyboardIcon(CURT_TELVAR_STONES)}
local AP={[PROGRESS_REASON_ALLIANCE_POINTS]=true}
local Exp={
	[PROGRESS_REASON_COMPLETE_POI]=true,
	[PROGRESS_REASON_DARK_ANCHOR_CLOSED]=true,[PROGRESS_REASON_SCRIPTED_EVENT]=true,
	[PROGRESS_REASON_DARK_FISSURE_CLOSED]=true,
	[PROGRESS_REASON_KILL]=true,
	[PROGRESS_REASON_LFG_REWARD]=true,
	[PROGRESS_REASON_QUEST]=true,
	[PROGRESS_REASON_REWARD]=true,
	}
local bg={
	"esoui/art/contacts/social_list_bgstrip.dds",
	"esoui/art/miscellaneous/spinnerbg_left.dds",
	"esoui/art/crafting/gamepad/gp_universalstyle_rowbackground.dds",
	"esoui/art/screens_app/gamepad/gp_loading_text_background-1024x256.dds",
	}
local IsChest={
	["Truhe"]=true,
	["Coffre"]=true,
	["Chest"]=true,
	["сундук"]=true,
	}
local LastChest={x=0,y=0}
local WayshrineIcon="/esoui/art/tutorial/poi_wayshrine_complete.dds"
local LatestMailZoneNames,FishingText,FishingWidth,MapZoneIndex,ChestsLooted,DungeonStartTime,RaidTargetTime,Settings,init,MinCharge,lastoutput,achievements1,achievements2,bag_space1,bag_space2,bank_space1,bank_space2,stable,smithing,researching,ResearchIcon,research_sec,research_cur,research_max,timer_start,timer_period,timer_w,expps_w,panel_w,panel_last_w,StolenItems,FenceSells,FenceLaunders,WornCondition,GlobalSettings,CharacterSettings,MenuParam,DungeonBossTimer={},"",0,0,0,0,0,nil,false,100,0,0,0,0,0,0,0,true,true,false,"",0,0,0,0,0,0,0,0,0,0,0,0,0,{},{},nil,nil

local FishIcon={
	Lake="/esoui/art/icons/crafting_fishing_perch.dds",
	Foul="/esoui/art/icons/crafting_slaughterfish.dds",
	River="/esoui/art/icons/crafting_fishing_river_betty.dds",
	Salt="/esoui/art/icons/crafting_fishing_merringar.dds",
	Oily="/esoui/art/icons/crafting_slaughterfish.dds",
	Mystic="/esoui/art/icons/crafting_fishing_merringar.dds",
	Running="/esoui/art/icons/crafting_fishing_river_betty.dds",
	}
local FishingZones={
	[2]=471,--Glenumbra
	[4]=472,--Stormhaven
	[5]=473,--Rivenspire
	[9]=477,--Stonefalls
	[10]=478,--Deshaan
	[11]=486,--Malabal Tor
	[14]=475,--Bangkorai
	[15]=480,--Eastmarch
	[16]=481,--Rift
	[17]=474,--Alik'r Desert
	[18]=485,--Greenshade
	[19]=479,--Shadowfen
	[37]=489,--Cyrodiil
	[154]=490,--Coldhabour
	[178]=483,--Auridon
	[179]=487,--Reaper's March
	[180]=484,--Grahtwood
	[500]=916,--Carglorn
	[109]=493,--Bleakrock
	[304]=491,--Stros M'Kai
	[306]=492,--Khenarthi's Roost
	--DLC
	[346]=1186,--Imperial City
	[379]=1340,--Wrothgar
	[442]=1351,--Hew's Bane
	[448]=1431,--Gold Coast
	[467]=1882,--Vvardenfell
	[589]=2027,--Clockwork City
	[590]=2027,--Clockwork City Brass Fortress
	[616]=2191,--Summerset
	[632]=2240,--Arteum
	[407]=2295,--Murkmire
	[681]=2412,--Northern Elsweyr
	[720]=2566,--Southern Elsweyr
	[743]=2655,--Greymoor
	[783]=2861,--Markarth
	[834]=2981,--Blackwood
	[857]=3144,--Deadlands
	[883]=3269,--High Isle
	bleakrockvillage=493,
	murkmire=2295,rootwhisper=2295,brightthroatvillage=2295,lilmothcity=2295,
	imperialcity=1186,
	wrothgar=1340,
	hewsbane=1351,
	goldcoast=1431,anvilcity=1431,kvatchcity=1431,
	vvardenfell=1882,
	clockwork=2027,brassfortress=2027,
	summerset=2191,lillandrill=2191,
	artaeum=2240,
	blackreach=2655,
	U28_blackreach=2861
}
local FishingAchievements={[471]=true,[472]=true,[473]=true,[474]=true,[475]=true,[477]=true,[478]=true,[479]=true,[480]=true,[481]=true,[483]=true,[484]=true,[485]=true,[486]=true,[487]=true,[489]=true,[490]=true,[491]=true,[492]=true,[493]=true,[916]=true,[1186]=true,[1339]=true,[1340]=true,[1351]=true,[1431]=true,[1882]=true,[2191]=true,[2240]=true,[2295]=true,[2412]=true,[2566]=true,[2655]=true,[2861]=true,[2981]=true,[3144]=true}
local FishingBugFix={[473]={[3]="River"},[2027]={[8]="Oily"},[472]={[1]="Foul"}}

local function ResetToDefault()
	for i,data in pairs(Settings) do GlobalSettings[data.name]=data.value end
	if GlobalSettings.ZO_CompassFrame and not (BUI and BUI.Vars and BUI.Vars.ZO_CompassFrame) then
		ZO_CompassFrame:ClearAnchors() ZO_CompassFrame:SetAnchor(TOP,GuiRoot,TOP,0,(IsInGamepadPreferredMode() and 58 or 40))
		ZO_TargetUnitFramereticleover:ClearAnchors() ZO_TargetUnitFramereticleover:SetAnchor(TOP,ZO_CompassFrame,BOTTOM,0,5)
	end
	GlobalSettings.ZO_CompassFrame=nil
end

local function MoveFrames()
	local function ApplyTemplateHook(obj,name)
		local ZO_Func=obj['ApplyStyle']
		obj['ApplyStyle']=function(self)
			local result=ZO_Func(self)
			if GlobalSettings[name] and not (BUI and BUI.Vars and BUI.Vars[name]) then
				local frame=_G[name] frame:ClearAnchors() frame:SetAnchor(TOP,GuiRoot,TOP,0,GlobalSettings[name])
			end
			return result
		end
	end
	if GlobalSettings.ZO_CompassFrame and not (BUI and BUI.Vars and BUI.Vars.ZO_CompassFrame) then
		ZO_CompassFrame:ClearAnchors() ZO_CompassFrame:SetAnchor(TOP,GuiRoot,TOP,0,GlobalSettings.ZO_CompassFrame)
		ApplyTemplateHook(COMPASS_FRAME,'ZO_CompassFrame')
		ZO_TargetUnitFramereticleover:ClearAnchors() ZO_TargetUnitFramereticleover:SetAnchor(TOP,ZO_CompassFrame,BOTTOM,0,5)
	end
end

local function CenterInfoPanel()
	ZO_PerformanceMeters:ClearAnchors() ZO_PerformanceMeters:SetAnchor(TOP,nil,TOP,0,-20) ZO_PerformanceMeters_OnMoveStop()
	GlobalSettings.ZO_CompassFrame=70
	MoveFrames()
end

Settings={
	[1]={name="Settings",value=true,header=true},
	[2]={name="Memory",value=false,icon="/esoui/art/ava/overview_icon_underdog_score.dds"},	--esoui/art/tutorial/gamepad/gp_inventory_icon_miscellaneous.dds
	[3]={name="Timer",value=true,icon="/esoui/art/icons/justice_stolen_hourglass_001.dds"},
	[4]={name="BossTimer",value=false,icon="/esoui/art/icons/poi/poi_groupboss_complete.dds"},
	[5]={name="BagSpace",value=1,icon="/esoui/art/tooltips/icon_bag.dds",dropdown=true},
	[6]={name="BankSpace",value=3,icon="/esoui/art/icons/mapkey/mapkey_bank.dds",dropdown=true},
	[7]={name=33271,value=false,icon="/esoui/art/icons/soulgem_006_filled.dds"},
	[8]={name=33265,value=false,icon="/esoui/art/icons/soulgem_006_empty.dds"},
	[9]={name=30357,value=false,icon="/esoui/art/icons/lockpick.dds"},
	[10]={name=44879,value=false,icon="/esoui/art/lfg/lfg_bonus_crate.dds"},
	[11]={name="RealTime",value=true,icon="/esoui/art/hud/gamepad/gp_radialicon_defer_down.dds"},	--esoui/art/icons/justice_stolen_hourglass_001.dds
	[12]={name="TamrielTime",value=false,icon="/esoui/art/tutorial/cadwell_indexicon_silver_up.dds"},	--esoui/art/miscellaneous/timer_32.dds
	[13]={name="TimeFormat",value=2,icon="/esoui/art/hud/gamepad/gp_radialicon_defer_down.dds",dropdown=true,choices={"12","24"}},
	[14]={name="Experience",value=true,character=true,icon="/esoui/art/icons/icon_experience.dds"},
	[15]={name="Stable",value=true,icon="/esoui/art/icons/mapkey/mapkey_stables.dds"},
	[16]={name="Smithing",value=true,icon="/esoui/art/icons/mapkey/mapkey_crafting.dds"},
	[17]={name="AP",value=false,icon=GetCurrencyKeyboardIcon(CURT_ALLIANCE_POINTS)},
	[18]={name="Gold",value=false,icon=GetCurrencyKeyboardIcon(CURT_MONEY)},
	[19]={name="Telvar",value=false,icon=GetCurrencyKeyboardIcon(CURT_TELVAR_STONES)},
	[20]={name="Vouchers",value=false,icon=GetCurrencyKeyboardIcon(CURT_WRIT_VOUCHERS)},
	[21]={name="Transmutation",value=false,icon=GetCurrencyKeyboardIcon(CURT_CHAOTIC_CREATIA)},
	[22]={name="UndauntedKeys",value=false,icon=GetCurrencyKeyboardIcon(CURT_UNDAUNTED_KEYS)},
	[23]={name="EventTickets",value=false,icon=GetCurrencyKeyboardIcon(CURT_EVENT_TICKETS)},
	[24]={name="Fence",value=false,icon="/esoui/art/inventory/gamepad/gp_inventory_icon_stolenitem.dds"},
	[25]={name="Apparel",value=true,icon="/esoui/art/inventory/gamepad/gp_inventory_icon_apparel.dds"},	--esoui/art/progression/icon_armorsmith.dds
	[26]={name="Weapons",value=true,icon="/esoui/art/progression/icon_weaponsmith.dds"},
	[27]={name="Achievements",value=3,icon="/esoui/art/tutorial/gamepad/gp_playermenu_icon_achievements.dds",dropdown=true},
	[28]={name="Skyshards",value=false,icon="/esoui/art/tutorial/gamepad/achievement_categoryicon_skyshards.dds"},
--	[27]={name="ESOPlus",value=0,icon="/esoui/art/inventory/inventory_quest_tabicon_active.dds",slider=true,maxvalue=120,setfunc=function(days) if days==0 then GlobalSettings.ESOPlus=0 else ESOPlusSubscriber=IsESOPlusSubscriber() local h,m,s=string.match(GetTimeString(),"(%d+):(%d+):(%d+)") GlobalSettings.ESOPlus=GetTimeStamp()-(h*60*60+m*60+s)+(days*24*60*60)+(18*60*60) end end,getfunc=function() return GlobalSettings.ESOPlus==0 and 0 or math.floor((GlobalSettings.ESOPlus-GetTimeStamp())/60/60/24) end},
	[29]={name="ExpPS",value=3,icon="/esoui/art/icons/icon_experience.dds",dropdown=true,choices={"Exp/sec","AP/sec","disabled","Telvar/sec"}},
	[30]={name="ReelAlert",value=false,icon="/esoui/art/icons/achievements_indexicon_fishing_up.dds"},
	[31]={name="FishingAchivement",value=false,character=true,icon="/esoui/art/icons/crafting_fishing_merringar.dds"},
	[32]={name="TrialInfo",value=false,icon="/esoui/art/tutorial/gamepad/gp_lfg_trial.dds"},
	[33]={name="DungeonInfo",value=false,icon="/esoui/art/icons/mapkey/mapkey_solotrial.dds"},
	[34]={name="DungeonChests",value=true,icon="/InfoPanel/Chest.dds"},
	[35]={name="Hirelings",value=false,icon="/esoui/art/mail/gamepad/gp_mailmenu_attachitem.dds"},
	[36]={name="Settings",value=true,header=true},
	[37]={name="Achievement_up",value=false,icon="/esoui/art/tutorial/gamepad/gp_playermenu_icon_achievements.dds"},
	[38]={name="APgain",value=true,icon=GetCurrencyKeyboardIcon(CURT_ALLIANCE_POINTS)},
	[39]={name="TelvarGain",value=true,icon=GetCurrencyKeyboardIcon(CURT_TELVAR_STONES)},
	[40]={name="ExPgain",value=true,icon="/esoui/art/icons/icon_experience.dds"},
	[41]={name="Settings",value=true,header=true},
	[42]={name="InfoPanel",value=true,icon="/esoui/art/cadwell/check.dds"},
	[43]={name="Background",value=10,icon="/esoui/art/crafting/universalstyle_rowbackground.dds",slider=true},
	[44]={name="Scale",value=0,icon="/esoui/art/miscellaneous/gamepad/gp_scrollarrow_up.dds",slider=true},
	[45]={name="Update",value=5,icon="/esoui/art/help/help_tabicon_feedback_up.dds",slider=true},
	[46]={name="Center",button=true,func=function() CenterInfoPanel() end},
	[47]={name="Reset",button=true,func=function() ResetToDefault() end,split=true},
	[48]={name="AutoRepair",value=true,header=true},
	[49]={name="AutoRepairStore",value=false,icon="/esoui/art/treeicons/achievements_indexicon_crafting_up.dds"},
	[50]={name="AutoRepairKit",value=false,icon="/esoui/art/treeicons/achievements_indexicon_crafting_up.dds"},
	[51]={name="AutoRecharge",value=false,icon="/esoui/art/inventory/inventory_tabicon_craftbag_enchanting_up.dds"},
	[52]={name="ChatOutput",value=true,icon="/esoui/art/tutorial/chat-notifications_up.dds"},
	}
local Localization={
	en={
	"Panel Options",			"",
	"Memory used by add-ons",	"",
	"Timer",				"Need to bind keys in CONTROLS menu to use",
	"Auto start timer",		"Auto start timer on dungeon bosses (loot can be received once in 4 min)",
	"Bag space",			"",
	"Bank space",			"",
	"Soul gems",			"",
	"Soul gems (empty)",		"",
	"Lockpicks",			"",
	"Repair kits",			"Works only with [Grand Repair Kit]",
	"Real time",			"",
	"Tamriel time",			"",
	"Time format",			"",
	"Experience",			"Experience info (option for current character)",
	"Stable info",			"This option automatically disables for characters with maxed skills in stable",
	"Researches info",		"This option automatically disables for characters who knows all traits or does not researching",
	"Alliance points",		"",
	"Gold",				"",
	"Telvar stones",			"",
	"Writ vouchers",			"",
	"Transmutation stones",		"",
	"Undaunted keys",			"",
	"Event tickets",			"",
	"Stolen/Fence,Launder",		"",
	"Apparel condition",		"",
	"Weapons charge",			"",
	"Achievement points",		"",
	"Skyshards",			"",
--	"ESO Plus",				"Displays ESO Plus membership time left. Set days left to enable. To disable set it to 0.",
	"Exp/Ap/Telvar per second",	"Displays Experience/AP per second value. Couner automatically resets after 5 min.",
	"Fishing: Reel alert",		"Displays on screen alert when fish is ready to reel.",
	"Fishing: Achivement info",	"Displays current zone fishing achivement info (option for current character).",
	"Trial info",			"Adds raid progress time and score.",
	"Dungeon info",			"Adds dungeon progress time and score.",
	"Dungeon chests",			"Adds quanity of looted/available chests in current dungeon.",
	"Hirelings (beta)",		"Time to the next delivery",
	"Chat messages",			"",
	"Achievement updates",		"Post in chat achivement updates",
	"AP gain",				"Post to chat huge AP ticks",
	"Telvar gain",			"Post to chat huge Telvar gains",
	"Experience gain",		"Post to chat huge Experience gains",
	"Panel Settings",			"",
	"Enable Info Panel",		"Shows additional info in standard performance panel",
	"Background transparency",	"Set this option to 0 to disable background",
	"Panel Scale",			"",
	"Update time",			"Information update time in seconds",
	"Center Panel",			"Move Info Panel to the top of the screen and move compass down.",
	"Reset",				"Reset add-on settings and move frames to it's default positions",
	"Auto repair/recharge",		"",
	"Auto repair in store",		"Automatically repairs all your apparel when you open store",
	"Auto repair in combat",	"Automatically repairs your apparel when it damaged (works only with [Grand Repair Kit])",
	"Auto recharge",			"Automatically recharges your weapons",
	"Chat output",			"Post repair/recharge results to chat",
	Name="Info Panel",
	AutoRepair="Auto Repair",
	["choices"]={"total","total/from","disabled"},
	["s_repaired"]="repaired for",
	["c_repaired"]="Repaired: ",
	["c_charged"]=GetString(SI_ITEMTRAITTYPE2)..": ",
	["no_kit"]="No repair kits",
	["no_gem"]="No soul gems",
	["damaged"]=" is damaged",
	["discharged"]=" out of charge",
	["reel"]="Reel in!",
	Lake="Lake",Foul="Foul",River="River",Salt="Salt",Oily="Oily",Mystic="Mystic",Running="Running",
	},
	ru={
	"Информация панели",		"",
	"Память занимаемая аддонами",	"",
	"Таймер",				"Для использования нужно назначить кнопки в меню CONTROLS",
	"Авто запуск таймера",		"Авто запуск таймера на босах в данжах (лут можно болучить не чаще чем раз в 4 минуты)",
	"Место в инвентаре",		"",
	"Место в банке",			"",
	"Камни душ",			"",
	"Камни душ (пустые)",		"",
	"Отмычки",				"",
	"Рем.комплекты",			"Показывает только [Grand Repair Kit]",
	"Время",				"",
	"Время в игре",			"",
	"Формат времени",			"",
	"Опыт",				"Набранный опыт (включается отдельно для текущего персонажа)",
	"Конюшня",				"Этот пункт автоматически отключается для персонажей у которых в конюшне уже все изучено",
	"Ремесленные исследования",	"Этот пункт автоматически отключается для персонажей у которых уже изучены все свойства или ничего не изучается",
	"Альянс поинты",			"",
	"Золото",				"",
	"Камни Тель-Вар",			"",
	"Ваучеры",				"",
	"Камни трансмутации",		"",
	"Ключи неустрашимых",		"",
	"Билеты событий",			"",
	"Краденное/можно сдать,отмыть","",
	"Состояние доспехов",		"",
	"Заряд оружия",			"",
	"Очки Достижений",		"",
	"Скайшарды",			"",
--	"ESO Plus",				"Показывает время до окончания ESO Plus. Чтоб включить укажите дни до окончания. Для откючения установите на 0.",
	"Exp/Ap/Telvar в секунду",	"Показывает набор Experience/AP в секунду. Счётчик автоматически сбрасывается через 5 минут простоя или можно его сбросить щелчком мыши.",
	"Рыбалка: Оповещение о поклевке",	"Выводит на экран сообщение о том что рыба клюнула и пора \"подсекать\".",
	"Рыбалка: Достижения",		"Показывает сколько еще раритетной рыбы нужно выловить в текущей локации (включается отдельно для текущего персонажа).",
	"Информация Триала",		"Добавляет информацию о продолжительности рейда, набранным очкам.",
	"Время в данже",			"Добавляет информацию о времени нахождения в данже.",
	"Сундуки в данже",		"Показывает колличество собранных/доступных сундуков в текущем данже.",
	"Наемники (beta)",		"Время до следующей доставки.",
	"Сообщения чата",		"",
	"Обновления достижений",	"Вывод в чат информации о обновлении достижений.",
	"Получение AP gain",		"При получении большого колличества AP выводить сообщение в окно чата.",
	"Получение Telvar-ов",		"При получении большого колличества Telvar-ов выводить сообщение в окно чата.",
	"Получение Опыта",		"При получении большого колличества опыта выводить сообщение в окно чата.",
	"Настройки панели",		"",
	"Включить панель",		"Добавляет к стандартной панели производительности дополнительную информацию.",
	"Прозрачность фона",		"Если выставить на 0 то фон будет полностью отключен.",
	"Масштаб панели",			"",
	"Время обновления",		"Частота обновления (секунды).",
	"Центрировать",			"",
	"Сброс настроек",			"Настройки бутыт выставлены на значения по умолчанию. Фреймы будут возвращены на их стандартные позиции.",
	"Авто починка/зарядка",		"",
	"Авто починка у торговца",	"Автоматически ремонтирует доспехи при диалоге с торговцем.",
	"Авто починка в бою",		"Автоматически ремонтирует доспехи когда они теряют прочность (используются [Grand Repair Kit]).",
	"Авто зарядка",			"Автоматически заряжает оружие камнями душ.",
	"Вывод в чат",			"Вывод в чат информации о починке одежды/зарядке оружия.",
	Name="Панель информации",
	AutoRepair="Авто починка",
	choices={"всего","всего/из","выключено"},
	["s_repaired"]="отремонтирована на",
	["c_repaired"]="Отремонтировано: ",
	["c_charged"]=GetString(SI_ITEMTRAITTYPE2)..": ",
	["no_kit"]="Нет рем.комплектов для ремонта",
	["no_gem"]="Нет камней душ для зарядки оружия",
	["damaged"]=" повреждено",
	["discharged"]=" разряжено",
	["reel"]="Клюёт!",
	Lake="озерная вода",Foul="грязная вода",River="речная вода",Salt="соленая вода",Oily="маслянистая вода",Mystic="мистическая вода",Running="речная вода",
	},
	de={
	"Panel Options",			"",
	"Speicher verwendet von add-ons",	"",
	"Timer",				"Need to bind keys in CONTROLS menu to use",
	"Auto start timer",		"Auto start timer on dungeon bosses (loot can be received once in 4 min)",
	"Taschenplaetze",			"",
	"Bankplatz",			"",
	"Seelensteine",			"",
	"Seelensteine (leer)",		"",
	"Dietriche",			"",
	"Reparatur Kiste",		"Works only with [Grand Repair Kit]",
	"Echtzeit",				"",
	"Tamriel Zeit",			"",
	"Zeitformat",			"",
	"Erfahrung",			"Experience info (option for current character)",
	"Stall Informationen",		"This option automaticaly disables for characters with maxed skills in stable",
	"Forschungsinformation",	"This option automaticaly disables for characters who knows all traits or does not researching",
	"Allianz Punkte",			"",
	"Gold",				"",
	"Telvar Steine",			"",
	"Wertgutscheine",			"",
	"Transmutationskristalle",	"",
	"Undaunted keys",			"",
	"Event tickets",			"",
	"Gestohlen/Hehler,schieben",	"",
	"Zustand der Ruestung",		"",
	"Weapons charge",			"",
	"Errungenschaftspunkte",	"",
	"Skyshards",			"",
--	"ESO Plus",				"Displays ESO Plus membership time left. Set days left to enable. To disable set it to 0.",
	"Exp/Ap/Telvar per second",	"Displays Experience/AP per second value. Couner automatically resets after 5 min.",
	"Fishing: Reel alert",		"Displays on screen alert when fish is ready to reel.",
	"Fishing: Achivement info",	"Displays current zone fishing achivement info (option for current character).",
	"Trial info",			"Adds raid progress time and score.",
	"Dungeon info",			"Adds dungeon progress time and score.",
	"Hirelings (beta)",		"Time to the next delivery",
	"Dungeon chests",			"Adds quanity of looted/available chests in current dungeon.",
	"Chat Messages",			"",
	"Leistungsaktualisierungen",		"Post in chat achivement updates",
	"AP gain",				"Post to chat huge AP ticks",
	"Telvar gain",			"Post to chat huge Telvar gains",
	"Experience gain",		"Post to chat huge Experience gains",
	"Panel Settings",			"",
	"Informations Panel einschalten",	"Shows additional info in standart performance panel",
	"Hintergrundtransparenz",	"Set this option to 0 to disable background",
	"Panel Scale",			"",
	"Aktualisierungszeit",		"Information update time in seconds",
	"Zentrum",				"",
	"Reset",				"Reset add-on settings and move frames to it's defaults",
	"Auto repair/recharge",		"",
	"Auto repair in store",		"Automaticaly repairs all your apparel when you open store",
	"Auto repair in combat",	"Automaticaly repairs your apparel when it damaged (works only with [Grand Repair Kit])",
	"Auto recharge",			"Automaticaly recharges your weapons",
	"Chat output",			"Post to char repair/recharge results",
	Name="Info Panel",
	AutoRepair="Auto Repair",
	choices={"gesamt", "gesamt/von", "deaktiviert"},
	["s_repaired"]="repariert für",
	["c_repaired"]="Repariert: ",
	["c_charged"]=GetString(SI_ITEMTRAITTYPE2)..": ",
	["no_kit"]="No repair kits",
	["no_gem"]="No soul gems",
	["damaged"]=" is damaged",
	["discharged"]=" entladen",
	["reel"]="Reel in!",
	Lake="Seewasser",Foul="Brackwasser",River="Flusswasser",Salt="Salzwasser",Oily="Ölwasser",Mystic="Mythenwasser",Running="Fließgewässer",
	},
	fr={--provided by NOTHAN, lexo1000
	"Affichage des infos",			"",
	"Mémoire occupée par les extensions",	"Indique la quantité de mémoire vive utilisée par toutes les extensions activées.",
	"Minuterie",					"Pour utiliser la minuterie, configurer les raccourcis dans le menu Commandes.",
	"Lancement automatique de la minuterie","Lance automatiquement la minuterie lors des Boss de donjon (le pillage peut être effectué toutes les 4 min).",
	"Espace d'inventaire",		"Indique l'espace restant ou occupé dans l'inventaire.",
	"Espace en banque",		"Indique l'espace restant ou occupé en banque.",
	"Pierres d'âme pleines",	"Indique le nombre de Pierres d'âme remplies disponibles dans l'inventaire.",
	"Pierres d'âme vides",		"Indique le nombre de Pierres d'âme vides disponibles dans l'inventaire.",
	"Crochets",				"Indique le nombre de crochets disponibles dans l'inventaire.",
	"Nécessaires de réparation",	"Indique le nombre de Grands nécessaires de réparation présents dans l'inventaire.",
	"Heure en temps réel",		"Indique l'heure actuelle.",
	"Heure en Tamriel",		"Indique l'heure dans le monde de Tamriel.",
	"Format de l'heure",		"",
	"Expérience",			"Indique le niveau et le pourcentage d'achèvement pour le niveau suivant.",
	"Monture",				"Indique le temps restant avant de pouvoir à nouveau entraîner la monture. Cette alerte ne s'affiche plus lorsque la compétence de monture atteint son niveau maximal.",
	"Recherche",			"Indique le nombre de recherches en cours. Ne s'affiche pas lorsque le personnage n'effectue aucune recherche ou a apprit tous les traits.",
	"Points d'alliance",		"Indique le nombre de Points d'alliance en possession du personnage.",
	"Or",					"Indique la quantité d'or en possession du personnage.",
	"Pierres de Tel Var",		"Indique le nombre de Pierres de Tel Var en possession du personnage.",
	"Commandes d'artisanat",	"Indique le nombre de commandes d'artisanat en attentes de livraison.",
	"Pierre de Transmutation",	"Indique le nombre de Pierres de transmutation en possession du personnage",
	"Undaunted keys",			"",
	"Event tickets",			"",
	"Objets volés/vendus/blanchis","Indique le nombre d'objets volés, vendus et blanchis en possession du personnage.",
	"Etat des armures",		"Indique le pourcentage de durabilité des armures portées par le personnage.",
	"Charges des armes",		"Indique le pourcentage de charges restantes sur les armes équipées par le personnage.",
	"Succès",				"Indique le nombre de succès débloqués.",
	"Éclats Célestes",		"Indique le nombre d'Éclats célestes débloqués par le personnage.",
	--"ESO Plus",			"Indique le temps restant en tant que membre ESO+. Sélectionner le temps ou zéro pour arrêter.",
	"Exp/Ap/Telvar par seconde",	"Indique l'expérience/AP gagné par seconde. Le compteur est réinitialisé toutes les 5 min.",
	"Alerte de pêche",		"Affiche une notification lorsqu'un poisson est ferré.",
	"Succès de pêche",		"Indique les succès de pêche de la zone actuelle.",
	"Épreuves",				"Indique la progression du raid et le score.",
	"Infos du donjon",		"Indique le temps de progression et le score du donjon.",
	"Coffres de donjon",		"Indique le nombre de coffres pillés et disponible dans le donjon actuel.",
	"Fournisseurs (beta)",		"Indique le temps restant avant la prochaine livraison.",
	"Chat messages",			"",
	"Notification des succès",	"Affiche dans la fenêtre de communication les nouveaux succès.",
	"Notification de points d'alliance",		"Affiche dans la fenêtre de communication les points d'alliance remportés.",
	"Notification de Pierres de Tel Var",		"Affiche dans la fenêtre de communication les pierres de Tel Var remportées.",
	"Notification d'Expérience",				"Affiche dans la fenêtre de communication les gains en points d'Expérience importants.",
	"Paramètres de la barre",		"",
	"Activer la barre d'information",	"Active l'affichage des informations complémentaires sur la barre de performance par défaut.",
	"Niveau de transparence de l'arrière-plan",	"Régler à 0 pour cacher l'arrière-plan.",
	"Échelle de de la barre d'information","Détermine la dimension de la barre d'information.",
	"Délai de mise à jour",		"Détermine le temps des mise à jour des informations en secondes.",
	"Centrer la barre",		"Positionne la barre d'information au centre de l'écran",
	"Réinitialiser",					"Réinitialise les réglages de l'extension et déplace la barre à sa position initiale.",
	"Réparation/recharge automatique",		"",
	"Réparation auto chez le marchand",	"Répare automatiquement l'armure en parlant à un marchand.",
	"Réparation auto en combat",		"Répare automatiquement l'armure lorsque celle-ci est endommagée. Ne fonctionne qu'avec un Grand nécessaire de réparation.",
	"Rechargement auto des armes",	"Recharge automatique les armes.",
	"Alertes",				"Affiche un message dans la fenêtre de communication lorsqu'une réparation ou une recharge automatique est effectuée.",
	Name="Info Panel",
	AutoRepair="Auto Repair",
	choices={"libre","occupé/total","NON"},
	["s_repaired"]="Réparer pour",
	["c_repaired"]="Réparé: ",
	["c_charged"]=GetString(SI_ITEMTRAITTYPE2)..": ",
	["no_kit"]="Auncun Nécessaires de réparation",
	["no_gem"]="Aucune Pierre d'âmes",
	["damaged"]=" est endommagé",
	["discharged"]=" déchargé",
	["reel"]="Ferré ",
	Lake="Lac",Foul="Sale",River="Rivière",Salt="Mer",Oily="Huileuse",Mystic="Mystique",Running="Courante",
	},
	}
local Items={
	[30357]={icon="/esoui/art/icons/lockpick.dds"},			--Lockpick
	[33265]={icon="/esoui/art/icons/soulgem_006_empty.dds"},	--Soul gemm (empty)
	[33271]={icon="/esoui/art/icons/soulgem_006_filled.dds"},	--Soul gemm
	[44879]={icon="/esoui/art/lfg/lfg_bonus_crate.dds"},		--Repairkit
	}
local ResearchIcons={
	[CRAFTING_TYPE_WOODWORKING]="/esoui/art/icons/mapkey/mapkey_woodworker.dds",
	[CRAFTING_TYPE_BLACKSMITHING]="/esoui/art/icons/mapkey/mapkey_smithy.dds",
	[CRAFTING_TYPE_CLOTHIER]="/esoui/art/icons/servicemappins/servicepin_outfitter.dds",
	[CRAFTING_TYPE_JEWELRYCRAFTING]="/esoui/art/crafting/gamepad/gp_jewelry_tabicon_icon.dds",	--"/esoui/art/tutorial/gamepad/gp_tooltip_itemslot_neck.dds",
	}
local repair_slots	={EQUIP_SLOT_OFF_HAND,EQUIP_SLOT_BACKUP_OFF,EQUIP_SLOT_HEAD,EQUIP_SLOT_SHOULDERS,EQUIP_SLOT_CHEST,EQUIP_SLOT_WAIST,EQUIP_SLOT_LEGS,EQUIP_SLOT_HAND,EQUIP_SLOT_FEET}
local recharge_slots	={EQUIP_SLOT_MAIN_HAND,EQUIP_SLOT_OFF_HAND,EQUIP_SLOT_BACKUP_MAIN,EQUIP_SLOT_BACKUP_OFF}
local kit_id		=44879
local gem_id		=33271
local minPercent	=3
local slot_name={
	[EQUIP_SLOT_MAIN_HAND]		=GetString(SI_EQUIPTYPE14),
	[EQUIP_SLOT_OFF_HAND]		=GetString(SI_EQUIPTYPE7),
	[EQUIP_SLOT_BACKUP_MAIN]	=GetString(SI_EQUIPSLOT20),
	[EQUIP_SLOT_BACKUP_OFF]		=GetString(SI_EQUIPSLOT21),
	[EQUIP_SLOT_HEAD]			=GetString(SI_EQUIPTYPE1),
	[EQUIP_SLOT_SHOULDERS]		=GetString(SI_EQUIPTYPE4),
	[EQUIP_SLOT_CHEST]		=GetString(SI_EQUIPTYPE3),
	[EQUIP_SLOT_WAIST]		=GetString(SI_EQUIPTYPE8),
	[EQUIP_SLOT_LEGS]			=GetString(SI_EQUIPTYPE9),
	[EQUIP_SLOT_HAND]			=GetString(SI_EQUIPTYPE13),
	[EQUIP_SLOT_FEET]			=GetString(SI_EQUIPTYPE10)
	}
if not Localization[lang] then lang="en" end

local function Menu_Init()
	local BanditsMenu=BUI and BUI.InternalMenu
	if not BanditsMenu and not LibAddonMenu2 then return end
	local Panel={
		type="panel",
		name=(BanditsMenu and "14. |t32:32:/esoui/art/tutorial/inventory_tabicon_misc_up.dds|t" or "")..Localization[lang].Name,
		displayName=(BanditsMenu and "14. " or "").."|c4B8BFE"..Localization[lang].Name.."|r",
		author="|c4B8BFEHoft|r",
		version=tostring(version),
		}
	local MenuOptions={}
	local index=0
	for i,data in pairs(Settings) do
		index=index+1
		local _param=data.name
		local dropdown_value=Localization[lang].choices[data.value]
		local _name=(data.icon) and zo_iconFormat(data.icon,icon_m_size,icon_m_size).." "..Localization[lang][i*2-1] or Localization[lang][i*2-1]
		local _tip=Localization[lang][i*2]
		if data.header then
			MenuOptions[index]=
			{	type		="header",
				name		=_name,
				width		="full"
			}
		elseif data.slider then
			local maxvalue=data.maxvalue and data.maxvalue or 10
			MenuOptions[index]=
			{	type		="slider",
				name		=_name,
				tooltip	=_tip,
				min		=0,
				max		=maxvalue,
				step		=1,
				getFunc	=function()
							if data.getfunc then
								local function func() return data.getfunc() end
								return func()
							else
								return GlobalSettings[_param]
							end
						end,
				setFunc	=function(value)
							MenuParam=_param
							GlobalSettings[_param]=value
							if data.setfunc then local function func(value) data.setfunc(value) end func(value) end
							InfoPanel.Initialize() InfoPanel.Update()
						end,
				default	=data.value,
			}
		elseif data.dropdown then
			local choices	=data.choices or Localization[lang].choices
			local values={} for i in ipairs(choices) do table.insert(values,i) end
			MenuOptions[index]=
			{	type		="dropdown",
				name		=_name,
				tooltip	=_tip,
				choices	=choices,
				choicesValues=values,
				getFunc	=function() return GlobalSettings[_param] end,
				setFunc	=function(value) MenuParam=_param GlobalSettings[_param]=value InfoPanel.Initialize() InfoPanel.Update() end,
				default	=dropdown_value,
			}
		elseif data.button then
			MenuOptions[index]=
			{	type		="button",
				name		=_name,
				tooltip	=_tip,
				width		="half",
				func		=data.func,
			}
		else
			MenuOptions[index]=
			{	type		="checkbox",
				name		=_name,
				tooltip	=_tip,
				getFunc	=function() if data.character then return CharacterSettings[_param] else return GlobalSettings[_param] end end,
				setFunc	=function(value)
							MenuParam=_param
							if data.character then CharacterSettings[_param]=value else GlobalSettings[_param]=value end
							InfoPanel.Initialize() InfoPanel.Update()
						end,
				default	=data.value,
			}
		end

		if BanditsMenu and data.split then
			BUI.Menu.RegisterPanel("InfoPanel_Menu_2",Panel)
			BUI.Menu.RegisterOptions("InfoPanel_Menu_2", MenuOptions)
			MenuOptions={}
			index=0
			Panel={
				type="panel",
				name="15. |t32:32:/esoui/art/tutorial/vendor_tabicon_repair_up.dds|t"..Localization[lang].AutoRepair,
				author="|c4B8BFEHoft|r",
				version=tostring(version),
				}
		end
	end
	if BanditsMenu then
		BUI.Menu.RegisterPanel("InfoPanel_Menu_1",Panel)
		BUI.Menu.RegisterOptions("InfoPanel_Menu_1", MenuOptions)

	else
		LibAddonMenu2:RegisterAddonPanel("InfoPanel_Menu_1",Panel)
		LibAddonMenu2:RegisterOptionControls("InfoPanel_Menu_1", MenuOptions)
	end
end

local function format_time(h,m)
	local meridien=""
	if GlobalSettings.TimeFormat==1 then
		meridien=h<12 and "am" or "pm"
		h=h%12
	end
	if string.len(tostring(h))<2 then h="0"..h end
	if string.len(tostring(m))<2 then m="0"..m end
	return h..":"..m..meridien
end

local function format_timer(t,sec)
	local d="" if t>86400 then d=math.floor(t/86400) t=t-d*86400 d=d.."d" end
	local h=(d=="") and "" or "00" if t>3600 then h=math.floor(t/3600) t=t-h*3600 if string.len(tostring(h))<2 then h="0"..h end end
	if d~="" then return d..h.."h" end
	local m=(h=="") and "" or "00" if t>60 then m=math.floor(t/60) t=t-m*60 if string.len(tostring(m))<2 then m="0"..m end end
	local s="" if sec then s=math.floor(t*10)/10 if math.floor(s)==s then s=s..".0" end if string.len(tostring(s))<4 then s="0"..s end if m~="" then s="."..s end end
	if h=="" and s=="" then if m~="" then m=m.."m" else m="00" end end
	return d..h..(h~="" and ":" or "")..m..s
end

local function format_number(n)
	n=tostring(n)
	local k=1
--	local l=string.len(n) return (l>3) and string.sub(n,1,l-3).."."..string.sub(n,l-2,l) or n
	while k~=0 do n,k=string.gsub(n,"^(-?%d+)(%d%d%d)", '%1\'%2') end
	return n
end

local function UI_Init()
	if GlobalSettings.InfoPanel then
		ZO_PerformanceMeters:SetWidth(215)
		ZO_PerformanceMetersBg:SetWidth(345)
--		ZO_PerformanceMetersBg:ClearAnchors()
--		ZO_PerformanceMetersBg:SetAnchor(LEFT,ZO_PerformanceMeters,LEFT,-85,0)
		ZO_PerformanceMetersFramerateMeter:ClearAnchors()
		ZO_PerformanceMetersFramerateMeter:SetAnchor(LEFT,ZO_PerformanceMeters,LEFT,10,0)
		ZO_PerformanceMetersLatencyMeter:ClearAnchors()
		ZO_PerformanceMetersLatencyMeter:SetAnchor(LEFT,ZO_PerformanceMetersFramerateMeter,RIGHT,-3,0)
		ZO_PerformanceMetersBg:SetAlpha(GlobalSettings.Background/10)
--		ZO_PerformanceMetersBg:SetHidden(true)
		PERFORMANCE_METER_FRAGMENT:SetHiddenForReason("AnyOn",false,0,0)
	else
		ZO_PerformanceMeters:SetWidth(173)
		ZO_PerformanceMetersBg:SetWidth(256)
		ZO_PerformanceMetersBg:ClearAnchors()
		ZO_PerformanceMetersBg:SetAnchor(CENTER,ZO_PerformanceMeters,CENTER,0,0)
		ZO_PerformanceMetersFramerateMeter:ClearAnchors()
		ZO_PerformanceMetersFramerateMeter:SetAnchor(RIGHT,ZO_PerformanceMeters,CENTER,0,0)
		ZO_PerformanceMetersLatencyMeter:ClearAnchors()
		ZO_PerformanceMetersLatencyMeter:SetAnchor(LEFT,ZO_PerformanceMeters,CENTER,0,0)
		if UI_InfoPanel_Timer then UI_InfoPanel_Timer:SetHidden(true) end
		if UI_InfoPanel_Period then UI_InfoPanel_Period:SetHidden(true) end
		if UI_InfoPanel_Info then UI_InfoPanel_Info:SetHidden(true) end
		if UI_InfoPanel_ExpPS then UI_InfoPanel_ExpPS:SetHidden(true) end
		local anyOn=GetSetting_Bool(SETTING_TYPE_UI, UI_SETTING_SHOW_FRAMERATE) or GetSetting_Bool(SETTING_TYPE_UI, UI_SETTING_SHOW_LATENCY)
		PERFORMANCE_METER_FRAGMENT:SetHiddenForReason("AnyOn",not anyOn,0,0)
		return
	end

	local control=_G["UI_InfoPanel_Timer"]
	if not control then control=WINDOW_MANAGER:CreateControl("UI_InfoPanel_Timer", ZO_PerformanceMeters, CT_LABEL) end
	control:SetDimensions(0,40)
	control:ClearAnchors()
	control:SetAnchor(LEFT,ZO_PerformanceMetersLatencyMeter,RIGHT,-10,0)
	control:SetFont("ZoFontWinT1")
	control:SetColor(.8,.8,.7,1)
	control:SetHorizontalAlignment(1)
	control:SetVerticalAlignment(1)
	control:SetText("")
	control:SetHidden(false)

	control=_G["UI_InfoPanel_Period"]
	if not control then control=WINDOW_MANAGER:CreateControl("UI_InfoPanel_Period", ZO_PerformanceMeters, CT_LABEL) end
	control:SetDimensions(55,30)
	control:ClearAnchors()
	control:SetAnchor(TOP,UI_InfoPanel_Timer,BOTTOM,0,-16)
	control:SetFont("ZoFontWinT1")
	control:SetColor(1,1,.86,1)
	control:SetHorizontalAlignment(1)
	control:SetVerticalAlignment(1)
	control:SetText("")
	control:SetHidden(false)

	control=_G["UI_InfoPanel_Info"]
	if not control then control=WINDOW_MANAGER:CreateControl("UI_InfoPanel_Info", ZO_PerformanceMeters, CT_LABEL) end
	control:SetDimensions(1000,40)
	control:ClearAnchors()
	control:SetAnchor(LEFT,UI_InfoPanel_Timer,RIGHT,0,0)
	control:SetFont("ZoFontWinT2")
	control:SetColor(1,1,1,1)
	control:SetHorizontalAlignment(0)
	control:SetVerticalAlignment(1)
	control:SetText("")
	control:SetHidden(false)

	control=_G["UI_InfoPanel_ExpPS"]
	if not control then control=WINDOW_MANAGER:CreateControl("UI_InfoPanel_ExpPS", ZO_PerformanceMeters, CT_CONTROL) end
	control:SetDimensions(icon_p_size1+55,40)
	control:ClearAnchors()
	control:SetAnchor(LEFT,UI_InfoPanel_Info,RIGHT,0,0)
	control:SetHidden(GlobalSettings.ExpPS==3)
	control:SetMouseEnabled(true)
	control:SetHandler("OnMouseDown", function(self,button) if button==2 then TimeLastExp=0 UI_InfoPanel_ExpPS_Text:SetText("0/s") end end)
	control:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, BOTTOMRIGHT, "RMB: Clear counter") end)
	control:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip(self) end)
	expps_w=GlobalSettings.ExpPS~=3 and icon_p_size3+55 or 0
	panel_last_w=0

	control=_G["UI_InfoPanel_ExpPS_Icon"]
	if not control then control=WINDOW_MANAGER:CreateControl("UI_InfoPanel_ExpPS_Icon", UI_InfoPanel_ExpPS, CT_TEXTURE) end
	control:SetDimensions(icon_p_size1,icon_p_size1)
	control:ClearAnchors()
	control:SetAnchor(LEFT,UI_InfoPanel_Info,RIGHT,0,0)
	control:SetTexture(ExpIcon[GlobalSettings.ExpPS])

	control=_G["UI_InfoPanel_ExpPS_Text"]
	if not control then control=WINDOW_MANAGER:CreateControl("UI_InfoPanel_ExpPS_Text", UI_InfoPanel_ExpPS, CT_LABEL) end
	control:SetDimensions(50,40)
	control:ClearAnchors()
	control:SetAnchor(RIGHT,UI_InfoPanel_ExpPS,RIGHT,0,0)
	control:SetFont("ZoFontWinT2")
	control:SetColor(.8,.8,.7,1)
	control:SetHorizontalAlignment(0)
	control:SetVerticalAlignment(1)
	control:SetText("0/s")

	ZO_PerformanceMeters:SetScale((GlobalSettings.Scale+10)/10)
end

local function GetAchievementPoints()
	local total,available=GetEarnedAchievementPoints(),GetTotalAchievementPoints()
	local pct=math.floor(total/available*100)
	achievements1=zo_iconFormat(Settings[27].icon,icon_p_size1,icon_p_size1).." |cCCCCAA"..format_number(total).."("..pct.."%)|r"
	achievements2=zo_iconFormat(Settings[27].icon,icon_p_size1,icon_p_size1).." |cCCCCAA"..format_number(total).."("..pct.."%)/"..format_number(available).."|r"
end

local function OnBagpackAdded(bagId, slotIndex, slotData)
	if bagId~=BAG_BACKPACK then return end
--	if slotData then d("Added: "..tostring(slotData.name)..", count: "..tostring(slotData.stackCount)..", itemType: "..tostring(slotData.itemType)) end
end

local function OnBagpackRemoved(bagId, slotIndex, slotData)
	if bagId~=BAG_BACKPACK then return end
--	if slotData then d("Removed: "..tostring(slotData.name)..", count: "..tostring(slotData.stackCount)..", itemType: "..tostring(slotData.itemType)) end
end

local function OnBackpackChanged(_, bagId, slotId, isNewItem, itemSoundCategory)
	if bagId==BAG_BACKPACK and GlobalSettings.BagSpace~=3 then
		local used,available=GetNumBagUsedSlots(1),GetBagUseableSize(1)
		local color=(used>available-10) and "|cCC2222" or ((used>available-50) and "|cCCCC00" or "|cFFFFFF")
		bag_space1=zo_iconFormat(Settings[5].icon,icon_p_size1,icon_p_size1).." "..color..(available-used).."|r"
		bag_space2=zo_iconFormat(Settings[5].icon,icon_p_size1,icon_p_size1).." "..color..used.."|cCCCCAA/"..available.."|r"
	end
	if isNewItem then
		--
	elseif GlobalSettings.ReelAlert and itemSoundCategory==ITEM_SOUND_CATEGORY_LURE and (bagId==BAG_BACKPACK or bagId==BAG_VIRTUAL) then
		local action=GetGameCameraInteractableActionInfo()
		if action==GetString(SI_GAMECAMERAACTIONTYPE17) then
			if BUI and BUI.OnScreen then
				BUI.OnScreen.Notification(12,Localization[lang].reel,SOUNDS.BOOK_ACQUIRED)
			else
				local messageParams=CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_MAJOR_TEXT, SOUNDS.BOOK_ACQUIRED)
				messageParams:SetText("|t32:32:/esoui/art/tutorial/gamepad/achievement_categoryicon_fishing.dds|t "..Localization[lang].reel)
				CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
			end
		end
	end
end
--	/script zo_callLater(function()local _,name=GetGameCameraInteractableActionInfo()StartChatInput(name)end,1000)
local function BankSpace()
	local used,available=GetNumBagUsedSlots(BAG_BANK),GetBagUseableSize(BAG_BANK)
	if IsESOPlusSubscriber() then
		used=used+GetNumBagUsedSlots(BAG_SUBSCRIBER_BANK)
		available=available+GetBagUseableSize(BAG_SUBSCRIBER_BANK)
	end
	local color=(used>available-10) and "|cCC2222" or ((used>available-50) and "|cCCCC00" or "|cCCCCAA")
	bank_space1=zo_iconFormat(Settings[6].icon,icon_p_size1,icon_p_size1).." "..color..(available-used).."|r"
	bank_space2=zo_iconFormat(Settings[6].icon,icon_p_size1,icon_p_size1).." "..color..used.."|cCCCCAA/"..available.."|r"
end

local function ScanInventory()
	local bag=SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK)
	StolenItems=0
	for _, data in pairs(bag) do
		if GlobalSettings.Fence then
			if IsItemStolen(data.bagId,data.slotIndex) then StolenItems=StolenItems+GetSlotStackSize(data.bagId,data.slotIndex) end
		end
		for id in pairs(Items) do
			if id==GetItemId(data.bagId,data.slotIndex) then Items[id].slotIndex=data.slotIndex end
		end
	end
end

local function GetItemCount(id)
	local count=(Items[id].slotIndex) and GetItemTotalCount(BAG_BACKPACK,Items[id].slotIndex) or 0
	local color=(count<=5) and "|cCC2222" or "|cFFFFFF"
	return zo_iconFormat(Items[id].icon,icon_p_size1,icon_p_size1).." "..color..count.."|r ", string.len(tostring(count))
end

local function GetFenceInfo()
	local totalLaunders,laundersUsed,resetTimeSeconds=GetFenceLaunderTransactionInfo()
	local totalSells,sellsUsed,resetTimeSeconds=GetFenceSellTransactionInfo()
	FenceSells=totalSells-sellsUsed
	FenceLaunders=totalLaunders-laundersUsed
end
--	/script d(AreAnyItemsStolen(BAG_BACKPACK))
local function GetRT()
	local t=math.floor(GetFormattedTime()/100)
	local h=math.floor(t/100)
	local m=t%100
	local tstring=format_time(h,m)
	return zo_iconFormat(Settings[11].icon,icon_p_size1,icon_p_size1).."|cCCCCAA"..tstring.."|r", string.len(tstring)
end

local function GetTT()
	local day,night=20955,7200
	local tSinceMidnight=GetTimeStamp()-(1398044126-night/2-(day-night)/2)
	local daysPast=day*math.floor(tSinceMidnight/day)
	local s=tSinceMidnight-daysPast
	local t=24*s/day
	local h=math.floor(t) t=(t-h)*60
	local m=math.floor(t) t=(t-m)*60
	local icon=(h>=4 and h<22) and zo_iconFormat("/esoui/art/tutorial/cadwell_indexicon_gold_up.dds",icon_p_size3,icon_p_size3) or zo_iconFormat("/esoui/art/tutorial/cadwell_indexicon_silver_up.dds",icon_p_size3,icon_p_size3)
	local tstring=format_time(h,m)
	return icon.."".."|cCCCCAA"..tstring.."|r", string.len(tstring)
end

local function GetXP()
	local icon="/esoui/art/icons/icon_experience.dds"
	local color={1,1,1,1}
	local current, effectiveMax
	local level=GetUnitLevel('player')
	if level>=50 then
		icon="/esoui/art/champion/champion_icon_32.dds"
		color={.8,.9,0,1}
		level=GetPlayerChampionPointsEarned()
--[[	<100034
		local poolSize=0
		local rank=GetChampionPointAttributeForRank(level+1)
		if (rank==1) then icon="/esoui/art/champion/champion_points_health_icon-hud-32.dds" color={0.6,0.2,0,1}
		elseif (rank==2) then icon="/esoui/art/champion/champion_points_magicka_icon-hud-32.dds" color={0,0.3,0.8,1}
		else icon="/esoui/art/champion/champion_points_stamina_icon-hud-32.dds" color={0.3,0.6,0.1,1} end
--]]
		effectiveMax=GetNumChampionXPInChampionPoint(level) current=GetPlayerChampionXP()	--poolSize=self:GetEnlightenedPool()
	else
		effectiveMax=GetUnitXPMax('player') current=GetUnitXP('player')
	end
	pct=math.floor(current/effectiveMax*100)	--Enlightpct=math.floor(current/poolSize*100)
	return zo_iconFormat(icon,icon_p_size1,icon_p_size1).." "..level.." |cCCCCAA"..pct.."%|r", 7
end

local function GetStable()
	local t=GetTimeUntilCanBeTrained() t=t/1000
	local color=(t<=180) and "|cCC2222" or "|cCCCCAA"
	local tstring=format_timer(t)
	return zo_iconFormat(Settings[15].icon,icon_p_size1,icon_p_size1).." "..color..tstring.."|r", string.len(tstring)
end
--	/script d("|t26:26:/esoui/art/icons/icon_experience.dds|t abcde")
local function GetCurency(currencyType)
	local location=(currencyType==CURT_CHAOTIC_CREATIA or currencyType==CURT_UNDAUNTED_KEYS or currencyType==CURT_EVENT_TICKETS) and CURRENCY_LOCATION_ACCOUNT or CURRENCY_LOCATION_CHARACTER
	local amount=GetCurrencyAmount(currencyType, location)
	local icon=GetCurrencyKeyboardIcon(currencyType)
	local color=(currencyType==CURT_MONEY and amount<1000) and "|cCC2222" or "|cFFFFFF"
	return zo_iconFormat(icon,icon_p_size1,icon_p_size1).." "..color..format_number(amount).."|r", string.len(tostring(amount))
end

local function GetSmithing()
	local _min=research_sec-GetGameTimeMilliseconds()/1000
	if _min<0 then _min=0 end
	_min=(researching) and " ("..format_timer(_min)..")" or ""
	local color=(research_cur<research_max) and "|cCC2222" or "|cFFFFFF"
	return zo_iconFormat(ResearchIcon,icon_p_size2,icon_p_size2).." "..color..research_cur.."|cCCCCAA/"..research_max.._min.."|r", string.len(research_cur..research_max.._min)
end

local function ScanSmithing()
	ResearchIcon=ResearchIcons[2]
	local SkillTypes={1,2,6,7}
	local rows={[1]=14,[2]=14,[6]=6,[7]=2}
	local knownTotal,_cur,_max,_min=0,0,0,5184000
	for _,i in pairs(SkillTypes) do
		local knownInType=0
		for row=1,rows[i] do
			for trait=1,9 do
				local _,remain=GetSmithingResearchLineTraitTimes(i, row, trait)
				remain=(remain) or 0
				if remain>0 then
					_cur=_cur+1
					if remain<_min then _min=remain ResearchIcon=ResearchIcons[i] end
				end
				local _t,_d,_k=GetSmithingResearchLineTraitInfo(i, row, trait)
				knownTotal=(_k) and knownTotal+1 or knownTotal
				knownInType=(_k) and knownInType+1 or knownInType
			end
		end
		local to_research=rows[i]*9-knownInType
		_max=_max+math.min(GetMaxSimultaneousSmithingResearch(i),to_research)
--		pl("Known traits: "..knownInType.." in type "..i.." ("..to_research.." to research)")
	end
	research_max=_max
	research_cur=_cur
	researching=_min~=5184000
	research_sec=_min+GetGameTimeMilliseconds()/1000
--	if knownTotal==324 then smithing=false end
--	pl("Known traits total: "..knownTotal.."/324")
end

local function GetFishing(zone)
	zone=zone or GetCurrentMapZoneIndex()
	FishingText=""
	FishingWidth=0
	local id=FishingZones[zone]
	if id then
		local total={Lake=0,Foul=0,River=0,Salt=0,Oily=0,Mystic=0,Running=0}
		for i=1,GetAchievementNumCriteria(id) do
			local AchName,a,b=GetAchievementCriterion(id,i)
			if FishingBugFix[id] and FishingBugFix[id][i] then
				total[ FishingBugFix[id][i] ]=total[ FishingBugFix[id][i] ]+b-a
			else
				for water in pairs(total) do
					if string.match(AchName,"("..Localization[lang][water]..")")~=nil then
						total[water]=total[water]+b-a
					end
				end
			end
		end
		for water,count in pairs(total) do
			if count>0 then
				FishingText=FishingText..(FishingText~="" and " " or "")..zo_iconFormat(FishIcon[water],icon_p_size2,icon_p_size2).." "..count
				FishingWidth=FishingWidth+(FishingWidth==0 and fs or 0)+icon_p_size2+2*fs
			end
		end
	end
end

function InfoPanel.Update()
	panel_w=fs
	local info=""
	if GlobalSettings.Memory then
		info=info..(info=="" and "" or "")..zo_iconFormat(Settings[2].icon,icon_p_size3,icon_p_size3).."|cFFFFFF"..math.floor(collectgarbage("count")/1024).."mb|r"
		panel_w=panel_w+icon_p_size3+6*fs
	end
	if GlobalSettings.BagSpace==1 then
		info=info..(info=="" and "" or "  ")..bag_space1
		panel_w=panel_w+icon_p_size1+4*fs
	elseif GlobalSettings.BagSpace==2 then
		info=info..(info=="" and "" or "  ")..bag_space2
		panel_w=panel_w+icon_p_size1+8*fs
	end
	if GlobalSettings.BankSpace==1 then
		info=info..(info=="" and "" or "  ")..bank_space1
		panel_w=panel_w+icon_p_size1+4*fs
	elseif GlobalSettings.BankSpace==2 then
		info=info..(info=="" and "" or "  ")..bank_space2
		panel_w=panel_w+icon_p_size1+8*fs
	end
	for id in pairs(Items) do
		if GlobalSettings[id] then
			local text,w=GetItemCount(id)
			info=info..(info=="" and "" or "  ")..text
			panel_w=panel_w+icon_p_size1+(w+2)*fs
		end
	end
	if GlobalSettings.RealTime then
		local text,w=GetRT()
		info=info..(info=="" and "" or " ")..text
		panel_w=panel_w+icon_p_size3+(w+1)*fs
	end
	if GlobalSettings.TamrielTime then
		local text,w=GetTT()
		info=info..(info=="" and "" or " ")..text
		panel_w=panel_w+icon_p_size3+(w+1)*fs
	end
	if CharacterSettings.Experience then
		local text,w=GetXP()
		info=info..(info=="" and "" or "  ")..text
		panel_w=panel_w+icon_p_size1+(w+2)*fs
	end
	if GlobalSettings.Stable and stable then
		local text,w=GetStable()
		info=info..(info=="" and "" or "  ")..text
		panel_w=panel_w+icon_p_size1+(w+2)*fs
	end
	if GlobalSettings.Smithing and researching then
		local text,w=GetSmithing()
		info=info..(info=="" and "" or "  ")..text
		panel_w=panel_w+icon_p_size2+(w+2)*fs
	end
	if GlobalSettings.AP then
		local text,w=GetCurency(CURT_ALLIANCE_POINTS)
		info=info..(info=="" and "" or "  ")..text
		panel_w=panel_w+icon_p_size1+(w+2)*fs
	end
	if GlobalSettings.Gold then
		local text,w=GetCurency(CURT_MONEY)
		info=info..(info=="" and "" or "  ")..text
		panel_w=panel_w+icon_p_size1+(w+2)*fs
	end
	if GlobalSettings.Telvar then
		local text,w=GetCurency(CURT_TELVAR_STONES)
		info=info..(info=="" and "" or "  ")..text
		panel_w=panel_w+icon_p_size1+(w+2)*fs
	end
	if GlobalSettings.Vouchers then
		local text,w=GetCurency(CURT_WRIT_VOUCHERS)
		info=info..(info=="" and "" or "  ")..text
		panel_w=panel_w+icon_p_size1+(w+2)*fs
	end
	if GlobalSettings.Transmutation then
		local text,w=GetCurency(CURT_CHAOTIC_CREATIA)
		info=info..(info=="" and "" or "  ")..text
		panel_w=panel_w+icon_p_size1+(w+2)*fs
	end
	if GlobalSettings.UndauntedKeys then
		local text,w=GetCurency(CURT_UNDAUNTED_KEYS)
		info=info..(info=="" and "" or "  ")..text
		panel_w=panel_w+icon_p_size1+(w+2)*fs
	end
	if GlobalSettings.EventTickets then
		local text,w=GetCurency(CURT_EVENT_TICKETS)
		info=info..(info=="" and "" or "  ")..text
		panel_w=panel_w+icon_p_size1+(w+2)*fs
	end
	if GlobalSettings.Fence and StolenItems>0 then
		local text=StolenItems
		panel_w=panel_w+icon_p_size1+(string.len(text)+1)*fs
		if FenceSells~=FenceLaunders then text=text.." |cCCCCAA/"..FenceSells..","..FenceLaunders.."|r" panel_w=panel_w+(string.len(FenceSells..FenceLaunders)+1)*fs end
		info=info..(info=="" and "" or "  ")..zo_iconFormat(Settings[24].icon,icon_p_size1,icon_p_size1)..text
	end
	if GlobalSettings.Apparel then
		info=info..(info=="" and "" or "  ")..zo_iconFormat(Settings[25].icon,icon_p_size1,icon_p_size1).." "..((WornCondition<=10) and "|cCC2222" or "|cCCCCAA")..WornCondition.."%|r"
		panel_w=panel_w+icon_p_size1+(WornCondition<100 and 4.5 or 5)*fs
	end
	if GlobalSettings.Weapons then
		info=info..(info=="" and "" or "  ")..zo_iconFormat(Settings[26].icon,icon_p_size1,icon_p_size1).." "..((MinCharge<=10) and "|cCC2222" or "|cCCCCAA")..MinCharge.."%|r"
		panel_w=panel_w+icon_p_size1+(MinCharge<100 and 4.5 or 5)*fs
	end
	if GlobalSettings.Achievements==1 then
		info=info..(info=="" and "" or "  ")..achievements1
		panel_w=panel_w+icon_p_size1+11*fs
	elseif GlobalSettings.Achievements==2 then
		info=info..(info=="" and "" or "  ")..achievements2
		panel_w=panel_w+icon_p_size1+17*fs
	end
	if GlobalSettings.Skyshards then
		info=info..(info=="" and "" or "  ")..(zo_iconFormat(Settings[28].icon,icon_p_size2,icon_p_size2).." ".."|cCCCCAA"..GetNumSkyShards().."|r")
		panel_w=panel_w+icon_p_size2+3*fs
	end
--[[
	if ESOPlusSubscriber then
		local timeleft=GlobalSettings.ESOPlus-GetTimeStamp()
		if timeleft>0 then
			info=info..(info=="" and "" or "  ")..(zo_iconFormat(Settings[27].icon,icon_p_size2,icon_p_size2).." ".."|cCCCCAA"..format_timer(timeleft).."|r")
			panel_w=panel_w+icon_p_size2+7*fs
		end
	end
--]]
	if GlobalSettings.TrialInfo and RaidTargetTime>0 then
		local duration=GetRaidDuration()/1000
		local t1=(duration>60 and duration<2000000) and format_timer(duration) or "0m"
--		local t2=format_timer(RaidTargetTime)
		local score=GetCurrentRaidScore()/1000
		local t3=score>0 and ": "..score.."K" or ""
		info=info..(info=="" and "" or "  ")..zo_iconFormat(Settings[32].icon,icon_p_size2,icon_p_size2).." "..t1..t3	--"|cCCCCAA/"..t2.."|r"
		panel_w=panel_w+icon_p_size2+(string.len(t1..t3)+4)*fs
	end
	if GlobalSettings.DungeonInfo and DungeonStartTime>0 then
		local duration=(GetGameTimeMilliseconds()-DungeonStartTime)/1000
		local t1=duration>60 and format_timer(duration) or "0m"
		info=info..(info=="" and "" or "  ")..zo_iconFormat(Settings[33].icon,icon_p_size2,icon_p_size2).." "..t1
		panel_w=panel_w+icon_p_size2+(string.len(t1)+1)*fs
	end
	if GlobalSettings.DungeonChests and DungeonStartTime>0 then
		info=info..(info=="" and "" or "  ")..zo_iconFormat(Settings[34].icon,icon_p_size2,icon_p_size2).." "..ChestsLooted.."|cCCCCAA/2"
		panel_w=panel_w+icon_p_size2+5*fs
	end
	if CharacterSettings.FishingAchivement and FishingWidth>0 then
		info=info..(info=="" and "" or "  ")..FishingText
		panel_w=panel_w+FishingWidth
	end
	if GlobalSettings.Hirelings and CharacterSettings.Hireling then
		local delay=CharacterSettings.Hireling-GetTimeStamp()
		if delay>0 then
			info=info..(info=="" and "" or "  ")..(zo_iconFormat(Settings[35].icon,icon_p_size2,icon_p_size2).." ".."|cCCCCAA"..format_timer(delay).."|r")
			panel_w=panel_w+icon_p_size2+5*fs
		end
	end
	UI_InfoPanel_Info:SetText(info)
--	panel_w=UI_InfoPanel_Info:GetTextWidth()
	if panel_last_w~=panel_w+expps_w then
		panel_last_w=panel_w+expps_w
		UI_InfoPanel_Info:SetWidth(panel_w)
		ZO_PerformanceMeters:SetWidth(132+panel_w+timer_w+expps_w)	--157
		ZO_PerformanceMetersBg:SetWidth((132+panel_w+timer_w+expps_w)*1.5)
	end
end

local function TimerUpdate()
	local now=GetGameTimeMilliseconds()
	local delta=DungeonBossTimer and (timer_start-now)/1000 or (now-timer_start)/1000
	if delta<0 or delta>5999 then InfoPanel.TimerStop() return end
	local text=format_timer(delta,true)
	if timer_period>0 then
		UI_InfoPanel_Period:SetText(format_timer((timer_period)/1000,true))
	end
	UI_InfoPanel_Timer:SetText(text)
end

function InfoPanel.TimerStart(IsDungeonBoss)
	if GlobalSettings.Timer and GlobalSettings.InfoPanel then
		local now=GetGameTimeMilliseconds()
		if now-timer_start<200 then return end
		DungeonBossTimer=IsDungeonBoss
		timer_w=55
		if now-timer_start<360000 then timer_period=now-timer_start end
		timer_start=now+(IsDungeonBoss and 240000 or 0)
		UI_InfoPanel_Timer:SetWidth(timer_w)
		ZO_PerformanceMeters:SetWidth(157+panel_w+timer_w+expps_w) ZO_PerformanceMetersBg:SetWidth((157+panel_w+timer_w+expps_w)*1.7)
		EVENT_MANAGER:RegisterForUpdate("InfoPanel_Timer", 100, TimerUpdate)
	end
end

function InfoPanel.TimerStop()
	timer_w=0
	timer_period=0
	timer_start=0
	UI_InfoPanel_Timer:SetWidth(0)
	UI_InfoPanel_Timer:SetText("")
	UI_InfoPanel_Period:SetText("")
	ZO_PerformanceMeters:SetWidth(157+panel_w+timer_w) ZO_PerformanceMetersBg:SetWidth((157+panel_w+timer_w)*1.7)
	EVENT_MANAGER:UnregisterForUpdate("InfoPanel_Timer")
end

local function AutoRepairStore()
	local cost=GetRepairAllCost()
	if cost>0 and CanStoreRepair() then
		RepairAll()
		if GlobalSettings.ChatOutput then 
			d(zo_strformat("<<1>> <<2>> |cFFFFFF<<3>>|r<<4>>", GetString(SI_EQUIPSLOTVISUALCATEGORY2), Localization[lang].s_repaired, cost, zo_iconFormat(Settings[18].icon,icon_p_size1,icon_p_size1)))
		end
	end
end

local function RepairItem(bagId,slotIndex)
	if not (Items[kit_id].slotIndex and IsItemRepairKit(BAG_BACKPACK,Items[kit_id].slotIndex)) then ScanInventory() end
	local count=(Items[kit_id].slotIndex) and GetItemTotalCount(BAG_BACKPACK,Items[kit_id].slotIndex) or 0
	if count<1 then return -1 end
	local amount=GetAmountRepairKitWouldRepairItem(bagId,slotIndex,BAG_BACKPACK,Items[kit_id].slotIndex)
	local condition=GetItemCondition(bagId,slotIndex)
	if condition>minPercent then return 0 end
	local oldcondition=condition
	RepairItemWithRepairKit(bagId,slotIndex,BAG_BACKPACK,Items[kit_id].slotIndex)
--	d(GetItemLink(bagId,slotIndex,LINK_STYLE_DEFAULT).." "..condition.." "..amount)
	condition=condition+amount
	if condition>100 then condition=100 end
	return condition-oldcondition
end

local function ChargeItem(bagId,slotIndex)
	if not (Items[gem_id].slotIndex and IsItemSoulGem(BAG_BACKPACK,Items[gem_id].slotIndex)) then ScanInventory() end
	local count=(Items[gem_id].slotIndex) and GetItemTotalCount(BAG_BACKPACK,Items[gem_id].slotIndex) or 0
	if count<1 then return -1 end
	local charge,maxcharge=GetChargeInfoForItem(bagId,slotIndex)
	if MinCharge>charge/maxcharge*100 then MinCharge=math.floor(charge/maxcharge*100) end
--	d(GetItemLink(bagId,slotIndex,LINK_STYLE_DEFAULT).." "..charge/maxcharge*100)
	if charge/maxcharge*100>minPercent then return 0 end
	local oldcharge=charge
	local amount=GetAmountSoulGemWouldChargeItem(bagId,slotIndex,BAG_BACKPACK,Items[gem_id].slotIndex)
	ChargeItemWithSoulGem(bagId,slotIndex,BAG_BACKPACK,Items[gem_id].slotIndex)
	if (charge+amount)<maxcharge then charge=charge+amount else charge=maxcharge end
	return (charge-oldcharge)/maxcharge*100
end

local function ScanWornCondition()
	WornCondition=100
	for _,slot in pairs(repair_slots) do
		if DoesItemHaveDurability(BAG_WORN, slot) then
			_cond=GetItemCondition(BAG_WORN, slot)
			if _cond<WornCondition then WornCondition=_cond end
			if _cond==0 and GlobalSettings.ChatOutput then d(GetItemName(BAG_WORN, slot)..Localization[lang].damaged) end
		end
	end
end
--	/script slot=EQUIP_SLOT_OFF_HAND d("["..slot.."] "..GetItemName(BAG_WORN, slot).." - "..GetItemCondition(BAG_WORN, slot).." "..tostring(DoesItemHaveDurability(BAG_WORN, slot)))
local function OnComabatState()
	if IsUnitDead("player") then return end
	if GlobalSettings.AutoRepairKit then	-- and WornCondition<=minPercent
		local total=0
		local str
		if GlobalSettings.Apparel then WornCondition=100 end
		for i,slot in pairs(repair_slots) do
			if DoesItemHaveDurability(BAG_WORN, slot) then
				if GlobalSettings.AutoRepairKit then
					total=RepairItem(BAG_WORN,slot)
					if total==-1 then
						if GlobalSettings.ChatOutput then
							local now=GetGameTimeMilliseconds()
							if lastoutput<now then
								lastoutput=now+60000
								d(Localization[lang].no_kit)
							end
						end break
					elseif total>0 and GlobalSettings.ChatOutput then
						str=(str or Localization[lang].c_repaired)..((str and ", ") or "")..slot_name[slot].." ("..math.floor(total).." %)"
					end
				end
				if GlobalSettings.Apparel then
					_cond=GetItemCondition(BAG_WORN, slot)
					if _cond<WornCondition then WornCondition=_cond end
					if _cond==0 and GlobalSettings.ChatOutput then d(GetItemName(BAG_WORN, slot).." is damaged") end
				end
			end
		end
		if str~=nil then
			if GlobalSettings.ChatOutput then d(str) end
			if GlobalSettings.InfoPanel then
				zo_callLater(function()ScanWornCondition()InfoPanel.Update()end,1200)
			end
		end
	end
end

local function OnPairChanged(_,Pair)
	MinCharge=100
	local total=0
	local str
	for i,slot in pairs(recharge_slots) do
		if IsItemChargeable(BAG_WORN, slot) then
			if GlobalSettings.AutoRecharge then
				total=ChargeItem(BAG_WORN,slot)
				if total==-1 then
					if GlobalSettings.ChatOutput then
						local now=GetGameTimeMilliseconds()
						if lastoutput<now then
							lastoutput=now+60000
							d(Localization[lang].no_gem)
						end
					end break
				elseif total>0 and GlobalSettings.ChatOutput then
					str=(str or Localization[lang].c_charged)..((str and ", ") or "")..slot_name[slot].." ("..math.floor(total).." %)"
				end
			end
			if GlobalSettings.Weapons then
				local charge,maxcharge=GetChargeInfoForItem(BAG_WORN,slot)
				if MinCharge>charge/maxcharge*100 then MinCharge=math.floor(charge/maxcharge*100) end
				if MinCharge==0 and GlobalSettings.ChatOutput then d(GetItemName(BAG_WORN, slot)..Localization[lang].discharged) end
			end
		end
	end
	if str~=nil then
		if GlobalSettings.ChatOutput then d(str) end
		if GlobalSettings.InfoPanel then InfoPanel.Update() end
	end
end

local function OnLootReceived(_,_,itemName,_,_,lootType,self)
	if self and lootType==LOOT_TYPE_ITEM then
		if GlobalSettings.Fence then ScanInventory() end
		if GlobalSettings.BossTimer then
			local itemIsSet=GetItemLinkSetInfo(itemName)
			if itemIsSet and GetUnitDifficulty('reticleover')==2 and GetMapContentType()==MAP_CONTENT_DUNGEON then InfoPanel.TimerStart(true) end
		end
	end
end

local function OnExpUpdate(_,unitTag,currentExp,maxExp,reason)
	if unitTag~='player' then return end
--	d("["..reason.."] "..currentExp-StartExp.."/"..LastExp.." "..tostring(Exp[reason]))
	if Exp[reason] then
		if GlobalSettings.ExpPS==1 then
			local now=GetGameTimeMilliseconds()
			if TimeLastExp+ExpDelay<now then TimeStartExp=now TimeLastExp=now StartExp=currentExp end
			UI_InfoPanel_ExpPS_Text:SetText(math.floor((currentExp-StartExp)/math.max((now-TimeStartExp)/1000,1)).."/s")
		end
		if GlobalSettings.ExPgain then
			local experience=currentExp-LastExp
			if experience>=5000 then
				d(string.format('|c22CC22Experience gain:|r %s%s',format_number(experience),zo_iconFormat(Settings[40].icon,icon_p_size2,icon_p_size2),reason))
			end
		end
	end
	LastExp=currentExp
end

local function OnApUpdate(_,alliancePoints,playSound,difference,reason)
	if GlobalSettings.ExpPS==2 and AP[reason] then
		local now=GetGameTimeMilliseconds()
		if TimeLastExp+ExpDelay<now then TimeStartExp=now TimeLastExp=now StartExp=alliancePoints end
		UI_InfoPanel_ExpPS_Text:SetText(math.floor((alliancePoints-StartExp)/math.max((now-TimeStartExp)/1000,1)).."/s")
	end

	if GlobalSettings.APgain and playSound and difference>=1000 then
		d("|c22CC22AP gain:|r "..format_number(difference)..zo_iconFormat(Settings[38].icon,icon_p_size2,icon_p_size2))	--.."("..tostring(reason)..")")
	end
end

local function OnTelvarGain(_,newTelvarStones,oldTelvarStones,reason)
	if reason==35 then return end
	if GlobalSettings.ExpPS==4 then
		local now=GetGameTimeMilliseconds()
		if TimeLastExp+ExpDelay<now then TimeStartExp=now TimeLastExp=now StartExp=newTelvarStones end
		UI_InfoPanel_ExpPS_Text:SetText(math.floor((newTelvarStones-StartExp)/math.max((now-TimeStartExp)/1000,1)).."/s")
	end

	if GlobalSettings.TelvarGain then
		local stones=newTelvarStones-oldTelvarStones
		if stones>=500 then
			d(string.format('|cAA22AATelvar gain:|r %s%s',format_number(stones),zo_iconFormat(Settings[39].icon,icon_p_size2,icon_p_size2),reason))
		end
	end
end

local function OnAchievementUpdate(_,achievementId,link)
	if CharacterSettings.FishingAchivement and FishingAchievements[achievementId] then PlaySound("Achievement_Awarded") GetFishing() InfoPanel.Update() end
	if GlobalSettings.Achievement_up then
		local AchName,a,b="",0,0
		for i=1,GetAchievementNumCriteria(achievementId) do
			local AchName,a1,b1=GetAchievementCriterion(achievementId,i)
			a=a+a1 b=b+b1
		end
		local blockAchievement={[55]=true,[42]=true,[1776]=true,[1779]=true,[1782]=true,[1785]=true,[1787]=true,[1788]=true,[1791]=true,[2218]=true,[2219]=true}
--		local isCompleted=IsAchievementComplete(achievementId)
		if (b<1000 and (b<25 or a%10==0 or not informedAchievement[achievementId]) and not blockAchievement[achievementId]) or IsAchievementComplete(achievementId) then	--(b==1 or isCompleted) and (a~=b or isCompleted) and
			link=link or GetAchievementLink(achievementId,LINK_STYLE_BRACKETS)
--	/script d(GetFirstAchievementInLine(1463))
--	/script d(GetAchievementLink(1456,LINK_STYLE_BRACKETS))
--	/script d(zo_iconFormat(select(4,GetAchievementInfo(1456)),18,18)
			d("["..achievementId.."] "..zo_iconFormat(select(4,GetAchievementInfo(achievementId)),18,18).." "..(link and link or AchName).." "..a.."/"..b)
			informedAchievement[achievementId]=true
		end
	end
end

local function OnInteract(_,result,TargetName)
--	d("Interact: "..TargetName)
	if result==CLIENT_INTERACT_RESULT_SUCCESS and IsChest[TargetName] then
		local x,y,_=GetMapPlayerPosition("player") x=math.floor(x*10000)/10000 y=math.floor(y*10000)/10000
		local delta=0.003
		if math.abs(LastChest.x-x)>delta and math.abs(LastChest.y-y)>delta then
			LastChest={x=x,y=y}
			ChestsLooted=ChestsLooted+1
			InfoPanel.Update()
		end
	end
end

local Hireling={
["Raw Blacksmith Materials"]={8,2,3},["Raw Clothier Materials"]={8,3,3},["Raw Woodworker Materials"]={8,7,3},["Raw Enchanter Materials"]={8,4,4},["Raw Provisioner Materials"]={8,6,7},
["Сырье для кузнеца"]={8,2,3},
["Сырье для портного"]={8,3,3},
["Сырье для столяра"]={8,7,3},
["Сырье для зачарователя"]={8,4,4},
["Сырье для снабженца"]={8,6,7},["Schmiedematerial"]={8,2,3},["Schneidermaterial"]={8,3,3},["Schreinermaterial"]={8,7,3},["Verzauberermaterial"]={8,4,4},["Versorgerzutaten"]={8,6,7},["Matériaux bruts de forge"]={8,2,3},["Matériaux bruts de couture"]={8,3,3},["Matériaux bruts de travail du bois"]={8,7,3},["Matériaux bruts d'enchantement"]={8,4,4},["Matériaux bruts de cuisine"]={8,6,7},["鍛冶師用素材"]={8,2,3},["仕立師用素材"]={8,3,3},["木工師用素材"]={8,7,3},["付呪師用素材"]={8,4,4},["調理師用素材"]={8,6,7},
}

local function OnMail(_,numUnread)
	if numUnread==0 then return end
	EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event1",EVENT_MAIL_NUM_UNREAD_CHANGED)
--	d("Mails: "..numUnread)
	RequestOpenMailbox()
	local function CheckMail()
		local subj,last,sender
		for mailId in ZO_GetNextMailIdIter do
			local senderId,_,subject,_,unread,fromSystem,_,_,_,_,_,_,secsSinceReceived=GetMailItemInfo(mailId)
--			d(subject..": unread "..tostring(unread).." sys: "..tostring(fromSystem).." sec:"..secsSinceReceived)
			if unread and secsSinceReceived<30 then
				last=secsSinceReceived
				if fromSystem then
					subj=subject sender=subject
				else
					timestamp=GetTimeStamp()-last
					if GlobalSettings.LatestMail<timestamp then
						sender="from "..senderId subj=subject GlobalSettings.LatestMail=timestamp
					end
				end
			end
		end
		if subj and Hireling[subj] then
			sender="from Hireling"
			if not CharacterSettings.Hireling or (CharacterSettings.Hireling and CharacterSettings.Hireling-GetTimeStamp()<=0) then
				local delay=(3-math.min(GetSkillAbilityUpgradeInfo(unpack(Hireling[subj])),2))*43200
				CharacterSettings.Hireling=GetTimeStamp()+delay-last
			end
		end
		if sender then
--			d("New mail "..sender..(subj and ": "..subj or ""))
		end
		CloseMailbox()
		InfoPanel.Update()
	end
	zo_callLater(CheckMail,300)
end

local function OnActivated()
	if GlobalSettings.Hirelings then
		if not CharacterSettings.Hireling or (CharacterSettings.Hireling and CharacterSettings.Hireling-GetTimeStamp()<=0) then
			EVENT_MANAGER:RegisterForEvent("InfoPanel_Event1",EVENT_MAIL_NUM_UNREAD_CHANGED,OnMail)
			zo_callLater(function()EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event1",EVENT_MAIL_NUM_UNREAD_CHANGED)end,4000)
		end
	end
	local trials={SunSpireHall001_base=true,MawLorkajSevenRiddles_Base=true,arenaslobbyexterior_base=true,maw_of=true,trl_so=true,helracitadelentry_base=true,aetherianarchivebottom_base=true,ui_map=true,gladiatorsassembly_base=true,}
	local subzone=string.match(GetMapTileTexture():lower(), "maps/[%w%-]+/([%w%-]+_[%w%-]+)")
	local zone=GetCurrentMapZoneIndex()
	if CharacterSettings.FishingAchivement then
		GetFishing(zone)
	end
	if MapZoneIndex~=zone then
		RaidTargetTime=trials[subzone] and GetRaidTargetTime()/1000 or 0
		DungeonStartTime=(not trials[subzone] and IsUnitInDungeon('player') and GetCurrentZoneDungeonDifficulty()>0) and GetGameTimeMilliseconds() or 0
		ChestsLooted=0
		LastChest={x=0,y=0}
	end
	MapZoneIndex=zone

	--Meter elements reposition (101035)
	ZO_PerformanceMetersFramerateMeter:ClearAnchors()
	ZO_PerformanceMetersFramerateMeter:SetAnchor(LEFT,ZO_PerformanceMeters,LEFT,10,0)
	ZO_PerformanceMetersLatencyMeter:ClearAnchors()
	ZO_PerformanceMetersLatencyMeter:SetAnchor(LEFT,ZO_PerformanceMetersFramerateMeter,RIGHT,-3,0)
--	d("Dungeon: "..tostring(IsUnitInDungeon('player')).." difficulty: "..tostring(GetCurrentZoneDungeonDifficulty()))
end

local function ZoneNameToIndex()
	local i,name=2,nil
	while name~="" do
		name=GetZoneNameByIndex(i)
		ZoneNames[ZO_CachedStrFormat("<<!A:1>>", name)]=GetZoneId(i)
		i=i+1
	end
end

local function WorldMapInfo(show)
	if CharacterSettings.FishingAchivement then
		GetFishing(GetCurrentMapZoneIndex())
		local control=ZO_WorldMapFishingAchivement
		if show then
			if not control then
				control=WINDOW_MANAGER:CreateControl("$(parent)FishingAchivement", ZO_WorldMap, CT_LABEL)
				control:SetAnchor(TOPLEFT,ZO_WorldMap,TOPLEFT,10,10)
				control:SetFont("ZoFontWinT2")
				control:SetHorizontalAlignment(1)
				control:SetVerticalAlignment(2)
			end
			control:SetText(FishingText)
		end
		if control then control:SetHidden(not show) end
	end
end

function InfoPanel.Initialize()
	MoveFrames()
	UI_Init()

	if GlobalSettings.DungeonChests and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event",EVENT_CLIENT_INTERACT_RESULT, OnInteract)
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event",EVENT_CLIENT_INTERACT_RESULT)
	end
	if (GlobalSettings.TrialInfo or GlobalSettings.DungeonInfo or GlobalSettings.DungeonChests) and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_PLAYER_ACTIVATED,	function() zo_callLater(OnActivated, 1000) end)
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_PLAYER_ACTIVATED)
	end
	if (GlobalSettings.ExPgain or GlobalSettings.ExpPS==1) and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_EXPERIENCE_UPDATE,	OnExpUpdate)
		if GlobalSettings.ExPgain and LastExp==0 then LastExp=GetUnitXP('player') end
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_EXPERIENCE_UPDATE)
	end
	if (GlobalSettings.APgain or GlobalSettings.ExpPS==2) and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_ALLIANCE_POINT_UPDATE,	OnApUpdate)
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_ALLIANCE_POINT_UPDATE)
	end
	if (GlobalSettings.TelvarGain or GlobalSettings.ExpPS==4) and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_TELVAR_STONE_UPDATE,	OnTelvarGain)
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_TELVAR_STONE_UPDATE)
	end
	if (GlobalSettings.Achievement_up or CharacterSettings.FishingAchivement) and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event",EVENT_ACHIEVEMENT_UPDATED,OnAchievementUpdate)
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event",EVENT_ACHIEVEMENT_AWARDED,function(_,_,_,achievementId,link) OnAchievementUpdate(_,achievementId,link)end)
		if CharacterSettings.FishingAchivement then
			WORLD_MAP_SCENE:RegisterCallback("StateChange", function(oldState, newState)
				if newState==SCENE_SHOWN then WorldMapInfo(true)
				elseif newState==SCENE_HIDDEN then WorldMapInfo(false) end
			end)
			CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged",function()
				if SCENE_MANAGER:GetCurrentScene().name=="worldMap" then WorldMapInfo(true) end
			end)
		end
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event",EVENT_ACHIEVEMENT_UPDATED)
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event",EVENT_ACHIEVEMENT_AWARDED)
		WORLD_MAP_SCENE:UnregisterCallback("StateChange")
		CALLBACK_MANAGER:UnregisterCallback("OnWorldMapChanged")
	end
	if GlobalSettings.BagSpace~=3 and GlobalSettings.InfoPanel then
--		SHARED_INVENTORY:RegisterCallback("SlotAdded", OnBagpackAdded, self)
--		SHARED_INVENTORY:RegisterCallback("SlotRemoved", OnBagpackRemoved, self)
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnBackpackChanged)
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_CLOSE_STORE, OnBackpackChanged)
		if not init or MenuParam=="BagSpace" then OnBackpackChanged(nil,BAG_BACKPACK) end
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_CLOSE_STORE)
	end
	if GlobalSettings.BankSpace~=3 and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event1", EVENT_CLOSE_BANK,	BankSpace)
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event1", EVENT_END_CRAFTING_STATION_INTERACT,	BankSpace)
		if not init or MenuParam=="BankSpace" then BankSpace() end
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event1", EVENT_CLOSE_BANK)
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event1", EVENT_END_CRAFTING_STATION_INTERACT)
	end
	if GlobalSettings.Fence and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event_Fence", EVENT_END_CRAFTING_STATION_INTERACT,	function() ScanInventory() end)
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event_Fence", EVENT_INVENTORY_ITEM_DESTROYED,	function() ScanInventory() InfoPanel.Update() end)
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event_Fence", EVENT_JUSTICE_FENCE_UPDATE,		function() ScanInventory() GetFenceInfo() InfoPanel.Update() end)
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event_Fence", EVENT_LOOT_RECEIVED,			OnLootReceived)
		if not init or MenuParam=="Fence" then GetFenceInfo() end
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event_Fence", EVENT_END_CRAFTING_STATION_INTERACT)
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event_Fence", EVENT_INVENTORY_ITEM_DESTROYED)
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event_Fence", EVENT_JUSTICE_FENCE_UPDATE)
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event_Fence", EVENT_LOOT_RECEIVED)
	end
	if (GlobalSettings.Fence or GlobalSettings.BossTimer) and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event_Fence", EVENT_LOOT_RECEIVED,	OnLootReceived)
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event_Fence", EVENT_LOOT_RECEIVED)
	end
	if GlobalSettings.Stable and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_STABLE_INTERACT_END,	InfoPanel.Update)
		local inventoryBonus,maxInventoryBonus,staminaBonus,maxStaminaBonus,speedBonus,maxSpeedBonus=GetRidingStats()
		if inventoryBonus==maxInventoryBonus and staminaBonus==maxStaminaBonus and speedBonus==maxSpeedBonus then stable=false end
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_STABLE_INTERACT_END)
	end
	if GlobalSettings.Smithing and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_END_CRAFTING_STATION_INTERACT,	function() ScanSmithing() InfoPanel.Update() end)
		if not init then zo_callLater(ScanSmithing,2000)
		elseif MenuParam=="Smithing" then ScanSmithing() end
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_END_CRAFTING_STATION_INTERACT)
	end
	if GlobalSettings.Apparel and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event2", EVENT_INVENTORY_FULL_UPDATE,	ScanWornCondition)
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event2", EVENT_CLOSE_STORE,			function() ScanWornCondition() InfoPanel.Update() end)
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event2", EVENT_UNIT_DEATH_STATE_CHANGED,	function(_,unitTag,isDead) if isDead and unitTag=='player' then ScanWornCondition() end end)
		if not init or MenuParam=="Apparel" then ScanWornCondition() end
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event2", EVENT_INVENTORY_FULL_UPDATE)
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event2", EVENT_CLOSE_STORE)
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event2", EVENT_UNIT_DEATH_STATE_CHANGED)
	end
	if GlobalSettings.Achievements~=3 and GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_ACHIEVEMENTS_UPDATED,	GetAchievementPoints)
		if not init or MenuParam=="Achievements" then GetAchievementPoints() end
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_ACHIEVEMENTS_UPDATED)
	end
	if GlobalSettings.AutoRepairStore then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_OPEN_STORE,	AutoRepairStore)
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_OPEN_STORE)
	end
	if GlobalSettings.AutoRepairKit then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event",EVENT_PLAYER_COMBAT_STATE,	function() zo_callLater(OnComabatState, 1000) end)
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event",EVENT_PLAYER_ALIVE,	function() zo_callLater(OnComabatState, 14100) end)
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event",EVENT_PLAYER_COMBAT_STATE)
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event",EVENT_PLAYER_ALIVE)
	end
	if GlobalSettings.AutoRecharge or GlobalSettings.Weapons then
		EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_ACTIVE_WEAPON_PAIR_CHANGED,	OnPairChanged)
		if not init or MenuParam=="Weapons" then OnPairChanged() end
	else
		EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_ACTIVE_WEAPON_PAIR_CHANGED)
	end
	if GlobalSettings.InfoPanel then
		EVENT_MANAGER:RegisterForUpdate("InfoPanel_Update", (GlobalSettings.Update+1)*1000,	InfoPanel.Update)
		if init then
			if CharacterSettings.FishingAchivement then GetFishing() end
			InfoPanel.Update()
		else
			init=true
			zo_callLater(function()
				InfoPanel.Update()
				PERFORMANCE_METER_FRAGMENT:SetHiddenForReason("AnyOn",false,0,0)
			end, 1000)
		end
	else
		EVENT_MANAGER:UnregisterForUpdate("InfoPanel_Update")
	end
end

local function OnLoad(eventCode, addonName)
	if (addonName~="InfoPanel") then return end
	EVENT_MANAGER:UnregisterForEvent("InfoPanel_Event", EVENT_ADD_ON_LOADED)
--	SLASH_COMMANDS["/panel"]=HandleSlashCommand
	local defaults={LatestMail=0}
	for i,data in pairs(Settings) do defaults[data.name]=data.value end
	GlobalSettings=ZO_SavedVars:NewAccountWide("InfoPanel_Settings", 1, nil, defaults)
	CharacterSettings=ZO_SavedVars:New("InfoPanel_Character", 1, nil, {FishingAchivement=false,Experience=false})
	Menu_Init()
	zo_callLater(
		function()
			ScanInventory()
			if GLN and GLN.SavedVars and GLN.SavedVars.BagSpace then
				GLN.SavedVars.BagSpace=false GLN.Initialize() GLN.BagSpace_Init()
			end
		end, 2000)
	InfoPanel.Initialize()
end

EVENT_MANAGER:RegisterForEvent("InfoPanel_Event", EVENT_ADD_ON_LOADED, OnLoad)