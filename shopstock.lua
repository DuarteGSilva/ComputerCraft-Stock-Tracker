-- Change the numbers/sides to the ones you got
d1 = peripheral.wrap("container_dropper_2")
d2 = peripheral.wrap("container_dropper_3")
mon = peripheral.wrap("top")
gl = peripheral.wrap("right")

-- Hexadecimal color code constants for glasses
GREEN = 0x00CC00
RED = 0xFF0000
CYAN = 0x006666
BLUE = 0x000099
ORANGE = 0xFF6600
YELLOW = 0xFF9900

function startswith(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function checkBoxes(dropper)
    local boxes = {
        sad = 0,
        epic = 0,
        jackpot = 0,
        normal = 0,
        total = 0
    }

    local items = dropper.getAllStacks()
    for slot, item in pairs(items) do
        local name = item.name
        if startswith(name, ":(") then
            boxes.sad = boxes.sad + 1
        elseif startswith(name, "Epic") then
            boxes.epic = boxes.epic + 1
        elseif startswith(name, "Jackpot") then
            boxes.jackpot = boxes.jackpot + 1
        else
            boxes.normal = boxes.normal + 1
        end
        boxes.total = boxes.total + 1
    end
    return boxes
end

function drawDropperBox(num_, boxes_, ycoord)
    gl.addBox(10, ycoord, 128, 84, CYAN, 0.5)
    gl.addText(14, ycoord+3, "Dropper"..num_.." :", BLUE)

    if (boxes_.normal == 6 and boxes_.jackpot == 1) or (boxes_.normal == 7 and boxes_.jackpot == 0) then
        gl.addText(14, ycoord+23, "Normal Boxes : "..boxes_.normal, GREEN)
    elseif boxes_.normal == 0 then
        gl.addText(14, ycoord+23, "Normal Boxes : "..boxes_.normal, ORANGE)
    else
        gl.addText(14, ycoord+23, "Normal Boxes : "..boxes_.normal, YELLOW)
    end

    if total_jackpots == 1 then
        gl.addText(14, ycoord+33, "Jackpot Boxes : "..boxes_.jackpot, GREEN)
    elseif total_jackpots == 0 then
        gl.addText(14, ycoord+33, "Jackpot Boxes : "..boxes_.jackpot, ORANGE)
    else
        gl.addText(14, ycoord+33, "Jackpot Boxes : "..boxes_.jackpot, RED)
    end

    if boxes_.epic == 1 then
        gl.addText(14, ycoord+43, "Epic Boxes : "..boxes_.epic, GREEN)
    elseif boxes_.epic == 0 then
        gl.addText(14, ycoord+43, "Epic Boxes : "..boxes_.epic, YELLOW)
    else
        gl.addText(14, ycoord+43, "Epic Boxes : "..boxes_.epic, RED)
    end

    if boxes_.sad == 1 then
        gl.addText(14, ycoord+53, ":( Boxes : "..boxes_.sad, GREEN)
    elseif boxes_.sad == 0 then
        gl.addText(14, ycoord+53, ":( Boxes : "..boxes_.sad, YELLOW)
    else
        gl.addText(14, ycoord+53, ":( Boxes : "..boxes_.sad, RED)
    end

    if boxes_.total == 9 then
        gl.addText(14, ycoord+73, "Total Boxes : "..boxes_.total, GREEN)
    elseif 4 <= boxes_.total and boxes_.total < 9 then
        gl.addText(14, ycoord+73, "Total Boxes : "..boxes_.total, YELLOW)
    elseif 0 < boxes_.total and boxes_.total < 4 then
        gl.addText(14, ycoord+73, "Total Boxes : "..boxes_.total, ORANGE)
    else
        gl.addText(14, ycoord+73, "Total Boxes : "..boxes_.total, RED)
    end
end

status = "Live"
status_color = GREEN

while true do
    boxes1 = checkBoxes(d1)
    boxes2 = checkBoxes(d2)

    total_jackpots = boxes1.jackpot + boxes2.jackpot
    total_boxes = boxes1.total + boxes2.total

    if boxes1.total == 0 or boxes2.total == 0 then
        status = "Down"
    else
        status = "Live"
    end

    mon.setBackgroundColor(512)
    mon.clear()

    mon.setCursorPos(1,1)
    if total_boxes == 0 then
        mon.setTextColor(16384)
    elseif total_boxes < 3 then
        mon.setTextColor(2)
    else
        mon.setTextColor(32)
    end
    if total_boxes < 10 then
        mon.write(total_boxes.." boxes")
    else
        mon.write(total_boxes.."boxes")
    end

    mon.setCursorPos(1,2)
    mon.write("stocked")

    mon.setCursorPos(1,3)
    mon.setTextColor(8)
    mon.write("Status:")

    mon.setCursorPos(1,4)
    if status == "Live" then
        mon.setTextColor(32)
        status_color = GREEN
    else
        mon.setTextColor(16384)
        status_color = RED
    end
    mon.write(status)

    gl.clear()
    gl.addBox(5,5,138,254,CYAN,0.4)
    gl.addBox(10,10,128,12,CYAN,0.5)
    gl.addText(14,13,"Status: "..status,status_color)

    drawDropperBox(1,boxes1,60)
    drawDropperBox(2,boxes2,170)

    sleep(1)
end
