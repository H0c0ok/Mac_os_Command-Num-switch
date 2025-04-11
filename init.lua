local spaces = require("hs.spaces")

-- Функция для выполнения AppleScript
local function runAppleScript(script)
    hs.osascript.applescript(script)
end

-- Sleep function
function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

-- Функция для получения текущего рабочего стола
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
    --print("--------------------------------------------------")
    for i, v in ipairs(numbers) do
        -- print("[?] Index: " .. tostring(i + 1) .. ", Value: " .. tostring(v) .. " [?]")
        ArrayNumbers[indx] = v
        indx = indx + 1
    end
    return ArrayNumbers
end


-- Функция для перемещения влево
local function moveLeft()
    print("[+] Toggling to left [+]")
    runAppleScript([[
        tell application "System Events"
	    key down control
	    keystroke (key code 123) -- Код клавиши "стрелка вправо"
	    -- Код для левой 123
	    key up control
        end tell
    ]])
end

-- Функция для перемещения вправо
local function moveRight()
    print("[+] Toggling to right [+]")
    runAppleScript([[
        tell application "System Events"
	    key down control
	    keystroke (key code 124) -- Код клавиши "стрелка вправо"
	    -- Код для левой 123
	    key up control
        end tell
    ]])
end

local CurPointer = 2
-- Функция для переключения на указанный рабочий стол
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
        -- Если целевой рабочий стол правее, двигаемся вправо
        for _ = 1, difference do
            sleep(0.1)
            moveRight()
        end
    elseif difference < 0 then
        -- Если целевой рабочий стол левее, двигаемся влево
        for _ = 1, math.abs(difference) do
            sleep(0.1)
            moveLeft()
        end
   else
        return
    end
    CurPointer = TargetSpace
end

-- Привязка горячих клавиш Command+цифра
for i = 1, 9 do
    hs.hotkey.bind({"cmd"}, tostring(i), function()
        switchToSpace(i)
    end)
end