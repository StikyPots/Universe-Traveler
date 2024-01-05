local ReplicatedStorage = game:GetService("ReplicatedStorage")
local readonly = require(ReplicatedStorage.Shared.MakeReadOnly)

Colors = {

    Rarity = {

        Common = Color3.fromHex("ABABAB");
        Rare = Color3.fromHex("3FC644");
        Epic = Color3.fromHex("983DF3");
        Legendary = Color3.fromHex("E09F21");
        Mythic = Color3.fromHex("EF2E14");

        Ultimate = {
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.166, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
        };
    }

} :: typeof(Colors)

return readonly(Colors)


