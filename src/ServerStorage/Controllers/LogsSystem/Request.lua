local HttpService = game:GetService("HttpService")
local Connections = require(script.Parent.TrelloConnections)
local requests = {}

local Urls = {
    CreateList = "https://api.trello.com/1/lists?name=%s&idBoard=%s&key=%s&token=%s";
    GetList = "https://api.trello.com/1/lists/%s?key=%s&token=%s";
    CreateLabel = "https://api.trello.com/1/labels?name=%s&color=%s&idBoard=%s&key=%s&token=%s";
    GetLabel = "https://api.trello.com/1/labels/%s?key=%s&token=%s";
    CreateCard = "https://api.trello.com/1/cards?idList=%s&name=%s&desc=%s&due=%s&key=%s&token=%s";
    CreateLabelsToCard = "https://api.trello.com/1/cards/%s/labels?color=%s&name=%s&key=%s&token=%s";
}


function requests.CreateList(name: string): string
    local url = Urls.CreateList:format(name, Connections.BoardId, Connections.APIKey, Connections.token)

    local succes, result = pcall(function()
        return HttpService:RequestAsync({
            Url = url;
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json", -- When sending JSON, set this!
            },
        })
    end)

    if not succes then
        return nil
    end
    
    local Body: {id: string} = HttpService:JSONDecode(result.Body)

    return Body.id
end


function requests.GetList(Id: string): boolean
    local url = Urls.GetList:format(Id, Connections.APIKey, Connections.token)

    local success, result = pcall(function()
        return HttpService:RequestAsync({
            Url = url;
            Method = "GET",
        })
    end)
    
    if not success then
        return false
    end

    local Success: boolean = HttpService:JSONDecode(result.Success)

    return Success
end

function requests.CreateLabel(name: string, color: string)
    local url = Urls.CreateLabel:format(name, color,Connections.BoardId ,Connections.APIKey, Connections.token)

    local success, result = pcall(function()

        return HttpService:RequestAsync({
            Url = url;
            Method = "POST",
            Headers = {
            ["Content-Type"] = "application/json", -- When sending JSON, set this!
            },
        })
    end)

    if not success then
        return false
    end

    local Body = HttpService:JSONDecode(result.Body)
    
    
    return Body.id, Body.name
end

function requests.GetLabel(Id: string): string
    local url = Urls.GetLabel:format(Id,Connections.APIKey, Connections.token)

    local success, result = pcall(function()

        return HttpService:RequestAsync({
            Url = url;
            Method = "GET",
        })
    end)

    if not success then
        return false
    end

    local Body = HttpService:JSONDecode(result.Body)

    return Body.name, Body.id
end


function requests.AddLabelToCard(CardId: string, name: string, color: string)
    local url = Urls.CreateLabelsToCard:format(CardId, color, name, Connections.APIKey, Connections.token)
    local success, result = pcall(function()

        return HttpService:RequestAsync({
            Url = url;
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json", -- When sending JSON, set this!
            },
        })
    end)

    if not success then
        return false
    end

    return result
end

function requests.CreateCard(title: string, desc, Time: string)
    local url = Urls.CreateCard:format(Connections.LogListId, title, desc, Time, Connections.APIKey, Connections.token)
    local success, result = pcall(function()

        return HttpService:RequestAsync({
            Url = url;
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json", -- When sending JSON, set this!
            },
        })
    end)

    if not success then
        return false
    end

    local Body = HttpService:JSONDecode(result.Body)

    return Body
end

function requests.GetCard()
    
end


return requests
