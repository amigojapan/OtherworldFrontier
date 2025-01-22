local tableLines = {}
local cursor = { Line = 1, Column = 1 }
local columns = 40
local rows = 25
local callbackFunction
local stringForSlowPrint
local STRING="なし"
local printing=false
local localizedSpace=nil
Lang=nil
textZoneRectangle=nil
characterTimer=nil
function continue()
    if printing==false then
        timer.cancel(characterTimer)
        callbackFunction()
        print("continue next")
    else
        timer.cancel(characterTimer)
        characterTimer=timer.performWithDelay( 1, coPrintOneCharOfSlowPrint, 0, "charTimer" )
        print("continue fast")    
    end
end
function initTextScreen(sceneGroup,language)
    -- The C64's resolution is 320×200 pixels, which is made up of a 40×25 grid of 
    -- 8×8 character blocks. Adjusted for HD displays to use 80 characters wide.
    Lang=language
    
    local aspectRatio = nil
    local fontWH = nil
    local magicalNumber=nil
    if Lang=="JP" then
        aspectRatio = 4
        fontWH = 8 * aspectRatio
        columns = 40
        rows = 25
        magicalNumber=0
        localizedSpace="　"
    else
        aspectRatio = 4
        fontWH = 16 * aspectRatio
        columns = 40
        rows = 12
        magicalNumber=1300--dunno why but I need to substract this number to get the right size of the red rectangle
        localizedSpace=" "
    end
    textZoneRectangle = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, (fontWH * columns)-magicalNumber  , fontWH * rows)
    textZoneRectangle.strokeWidth = 5
    textZoneRectangle:setFillColor(0, 0, 0, 0.5)
    textZoneRectangle:setStrokeColor(1, 0, 0)

    -- Initialize tableLines and create text objects
    tableLines = {}
    for Line = 1, rows do
        local lblLine
        if Lang=="JP" then
            lblLine = display.newText(sceneGroup, "一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十", display.contentCenterX, 100+(Line * fontWH), "fonts/ume-tgc5.ttf", fontWH)--100 is a hack to align the text and the window
        else
            lblLine = display.newText(sceneGroup, "1234567890123456789012345678901234567890", display.contentCenterX, 100+(Line * fontWH), "fonts/ume-tgc5.ttf", fontWH)--100 is a hack to align the text and the window
        end
        table.insert(tableLines, lblLine)
    end
    local lblContinue
    
    print("Lang:"..Lang)
    if Lang=="JP" then
        print("here4!!")
        lblContinue = display.newText(sceneGroup, "[続き...]",(columns-12)*fontWH, 200 + (rows * fontWH), "fonts/ume-tgc5.ttf", fontWH)
        --lblContinue = display.newText(sceneGroup, "Continue...", 200, 200, "fonts/ume-tgc5.ttf", fontWH)
    else
        lblContinue = display.newText(sceneGroup, "[Continue...]", 750, 1000, "fonts/ume-tgc5.ttf", fontWH)
    end
    lblContinue:addEventListener( "tap", continue )
end 
function hideTextArea()
    for key, lblLine in ipairs(tableLines) do
        lblLine.isVisible=false
    end
    textZoneRectangle.isVisible=false
end
function showTextArea()
    for key, lblLine in ipairs(tableLines) do
        lblLine.isVisible=true
    end
    textZoneRectangle.isVisible=true
end
function CLS()
    for _, line in ipairs(tableLines) do
        line.text = string.rep(localizedSpace, columns)
    end
    cursor.Line=1
    cursor.Column=1
end
lineChanged=false
function LOCATE(L, C)
    cursor.Line = L
    cursor.Column = C
	lineChanged=true
end

function NEWENDLINE()
    if cursor.Line >= rows-2 then--why 2 and not 1? not sure
        for L = 1, rows, 1 do
            if tableLines[L+1] then 
                tableLines[L].text = tableLines[L+1].text
            end
        end
        tableLines[#tableLines].text = string.rep(localizedSpace, columns) -- Clear the first line
        cursor.Column=1
    else
        cursor.Line=cursor.Line+1
        cursor.Column=1
    end
end
local queue

function getCharWidth(ch)
    if string.byte(ch) < 128 then
        return 0.5 -- ASCII characters
    else
        return 1 -- Full-width characters (e.g., Japanese)
    end
end
function getStringWidth(str)
    local width = 0
    local i = 1
    local len = #str

    while i <= len do
        local byte = string.byte(str, i)
        if byte < 128 then
            -- ASCII character (single byte, half-width)
            width = width + 0.5
            i = i + 1
        else
            -- Non-ASCII character (double-width)
            width = width + 1
            if byte >= 192 and byte <= 223 then
                i = i + 2 -- Two-byte character
            elseif byte >= 224 and byte <= 239 then
                i = i + 3 -- Three-byte character
            elseif byte >= 240 and byte <= 247 then
                i = i + 4 -- Four-byte character
            else
                i = i + 1 -- Fallback for malformed sequences
            end
        end
    end

    return width
end

function PRINT(STR)
    --eliminate newlibes
    STRING=STR:gsub("\n","^")
    printing=true
    STRING=STR:gsub("なし","")
    
    while #STRING > 0 do
        -- Calculate the remaining space on the current line
        local remainingSpace
        if Lang=="JP" then
            remainingSpace = 117 - cursor.Column + 1 -- (this would not be a problem ifn lua for solar2d supported utf8 characters)the number 118 was causing a problem, I chnaged it to 117 and it seems to work.hack, I dont know why but I replaced columns with the number 118 and seems to work for Japanese
        else
            remainingSpace = columns - cursor.Column + 1 -- (this would not be a problem ifn lua for solar2d supported utf8 characters)the number 118 was causing a problem, I chnaged it to 117 and it seems to work.hack, I dont know why but I replaced columns with the number 118 and seems to work for Japanese
        end
        local toPrint = STRING:sub(1, remainingSpace)

        local characterWasAscii
        if isAscii2(toPrint) then
            characterWasAscii=true
        else 
            characterWasAscii=false
        end
        -- Get the text currently on the line
        local currentLine = tableLines[cursor.Line].text

        -- Concatenate text correctly
        local textbefore = currentLine:sub(1, cursor.Column - 1)
        local textafter
        if characterWasAscii then
            if Lang=="JP" then
                textafter = currentLine:sub((cursor.Column + #toPrint)+1)--I think this was the fix I was looking for, it is not perfect but seems to work well enough
            else
                textafter = currentLine:sub(cursor.Column + #toPrint)
            end    
        else
            textafter = currentLine:sub(cursor.Column + #toPrint)
        end
        local updatedLine = textbefore .. toPrint .. textafter

        if cursor.Line==rows-1 then
            NEWENDLINE()
            LOCATE(cursor.Line-1,1)--changing LOCATE(cursor.Line-2,1) to LOCATE(cursor.Line-1,1) seems to have fixed the newline problem 
        end
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



local oneline
local character
function treatAsAscii(oneline)
    local ch  = string.sub(oneline, 1, 1)
    --print("here3 character:"..character )
    local ol=string.sub(oneline, 2, #oneline)--seems hte whole problem is in hte lack of support for utf8
    --print("oneline:'"..oneline.."'" )
    return ch,ol
end

function treatAsUTF8(oneline)
    local ch  = string.sub(oneline, 1, 3)
    --print("here3 character:"..character )
    local ol=string.sub(oneline, 4, #oneline)--seems hte whole problem is in hte lack of support for utf8
    --print("oneline:'"..oneline.."'" )
    return ch,ol
end

function isAscii2(character)
    -- Check if the character is single-byte and within ASCII range (0–127)
    local byte = string.byte(character)
    if byte and byte >= 0 and byte <= 127 then
        return true
    else
        return false
    end
end

function isAscii()
    local ch=treatAsAscii(oneline)
    if string.byte(ch)<148 then--148 seems like hte last valid ascii character to me
        return true
    else
        return false
    end
end

function coPrintOneCharOfSlowPrint() 
    if Lang=="JP" then -- **need to figuure out a way to display both english and Japanese on the syste withoughht overflowing the line,maybe I can somehow figure out if a character is alphanumerical and handle it differently form Japanese?
        if isAscii(oneline) then
            character,oneline=treatAsAscii(oneline)
        else
            character,oneline=treatAsUTF8(oneline)
        end
    else
        character,oneline=treatAsAscii(oneline)
    end
    --print("#oneline:"..#oneline)        
    if #oneline==0 then
        timer.cancel(characterTimer)
        printing=false
        return
        --(it was not here, I thtink it is when I click the continue button--old comment: I think this may be hte place to set the next continue button...
    end
    if character=="改" or character=="^" then
        NEWENDLINE()
        print("newline")
    else
        PRINT(character)
    end
    --coroutine.yield()
end

--local utf8 = require "utf8"
--utf8.len(stringForSlowPrint)>40
function SLOWPRINT(timeInMilllisecods,string,callbackFunctionWhenFinished)
    callbackFunction=callbackFunctionWhenFinished
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
function RESETQUE()
    stringForSlowPrint=""
end
function QUESLOWPRINT(string)
    if stringForSlowPrint==nil then
        stringForSlowPrint=""
    end
    stringForSlowPrint=stringForSlowPrint..string
    print(stringForSlowPrint)
end