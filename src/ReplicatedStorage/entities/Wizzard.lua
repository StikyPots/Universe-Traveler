return {
    System = "SummonEntity",
    Health = 10,
    Speed = 2,
    
    Animations = {
        OnSummon = "16156639761";
        Walking = "16156648442";
    },

    ComponentsList = {

    EntityData = {
      Name = "Zombie",
      Health = 15,
      Speed = 2,
      Model = nil,
      DelayBetweenEachSpawn = 2,
      EntityToSpawn = "SummonedZombie"
    },

    CanSommon = true,
  }
}