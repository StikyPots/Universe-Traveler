
export type UserdataTemplate = {
    Gems: number;
    Level: number;
    Experience: number;
    Chests: {};
    Towers: {};
}

export type Tower = {
    Name: string;
    Experience: number;
    Level: number;
}

return {
    UserdataTemplate = {
        Gems = 0;
        Level = 1;
        Experience = 0;
        Chests = {};
        Towers = {};
    },

    EquipTowers = {

    };

    TowerTemplate = {
        Name = "";
        Experience = 0;
        Level = 0;
    }
}