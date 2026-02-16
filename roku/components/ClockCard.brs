sub init()
    m.cardBg = m.top.findNode("cardBg")
    m.accentLine = m.top.findNode("accentLine")
    m.nameLabel = m.top.findNode("nameLabel")
    m.baseLabel = m.top.findNode("baseLabel")
    m.timeLabel = m.top.findNode("timeLabel")
    m.hourGrid = m.top.findNode("hourGrid")
    m.minGrid = m.top.findNode("minGrid")

    m.base = 10
    m.hourDigits = 2
    m.minDigits = 2

    m.top.observeField("cardConfig", "onConfigChanged")
    m.top.observeField("currentHour", "onTimeChanged")
    m.top.observeField("currentMinute", "onTimeChanged")
    m.top.observeField("focused", "onFocusChanged")
end sub

sub onConfigChanged()
    cfg = m.top.cardConfig
    if cfg = invalid then return

    m.base = cfg.base

    alpha = "0123456789AB"
    maxDigit = alpha.mid(cfg.base - 1, 1)
    m.nameLabel.text = UCase(cfg.name) + " (0-" + maxDigit + ")"
    m.nameLabel.color = cfg.accent

    m.baseLabel.text = "BASE " + Str(cfg.base).trim()

    m.accentLine.color = cfg.accent
    m.accentLine.opacity = 0.2

    m.timeLabel.color = cfg.accent

    ' Set the time font size from config
    timeFont = CreateObject("roSGNode", "Font")
    timeFont.uri = "font:SystemFontFile"
    timeFont.size = cfg.fontSize
    m.timeLabel.font = timeFont

    ' Pre-calculate the digit counts for zero-padding
    m.hourDigits = digitsNeeded(11, cfg.base)
    m.minDigits = digitsNeeded(59, cfg.base)

    ' Configure the hour dot grid (12 dots, base columns)
    dotSize = cfg.dotSize
    dotGap = cfg.dotGap
    dimColor = "0xFFFFFF26"

    hCfg = {}
    hCfg.totalDots = 12
    hCfg.cols = cfg.base
    hCfg.dotSize = dotSize
    hCfg.dotGap = dotGap
    hCfg.accentColor = cfg.accent
    hCfg.dimColor = dimColor
    m.hourGrid.gridConfig = hCfg

    ' Configure the minute dot grid (60 dots, base columns)
    mCfg = {}
    mCfg.totalDots = 60
    mCfg.cols = cfg.base
    mCfg.dotSize = dotSize
    mCfg.dotGap = dotGap
    mCfg.accentColor = cfg.accent
    mCfg.dimColor = dimColor
    m.minGrid.gridConfig = mCfg

    ' Calculate grid pixel dimensions for layout
    hourRows = Int((12 + cfg.base - 1) / cfg.base)
    hourGridH = hourRows * dotSize + (hourRows - 1) * dotGap
    hourGridW = cfg.base * dotSize + (cfg.base - 1) * dotGap

    minRows = Int((60 + cfg.base - 1) / cfg.base)
    minGridH = minRows * dotSize + (minRows - 1) * dotGap
    minGridW = cfg.base * dotSize + (cfg.base - 1) * dotGap

    ' Body height = tallest of hour grid, minute grid, or font
    bodyH = cfg.fontSize
    if hourGridH > bodyH then bodyH = hourGridH
    if minGridH > bodyH then bodyH = minGridH

    ' Resize card background to fit content
    headerH = 28
    bottomPad = 10
    cardH = headerH + bodyH + bottomPad
    m.cardBg.height = cardH

    ' Position dot grids vertically centered in body area
    hourY = headerH + Int((bodyH - hourGridH) / 2)
    minY = headerH + Int((bodyH - minGridH) / 2)
    m.hourGrid.translation = [24, hourY]
    m.minGrid.translation = [960 - 24 - minGridW, minY]

    ' Position time label to fill body area for vertical centering
    m.timeLabel.translation = [0, headerH]
    m.timeLabel.height = bodyH

    onTimeChanged()
end sub

sub onTimeChanged()
    if m.base = invalid then return

    h = m.top.currentHour
    min = m.top.currentMinute

    hStr = toBase(h, m.base)
    mStr = padLeft(toBase(min, m.base), m.minDigits)

    m.timeLabel.text = hStr + "  :  " + mStr

    ' Update dot grids
    m.hourGrid.currentValue = h
    m.minGrid.currentValue = min
end sub

sub onFocusChanged()
end sub

' Convert an integer to a string in the given base (supports up to base 12)
function toBase(n as Integer, base as Integer) as String
    alpha = "0123456789AB"
    if n = 0 then return "0"
    s = ""
    v = n
    while v > 0
        r = v mod base
        s = alpha.mid(r, 1) + s
        v = Int(v / base)
    end while
    return s
end function

' Calculate how many digits are needed to represent maxVal in the given base
function digitsNeeded(maxVal as Integer, base as Integer) as Integer
    if maxVal = 0 then return 1
    d = 0
    v = maxVal
    while v > 0
        d = d + 1
        v = Int(v / base)
    end while
    return d
end function

' Left-pad a string with zeros to reach the target length
function padLeft(s as String, length as Integer) as String
    result = s
    while result.len() < length
        result = "0" + result
    end while
    return result
end function
