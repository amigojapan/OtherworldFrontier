local composer = require("composer")
local scene = composer.newScene()


local tableLines = {}
local cursor = { Line = 1, Column = 1 }
local columns = 40
local rows = 25
local currentcolumbs=columns
local callbackFunction
local stringForSlowPrint
local STRING="なし"
local printing=false
local localizedSpace=nil
composer.setVariable("lblContinue",nil)
Lang=nil
textZoneRectangle=nil
characterTimer=nil

if composer.getVariable( "speed" )==nil then
    composer.setVariable( "speed", 1)
end

function replaceStringOfRomajiWithDoubleWidthCHaracters(str)
    local doubleWidthString
    --！＂＃＄％＆＇（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠［＼］＾＿｀｛｜｝～￠￡￢￣￤￥￦ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ
    doubleWidthString = str.rep("!", "！")
    doubleWidthString = str.rep("\"", "＂")
    doubleWidthString = str.rep("#", "＃")
    doubleWidthString = str.rep("$", "＄")
    doubleWidthString = str.rep("%", "％")
    doubleWidthString = str.rep("&", "＆")
    doubleWidthString = str.rep("'", "＇")
    doubleWidthString = str.rep("(", "（")
    doubleWidthString = str.rep(")", "）")
    doubleWidthString = str.rep("*", "＊")
    doubleWidthString = str.rep("+", "＋")
    doubleWidthString = str.rep(",", "，")
    doubleWidthString = str.rep("-", "－")
    doubleWidthString = str.rep(".", "．")
    doubleWidthString = str.rep("/", "／")
    --０１２３４５６７８９
    doubleWidthString = str.rep("!", "０")
    doubleWidthString = str.rep("!", "１")
    doubleWidthString = str.rep("!", "２")
    doubleWidthString = str.rep("!", "３")
    doubleWidthString = str.rep("!", "４")
    doubleWidthString = str.rep("!", "５")
    doubleWidthString = str.rep("!", "６")
    doubleWidthString = str.rep("!", "７")
    doubleWidthString = str.rep("!", "８")
    doubleWidthString = str.rep("!", "９")
    --：；＜＝＞？＠［＼］＿｀｛｜｝～￥
    --omitted symbols ＾ because used for newline.￠￡￢￣￤￦ cause I dont know how to type them
    doubleWidthString = str.rep(":", "：")
    doubleWidthString = str.rep(";", "；")
    doubleWidthString = str.rep("<", "＜")
    doubleWidthString = str.rep("=", "＝")
    doubleWidthString = str.rep(">", "＞")
    doubleWidthString = str.rep("?", "？")
    doubleWidthString = str.rep("@", "＠")
    doubleWidthString = str.rep("[]", "［")
    doubleWidthString = str.rep("\\", "＼")
    doubleWidthString = str.rep("]", "］")
    doubleWidthString = str.rep("!", "＿")
    doubleWidthString = str.rep("`", "｀")
    doubleWidthString = str.rep("{", "｛")
    doubleWidthString = str.rep("|", "｜")
    doubleWidthString = str.rep("}", "｝")
    doubleWidthString = str.rep("~", "～")
    doubleWidthString = str.rep("¥", "￥")
    --ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ
    doubleWidthString = str.rep("A", "Ａ")
    doubleWidthString = str.rep("B", "Ｂ")
    doubleWidthString = str.rep("C", "Ｃ")
    doubleWidthString = str.rep("D", "Ｄ")
    doubleWidthString = str.rep("E", "Ｅ")
    doubleWidthString = str.rep("F", "Ｆ")
    doubleWidthString = str.rep("G", "Ｇ")
    doubleWidthString = str.rep("H", "Ｈ")
    doubleWidthString = str.rep("I", "Ｉ")
    doubleWidthString = str.rep("J", "Ｊ")
    doubleWidthString = str.rep("K", "Ｋ")
    doubleWidthString = str.rep("L", "Ｌ")
    doubleWidthString = str.rep("M", "Ｍ")
    doubleWidthString = str.rep("N", "Ｎ")
    doubleWidthString = str.rep("O", "Ｏ")
    doubleWidthString = str.rep("P", "Ｐ")
    doubleWidthString = str.rep("Q", "Ｑ")
    doubleWidthString = str.rep("R", "Ｒ")
    doubleWidthString = str.rep("S", "Ｓ")
    doubleWidthString = str.rep("T", "Ｔ")
    doubleWidthString = str.rep("U", "Ｕ")
    doubleWidthString = str.rep("V", "Ｖ")
    doubleWidthString = str.rep("W", "Ｗ")
    doubleWidthString = str.rep("X", "Ｘ")
    doubleWidthString = str.rep("Y", "Ｙ")
    doubleWidthString = str.rep("Z", "Ｚ")
    --ａｂｃｄｅｆｇｈｉｊ
    doubleWidthString = str.rep("a", "ａ")
    doubleWidthString = str.rep("b", "ｂ")
    doubleWidthString = str.rep("c", "ｃ")
    doubleWidthString = str.rep("d", "ｄ")
    doubleWidthString = str.rep("e", "ｅ")
    doubleWidthString = str.rep("f", "ｆ")
    doubleWidthString = str.rep("g", "ｇ")
    doubleWidthString = str.rep("h", "ｈ")
    doubleWidthString = str.rep("i", "ｉ")
    doubleWidthString = str.rep("j", "ｊ")
    --ｋｌｍｎｏｐｑ
    doubleWidthString = str.rep("k", "ｋ")
    doubleWidthString = str.rep("l", "ｌ")
    doubleWidthString = str.rep("m", "ｍ")
    doubleWidthString = str.rep("n", "ｎ")
    doubleWidthString = str.rep("o", "ｏ")
    doubleWidthString = str.rep("p", "ｐ")
    doubleWidthString = str.rep("q", "ｑ")
    --ｒｓｔｕｖｗｘｙｚ
    doubleWidthString = str.rep("r", "ｒ")
    doubleWidthString = str.rep("s", "ｓ")
    doubleWidthString = str.rep("t", "ｔ")
    doubleWidthString = str.rep("u", "ｕ")
    doubleWidthString = str.rep("v", "ｖ")
    doubleWidthString = str.rep("w", "ｗ")
    doubleWidthString = str.rep("x", "ｘ")
    doubleWidthString = str.rep("y", "ｙ")
    doubleWidthString = str.rep("z", "ｚ")
    return doubleWidthString
end
function replaceStringOfRomajiWithDoubleWidthCHaracters2(str)
    -- Define a mapping of single-width to double-width characters
    local mapping = {
        ["!"] = "！", ["\""] = "＂", ["#"] = "＃", ["$"] = "＄", ["%"] = "％",
        ["&"] = "＆", ["'"] = "＇", ["("] = "（", [")"] = "）", ["*"] = "＊",
        ["+"] = "＋", [","] = "，", ["-"] = "－", ["."] = "．", ["/"] = "／",
        ["0"] = "０", ["1"] = "１", ["2"] = "２", ["3"] = "３", ["4"] = "４",
        ["5"] = "５", ["6"] = "６", ["7"] = "７", ["8"] = "８", ["9"] = "９",
        [":"] = "：", [";"] = "；", ["<"] = "＜", ["="] = "＝", [">"] = "＞",
        ["?"] = "？", ["@"] = "＠", ["["] = "［", ["\\"] = "＼", ["]"] = "］",
        ["_"] = "＿", ["`"] = "｀", ["{"] = "｛", ["|"] = "｜", ["}"] = "｝",
        ["~"] = "～", ["¥"] = "￥",
        ["A"] = "Ａ", ["B"] = "Ｂ", ["C"] = "Ｃ", ["D"] = "Ｄ", ["E"] = "Ｅ",
        ["F"] = "Ｆ", ["G"] = "Ｇ", ["H"] = "Ｈ", ["I"] = "Ｉ", ["J"] = "Ｊ",
        ["K"] = "Ｋ", ["L"] = "Ｌ", ["M"] = "Ｍ", ["N"] = "Ｎ", ["O"] = "Ｏ",
        ["P"] = "Ｐ", ["Q"] = "Ｑ", ["R"] = "Ｒ", ["S"] = "Ｓ", ["T"] = "Ｔ",
        ["U"] = "Ｕ", ["V"] = "Ｖ", ["W"] = "Ｗ", ["X"] = "Ｘ", ["Y"] = "Ｙ",
        ["Z"] = "Ｚ",
        ["a"] = "ａ", ["b"] = "ｂ", ["c"] = "ｃ", ["d"] = "ｄ", ["e"] = "ｅ",
        ["f"] = "ｆ", ["g"] = "ｇ", ["h"] = "ｈ", ["i"] = "ｉ", ["j"] = "ｊ",
        ["k"] = "ｋ", ["l"] = "ｌ", ["m"] = "ｍ", ["n"] = "ｎ", ["o"] = "ｏ",
        ["p"] = "ｐ", ["q"] = "ｑ", ["r"] = "ｒ", ["s"] = "ｓ", ["t"] = "ｔ",
        ["u"] = "ｕ", ["v"] = "ｖ", ["w"] = "ｗ", ["x"] = "ｘ", ["y"] = "ｙ",
        ["z"] = "ｚ",[" "] = "　"
    }
    --(Done)add doubel width space
    return (str:gsub(".", function(c) return mapping[c] or c end))
end

local continueDisabled=false
function continue()
    if continueDisabled then
        disableContinueButton()
        continueDisabled=false
        hideTextArea()
        setGamePausedState(false)
        return
    end
    if printing==false then
        timer.cancel(characterTimer)
        print(tostring(callbackFunction))
        callbackFunction()
        print("continue next")
        --disableContinueButton()
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
    print("language:"..language)
    local aspectRatio = nil
    local fontWH = nil
    local magicalNumber=nil
    if Lang=="JP" then
        aspectRatio = 8
        fontWH = 8 * aspectRatio
        columns = 21
        rows = 14
        magicalNumber=0
        localizedSpace="　"
    else
        aspectRatio = 4
        fontWH = 16 * aspectRatio
        columns = 40
        rows = 14
        magicalNumber=1200--dunno why but I need to substract this number to get the right size of the red rectangle(it seems the smaller the bigger the rectangle gets)
        localizedSpace=" "
    end
    if sceneGroup==nil then
        return
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
            lblLine = display.newText(sceneGroup, "一二三四五六七八九十一二三四五六七八九十一", display.contentCenterX, 100+(Line * fontWH), "fonts/ume-tgc5.ttf", fontWH)--100 is a hack to align the text and the window
        else
            lblLine = display.newText(sceneGroup, "1234567890123456789012345678901234567890", display.contentCenterX, 100+(Line * fontWH), "fonts/ume-tgc5.ttf", fontWH)--100 is a hack to align the text and the window
        end
        table.insert(tableLines, lblLine)
    end
    
    print("Lang:"..Lang)
    if Lang=="JP" then
        print("here4!!")
        composer.setVariable("lblContinue",display.newText(sceneGroup, "[>>]",(columns-12)*fontWH, 200 + ((rows-1.6) * fontWH), "fonts/ume-tgc5.ttf", fontWH))
        --lblContinue = display.newText(sceneGroup, "Continue...", 200, 200, "fonts/ume-tgc5.ttf", fontWH)
    else
        print("here5!!")
        composer.setVariable("lblContinue",display.newText(sceneGroup, "[Continue...]", 750, 996, "fonts/ume-tgc5.ttf", fontWH))
    end
    composer.getVariable("lblContinue"):addEventListener( "tap", continue )
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
    if textZoneRectangle then
        textZoneRectangle.isVisible=true
    end
    --lblContinue.isVisible=false
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
    --eliminate newlines
    STRING=STR:gsub("\n","^")
    printing=true
    STRING=STR:gsub("なし","")
    
    while #STRING > 0 do
        -- Calculate the remaining space on the current line
        local magicnum2=columns*3-- ah the magic number is about the newline at the end of the columns
        local remainingSpace
        if Lang=="JP" then
            --magicnum2=63-6--(63 is columns21*3)(6 is to give it some margin to avoid teh line wrapping up(which I don't want))
            remainingSpace = magicnum2 - cursor.Column + 1 -- (this would not be a problem ifn lua for solar2d supported utf8 characters)the number 118 was causing a problem, I chnaged it to 117 and it seems to work.hack, I dont know why but I replaced columns with the number 118 and seems to work for Japanese
        else
            remainingSpace = columns - cursor.Column + 1 -- (this would not be a problem ifn lua for solar2d supported utf8 characters)the number 118 was causing a problem, I chnaged it to 117 and it seems to work.hack, I dont know why but I replaced columns with the number 118 and seems to work for Japanese
        end
        local characterWasAscii
        local toPrint = STRING:sub(1, remainingSpace)

        local characterWasAscii
        if isAscii2(toPrint) then
            characterWasAscii=true
        else 
            characterWasAscii=false
        end
        -- Get the text currently on the line
        local currentLine = tableLines[cursor.Line].text
        --if characterWasAscii then
            --cursor.Column=cursor.Column-0.5
        --end
        -- Concatenate text correctly
        if currentLine==nil then
            return
        end
        local textbefore = currentLine:sub(1, cursor.Column - 1)
        local textafter
        if characterWasAscii then
            if Lang=="JP" then
                textafter = currentLine:sub((cursor.Column + #toPrint)+1)--I think this was the fix I was looking for, it is not perfect but seems to work well enough
            else
               textafter = currentLine:sub(cursor.Column + #toPrint)
            end    
        else
            if currentLine then
                textafter = currentLine:sub(cursor.Column + #toPrint)
            end
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



function PRINTFAST(STR)
    continueDisabled=true
    if Lang=="JP" then
        STR=replaceStringOfRomajiWithDoubleWidthCHaracters2(STR)
    end
    -- Eliminate newlines and prepare the string
    STRING = STR:gsub("\n", "^")
    printing = true
    STRING = STRING:gsub("なし", "")
    
    -- Define magicnum2 for Japanese language handling
    local magicnum2
    if Lang == "JP" then
        magicnum2 = columns * 3  -- Adjusts column width for Japanese characters
    end
    
    -- Split STRING by '^'
    local parts = {}
    local start = 1
    while true do
        local pos = STRING:find("%^", start)
        if pos then
            table.insert(parts, STRING:sub(start, pos - 1))
            start = pos + 1
        else
            table.insert(parts, STRING:sub(start))
            break
        end
    end
    
    -- Print each part
    for i, part in ipairs(parts) do
        -- Call NEWENDLINE() before printing all parts except the first
        if i > 1 then
            NEWENDLINE()
        end
        while #part > 0 do
            -- Calculate the remaining space on the current line
            local remainingSpace
            if Lang == "JP" then
                remainingSpace = magicnum2 - cursor.Column + 1
            else
                remainingSpace = columns - cursor.Column + 1
            end
            local toPrint = part:sub(1, remainingSpace)
            
            -- Determine if the text is ASCII for spacing adjustments
            local characterWasAscii = isAscii2(toPrint)
            
            -- Get the current line text
            local currentLine = tableLines[cursor.Line].text
            
            -- Concatenate text correctly
            local textbefore = currentLine:sub(1, cursor.Column - 1)
            local textafter
            if characterWasAscii and Lang == "JP" then
                textafter = currentLine:sub((cursor.Column + #toPrint) + 1)
            else
                textafter = currentLine:sub(cursor.Column + #toPrint)
            end
            local updatedLine = textbefore .. toPrint .. textafter
            
            -- Handle scrolling if at the second-to-last line
            if cursor.Line == rows - 1 then
                NEWENDLINE()
                LOCATE(cursor.Line - 1, 1)
            end
            tableLines[cursor.Line].text = updatedLine
            
            -- Remove the printed portion from the part
            part = part:sub(#toPrint + 1)
            
            -- Update cursor position
            if #part > 0 then
                cursor.Line = cursor.Line + 1
                if cursor.Line > rows then
                    NEWENDLINE()
                    cursor.Line = rows
                end
                cursor.Column = 1
            else
                cursor.Column = cursor.Column + #toPrint
            end
        end
    end
    printing=false
    enableContinueButton()
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
    if string.byte(ch) then
        if string.byte(ch)<148 then--148 seems like hte last valid ascii character to me
            return true
        else
            return false
        end
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
    timeInMilllisecods=timeInMilllisecods*composer.getVariable( "speed" )
    callbackFunction=callbackFunctionWhenFinished
    print("hereX")
    print(tostring(callbackFunction))
    if stringForSlowPrint==nil then
        stringForSlowPrint=""
    end
    stringForSlowPrint=stringForSlowPrint..string
    if Lang=="JP" then
        stringForSlowPrint=replaceStringOfRomajiWithDoubleWidthCHaracters2(stringForSlowPrint)
    end
    --log the story into a file
    --[[
    file = io.open("testRead.txt","a")
    local tmp=stringForSlowPrint:gsub("^","\n")
    local tmp=tmp:gsub("改","\n")
    file:write(tmp)
    file:close()
    ]]
    --hack to make the slowprint work, otherwise it is jittery
    --hack fix, it does nto want to work form columb 1
    --repeat
        --LOCATE(cursor.Line,2)
        if string.len(stringForSlowPrint)>columns then
            oneline = string.sub(stringForSlowPrint, 1, #stringForSlowPrint)--80 shoudl be two characters in utf8???
            stringForSlowPrint=string.sub(stringForSlowPrint, columns, #stringForSlowPrint)
            characterTimer=timer.performWithDelay( timeInMilllisecods, coPrintOneCharOfSlowPrint, 0, "charTimer" )
        else
            if character then
               print("here2 oneline:"..oneline)
            end
            oneline= stringForSlowPrint
            print("here7"..oneline)
            characterTimer=timer.performWithDelay( timeInMilllisecods, coPrintOneCharOfSlowPrint, 0, "charTimer" )
            --buggy, but will removing this affect something else? oneline=""
        end
        --coroutine.resume(coPrintOneCharOfSlowPrint)
    --until #oneline==0
        enableContinueButton()
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
function disableContinueButton()
    print("disableContinueButton() called")
    composer.getVariable("lblContinue").isVisible=false
        --lblContinue.isHitTestable=false
end
function enableContinueButton()
    --there is a bug in here, but it seems to not appear anymore so I commented this and the code at the end:if not Lang==nil then--quick and direty fix cause it seems something is calling this with null language
        print("enableContinueButton() called")
        composer.getVariable("lblContinue").isVisible=true
            --lblContinue.isHitTestable=true
end
