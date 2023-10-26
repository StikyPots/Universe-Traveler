return {
    Name = "spawn_entity";
	Aliases = {"spwne"};
	Description = "Spawn a new entity";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "entity";
			Name = "Entity";
			Description = "The entity to spawn";
		},
        {
			Type = "number";
			Name = "Entity amount";
			Description = "Amount of entity to spawn";
		},
	};
}