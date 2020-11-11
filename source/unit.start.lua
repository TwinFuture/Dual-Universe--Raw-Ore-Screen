-- Hide programming board from UI
unit.hide()
-- Unload default Modules & Libraries from global.lua
function unrequire(m)
    package.loaded[m] = nil
    _G[m] = nil
end
unrequire'json'
unrequire'Navigator'
unrequire'Helpers'
unrequire'AxisCommand'
unrequire'database'
unrequire'cpml/sgui'
unrequire'pl/init'
-- Manually run the garbage collector 
collectgarbage('collect')
-- "setpause" controls how much memory has to be allocated before it starts a new cycle
-- Default is 200, meaning it will run everytime the memory is doubled,
-- 100 means it will run every allocation. we're gonna use 110
collectgarbage('setpause', 110)
-- You want this above to run on every pb, before any timers.
-- You can manually collect garbage withing your tick, bot not recommended, fix your code!

-- Here we are gonna detect what is in the default slots, databank/core/screen.
core, screen = {};
local slots = {slot1,slot2}

for i = 1, #slots do
    if slots[i].getElementClass() == 'CoreUnitStatic'
    or slots[i].getElementClass() == 'CoreUnitSpace'
    or slots[i].getElementClass() == 'CoreUnitDynamic' then
        core = slots[i]
    end
    if slots[i].getElementClass() == 'ScreenUnit' then
        screen = slots[i]
    end
end
local refresh = 10 --export
-- Set timer to update screen every refresh
unit.setTimer('blam', refresh)
