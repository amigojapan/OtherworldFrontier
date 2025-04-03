local function loadLevel()
    local path = system.pathForFile("level.json", system.DocumentsDirectory)
    local file, errorString = io.open(path, "r")
    if file then
        local jsonString = file:read("*a")
        io.close(file)
        --print("json sting:"..jsonString)
        local serializableBoxes = json.decode(jsonString)
        
        -- Clear existing boxes
        for i = #tblBoxes, 1, -1 do
            local box = tblBoxes[i]
            box:removeSelf() -- Remove from display
            table.remove(tblBoxes, i) -- Remove from table
        end
        --diagnostic
        print("Number of items: " .. #serializableBoxes) -- Should match JSON array length
        for i, data in ipairs(serializableBoxes) do
            print("Item " .. i .. " type: " .. type(data)) -- Should be "table"
            if type(data) == "table" then
                print("Item " .. i .. " label: " .. tostring(data.label)) -- Should show label or "nil"
            end
            if data.label==nil then
                print("nil label found in data, skipping")
            else
                -- Box creation code
            end
        end
        local mistranlsEndInData=false
        -- Recreate boxes from loaded data
        for _, data in ipairs(serializableBoxes) do
                if data.label==nil then
                    print("nil label found in data, skipping")
                else
                --local box = display.newImageRect("img/block-white.png", data.size, data.size)
                if data.color=="colorWhite" then
                    box = display.newImageRect("img/block-white.png", 32, 32)    
                elseif data.color=="colorRed" then
                    box = display.newImageRect("img/block-red.png", 32, 32)    
                elseif data.color=="colorGreen" then
                    box = display.newImageRect("img/block-green.png", 32, 32)    
                elseif data.color=="colorBlue" then
                    box = display.newImageRect("img/block-blue.png", 32, 32)    
                elseif data.color=="colorYellow" then
                    box = display.newImageRect("img/block.png", 32, 32)    
                end
                print("label:"..data.label)
                if data.label=="mist_end_exit" then
                    mistranlsEndInData=true
                end
                box.label = data.label
                box.color = data.color
                box.x = data.x
                box.y = data.y
                box.size = data.size
                box.alpha = 0.3
                box:addEventListener("tap", boxListener) -- Add your tap listener if needed
                table.insert(tblBoxes, box)
            end
        end
        print("Level loaded successfully.")
    else
        print("Error loading level: " .. errorString)
    end
    if mistranlsEndInData then
        print("mistrals end in data")
    else
        print("warning:mistrals end NOT in data")
    end

end
