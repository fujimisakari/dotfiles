-- `hs` CLI から設定を問い合わせ/操作できるようにする (デバッグ用)
require("hs.ipc")

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
-- ウィンドウフィルタは AX オブザーバを張る重いオブジェクトなので、押下ごとに作らず
-- 一度だけ作って使い回す。毎回 new() するとオブザーバの張り直しが積み上がり、
-- コールバック内でエラー (hs.logger の stack overflow) になって「その押下だけ何も
-- 起きない」という間欠的な取りこぼしが発生する。
local spaceFilters = setmetatable({}, { __mode = "v" })
local function spaceFilter(appName)
  local key = appName or "*"
  if not spaceFilters[key] then
    spaceFilters[key] = hs.window.filter.new(appName):setCurrentSpace(true)
  end
  return spaceFilters[key]
end

local function cycleWindowsInSpace(sameAppOnly)
  local focused = hs.window.focusedWindow()
  if not focused then return end

  local appName = sameAppOnly and focused:application():name() or nil
  local wf = spaceFilter(appName)

  -- ivy-posframe などの Emacs 子フレームは AX 上 subrole=AXDialog の別ウィンドウとして
  -- 現れる。これが候補に混ざると「Emacs の次」がその不可視ウィンドウになり、focus() でも
  -- 何も起きないため alt+tab が空振りする。枠表示と同じ isRealWindow の基準で
  -- 通常ウィンドウだけに絞る。
  local wins = {}
  for _, w in ipairs(wf:getWindows()) do
    if isRealWindow(w) then table.insert(wins, w) end
  end

  -- 巡回順は画面上の位置で決める。sortByCreated だとウィンドウを起動した順が
  -- そのまま並びになるため、同じ配置でも起動の仕方で巡回方向が変わってしまう。
  -- 列優先 (左の列から右へ、各列は上から下へ) にすると配置だけで順序が決まり、
  -- 起動順に依存しない。同座標のときは id で並べて順序を安定させる。
  table.sort(wins, function(a, b)
    local fa, fb = a:frame(), b:frame()
    if fa.x ~= fb.x then return fa.x < fb.x end
    if fa.y ~= fb.y then return fa.y < fb.y end
    return (a:id() or 0) < (b:id() or 0)
  end)

  if #wins < 2 then return end

  -- 現在のウィンドウを探して「次」へフォーカス（末尾なら先頭に戻る）
  local idx = 1
  for i, w in ipairs(wins) do
    if w:id() == focused:id() then idx = i; break end
  end
  local target = wins[(idx % #wins) + 1]

  -- win:focus() だけでは前面化しきれないことがあるため、アプリの activate() も併用する。
  target:application():activate()
  target:focus()
end

--------------------------------------------------------------------------------
-- ⌥Tab の受け方
--   * hs.hotkey (Carbon の system hotkey) 単独では取りこぼす。実測で 9 回の押下に対し
--     発火 6 回で、落ちた 3 回はいずれも「直前の押下でアプリを切り替えた直後」だった。
--   * eventtap 単独では OS 側に無効化されたときに操作ごと死ぬ (Ghostty でも効かなくなる)。
--   そこで eventtap を主、hs.hotkey を保険として両方張る。eventtap が生きている間は
--   イベントを消費するので hs.hotkey は発火せず、二重遷移にはならない。万一両方来ても
--   下の debounce で弾く。
--------------------------------------------------------------------------------
local TAB_KEYCODE = hs.keycodes.map.tab
local lastCycleNs = 0

local function triggerCycle()
  -- eventtap と hs.hotkey の 2 つの経路があるため、近接した重複呼び出しを弾く
  local now = hs.timer.absoluteTime()
  if (now - lastCycleNs) < 150e6 then return end -- 150ms
  lastCycleNs = now
  cycleWindowsInSpace(false)
end

local altTabTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
  -- 全打鍵を通るので、tab 以外は最小コストで抜ける
  if e:getKeyCode() ~= TAB_KEYCODE then return false end
  local f = e:getFlags()
  if not f.alt or f.cmd or f.ctrl or f.shift then return false end
  -- キーリピートで届いた keyDown は無視する。hs.hotkey は押下とリピートを別扱いするが
  -- eventtap には両方そのまま来るため、押しっぱなしだと 33ms 間隔で連続遷移してしまう。
  if e:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat) ~= 0 then
    return true
  end
  -- AX 問い合わせをコールバック内で同期実行するとタップが OS に無効化されうるので、
  -- 消費だけ即座に返し、ウィンドウ切り替えは次のループに回す。
  hs.timer.doAfter(0, triggerCycle)
  return true -- 消費して Emacs の <M-tab> に渡さない
end)
altTabTap:start()

-- eventtap が無効化されても操作が死なないよう system hotkey も張っておく
hs.hotkey.bind({ "alt" }, "tab", triggerCycle)

-- 無効化されたタップを早めに復帰させる
hs.timer.doEvery(5, function()
  if not altTabTap:isEnabled() then altTabTap:start() end
end)

-- 状態を外から確認できるようにする (hs -c "return altTabStatus()")
_G.altTabStatus = function()
  return string.format("eventtap=%s / hotkey=%d件",
    tostring(altTabTap:isEnabled()), #hs.hotkey.getHotkeys())
end

-- 同一アプリのウィンドウだけを順送りしたい場合はこちらを有効化
-- hs.hotkey.bind({ "alt", "shift" }, "tab", function() cycleWindowsInSpace(true) end)
