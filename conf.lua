function love.conf(t)
    t.identity = "lovefunk"
    t.console = true

    t.window.title = "LOVEFUNK"
    t.window.icon = "assets/icon.png"
    t.window.width = 1280
    t.window.height = 720
    t.window.resizable = true

    t.modules.physics = false
    t.modules.touch = false
    t.modules.video = false
end
