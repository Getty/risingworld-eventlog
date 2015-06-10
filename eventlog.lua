
io_eventlog = nil;
eventid = 0;
server = getServer();

function nstr(something)
  if something == nil then
    return "";
  elseif something == true then
    return "true";
  elseif something == false then
    return "false";
  else
    return something;
  end
end

function onEnable()
  io_eventlog = io.open("eventlog.log","a+");
end

function EventLog(eventname,text)
  eventid = eventid + 1;
  io_eventlog:write(eventid .. " " .. os.date("%x %X") .. " [" ..
    eventname .. "] " .. text .."\n");
end

function PlayerEventLog(eventname,event,extra)
  local pos = event.player:getPosition();
  local chunkPos = event.player:getChunkPosition();
  EventLog(eventname,
    event.player:getDBID() .. "(" ..
      pos.x .. "|" .. pos.y .. "|" .. pos.z .. "X" ..
      chunkPos.x .. "|" .. chunkPos.y .. "|" .. chunkPos.z ..
    ")" .. " " .. nstr(extra)
  );
end

function NpcEventLog(eventname,event,extra)
  local pos = event.npc:getPosition();
  EventLog(eventname,
    "NPC: " .. event.npc:getName() .. " #" .. event.npc:getID() ..
    "(" .. event.npc:getTypeID() .. ")" ..
    nstr(extra)
  );
end

function EventChunkBlock(event)
  return
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY .. 
        "|" .. event.chunkOffsetZ .. "X" ..
    event.blockPositionX .. "|" .. event.blockPositionY .. 
        "|" .. event.blockPositionZ .. "]"
end

function onPlayerConnect(event)
  PlayerEventLog("PlayerConnect",event);
end
addEvent("PlayerConnect", onPlayerConnect);

function onPlayerDisconnect(event)
  PlayerEventLog("PlayerDisconnect",event);
end
addEvent("PlayerDisconnect", onPlayerDisconnect);

function onPlayerText(event)
  PlayerEventLog("PlayerText",event,
    "[" .. nstr(event.prefix) .. "|" .. nstr(event.text) .. "]");
end
addEvent("PlayerText", onPlayerText);

function onPlayerCommand(event)
  PlayerEventLog("PlayerCommand",event,
    "[" .. nstr(event.command) .. "]");
end
addEvent("PlayerCommand", onPlayerCommand);

function onPlayerDeath(event)
  local pos = event.position;
  PlayerEventLog("PlayerDeath",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "]");
end
addEvent("PlayerDeath", onPlayerDeath);

function onPlayerEnterChunk(event)
  local old = event.oldChunk;
  local new = event.newChunk;
  PlayerEventLog("PlayerEnterChunk",event,
    "[" .. old.x .. "|" .. old.y .. "|" .. old.z .. "] -> " ..
    "[" .. new.x .. "|" .. new.y .. "|" .. new.z .. "]"
  );
end
addEvent("PlayerEnterChunk", onPlayerEnterChunk);

function onPlayerEnterWorldpart(event)
  local old = event.oldWorldpart;
  local new = event.newWorldpart;
  PlayerEventLog("PlayerEnterWorldpart",event,
    "[" .. old.a .. "|" .. old.b .. "] -> " ..
    "[" .. new.a .. "|" .. new.b .. "]"
  );
end
addEvent("PlayerEnterWorldpart", onPlayerEnterWorldpart);

function onPlayerTerrainFill(event)
  PlayerEventLog("PlayerTerrainFill",event,
    EventChunkBlock(event) .. " " ..
    event.newBlockID
  );
end
addEvent("PlayerTerrainFill", onPlayerTerrainFill);

function onPlayerTerrainDestroy(event)
  PlayerEventLog("PlayerTerrainDestroy",event,
    EventChunkBlock(event)
  );
end
addEvent("PlayerTerrainDestroy", onPlayerTerrainDestroy);

function onPlayerGrassRemove(event)
  PlayerEventLog("PlayerGrassRemove",event,
    EventChunkBlock(event) .. " " ..
    event.newBlockID
  );
end
addEvent("PlayerGrassRemove", onPlayerGrassRemove);

function onPlayerBlockPlace(event)
  PlayerEventLog("PlayerBlockPlace",event,
    EventChunkBlock(event) .. " " ..
    event.newBlockID
  );
end
addEvent("PlayerBlockPlace", onPlayerBlockPlace);

function onPlayerBlockDestroy(event)
  PlayerEventLog("PlayerBlockDestroy",event,
    EventChunkBlock(event) .. " " ..
    event.oldBlockID
  );
end
addEvent("PlayerBlockDestroy", onPlayerBlockDestroy);

function onPlayerConstructionPlace(event)
  local pos = event.position;
  local rot = event.rotation;
  local size = event.size;
  PlayerEventLog("PlayerConstructionPlace",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. rot.x .. "|" .. rot.y .. "|" .. rot.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    "[" .. size.x .. "|" .. size.y .. "|" .. size.z .. "] " ..
    event.textureID .. " " .. event.constructionID
  );
end
addEvent("PlayerConstructionPlace", onPlayerConstructionPlace);

function onPlayerConstructionDestroy(event)
  local pos = event.position;
  local size = event.size;
  PlayerEventLog("PlayerConstructionDestroy",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    "[" .. size.x .. "|" .. size.y .. "|" .. size.z .. "] " ..
    event.constructionID
  );
end
addEvent("PlayerConstructionDestroy", onPlayerConstructionDestroy);

function onPlayerConstructionRemove(event)
  local pos = event.position;
  local size = event.size;
  PlayerEventLog("PlayerConstructionRemove",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    "[" .. size.x .. "|" .. size.y .. "|" .. size.z .. "] " ..
    event.constructionID
  );
end
addEvent("PlayerConstructionRemove", onPlayerConstructionRemove);

function onPlayerObjectPlace(event)
  local pos = event.position;
  local rot = event.rotation;
  PlayerEventLog("PlayerObjectPlace",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. rot.x .. "|" .. rot.y .. "|" .. rot.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    event.variation .. " " .. event.objectTypeID .. " " ..
    event.info
  );
end
addEvent("PlayerObjectPlace", onPlayerObjectPlace);

function onPlayerObjectPickup(event)
  local pos = event.position;
  PlayerEventLog("PlayerObjectPickup",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    event.objectTypeID
  );
end
addEvent("PlayerObjectPickup", onPlayerObjectPickup);

function onPlayerObjectRemove(event)
  local pos = event.position;
  PlayerEventLog("PlayerObjectRemove",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    event.objectTypeID
  );
end
addEvent("PlayerObjectRemove", onPlayerObjectRemove);

function onPlayerObjectDestroy(event)
  local pos = event.position;
  PlayerEventLog("PlayerObjectDestroy",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    event.objectTypeID
  );
end
addEvent("PlayerObjectDestroy", onPlayerObjectDestroy);

function onPlayerObjectStatusChange(event)
  local pos = event.position;
  PlayerEventLog("PlayerObjectStatusChange",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    event.objectTypeID .. " " ..
    event.newStatus .. " -> " .. event.oldStatus
  );
end
addEvent("PlayerObjectStatusChange", onPlayerObjectStatusChange);

function onPlayerVegetationPlace(event)
  local pos = event.position;
  local rot = event.rotation;
  PlayerEventLog("PlayerVegetationPlace",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. rot.x .. "|" .. rot.y .. "|" .. rot.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    event.variation .. " " .. event.plantTypeID
  );
end
addEvent("PlayerVegetationPlace", onPlayerVegetationPlace);

function onPlayerVegetationPickup(event)
  local pos = event.position;
  PlayerEventLog("PlayerVegetationPickup",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    event.plantTypeID
  );
end
addEvent("PlayerVegetationPickup", onPlayerVegetationPickup);

function onPlayerVegetationDestroy(event)
  local pos = event.position;
  PlayerEventLog("PlayerVegetationDestroy",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    event.playerTypeID
  );
end
addEvent("PlayerVegetationDestroy", onPlayerVegetationDestroy);

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

function onPlayerQuickslotChange(event)
  local old = event.oldFocus;
  local new = event.newFocus;
  PlayerEventLog("PlayerQuickslotChange",event,
    old .. " -> " .. new
  );
end
addEvent("PlayerQuickslotChange", onPlayerQuickslotChange);

function onPlayerDamage(event)
  PlayerEventLog("PlayerDamage",event,
    event.oldHealth .. " " .. event.damage
  );
end
addEvent("PlayerDamage", onPlayerDamage);

-- function onPlayerHit(event)
--   local damage = event.damagePoint;
--   PlayerEventLog("PlayerHit",event,
--   );
-- end
-- addEvent("PlayerHit", onPlayerHit);

function onPlayerRespawn(event)
  local pos = event.position;
  local rot = event.rotation;
  PlayerEventLog("PlayerRespawn",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. rot.x .. "|" .. rot.y .. "|" .. rot.z .. "]"
    -- more todo
  );
end
addEvent("PlayerRespawn", onPlayerRespawn);

function onPlayerConsumeItem(event)
  PlayerEventLog("PlayerConsumeItem",event,
    event.healthrestore .. " " ..
    event.hungerrestore .. " " ..
    event.thirstrestore .. " " ..
    nstr(event.healBrokenbones)
  );
end
addEvent("PlayerConsumeItem", onPlayerConsumeItem);

function onPlayerChestRemove(event)
  local pos = event.position;
  PlayerEventLog("PlayerChestRemove",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    event.chestID .. " " .. event.objectTypeID
  );
end
addEvent("PlayerChestRemove", onPlayerChestRemove);

function onPlayerChestDestroy(event)
  local pos = event.position;
  PlayerEventLog("PlayerChestDestroy",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    event.chestID .. " " .. event.objectTypeID
  );
end
addEvent("PlayerChestDestroy", onPlayerChestDestroy);

function onPlayerChestPlace(event)
  local pos = event.position;
  local rot = event.rotation;
  PlayerEventLog("PlayerChestPlace",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    "[" .. rot.x .. "|" .. rot.y .. "|" .. rot.z .. "] " ..
    "[" .. event.chunkOffsetX .. "|" .. event.chunkOffsetY ..
        "|" .. event.chunkOffsetZ .. "] " ..
    event.chestID .. " <- " .. event.objectTypeID
  );
end
addEvent("PlayerChestPlace", onPlayerChestPlace);

function onChestToInventory(event)
  PlayerEventLog("ChestToInventory",event,
    event.chestID .. " " .. event.chestslot .. " -> " ..
    event.inventorytype .. " " .. event.inventoryslot
  );
end
addEvent("ChestToInventory", onChestToInventory);

function onInventoryToChest(event)
  PlayerEventLog("InventoryToChest",event,
    event.chestID .. " " .. event.chestslot .. " <- " ..
    event.inventorytype .. " " .. event.inventoryslot
  );
end
addEvent("InventoryToChest", onInventoryToChest);

function onChestItemDrop(event)
  PlayerEventLog("ChestItemDrop",event,
    event.chestID .. " " .. event.chestslot
  );
end
addEvent("ChestItemDrop", onChestItemDrop);

function onNpcDeath(event)
  local pos = event.position;
  NpcEventLog("NpcDeath",event,
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "]"
  );
end
addEvent("NpcDeath", onNpcDeath);

function onNpcHit(event)
  PlayerEventLog("NpcHit",event,
    "NPC: " .. event.targetNpc:getName() ..
    " #" .. event.targetNpc:getID() ..
    "(" .. event.targetNpc:getTypeID() .. ")" ..
    event.distanceSquared .. " " .. event.damage
  );
end
addEvent("NpcHit", onNpcHit);

function onNpcSpawn(event)
  local pos = event.position;
  EventLog("NpcDeath",
    "[" .. pos.x .. "|" .. pos.y .. "|" .. pos.z .. "] " ..
    event.typeID
  );
end
addEvent("NpcSpawn", onNpcSpawn);

-- ItemPickup

-- ItemDrop

-- ItemDestroy 

-- SpawnInventoryChange

-- SpawnPositionChange

-- CreateWorldpart

-- WorldChange

-- Update
