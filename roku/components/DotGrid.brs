sub init()
    m.dots = []
    m.accentColor = "0xFFFFFFFF"
    m.dimColor = "0xFFFFFF26"

    m.top.observeField("gridConfig", "onConfigChanged")
    m.top.observeField("currentValue", "onValueChanged")
end sub

' Build the dot grid from config: totalDots, cols, dotSize, dotGap, accentColor, dimColor
sub onConfigChanged()
    cfg = m.top.gridConfig
    if cfg = invalid then return

    ' Clear any existing dots
    if m.top.getChildCount() > 0
        m.top.removeChildrenIndex(m.top.getChildCount(), 0)
    end if
    m.dots = []

    total = cfg.totalDots
    cols = cfg.cols
    dotSize = cfg.dotSize
    dotGap = cfg.dotGap
    m.accentColor = cfg.accentColor
    m.dimColor = cfg.dimColor

    if total = 0 or cols = 0 then return

    rows = Int((total + cols - 1) / cols)

    for r = 0 to rows - 1
        ' Last row may have fewer columns
        rowCols = cols
        remaining = total - r * cols
        if remaining < cols then rowCols = remaining

        for c = 0 to rowCols - 1
            dot = CreateObject("roSGNode", "Rectangle")
            dot.width = dotSize
            dot.height = dotSize
            dot.color = m.dimColor
            dot.translation = [c * (dotSize + dotGap), r * (dotSize + dotGap)]
            m.top.appendChild(dot)
            m.dots.push(dot)
        end for
    end for

    onValueChanged()
end sub

' Light up dots 0..value-1 in accent color, the rest dim
sub onValueChanged()
    if m.dots.count() = 0 then return

    val = m.top.currentValue

    for i = 0 to m.dots.count() - 1
        if i < val
            m.dots[i].color = m.accentColor
        else
            m.dots[i].color = m.dimColor
        end if
    end for
end sub
