server should store a registry of all castles, all data.

MapServerService merely contains references to map instances / data

CastleServerService stores a list of all castles and their player owners, CastleServerController hooks to PlayerAdded and adds the player to a vacant spot in CastleServerService. This function would be AddPlayerCastle(player: Player) which should 1) add player to vacant castle and 2) load in castle data from DataServerService to that list. this data is cached in CastleServerService so that its now localized castle data, rather than having to directly get it from DataServerService

On player's end, itll send a handshake remote to the server telling it that its ready to render castles. When received by CastleServerController, itll run GetPlayerCastleData(player: Player) which will send a table, this table will then be sent by CastleServerController thru CastleSharedService which is a middleground for serializing/deserializing this castle data, which is then intercepted by CastleClientController to then pass onto CastleClientService which renders the castle data via RenderPlayerCastleData()

WHAT EXACTLY IS THIS DATA INTERCEPTED BY CastleSharedService?
1) IslandReplicationPacket which should be pretty much... 
type IslandReplication = {
    islandID: number;
}
type StructureReplication = {
    islandID: number;
    unlockedStructures: {[string]: boolean};
}

IMPLICATION? CastleSharedService should hold all integer IDs for islandID which holds info like CFrame, etc etc. CastleSharedService also holds string IDs for each structure, meaning rendering a newly bought structure is as simple as sending a string

PS. CastleSharedService should hold all the identifiers for each progression, eg 1 Platform, so as to allow for serde

this approach applies for everybody's castle, even the players castle. we do our own rendering to allow finer control on certain effects (eg we may want to apply effects when a new structure is bought, but only apply that effect for objects near the client! if too far aka from other castles, instantly place it rather than doing any special effects)