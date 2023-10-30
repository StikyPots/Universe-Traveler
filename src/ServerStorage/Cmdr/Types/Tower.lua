return function (registry)
    registry:RegisterType("tower", registry.Cmdr.Util.MakeEnumType(
        "Tower",
        {
            
            "Mushroom";
            "Peashooter";
            "Toilet"
            
        }
    ))
end