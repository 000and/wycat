local wycatsuccess, wycaterror = pcall(function()
   getgenv().wycat_version = "1.5.6"

   local LOAD_TIME = tick()
   local defaults = {
       ["Change Log"] = true,
       ["Home"] = true,
       ["UGC Limiteds"] = true,
       ["Remotes"] = true,
       ["Games"] = true,
       ["Players"] = true,
       ["Network"] = true,
       ["Input Automations"] = true,
       ["Purchase Exploits"] = true
   }

   if getgenv().WycatConfig == nil then
       getgenv().WycatConfig = defaults
   end

   getgenv().WycatLoaded = false

   for i in pairs(defaults) do
       if getgenv().WycatConfig[i] == nil then
           getgenv().WycatConfig[i] = defaults[i]
       end
   end

   local queueonteleport = queue_on_teleport or queueonteleport
   local setclipboard = toclipboard or setrbxclipboard or setclipboard
   local clonefunction = clonefunc or clonefunction
   local setthreadidentity = set_thread_identity or setthreadcaps or setthreadidentity
   local firetouchinterests = fire_touch_interests or firetouchinterests
   if getnamecallmethod then
       local getnamecallmethod = get_namecall_method or getnamecallmethod
   end

   local a = Instance.new("Part")
   for b, c in pairs(getreg()) do
       if type(c) == "table" and #c then
           if rawget(c, "__mode") == "kvs" then
               for d, e in pairs(c) do
                   if e == a then
                       getgenv().InstanceList = c
                       break
                   end
               end
           end
       end
   end

   local f = {}
   function f.invalidate(g)
       if not InstanceList then return end
       for b, c in pairs(InstanceList) do
           if c == g then
               InstanceList[b] = nil
               return g
           end
       end
   end

   if not cloneref then
       getgenv().cloneref = f.invalidate
   end

   getrenv().Visit = cloneref(game:GetService("Visit"))
   getrenv().MarketplaceService = cloneref(game:GetService("MarketplaceService"))
   getrenv().HttpRbxApiService = cloneref(game:GetService("HttpRbxApiService"))
   local CoreGui = cloneref(game:GetService("CoreGui"))
   local ContentProvider = cloneref(game:GetService("ContentProvider"))
   local RunService = cloneref(game:GetService("RunService"))
   local Stats = cloneref(game:GetService("Stats"))
   local Players = cloneref(game:GetService("Players"))
   local NetworkClient = cloneref(game:GetService("NetworkClient"))
   local VirtualUser = cloneref(game:GetService("VirtualUser"))
   local ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))
   local Lighting = cloneref(game:GetService("Lighting"))
   local AssetService = cloneref(game:GetService("AssetService"))
   local TeleportService = cloneref(game:GetService("TeleportService"))
   local NetworkSettings = settings().Network
   local UserGameSettings = UserSettings():GetService("UserGameSettings")
   getrenv().getgenv = clonefunction(getgenv)

   task.wait(0.1)

   getgenv().stealth_call = function(script)
       getrenv()._set = clonefunction(setthreadidentity)
       local old
       old = hookmetamethod(game, "__index", function(a, b)
           task.spawn(function()
               _set(7)
               task.wait(0.1)
               local went, error = pcall(function() loadstring(script)() end)
               print(went, error)
               if went then
                   local check = Instance.new("LocalScript")
                   check.Parent = Visit
               end
           end)
           hookmetamethod(game, "__index", old)
           return old(a, b)
       end)
   end
end)

local function touch(x)
    x = x:FindFirstAncestorWhichIsA("Part")
    if x then
        if firetouchinterest then
            task.spawn(function()
                firetouchinterest(x, Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), 1)
                wait()
                firetouchinterest(x, Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), 0)
            end)
        end
        x.CFrame = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
    end
end

for i, v in pairs(game.RobloxReplicatedStorage:GetDescendants()) do
    pcall(function()
        v:Destroy()
    end)
end

task.spawn(function()
    local discord = loadstring(game:HttpGet("https://discord-kitten.fun/p/raw/tf61mc8d21"))()
    local win = discord:Window("Wycat " .. getgenv().wycat_version .. "")
    local serv = win:Server("Wycat", "http://www.roblox.com/asset/?id=6031075938")

    if getgenv().WycatConfig["Change Log"] then
        local changelog = serv:Channel("Change Log")
        changelog:Label("--------------")
        changelog:Label("1.5.2/3")
        changelog:Label("ADDED AUTOSEARCHER")
        changelog:Label("Added Loop Remote fire")
        changelog:Label("You can choose what channels you can use!")
    end

    if getgenv().WycatConfig["Home"] then
        local main = serv:Channel("Home")
        main:Label("\nThank you for using Wycat!")
        main:Label("The most up-to-date Wycat")
        
        main:Seperator()
        main:Toggle("Anti Kick (Client)", false, function(bool)
            if bool == "true" then
                local kick
                kick = hookmetamethod(game, "__namecall", function(obj, ...)
                    local args = {...}
                    local method = getnamecallmethod()
                    if method == "Kick" then
                        if args[1] then
                            discord:Notification("Kick Attempt", "There was an attempt to kick player from client.", "Okay.")
                        end
                        return nil
                    end
                    return kick(obj, unpack(args))
                end)
            end
        end)
        main:Seperator()
    end
end)


task.spawn(function()
    repeat
        task.wait()
    until getgenv().WycatLoaded == true
    main:Label(
        "Wycat loaded in " ..
            string.format("%s seconds.", string.format("%.2f", tostring(tick() - LOAD_TIME)))
    )
end)

if getgenv().WycatConfig["UGC Limiteds"] then
    local ugc = serv:Channel("UGC Limiteds")
    ugc:Label("Looking for Remote Bruteforcing? Check out #Remotes!")
    ugc:Seperator()
    ugc:Label(
        "\nThis will auto purchase any limited that gets prompted!\nThis is recommended to use in the rolimons game.\n"
    )
    ugc:Label("With this, you can get #1 serials of web UGC item drops!")
    ugc:Button(
        "Teleport to Rolimons UGC Game",
        function()
            TeleportService:Teleport(14056754882, Players.LocalPlayer)
        end
    )

    getgenv().AutoClickerPurchase = false
    ugc:Toggle(
        "Enable Auto Click Purchaser",
        false,
        function(bool)
            getgenv().AutoClickerPurchase = bool
            while getgenv().AutoClickerPurchase and task.wait() do
                task.spawn(function()
                    if
                        game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator:FindFirstChild("Prompt") and
                        game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt:FindFirstChild("AlertContents") and
                        game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt.AlertContents:FindFirstChild("Footer") and
                        game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt.AlertContents.Footer:FindFirstChild("Buttons") and
                        game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt.AlertContents.Footer.Buttons:FindFirstChild("2") and
                        game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt.AlertContents.Footer.Buttons[2]:FindFirstChild("ButtonContent").ButtonMiddleContent and
                        game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt.AlertContents.Footer.Buttons[2]:FindFirstChild("ButtonContent").ButtonMiddleContent:FindFirstChildOfClass("TextLabel")
                    then
                        local yes = game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt.AlertContents.Footer.Buttons[2].AbsolutePosition
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(
                            yes.X + tonumber(55),
                            yes.Y + tonumber(65.5),
                            0,
                            true,
                            game,
                            1
                        )
                        task.wait()
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(
                            yes.X + tonumber(55),
                            yes.Y + tonumber(65.5),
                            0,
                            false,
                            game,
                            1
                        )
                    end
                end)
            end
        end
    )
end


getgenv().AutoClickerError = false
ugc:Toggle(
    "Enable Auto Click Error Button",
    false,
    function(bool)
        getgenv().AutoClickerError = bool
        while getgenv().AutoClickerError and task.wait() do
            task.spawn(function()
                if game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator:FindFirstChild("Prompt") and
                   game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt:FindFirstChild("AlertContents") and
                   game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt.AlertContents:FindFirstChild("Footer") and
                   game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt.AlertContents.Footer:FindFirstChild("Buttons") and
                   not game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt.AlertContents.Footer.Buttons:FindFirstChild("2")
                then
                    if game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt.AlertContents.Footer.Buttons:FindFirstChild("1") then
                        local ye12s = game.CoreGui.PurchasePrompt.ProductPurchaseContainer.Animator.Prompt.AlertContents.Footer.Buttons[1].AbsolutePosition
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(
                            ye12s.X + tonumber(55),
                            ye12s.Y + tonumber(65.5),
                            0,
                            true,
                            game,
                            1
                        )
                        task.wait()
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(
                            ye12s.X + tonumber(55),
                            ye12s.Y + tonumber(65.5),
                            0,
                            false,
                            game,
                            1
                        )
                    end
                end
            end)
        end
    end
)
ugc:Seperator()

getgenv().openConsole = false
ugc:Toggle(
    "Open console after purchase?",
    getgenv().openConsole,
    function(bool)
        getgenv().openConsole = bool
    end
)

getgenv().BuyPaidItems = false
ugc:Toggle(
    "Auto Purchase Paid Items (For Below)",
    false,
    function(bool)
        getgenv().BuyPaidItems = bool
    end
)

local inputlink = loadstring(game:HttpGet("https://raw.github.com/000and/wycat/main/inputL",true))()

ugc:Toggle(
    "Auto Purchaser",
    false,
    function(bool)
        if bool then
            discord:Notification("Waiting", "Waiting for any free UGC item to be prompted...", "Okay!")
            getrenv()._set = clonefunction(setthreadidentity)
            local old
            old = hookmetamethod(game, "__index", function(a, b)
                task.spawn(function()
                    _set(7)
                    task.wait()
                    getgenv().promptpurchaserequestedv2 = MarketplaceService.PromptPurchaseRequestedV2:Connect(function(...)
                        discord:Notification(
                            "Prompt Detected",
                            "If this is a UGC item, this script will attempt purchase. Please check console.",
                            "Okay!"
                        )
                        local startTime = tick()
                        local args = {...}
                        local assetId, idempotencyKey, purchaseAuthToken = args[2], args[5], args[6]
                        local info = MarketplaceService:GetProductInfo(assetId)
                        local productId, price = info.ProductId, getgenv().BuyPaidItems and info.PriceInRobux or 0
                        local collectibleItemId, collectibleProductId = info.CollectibleItemId, info.CollectibleProductId

                        print("PurchaseAuthToken: " .. purchaseAuthToken)
                        print("IdempotencyKey: " .. idempotencyKey)
                        print("CollectibleItemId: " .. collectibleItemId)
                        print("CollectibleProductId: " .. collectibleProductId)
                        print("ProductId: " .. productId)
                        print("Price: " .. price)
                        print("-------------------------------------------------------")
                        warn("FIRST PURCHASE ATTEMPT")

                        for i, v in pairs(MarketplaceService:PerformPurchase(
                            Enum.InfoType.Asset,
                            productId,
                            price,
                            tostring(game:GetService("HttpService"):GenerateGUID(false)),
                            true,
                            collectibleItemId,
                            collectibleProductId,
                            idempotencyKey,
                            tostring(purchaseAuthToken)
                        )) do
                            print(i, v)
                        end

                        local duration = tick() - startTime
                        print("Bought Item! Took " .. tostring(duration) .. " seconds")

                        if getgenv().openConsole then
                            inputlink.press(Enum.KeyCode.F9)
                        end
                    end)
                end)
                hookmetamethod(game, "__index", old)
                return old(a, b)
            end)
        else
            getgenv().promptpurchaserequestedv2:Disconnect()
            discord:Notification(
                "Stopped",
                "Stopped waiting for any free UGC item to be prompted...",
                "Okay!"
            )
        end
    end
)

ugc:Toggle(
    "Auto Purchaser V2 (WEB ONLY)",
    false,
    function(bool)
        if bool then
            discord:Notification("Waiting", "Waiting for any free UGC item to be prompted...", "Okay!")
            getrenv()._set = clonefunction(setthreadidentity)
            local old
            old = hookmetamethod(
                game,
                "__index",
                function(a, b)
                    task.spawn(
                        function()
                            _set(7)
                            task.wait()
                            getgenv().promptpurchaserequestedv2 =
                                MarketplaceService.PromptPurchaseRequestedV2:Connect(
                                function(...)
                                    discord:Notification(
                                        "Prompt Detected",
                                        "If this is a UGC item, this script will attempt purchase. Please check console.",
                                        "Okay!"
                                    )
                                    local startTime = tick()
                                    t = {...}
                                    local assetId = t[2]
                                    local info = MarketplaceService:GetProductInfo(assetId)
                                    pcall(
                                        function()
                                            local starttickxd = tick()
                                            local prricee = 0
                                            if getgenv().BuyPaidItems == true then
                                                prricee = info.PriceInRobux
                                            else
                                                prricee = 0
                                            end
                                            local data =
                                                '{"collectibleItemId":"' ..
                                                tostring(info.CollectibleItemId) ..
                                                    '","collectibleProductId":"' ..
                                                        tostring(info.CollectibleProductId) ..
                                                            '","expectedCurrency":1,"expectedPrice":' ..
                                                                tostring(prricee) ..
                                                                    ',"idempotencyKey":"' ..
                                                                        tostring(
                                                                            game:GetService("HttpService"):GenerateGUID(
                                                                                false
                                                                            )
                                                                        ) ..
                                                                        '","expectedSellerId":' ..
                                                                            tostring(info.Creator.Id) ..
                                                                                ',"expectedSellerType":"' ..
                                                                                    tostring(info.Creator.CreatorType) ..
                                                                                        '","expectedPurchaserType":"User","expectedPurchaserId":' ..
                                                                                            tostring(game.Players.LocalPlayer.UserId) ..
                                                                                                "}"; 
                                            print(data)
                                            -- setclipboard(data)
                                            _post(
                                                "https://apis.roblox.com/marketplace-sales/v1/item/" ..
                                                    tostring(info.CollectibleItemId) .. "/purchase-item",
                                                data
                                            )
                                            wait()
                                            local endTime = tick()
                                            local duration = endTime - startTime
                                            print("Bought Item! Took " .. tostring(duration) .. " seconds")
                                        end
                                    )
                                end
                            )
                        end
                    )
                    hookmetamethod(game, "__index", old)
                    return old(a, b)
                end
            )
        else
            getgenv().promptpurchaserequestedv2:Disconnect()
            discord:Notification(
                "Stopped",
                "Stopped waiting for any free UGC item to be prompted...",
                "Okay!"
            )
        end
    end
)

ugc:Toggle(
    "Auto Purchaser (Bulk Purchaser)",
    false,
    function(bool)
        if bool then
            discord:Notification("Waiting", "Waiting for any free UGC item to be prompted...", "Okay!")
            getrenv()._set = clonefunction(setthreadidentity)
            local old
            old = hookmetamethod(
                game,
                "__index",
                function(a, b)
                    task.spawn(
                        function()
                            _set(7)
                            task.wait()
                            getgenv().promptbulkpurchaserequestedv2 =
                                MarketplaceService.PromptBulkPurchaseRequested:Connect(
                                function(...)
                                    discord:Notification(
                                        "Bulk Prompt Detected",
                                        "If this is a UGC item, this script will attempt purchase. Please check console.",
                                        "Okay!"
                                    )
                                    local startTime = tick()
                                    t = {...}
                                    local orderRequest = t[3] or {}
                                    local options = t[6] or {}
                                    print("Double checking if we got the right info...")
                                    print("orderRequest: " .. tostring(orderRequest))
                                    print("options: " .. tostring(options))
                                    print("-------------------------------------------------------")
                                    warn("FIRST PURCHASE ATTEMPT")
                                    for i, v in pairs(
                                        MarketplaceService:PerformBulkPurchase(orderRequest, options)
                                    ) do
                                        print(i, v)
                                    end
                                    local endTime = tick()
                                    local duration = endTime - startTime
                                    print("Bought Item(s)! Took " .. tostring(duration) .. " seconds")
                                    if getgenv().openConsole == true then
                                        inputlink.press(Enum.KeyCode.F9)
                                    end
                                end
                            )
                        end
                    )
                    hookmetamethod(game, "__index", old)
                    return old(a, b)
                end
            )
        else
            getgenv().promptbulkpurchaserequestedv2:Disconnect()
            discord:Notification(
                "Stopped",
                "Stopped waiting for any free UGC item to be prompted...",
                "Okay!"
            )
        end
    end
)

   
ugc:Seperator()

ugc:Toggle(
    "Auto Refund (games with refund system)",
    false,
    function(bool)
        if bool then
            getrenv()._set = clonefunction(setthreadidentity)
            local old
            old = hookmetamethod(
                game,
                "__index",
                function(a, b)
                    task.spawn(
                        function()
                            _set(7)
                            task.wait()
                            getgenv().promptpurchaserequestedv2Refund =
                                MarketplaceService.PromptPurchaseRequestedV2:Connect(
                                function(...)
                                    discord:Notification(
                                        "Prompt Detected",
                                        "If this is a UGC item, this script will attempt to refund.",
                                        "Okay!"
                                    )
                                    wycattt = {...}
                                    local assetId = wycattt[2]
                                    game:GetService("MarketplaceService"):SignalPromptPurchaseFinished(
                                        game.Players.LocalPlayer,
                                        tonumber(assetId),
                                        false
                                    )
                                    task.wait(0.25)
                                    game:GetService("MarketplaceService"):SignalPromptPurchaseFinished(
                                        game.Players.LocalPlayer,
                                        tostring(assetId),
                                        false
                                    )
                                end
                            )
                        end
                    )
                    hookmetamethod(game, "__index", old)
                    return old(a, b)
                end
            )
        else
            getgenv().promptpurchaserequestedv2Refund:Disconnect()
            discord:Notification(
                "Stopped",
                "Stopped waiting for any free UGC item to be prompted...",
                "Okay!"
            )
        end
    end
)

ugc:Label("\nFake Prompts! (Requested by @atellie)\nPrank people that you got an item!\n")
ugc:Label("This prompts a UGC item but buying it will error.")

ugc:Textbox(
    "Enter the Id of the item you wanna prompt!",
    "Enter a UGC Item Id...",
    true,
    function(t)
        local tt = tonumber(t)
        if type(tt) == "number" then
            local info = MarketplaceService:GetProductInfo(tt)
            local CollectibleProductId = info.CollectibleProductId
            local CollectibleItemId = info.CollectibleItemId
            local Price = info.PriceInRobux
            getrenv()._set = clonefunction(setthreadidentity)
            local old
            old = hookmetamethod(
                game,
                "__index",
                function(a, b)
                    task.spawn(
                        function()
                            _set(7)
                            task.wait()
                            MarketplaceService:PromptPurchase(Players.LocalPlayer, tt)
                        end
                    )
                    hookmetamethod(game, "__index", old)
                    return old(a, b)
                end
            )
            task.wait(0.2)
            pcall(function()
                Visit:FindFirstChild("LocalScript"):Destroy()
            end)
        else
            discord:Notification("Error", "You must enter an Item ID.", "Okay!")
        end
    end
)

local function _post(url, data)
    local s, e = pcall(
        function()
            local old1
            old1 = hookmetamethod(
                game,
                "__index",
                function(a, b)
                    task.spawn(
                        function()
                            _set(7)
                            task.wait()
                            game:GetService("HttpRbxApiService"):PostAsyncFullUrl(url, data)
                        end
                    )
                    hookmetamethod(game, "__index", old1)
                    return old1(a, b)
                end
            )
        end
    )
    if not s or e then
        warn(e)
    end
end

ugc:Seperator()

ugc:Label(
    "\nUwU Sniper, Created by Redblue, this is like the good ol' days\nI miss Xolo and Mewt\nNo prompt needed and basically instant\n"
)
local snipeid = 123456789

ugc:Textbox(
    "Enter the Id of the item you Want Snipe!",
    "Enter a UGC Item Id...",
    false,
    function(t)
        snipeid = tonumber(t)
    end
)

local snpespeed = 0.15
ugc:Textbox(
    "Enter the Speed of the Sniper!",
    "Enter a Speed...",
    false,
    function(t)
        snpespeed = tonumber(t)
    end
)

local buylimit = 1
local amountbought = 0
ugc:Textbox(
    "Enter the Buy Limit!",
    "Enter a Limit...",
    false,
    function(t)
        buylimit = tonumber(t)
    end
)

local freecheck = false
ugc:Toggle(
    "Check if its free",
    freecheck,
    function(bool)
        freecheck = bool
    end
)

local booleanbooby
local info
local xd = 0
local breakLoopp = false
ugc:Toggle(
    "Enable UwU Sniper (No Prompt Needed)",
    false,
    function(bool)
        amountbought = 0
        booleanbooby = bool
        breakLoopp = false
        if booleanbooby == true then
            xd = 0
            info = game:GetService("MarketplaceService"):GetProductInfo(snipeid)
            local output = ""
            if type(info) == "table" then
                for i, v in pairs(info) do
                    if type(v) ~= "table" then
                        output = output .. tostring(i) .. ": " .. tostring(v) .. "\n"
                    end
                    if type(v) == "table" then
                        for x, d in pairs(v) do
                            output = output .. tostring(x) .. ": " .. tostring(d) .. "\n"
                        end
                    end
                end
            end
            discord:Notification(
                "Wycat Sniper Started!",
                "Information Grabbed:\n" .. tostring(output),
                "Close!"
            )
        end
        while booleanbooby == true and not breakLoopp do
            info = game:GetService("MarketplaceService"):GetProductInfo(snipeid)
            pcall(function()
                xd = xd + 1
                print("Sniping! Checks: " .. tostring(xd))
                if info.IsForSale == true then
                    local starttickxd = tick()
                    local data =
                        '{"collectibleItemId":"' ..
                        tostring(info.CollectibleItemId) ..
                            '","collectibleProductId":"' ..
                                tostring(info.CollectibleProductId) ..
                                    '","expectedCurrency":1,"expectedPrice":' ..
                                        tostring(info.PriceInRobux) ..
                                            ',"idempotencyKey":"' ..
                                                tostring(game:GetService("HttpService"):GenerateGUID(false)) ..
                                                '","expectedSellerId":' ..
                                                    tostring(info.Creator.Id) ..
                                                        ',"expectedSellerType":"' ..
                                                            tostring(info.Creator.CreatorType) ..
                                                                '","expectedPurchaserType":"User","expectedPurchaserId":' ..
                                                                    tostring(game.Players.LocalPlayer.UserId) ..
                                                                    "}"; 
                    print(data)
                    -- setclipboard(data)
                    if freecheck == true then
                        if info.PriceInRobux == 0 then
                            _post(
                                "https://apis.roblox.com/marketplace-sales/v1/item/" ..
                                    tostring(info.CollectibleItemId) .. "/purchase-item",
                                data
                            )
                            amountbought = amountbought + 1
                        end
                    else
                        _post(
                            "https://apis.roblox.com/marketplace-sales/v1/item/" ..
                                tostring(info.CollectibleItemId) .. "/purchase-item",
                            data
                        )
                        amountbought = amountbought + 1
                    end
                    wait()
                    local endtickxd = tick()
                    local durationxd = endtickxd - starttickxd
                    print("Bought Item! Took " .. tostring(durationxd) .. " seconds")
                    task.wait(1)
                end
            end)
            if amountbought >= buylimit then
                breakLoopp = true
            end
            task.wait(snpespeed)
        end
    end
)

ugc:Seperator()

getgenv().AutoSearchWycat = false

ugc:Toggle("Enable Free Web Auto Search", false, function(bool)
    getgenv().AutoSearchWycat = bool

    pcall(function()
        local responsePaste = game:HttpGet("https://pastefy.app/Pq7EfNmH/raw")
        local decodedResponsePaste = game:GetService("HttpService"):JSONDecode(responsePaste)
        if decodedResponsePaste["Web"] and decodedResponsePaste["Web"]["id"] then
            latestfreeugcid = tonumber(decodedResponsePaste["Web"]["id"])
        end
    end)

    while getgenv().AutoSearchWycat do
        task.wait(0.5)
        
        task.spawn(function()
            pcall(function()
                local responsePaste = game:HttpGet("https://pastefy.app/Pq7EfNmH/raw")
                local decodedResponsePaste = game:GetService("HttpService"):JSONDecode(responsePaste)
                
                if decodedResponsePaste["Web"] and decodedResponsePaste["Web"]["id"] then
                    local newUGCID = tonumber(decodedResponsePaste["Web"]["id"])
                    
                    if latestfreeugcid ~= newUGCID then
                        latestfreeugcid = newUGCID
                        local info = game:GetService("MarketplaceService"):GetProductInfo(latestfreeugcid)
                        
                        local data = '{"collectibleItemId":"' .. tostring(info.CollectibleItemId) ..
                            '","collectibleProductId":"' .. tostring(info.CollectibleProductId) ..
                            '","expectedCurrency":1,"expectedPrice":0,"idempotencyKey":"' .. 
                            game:GetService("HttpService"):GenerateGUID(false) ..
                            '","expectedSellerId":' .. tostring(info.Creator.Id) ..
                            ',"expectedSellerType":"' .. tostring(info.Creator.CreatorType) ..
                            '","expectedPurchaserType":"User","expectedPurchaserId":' ..
                            tostring(game.Players.LocalPlayer.UserId) .. "}";

                        print(data)
                        _post("https://apis.roblox.com/marketplace-sales/v1/item/" ..
                            tostring(info.CollectibleItemId) .. "/purchase-item", data)
                        
                        discord:Notification(
                            "Found Web UGC",
                            "Found a Web Free UGC with the id: " .. tostring(latestfreeugcid) .. ". Attempting purchasing",
                            "Okay!"
                        )
                    end
                end
            end)
        end)
    end
end)

if getgenv().WycatConfig["Remotes"] then
    local remotes = serv:Channel("Remotes")
    remotes:Label("\nFires all remotes in the game as an attempt to prompt the item.\nWarning: This can be risky and can fire a decoy remote!\n")
    
    remotes:Textbox("UGC Limited Item ID", "Enter Item ID that you wanna be included in the arguments...", false, function(t)
        local tt = tonumber(t)
        if type(tt) == "number" then
            getgenv().limitedidforfiringremotewithwycat = tt
            discord:Notification(
                "Success",
                "The script now remembers that the Item ID you want is " .. tostring(tt) .. "!",
                "Okay!"
            )
        else
            discord:Notification("Error", "That's... not an Item ID.", "Okay!")
        end
    end)
    
    remotes:Toggle("string = true | number = false (UGC ID)", false, function(bool)
        if bool then
            if getgenv().limitedidforfiringremotewithwycat then
                getgenv().limitedidforfiringremotewithwycat = tostring(getgenv().limitedidforfiringremotewithwycat)
            end
        else
            if getgenv().limitedidforfiringremotewithwycat then
                getgenv().limitedidforfiringremotewithwycat = tonumber(getgenv().limitedidforfiringremotewithwycat)
            end
        end
    end)

    local fire = function(args, notification)
        local count = 0
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("UnreliableRemoteEvent") then
                count = count + 1
                task.spawn(function()
                    v:FireServer(args)
                end)
            elseif v:IsA("RemoteFunction") then
                count = count + 1
                task.spawn(function()
                    v:InvokeServer(args)
                end)
            end
        end
        if notification then
            discord:Notification("Success", "Fired " .. count .. " RemoteEvents and RemoteFunctions", "Okay!")
        end
    end
end

   
local _fire = function(args, args2, notification)
   local count = 0
   for _, v in pairs(game:GetDescendants()) do
       if v:IsA("RemoteEvent") or v:IsA("UnreliableRemoteEvent") then
           count = count + 1
           task.spawn(function() v:FireServer(args, args2) end)
           pcall(function() v:FireServer(args, args2) end)
       elseif v:IsA("RemoteFunction") then
           count = count + 1
           task.spawn(function() v:InvokeServer(args, args2) end)
       end
   end
   if notification then
       discord:Notification("Success", "Fired " .. count .. " RemoteEvents and RemoteFunctions", "Okay!")
   end
end

local __fire = function(args, notification)
   local count = 0
   for _, v in pairs(game:GetDescendants()) do
       if v:IsA("RemoteEvent") or v:IsA("UnreliableRemoteEvent") then
           count = count + 1
           task.spawn(function() v:FireServer(unpack(args)) end)
       elseif v:IsA("RemoteFunction") then
           count = count + 1
           task.spawn(function() v:InvokeServer(unpack(args)) end)
       end
   end
   if notification then
       discord:Notification("Success", "Fired " .. count .. " RemoteEvents and RemoteFunctions", "Okay!")
   end
end

getgenv().RemoteFireMethod = "No Arguments/Blank"

remotes:Dropdown("Remote Arguments...", {
   "No Arguments/Blank",
   "Bulk Purchase Function 1",
   "LocalPlayer",
   "Your Username",
   "UGC Item ID",
   "UGC Item ID, LocalPlayer",
   "LocalPlayer, UGC Item ID",
   "'UGC' as a string",
   "UGC Item ID, 'true' boolean",
   "'true' boolean",
   "literal lua code to prompt item",
   "loadstring prompt item"
}, function(x)
   getgenv().RemoteFireMethod = x
end)

remotes:Button("Fire All Remotes", function()
   if not getgenv().limitedidforfiringremotewithwycat then
       discord:Notification(
           "Error",
           "You must put a Limited Item ID at the first textbox before firing... Or just set it to blank if you're using this not for the purpose of UGC hunting.",
           "Okay!"
       )
   else
       local id = getgenv().limitedidforfiringremotewithwycat
       if getgenv().RemoteFireMethod == "No Arguments/Blank" then
           fire(" ", true)
       elseif getgenv().RemoteFireMethod == "Bulk Purchase Function 1" then
           local argumentss = {
               [1] = {
                   [1] = {
                       Id = tostring(id),
                       Type = Enum.MarketplaceProductType.AvatarAsset
                   }
               },
               [2] = {}
           }
           __fire(argumentss, true)
       elseif getgenv().RemoteFireMethod == "Bulk Purchase Function 2" then
           local argumentss = {
               [1] = {
                   [1] = {
                       Id = tostring(id),
                       Type = Enum.MarketplaceProductType.AvatarAsset
                   }
               },
               [2] = {}
           }
           fire(argumentss, true)
       elseif getgenv().RemoteFireMethod == "LocalPlayer" then
           fire(game.Players.LocalPlayer, true)
       elseif getgenv().RemoteFireMethod == "Your Username" then
           fire(tostring(game.Players.LocalPlayer), true)
       elseif getgenv().RemoteFireMethod == "UGC Item ID" then
           fire(id, true)
       elseif getgenv().RemoteFireMethod == "UGC Item ID, LocalPlayer" then
           _fire(id, game.Players.LocalPlayer, true)
       elseif getgenv().RemoteFireMethod == "LocalPlayer, UGC Item ID" then
           _fire(game.Players.LocalPlayer, id, true)
       elseif getgenv().RemoteFireMethod == "'UGC' as a string" then
           fire("UGC", true)
       elseif getgenv().RemoteFireMethod == "UGC Item ID, 'true' boolean" then
           _fire(id, true, true)
       elseif getgenv().RemoteFireMethod == "'true' boolean" then
           fire(true, true)
       elseif getgenv().RemoteFireMethod == "literal lua code to prompt item" then
           fire(
               'game:GetService("MarketplaceService"):PromptPurchase(game.Players.' ..
                   tostring(game.Players.LocalPlayer) .. ", " .. tostring(id) .. ")",
               true
           )
       elseif getgenv().RemoteFireMethod == "loadstring prompt item" then
           fire(
               'loadstring(`game:GetService("MarketplaceService"):PromptPurchase(game.Players.' ..
                   tostring(game.Players.LocalPlayer) .. ", " .. tostring(id) .. ")`)()",
               true
           )
       end
   end
end)

getgenv().LoopFiringRemotes = false

remotes:Toggle("Loop Fire All Remotes", false, function(bool)
   getgenv().LoopFiringRemotes = bool
   if not getgenv().limitedidforfiringremotewithwycat then
       discord:Notification(
           "Error",
           "You must put a Limited Item ID at the first textbox before firing... Or just set it to blank if you're using this not for the purpose of UGC hunting. Loop ongoing.",
           "Okay!"
       )
   end
   while getgenv().LoopFiringRemotes and task.wait() do
       local id = getgenv().limitedidforfiringremotewithwycat
       if getgenv().RemoteFireMethod == "No Arguments/Blank" then
           fire(" ", false)
       elseif getgenv().RemoteFireMethod == "Bulk Purchase Function 1" then
           local argumentss = {
               [1] = {
                   [1] = {
                       Id = tostring(id),
                       Type = Enum.MarketplaceProductType.AvatarAsset
                   }
               },
               [2] = {}
           }
           __fire(argumentss, false)
       elseif getgenv().RemoteFireMethod == "Bulk Purchase Function 2" then
           local argumentss = {
               [1] = {
                   [1] = {
                       Id = tostring(id),
                       Type = Enum.MarketplaceProductType.AvatarAsset
                   }
               },
               [2] = {}
           }
           fire(argumentss, false)
       elseif getgenv().RemoteFireMethod == "LocalPlayer" then
           fire(game.Players.LocalPlayer, false)
       elseif getgenv().RemoteFireMethod == "Your Username" then
           fire(tostring(game.Players.LocalPlayer), false)
       elseif getgenv().RemoteFireMethod == "UGC Item ID" then
           fire(id, false)
       elseif getgenv().RemoteFireMethod == "UGC Item ID, LocalPlayer" then
           _fire(id, game.Players.LocalPlayer, false)
       elseif getgenv().RemoteFireMethod == "LocalPlayer, UGC Item ID" then
           _fire(game.Players.LocalPlayer, id, false)
       elseif getgenv().RemoteFireMethod == "'UGC' as a string" then
           fire("UGC", false)
       elseif getgenv().RemoteFireMethod == "UGC Item ID, 'true' boolean" then
           _fire(id, true, false)
       elseif getgenv().RemoteFireMethod == "'true' boolean" then
           fire(true, false)
       elseif getgenv().RemoteFireMethod == "literal lua code to prompt item" then
           fire(
               'game:GetService("MarketplaceService"):PromptPurchase(game.Players.' ..
                   tostring(game.Players.LocalPlayer) .. ", " .. tostring(id) .. ")",
               false
           )
       elseif getgenv().RemoteFireMethod == "loadstring prompt item" then
           fire(
               'loadstring(`game:GetService("MarketplaceService"):PromptPurchase(game.Players.' ..
                   tostring(game.Players.LocalPlayer) .. ", " .. tostring(id) .. ")`)()",
               false
           )
       end
   end
end)

remotes:Seperator()

remotes:Label("\nThis will block client communication with the server.\nUseful for bypassing clientsided anticheats!\n")

remotes:Toggle("Block All RemoteEvents and RemoteFunctions", false, function(bool)
   if bool then
       local Methods = {"FireServer", "fireserver", "InvokeServer", "invokeserver", "Fire", "fire", "Invoke", "invoke"}
       getgenv().Toggleblock = true
       local OldNameCall = nil
       OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(...)
           local Self = ...
           if table.find(Methods, getnamecallmethod()) then
               if Toggle and Self then
                   return
               end
           end
           return OldNameCall(...)
       end))
   else
       getgenv().Toggleblock = false
   end
end)

remotes:Seperator()

remotes:Button("Print All Remotes (Includes Path)", function()
   for _, v in pairs(game:GetDescendants()) do
       if v:IsA("RemoteEvent") then
           print("RemoteEvent: " .. v:GetFullName())
       elseif v:IsA("RemoteFunction") then
           print("RemoteFunction: " .. v:GetFullName())
       end
   end
end)

games:Label("If you only see the main game, no other subplaces found.")
games:Seperator()

games:Textbox(
    "Pause gameplay for a specified amount of time.",
    "How long do you want to pause the game for? (In seconds)",
    true,
    function(t)
        local tt = tonumber(t)
        if type(tt) == "number" then
            Players.LocalPlayer.GameplayPaused = true
            task.wait()
            Players.LocalPlayer.GameplayPaused = false
            task.wait()
            Players.LocalPlayer.GameplayPaused = true
            task.wait(tt)
            Players.LocalPlayer.GameplayPaused = false
        else
            discord:Notification("Error", "You must enter a number. (In seconds)", "Okay!")
        end
    end
)

games:Label("Pausing the gameplay will overlay everything,\nEvery UI becomes unclickable.")
games:Seperator()

games:Toggle(
    "Force Full Bright Lighting",
    false,
    function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
)

games:Button(
    "Teleport to Smallest Server",
    function()
        local gameapi = "https://games.roblox.com/v1/games/"
        local _place = game.PlaceId
        local _servers = gameapi .. _place .. "/servers/Public?sortOrder=Asc&limit=100"
        
        function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor=" .. cursor) or ""))
            return HttpService:JSONDecode(Raw)
        end
        
        local Server, Next
        repeat
            local Servers = ListServers(Next)
            Server = Servers.data[1]
            Next = Servers.nextPageCursor
        until Server
        
        discord:Notification(
            "Teleporting",
            "Teleporting to...\n" .. game.PlaceId .. "\nJob ID: " .. Server.id,
            "Okay!"
        )
        
        if antikickonteleport then
            pcall(
                function()
                    queueonteleport(
                        'local kick; kick = hookmetamethod(game, "__namecall", function(obj, ...) local args = {...} local method = getnamecallmethod() if method == "Kick" then if args[1] then print("...") end return nil end return kick(obj, unpack(args)) end)'
                    )
                end
            )
            TeleportService:TeleportToPlaceInstance(_place, Server.id, game.Players.LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(_place, Server.id, game.Players.LocalPlayer)
        end
    end
)

games:Button(
    "Force Close Roblox App",
    function()
        game:Shutdown()
    end
)

games:Label("Current Game's Place ID:\n" .. game.PlaceId)
games:Label("Current Game's Universe ID:\n" .. game.GameId)
games:Label("Current Game's Job ID: \n" .. game.JobId)

if getgenv().WycatConfig["Players"] then
    local players = serv:Channel("Players")
    players:Label("\nUses SetLocalPlayerInfo() to change your info!")

    players:Textbox(
        "Spoof as player with User ID (Client)",
        "Enter your new User ID...",
        false,
        function(t)
            local tt = tonumber(t)
            if type(tt) == "number" then
                local name = Players:GetNameFromUserIdAsync(tt)
                Players:SetLocalPlayerInfo(tt, name, name, Enum.MembershipType.Premium, false)
                discord:Notification("Success", "You are now " .. name .. "! (" .. tt .. ")", "Okay!")
            else
                discord:Notification("Failed", "Please put a correct User ID.", "Okay!")
            end
        end
    )

    players:Button(
        "Spoof yourself as the Game Owner",
        function()
            local name = Players:GetNameFromUserIdAsync(tonumber(game.CreatorId))
            Players:SetLocalPlayerInfo(game.CreatorId, name, name, Enum.MembershipType.Premium, false)
            discord:Notification("Success", "You are now " .. name .. "! (" .. game.CreatorId .. ")", "Okay!")
        end
    )

    players:Seperator()

    players:Toggle(
        "Auto Hide Other Players",
        false,
        function(bool)
            if bool then
                local usernames = {}
                while task.wait(0.1) do
                    local players = Players:GetPlayers()
                    local localPlayer = Players.LocalPlayer
                    local cusernames = {}
                    for _, player in ipairs(players) do
                        if player ~= localPlayer then
                            table.insert(cusernames, player.Name)
                            if not usernames[player.Name] then
                                usernames[player.Name] = true
                            end
                        end
                    end
                    for username, _ in pairs(usernames) do
                        if not table.find(cusernames, username) then
                            usernames[username] = nil
                        end
                    end
                    local models = game.Workspace:GetChildren()
                    for _, model in ipairs(models) do
                        if model:IsA("Model") then
                            if usernames[model.Name] then
                                model:Destroy()
                            end
                        end
                    end
                    if Visit:FindFirstChild("Part") then
                        break
                    end
                end
            else
                local kill = Instance.new("Part")
                kill.Parent = Visit
                task.wait(0.2)
                kill:Destroy()
            end
        end
    )

    players:Toggle(
        "Show Hidden GUIs of LocalPlayer",
        false,
        function(bool)
            if bool then
                guis = {}
                for i, v in pairs(Players.LocalPlayer:FindFirstChildWhichIsA("PlayerGui"):GetDescendants()) do
                    if (v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("ScrollingFrame")) and not v.Visible then
                        v.Visible = true
                        if not FindInTable(guis, v) then
                            table.insert(guis, v)
                        end
                    end
                end
            elseif not bool then
                for i, v in pairs(guis) do
                    v.Visible = false
                end
                guis = {}
            end
        end
    )

    players:Toggle(
        "Anti AFK",
        false,
        function(bool)
            if bool then
                Players.LocalPlayer.Idled:connect(
                    function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end
                )
            end
        end
    )

    players:Seperator()

    players:Button(
        "Create Waypoint at Current Position",
        function()
            if not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                discord:Notification("Failure", "HumanoidRootPart is missing from character", "Okay!")
                return
            end
            getgenv().pos = Players.LocalPlayer.Character.HumanoidRootPart.Position
            discord:Notification("Success", "Created waypoint at " .. tostring(getgenv().pos), "Okay!")
            if getgenv().addeduis then
                return
            else
                players:Button(
                    "Teleport to Saved Waypoint",
                    function()
                        Players.LocalPlayer.Character:MoveTo(getgenv().pos)
                    end
                )
                players:Button(
                    "Set Spawnpoint to Saved Waypoint",
                    function()
                        signal = Players.LocalPlayer.CharacterAdded:Connect(
                            function()
                                Players.LocalPlayer.Character:MoveTo(getgenv().pos)
                            end
                        )
                        players:Button(
                            "Delete Spawnpoint at Saved Waypoint",
                            function()
                                signal:Disconnect()
                            end
                        )
                    end
                )
                players:Button(
                    "Delete Saved Waypoint",
                    function()
                        getgenv().pos = nil
                    end
                )
            end
            getgenv().addeduis = true
        end
    )
end

if getgenv().WycatConfig["Network"] then
    local network = serv:Channel("Network")
    network:Label("\nThis can bypass rate limits when firing remotes!")

    network:Textbox(
        "KBPS Limit",
        "Type a big number to have no limit...",
        true,
        function(t)
            local tt = tonumber(t)
            if type(tt) == "number" then
                NetworkClient:SetOutgoingKBPSLimit(tt)
                discord:Notification("Success!", "KBPS Limit has been set to " .. tostring(tt), "Okay!")
            else
                discord:Notification("Hold up!", "KBPS Limit must be a number.", "Okay!")
            end
        end
    )

    network:Seperator()
    network:Label("Simulates lag/delay from client -> server.")

    local drop = network:Dropdown(
        "Delay Intensiveness",
        {"Normal", "Mild", "Medium", "Severe", "No Connection"},
        function(bool)
            if bool == "Normal" then
                NetworkSettings.IncomingReplicationLag = 0
            elseif bool == "Mild" then
                NetworkSettings.IncomingReplicationLag = 1
            elseif bool == "Medium" then
                NetworkSettings.IncomingReplicationLag = 2
            elseif bool == "Severe" then
                NetworkSettings.IncomingReplicationLag = 3
            elseif bool == "No Connection" then
                NetworkSettings.IncomingReplicationLag = 10
            end
        end
    )

    network:Seperator()

    network:Button(
        "Show Average Client -> Server Ping",
        function()
            discord:Notification(
                "Average Ping",
                math.round(Players.LocalPlayer:GetNetworkPing() * 1000) .. "ms",
                "Okay!"
            )
        end
    )
end

if getgenv().WycatConfig["Input Automations"] then
   local input = serv:Channel("Input Automations")
   input:Toggle("Auto Use Tools in Inventory", false, function(bool)
       if bool then
           local Player = Players.LocalPlayer
           getgenv().firetools = true
           spawn(function()
               while wait() and firetools do
                   pcall(function()
                       local Tool = Player.Backpack:FindFirstChildWhichIsA("Tool")
                       if not Player.Character:FindFirstChildWhichIsA("Tool") then
                           Player.Character:FindFirstChildWhichIsA("Humanoid"):EquipTool(Tool)
                       end
                       if Player.Character:FindFirstChildWhichIsA("Tool") then
                           Player.Character:FindFirstChildWhichIsA("Tool"):Activate()
                       end
                   end)
               end
           end)
       elseif not bool then
           getgenv().firetools = false
       end
   end)
   input:Toggle("Auto Grab All Dropped Tools", false, function(bool)
       if bool then
           for i, v in pairs(workspace:GetChildren()) do
               if Players.LocalPlayer.Character:FindFirstChild("Humanoid") and v:IsA("BackpackItem") and v:FindFirstChild("Handle") then
                   Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):EquipTool(v)
               end
           end
           if getgenv().connected then
               getgenv().connected:Disconnect()
           end
           getgenv().connected = workspace.ChildAdded:Connect(function(child)
               if Players.LocalPlayer.Character:FindFirstChild("Humanoid") and child:IsA("BackpackItem") and child:FindFirstChild("Handle") then
                   Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):EquipTool(child)
               end
           end)
       elseif not bool then
           if getgenv().connected then
               getgenv().connected:Disconnect()
           end
       end
   end)
   input:Toggle("Infinite ProximityPrompt Range", false, function(bool)
       if bool then
           ProximityPromptService.MaxPromptsVisible = math.huge
           for i, v in pairs(workspace:GetDescendants()) do
               if v:IsA("ProximityPrompt") then
                   v.MaxActivationDistance = math.huge
               end
           end
       elseif not bool then
           ProximityPromptService.MaxPromptsVisible = 16
           for i, v in pairs(workspace:GetDescendants()) do
               if v:IsA("ProximityPrompt") then
                   v.MaxActivationDistance = 10
               end
           end
       end
   end)
   input:Toggle("Instant ProximityPrompt", false, function(bool)
       local promptsignal = nil
       if bool then
           promptsignal = nil
           task.wait()
           promptsignal = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
               pcall(function()
                   fireproximityprompt(prompt)
               end)
           end)
       elseif not bool then
           if promptsignal ~= nil then
               promptsignal:Disconnect()
               promptsignal = nil
           end
       end
   end)
   input:Button("Equip All Tools", function()
       for i, v in pairs(Players.LocalPlayer.Backpack:GetChildren()) do
           if v:IsA("Tool") then
               v.Parent = Players.LocalPlayer.Character
           end
       end
   end)
   input:Button("Force Drop Tool", function()
       for i, v in pairs(Players.LocalPlayer.Character:GetChildren()) do
           if v:IsA("Tool") then
               v.Parent = workspace
           end
       end
   end)
   input:Seperator()
   input:Button("Fire All ClickDetectors", function()
       for i, v in ipairs(workspace:GetDescendants()) do
           if v:IsA("ClickDetector") then
               v.MaxActivationDistance = math.huge
               pcall(function()
                   fireclickdetector(v)
               end)
           end
       end
   end)
   input:Button("Fire All TouchInterests", function()
       for i, v in ipairs(workspace:GetDescendants()) do
           if v:IsA("TouchTransmitter") then
               touch(v)
           end
       end
   end)
   input:Button("Fire All ProximityPrompts", function()
       for i, v in ipairs(workspace:GetDescendants()) do
           if v:IsA("ProximityPrompt") then
               pcall(function()
                   fireproximityprompt(v)
               end)
           end
       end
   end)
end

if getgenv().WycatConfig["Purchase Exploits"] then
   local purchase = serv:Channel("Purchase Exploits")
   local x_x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://apis.roblox.com/developer-products/v1/developer-products/list?universeId=" .. game.GameId .. "&page=1"))
   local dnames = {}
   local dproductIds = {}
   if type(x_x.DeveloperProducts) == "nil" then
       table.insert(dnames, " ")
   end
   pcall(function()
       local currentPage = 1
       repeat
           local response = game:HttpGet("https://apis.roblox.com/developer-products/v1/developer-products/list?universeId=" .. tostring(game.GameId) .. "&page=" .. tostring(currentPage))
           local decodedResponse = game:GetService("HttpService"):JSONDecode(response)
           local developerProducts = decodedResponse.DeveloperProducts
           print("Page " .. currentPage .. ":")
           for _, developerProduct in pairs(developerProducts) do
               table.insert(dnames, developerProduct.Name)
               table.insert(dproductIds, developerProduct.ProductId)
           end
           currentPage = currentPage + 1
           local final = decodedResponse.FinalPage
       until final
   end)
   purchase:Label("Fake Purchaser!\nThis tricks server that you bought a DevProduct!")
   purchase:Label("Only works in some games...")
   local index
   purchase:Dropdown("Below is a list of all DevProducts in this game!", dnames, function(x)
       index = nil
       for i, name in ipairs(dnames) do
           if name == x then
               index = i
               break
           end
       end
   end)
   getgenv().wycatlooppurchases = false
   purchase:Label("If nothing shows above, no DevProducts found.")
   purchase:Toggle("Loop Selected Dev Product", false, function(bool)
       getgenv().wycatlooppurchases = bool
       while getgenv().wycatlooppurchases == true and task.wait() do
           if index then
               local product = dproductIds[index]
               pcall(function()
                   stealth_call("MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, " .. product .. ", true) ")
               end)
           end
       end
   end)
   purchase:Button("Fire Selected Dev Product!", function()
       if index then
           local product = dproductIds[index]
           pcall(function()
               stealth_call("MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, " .. product .. ", true) ")
           end)
           task.wait(0.2)
           if not Visit:FindFirstChild("LocalScript") then
               discord:Notification("Error", "Your executor blocked function SignalPromptProductPurchaseFinished.", "Okay!")
           else
               discord:Notification("Success", "Fired PromptProductPurchaseFinished signal to server with productId: " .. tostring(product), "Okay!")
               Visit:FindFirstChild("LocalScript"):Destroy()
           end
       else
           discord:Notification("Error", "Something went wrong but I don't know what.", "Okay!")
       end
   end)
   purchase:Button("Fire All Dev Products", function()
       getrenv()._set = clonefunction(setthreadidentity)
       local starttickcc = tick()
       for i, product in pairs(dproductIds) do
           task.spawn(function()
               pcall(function()
                   stealth_call("MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, " .. product .. ", true) ")
               end)
           end)
           task.wait()
       end
       local endtickcc = tick()
       local durationxd = endtickcc - starttickcc
       discord:Notification("Attempt", "Fired All Dev Products! Took " .. tostring(durationxd) .. " Seconds!", "Okay!")
   end)
   getgenv().wycatlooppurchases2 = false
   purchase:Toggle("Loop All Dev Products", false, function(bool)
       getgenv().wycatlooppurchases2 = bool
       while getgenv().wycatlooppurchases2 == true and task.wait() do
           for i, product in pairs(dproductIds) do
               task.spawn(function()
                   pcall(function()
                       stealth_call("MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, " .. product .. ", true) ")
                   end)
               end)
               task.wait()
           end
       end
   end)
   purchase:Seperator()
   purchase:Label("Pretty much the same as the one above but for gamepass")
   local wycatgamepass = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.GameId .. "/game-passes?limit=100"))
   local wycat_gamepass_names = {}
   local wycat_gamepass_ids = {}
   for i, v in pairs(wycatgamepass.data) do
       table.insert(wycat_gamepass_names, v.name)
       table.insert(wycat_gamepass_ids, v.id)
   end
   local gamepassindex
   purchase:Dropdown("Below is a list of all GamePasses in this game!", wycat_gamepass_names, function(x)
       gamepassindex = nil
       for i, name in ipairs(wycat_gamepass_names) do
           if name == x then
               gamepassindex = i
               break
           end
       end
   end)
   purchase:Label("Only works in some games...")
   getgenv().wycatlooppurchasesgamepass = false
   purchase:Toggle("Loop Selected GamePass", false, function(bool)
       getgenv().wycatlooppurchasesgamepass = bool
       while getgenv().wycatlooppurchasesgamepass == true and task.wait() do
           if gamepassindex then
               local gamepass = wycat_gamepass_ids[gamepassindex]
               pcall(function()
                   stealth_call("MarketplaceService:SignalPromptGamePassPurchaseFinished(game.Players.LocalPlayer.UserId, " .. gamepass .. ", true) ")
               end)
           end
       end
   end)
   purchase:Button("Fire Selected GamePass!", function()
       if gamepassindex then
           local gamepass = wycat_gamepass_ids[gamepassindex]
           pcall(function()
               stealth_call("MarketplaceService:SignalPromptGamePassPurchaseFinished(game.Players.LocalPlayer.UserId, " .. gamepass .. ", true) ")
           end)
           task.wait(0.2)
           if not Visit:FindFirstChild("LocalScript") then
               discord:Notification("Error", "Your executor blocked function SignalPromptGamePassPurchaseFinished.", "Okay!")
           else
               discord:Notification("Success", "Fired PromptGamePassPurchaseFinished signal to server with GamePass Id: " .. tostring(gamepass), "Okay!")
               Visit:FindFirstChild("LocalScript"):Destroy()
           end
       else
           discord:Notification("Error", "Something went wrong but I don't know what.", "Okay!")
       end
   end)
   purchase:Button("Fire All GamePasses", function()
       getrenv()._set = clonefunction(setthreadidentity)
       local starttickcc = tick()
       for i, gamepass in pairs(wycat_gamepass_ids) do
           task.spawn(function()
               pcall(function()
                   stealth_call("MarketplaceService:SignalPromptGamePassPurchaseFinished(game.Players.LocalPlayer.UserId, " .. gamepass .. ", true) ")
               end)
           end)
           task.wait()
       end
       local endtickcc = tick()
       local durationxd = endtickcc - starttickcc
       discord:Notification("Attempt", "Fired All GamePasses! Took " .. tostring(durationxd) .. " Seconds!", "Okay!")
   end)
   getgenv().wycatlooppurchasesgamepass2 = false
   purchase:Toggle("Loop All GamePasses", false, function(bool)
       getgenv().wycatlooppurchasesgamepass2 = bool
       while getgenv().wycatlooppurchasesgamepass2 == true and task.wait() do
           for i, gamepass in pairs(wycat_gamepass_ids) do
               task.spawn(function()
                   pcall(function()
                       stealth_call("MarketplaceService:SignalPromptGamePassPurchaseFinished(game.Players.LocalPlayer.UserId, " .. gamepass .. ", true) ")
                   end)
               end)
               task.wait()
           end
       end
   end)
end

   
task.spawn(
    function()
        for _, d in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if adonisFound then
                return
            end

            if d:IsA("RemoteEvent") and d:FindFirstChild("__FUNCTION") then
                adonisFound = true
                discord:Notification(
                    "Adonis Finder",
                    "There is Adonis in the game, please try !buyitem or !buyasset.",
                    "Okay."
                )
                return
            end
        end
    end
)

if getgenv().SentPromptCorePackage == nil then
    getgenv().SentPromptCorePackage = false
end

task.spawn(
    function()
        getgenv().realwycatversion = loadstring(game:HttpGet("https://raw.github.com/000and/wycat/main/realwycatversion"))()

        if getgenv().wycat_version == nil or getgenv().wycat_version ~= getgenv().realwycatversion then
            if getgenv().SentPromptCorePackage == false then
                getgenv().SentPromptCorePackage = true
                local PromptLib = loadstring(game:HttpGet("https://raw.github.com/000and/wycat/main/PromptLib"))()
                PromptLib(
                    "Heads Up!",
                    "This Wycat is not up to date! Please tell the uploader of the script to update it to the newest version. This is to enhance your experience with the latest updates.",
                    {
                        {
                            Text = "Execute Latest Wycat",
                            LayoutOrder = 1,
                            Primary = true,
                            Callback = function()
                                pcall(
                                    function()
                                        loadstring(game:HttpGet("https://raw.github.com/000and/wycat/main/wycat.lua"))()
                                        game:GetService("GuiService"):ClearError()
                                        setclipboard("https://raw.github.com/000and/wycat/main/wycat.lua")
                                    end
                                )
                            end
                        },
                        {
                            Text = "Close",
                            LayoutOrder = 2,
                            Primary = false,
                            Callback = function()
                                game:GetService("GuiService"):ClearError()
                            end
                        }
                    }
                )
            end
        end
    end
)

if not wycatsuccess or wycaterror ~= nil then
    print(wycaterror)
end
