DiscordWebhookSystemInfos = 'https://discordapp.com/api/webhooks/732283111194492958/jdRCktnESoJLtCFVC6TqdKXL8srqT0zUJ6tbSpXauZcH9wsLFHd_6cJsbk506x5EBRpT'
DiscordWebhookKillinglogs = 'https://discordapp.com/api/webhooks/732283231834996757/pvxGHi7SUqv5ZTubi0HPUgoIE0k0_c9VYw4nr9lO8rImlxfOT8ThUgtLNmCCDnPbhKJo'
DiscordWebhookChat = 'https://discordapp.com/api/webhooks/732283315821740072/vVNjB688daIXbgJFMjCsKZPSBUHQj4ljQp3vaJzFMnfaEY4HbIVzZ9-Cuyg8m84g0GY_'
DiscordWebhookMeh = 'https://discordapp.com/api/webhooks/732283377578934352/QBrcJKsVYHmDRtC3c8KlhXbiaecrTgKZWEWKS_7rS-npG1JpzTZ0hnY3ONbfbDStTLr_'
DiscordWebhookVozila = 'https://discordapp.com/api/webhooks/732283440073932950/oqqkIDZgmsC-TWKD_ygD-1x-KMH6w4cD7PQHb4FaAckwcEPxvfgyD66-DezXzCe7n_8P'
DiscordWebhookInventory = 'https://discordapp.com/api/webhooks/732283507686113340/-MYGlTN5cG76ZmYvdbI4R7Y7tc-3bs5khc-vAm9-qI8evrpANcGdXU4G0vl3c-aAqd-d'
DiscordWebhookAnticheat = 'https://discordapp.com/api/webhooks/732283580746825778/0MwBtKGivnz3QaJtb2PxVBlDu0Finf4E7Yy5iqsH_yfu7KdaMkMZWcqbKbnW8ryCamho'
DiscordWebhookMarkeri = 'https://discordapp.com/api/webhooks/733851348457619477/5NDuaumeuORaf3ZX3eR6O3wW42DUoMER4Qf4Q0N_6wt5waJtegOxfHwtyiBPFYC_hNpH'
DiscordWebhookGepek = 'https://discordapp.com/api/webhooks/747412906551017522/EpRXAzmF0X3NOBbvCoyiqBEmqAlTOawBCtCiPz4KfLm5rrCt55ADffj1RjLD-RNhujkg'
DiscordWebhookOduzimanje = 'https://discord.com/api/webhooks/786704036476878859/nU03Z9HQh1y3egs7Q7a0v4FGmJQNR9EMWLbecE5V90zOyDX0WVJYXMDxKKwIgMX6ndR-'
DiscordWebhookZetoni = 'https://discord.com/api/webhooks/794536116770045972/5AyVyA8ezOEgRGDH_7bK9CqECA3Sjdu9NO6mTHhvKs4f8ftI_mQ90OzFktzisjQBElFv'
DiscordWebhookGranica = 'https://discord.com/api/webhooks/801580952601231431/vEWbueIzvYYfM4OwRX8dvOfgNHRKMWTLkkifYQcP_l5BRb2RIQ21Q0zJWQuhzFzHGPWJ'
DiscordWebhookProdaja = 'https://discord.com/api/webhooks/848188467594526760/C9upnyfA0ELSoRd59IqDV-OU3sRpjhbphYVZOWXjW--p2vVMbHmnP0TbMft7Fq9Jotu5'

SystemAvatar = 'https://purepng.com/public/uploads/large/purepng.com-sealanimalssealsea-lion-981524671319vlofh.png'

UserAvatar = 'https://purepng.com/public/uploads/large/purepng.com-sealanimalssealsea-lion-981524671319vlofh.png'

SystemName = 'SEAL'


--[[ Special Commands formatting
		 *YOUR_TEXT*			--> Make Text Italics in Discord
		**YOUR_TEXT**			--> Make Text Bold in Discord
	   ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		__YOUR_TEXT__			--> Underline Text in Discord
	   __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	  __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	 __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		~~YOUR_TEXT~~			--> Strikethrough Text in Discord
]]
-- Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
-- Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command


-- These special commands will be printed differently in discord, depending on what you set it to
SpecialCommands = {
				   {'/ooc', '**[OOC]:**'},
				   {'/911', '**[911]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
				  }

						
-- These blacklisted commands will not be printed in discord
BlacklistedCommands = {
					   '/AnyCommand',
					   '/AnyCommand2',
					  }

-- These Commands will use their own webhook
OwnWebhookCommands = {
					  {'/AnotherCommand', 'WEBHOOK_LINK_HERE'},
					  {'/AnotherCommand2', 'WEBHOOK_LINK_HERE'},
					 }

-- These Commands will be sent as TTS messages
TTSCommands = {
			   '/Whatever',
			   '/Whatever2',
			  }

