
JSON = assert(loadfile "JSON.lua")()

io_eventlog = nil;
eventid = 0;
server = getServer();

function onEnable()
  io_eventlog = io.open("eventlog.log","a+");
end

function EventLog(eventset)
  io_eventlog:write(JSON:encode(eventset) .. "\n");
end

function getEventSet(eventname)
  eventid = eventid + 1;
  return {
    EventID = eventid,
    EventName = eventname,
    GameTimestamp = server:getGameTimestamp(),
  };
end

function addXYZToSet(set,key,xyz)
  if not xyz == nil then
    local xyzset = {
      x = xyz.x,
      y = xyz.y,
      z = xyz.z,
    };
    set[key] = xyzset;
  end
end

function addChunkOffsetToSet(set,obj)
  set["chunkOffsetX"] = obj.chunkOffsetX;
  set["chunkOffsetY"] = obj.chunkOffsetY;
  set["chunkOffsetZ"] = obj.chunkOffsetZ;
end

function addBlockPositionToSet(set,obj)
  set["blockPositionX"] = obj.blockPositionX;
  set["blockPositionY"] = obj.blockPositionY;
  set["blockPositionZ"] = obj.blockPositionZ;
end

function addChunkBlockToSet(set,obj)
  addChunkOffsetToSet(set,obj);
  addBlockPositionToSet(set,obj);
end

function addPlayerToSet(set,key,player)
  local playerset = {
    DBID = player:getDBID(),
    name = player:getName(),
  };
  addXYZToSet(playerset,'position',player:getPosition());
  addXYZToSet(playerset,'chunkPosition',player:getChunkPosition());
  set[key] = playerset;
end

function addNpcToSet(set,key,npc)
  local npcset = {
    Name = npc:getName(),
    TypeID = npc:getTypeID(),
    ID = npc:getID(),
  };
  addXYZToSet(npcset,'position',npc:getPosition());
  set[key] = npcset;
end

addEvent("PlayerConnect", function (event)
  local set = getEventSet("PlayerConnect");
  addPlayerToSet(set,"player",event.player);
  EventLog(set);
end);

addEvent("PlayerDisconnect", function (event)
  local set = getEventSet("PlayerDisconnect");
  addPlayerToSet(set,"player",event.player);
  EventLog(set);
end);

addEvent("PlayerText", function (event)
  local set = getEventSet("PlayerText");
  addPlayerToSet(set,"player",event.player);
  set["prefix"] = event.prefix;
  set["text"] = event.text;
  EventLog(set);
end);

addEvent("PlayerCommand", function (event)
  local set = getEventSet("PlayerCommand");
  addPlayerToSet(set,"player",event.player);
  set["command"] = event.command;
  EventLog(set);
end);

addEvent("PlayerDeath", function (event)
  local set = getEventSet("PlayerDeath");
  addPlayerToSet(set,"player",event.player);
  addPosToSet(set,"Position",event.position);
  EventLog(set);
end);

addEvent("PlayerEnterChunk", function (event)
  local set = getEventSet("PlayerEnterChunk");
  addPlayerToSet(set,"player",event.player);
  addXYZToSet(set,"position",event.position);
  addXYZToSet(set,"oldChunk",event.oldChunk);
  addXYZToSet(set,"newChunk",event.newChunk);
  EventLog(set);
end);

addEvent("PlayerEnterWorldpart", function (event)
  local set = getEventSet("PlayerEnterWorldpart");
  addPlayerToSet(set,"player",event.player);
  set["oldWorldPart"] = {
    a = event.oldWorldpart.a,
    b = event.oldWorldpart.b,
  };
  set["newWorldPart"] = {
    a = event.oldWorldpart.a,
    b = event.oldWorldpart.b,
  };
  EventLog(set);
end);

addEvent("PlayerTerrainFill", function (event)
  local set = getEventSet("PlayerTerrainFill");
  addPlayerToSet(set,"player",event.player);
  addChunkBlockToSet(set, event);
  set["newBlockID"] = event.newBlockID;
  EventLog(set);
end);

addEvent("PlayerTerrainDestroy", function (event)
  local set = getEventSet("PlayerTerrainDestroy");
  addPlayerToSet(set,"player",event.player);
  addChunkBlockToSet(set, event);
  EventLog(set);
end);

addEvent("PlayerGrassRemove", function (event)
  local set = getEventSet("PlayerGrassRemove");
  addPlayerToSet(set,"player",event.player);
  addChunkBlockToSet(set, event);
  set["newBlockID"] = event.newBlockID;
  EventLog(set);
end);

addEvent("PlayerBlockPlace", function (event)
  local set = getEventSet("PlayerBlockPlace");
  addPlayerToSet(set,"player",event.player);
  addChunkBlockToSet(set, event);
  set["newBlockID"] = event.newBlockID;
  EventLog(set);
end);

addEvent("PlayerBlockDestroy", function (event)
  local set = getEventSet("PlayerBlockDestroy");
  addPlayerToSet(set,"player",event.player);
  addChunkBlockToSet(set, event);
  set["oldBlockID"] = event.oldBlockID;
  EventLog(set);
end);

addEvent("PlayerConstructionPlace", function (event)
  local set = getEventSet("PlayerConstructionPlace");
  addPlayerToSet(set,"player",event.player);
  addChunkOffsetToSet(set, event);
  addXYZToSet(set,"position",event.position);
  addXYZToSet(set,"rotation",event.rotation);
  addXYZToSet(set,"size",event.size);
  set["textureID"] = event.textureID;
  set["constructionID"] = event.constructionID;
  EventLog(set);
end);

addEvent("PlayerConstructionDestroy", function (event)
  local set = getEventSet("PlayerConstructionDestroy");
  addPlayerToSet(set,"player",event.player);
  addChunkOffsetToSet(set, event);
  addXYZToSet(set,"position",event.position);
  addXYZToSet(set,"size",event.size);
  set["constructionID"] = event.constructionID;
  EventLog(set);
end);

addEvent("PlayerConstructionRemove", function (event)
  local set = getEventSet("PlayerConstructionRemove");
  addPlayerToSet(set,"player",event.player);
  addChunkOffsetToSet(set, event);
  addXYZToSet(set,"position",event.position);
  addXYZToSet(set,"size",event.size);
  set["constructionID"] = event.constructionID;
  EventLog(set);
end);

addEvent("PlayerObjectPlace", function (event)
  local set = getEventSet("PlayerObjectPlace");
  addPlayerToSet(set,"player",event.player);
  addChunkOffsetToSet(set, event);
  addXYZToSet(set,"position",event.position);
  addXYZToSet(set,"rotation",event.rotation);
  set["variation"] = event.variation;
  set["info"] = event.info;
  set["objectTypeID"] = event.objectTypeID;
  EventLog(set);
end);

addEvent("PlayerObjectPickup", function (event)
  local set = getEventSet("PlayerObjectPickup");
  addPlayerToSet(set,"player",event.player);
  addChunkOffsetToSet(set, event);
  addXYZToSet(set,"position",event.position);
  set["objectTypeID"] = event.objectTypeID;
  EventLog(set);
end);

addEvent("PlayerObjectRemove", function (event)
  local set = getEventSet("PlayerObjectRemove");
  addPlayerToSet(set,"player",event.player);
  addChunkOffsetToSet(set, event);
  addXYZToSet(set,"position",event.position);
  set["objectTypeID"] = event.objectTypeID;
  EventLog(set);
end);

addEvent("PlayerObjectDestroy", function (event)
  local set = getEventSet("PlayerObjectDestroy");
  addPlayerToSet(set,"player",event.player);
  addChunkOffsetToSet(set, event);
  addXYZToSet(set,"position",event.position);
  set["objectTypeID"] = event.objectTypeID;
  EventLog(set);
end);

addEvent("PlayerObjectStatusChange", function (event)
  local set = getEventSet("PlayerObjectStatusChange");
  addPlayerToSet(set,"player",event.player);
  addChunkOffsetToSet(set, event);
  addXYZToSet(set,"position",event.position);
  set["objectTypeID"] = event.objectTypeID;
  set["newStatus"] = event.newStatus;
  set["oldStatus"] = event.oldStatus;
  EventLog(set);
end);

addEvent("PlayerVegetationPlace", function (event)
  local set = getEventSet("PlayerVegetationPlace");
  addPlayerToSet(set,"player",event.player);
  addChunkOffsetToSet(set, event);
  addXYZToSet(set,"position",event.position);
  addXYZToSet(set,"rotation",event.rotation);
  set["variation"] = event.variation;
  set["plantTypeID"] = event.plantTypeID;
  EventLog(set);
end);

addEvent("PlayerVegetationPickup", function (event)
  local set = getEventSet("PlayerVegetationPickup");
  addPlayerToSet(set,"player",event.player);
  addChunkOffsetToSet(set, event);
  addXYZToSet(set,"position",event.position);
  set["plantTypeID"] = event.plantTypeID;
  EventLog(set);
end);

addEvent("PlayerVegetationDestroy", function (event)
  local set = getEventSet("PlayerVegetationDestroy");
  addPlayerToSet(set,"player",event.player);
  addChunkOffsetToSet(set, event);
  addXYZToSet(set,"position",event.position);
  -- corrected the type in the Lua class
  set["plantTypeID"] = event.playerTypeID;
  EventLog(set);
end);

-- PlayerPressKey

-- PlayerCraftItem

-- PlayerGroupInvited

-- PlayerGroupJoin

-- PlayerGroupLeave

-- PlayerArmorChange

-- PlayerChangeClothes

-- TODO Switch for this
-- function onPlayerChangePosition(event)
--   local pos = event.position;
--   local rot = event.rotation;
--   PlayerEventLog("PlayerChangePosition",event,
--     "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
--     "[" .. rot.x .. "|" .. rot.y .. "|" .. rot.z .. "]"
--   );
-- end
-- addEvent("PlayerChangePosition", onPlayerChangePosition);

-- PlayerSpawnChange

-- PlayerGuiInteract

-- PlayerInventoryChange

addEvent("PlayerQuickslotChange", function (event)
  local set = getEventSet("PlayerQuickslotChange");
  addPlayerToSet(set,"player",event.player);
  set["oldFocus"] = event.oldFocus;
  set["newFocus"] = event.newFocus;
  EventLog(set);
end);

addEvent("PlayerDamage", function (event)
  local set = getEventSet("PlayerDamage");
  addPlayerToSet(set,"player",event.player);
  set["oldHealth"] = event.oldHealth;
  set["damage"] = event.damage;
  EventLog(set);
end);

-- function onPlayerHit(event)
--   local damage = event.damagePoint;
--   PlayerEventLog("PlayerHit",event,
--   );
-- end
-- addEvent("PlayerHit", onPlayerHit);

addEvent("PlayerRespawn", function (event)
  local set = getEventSet("PlayerRespawn");
  addPlayerToSet(set,"player",event.player);
  addXYZToSet(set,"position",event.position);
  addXYZToSet(set,"rotation",event.rotation);
  EventLog(set);
end);

addEvent("PlayerConsumeItem", function (event)
  local set = getEventSet("PlayerConsumeItem");
  addPlayerToSet(set,"player",event.player);
  set["healthrestore"] = event.healthrestore;
  set["hungerrestore"] = event.hungerrestore;
  set["thirstrestore"] = event.thirstrestore;
  set["healBrokenbones"] = event.healBrokenbones;
  EventLog(set);
end);

addEvent("PlayerChestRemove", function (event)
  local set = getEventSet("PlayerChestRemove");
  addPlayerToSet(set,"player",event.player);
  addXYZToSet(set,"position",event.position);
  addChunkOffsetToSet(set, event);
  set["chestID"] = event.chestID;
  set["objectTypeID"] = event.objectTypeID;
  EventLog(set);
end);

addEvent("PlayerChestDestroy", function (event)
  local set = getEventSet("PlayerChestDestroy");
  addPlayerToSet(set,"player",event.player);
  addXYZToSet(set,"position",event.position);
  addChunkOffsetToSet(set, event);
  set["chestID"] = event.chestID;
  set["objectTypeID"] = event.objectTypeID;
  EventLog(set);
end);

addEvent("PlayerChestPlace", function (event)
  local set = getEventSet("PlayerChestPlace");
  addPlayerToSet(set,"player",event.player);
  addXYZToSet(set,"position",event.position);
  addXYZToSet(set,"rotation",event.rotation);
  addChunkOffsetToSet(set, event);
  set["chestID"] = event.chestID;
  set["objectTypeID"] = event.objectTypeID;
  EventLog(set);
end);

addEvent("ChestToInventory", function (event)
  local set = getEventSet("ChestToInventory");
  addPlayerToSet(set,"player",event.player);
  set["chestID"] = event.chestID;
  set["chestslot"] = event.chestslot;
  set["inventorytype"] = event.inventorytype;
  set["inventoryslot"] = event.inventoryslot;
  EventLog(set);
end);

addEvent("InventoryToChest", function (event)
  local set = getEventSet("InventoryToChest");
  addPlayerToSet(set,"player",event.player);
  set["chestID"] = event.chestID;
  set["chestslot"] = event.chestslot;
  set["inventorytype"] = event.inventorytype;
  set["inventoryslot"] = event.inventoryslot;
  EventLog(set);
end);

addEvent("ChestItemDrop", function (event)
  local set = getEventSet("ChestItemDrop");
  addPlayerToSet(set,"player",event.player);
  set["chestID"] = event.chestID;
  set["chestslot"] = event.chestslot;
  EventLog(set);
end);

addEvent("NpcDeath", function (event)
  local set = getEventSet("NpcDeath");
  addNpcToSet(set,"npc",event.npc);
  addXYZToSet(set,"position",event.position);
  EventLog(set);
end);

addEvent("NpcHit", function (event)
  local set = getEventSet("NpcHit");
  addPlayerToSet(set,"player",event.player);
  addNpcToSet(set,"targetNpc",event.targetNpc);
  set["distanceSquared"] = event.distanceSquared;
  set["damage"] = event.damage;
  EventLog(set);
end);

addEvent("NpcHit", function (event)
  local set = getEventSet("NpcSpawn");
  addXYZToSet(set,"position",event.position);
  set["typeID"] = event.typeID;
  EventLog(set);
end);

-- ItemPickup

-- ItemDrop

-- ItemDestroy 

-- SpawnInventoryChange

-- SpawnPositionChange

-- CreateWorldpart

-- WorldChange

-- Update
