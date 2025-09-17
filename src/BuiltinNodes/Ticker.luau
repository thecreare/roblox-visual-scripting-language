local RunService = game:GetService("RunService")

local NodeBuilder = require(script.Parent.Parent.NodeBuilder)

return function()
    local builder = NodeBuilder.new()
    builder:AddInput("Interval", "number")
    builder:AddOutput("Start")
    builder:AddOutput("Tick")
    builder:OnGraphRun(function(ctx)
        ctx:SetOutput("Start")
        local last_tick = os.clock()
        local connection = RunService.Heartbeat:Connect(function()
            if os.clock() - last_tick < ctx:ExtractInput("Interval") then return end
            last_tick = os.clock()
            ctx:SetOutput("Tick")
        end)
        return function()
            connection:Disconnect()
        end
    end)
    builder.ui_name = "Ticker"
    return builder
end
