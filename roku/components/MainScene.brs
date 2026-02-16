sub init()
    m.cardLayout = m.top.findNode("cardLayout")
    m.clockTimer = m.top.findNode("clockTimer")

    m.clocks = []
    m.prevH = -1
    m.prevM = -1

    ' Clock configurations: base, name, accent color, font size
    configs = []

    c = {}
    c.base = 2
    c.name = "Binary"
    c.accent = "0x00E5FFFF"
    c.fontSize = 30
    c.dotSize = 4
    c.dotGap = 2
    configs.push(c)

    c = {}
    c.base = 5
    c.name = "Quinary"
    c.accent = "0x69F0AEFF"
    c.fontSize = 36
    c.dotSize = 5
    c.dotGap = 2
    configs.push(c)

    c = {}
    c.base = 6
    c.name = "Senary"
    c.accent = "0xE040FBFF"
    c.fontSize = 36
    c.dotSize = 5
    c.dotGap = 2
    configs.push(c)

    c = {}
    c.base = 10
    c.name = "Decimal"
    c.accent = "0xFFD740FF"
    c.fontSize = 42
    c.dotSize = 6
    c.dotGap = 2
    configs.push(c)

    c = {}
    c.base = 12
    c.name = "Dozenal"
    c.accent = "0xFF5252FF"
    c.fontSize = 44
    c.dotSize = 6
    c.dotGap = 2
    configs.push(c)

    for i = 0 to configs.count() - 1
        card = CreateObject("roSGNode", "ClockCard")
        m.cardLayout.appendChild(card)
        card.cardConfig = configs[i]
        m.clocks.push(card)
    end for

    ' Immediately show the correct time
    onTick()

    ' Start the 1-second update timer
    m.clockTimer.observeField("fire", "onTick")
    m.clockTimer.control = "start"
end sub

sub onTick()
    dt = CreateObject("roDateTime")
    dt.toLocalTime()
    h24 = dt.getHours()
    h = ((h24 + 11) mod 12) + 1
    min = dt.getMinutes()

    ' Only push updates when the time actually changes
    if h = m.prevH and min = m.prevM then return

    for each card in m.clocks
        card.currentHour = h
        card.currentMinute = min
    end for

    m.prevH = h
    m.prevM = min
end sub
