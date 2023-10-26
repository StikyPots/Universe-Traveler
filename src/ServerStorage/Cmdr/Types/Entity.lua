return function (registry)
    registry:RegisterType("entity", registry.Cmdr.Util.MakeEnumType(
        "Entity",
        {

            "Zombie";
            "Wizzard";
            "Robot"
            
        }
    ))
end