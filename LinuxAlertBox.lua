local function cleanup()
    --local objects = {background, alertBox, titleText, messageText, yesButton, yesText, noButton, noText}
    local objects = {alertBox, titleText, messageText, yesButton, yesText, noButton, noText}
    for _, obj in ipairs(objects) do
        if obj and obj.removeSelf then
            obj:removeSelf()
        end
    end
    --background, 
    alertBox, titleText, messageText, yesButton, yesText, noButton, noText = nil, nil, nil, nil, nil, nil, nil, nil

    if group and group.removeSelf then
        group:removeSelf()
        group = nil
    end
end

function createCustomAlert(title, message, onYesPress, onNoPress)
    -- Create a semi-transparent background
    --local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    --background:setFillColor(0, 0, 0, 0.5)
    --background.isHitTestable = true

    -- Create the alert box
    local alertBox = display.newRoundedRect(display.contentCenterX, display.contentCenterY, 300, 200, 15)
    alertBox:setFillColor(0.3)
    alertBox:setStrokeColor(0.2)
    alertBox.strokeWidth = 2

    -- Title text
    local titleText = display.newText({
        text = title,
        x = display.contentCenterX,
        y = display.contentCenterY - 60,
        width = 280,
        font = "fonts/ume-tgc5.ttf", --(japanese font) Replace with your custom font if needed
        fontSize = 20,
        align = "center"
    })
    titleText:setFillColor(1)

    -- Message text
    local messageText = display.newText({
        text = message,
        x = display.contentCenterX,
        y = display.contentCenterY - 20,
        width = 280,
        font = "fonts/ume-tgc5.ttf", -- Replace with your custom font if needed
        fontSize = 16,
        align = "center"
    })
    messageText:setFillColor(1)

    -- Yes button
    local yesButton = display.newRoundedRect(display.contentCenterX - 80, display.contentCenterY + 60, 100, 40, 10)
    yesButton:setFillColor(0.5, 0.5, 0.5)

    local yesText = display.newText({
        text = "Yes",
        x = display.contentCenterX - 80,
        y = display.contentCenterY + 60,
        font = native.systemFontBold, -- Replace with your custom font if needed
        fontSize = 18,
        align = "center"
    })
    yesText:setFillColor(1)

    -- No button
    local noButton = display.newRoundedRect(display.contentCenterX + 80, display.contentCenterY + 60, 100, 40, 10)
    noButton:setFillColor(0.5, 0.5, 0.5)

    local noText = display.newText({
        text = "No",
        x = display.contentCenterX + 80,
        y = display.contentCenterY + 60,
        font = native.systemFontBold, -- Replace with your custom font if needed
        fontSize = 18,
        align = "center"
    })
    noText:setFillColor(1)

    -- Button handlers
    local function handleYesTap(event)
        if onYesPress then
            onYesPress()
        end

        -- Remove all elements
        --background:removeSelf()
        alertBox:removeSelf()
        titleText:removeSelf()
        messageText:removeSelf()
        yesButton:removeSelf()
        yesText:removeSelf()
        noButton:removeSelf()
        noText:removeSelf()
        --for key, value in ipairs( display.getCurrentStage()) do
        --    value.isVisible=false--hack to hide hte invisible object that I do't know what it is  
        --end
    end

    local function handleNoTap(event)
        if onNoPress then
            onNoPress()
        end

        -- Remove all elements
        --background:removeSelf()
        alertBox:removeSelf()
        titleText:removeSelf()
        messageText:removeSelf()
        yesButton:removeSelf()
        yesText:removeSelf()
        noButton:removeSelf()
        noText:removeSelf()
        --background=nil
        alertBox=nil
        titleText=nil
        messageText=nil
        yesButton=nil
        yesText=nil
        noButton=nil
        noText=nil
        cleanup()
    end

    yesButton:addEventListener("tap", handleYesTap)
    noButton:addEventListener("tap", handleNoTap)

    -- Group all elements
    local group = display.newGroup()
    --group:insert(background)
    group:insert(alertBox)
    group:insert(titleText)
    group:insert(messageText)
    group:insert(yesButton)
    group:insert(yesText)
    group:insert(noButton)
    group:insert(noText)

    return group
end

-- Example usage
--[[
createCustomAlert(
    "Custom Alert",
    "Do you want to proceed?",
    function()
        print("Yes pressed!")
    end,
    function()
        print("No pressed!")
    end
)
]]