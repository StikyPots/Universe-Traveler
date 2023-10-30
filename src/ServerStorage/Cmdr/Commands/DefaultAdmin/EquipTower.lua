return {
    Name = "give_tower_to";
	Aliases = {"gtt"};
	Description = "Give a tower to the selected player";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "players";
			Name = "Player";
			Description = "The player to give";
		},
        {
			Type = "tower";
			Name = "tower";
			Description = "The tower to give";
		},
	};
}