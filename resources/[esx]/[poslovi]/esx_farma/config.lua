Config              = {}
Config.DrawDistance = 100.0
Config.MaxDelivery	= 10
Config.TruckPrice	= 0
Config.Locale       = 'en'

Config.Trucks = {
	"tractor2"
}

Config.Cloakroom = {
			CloakRoom = {
					Pos   = {x = 2415.5666503906, y = 5004.8374023438, z = 45.683673858643},
					Size  = {x = 3.0, y = 3.0, z = 1.0},
					Color = {r = 204, g = 204, b = 0},
					Type  = 1,
					Id = 1
				}
}

Config.ZaposliSe = {
	Pos   = vector3(2411.5739746094, 4997.06640625, 46.58130645752),
	Size  = {x = 3.0, y = 3.0, z = 3.0},
	Color = {r = 101, g = 65, b = 104},
	Type  = 29,
	Sprite = 238,
	BColor = 5
}

Config.Zones = {
	VehicleSpawner = {
				Pos   = {x = 2434.4509277344, y = 5011.5419921875, z = 45.82914352417},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 204, g = 204, b = 0},
				Type  = 1
	},

	VehicleSpawnPoint = {
				Pos = {
					{ coords = vector3(2455.1228027344, 5009.9423828125, 45.093528747559), heading = 315.28479003906},
					{ coords = vector3(2401.5549316406, 4978.0239257812, 45.414737701416), heading = 133.11557006836},
					{ coords = vector3(2406.16796875, 4958.7705078125, 44.553562164306), heading = 133.95649719238 },
					{ coords = vector3(2388.6853027344, 4948.7299804688, 42.778270721436), heading = 167.25318908692 },
					{ coords = vector3(2378.9926757812, 4929.33203125, 42.52853012085), heading = 134.84870910644 }
                },
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Type  = -1
	},
	
	VehicleDeletePoint = {
				Pos   = {x = 2462.9230957031, y = 5022.8759765625, z = 44.616222381592},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 255, g = 0, b = 0},
				Type  = 1
	}
}

Config.Uniforms = {
	EUP = false,
	uniforma = { 
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 0,
			['torso_1'] = 95,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 37,
			['pants_1'] = 36,   ['pants_2'] = 0,
			['shoes_1'] = 35,   ['shoes_2'] = 1,
			['helmet_1'] = 5,  ['helmet_2'] = 0,
			['glasses_1'] = 19,  ['glasses_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 0,
			['torso_1'] = 0,   ['torso_2'] = 11,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 68,
			['pants_1'] = 30,   ['pants_2'] = 2,
			['shoes'] = 26,
			['helmet_1'] = 19,  ['helmet_2'] = 0,
			['glasses_1'] = 15,  ['glasses_2'] = 0
		}
	},
	EUPuniforma = { 
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 72, 1 },
				{ 3, 65, 1 },
				{ 10, 1, 1 },
				{ 8, 16, 1 },
				{ 4, 54, 1 },
				{ 6, 28, 1 },
				{ 7, 1, 1 },
				{ 9, 1, 1 },
				{ 5, 1, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 14, 1 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 68, 1 },
				{ 3, 76, 1 },
				{ 10, 1, 1 },
				{ 8, 15, 1 },
				{ 4, 56, 1 },
				{ 6, 27, 1 },
				{ 7, 1, 1 },
				{ 9, 1, 1 },
				{ 5, 1, 1 },
			}
		}
	}
}

Config.Objekti = {
	{x = 2338.9152832032, y = 5126.4633789062, z = 47.518600463868}, --Nema komentara
	{x = 2332.5815429688, y = 5132.8876953125, z = 48.08137512207}, --Nema komentara
	{x = 2327.2302246094, y = 5138.2719726562, z = 48.97045135498}, --Nema komentara
	{x = 2321.4802246094, y = 5143.662109375, z = 49.98942565918}, --Nema komentara
	{x = 2316.9721679688, y = 5148.0776367188, z = 51.045665740966}, --Nema komentara
	{x = 2312.2678222656, y = 5152.6044921875, z = 52.196041107178}, --Nema komentara
	{x = 2306.8227539062, y = 5157.8071289062, z = 53.888008117676}, --Nema komentara
	{x = 2302.2788085938, y = 5162.1245117188, z = 55.198497772216}, --Nema komentara
	{x = 2297.0776367188, y = 5166.765625, z = 56.793807983398}, --Nema komentara
	{x = 2291.2604980468, y = 5163.9301757812, z = 56.514533996582}, --Nema komentara
	{x = 2294.4899902344, y = 5160.55859375, z = 55.423301696778}, --Nema komentara
	{x = 2298.4638671875, y = 5156.50390625, z = 54.10300064087}, --Nema komentara
	{x = 2301.7785644532, y = 5153.0888671875, z = 53.18968963623}, --Nema komentara
	{x = 2305.7131347656, y = 5149.1328125, z = 52.148086547852}, --Nema komentara
	{x = 2310.1081542968, y = 5144.6787109375, z = 51.079578399658}, --Nema komentara
	{x = 2314.0114746094, y = 5140.794921875, z = 50.204833984375}, --Nema komentara
	{x = 2317.8825683594, y = 5136.9306640625, z = 49.320976257324}, --Nema komentara
	{x = 2321.9807128906, y = 5132.9755859375, z = 48.678161621094}, --Nema komentara
	{x = 2327.2834472656, y = 5127.98046875, z = 47.865497589112}, --Nema komentara
	{x = 2331.3859863282, y = 5124.1298828125, z = 47.448348999024}, --Nema komentara
	{x = 2336.7368164062, y = 5119.0659179688, z = 46.99250793457}, --Nema komentara
	{x = 2340.1064453125, y = 5115.8862304688, z = 46.979663848876}, --Nema komentara
	{x = 2343.4106445312, y = 5112.7739257812, z = 47.021587371826}, --Nema komentara
	{x = 2341.1528320312, y = 5109.4516601562, z = 46.826461791992}, --Nema komentara
	{x = 2337.0876464844, y = 5113.3837890625, z = 46.825260162354}, --Nema komentara
	{x = 2332.6555175782, y = 5117.5727539062, z = 46.999103546142}, --Nema komentara
	{x = 2328.6882324218, y = 5121.3857421875, z = 47.36520767212}, --Nema komentara
	{x = 2323.9255371094, y = 5125.9521484375, z = 47.90697479248}, --Nema komentara
	{x = 2319.21875, y = 5130.4951171875, z = 48.641242980958}, --Nema komentara
	{x = 2314.5419921875, y = 5135.0463867188, z = 49.412944793702}, --Nema komentara
	{x = 2310.1865234375, y = 5139.2470703125, z = 50.315372467042}, --Nema komentara
	{x = 2305.7470703125, y = 5143.5224609375, z = 51.233459472656}, --Nema komentara
	{x = 2301.0295410156, y = 5148.0283203125, z = 52.334373474122}, --Nema komentara
	{x = 2297.4487304688, y = 5151.3364257812, z = 53.181270599366}, --Nema komentara
	{x = 2294.0769042968, y = 5154.5239257812, z = 54.08662033081}, --Nema komentara
	{x = 2290.7248535156, y = 5157.6875, z = 55.091999053956}, --Nema komentara
	{x = 2287.3701171875, y = 5160.857421875, z = 56.075969696044}, --Nema komentara
	{x = 2285.1057128906, y = 5158.58203125, z = 55.675048828125}, --Nema komentara
	{x = 2288.9323730468, y = 5154.7001953125, z = 54.541625976562}, --Nema komentara
	{x = 2293.3891601562, y = 5150.2446289062, z = 53.225574493408}, --Nema komentara
	{x = 2297.8347167968, y = 5145.7622070312, z = 52.189609527588}, --Nema komentara
	{x = 2302.4953613282, y = 5141.1333007812, z = 51.112079620362}, --Nema komentara
	{x = 2307.1547851562, y = 5136.5864257812, z = 50.178043365478}, --Nema komentara
	{x = 2312.5888671875, y = 5131.31640625, z = 49.079265594482}, --Nema komentara
	{x = 2318.0295410156, y = 5126.0498046875, z = 48.25001525879}, --Nema komentara
	{x = 2323.1462402344, y = 5120.8603515625, z = 47.478164672852}, --Nema komentara
	{x = 2328.3898925782, y = 5115.6123046875, z = 46.95038986206}, --Nema komentara
	{x = 2334.1809082032, y = 5109.7880859375, z = 46.581546783448}, --Nema komentara
	{x = 2338.9602050782, y = 5105.001953125, z = 46.470428466796}, --Nema komentara
	{x = 2336.2014160156, y = 5102.2529296875, z = 46.19811630249}, --Nema komentara
	{x = 2331.0334472656, y = 5107.2666015625, z = 46.397560119628}, --Nema komentara
	{x = 2325.7507324218, y = 5112.359375, z = 46.786060333252}, --Nema komentara
	{x = 2320.4792480468, y = 5117.4970703125, z = 47.327503204346}, --Nema komentara
	{x = 2315.6350097656, y = 5122.1508789062, z = 48.050235748292}, --Nema komentara
	{x = 2310.7990722656, y = 5126.7509765625, z = 48.814292907714}, --Nema komentara
	{x = 2306.2380371094, y = 5131.3422851562, z = 49.678733825684}, --Nema komentara
	{x = 2300.69921875, y = 5136.8120117188, z = 50.749599456788}, --Nema komentara
	{x = 2296.037109375, y = 5141.4838867188, z = 51.717319488526}, --Nema komentara
	{x = 2291.7805175782, y = 5145.7846679688, z = 52.623439788818}, --Nema komentara
	{x = 2287.6589355468, y = 5149.9233398438, z = 53.664127349854}, --Nema komentara
	{x = 2282.96484375, y = 5154.6264648438, z = 54.94197845459} --Nema komentara 
}

Config.Objekti2 = {
	{x = 2332.365234375, y = 5098.1538085938, z = 45.887554168701}, --njiva2
	{x = 2327.345703125, y = 5103.6318359375, z = 46.190032958984}, --njiva2
	{x = 2322.2905273438, y = 5108.763671875, z = 46.61642074585}, --njiva2
	{x = 2317.2573242188, y = 5113.943359375, z = 47.171062469482}, --njiva2
	{x = 2312.0993652344, y = 5119.2861328125, z = 47.973957061768}, --njiva2
	{x = 2308.0900878906, y = 5123.3833007813, z = 48.634212493896}, --njiva2
	{x = 2303.7114257813, y = 5128.0517578125, z = 49.4114112854}, --njiva2
	{x = 2297.9890136719, y = 5134.04296875, z = 50.436531066895}, --njiva2
	{x = 2293.3881835938, y = 5138.873046875, z = 51.363090515137}, --njiva2
	{x = 2289.5307617188, y = 5142.9155273438, z = 52.209590911865}, --njiva2
	{x = 2285.1083984375, y = 5147.5043945313, z = 53.343444824219}, --njiva2
	{x = 2279.8427734375, y = 5152.580078125, z = 54.738857269287}, --njiva2
	{x = 2277.19921875, y = 5149.4931640625, z = 54.346622467041}, --njiva2
	{x = 2280.5119628906, y = 5145.939453125, z = 53.391983032227}, --njiva2
	{x = 2285.8002929688, y = 5140.8642578125, z = 52.054515838623}, --njiva2
	{x = 2290.9143066406, y = 5135.6430664063, z = 51.010887145996}, --njiva2
	{x = 2295.5261230469, y = 5131.0048828125, z = 50.140895843506}, --njiva2
	{x = 2300.2482910156, y = 5126.39453125, z = 49.372406005859}, --njiva2
	{x = 2305.1765136719, y = 5121.5151367188, z = 48.57213973999}, --njiva2
	{x = 2309.9301757813, y = 5116.9418945313, z = 47.830955505371}, --njiva2
	{x = 2314.4399414063, y = 5112.6186523438, z = 47.141967773438}, --njiva2
	{x = 2320.6877441406, y = 5106.6704101563, z = 46.48462677002}, --njiva2
	{x = 2325.7543945313, y = 5101.7778320313, z = 46.068412780762}, --njiva2
	{x = 2330.9919433594, y = 5096.6025390625, z = 45.760746002197}, --njiva2
	{x = 2328.0300292969, y = 5092.26171875, z = 45.434852600098}, --njiva2
	{x = 2322.5241699219, y = 5097.900390625, z = 45.819786071777}, --njiva2
	{x = 2317.4123535156, y = 5103.0180664063, z = 46.268238067627}, --njiva2
	{x = 2311.8088378906, y = 5108.6381835938, z = 46.886680603027}, --njiva2
	{x = 2306.5610351563, y = 5113.9614257813, z = 47.611488342285}, --njiva2
	{x = 2300.2624511719, y = 5120.3354492188, z = 48.516498565674}, --njiva2
	{x = 2294.5666503906, y = 5125.8510742188, z = 49.458076477051}, --njiva2
	{x = 2288.4978027344, y = 5131.81640625, z = 50.519420623779}, --njiva2
	{x = 2281.6257324219, y = 5138.7758789063, z = 51.888095855713}, --njiva2
	{x = 2274.3056640625, y = 5145.6118164063, z = 53.82873916626}, --njiva2
	{x = 2269.7233886719, y = 5143.0502929688, z = 53.740772247314}, --njiva2
	{x = 2274.5139160156, y = 5138.0209960938, z = 52.368541717529}, --njiva2
	{x = 2280.7973632813, y = 5131.9350585938, z = 50.92541885376}, --njiva2
	{x = 2286.033203125, y = 5126.8793945313, z = 49.995391845703}, --njiva2
	{x = 2292.5854492188, y = 5120.5209960938, z = 48.984191894531}, --njiva2
	{x = 2298.6257324219, y = 5114.8989257813, z = 48.100688934326}, --njiva2
	{x = 2305.1020507813, y = 5108.7563476563, z = 47.271106719971}, --njiva2
	{x = 2311.25390625, y = 5102.8032226563, z = 46.551834106445}, --njiva2
	{x = 2320.6960449219, y = 5093.34765625, z = 45.675048828125}, --njiva2
	{x = 2313.853515625, y = 5092.59375, z = 46.086994171143}, --njiva2
	{x = 2307.361328125, y = 5098.73828125, z = 46.651721954346}, --njiva2
	{x = 2302.1022949219, y = 5103.685546875, z = 47.127258300781}, --njiva2
	{x = 2295.6254882813, y = 5110.060546875, z = 47.941040039063}, --njiva2
	{x = 2289.2878417969, y = 5116.2255859375, z = 48.8466796875}, --njiva2
	{x = 2283.26171875, y = 5122.0786132813, z = 49.757804870605}, --njiva2
	{x = 2277.736328125, y = 5127.3559570313, z = 50.670463562012}, --njiva2
	{x = 2271.7038574219, y = 5133.1274414063, z = 51.88249206543}, --njiva2
	{x = 2266.5241699219, y = 5138.0385742188, z = 53.160919189453} --njiva2
}

Config.Objekti3 = {
	{x = 2211.4377441406, y = 5175.5493164063, z = 57.024463653564}, --njiva3
	{x = 2205.6208496094, y = 5181.5595703125, z = 57.401336669922}, --njiva3
	{x = 2197.9775390625, y = 5189.53515625, z = 58.041706085205}, --njiva3
	{x = 2187.1755371094, y = 5199.8330078125, z = 58.901142120361}, --njiva3
	{x = 2171.8937988281, y = 5206.3784179688, z = 58.620002746582}, --njiva3
	{x = 2179.8771972656, y = 5197.3989257813, z = 58.03938293457}, --njiva3
	{x = 2186.9226074219, y = 5189.8217773438, z = 57.609146118164}, --njiva3
	{x = 2193.6872558594, y = 5182.275390625, z = 57.05199432373}, --njiva3
	{x = 2202.7800292969, y = 5172.3500976563, z = 56.366355895996}, --njiva3
	{x = 2200.8569335938, y = 5166.5209960938, z = 55.661102294922}, --njiva3
	{x = 2194.8452148438, y = 5172.6821289063, z = 56.067489624023}, --njiva3
	{x = 2187.2983398438, y = 5181.1123046875, z = 56.818073272705}, --njiva3
	{x = 2178.2536621094, y = 5191.0473632813, z = 57.515247344971}, --njiva3
	{x = 2165.9035644531, y = 5204.7744140625, z = 58.128044128418}, --njiva3
	{x = 2156.9294433594, y = 5208.1538085938, z = 57.934513092041}, --njiva3
	{x = 2163.2438964844, y = 5200.9853515625, z = 57.742855072021}, --njiva3
	{x = 2171.736328125, y = 5191.7495117188, z = 57.359439849854}, --njiva3
	{x = 2180.578125, y = 5182.3032226563, z = 56.603340148926}, --njiva3
	{x = 2188.3371582031, y = 5173.9619140625, z = 55.898887634277}, --njiva3
	{x = 2197.3854980469, y = 5164.5336914063, z = 55.185882568359} --njiva3
}

Config.Objekti4 = {
	{x = 2186.3937988281, y = 5152.955078125, z = 52.874935150146}, --njiva4
	{x = 2178.8952636719, y = 5161.0986328125, z = 53.399967193604}, --njiva4
	{x = 2169.9802246094, y = 5170.841796875, z = 54.483695983887}, --njiva4
	{x = 2160.9858398438, y = 5180.85546875, z = 55.500541687012}, --njiva4
	{x = 2150.3676757813, y = 5192.2065429688, z = 56.328842163086}, --njiva4
	{x = 2137.7741699219, y = 5205.5844726563, z = 56.49686050415}, --njiva4
	{x = 2127.984375, y = 5208.7133789063, z = 56.182342529297}, --njiva4
	{x = 2133.8510742188, y = 5202.3564453125, z = 56.085498809814}, --njiva4
	{x = 2142.7119140625, y = 5192.4873046875, z = 55.912113189697}, --njiva4
	{x = 2153.0944824219, y = 5181.0551757813, z = 55.210433959961}, --njiva4
	{x = 2163.1108398438, y = 5170.6201171875, z = 54.150733947754}, --njiva4
	{x = 2173.1398925781, y = 5160.54296875, z = 53.072280883789}, --njiva4
	{x = 2181.521484375, y = 5151.7250976563, z = 52.360885620117}, --njiva4
	{x = 2180.162109375, y = 5146.03125, z = 51.388092041016}, --njiva4
	{x = 2174.486328125, y = 5151.9189453125, z = 51.847713470459}, --njiva4
	{x = 2165.8239746094, y = 5161.552734375, z = 52.974430084229}, --njiva4
	{x = 2158.1215820313, y = 5169.701171875, z = 53.849258422852}, --njiva4
	{x = 2149.4985351563, y = 5178.7841796875, z = 54.866737365723}, --njiva4
	{x = 2140.0754394531, y = 5188.6000976563, z = 55.439674377441}, --njiva4
	{x = 2129.94921875, y = 5199.37109375, z = 55.794296264648}, --njiva4
	{x = 2124.21875, y = 5205.7250976563, z = 55.976428985596}, --njiva4
	{x = 2118.0146484375, y = 5205.2788085938, z = 55.706317901611}, --njiva4
	{x = 2124.0720214844, y = 5198.4233398438, z = 55.639911651611}, --njiva4
	{x = 2132.1708984375, y = 5189.833984375, z = 55.113162994385}, --njiva4
	{x = 2139.3364257813, y = 5181.9829101563, z = 54.608913421631}, --njiva4
	{x = 2146.2761230469, y = 5174.2846679688, z = 54.053665161133}, --njiva4
	{x = 2154.3994140625, y = 5165.7631835938, z = 53.064800262451}, --njiva4
	{x = 2161.6467285156, y = 5158.208984375, z = 52.143402099609}, --njiva4
	{x = 2167.2702636719, y = 5152.5893554688, z = 51.47730255127}, --njiva4
	{x = 2174.279296875, y = 5145.4013671875, z = 50.772117614746}, --njiva4
	{x = 2172.2890625, y = 5139.5600585938, z = 49.62370300293}, --njiva4
	{x = 2165.9890136719, y = 5146.2602539063, z = 50.215038299561}, --njiva4
	{x = 2159.3461914063, y = 5153.4228515625, z = 51.088798522949}, --njiva4
	{x = 2151.1311035156, y = 5161.9150390625, z = 52.197525024414}, --njiva4
	{x = 2143.5288085938, y = 5170.1904296875, z = 53.165897369385}, --njiva4
	{x = 2135.7919921875, y = 5177.8251953125, z = 53.766574859619}, --njiva4
	{x = 2130.234375, y = 5183.87890625, z = 54.225303649902}, --njiva4
	{x = 2123.5993652344, y = 5190.744140625, z = 54.687042236328}, --njiva4
	{x = 2118.2629394531, y = 5196.9252929688, z = 55.140403747559}, --njiva4
	{x = 2112.4328613281, y = 5203.7368164063, z = 55.284187316895} --njiva4
}

Config.Krave = {
	{x = 2371.2600097656, y = 5058.9790039063, z = 46.463287353516, h = 143.96441650391}, --k1
	{x = 2369.447265625, y = 5053.6147460938, z = 46.42414855957, h = 182.61289978027}, --k2
	{x = 2371.419921875, y = 5049.8671875, z = 46.424144744873, h = 109.44066619873}, --k3
	{x = 2372.1618652344, y = 5046.15625, z = 46.399410247803, h = 290.04943847656}, --k4
	{x = 2375.0610351563, y = 5044.5024414063, z = 46.396209716797, h = 241.81335449219}, --k5
	{x = 2379.0725097656, y = 5044.9047851563, z = 46.418712615967, h = 347.81436157227}, --k6
	{x = 2378.0329589844, y = 5049.30859375, z = 46.444637298584, h = 8.3541431427002}, --k7
	{x = 2378.8879394531, y = 5053.4165039063, z = 46.444637298584, h = 330.89785766602}, --k8
	{x = 2383.4699707031, y = 5052.8745117188, z = 46.444637298584, h = 272.30215454102}, --k9
	{x = 2385.8745117188, y = 5056.1362304688, z = 46.444637298584, h = 16.403709411621},
	{x = 2374.7951660156, y = 5056.3833007813, z = 46.444641113281, h = 304.85494995117}, --k11
	{x = 2376.3024902344, y = 5061.41796875, z = 46.444610595703, h = 263.32775878906}, --k12
	{x = 2381.1789550781, y = 5060.978515625, z = 46.444610595703, h = 157.4090423584}
}