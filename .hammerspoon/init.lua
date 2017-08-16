--
-- Emacs Keybind
-- 

local function keyCode(key, modifiers)
   modifiers = modifiers or {}
   return function()
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
      hs.timer.usleep(1000)
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
   end
end

local function remapKey(modifiers, key, keyCode)
   hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

local function disableAllHotkeys()
   for k, v in pairs(hs.hotkey.getHotkeys()) do
      v['_hk']:disable()
   end
end

local function enableAllHotkeys()
   for k, v in pairs(hs.hotkey.getHotkeys()) do
      v['_hk']:enable()
   end
end

local function handleGlobalAppEvent(name, event, app)
   if event == hs.application.watcher.activated then
       -- hs.alert.show(name)
       if name == "VirtualBox VM" then
           disableAllHotkeys()
       -- elseif name == "Firefox" then
       --     enableAllHotkeys()
       else
           if name == "Emacs" or name == "iTerm" then
               disableAllHotkeys()
           else
               enableAllHotkeys()
           end
           remapKey({'ctrl'}, 'y', keyCode('v', {'cmd'}))
           remapKey({'ctrl'}, 'm', keyCode('return'))
       end
   end
end

appsWatcher = hs.application.watcher.new(handleGlobalAppEvent)
appsWatcher:start()

remapKey({'ctrl'}, 'f', keyCode('right'))
remapKey({'ctrl'}, 'b', keyCode('left'))
remapKey({'ctrl'}, 'n', keyCode('down'))
remapKey({'ctrl'}, 'p', keyCode('up'))

remapKey({'ctrl'}, 'w', keyCode('x', {'cmd'}))

remapKey({'alt'},  'w', keyCode('c', {'cmd'}))

remapKey({'ctrl'}, 'd', keyCode('forwarddelete'))
remapKey({'ctrl'}, 'h', keyCode('delete'))

remapKey({'ctrl'}, '/', keyCode('z', {'cmd'}))
remapKey({'ctrl'}, 'g', keyCode('escape'))

remapKey({'ctrl'}, 'v', keyCode('pagedown'))
remapKey({'alt'},  'v', keyCode('pageup'))

--
-- Mouse Keyboard Setting
--
local lowSpeed = 7
local hiSpeed = 15

local function mouseMoveToUp(isSpeedup)
   mvOffset = isSpeedup and hiSpeed or lowSpeed
   absPos = hs.mouse.getAbsolutePosition()
   mvPos = {['x']=absPos['x'], ['y']=absPos['y'] - mvOffset}
   hs.mouse.setRelativePosition(mvPos)
end

local function mouseMoveToDown(isSpeedup)
   mvOffset = isSpeedup and hiSpeed or lowSpeed
   absPos = hs.mouse.getAbsolutePosition()
   mvPos = {['x']=absPos['x'], ['y']=absPos['y'] + mvOffset}
   hs.mouse.setRelativePosition(mvPos)
end

local function mouseMoveToLeft(isSpeedup)
   mvOffset = isSpeedup and hiSpeed or lowSpeed
   absPos = hs.mouse.getAbsolutePosition()
   mvPos = {['x']=absPos['x'] - mvOffset, ['y']=absPos['y']}
   hs.mouse.setRelativePosition(mvPos)
end

local function mouseMoveToRight(isSpeedup)
   mvOffset = isSpeedup and hiSpeed or lowSpeed
   absPos = hs.mouse.getAbsolutePosition()
   mvPos = {['x']=absPos['x'] + mvOffset, ['y']=absPos['y']}
   hs.mouse.setRelativePosition(mvPos)
end

local function mouseHiSpeedMoveToUp(isSpeedup)
   mvOffset = hiSpeed
   absPos = hs.mouse.getAbsolutePosition()
   mvPos = {['x']=absPos['x'], ['y']=absPos['y'] - mvOffset}
   hs.mouse.setRelativePosition(mvPos)
end

local function mouseHiSpeedMoveToDown(isSpeedup)
   mvOffset = hiSpeed
   absPos = hs.mouse.getAbsolutePosition()
   mvPos = {['x']=absPos['x'], ['y']=absPos['y'] + mvOffset}
   hs.mouse.setRelativePosition(mvPos)
end

local function mouseHiSpeedMoveToLeft(isSpeedup)
   mvOffset = hiSpeed
   absPos = hs.mouse.getAbsolutePosition()
   mvPos = {['x']=absPos['x'] - mvOffset, ['y']=absPos['y']}
   hs.mouse.setRelativePosition(mvPos)
end

local function mouseHiSpeedMoveToRight(isSpeedup)
   mvOffset = hiSpeed
   absPos = hs.mouse.getAbsolutePosition()
   mvPos = {['x']=absPos['x'] + mvOffset, ['y']=absPos['y']}
   hs.mouse.setRelativePosition(mvPos)
end

-- remapKey({'cmd', 'alt'}, 'h', mouseMoveToLeft)
-- remapKey({'cmd', 'alt'}, 'j', mouseMoveToDown)
-- remapKey({'cmd', 'alt'}, 'k', mouseMoveToUp)
-- remapKey({'cmd', 'alt'}, 'l', mouseMoveToRight)
-- remapKey({'cmd', 'shift', 'alt'}, 'h', mouseHiSpeedMoveToLeft)
-- remapKey({'cmd', 'shift', 'alt'}, 'j', mouseHiSpeedMoveToDown)
-- remapKey({'cmd', 'shift', 'alt'}, 'k', mouseHiSpeedMoveToUp)
-- remapKey({'cmd', 'shift', 'alt'}, 'l', mouseHiSpeedMoveToRight)

local function leftClick()
   absPos = hs.mouse.getAbsolutePosition()
   hs.eventtap.leftClick(absPos)
end

local function rightClick()
   absPos = hs.mouse.getAbsolutePosition()
   hs.eventtap.rightClick(absPos)
end

-- remapKey({'cmd', 'alt'}, 'm', leftClick)
-- remapKey({'cmd', 'alt'}, '.', rightClick)


-- local codeMap = {['a']=0, ['s']=1, ['d']=2, ['f']=3, ['k']=40, ['j']=38, ['h']=4, ['l']=37}
-- local eventMap = {['keydown']=10, ['keyup']=11}
-- local pressedKeyTable = {}
-- local deleteFlag = false

-- eventtap = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, function(event)
--       local kCode = event:getKeyCode()
--       local eType = event:getType()

--       if eType == eventMap['keydown']
--       and (kCode == codeMap['a'] or kCode == codeMap['d'] or kCode == codeMap['f']) then
--          pressedKeyTable[kCode] = true
--       end

--       if eType == eventMap['keyup']
--       and (kCode == codeMap['a'] or kCode == codeMap['d'] or kCode == codeMap['f']) then
--          pressedKeyTable[kCode] = false
--       end

--       if pressedKeyTable[codeMap['d']] and pressedKeyTable[codeMap['f']] then
--          deleteFlag = true

--          if kCode == codeMap['k'] then
--             mouseMoveToUp(pressedKeyTable[codeMap['a']])
--          elseif kCode == codeMap['j'] then
--             mouseMoveToDown(pressedKeyTable[codeMap['a']])
--          elseif kCode == codeMap['h'] then
--             mouseMoveToLeft(pressedKeyTable[codeMap['a']])
--          elseif kCode == codeMap['l'] then
--             mouseMoveToRight(pressedKeyTable[codeMap['a']])
--          end

--          return true
--       end

--       if deleteFlag then
--          hs.eventtap.event.newKeyEvent({}, 'delete', true):post()
--          hs.timer.usleep(1000)
--          hs.eventtap.event.newKeyEvent({}, 'delete', false):post()
--          deleteFlag = false
--       end
-- end)
-- eventtap:start()
