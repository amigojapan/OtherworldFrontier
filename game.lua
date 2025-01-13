local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local tableLines = {}
local cursor = { Line = 1, Column = 1 }
local columns = 40
local rows = 25
textZoneRectangle=nil
local characterTimer=nil
function continue()
    timer.cancel(characterTimer)
    characterTimer=timer.performWithDelay( 1, coPrintOneCharOfSlowPrint, 0, "charTimer" )
end
local function initTextScreen(sceneGroup)
    -- The C64's resolution is 320×200 pixels, which is made up of a 40×25 grid of 
    -- 8×8 character blocks. Adjusted for HD displays to use 80 characters wide.

    local aspectRatio = 3
    local fontWH = 8 * aspectRatio
    textZoneRectangle = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, (fontWH * columns) , fontWH * rows)
    textZoneRectangle.strokeWidth = 5
    textZoneRectangle:setFillColor(0, 0, 0, 0.5)
    textZoneRectangle:setStrokeColor(1, 0, 0)

    -- Initialize tableLines and create text objects
    tableLines = {}
    for Line = 1, rows do
        local lblLine = display.newText(sceneGroup, "一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十", display.contentCenterX, 200 + (Line * fontWH), "fonts/ume-tgc5.ttf", fontWH)
        table.insert(tableLines, lblLine)
    end
    local lblContinue = display.newText(sceneGroup, "Continue...",(columns-12)*fontWH, 200 + (rows * fontWH), "fonts/ume-tgc5.ttf", fontWH)
    lblContinue:addEventListener( "touch", continue )
end 
local function hideTextArea()
    for key, lblLine in ipairs(tableLines) do
        lblLine.isVisible=false
    end
    textZoneRectangle.isVisible=false
end
local function showTextArea()
    for key, lblLine in ipairs(tableLines) do
        lblLine.isVisible=true
    end
    textZoneRectangle.isVisible=true
end
local function CLS()
    for _, line in ipairs(tableLines) do
        line.text = string.rep("　", columns)
    end
end
lineChanged=false
local function LOCATE(L, C)
    cursor.Line = L
    cursor.Column = C
	lineChanged=true
end

local function NEWENDLINE()
    --if cursor.Line == columns then
    --    for L = 1, cursor.Line, 1 do
    --        if tableLines[L+1] then 
    --            tableLines[L].text = tableLines[L+1].text
    --        end
    --    end
    --    tableLines[#tableLines].text = string.rep("　", columns) -- Clear the first line
    --else
        cursor.Line=cursor.Line+1
        cursor.Column=1
    --end
end
local queue
local function PRINT(STRING)
    --eliminate newlibes
    STRING=STRING:gsub("\n","")
    while #STRING > 0 do
        -- Calculate the remaining space on the current line
        local remainingSpace = 118 - cursor.Column + 1 -- hack, I dont know why but I replaced columns with the number 118 and seems to work for Japanese
        local toPrint = STRING:sub(1, remainingSpace)

        -- Get the text currently on the line
        local currentLine = tableLines[cursor.Line].text

        -- Concatenate text correctly
        local textbefore = currentLine:sub(1, cursor.Column - 1)
        local textafter = currentLine:sub(cursor.Column + #toPrint)

        local updatedLine = textbefore .. toPrint .. textafter
        tableLines[cursor.Line].text = updatedLine

        -- Remove the portion of the string that was printed
        STRING = STRING:sub(#toPrint + 1)

        -- Update the cursor position
        if #STRING > 0 then
            cursor.Line = cursor.Line + 1
            if cursor.Line > #tableLines then
                NEWENDLINE()
                cursor.Line = #tableLines
            end
            cursor.Column = 1
        else
            cursor.Column = cursor.Column + #toPrint
        end
    end
end


local stringForSlowPrint
local oneline
local character
--[[
coPrintOneCharOfSlowPrint = coroutine.create(function () 
    character  = string.sub(oneline, 1, 3)
    print("here3 character:"..character )
    oneline=string.sub(oneline, 7, #oneline)--seems hte whole problem is in hte lack of support for utf8
    print("oneline:"..oneline )
    if oneline=="" then
        --timer.cancel(characterTimer)
    end
    PRINT(character)
    --coroutine.yield()
end)
]]
function coPrintOneCharOfSlowPrint() 
    character  = string.sub(oneline, 1, 3)
    print("here3 character:"..character )
    oneline=string.sub(oneline, 4, #oneline)--seems hte whole problem is in hte lack of support for utf8
    print("#oneline:'"..#oneline.."'" )
    if #oneline==0 then
        timer.cancel(characterTimer)
    end
    if character=="改" then
        NEWENDLINE()
        print("newline")
    else
        PRINT(character)
    end
    --coroutine.yield()
end

--local utf8 = require "utf8"
--utf8.len(stringForSlowPrint)>40
local function SLOWPRINT(timeInMilllisecods,string)
    if stringForSlowPrint==nil then
        stringForSlowPrint=""
    end
    stringForSlowPrint=stringForSlowPrint..string
    --hack to make the flowprint work, otherwise it is jittery
    --hack fix, it does nto want to work form columb 1
    --repeat
        --LOCATE(cursor.Line,2)
        if string.len(stringForSlowPrint)>40 then
            oneline = string.sub(stringForSlowPrint, 1, #stringForSlowPrint)--80 shoudl be two characters in utf8???
            print("here1")
            stringForSlowPrint=string.sub(stringForSlowPrint, 40, #stringForSlowPrint)
            characterTimer=timer.performWithDelay( timeInMilllisecods, coPrintOneCharOfSlowPrint, 0, "charTimer" )
        else
            if character then
               print("here2 oneline:"..oneline)
            end
            online= stringForSlowPrint
            characterTimer=timer.performWithDelay( timeInMilllisecods, coPrintOneCharOfSlowPrint, 0, "charTimer" )
            oneline=""
        end
        --coroutine.resume(coPrintOneCharOfSlowPrint)
    --until #oneline==0
end
function QUESLOWPRINT(string)
    if stringForSlowPrint==nil then
        stringForSlowPrint=""
    end
    stringForSlowPrint=stringForSlowPrint..string
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        initTextScreen(sceneGroup)
        showTextArea()
        CLS()
		--PRINT("こんにちは世界！")
        QUESLOWPRINT("改")
        QUESLOWPRINT("こんにちは世界！改日本語の文章を試します、昔々あるところでおじいちゃんとおばあちゃんがいました、おじいちゃんが芝刈りに、おばあちゃんが川で洗濯してました。")
        QUESLOWPRINT("改")
        QUESLOWPRINT("こんにちは世界！改日本語の文章を試します、昔々あるところでおじいちゃんとおばあちゃんがいました、おじいちゃんが芝刈りに、おばあちゃんが川で洗濯してました。")
        SLOWPRINT(100,"")

        --(workaround)bug makes one slowprint wait for the one in back to finish
        --maybe just append the string to the outpusiting if there is already one SLOWPRINT working
        --idea, for the continue button, just set the timer to a shorter period, that way it will appear quickly but nto completly instantaneously  and be less work
        --SLOWPRINT(100,"こんにちは世界！日本語の文章を試します、昔々あるところでおじいちゃんとばあちゃんがいました、おじいちゃんが芝刈りに、おばあちゃんが川で洗濯してました")
        
        --LOCATE(24,10)
		--PRINT("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		--PRINT("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB")
		--PRINT("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
        --hideTextArea()
        
	end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif (phase == "did") then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene