sub init()
    m.cardBg = m.top.findNode("cardBg")
    m.accentLine = m.top.findNode("accentLine")
    m.nameLabel = m.top.findNode("nameLabel")
    m.baseLabel = m.top.findNode("baseLabel")
    m.timeLabel = m.top.findNode("timeLabel")
    m.hourBarFg = m.top.findNode("hourBarFg")
    m.minBarFg = m.top.findNode("minBarFg")

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

    m.nameLabel.text = UCase(cfg.name)
    m.nameLabel.color = cfg.accent

    m.baseLabel.text = "BASE " + Str(cfg.base).trim()

    m.accentLine.color = cfg.accent
    m.accentLine.opacity = 0.2

    m.hourBarFg.color = cfg.accent
    m.minBarFg.color = cfg.accent

    m.timeLabel.color = cfg.accent

    ' Set the time font size from config
    timeFont = CreateObject("roSGNode", "Font")
    timeFont.uri = "font:SystemFontFile"
    timeFont.size = cfg.fontSize
    m.timeLabel.font = timeFont

    ' Pre-calculate the digit counts for zero-padding
    m.hourDigits = digitsNeeded(11, cfg.base)
    m.minDigits = digitsNeeded(59, cfg.base)

    onTimeChanged()
end sub

sub onTimeChanged()
    if m.base = invalid then return

    h = m.top.currentHour
    min = m.top.currentMinute

    hStr = padLeft(toBase(h, m.base), m.hourDigits)
    mStr = padLeft(toBase(min, m.base), m.minDigits)

    m.timeLabel.text = hStr + "  :  " + mStr

    ' Update hour progress bar (0-11 mapped to 0-200px)
    if h > 0
        m.hourBarFg.width = Int(200 * h / 11)
    else
        m.hourBarFg.width = 0
    end if

    ' Update minute progress bar (0-59 mapped to 0-200px)
    if min > 0
        m.minBarFg.width = Int(200 * min / 59)
    else
        m.minBarFg.width = 0
    end if
end sub

sub onFocusChanged()
    if m.top.focused
        m.cardBg.color = "0x14142AFF"
    else
        m.cardBg.color = "0x0D0D18FF"
    end if
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
