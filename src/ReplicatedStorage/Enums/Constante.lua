return {
    PreloadTime = 5,
    StartTime = 5,

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
        Normal = 250,
        Hard = 100,
	},
	
	MaxTowerOnMapPerDifficulty = {
		Easy = 150,
		Normal = 0,
		Hard = 50,
	},

    DefaultTeleportData = {
        Map = "Zombieland",
        Difficulty = "Normal",
        PlayerNumbers = 1,
    }

}