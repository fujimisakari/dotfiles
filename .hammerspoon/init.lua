-- フォーカス中のウィンドウを赤枠でハイライトする
-- 似た画面が並んでいても、今アクティブなウィンドウが一目で分かる

local border = nil

local function clearBorder()
  if border then
    border:delete()
    border = nil
  end
end

-- IME の変換候補やパネルなど「通常でないウィンドウ」を除外する
local function isRealWindow(win)
  if not win then return false end
  if not win:isStandard() then return false end          -- 標準ウィンドウのみ
  if win:subrole() ~= "AXStandardWindow" then return false end
  local f = win:frame()
  if f.w < 50 or f.h < 50 then return false end           -- 極端に小さい窓は除外
  return true
end

local function drawBorder(win)
  if not isRealWindow(win) then return end                -- 対象外なら枠は今のまま維持
  clearBorder()
  local f = win:frame()
  local w = 2                                             -- 枠の太さ
  local pad = w                                           -- 枠が切れないようキャンバスを外側に広げる
  border = hs.canvas.new({ x = f.x - pad, y = f.y - pad, w = f.w + pad * 2, h = f.h + pad * 2 })
  border:appendElements({
    type = "rectangle",
    action = "stroke",
    frame = { x = pad, y = pad, w = f.w, h = f.h },
    strokeColor = { red = 0.75, green = 0.55, blue = 0.95, alpha = 1 }, -- 薄めの紫の枠
    strokeWidth = w,
    roundedRectRadii = { xRadius = 8, yRadius = 8 },
  })
  border:level(hs.canvas.windowLevels.overlay) -- 常に前面
  border:show()
end

--------------------------------------------------------------------------------
-- フォーカスが移った瞬間、そのウィンドウの左上に一瞬だけバッジを出す
-- 「このウィンドウにフォーカスが当たった」ことを 1 秒ほど視覚的に知らせる
--------------------------------------------------------------------------------
local flash = nil
local flashTimer = nil

local function clearFlash()
  if flashTimer then flashTimer:stop(); flashTimer = nil end
  if flash then flash:delete(); flash = nil end
end

local function flashFocusBadge(win)
  if not isRealWindow(win) then return end
  clearFlash()

  local label = win:application():name() or "focused"
  local f = win:frame()

  local w, h = 220, 34
  local margin = 12
  flash = hs.canvas.new({ x = f.x + margin, y = f.y + margin, w = w, h = h })
  flash:appendElements({
    type = "rectangle",
    action = "fill",
    fillColor = { red = 0.56, green = 0.41, blue = 0.72, alpha = 0.95 }, -- 中間よりやや明るめの紫
    roundedRectRadii = { xRadius = 8, yRadius = 8 },
  }, {
    type = "text",
    text = "◉ " .. label,
    textColor = { white = 1, alpha = 1 },
    textSize = 15,
    textAlignment = "left",
    frame = { x = 12, y = 7, w = w - 20, h = h - 10 },
  })
  flash:level(hs.canvas.windowLevels.overlay)
  flash:show()

  -- 1 秒後に消す
  flashTimer = hs.timer.doAfter(1.0, clearFlash)
end

local wf = hs.window.filter.new()
wf:subscribe(hs.window.filter.windowFocused,   function(win) drawBorder(win); flashFocusBadge(win) end)
wf:subscribe(hs.window.filter.windowMoved,     function(win) drawBorder(win) end)
wf:subscribe(hs.window.filter.windowUnfocused, function(win)
  -- 通常ウィンドウが外れたときだけ枠を消す（IME候補が閉じても維持）
  if isRealWindow(win) then clearBorder() end
end)

-- 起動時に現在フォーカス中のウィンドウにも枠を出す
drawBorder(hs.window.focusedWindow())

hs.alert.show("Hammerspoon: フォーカス枠ハイライト 有効")

--------------------------------------------------------------------------------
-- 現在のワークスペース(Space)内だけでウィンドウを切り替える
-- macOS 標準の ⌘` は別 Space のウィンドウに移ると Space ごと切り替わるが、
-- setCurrentSpace(true) で候補を現在の Space に限定するため Space 切替が起きない
--------------------------------------------------------------------------------
local function cycleWindowsInSpace(sameAppOnly)
  local focused = hs.window.focusedWindow()
  if not focused then return end

  local appName = sameAppOnly and focused:application():name() or nil
  local wf = hs.window.filter.new(appName):setCurrentSpace(true)
  local wins = wf:getWindows(hs.window.filter.sortByCreated) -- 安定した順序

  if #wins < 2 then return end

  -- 現在のウィンドウを探して「次」へフォーカス（末尾なら先頭に戻る）
  local idx = 1
  for i, w in ipairs(wins) do
    if w:id() == focused:id() then idx = i; break end
  end
  local target = wins[(idx % #wins) + 1]

  -- Emacs はウィンドウの role を AXTextField として報告するため win:focus() だけでは
  -- 前面化できないことがある。アプリの activate() を併用して確実に前面へ持ってくる。
  target:application():activate()
  target:focus()
end

-- 全アプリのウィンドウを Space 内で順送り（Ghostty / Emacs / Settings をまたいで移動）
hs.hotkey.bind({ "alt" }, "tab", function() cycleWindowsInSpace(false) end)

-- 同一アプリのウィンドウだけを順送りしたい場合はこちらを有効化
-- hs.hotkey.bind({ "alt", "shift" }, "tab", function() cycleWindowsInSpace(true) end)
