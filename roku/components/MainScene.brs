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
    c.accentDim = "0x00E5FF26"
    c.fontSize = 30
    configs.push(c)

    c = {}
    c.base = 5
    c.name = "Quinary"
    c.accent = "0x69F0AEFF"
    c.accentDim = "0x69F0AE26"
    c.fontSize = 36
    configs.push(c)

    c = {}
    c.base = 6
    c.name = "Senary"
    c.accent = "0xE040FBFF"
    c.accentDim = "0xE040FB26"
    c.fontSize = 36
    configs.push(c)

    c = {}
    c.base = 10
    c.name = "Decimal"
    c.accent = "0xFFD740FF"
    c.accentDim = "0xFFD74026"
    c.fontSize = 42
    configs.push(c)

    c = {}
    c.base = 12
    c.name = "Dozenal"
    c.accent = "0xFF5252FF"
    c.accentDim = "0xFF525226"
    c.fontSize = 44
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
    h = dt.getHours() mod 12
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
