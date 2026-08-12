local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)

local ReplicationController = {}

function ReplicationController.Init()
    CastleSharedService.InitRender()
    CastleSharedService.ClientReplicationReady.client:FireServer()

    CastleSharedService.ReplicationPacket.client.OnClientEvent:Connect(function(
        replicationBuffer
    )
        local batchedCastleReplication = CastleSharedService.DeserializeReplicationPacket(
            replicationBuffer
        )

        for _, castleReplication in batchedCastleReplication do
            CastleSharedService.RenderCastleReplication(castleReplication)
        end
    end)

    CastleSharedService.StructurePurchaseTouched:Connect(function(
        unlockedStructureId,
        touchingPlayer
    )
        CastleSharedService.ClientTouchedStructurePurchase.client:FireServer(unlockedStructureId)
    end)
end

return ReplicationController
