local pos = 18

local mon = peripheral.wrap("left")
mon.clear()
mon.setBackgroundColor(colors.lightBlue)
mon.setTextColor(colors.blue)
mon.setTextScale(5)

while true do
    if pos == -15 then
        pos = 18
    end

    mon.clear()
    mon.setCursorPos(pos,1)
    mon.write("Cold Corner")
    pos = pos-1

    os.sleep(0.15)
end