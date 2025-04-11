local spaces = require("hs.spaces")

-- Function to run applescripts
local function runAppleScript(script)
    hs.osascript.applescript(script)
end

-- Sleep function
function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

-- Function to get current workspace
local function getCurrentSpace()
    local spaceID = spaces.focusedSpace()
    return spaceID
end

-- Convert Table object to string
local function TableToString(Table)
    local String_Splitted = ""
    for i = 1, #Table do
        String_Splitted = String_Splitted .. Table[i]
    end
    return String_Splitted
end

-- Split function
local function Split(inputstr, sep)
    if sep == nil then
      sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
    if t == nil then
        return t
    end
    return TableToString(t)
end

-- reutrns table with all available workspaces(1st index used to get lenght of the returned table)
local function GetWindowNumbers()
    local currentSpace = getCurrentSpace()
    local AllCurrentSpaces = tostring(hs.spaces.allSpaces())
    local StringAllCurrentSpaces = Split(AllCurrentSpaces, "%s")
    local numbers_part = StringAllCurrentSpaces:match("=%{(.+)%}")
    local numbers = {}
    local ArrayNumbers = {}
    for num in numbers_part:gmatch("%d+") do
        table.insert(numbers, tonumber(num))
    end
    local LenghtNumbers = #numbers
    ArrayNumbers[1] = LenghtNumbers + 1
    local indx = 2
    for i, v in ipairs(numbers) do
        ArrayNumbers[indx] = v
        indx = indx + 1
    end
    return ArrayNumbers
end


-- Function to move left
local function moveLeft()
    -- print("[+] Toggling to left [+]")
    runAppleScript([[
        tell application "System Events"
	    key down control
	    keystroke (key code 123) -- Код клавиши "стрелка вправо"
	    -- Код для левой 123
	    key up control
        end tell
    ]])
end

-- Function to move right
local function moveRight()
    -- print("[+] Toggling to right [+]")
    runAppleScript([[
        tell application "System Events"
	    key down control
	    keystroke (key code 124) -- Код клавиши "стрелка вправо"
	    -- Код для левой 123
	    key up control
        end tell
    ]])
end

local CurPointer = 2  -- to keep track of current wokspace

-- some sort of main function, here we getting available spaces and switching between them
local function switchToSpace(target)
    os.execute("clear")
    local TargetSpace = target + 1
    local ArraySpaces = GetWindowNumbers()
    local lenght = ArraySpaces[1]
    if TargetSpace > lenght then
        print("[-] Error, no such workspace found! [-]")
        return
    end
    -- !! index starts form 2 !!
    local difference = TargetSpace - CurPointer

    if difference > 0 then
        for _ = 1, difference do
            sleep(0.1)
            moveRight()
        end
    elseif difference < 0 then
        for _ = 1, math.abs(difference) do
            sleep(0.1)
            moveLeft()
        end
   else
        return
    end
    CurPointer = TargetSpace
end

-- Binding to Command + num(1-9)
for i = 1, 9 do
    hs.hotkey.bind({"cmd"}, tostring(i), function()
        switchToSpace(i)
    end)
end
