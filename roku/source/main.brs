' Primary entry point: launched when the screensaver activates
sub RunScreenSaver()
    screen = CreateObject("roSGScreen")
    port = CreateObject("roMessagePort")
    screen.setMessagePort(port)

    scene = screen.CreateScene("MainScene")
    screen.show()

    while true
        msg = wait(0, port)
        if type(msg) = "roSGScreenEvent"
            if msg.isScreenClosed()
                return
            end if
        end if
    end while
end sub

' Optional: allows the channel to also be launched from the Home Screen
sub RunUserInterface()
    RunScreenSaver()
end sub
