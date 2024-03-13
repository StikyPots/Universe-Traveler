return {
    PreloadTime = 1,
    StartTime = 1,

    TowerTag = "Tower",
    EntityTag = "Entity",

    PartyTimer = 45,
    
    BASE_COINS = 125;
    COINS_INCREMENT = 100,

    TowerMaxUpdate = 4,

    GlobalWaveSettings = {
        spawnRatePerDifficulty = {
            Easy = 0.5,
            Normal = 1,
            Hard = 1.5,
        };

        StartAmountPerDifficulty = {
            Easy = 2,
            Normal = 3,
            Hard = 5,
        },
    },

    BaseHealth = {
        Easy = 500,
        Normal = 100,
        Hard = 100,
	},
	
	MaxTowerOnMapPerDifficulty = {
		Easy = 130,
		Normal = 100,
		Hard = 50,
	},

    DefaultTeleportData = {
        Map = "Zombieland1",
        Difficulty = "Normal",
        PlayerNumbers = 1,
    },


    Notification = {
        defaultDuration = 8,
        defaultStyle = "none"
    }

}