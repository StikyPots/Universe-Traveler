return {
    Name = "spawn_entity";
	Aliases = {"spwne"};
	Description = "Spawn a new entity";
	Group = "Admin";
	Args = {
		{
			Type = "string";
			Name = "Entity name";
			Description = "The entity to spawn";
		},
        {
			Type = "number";
			Name = "Entity amount";
			Description = "Amount of entity to spawn";
		},
	};
}