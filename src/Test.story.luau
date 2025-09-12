--[[
    Test script that manually constructs graphs and runs them
]]

local VisualScriptingLanguage = require(script.Parent)

return function()
    local threads = {}

    local language = VisualScriptingLanguage.new(true)

    do
        local explode_node = language.BuildNode()
        explode_node.ui_name = "Explode"
        explode_node:AddInput("Explosion Power", "number")
        explode_node:AddInputSignal("Explode", function(ctx)
            print(`Kaboom with {ctx:ExtractInput("Explosion Power")} explosion power!`)
        end)
        language:RegisterNode("Explode", explode_node)
    end

    do
        local random_node = language.BuildNode()
        random_node.ui_name = "Random"
        random_node:AddOutput("Result", "number")
        random_node:AddInputSignal("Generate", function(ctx)
            ctx:SetOutput("Result", math.random(1, 2))
        end)
        language:RegisterNode("StupidRandom", random_node)
    end

    do
        local touch_sensor_node = language.BuildNode()
        touch_sensor_node.ui_name = "Touch Sensor"
        touch_sensor_node:AddOutput("Touched")
        language:RegisterNode("TouchSensor", touch_sensor_node)
    end
    
    do
        local altitude_sensor_node = language.BuildNode()
        altitude_sensor_node.ui_name = "Altitude Sensor"
        altitude_sensor_node:AddOutput("Reading", "number")
        altitude_sensor_node:AddInputSignal("Measure", function(ctx)
            ctx:SetOutput("Reading", math.random(1, 100))
        end)
        language:RegisterNode("AltitudeSensor", altitude_sensor_node)
    end

    if true then
        local graph = language:CreateBlankGraph()
        local rng_node = graph:CreateNode("StupidRandom")
        local print_false_node = graph:CreateNode("Print")
        local print_true_node = graph:CreateNode("Print")
        local condition_node = graph:CreateNode("Condition")

        condition_node:_SetInput("Compare", 1)
        condition_node:_SetInput("Value", 99)

        print_true_node:_SetInput("Message", "Value is True")
        print_false_node:_SetInput("Message", "Value is False")

        graph:ConnectNodes(rng_node, "Result", condition_node, "Value")
        graph:ConnectNodes(rng_node, "Result", condition_node, "Check")
        graph:ConnectNodes(condition_node, "True", print_true_node, "Log")
        graph:ConnectNodes(condition_node, "False", print_false_node, "Log")

        graph:Debug()
        rng_node:_SetInput("Generate")
        graph:Debug()
    end

    if false then
        local graph = language:CreateBlankGraph()
        
        local touch_sensor = graph:CreateNode("TouchSensor")
        local print_node = graph:CreateNode("Print")
        print_node:_SetInput("Message", "Touched!")
        graph:ConnectNodes(touch_sensor, "Touched", print_node, "Log")

        touch_sensor:SetOutput("Touched")
    end
    
    if false then -- todo
        local graph = language:CreateBlankGraph()
        
        local ticker = graph:CreateNode("Ticker")
        local print_node = graph:CreateNode("Print")
        print_node:_SetInput("Message", "Ticked!")
        ticker:_SetInput("Interval", 0.1)
        graph:ConnectNodes(ticker, "Tick", print_node, "Log")
    end
    
    if false then
        local graph = language:CreateBlankGraph()
        
        local height_sensor = graph:CreateNode("AltitudeSensor")
        local print_node = graph:CreateNode("Print")

        graph:ConnectNodes(height_sensor, "Reading", print_node, "Log")
        graph:ConnectNodes(height_sensor, "Reading", print_node, "Message")
        
        table.insert(threads, task.spawn(function()
            while task.wait(0.1) do
                height_sensor:_SetInput("Measure")
            end
        end))
    end

    return function()
        for _, thread in threads do
            coroutine.close(thread)
        end
    end
end
