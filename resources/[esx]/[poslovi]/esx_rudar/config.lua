Config = {
    ChanceToGetItem = 20, -- if math.random(0, 100) <= ChanceToGetItem then give item
    Items = {'iron'},
    Objects = {
        ['pickaxe'] = 'prop_tool_pickaxe',
    },
    MiningPositions = {
        {coords = vector3(2992.77, 2750.64, 42.78), heading = 209.29},
        {coords = vector3(2983.03, 2750.9, 42.02), heading = 214.08},
        {coords = vector3(2976.74, 2740.94, 43.63), heading = 246.21}
    },
}

Strings = {
    ['press_mine'] = 'Pritisnite ~INPUT_CONTEXT~ da zapocnete rudarenje.',
    ['mining_info'] = 'Pritisnite ~INPUT_ATTACK~ da udarite kamen ili ~INPUT_FRONTEND_RRIGHT~ da prestanete.',
    ['someone_close'] = 'Drugi igrac je blizu vas!',
    ['mining'] = 'Posao rudar'
}