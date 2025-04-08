local composer = require("composer")
-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
rectBorder=nil
rectEdit=nil
lblTitle=nil
editBuffer=nil
okButton=nil
inputBuffer=""
local _callback=nil
LinuxInputBoxElements = display.newGroup()
--[[
function setAllObjectsHitTestable(group, value)
    value = value or false -- Default to false if no value is provided
    for i = 1, group.numChildren do
        local child = group[i]
        if child then
            -- Check if the object has the isHitTestable property
            if child.isHitTestable ~= nil then
				child.isVisible = value
                child.isHitTestable = value
            end

            -- If the child is a group, recurse into it
            if child.numChildren then
                setAllObjectsHitTestable(child, value)
            end
        end
    end
end
]]

function inputAccepted()
	LinuxInputBoxElements.iHitTestable=false
	LinuxInputBoxElements.isVisible=false
	composer.setVariable("inputBuffer",inputBuffer)
	composer.removeScene("LinuxScreenKeyboard")
	composer.gotoScene(composer.getSceneName( "previous" ))
end
function okButtonTouchListener( event )
	if event.phase == "ended" then
		print("ok clicked!")
		removerInputBox()
		inputAccepted()
	end
    return true  -- Prevents tap/touch propagation to underlying objects
end



local offsetx=600--this is the initial button position
local offsety=800

local paint = {
    type = "image",
    filename = "img/ok.png"
}
okButton = display.newRect(LinuxInputBoxElements,offsetx, offsety, 200, 100 )
okButton.fill = paint
okButton:addEventListener( "touch", okButtonTouchListener )  -- Add a "touch" listener to the obj
okButton.isVisible=false

function drawBorder(x,y,width,height)
		rectBorder = display.newRect(LinuxInputBoxElements,x,y,width,height)
		rectBorder.strokeWidth = 5
		rectBorder:setFillColor( 0, 0 , 0, 0.5 )
		rectBorder:setStrokeColor( 1, 1, 1 )
end
editBuffer=nil
function drawInputPrompt(x,y,width,height,prompt)
		disableContinueButton()
		lblTitle = display.newText(LinuxInputBoxElements, prompt, x, y, "fonts/ume-tgc5.ttf", 50 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )
		editBuffer = display.newText(LinuxInputBoxElements, "", x, y+100, "fonts/ume-tgc5.ttf", 50 )
		editBuffer:setFillColor( 0.82, 0.86, 1 )
		rectEdit = display.newRect(LinuxInputBoxElements,x,y+100,width-300,height-700)
		rectEdit.strokeWidth = 5
		rectEdit:setFillColor( 1, 1 , 1, 0.5 )
		rectEdit:setStrokeColor( 1, 1, 1 )
end

function removeScreenKeyboard()
	print("RemoveScreenKeyboard called")
	for key, value in ipairs(keysLablesTable) do
		--print(value)
		value.isVisible=false
		if value.removeSelf then
			value:removeSelf()
		end
	end
end

function logDisplayObjects()
	print("Number of active display objects: " .. display.getCurrentStage().numChildren)
	for i = 1, display.getCurrentStage().numChildren do
		print("Object " .. i .. ": " .. tostring(display.getCurrentStage()[i]))
		
		--if i==2 then
		--	local buggyObject=display.getCurrentStage()[i]
		--	buggyObject.isVisible=false
			--buggyObject:removeSelf()
			--buggyObject=nil
		--end
	end
	--this hack seems to hide the black object from any extra number of screens
	print ("display.getCurrentStage().numChildren"..display.getCurrentStage().numChildren)
	display.getCurrentStage()[display.getCurrentStage().numChildren-1].isVisible=false--hack to hide hte invisible object that I do't know what it is
	--display.getCurrentStage()[2]:removeSelf()--cant do this, cause it seems composer tries to bring this object to the front
end
function removerInputBox(event)
    -- Set all objects back to being hit-testable
    --setAllObjectsHitTestable(display.getCurrentStage(), true)

    -- Remove rectBorder
    if rectBorder and rectBorder.removeSelf then
        rectBorder:removeSelf()
        rectBorder = nil
    end

    -- Remove rectEdit
    if rectEdit and rectEdit.removeSelf then
        rectEdit:removeSelf()
        rectEdit = nil
    end

    -- Remove lblTitle
    if lblTitle and lblTitle.removeSelf then
        lblTitle:removeSelf()
        lblTitle = nil
    end

    -- Remove editBuffer
    if editBuffer then
		if editBuffer.removeSelf then
			editBuffer:removeSelf()
			editBuffer = nil
		end
    end

    -- Remove okButton
    if okButton and okButton.removeSelf then
        okButton:removeSelf()
        okButton = nil
    end

    -- Clear screen keyboard
    removeScreenKeyboard()

    -- Remove event listeners
    Runtime:removeEventListener("enterFrame", frameUpdate)
    Runtime:removeEventListener("key", onKeyEvent)

	logDisplayObjects()
	LinuxInputBoxElements.isVisible=false
end

--handle keystrokes
downkey=""

local action = {}
function addInputToBuffer(downkey)
	if downkey == "enter" then
		print("inputBuffer:"..inputBuffer)
		removerInputBox()
		inputAccepted()
		
		--_callback(inputBuffer)
		--inputBuffer=""
		downkey=""
		--removerInputBox()
		return
	end
	if downkey == "deleteBack" or downkey == "back" or downkey == "<<" then
		inputBuffer = inputBuffer:sub(1, -2)--deletes last character off the buffer
		print("delete pressed")
		downkey=""
	end

	if downkey == "escape" then
		inputBuffer = ""
		print("escape pressed")
		downkey=""
	end

	if downkey == "space" then
		inputBuffer = inputBuffer .. " "
		print("space pressed")
		downkey=""
	end

	if downkey == "unknown" then
		print("unknown key pressed")
		downkey=""
		return
	end
		
	if downkey ~= "" then
		print("downkey:"..downkey)
		inputBuffer=inputBuffer..downkey
		downkey=""
	end
	
	if editBuffer then 
		editBuffer.text=inputBuffer
	end
end
function frameUpdate()
	local keyDown = false
	-- See if one of the selected action buttons is down and move the knight.
	if downkey then
		addInputToBuffer(downkey)
		downkey=""
	end
end

function onKeyEvent( event )
	if event.phase == "down" then
	else
		downkey=event.keyName
		return true
	end
	return true
end
--help button
webView=nil
keysTable={}
keysLablesTable={}
local functionTable={}
function getFunctionName()
    local info = debug.getinfo(2, "n")
    return info.name or "anonymous"
end
function clickOnScreenKeys(event)
	if event.phase == "ended" then
		print("clickOnScreenKeys called")
		print(event.target.text)
		addInputToBuffer(event.target.text)
	end
	return true
end

function bringUpScreenKeyboard()
	keysTable={}
	table.insert(keysTable, "1")
	table.insert(keysTable, "2")
	table.insert(keysTable, "3")
	table.insert(keysTable, "4")
	table.insert(keysTable, "5")
	table.insert(keysTable, "6")
	table.insert(keysTable, "7")
	table.insert(keysTable, "8")
	table.insert(keysTable, "9")
	table.insert(keysTable, "0")
	table.insert(keysTable, "-")
	table.insert(keysTable, "<<")
	local xoffsetinitial=500
	local xoffset=xoffsetinitial+100--initial position of keys
	local yoffset=200
	for key, value in ipairs(keysTable) do
		local lable = display.newText(LinuxInputBoxElements, value, xoffset, yoffset, "fonts/ume-tgc5.ttf", 50 )
		lable:setFillColor( 0.82, 0.86, 1 )
		lable:addEventListener( "touch", clickOnScreenKeys )
		table.insert(keysLablesTable, lable)
		xoffset=xoffset+50
	end
	yoffset=yoffset+50
	xoffset=xoffsetinitial+125
	keysTable={}
	table.insert(keysTable, "q")
	table.insert(keysTable, "w")
	table.insert(keysTable, "e")
	table.insert(keysTable, "r")
	table.insert(keysTable, "t")
	table.insert(keysTable, "y")
	table.insert(keysTable, "u")
	table.insert(keysTable, "i")
	table.insert(keysTable, "o")
	table.insert(keysTable, "p")
	for key, value in ipairs(keysTable) do
		local lable = display.newText(LinuxInputBoxElements, value, xoffset, yoffset, "fonts/ume-tgc5.ttf", 50 )
		lable:setFillColor( 0.82, 0.86, 1 )
		lable:addEventListener( "touch", clickOnScreenKeys )
		table.insert(keysLablesTable, lable)
		xoffset=xoffset+50
	end
	yoffset=yoffset+50
	xoffset=xoffsetinitial+150
	keysTable={}
	table.insert(keysTable, "d")
	table.insert(keysTable, "a")
	table.insert(keysTable, "s")
	table.insert(keysTable, "d")
	table.insert(keysTable, "f")
	table.insert(keysTable, "g")
	table.insert(keysTable, "h")
	table.insert(keysTable, "j")
	table.insert(keysTable, "k")
	table.insert(keysTable, "l")
	for key, value in ipairs(keysTable) do
		local lable = display.newText(LinuxInputBoxElements, value, xoffset, yoffset, "fonts/ume-tgc5.ttf", 50 )
		lable:setFillColor( 0.82, 0.86, 1 )
		lable:addEventListener( "touch", clickOnScreenKeys )
		table.insert(keysLablesTable, lable)
		xoffset=xoffset+50
	end
	yoffset=yoffset+50
	xoffset=xoffsetinitial+175
	keysTable={}
	table.insert(keysTable, "z")
	table.insert(keysTable, "x")
	table.insert(keysTable, "c")
	table.insert(keysTable, "v")
	table.insert(keysTable, "b")
	table.insert(keysTable, "n")
	table.insert(keysTable, "m")
	table.insert(keysTable, "_")
	for key, value in ipairs(keysTable) do
		local lable = display.newText(LinuxInputBoxElements, value, xoffset, yoffset, "fonts/ume-tgc5.ttf", 50 )
		lable:setFillColor( 0.82, 0.86, 1 )
		lable:addEventListener( "touch", clickOnScreenKeys )
		table.insert(keysLablesTable, lable)
		xoffset=xoffset+50
	end
	yoffset=yoffset+50
	xoffset=xoffsetinitial+350
	local lable = display.newText(LinuxInputBoxElements, "space", xoffset, yoffset, "fonts/ume-tgc5.ttf", 50 )
	lable:setFillColor( 0.82, 0.86, 1 )
	lable:addEventListener( "touch", clickOnScreenKeys )
	table.insert(keysLablesTable, lable)
	
end




prebuff=nil
function showInputBox(prompt,callback,predefinedBuffer)
	print("showInputBox called")
	if predefinedBuffer == nil then
		predefinedBuffer=""
	end
	inputBuffer=predefinedBuffer
	--disable isHitTestable for all display objects
	--setAllObjectsHitTestable(display.getCurrentStage(),false)
	print("All objects set to isHitTestable = false")
	
	_callback=callback
	--if okButton == nil then
		--**(I have not run into this bug anymore)fix bug of second click on ok button , it is nil and it crashes
		
		local paint = {
			type = "image",
			filename = "img/ok.png"
		}
		okButton = display.newRect(LinuxInputBoxElements, offsetx, offsety, 200, 100 )
		okButton.fill = paint
		okButton:addEventListener( "touch", okButtonTouchListener )  -- Add a "touch" listener to the obj
	--end
	okButton.isVisible=true
	drawBorder(display.contentCenterX, display.contentCenterY, 1000-100, 800-50)
	drawInputPrompt(display.contentCenterX, display.contentCenterY, 1000-100, 800-50,prompt)
	Runtime:addEventListener( "enterFrame", frameUpdate )
	Runtime:addEventListener( "key", onKeyEvent )
	--maybe do this optionally if on touchscreen
	bringUpScreenKeyboard()	
	LinuxInputBoxElements.isVisible=true
end


--call the following way in your program
--[[
function callback(userinput)
	print("the user inputed"..userinput)
	native.showAlert(
		"the user inputed", -- Title of the alert
		"the user inputed:"..userinput, -- Message content
		{ "OK" } -- Button labels
		--onComplete -- Listener for button clicks
	)
end
showInputBox("your prompt:",callback)
]]

--try adding a group to every object in here to it can be hid easily... for everything later (a way to fix the black ares)
--now the keybnoard is responding to lciks twice, it hsould be once