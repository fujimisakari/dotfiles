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
  border = hs.canvas.new(f)
  border:appendElements({
    type = "rectangle",
    action = "stroke",
    strokeColor = { red = 0.75, green = 0.55, blue = 0.95, alpha = 1 }, -- 薄めの紫の枠
    strokeWidth = 1.5,
    roundedRectRadii = { xRadius = 8, yRadius = 8 },
  })
  border:level(hs.canvas.windowLevels.overlay) -- 常に前面
  border:show()
end

local wf = hs.window.filter.new()
wf:subscribe(hs.window.filter.windowFocused,   function(win) drawBorder(win) end)
wf:subscribe(hs.window.filter.windowMoved,     function(win) drawBorder(win) end)
wf:subscribe(hs.window.filter.windowUnfocused, function(win)
  -- 通常ウィンドウが外れたときだけ枠を消す（IME候補が閉じても維持）
  if isRealWindow(win) then clearBorder() end
end)

-- 起動時に現在フォーカス中のウィンドウにも枠を出す
drawBorder(hs.window.focusedWindow())

hs.alert.show("Hammerspoon: フォーカス枠ハイライト 有効")
