local VisualScriptingLanguage = require(script.Parent.Parent)

return function()
    local language = VisualScriptingLanguage.new(true)

    do -- Tactile Receptor
        local node = language.BuildNode()
        node.ui_name = "Tactile Receptor"
        node:AddOutput("Touched")
        node:OnGraphRun(function(ctx)
            ctx:SetOutput("Touched")
            return function()
                
            end
        end)
        language:RegisterNode("TactileReceptor", node)
    end
    
    do -- Light Detector
        local node = language.BuildNode()
        node.ui_name = "Light Detector"
        node:AddOutput("Brightness", "number")
        node:AddInputSignal("Sense", function(ctx)
            ctx:SetOutput("Brightness", Random.new():NextNumber())
        end)
        language:RegisterNode("LightDetector", node)
    end

    do -- Electrocytes
        local node = language.BuildNode()
        node.ui_name = "Electrocyte"
        node:AddInputSignal("Electrocute", function(ctx)
            print("zap zap zap >:3")
        end)
        language:RegisterNode("Electrocyte", node)
    end
    
    do -- Nectophore
        local node = language.BuildNode()
        node.ui_name = "Nectophore"
        node:AddInput("Force", "number")
        node:AddInputSignal("Launch", function(ctx)
            
        end)
        language:RegisterNode("Nectophore", node)
    end
    
    do -- Esca
        local node = language.BuildNode()
        node.ui_name = "Esca"
        local function SetEnabled(ctx: VisualScriptingLanguage.Node, enabled: boolean)
            print("Esca", enabled)
            -- enable based on value
            -- some todo things:
            -- node.linked_part.Material = if enabled then Enum.Material.Neon else Enum.Material.SmoothPlastic
            -- node.internal_state.Enabled = enabled
        end
        node:AddInputSignal("Enable", function(ctx)
            SetEnabled(ctx, true)
        end)
        node:AddInputSignal("Disable", function(ctx)
            SetEnabled(ctx, false)
        end)
        node:AddInputSignal("Toggle", function(ctx)
            -- SetEnabled(ctx, not ctx.internal_state.Enabled)
        end)
        language:RegisterNode("Esca", node)
    end

    do -- Keybind
        local node = language.BuildNode()
        node.ui_name = "Keybind"
        node:AddInput("Key", "string")
        node:AddOutput("KeyPressed")
        node:AddOutput("KeyReleased")
        node:OnGraphRun(function(ctx)
            ctx:SetOutput("KeyPressed")
            task.delay(0.5, function()
                ctx:SetOutput("KeyReleased")
            end)
            return function()
                
            end
        end)
        language:RegisterNode("Keybind", node)
    end
    
    do -- Screen Button
        local node = language.BuildNode()
        node.ui_name = "UI Button"
        node:AddInput("Position", "any")
        node:AddInput("Label", "string")
        node:AddInput("Visible", "boolean")
        node:AddOutput("Activated")
        node:AddInputSignal("Render", function(ctx)
            -- TODO: Actually show/update the UI on screen.
            -- This should maybe left up to the user of this
            -- library to implement.
            print("Rendering node")
        end)
        node:OnGraphRun(function(ctx)
            -- Automatically initialize button.
            -- This might be confusing for the user
            -- so consider not doing this
            ctx:_SetInput("Render")

            -- for debug reasons because no ui exists right now
            ctx:SetOutput("Activated")
            return function()
                
            end
        end)
        language:RegisterNode("UIButton", node)
    end

    do -- LessThanCondition
        local node = language.BuildNode()
        node:AddInput("A", "number")
        node:AddInput("B", "number")
        node:AddOutput("True")
        node:AddOutput("False")
        node:AddInputSignal("Check", function(ctx)
            local a = ctx:ExtractInput("A")
            local b = ctx:ExtractInput("B")
            if a < b then
                ctx:SetOutput("True")
            else
                ctx:SetOutput("False")
            end
        end)
        node.ui_name = "Condition <b>A&lt;B</b>"
        language:RegisterNode("LessThanCondition", node)
    end

    local graph = language:CreateBlankGraph()

    local touch_sensor = graph:CreateNode("TactileReceptor")
    local electrocyte_node = graph:CreateNode("Electrocyte")
    local print_node = graph:CreateNode("Print")

    touch_sensor.Position = Vector2.new(0, 0)

    electrocyte_node.Position = Vector2.new(230, 0)

    print_node:_SetInput("Message", "Zapped an enemy!")
    print_node.Position = Vector2.new(230, 50)

    graph:ConnectNodes(touch_sensor, "Touched", electrocyte_node, "Electrocute")
    graph:ConnectNodes(touch_sensor, "Touched", print_node, "Log")

    local keybind = graph:CreateNode("Keybind")
    keybind:_SetInput("Key", "R")
    keybind.Position = Vector2.new(0, 100)

    local ui_button = graph:CreateNode("UIButton")
    ui_button.Position = Vector2.new(0, 200)
    ui_button:_SetInput("Label", "Launch")
    ui_button:_SetInput("Position", "10,20")
    
    local nectophore = graph:CreateNode("Nectophore")
    nectophore:_SetInput("Force", 100)
    nectophore.Position = Vector2.new(230, 150)

    graph:ConnectNodes(keybind, "KeyPressed", nectophore, "Launch")
    graph:ConnectNodes(ui_button, "Activated", nectophore, "Launch")


    local ticker = graph:CreateNode("Ticker")
    ticker.Position = Vector2.new(0, 350)
    ticker:_SetInput("Interval", 1)

    local light_sensor = graph:CreateNode("LightDetector")
    light_sensor.Position = Vector2.new(230, 350)

    local compare = graph:CreateNode("LessThanCondition")
    compare.Position = Vector2.new(460, 350)
    compare:_SetInput("B", 0.5)

    local esca = graph:CreateNode("Esca")
    esca.Position = Vector2.new(690, 350)

    -- graph:ConnectNodes(ticker, "Tick", light_sensor, "Sense")
    -- graph:ConnectNodes(light_sensor, "Brightness", compare, "A")
    -- graph:ConnectNodes(light_sensor, "Brightness", compare, "Check")
    -- graph:ConnectNodes(compare, "True", esca, "Enable")
    -- graph:ConnectNodes(compare, "False", esca, "Disable")

    return graph
end
