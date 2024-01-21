return {
    PreloadTime = 1,
    StartTime = 1,

    TowerTag = "Tower",
    EntityTag = "Entity",

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
        Map = "Zombieland",
        Difficulty = "Normal",
        PlayerNumbers = 1,
    }

}