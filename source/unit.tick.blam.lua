local ores, htmlHead, htmlFoot, htmlBody, eleIds, containers = {
    {
        {'Quartz',2.65,'rgba(0,255,255'},
        {'Bauxite',1.28095,'rgba(191,166,166'},
        {'Coal',1.346,'rgba(54,69,79'},
        {'Hematite',5.04,'rgba(255,255,0'}
    },
    {
        {'Malachite',4.0,'rgba(200,128,51'},
        {'Limestone',2.7108,'rgba(61,255,0'},
        {'Natron',1.55,'rgba(171,92,242'},
        {'Chromite',4.54,'rgba(138,153,199'}
    },
    {
        {'Acanthite',7.2,'rgba(192,192,192'},
        {'Garnierite',2.6,'rgba(80,208,80'},
        {'Pyrite',5.01,'rgba(255,255,48'},
        {'Petalite',2.41,'rgba(204,128,255'}
    },
    {
        {'Cobaltite',6.33,'rgba(240,144,160'},
        {'Cryolite',2.95,'rgba(144,224,80'},
        {'Kolbeckite',2.37,'rgba(230,230,230'},
        {'Gold Nuggets',19.3,'rgba(255,209,35'}
    },
    {
        {'Columbite',5.38,'rgba(155,194,201'},
        {'Illmenite',4.55,'rgba(191,194,199'},
        {'Vanadinite',6.95,'rgba(166,166,171'},
        {'Rhodonite',3.76,'rgba(156,122,199'},
        {'Thoramine',21.30,'rgba(255,0,0'}
    }
}, [[<html><head><style>
    .head {
        margin-top: -6px;
        font-size:50px;
        font-variant: small-caps;
        font-weight:bold
    }
    th, .head {
        background: -webkit-linear-gradient(white, #38495a);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        -webkit-text-stroke-width: 2px;
        -webkit-text-stroke-color: #fff
    }
    body {
        text-align:center
    }
    table {
        float:left;
        font-size:20px;
        width: calc(50% - 10px);
        margin:0 5px 10px 5px
    }
    th {
        font-size:28px
    }
    td, .bar {
        text-shadow: 1px 1px #000, 2px 2px #000;
        background-image: linear-gradient(to bottom, rgba(255, 255, 255, 0.3), rgba(255, 255, 255, 0.05));
        box-shadow: 0 0 1px 1px rgba(0, 0, 0, 0.25), inset 0 1px rgba(255, 255, 255, 0.1);
        color:#fff
    }
    .amount {
        width:20%
    }
    .name {
        width:36%
    }
    .percent {
        width:45%;
        font-family:bank;
        letter-spacing:-1px
    }
    .blank td {
        padding:2px
    }
</style></head><body>
	<div class="head">Raw Ores</div>]], '</body></html>', '', core.getElementIdList(), {}
-- Simple rounding function needed later.
function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end
-- Grab and store all the containers into a table.
for i = 1, #eleIds do
    if core.getElementTypeById(eleIds[i]) == 'container'
    or core.getElementTypeById(eleIds[i]) == 'Hub Container' then
        local name = core.getElementNameById(eleIds[i])
        -- If not default container name, store.
        if not string.match(name, '%[') then
            -- Container name eg: Coal, Bauxite
            -- Name of containers, Size of container and Total Weight of container.
            table.insert(containers, {name, core.getElementMaxHitPointsById(eleIds[i]), core.getElementMassById(eleIds[i])})
        end
    end
end
-- Iterate through the list of ores so they display in order.
for i = 1, #ores do
    local style = ''
    if i == 5 then
        style = 'style="float:none;margin:0 auto;"'
    end
    htmlBody = htmlBody .. '<table '.. style ..'><tbody><tr><th colspan=3>TIER '..i..'</th></tr>'
    local tiers = ores[i]
    for x = 1, #tiers do
        local name = tiers[x][1]
        for y = 1, #containers do
            if containers[y][1] == name then
                local containerProficiency = 30 --export
                local hubVol = 114400 --export
                local sizes = {
                    -- Mining and Inventory, Inventory Manager, Container Proficiency.
                    -- Containers, min - max Hitpoints, Base Volume, Base Weight
                    {49.00,122.00,hubVol,55.80}, --Hub
                    {123.00,998.00,1000,229.09}, --xs
                    {998.00,7996.00,8000,1280}, --s
                    {7996.00,17316.00,64000,7421.34}, --m
                    {17316.00,50316.00,128000,14842.7} --l
                }
                for z = 1, #sizes do
                    if (containers[y][2] >= sizes[z][1] and containers[y][2] <= sizes[z][2]) then
                        local amount = (containers[y][3] - sizes[z][4]) / tiers[x][2]
                        local volume = sizes[z][3] + (sizes[z][3] * containerProficiency / 100)
                        -- we need to times the base volume by the proficiency modifier.
                        local percent = amount / volume
                        -- Convert L to KL to ML
                        if amount > 999999 then
                            amount = round(amount / 1000000, 2) .. 'ML'
                        elseif amount > 999 then
                            amount = round(amount / 1000, 2) .. 'KL'
                        else
                            amount = round(amount, 2) .. 'L'
                        end
                        local r,g,b = '255'
                        if percent < 0.5 then
                            -- I like red to blue....Empty -> half full.
                            -- range,              lower                upper..
                            r = math.floor(255 *(1 - (percent) / 0.5) +0 * (percent) / 0.5)
                            g = math.floor(0 *(1 - (percent) / 0.5) +0 * (percent) / 0.5)
                            b = math.floor(0 *(1 - (percent) / 0.5) +255 * (percent) / 0.5)
                        else
                            -- then, blue to green, half fulle -> full.
                            -- Alter range
                            r = math.floor(0 *(1 - (percent - 0.5) / 0.5) +0 * (percent - 0.5) / 0.5)
                            g = math.floor(0 *(1 - (percent - 0.5) / 0.5) +255 * (percent - 0.5) / 0.5)
                            b = math.floor(255 *(1 - (percent - 0.5) / 0.5) +0 * (percent - 0.5) / 0.5)
                        end
                        percent = round(percent * 100, 1)
                        local color = tiers[x][3]
                        htmlBody = htmlBody .. [[<tr>
                        <td class="name" style="border: 1px solid ]]..color..',1); background-color:'..color..', 0.6)">'..name..[[</td>
                        <td class="amount" style="border: 1px solid ]]..color..',1); background-color:'..color..', 0.6)">'..amount..[[</td>
                        <td class="percent" style="border: 1px solid ]]..color..[[,1);">
                        <div class="bar" style="width: ]]..percent..'%; background-color: '.. 'rgba('..r..','..g..','..b..',0.7)' ..'">'..percent..[[%</div>
                        </td>
                        </tr>
                        <tr class="blank"><td></td></tr>]]
                    end
                end
            end
        end
    end
    htmlBody = htmlBody .. '</tbody></table>'
end
screen.setHTML(htmlHead .. htmlBody .. htmlFoot)