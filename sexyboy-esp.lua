-- SEXYBOY UNIVERSAL v3.0

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Config = {
	Language = "EN",
	EnableESP = false,
	PlayerESP = false,
	ESP_V2 = false,
	ESPV3 = false,
	EnemyESP = false,
	TeamESP = false,
	NPCESP = false,
	PlayerHitbox = false,
	Aimbot = false,
	AimbotV2 = false,
	AimbotTeamCheck = false,
	AimbotVisibleCheck = false,
	AimbotTarget = "Head",
	
	-- Triggerbot Config
	Triggerbot = false,
	TriggerbotDelay = 0.05,
	TriggerbotFOV = 120,
	UnknownTargetMode = "Enemy", -- "Enemy" o "Skip"
	
	ESPRange = 300,
	HitboxSize = 6,
	Transparency = 0.5,
	AimbotFOV = 120,
	AimbotSmooth = 0.15,
	ESPColor = Color3.fromRGB(240, 70, 70),

	-- NUEVAS CONFIGURACIONES AGREGADAS
	Noclip = false,
	WalkSpeed = 16,
	JumpPower = 50,
	FOVColor = Color3.fromRGB(137, 78, 235),
	RainbowESP = false,
	RainbowFOV = false
}

local Translations = {
	EN = {
		TabHome = "Features", TabSettings = "Settings",
		SecESP = "VISUALS (ESP)", EnableESP = "Enable ESP", EnableESP_D = "Master switch for visual elements",
		ESP_V2 = "ESP V2 (Undetectable)", ESP_V2_D = "Undetectable ESP for strict Anti-Cheats (Bypasses Kicks, ideal for Sheriffs vs Asesinos)",
		ESP_V3 = "ESP V3 (Undetectable)", ESP_V3_D = "Undetectable ESP for games with advanced AC",
		PlayerESP = "Player ESP", PlayerESP_D = "Highlight all nearby players",
		EnemyESP = "Enemy ESP", EnemyESP_D = "Highlight only enemy players",
		TeamESP = "Team ESP", TeamESP_D = "Highlight teammate players",
		NPCESP = "NPC / Bot ESP", NPCESP_D = "Highlight non-player entities",
		PlayerHitbox = "Hitbox Expander", PlayerHitbox_D = "Enlarge player hitboxes for easy targets",
		
		SecAimbot = "AIM ASSIST & COMBAT", Aimbot = "Enable Aimbot (Normal)", Aimbot_D = "Classic smooth mouse aimbot",
		AimbotV2 = "Aimbot V2 (3rd Person)", AimbotV2_D = "Locks Camera AND rotates your character's body",
		Triggerbot = "Triggerbot", Triggerbot_D = "Automatically shoots when cursor is over an enemy",
		TeamCheck = "Advanced Team Check", TeamCheck_D = "Universal team detection (Attributes, Values & Tags)",
		UnknownMode = "Unknown Targets", UnknownMode_D = "How to treat players with unidentified teams",
		VisibleCheck = "Visible Check", VisibleCheck_D = "Target only visible players behind walls",
		TargetPart = "Target Part", TargetPart_D = "Select body part to aim at",

		-- Traducciones Modificadores y Movimiento
		SecMovement = "PLAYER MOVEMENT", Noclip = "Noclip", Noclip_D = "Walk through walls and obstacles",
		Speed = "WalkSpeed", Speed_D = "Modify character walk speed",
		Jump = "Jump Power", Jump_D = "Modify jump height",
		RainbowESP = "Rainbow ESP", RainbowESP_D = "Cycle colors dynamically for ESP",
		RainbowFOV = "Rainbow FOV", RainbowFOV_D = "Cycle colors dynamically for FOV circle",
		FOVColorRow = "FOV Circle Color", FOVColorRow_D = "Select color for Aimbot FOV",
		
		SecSettings = "GENERAL SETTINGS", Distance = "ESP Distance", Distance_D = "Maximum rendering range for ESP",
		HitSize = "Hitbox Size", HitSize_D = "Expansion size of hitboxes (Max 50)",
		Transp = "Transparency", Transp_D = "Opacity of the ESP highlight",
		FOVSize = "FOV Circle Size", FOVSize_D = "Aimbot detection radius",
		TrigDelay = "Triggerbot Delay (ms)", TrigDelay_D = "Delay before firing when target is hovered",
		Smooth = "Aimbot Smoothness", Smooth_D = "Lower is faster, higher is smoother",
		ColorRow = "Highlight Color", LangRow = "Language", LangRow_D = "Switch interface language",
		
		NoticeTitle = "IMPORTANT NOTICE",
		NoticeMsg = "Attention: ESP and Hitbox options are BANNEABLE in this game. For safe use, use UNDETECTABLE features: Aimbot and ESP V2.",
		AcceptBtn = "Understand & Accept"
	},
	ES = {
		TabHome = "Features", TabSettings = "Settings",
		SecESP = "VISUALS (ESP)", EnableESP = "Enable ESP", EnableESP_D = "El botón principal para poder ver a los demás a través de las paredes",
		ESP_V2 = "ESP V2 (Undetected)", ESP_V2_D = "ESP Indetectable para juegos con anti-cheat (Especialmente Sheriffs vs Asesinos)",
		ESP_V3 = "ESP V3 (Indetectable)", ESP_V3_D = "ESP Indetectable para juegos con AC Avanzado",
		PlayerESP = "Player ESP", PlayerESP_D = "Muestra una luz alrededor de todas las personas que están cerca",
		EnemyESP = "Enemy ESP", EnemyESP_D = "Muestra luces solo en los jugadores del equipo contrario",
		TeamESP = "Team ESP", TeamESP_D = "Muestra luces solo en tus compañeros de equipo",
		NPCESP = "NPC / Bot ESP", NPCESP_D = "Muestra luces en los personajes creados por el juego",
		PlayerHitbox = "Hitbox Expander", PlayerHitbox_D = "Hace a los enemigos tan grandes que es imposible fallarles",
		
		SecAimbot = "AIM ASSIST & COMBAT", Aimbot = "Enable Aimbot (Normal)", Aimbot_D = "La cámara se mueve suavemente para apuntarle al enemigo",
		AimbotV2 = "Aimbot V2 (3rd Person)", AimbotV2_D = "Apunta la cámara y también gira a tu personaje para no fallar",
		Triggerbot = "Triggerbot", Triggerbot_D = "Dispara automáticamente al poner la mira sobre un enemigo",
		TeamCheck = "Team Check Avanzado", TeamCheck_D = "Detección universal de equipos (Atributos, Valores y Tags)",
		UnknownMode = "Objetivos Desconocidos", UnknownMode_D = "Tratamiento para jugadores sin equipo identificado",
		VisibleCheck = "Visible Check", VisibleCheck_D = "Solo les apunta si no están escondidos detrás de una pared",
		TargetPart = "Target Part", TargetPart_D = "Elige si quieres apuntar a la cabeza o al cuerpo",

		-- Traducciones Modificadores y Movimiento
		SecMovement = "MOVIMIENTO Y EFECTOS", Noclip = "Noclip", Noclip_D = "Atraviesa paredes y estructuras",
		Speed = "Velocidad", Speed_D = "Aumenta o disminuye tu velocidad de movimiento",
		Jump = "Fuerza de Salto", Jump_D = "Aumenta la altura de tus saltos",
		RainbowESP = "ESP Rainbow", RainbowESP_D = "Color de ESP animado estilo arcoíris",
		RainbowFOV = "FOV Rainbow", RainbowFOV_D = "Color de FOV animado estilo arcoíris",
		FOVColorRow = "Color del FOV", FOVColorRow_D = "Selecciona el color para el círculo del FOV",
		
		SecSettings = "GENERAL SETTINGS", Distance = "ESP Distance", Distance_D = "Elige desde qué distancia puedes ver las luces de los demás",
		HitSize = "Hitbox Size", HitSize_D = "Cambia el tamaño del cuerpo de los enemigos (hasta 50)",
		Transp = "Transparency", Transp_D = "Cambia qué tan fuerte o suave se ven los colores",
		FOVSize = "FOV Circle Size", FOVSize_D = "Todo lo que entre adentro de este círculo será tu objetivo",
		TrigDelay = "Triggerbot Delay", TrigDelay_D = "Tiempo de espera antes de disparar",
		Smooth = "Aimbot Smoothness", Smooth_D = "Si pones 0 es súper rápido, si aumentas es más suave",
		ColorRow = "Highlight Color", LangRow = "Language", LangRow_D = "Cambia el idioma del menú",
		
		NoticeTitle = "AVISO IMPORTANTE",
		NoticeMsg = "Atención: Funciones como ESP normal y Hitbox son BANEABLES en este juego. Las únicas funciones 100% INDETECTABLES son Aimbot y ESP V2.",
		AcceptBtn = "Entendido y Aceptar"
	},
	PT = {
		TabHome = "Funcoes", TabSettings = "Ajustes",
		SecESP = "VISUAIS (ESP)", EnableESP = "Ativar ESP", EnableESP_D = "Liga ou desliga o sistema visual",
		ESP_V2 = "ESP V2 (Indetectavel)", ESP_V2_D = "ESP Indetectável para jogos com anti-cheat (Ideal para Sheriffs vs Asesinos)",
		ESP_V3 = "ESP V3 (Indetectavel)", ESP_V3_D = "ESP indetectável para jogos com AC avançado.",
		PlayerESP = "Ver Jogadores", PlayerESP_D = "Destaca todos os jogadores proximos",
		EnemyESP = "Ver Inimigos", EnemyESP_D = "Destaca apenas os inimigos",
		TeamESP = "Ver Aliados", TeamESP_D = "Destaca os companheiros",
		NPCESP = "Ver NPCs / Bots", NPCESP_D = "Destaca personagens do jogo",
		PlayerHitbox = "Aumentar Hitbox", PlayerHitbox_D = "Aumenta o corpo do inimigo",
		
		SecAimbot = "MIRA AUTOMATICA & COMBATE", Aimbot = "Aimbot Normal", Aimbot_D = "Mira suave e tradicional de mouse",
		AimbotV2 = "Aimbot V2 (3 Persona)", AimbotV2_D = "Mira camera E gira o corpo do personagem",
		Triggerbot = "Triggerbot", Triggerbot_D = "Dispara automaticamente ao colocar a mira em um inimigo",
		TeamCheck = "Ignorar Aliados Avancado", TeamCheck_D = "Detecção universal de equipes",
		UnknownMode = "Alvos Desconhecidos", UnknownMode_D = "Como tratar jogadores com equipes desconhecidas",
		VisibleCheck = "Verificar Visibilidade", VisibleCheck_D = "Apenas mira se estiver visivel",
		TargetPart = "Alvo da Mira", TargetPart_D = "Parte do corpo para mirar",

		-- Traducciones Modificadores y Movimiento
		SecMovement = "MOVIMENTO DO JOGADOR", Noclip = "Noclip", Noclip_D = "Atravesse paredes e objetos",
		Speed = "Velocidade", Speed_D = "Modifique a velocidade do personagem",
		Jump = "Força do Pulo", Jump_D = "Modifique a altura do pulo",
		RainbowESP = "ESP Rainbow", RainbowESP_D = "Efeito arco-íris dinâmico para ESP",
		RainbowFOV = "FOV Rainbow", RainbowFOV_D = "Efeito arco-íris dinâmico para o FOV",
		FOVColorRow = "Cor do FOV", FOVColorRow_D = "Escolha a cor do círculo do FOV",
		
		SecSettings = "CONFIGURACOES", Distance = "Distancia Visivel", Distance_D = "Alcance maximo do ESP",
		HitSize = "Tamanho da Hitbox", HitSize_D = "Tamanho da caixa (Max 50)",
		Transp = "Transparencia", Transp_D = "Opacidade do destaque",
		FOVSize = "Tamanho do Circulo FOV", FOVSize_D = "Raio de busca do Aimbot",
		TrigDelay = "Atraso do Triggerbot", TrigDelay_D = "Atraso antes de disparar",
		Smooth = "Suavidade da Mira", Smooth_D = "0 e rapido, 100 e suave",
		ColorRow = "Cor do Destaque", LangRow = "Idioma", LangRow_D = "Alterar idioma",
		
		NoticeTitle = "AVISO IMPORTANTE",
		NoticeMsg = "Atenção: Funções como ESP normal e Hitbox são BANÍVEIS neste jogo. Para segurança total, use as funções INDETECTÁVEIS: Aimbot e ESP V2.",
		AcceptBtn = "Entendido e Aceitar"
	}
}

local UI_Elements = {}
local savedHRP = {}
local currentTargetPart = nil

----------------------------------------------------
-- SISTEMA ROBUSTO Y UNIVERSAL DE TEAMCHECK (FALLBACK)
----------------------------------------------------
local function GetPlayerRelation(targetPlayer)
	if not targetPlayer or targetPlayer == LocalPlayer then return "ALLY" end

	-- Método 1: Teams Tradicionales de Roblox (Player.Team y TeamColor)
	if LocalPlayer.Team ~= nil and targetPlayer.Team ~= nil then
		if LocalPlayer.Team == targetPlayer.Team then
			return "ALLY"
		else
			return "ENEMY"
		end
	end

	if LocalPlayer.TeamColor == targetPlayer.TeamColor and LocalPlayer.TeamColor ~= BrickColor.new("White") then
		return "ALLY"
	end

	-- Método 2: Atributos Personalizados en Player o Character
	local myChar = LocalPlayer.Character
	local targetChar = targetPlayer.Character

	local attributeKeys = {"Team", "TeamName", "Role", "Faction", "Group", "Side", "Alignment"}
	for _, attr in ipairs(attributeKeys) do
		local myAttr = LocalPlayer:GetAttribute(attr) or (myChar and myChar:GetAttribute(attr))
		local targetAttr = targetPlayer:GetAttribute(attr) or (targetChar and targetChar:GetAttribute(attr))

		if myAttr ~= nil and targetAttr ~= nil then
			if myAttr == targetAttr then
				return "ALLY"
			else
				return "ENEMY"
			end
		end
	end

	-- Método 3: Objetos de Valor dentro de Player o Character (ValueObjects)
	local valueNames = {"Team", "TeamValue", "Role", "Faction", "Group", "Side"}
	for _, vName in ipairs(valueNames) do
		local myValObj = LocalPlayer:FindFirstChild(vName) or (myChar and myChar:FindFirstChild(vName))
		local targetValObj = targetPlayer:FindFirstChild(vName) or (targetChar and targetChar:FindFirstChild(vName))

		if myValObj and targetValObj then
			local v1 = myValObj:IsA("ValueBase") and myValObj.Value
			local v2 = targetValObj:IsA("ValueBase") and targetValObj.Value
			if v1 and v2 then
				if v1 == v2 then return "ALLY" else return "ENEMY" end
			end
		end
	end

	-- Método 4: CollectionService Tags
	local commonTags = {"Ally", "Teammate", "Friendly", "Infected", "Zombie", "Survivor", "Sheriff", "Murderer"}
	for _, tag in ipairs(commonTags) do
		local myHas = CollectionService:HasTag(LocalPlayer, tag) or (myChar and CollectionService:HasTag(myChar, tag))
		local targetHas = CollectionService:HasTag(targetPlayer, tag) or (targetChar and CollectionService:HasTag(targetChar, tag))
		if myHas and targetHas then
			return "ALLY"
		end
	end

	-- Método 5: Carpetas en Workspace (Estructura de Equipos)
	if targetChar and targetChar.Parent then
		local parentName = string.lower(targetChar.Parent.Name)
		if string.find(parentName, "ally") or string.find(parentName, "friend") or string.find(parentName, "blue") then
			return "ALLY"
		elseif string.find(parentName, "enemy") or string.find(parentName, "hostile") or string.find(parentName, "red") then
			return "ENEMY"
		end
	end

	return "UNKNOWN"
end

local function IsFriendly(targetPlayer)
	if not Config.AimbotTeamCheck then return false end
	
	local relation = GetPlayerRelation(targetPlayer)
	if relation == "ALLY" then
		return true
	elseif relation == "ENEMY" then
		return false
	else
		-- Relación no determinada (UNKNOWN)
		if Config.UnknownTargetMode == "Enemy" then
			return false -- Se trata como enemigo
		else
			return true -- Se salta / ignora (Treat as friendly)
		end
	end
end

----------------------------------------------------
-- SISTEMA ESP V2 (UNDETECTED / STEALTH)
----------------------------------------------------
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "StealthESP_Storage"
pcall(function() ESPFolder.Parent = CoreGui end)
if not ESPFolder.Parent then
	ESPFolder.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local ActiveAdornments = {}

local function CleanESPForPlayer(player)
	if ActiveAdornments[player] then
		for _, item in pairs(ActiveAdornments[player]) do
			pcall(function() item:Destroy() end)
		end
		ActiveAdornments[player] = nil
	end
end

local function ClearAllStealthESP()
	for player in pairs(ActiveAdornments) do
		CleanESPForPlayer(player)
	end
end

local function CreateStealthBox(player)
	if player == LocalPlayer then return end
	
	local character = player.Character
	if not character then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	
	if not hrp or not humanoid or humanoid.Health <= 0 then return end
	
	CleanESPForPlayer(player)
	ActiveAdornments[player] = {}

	local box = Instance.new("BoxHandleAdornment")
	box.Name = player.Name .. "_Adornment"
	box.Size = Vector3.new(4, 5, 4)
	box.Color3 = Config.ESPColor
	box.Transparency = Config.Transparency
	box.AlwaysOnTop = true
	box.ZIndex = 5
	box.Adornee = hrp
	box.Parent = ESPFolder
	
	table.insert(ActiveAdornments[player], box)
end

task.spawn(function()
	while true do
		if Config.EnableESP and Config.ESP_V2 then
			local myChar = LocalPlayer.Character
			local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
			local myPos = myHRP and myHRP.Position or Vector3.zero

			for _, player in ipairs(Players:GetPlayers()) do
				pcall(function()
					if player ~= LocalPlayer then
						local character = player.Character
						local hrp = character and character:FindFirstChild("HumanoidRootPart")
						local humanoid = character and character:FindFirstChildOfClass("Humanoid")
						
						if character and hrp and humanoid and humanoid.Health > 0 and (myPos - hrp.Position).Magnitude <= Config.ESPRange then
							if not IsFriendly(player) or Config.TeamESP then
								local currentData = ActiveAdornments[player]
								if not currentData or not currentData[1] or currentData[1].Adornee ~= hrp then
									CreateStealthBox(player)
								else
									currentData[1].Color3 = Config.ESPColor
									currentData[1].Transparency = Config.Transparency
								end
							else
								CleanESPForPlayer(player)
							end
						else
							CleanESPForPlayer(player)
						end
					end
				end)
			end
		else
			ClearAllStealthESP()
		end
		task.wait(0.5)
	end
end)

local function SetupPlayerListeners(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.8)
		if Config.EnableESP and Config.ESP_V2 then
			CreateStealthBox(player)
		end
	end)
end

for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then SetupPlayerListeners(player) end
end
Players.PlayerAdded:Connect(SetupPlayerListeners)
Players.PlayerRemoving:Connect(CleanESPForPlayer)

----------------------------------------------------
-- SISTEMA ESP V3 (INDETECTABLE) - Técnica Highlight (ESP 1)
-- Los Highlights se guardan en el contenedor oculto (ESPFolder) y respetan:
-- Team Check Avanzado, distancia, transparencia, color y Rainbow del script.
----------------------------------------------------
local V3Highlights = {}

local function CleanV3ForPlayer(player)
	local h = V3Highlights[player]
	if h then pcall(function() h:Destroy() end) end
	V3Highlights[player] = nil
end

local function ClearAllV3()
	for player in pairs(V3Highlights) do
		CleanV3ForPlayer(player)
	end
end

local function CreateV3Highlight(player, character)
	CleanV3ForPlayer(player)

	local h = Instance.new("Highlight")
	h.Name = "h"
	h.Adornee = character
	h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	h.FillColor = Config.ESPColor
	h.OutlineColor = Config.ESPColor
	h.FillTransparency = Config.Transparency
	h.OutlineTransparency = 0
	h.Parent = ESPFolder

	V3Highlights[player] = h
end

-- Revisa quién debe tener ESP (rango, vida, Team Check Avanzado)
task.spawn(function()
	while true do
		if Config.EnableESP and Config.ESPV3 then
			local myChar = LocalPlayer.Character
			local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
			local myPos = myHRP and myHRP.Position or Vector3.zero

			for _, player in ipairs(Players:GetPlayers()) do
				pcall(function()
					if player ~= LocalPlayer then
						local character = player.Character
						local hrp = character and character:FindFirstChild("HumanoidRootPart")
						local humanoid = character and character:FindFirstChildOfClass("Humanoid")

						if character and character.Parent and hrp and humanoid and humanoid.Health > 0
							and (myPos - hrp.Position).Magnitude <= Config.ESPRange
							and (not IsFriendly(player) or Config.TeamESP) then
							local h = V3Highlights[player]
							if not h or not h.Parent or h.Adornee ~= character then
								CreateV3Highlight(player, character)
							end
						else
							CleanV3ForPlayer(player)
						end
					end
				end)
			end
		else
			ClearAllV3()
		end
		task.wait(0.3)
	end
end)

-- Colores / transparencia en cada frame (así el Rainbow se ve fluido)
RunService.RenderStepped:Connect(function()
	if not (Config.EnableESP and Config.ESPV3) then return end
	local color = Config.ESPColor
	local transp = Config.Transparency
	for _, h in pairs(V3Highlights) do
		if h and h.Parent then
			h.FillColor = color
			h.OutlineColor = color
			h.FillTransparency = transp
		end
	end
end)

Players.PlayerRemoving:Connect(CleanV3ForPlayer)

----------------------------------------------------
-- INTERFAZ DE USUARIO Y CONFIGURACIÓN
----------------------------------------------------
local Icons = {
	Crosshair = "rbxassetid://87144352307029",
	Eye = "rbxassetid://111545834461192",
	Users = "rbxassetid://115802506829292",
	UsersRound = "rbxassetid://96906563206392",
	Cog = "rbxassetid://129338365599931",
	Palette = "rbxassetid://105984703621000",
	Scan = "rbxassetid://71940405914183",
	Maximize = "rbxassetid://92485191441668",
	Shield = "rbxassetid://129838924496395",
	Bot = "rbxassetid://133773993429564",
	X = "rbxassetid://88505630454141",
	Target = "rbxassetid://87144352307029",
	Globe = "rbxassetid://11422155687",
	VerifiedBadge = "rbxassetid://79143359738739",
	Flame = "rbxassetid://100387296039230",
	Zap = "rbxassetid://133773993429564"
}

local Theme = {
	Background = Color3.fromRGB(11, 10, 18),
	Panel = Color3.fromRGB(18, 16, 28),
	Card = Color3.fromRGB(25, 22, 38),
	Stroke = Color3.fromRGB(72, 57, 108),
	Purple = Color3.fromRGB(137, 78, 235),
	Purple2 = Color3.fromRGB(94, 53, 181),
	Text = Color3.fromRGB(245, 243, 250),
	SubText = Color3.fromRGB(155, 147, 175),
	Muted = Color3.fromRGB(155, 147, 175),
	On = Color3.fromRGB(86, 218, 143),
	Off = Color3.fromRGB(49, 45, 64),
	White = Color3.fromRGB(255, 255, 255)
}

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function stroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Theme.Stroke
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0
	s.Parent = parent
	return s
end

local function gradient(parent, c1, c2, rotation)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(c1, c2)
	g.Rotation = rotation or 0
	g.Parent = parent
	return g
end

local function makeIcon(parent, asset, size, position)
	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.fromOffset(size, size)
	icon.Position = position
	icon.BackgroundTransparency = 1
	icon.Image = asset
	icon.ImageColor3 = Theme.SubText
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Parent = parent
	return icon
end

local function getCharacter(plr)
	if not plr or plr == LocalPlayer then return nil end
	local char = plr.Character
	if char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")) then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health > 0 then return char end
	end
	return nil
end

local function isValidModel(model)
	if not model or not model:IsA("Model") then return false end
	if model == LocalPlayer.Character then return false end
	if Players:GetPlayerFromCharacter(model) then return false end

	local hum = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
	
	if hum and hum.Health > 0 and root then
		return true
	end
	return false
end

local getContainer = gethui or function()
	return LocalPlayer:WaitForChild("PlayerGui")
end

local parentTarget = getContainer()

for _, guiName in ipairs({"SexyBoyUniversal", "SexyBoyESP", "SexyBoyUniversal_v2"}) do
	pcall(function()
		local old = parentTarget:FindFirstChild(guiName)
		if old then old:Destroy() end
	end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SexyBoyUniversal"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = parentTarget

local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "FOVCircle"
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.fromScale(0.5, 0.5)
FOVFrame.Size = UDim2.fromOffset(Config.AimbotFOV * 2, Config.AimbotFOV * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.Parent = ScreenGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Config.FOVColor
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.25
FOVStroke.Parent = FOVFrame
corner(FOVFrame, 999)

local FloatBtn = Instance.new("ImageButton")
FloatBtn.Size = UDim2.fromOffset(42, 42)
FloatBtn.Position = UDim2.new(0, 14, 0.18, 0)
FloatBtn.BackgroundColor3 = Theme.Purple2
FloatBtn.AutoButtonColor = false
FloatBtn.Image = Icons.Crosshair
FloatBtn.ImageColor3 = Theme.White
FloatBtn.Parent = ScreenGui
corner(FloatBtn, 21)
stroke(FloatBtn, Color3.fromRGB(168, 111, 255), 1.5, 0.15)
gradient(FloatBtn, Theme.Purple, Theme.Purple2, 45)

-- Logo personalizado del ícono flotante (si falla la descarga, queda el ícono original)
task.spawn(function()
	local LOGO_URL = "https://raw.githubusercontent.com/moisess011/sexyboyhub/main/logo2.png"
	local LOGO_FILE = "sexyboy_logo2.png"
	local getasset = getcustomasset or getsynasset
	if not (getasset and writefile) then return end

	local downloaded = pcall(function()
		writefile(LOGO_FILE, game:HttpGet(LOGO_URL))
	end)
	if not downloaded and not (isfile and isfile(LOGO_FILE)) then return end

	local ok, asset = pcall(getasset, LOGO_FILE)
	if ok and asset and asset ~= "" then
		FloatBtn.Image = asset
		FloatBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
		FloatBtn.ScaleType = Enum.ScaleType.Crop

		-- el degradado teñiría los colores del logo, así que se desactiva
		local g = FloatBtn:FindFirstChildOfClass("UIGradient")
		if g then g.Enabled = false end

		-- Ícono de la pantalla de carga (se crea más abajo en el script, así que se busca cuando exista)
		task.spawn(function()
			for _ = 1, 100 do -- hasta 10s esperando a que se cree la pantalla de carga
				if LoadingIcon then break end
				task.wait(0.1)
			end
			if LoadingIcon then
				LoadingIcon.Image = asset
				LoadingIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
				LoadingIcon.ScaleType = Enum.ScaleType.Crop
				local gL = IconContainer:FindFirstChildOfClass("UIGradient")
				if gL then gL.Enabled = false end
			end
		end)

		-- Ícono junto a "SexyBoy Universal" en el menú
		MenuHeaderIcon.Image = asset
		MenuHeaderIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
		MenuHeaderIcon.ScaleType = Enum.ScaleType.Crop
		local gH = HeaderIcon:FindFirstChildOfClass("UIGradient")
		if gH then gH.Enabled = false end
	end
end)

local Window = Instance.new("Frame")
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.Size = UDim2.new(0, 350, 0, 440)
Window.Position = UDim2.fromScale(0.5, 0.5)
Window.BackgroundColor3 = Theme.Background
Window.BackgroundTransparency = 0.08
Window.BorderSizePixel = 0
Window.Active = true
Window.Visible = false
Window.Parent = ScreenGui
corner(Window, 14)
stroke(Window, Theme.Stroke, 1.2, 0.12)

local Inner = Instance.new("Frame")
Inner.Size = UDim2.new(1, -2, 1, -2)
Inner.Position = UDim2.fromOffset(1, 1)
Inner.BackgroundColor3 = Theme.Panel
Inner.BackgroundTransparency = 0.08
Inner.BorderSizePixel = 0
Inner.Parent = Window
corner(Inner, 13)

local WindowScale = Instance.new("UIScale")
WindowScale.Scale = 0.78
WindowScale.Parent = Window

local dragging, dragStart, startPos = false, nil, nil
Window.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Window.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
	local delta = input.Position - dragStart
	Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, -20, 0, 52)
Header.Position = UDim2.fromOffset(10, 8)
Header.BackgroundTransparency = 1
Header.Parent = Inner

local HeaderIcon = Instance.new("Frame")
HeaderIcon.Size = UDim2.fromOffset(36, 36)
HeaderIcon.Position = UDim2.fromOffset(0, 4)
HeaderIcon.BackgroundColor3 = Theme.Purple2
HeaderIcon.BorderSizePixel = 0
HeaderIcon.Parent = Header
corner(HeaderIcon, 10)
stroke(HeaderIcon, Color3.fromRGB(160, 105, 255), 1, 0.25)
gradient(HeaderIcon, Theme.Purple, Theme.Purple2, 45)
local MenuHeaderIcon = makeIcon(HeaderIcon, Icons.Crosshair, 18, UDim2.fromOffset(9, 9))
MenuHeaderIcon.ImageColor3 = Theme.White

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 20)
Title.Position = UDim2.fromOffset(46, 3)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "SexyBoy Universal"
Title.TextColor3 = Theme.Text
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -50, 0, 16)
Subtitle.Position = UDim2.fromOffset(46, 23)
Subtitle.BackgroundTransparency = 1
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "v3.0 • Actualizado el 22/9/26"
Subtitle.TextColor3 = Theme.SubText
Subtitle.TextSize = 9
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local CloseBtn = Instance.new("ImageButton")
CloseBtn.Size = UDim2.fromOffset(28, 28)
CloseBtn.Position = UDim2.new(1, -28, 0, 8)
CloseBtn.BackgroundColor3 = Theme.Card
CloseBtn.AutoButtonColor = false
CloseBtn.Image = Icons.X
CloseBtn.ImageColor3 = Theme.SubText
CloseBtn.Parent = Header
corner(CloseBtn, 8)
stroke(CloseBtn, Theme.Stroke, 1, 0.35)
CloseBtn.Activated:Connect(function() Window.Visible = false end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 34)
TabBar.Position = UDim2.fromOffset(10, 62)
TabBar.BackgroundColor3 = Theme.Card
TabBar.BackgroundTransparency = 0.15
TabBar.BorderSizePixel = 0
TabBar.Parent = Inner
corner(TabBar, 9)
stroke(TabBar, Theme.Stroke, 1, 0.35)

local HomeTab = Instance.new("TextButton")
HomeTab.Size = UDim2.new(0.5, -3, 1, -6)
HomeTab.Position = UDim2.fromOffset(3, 3)
HomeTab.BackgroundColor3 = Theme.Purple2
HomeTab.AutoButtonColor = false
HomeTab.Text = Translations.EN.TabHome
HomeTab.Font = Enum.Font.GothamSemibold
HomeTab.TextSize = 11
HomeTab.TextColor3 = Theme.White
HomeTab.Parent = TabBar
corner(HomeTab, 7)
gradient(HomeTab, Theme.Purple, Theme.Purple2, 45)

local SettingsTab = Instance.new("TextButton")
SettingsTab.Size = UDim2.new(0.5, -3, 1, -6)
SettingsTab.Position = UDim2.new(0.5, 0, 0, 3)
SettingsTab.BackgroundColor3 = Color3.fromRGB(27, 24, 40)
SettingsTab.AutoButtonColor = false
SettingsTab.Text = Translations.EN.TabSettings
SettingsTab.Font = Enum.Font.GothamSemibold
SettingsTab.TextSize = 11
SettingsTab.TextColor3 = Theme.SubText
SettingsTab.Parent = TabBar
corner(SettingsTab, 7)

local HomePage = Instance.new("ScrollingFrame")
HomePage.Size = UDim2.new(1, -20, 1, -106)
HomePage.Position = UDim2.fromOffset(10, 102)
HomePage.BackgroundTransparency = 1
HomePage.BorderSizePixel = 0
HomePage.ScrollBarThickness = 2
HomePage.ScrollBarImageColor3 = Theme.Purple
HomePage.AutomaticCanvasSize = Enum.AutomaticSize.Y
HomePage.CanvasSize = UDim2.new()
HomePage.Parent = Inner
Instance.new("UIPadding", HomePage).PaddingBottom = UDim.new(0, 6)
Instance.new("UIListLayout", HomePage).Padding = UDim.new(0, 5)

local SettingsPage = Instance.new("ScrollingFrame")
SettingsPage.Size = UDim2.new(1, -20, 1, -106)
SettingsPage.Position = UDim2.fromOffset(10, 102)
SettingsPage.BackgroundTransparency = 1
SettingsPage.BorderSizePixel = 0
SettingsPage.ScrollBarThickness = 2
SettingsPage.ScrollBarImageColor3 = Theme.Purple
SettingsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsPage.CanvasSize = UDim2.new()
SettingsPage.Visible = false
SettingsPage.Parent = Inner
Instance.new("UIPadding", SettingsPage).PaddingBottom = UDim.new(0, 6)
Instance.new("UIListLayout", SettingsPage).Padding = UDim.new(0, 5)

local function selectTab(home)
	HomePage.Visible = home
	SettingsPage.Visible = not home
	TweenService:Create(HomeTab, TweenInfo.new(0.18), {
		BackgroundColor3 = home and Theme.Purple2 or Color3.fromRGB(27, 24, 40),
		TextColor3 = home and Theme.White or Theme.SubText
	}):Play()
	TweenService:Create(SettingsTab, TweenInfo.new(0.18), {
		BackgroundColor3 = home and Color3.fromRGB(27, 24, 40) or Theme.Purple2,
		TextColor3 = home and Theme.SubText or Theme.White
	}):Play()
end
HomeTab.Activated:Connect(function() selectTab(true) end)
SettingsTab.Activated:Connect(function() selectTab(false) end)

local updateModalLanguage

local function updateLanguage(langKey)
	Config.Language = langKey
	local t = Translations[langKey] or Translations.EN
	HomeTab.Text = t.TabHome
	SettingsTab.Text = t.TabSettings
	for key, elem in pairs(UI_Elements) do
		if elem.Title and t[key] then elem.Title.Text = t[key] end
		if elem.Desc and t[key .. "_D"] then elem.Desc.Text = t[key .. "_D"] end
	end
	if updateModalLanguage then updateModalLanguage(langKey) end
end

local function createSection(parent, apiKey, iconAsset)
	local section = Instance.new("Frame")
	section.Size = UDim2.new(1, 0, 0, 24)
	section.BackgroundTransparency = 1
	section.Parent = parent
	local icon = makeIcon(section, iconAsset, 14, UDim2.fromOffset(2, 4))
	icon.ImageColor3 = Theme.Purple
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -22, 1, 0)
	label.Position = UDim2.fromOffset(22, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = Translations.EN[apiKey] or apiKey
	label.TextColor3 = Theme.Text
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = section
	UI_Elements[apiKey] = { Title = label }
end

local function createToggle(parent, apiKey, iconAsset, default, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 50)
	row.BackgroundColor3 = Theme.Card
	row.BackgroundTransparency = 0.12
	row.BorderSizePixel = 0
	row.Parent = parent
	corner(row, 10)
	stroke(row, Theme.Stroke, 1, 0.55)

	local iconBox = Instance.new("Frame")
	iconBox.Size = UDim2.fromOffset(30, 30)
	iconBox.Position = UDim2.fromOffset(8, 10)
	iconBox.BackgroundTransparency = 1
	iconBox.Parent = row
	makeIcon(iconBox, iconAsset, 18, UDim2.fromOffset(6, 6)).ImageColor3 = Theme.Purple

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -100, 0, 18)
	lbl.Position = UDim2.fromOffset(44, 8)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamSemibold
	lbl.Text = Translations.EN[apiKey] or apiKey
	lbl.TextColor3 = Theme.Text
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row

	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(1, -100, 0, 16)
	desc.Position = UDim2.fromOffset(44, 26)
	desc.BackgroundTransparency = 1
	desc.Font = Enum.Font.Gotham
	desc.Text = Translations.EN[apiKey .. "_D"] or ""
	desc.TextColor3 = Theme.Muted
	desc.TextSize = 8.5
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextTruncate = Enum.TextTruncate.AtEnd
	desc.Parent = row

	UI_Elements[apiKey] = { Title = lbl, Desc = desc }

	local track = Instance.new("TextButton")
	track.Size = UDim2.fromOffset(42, 22)
	track.Position = UDim2.new(1, -50, 0.5, -11)
	track.BackgroundColor3 = default and Theme.On or Theme.Off
	track.AutoButtonColor = false
	track.Text = ""
	track.Parent = row
	corner(track, 11)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(16, 16)
	knob.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.fromOffset(3, 3)
	knob.BackgroundColor3 = Theme.White
	knob.BorderSizePixel = 0
	knob.Parent = track
	corner(knob, 8)

	local state = default
	track.Activated:Connect(function()
		state = not state
		TweenService:Create(track, TweenInfo.new(0.16), { BackgroundColor3 = state and Theme.On or Theme.Off }):Play()
		TweenService:Create(knob, TweenInfo.new(0.16), { Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.fromOffset(3, 3) }):Play()
		callback(state)
	end)
end

local function createDropdown(parent, apiKey, iconAsset, options, defaultValue, onSelect)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 52)
	container.BackgroundColor3 = Theme.Card
	container.BackgroundTransparency = 0.12
	container.ClipsDescendants = true
	container.BorderSizePixel = 0
	container.Parent = parent
	corner(container, 10)
	stroke(container, Theme.Stroke, 1, 0.55)

	local headerBtn = Instance.new("TextButton")
	headerBtn.Size = UDim2.new(1, 0, 0, 52)
	headerBtn.BackgroundTransparency = 1
	headerBtn.Text = ""
	headerBtn.Parent = container

	local iconBox = Instance.new("Frame")
	iconBox.Size = UDim2.fromOffset(30, 30)
	iconBox.Position = UDim2.fromOffset(8, 11)
	iconBox.BackgroundTransparency = 1
	iconBox.Parent = headerBtn
	makeIcon(iconBox, iconAsset, 18, UDim2.fromOffset(6, 6)).ImageColor3 = Theme.Purple

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.55, 0, 0, 18)
	lbl.Position = UDim2.fromOffset(44, 8)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamSemibold
	lbl.Text = Translations.EN[apiKey] or apiKey
	lbl.TextColor3 = Theme.Text
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = headerBtn

	local selectedLbl = Instance.new("TextLabel")
	selectedLbl.Size = UDim2.new(0.55, 0, 0, 16)
	selectedLbl.Position = UDim2.fromOffset(44, 26)
	selectedLbl.BackgroundTransparency = 1
	selectedLbl.Font = Enum.Font.Gotham
	selectedLbl.Text = "Selected: " .. tostring(defaultValue)
	selectedLbl.TextColor3 = Theme.Purple
	selectedLbl.TextSize = 9
	selectedLbl.TextXAlignment = Enum.TextXAlignment.Left
	selectedLbl.Parent = headerBtn

	UI_Elements[apiKey] = { Title = lbl }

	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.fromOffset(24, 24)
	arrow.Position = UDim2.new(1, -32, 0, 14)
	arrow.BackgroundTransparency = 1
	arrow.Font = Enum.Font.GothamBold
	arrow.Text = "v"
	arrow.TextColor3 = Theme.SubText
	arrow.TextSize = 14
	arrow.Parent = headerBtn

	local listContainer = Instance.new("Frame")
	listContainer.Size = UDim2.new(1, -16, 0, #options * 32)
	listContainer.Position = UDim2.fromOffset(8, 52)
	listContainer.BackgroundTransparency = 1
	listContainer.Parent = container

	local expanded = false
	for i, opt in ipairs(options) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size = UDim2.new(1, 0, 0, 28)
		optBtn.Position = UDim2.fromOffset(0, (i - 1) * 32)
		optBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
		optBtn.Font = Enum.Font.GothamSemibold
		optBtn.Text = "   " .. opt.label
		optBtn.TextColor3 = (defaultValue == opt.value) and Theme.White or Theme.SubText
		optBtn.TextSize = 10
		optBtn.TextXAlignment = Enum.TextXAlignment.Left
		optBtn.AutoButtonColor = false
		optBtn.Parent = listContainer
		corner(optBtn, 6)
		optBtn.Activated:Connect(function()
			selectedLbl.Text = "Selected: " .. opt.label
			onSelect(opt.value)
			expanded = false
			arrow.Text = "v"
			TweenService:Create(container, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 52) }):Play()
			for _, child in ipairs(listContainer:GetChildren()) do
				if child:IsA("TextButton") then child.TextColor3 = Theme.SubText end
			end
			optBtn.TextColor3 = Theme.White
		end)
	end

	headerBtn.Activated:Connect(function()
		expanded = not expanded
		arrow.Text = expanded and "^" or "v"
		local targetHeight = expanded and (52 + #options * 32 + 8) or 52
		TweenService:Create(container, TweenInfo.new(0.22), { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()
	end)
end

local function createSlider(parent, apiKey, iconAsset, minV, maxV, default, suffix, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 58)
	row.BackgroundColor3 = Theme.Card
	row.BackgroundTransparency = 0.12
	row.BorderSizePixel = 0
	row.Parent = parent
	corner(row, 10)
	stroke(row, Theme.Stroke, 1, 0.55)

	local iconBox = Instance.new("Frame")
	iconBox.Size = UDim2.fromOffset(30, 30)
	iconBox.Position = UDim2.fromOffset(8, 8)
	iconBox.BackgroundTransparency = 1
	iconBox.Parent = row
	makeIcon(iconBox, iconAsset, 18, UDim2.fromOffset(6, 6)).ImageColor3 = Theme.Purple

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.55, 0, 0, 16)
	lbl.Position = UDim2.fromOffset(44, 6)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamSemibold
	lbl.Text = Translations.EN[apiKey] or apiKey
	lbl.TextColor3 = Theme.Text
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row

	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(0.55, 0, 0, 14)
	desc.Position = UDim2.fromOffset(44, 22)
	desc.BackgroundTransparency = 1
	desc.Font = Enum.Font.Gotham
	desc.Text = Translations.EN[apiKey .. "_D"] or ""
	desc.TextColor3 = Theme.Muted
	desc.TextSize = 8
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.Parent = row

	UI_Elements[apiKey] = { Title = lbl, Desc = desc }

	local val = Instance.new("TextLabel")
	val.Size = UDim2.fromOffset(80, 18)
	val.Position = UDim2.new(1, -90, 0, 6)
	val.BackgroundTransparency = 1
	val.Font = Enum.Font.GothamBold
	val.Text = tostring(default) .. suffix
	val.TextColor3 = Color3.fromRGB(173, 121, 255)
	val.TextSize = 10
	val.TextXAlignment = Enum.TextXAlignment.Right
	val.Parent = row

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -52, 0, 4)
	track.Position = UDim2.fromOffset(44, 44)
	track.BackgroundColor3 = Color3.fromRGB(45, 40, 59)
	track.BorderSizePixel = 0
	track.Parent = row
	corner(track, 2)

	local fill = Instance.new("Frame")
	local sc = math.clamp((default - minV) / (maxV - minV), 0, 1)
	fill.Size = UDim2.new(sc, 0, 1, 0)
	fill.BackgroundColor3 = Theme.Purple
	fill.BorderSizePixel = 0
	fill.Parent = track
	corner(fill, 2)
	gradient(fill, Theme.Purple, Color3.fromRGB(184, 105, 255), 0)

	local draggingSlider = false
	local function update(pos)
		local rel = math.clamp((pos.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		fill.Size = UDim2.new(rel, 0, 1, 0)
		local v = math.floor(minV + (maxV - minV) * rel)
		val.Text = tostring(v) .. suffix
		callback(v)
	end
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
			update(input.Position)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input.Position)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
		end
	end)
end

local function createColorRow(parent, apiKey, iconAsset, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 52)
	row.BackgroundColor3 = Theme.Card
	row.BackgroundTransparency = 0.12
	row.BorderSizePixel = 0
	row.Parent = parent
	corner(row, 10)
	stroke(row, Theme.Stroke, 1, 0.55)

	local iconBox = Instance.new("Frame")
	iconBox.Size = UDim2.fromOffset(30, 30)
	iconBox.Position = UDim2.fromOffset(8, 11)
	iconBox.BackgroundTransparency = 1
	iconBox.Parent = row
	makeIcon(iconBox, iconAsset or Icons.Palette, 18, UDim2.fromOffset(6, 6)).ImageColor3 = Theme.Purple

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.35, 0, 1, 0)
	lbl.Position = UDim2.fromOffset(44, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamSemibold
	lbl.Text = Translations.EN[apiKey] or apiKey
	lbl.TextColor3 = Theme.Text
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row
	UI_Elements[apiKey] = { Title = lbl }

	local colors = {
		Color3.fromRGB(240, 70, 70),
		Color3.fromRGB(70, 200, 120),
		Color3.fromRGB(70, 150, 240),
		Color3.fromRGB(240, 200, 60),
		Color3.fromRGB(200, 70, 240)
	}
	for i, c in ipairs(colors) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.fromOffset(18, 18)
		b.Position = UDim2.new(0.48 + (i - 1) * 0.105, 0, 0.5, -9)
		b.BackgroundColor3 = c
		b.Text = ""
		b.AutoButtonColor = false
		b.Parent = row
		corner(b, 9)
		b.Activated:Connect(function() callback(c) end)
	end
end

local function restoreHitbox(plr)
	local data = savedHRP[plr]
	if not data then return end
	local root = data.part
	if root and root.Parent and data.size then
		pcall(function()
			root.Size = data.size
			root.Transparency = data.transparency or 1
			root.CanCollide = data.canCollide
		end)
	end
	savedHRP[plr] = nil
end

local function clearAllHitboxes()
	for plr, _ in pairs(savedHRP) do restoreHitbox(plr) end
end

-- SECCIÓN DE VISUALES
createSection(HomePage, "SecESP", Icons.Crosshair)
createToggle(HomePage, "EnableESP", Icons.Crosshair, false, function(s) Config.EnableESP = s end)
createToggle(HomePage, "ESP_V2", Icons.Shield, false, function(s) Config.ESP_V2 = s end)
createToggle(HomePage, "ESP_V3", Icons.Shield, false, function(s)
	Config.ESPV3 = s
	if not s then ClearAllV3() end
end)
createToggle(HomePage, "PlayerESP", Icons.Users, false, function(s) Config.PlayerESP = s end)
createToggle(HomePage, "EnemyESP", Icons.Shield, false, function(s) Config.EnemyESP = s end)
createToggle(HomePage, "TeamESP", Icons.UsersRound, false, function(s) Config.TeamESP = s end)
createToggle(HomePage, "NPCESP", Icons.Bot, false, function(s) Config.NPCESP = s end)
createToggle(HomePage, "PlayerHitbox", Icons.Maximize, false, function(s)
	Config.PlayerHitbox = s
	if not s then clearAllHitboxes() end
end)

-- SECCIÓN DE MOVIMIENTO Y MODIFICADORES (NUEVO)
createSection(HomePage, "SecMovement", Icons.Zap)
createToggle(HomePage, "Noclip", Icons.Shield, false, function(s) Config.Noclip = s end)
createSlider(HomePage, "Speed", Icons.Zap, 16, 200, 16, "", function(v) Config.WalkSpeed = v end)
createSlider(HomePage, "Jump", Icons.Zap, 50, 300, 50, "", function(v) Config.JumpPower = v end)

-- SECCIÓN DE AIM ASSIST & COMBAT (INTEGRADO CON TRIGGERBOT)
createSection(HomePage, "SecAimbot", Icons.Crosshair)
createToggle(HomePage, "Aimbot", Icons.Crosshair, false, function(s)
	Config.Aimbot = s
	FOVFrame.Visible = (Config.Aimbot or Config.AimbotV2)
end)
createToggle(HomePage, "AimbotV2", Icons.Target, false, function(s)
	Config.AimbotV2 = s
	FOVFrame.Visible = (Config.Aimbot or Config.AimbotV2)
end)
createToggle(HomePage, "Triggerbot", Icons.Zap, false, function(s) Config.Triggerbot = s end)
createToggle(HomePage, "TeamCheck", Icons.Shield, false, function(s) Config.AimbotTeamCheck = s end)

createDropdown(HomePage, "UnknownMode", Icons.Shield, {
	{ label = "Tratar como Enemigo", value = "Enemy" },
	{ label = "Ignorar / Saltar", value = "Skip" }
}, "Tratar como Enemigo", function(val) Config.UnknownTargetMode = val end)

createToggle(HomePage, "VisibleCheck", Icons.Eye, false, function(s) Config.AimbotVisibleCheck = s end)

createDropdown(HomePage, "TargetPart", Icons.Target, {
	{ label = "Cabeza", value = "Head" },
	{ label = "Pecho", value = "Torso" },
	{ label = "Cualquiera (Azar)", value = "Random" }
}, "Cabeza", function(val) Config.AimbotTarget = val end)

-- AJUSTES
createSection(SettingsPage, "SecSettings", Icons.Cog)
createDropdown(SettingsPage, "LangRow", Icons.Globe, {
	{ label = "Ingles (USA)", value = "EN" },
	{ label = "Espanol (ES)", value = "ES" },
	{ label = "Portugues (BR)", value = "PT" }
}, "EN", function(val) updateLanguage(val) end)

createSlider(SettingsPage, "Distance", Icons.Scan, 50, 1000, 300, "m", function(v) Config.ESPRange = v end)
createSlider(SettingsPage, "HitSize", Icons.Maximize, 2, 50, 6, "", function(v) Config.HitboxSize = v end)
createSlider(SettingsPage, "Transp", Icons.Eye, 0, 100, 50, "%", function(v) Config.Transparency = v / 100 end)
createSlider(SettingsPage, "FOVSize", Icons.Scan, 40, 350, 120, "px", function(v)
	Config.AimbotFOV = v
	FOVFrame.Size = UDim2.fromOffset(v * 2, v * 2)
end)
createSlider(SettingsPage, "TrigDelay", Icons.Zap, 0, 300, 50, "ms", function(v) Config.TriggerbotDelay = v / 1000 end)
createSlider(SettingsPage, "Smooth", Icons.Eye, 0, 100, 15, "%", function(v) Config.AimbotSmooth = v / 100 end)

-- COLORES Y EFECTOS RAINBOW (NUEVO)
createToggle(SettingsPage, "RainbowESP", Icons.Palette, false, function(s) Config.RainbowESP = s end)
createToggle(SettingsPage, "RainbowFOV", Icons.Palette, false, function(s) Config.RainbowFOV = s end)
createColorRow(SettingsPage, "ColorRow", Icons.Palette, function(c) Config.ESPColor = c end)
createColorRow(SettingsPage, "FOVColorRow", Icons.Palette, function(c)
	Config.FOVColor = c
	FOVStroke.Color = c
end)

local function isPartVisible(part)
	if not Config.AimbotVisibleCheck then return true end
	local myChar = LocalPlayer.Character
	if not myChar then return false end
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {myChar, Camera}
	
	local origin = Camera.CFrame.Position
	local direction = (part.Position - origin)
	local result = workspace:Raycast(origin, direction, raycastParams)
	
	if result then
		return result.Instance:IsDescendantOf(part.Parent)
	end
	return true
end

local function isValidTarget(plr)
	if plr == LocalPlayer then return false end
	if IsFriendly(plr) then return false end
	return getCharacter(plr) ~= nil
end

local function getAimPart(char)
	if not char then return nil end
	if Config.AimbotTarget == "Head" then
		return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
	elseif Config.AimbotTarget == "Torso" then
		return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char.PrimaryPart
	else
		local parts = { char:FindFirstChild("Head"), char:FindFirstChild("HumanoidRootPart"), char:FindFirstChild("Torso") }
		local valid = {}
		for _, p in ipairs(parts) do if p then table.insert(valid, p) end end
		if #valid == 0 then return char.PrimaryPart end
		return valid[math.random(1, #valid)]
	end
end

local function getClosestInFOV()
	local cam = workspace.CurrentCamera
	if not cam then return nil end
	local screenCenter = cam.ViewportSize / 2
	local best, bestDist = nil, Config.AimbotFOV

	local targetsToScan = {}

	for _, plr in ipairs(Players:GetPlayers()) do
		if isValidTarget(plr) then
			local char = getCharacter(plr)
			if char then table.insert(targetsToScan, char) end
		end
	end

	for _, child in ipairs(workspace:GetChildren()) do
		if isValidModel(child) then
			table.insert(targetsToScan, child)
		end
	end

	for _, char in ipairs(targetsToScan) do
		local part = getAimPart(char)
		if part and isPartVisible(part) then
			local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
			if onScreen and screenPos.Z > 0 then
				local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
				if dist < bestDist then
					bestDist = dist
					best = part
				end
			end
		end
	end

	return best
end

local function applyHighlight(model, color)
	local h = model:FindFirstChild("SexyBoy_Highlight")
	if not h then
		h = Instance.new("Highlight")
		h.Name = "SexyBoy_Highlight"
		h.Parent = model
	end
	h.FillColor = color
	h.OutlineColor = color
	h.FillTransparency = Config.Transparency
	h.Enabled = true
end

local function removeHighlight(model)
	local h = model:FindFirstChild("SexyBoy_Highlight")
	if h then h:Destroy() end
end

----------------------------------------------------
-- LÓGICA DEL TRIGGERBOT
----------------------------------------------------
local lastTriggerShot = 0

local function ProcessTriggerbot()
	if not Config.Triggerbot then return end
	if tick() - lastTriggerShot < Config.TriggerbotDelay then return end

	local targetObj = Mouse.Target
	if not targetObj then return end

	local character = targetObj:FindFirstAncestorOfClass("Model")
	if not character then return end

	local player = Players:GetPlayerFromCharacter(character)
	if not player or player == LocalPlayer then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end

	if IsFriendly(player) then return end

	-- Verificación de Visibilidad
	local part = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
	if part and not isPartVisible(part) then return end

	lastTriggerShot = tick()
	
	-- Simular Disparo
	pcall(function()
		if mouse1press and mouse1release then
			mouse1press()
			task.wait(0.02)
			mouse1release()
		else
			VirtualInputManager = game:GetService("VirtualInputManager")
			VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 0)
			task.wait(0.02)
			VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 0)
		end
	end)
end

----------------------------------------------------
-- BUCLE PRINCIPAL (RENDERSTEPPED)
----------------------------------------------------
RunService.RenderStepped:Connect(function()
	local cam = workspace.CurrentCamera
	if cam then Camera = cam end

	local myChar = LocalPlayer.Character
	local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
	local myPos = myHRP and myHRP.Position or Vector3.zero

	-- LÓGICA DE COLOR RAINBOW (NUEVO)
	local rainbowColor = Color3.fromHSV((tick() * 0.5) % 1, 1, 1)
	if Config.RainbowESP then
		Config.ESPColor = rainbowColor
	end
	if Config.RainbowFOV then
		FOVStroke.Color = rainbowColor
	else
		FOVStroke.Color = Config.FOVColor
	end

	-- LÓGICA DE NOCLIP & MOVIMIENTO (NUEVO)
	if myChar then
		local hum = myChar:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = Config.WalkSpeed
			hum.JumpPower = Config.JumpPower
		end
		if Config.Noclip then
			for _, part in ipairs(myChar:GetChildren()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end

	-- Triggerbot Process
	ProcessTriggerbot()

	-- Control del ESP Normal por Highlights
	if not Config.EnableESP or Config.ESP_V2 then
		for _, plr in ipairs(Players:GetPlayers()) do
			local c = getCharacter(plr)
			if c then removeHighlight(c) end
			if plr.Character then removeHighlight(plr.Character) end
			local wm = workspace:FindFirstChild(plr.Name)
			if wm and wm:IsA("Model") then removeHighlight(wm) end
		end
	elseif Config.PlayerESP and not Config.ESP_V2 then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local char = getCharacter(plr)
				if char then
					local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head") or char.PrimaryPart
					if root then
						if (myPos - root.Position).Magnitude <= Config.ESPRange then
							if not IsFriendly(plr) or Config.TeamESP then
								applyHighlight(char, Config.ESPColor)
							else
								removeHighlight(char)
							end
						else
							removeHighlight(char)
						end
					end
				end
			end
		end
	end

	-- Hitbox Expander
	if Config.PlayerHitbox then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and not IsFriendly(plr) then
				local char = getCharacter(plr)
				if char then
					local root = char:FindFirstChild("HumanoidRootPart")
					local hum = char:FindFirstChildOfClass("Humanoid")
					if root and hum and hum.Health > 0 and (myPos - root.Position).Magnitude <= Config.ESPRange then
						if not savedHRP[plr] then
							savedHRP[plr] = {
								size = root.Size,
								transparency = root.Transparency,
								canCollide = root.CanCollide,
								part = root
							}
						end
						local size = math.clamp(Config.HitboxSize, 2, 50)
						pcall(function()
							root.Size = Vector3.new(size, size, size)
							root.Transparency = 0.6
							root.CanCollide = false
						end)
					else
						restoreHitbox(plr)
					end
				else
					restoreHitbox(plr)
				end
			end
		end
	end

	-- Aimbot & Aimbot V2 Logic
	if (Config.Aimbot or Config.AimbotV2) and Camera then
		if Config.Aimbot and not Config.AimbotV2 then
			currentTargetPart = getClosestInFOV()
		else
			if not currentTargetPart or not currentTargetPart.Parent or not currentTargetPart.Parent:FindFirstChildOfClass("Humanoid") or currentTargetPart.Parent:FindFirstChildOfClass("Humanoid").Health <= 0 or not isPartVisible(currentTargetPart) then
				currentTargetPart = getClosestInFOV()
			else
				local screenPos, onScreen = Camera:WorldToViewportPoint(currentTargetPart.Position)
				local screenCenter = Camera.ViewportSize / 2
				local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
				if not onScreen or dist > (Config.AimbotFOV * 1.8) then
					currentTargetPart = nil
				end
			end
		end

		if currentTargetPart then
			local rawSmooth = math.clamp(Config.AimbotSmooth, 0, 0.95)
			local alpha = math.clamp(1 - rawSmooth, 0.1, 1)

			if Config.Aimbot and not Config.AimbotV2 then
				if Camera.CameraType ~= Enum.CameraType.Custom then
					Camera.CameraType = Enum.CameraType.Custom
				end
				local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, currentTargetPart.Position)
				Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, alpha)
			
			elseif Config.AimbotV2 then
				Camera.CameraType = Enum.CameraType.Scriptable
				local goalCam = CFrame.lookAt(Camera.CFrame.Position, currentTargetPart.Position)
				Camera.CFrame = Camera.CFrame:Lerp(goalCam, alpha)
				
				if myHRP then
					local targetPosHorizontal = Vector3.new(currentTargetPart.Position.X, myHRP.Position.Y, currentTargetPart.Position.Z)
					local goalBody = CFrame.lookAt(myHRP.Position, targetPosHorizontal)
					myHRP.CFrame = myHRP.CFrame:Lerp(goalBody, alpha)
				end
			end
		else
			if Camera.CameraType == Enum.CameraType.Scriptable then
				Camera.CameraType = Enum.CameraType.Custom
			end
		end
	else
		currentTargetPart = nil
		if Camera and Camera.CameraType == Enum.CameraType.Scriptable then
			Camera.CameraType = Enum.CameraType.Custom
		end
	end
end)

FloatBtn.Activated:Connect(function()
	Window.Visible = not Window.Visible
end)

----------------------------------------------------
-- MENÚ DE CARGA (LOADING SCREEN) Y AVISO MODAL
----------------------------------------------------
local activeUsersCount = math.random(680, 740)

local LoadingGui = Instance.new("Frame")
LoadingGui.Name = "LoadingScreen"
LoadingGui.Size = UDim2.fromScale(1, 1)
LoadingGui.BackgroundColor3 = Theme.Background
LoadingGui.BackgroundTransparency = 0
LoadingGui.BorderSizePixel = 0
LoadingGui.ZIndex = 100000
LoadingGui.Parent = ScreenGui

local LoadingContainer = Instance.new("Frame")
LoadingContainer.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingContainer.Position = UDim2.fromScale(0.5, 0.5)
LoadingContainer.Size = UDim2.fromOffset(340, 240)
LoadingContainer.BackgroundColor3 = Theme.Panel
LoadingContainer.BackgroundTransparency = 0.05
LoadingContainer.Parent = LoadingGui
corner(LoadingContainer, 16)
stroke(LoadingContainer, Theme.Stroke, 1.5, 0.1)

local IconContainer = Instance.new("Frame")
IconContainer.AnchorPoint = Vector2.new(0.5, 0)
IconContainer.Position = UDim2.new(0.5, 0, 0, 16)
IconContainer.Size = UDim2.fromOffset(44, 44)
IconContainer.BackgroundColor3 = Theme.Purple2
IconContainer.Parent = LoadingContainer
corner(IconContainer, 12)
gradient(IconContainer, Theme.Purple, Theme.Purple2, 45)
local LoadingIcon = makeIcon(IconContainer, Icons.Crosshair, 24, UDim2.fromOffset(10, 10))
LoadingIcon.ImageColor3 = Theme.White

local LTitle = Instance.new("TextLabel")
LTitle.Position = UDim2.new(0, 0, 0, 66)
LTitle.Size = UDim2.new(1, 0, 0, 20)
LTitle.BackgroundTransparency = 1
LTitle.Font = Enum.Font.GothamBold
LTitle.Text = "SEXYBOY UNIVERSAL"
LTitle.TextColor3 = Theme.Text
LTitle.TextSize = 15
LTitle.Parent = LoadingContainer

local LVersion = Instance.new("TextLabel")
LVersion.Position = UDim2.new(0, 0, 0, 86)
LVersion.Size = UDim2.new(1, 0, 0, 14)
LVersion.BackgroundTransparency = 1
LVersion.Font = Enum.Font.Gotham
LVersion.Text = "v3.0"
LVersion.TextColor3 = Theme.Purple
LVersion.TextSize = 11
LVersion.Parent = LoadingContainer

local TikTokBanner = Instance.new("Frame")
TikTokBanner.AnchorPoint = Vector2.new(0.5, 0)
TikTokBanner.Position = UDim2.new(0.5, 0, 0, 106)
TikTokBanner.Size = UDim2.new(1, -40, 0, 24)
TikTokBanner.BackgroundColor3 = Theme.Card
TikTokBanner.Parent = LoadingContainer
corner(TikTokBanner, 6)
stroke(TikTokBanner, Theme.Stroke, 1, 0.4)

local TikTokIcon = makeIcon(TikTokBanner, Icons.VerifiedBadge, 14, UDim2.fromOffset(8, 5))
TikTokIcon.ImageColor3 = Theme.Purple

local TikTokText = Instance.new("TextLabel")
TikTokText.Position = UDim2.fromOffset(26, 0)
TikTokText.Size = UDim2.new(1, -30, 1, 0)
TikTokText.BackgroundTransparency = 1
TikTokText.Font = Enum.Font.GothamSemibold
TikTokText.Text = "Scripts en TikTok: @sexyboy.scripts"
TikTokText.TextColor3 = Theme.Text
TikTokText.TextSize = 10
TikTokText.TextXAlignment = Enum.TextXAlignment.Left
TikTokText.Parent = TikTokBanner

local LiveStatsBanner = Instance.new("Frame")
LiveStatsBanner.AnchorPoint = Vector2.new(0.5, 0)
LiveStatsBanner.Position = UDim2.new(0.5, 0, 0, 134)
LiveStatsBanner.Size = UDim2.new(1, -40, 0, 24)
LiveStatsBanner.BackgroundColor3 = Theme.Card
LiveStatsBanner.Parent = LoadingContainer
corner(LiveStatsBanner, 6)
stroke(LiveStatsBanner, Theme.Stroke, 1, 0.4)

local FlameIcon = makeIcon(LiveStatsBanner, Icons.Flame, 14, UDim2.fromOffset(8, 5))
FlameIcon.ImageColor3 = Color3.fromRGB(255, 140, 0)

local LiveStatsText = Instance.new("TextLabel")
LiveStatsText.Position = UDim2.fromOffset(26, 0)
LiveStatsText.Size = UDim2.new(1, -30, 1, 0)
LiveStatsText.BackgroundTransparency = 1
LiveStatsText.Font = Enum.Font.GothamSemibold
LiveStatsText.Text = activeUsersCount .. " personas usando este script ahora mismo"
LiveStatsText.TextColor3 = Theme.SubText
LiveStatsText.TextSize = 10
LiveStatsText.TextXAlignment = Enum.TextXAlignment.Left
LiveStatsText.Parent = LiveStatsBanner

local StatusText = Instance.new("TextLabel")
StatusText.Position = UDim2.new(0, 20, 0, 172)
StatusText.Size = UDim2.new(1, -40, 0, 16)
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.GothamMedium
StatusText.Text = "Cargando módulos..."
StatusText.TextColor3 = Theme.SubText
StatusText.TextSize = 11
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = LoadingContainer

local PercentText = Instance.new("TextLabel")
PercentText.Position = UDim2.new(0, 20, 0, 172)
PercentText.Size = UDim2.new(1, -40, 0, 16)
PercentText.BackgroundTransparency = 1
PercentText.Font = Enum.Font.GothamBold
PercentText.Text = "0%"
PercentText.TextColor3 = Theme.Purple
PercentText.TextSize = 11
PercentText.TextXAlignment = Enum.TextXAlignment.Right
PercentText.Parent = LoadingContainer

local BarTrack = Instance.new("Frame")
BarTrack.Position = UDim2.new(0, 20, 0, 196)
BarTrack.Size = UDim2.new(1, -40, 0, 6)
BarTrack.BackgroundColor3 = Color3.fromRGB(30, 26, 46)
BarTrack.BorderSizePixel = 0
BarTrack.Parent = LoadingContainer
corner(BarTrack, 3)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Theme.Purple
BarFill.BorderSizePixel = 0
BarFill.Parent = BarTrack
corner(BarFill, 3)
gradient(BarFill, Theme.Purple, Color3.fromRGB(184, 105, 255), 0)

----------------------------------------------------
-- AVISO POPUP / MODAL
----------------------------------------------------
local ModalBlur = Instance.new("BlurEffect")
ModalBlur.Size = 0
ModalBlur.Enabled = false
ModalBlur.Parent = Lighting

local ModalOverlay = Instance.new("Frame")
ModalOverlay.Name = "NoticeModalOverlay"
ModalOverlay.Size = UDim2.fromScale(1, 1)
ModalOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ModalOverlay.BackgroundTransparency = 1
ModalOverlay.ZIndex = 100005
ModalOverlay.Visible = false
ModalOverlay.Parent = ScreenGui

local ModalCard = Instance.new("Frame")
ModalCard.AnchorPoint = Vector2.new(0.5, 0.5)
ModalCard.Position = UDim2.fromScale(0.5, 0.5)
ModalCard.Size = UDim2.fromOffset(330, 210)
ModalCard.BackgroundColor3 = Theme.Panel
ModalCard.BackgroundTransparency = 0.05
ModalCard.Parent = ModalOverlay
corner(ModalCard, 14)
stroke(ModalCard, Theme.Stroke, 1.5, 0.1)

local ModalHeader = Instance.new("Frame")
ModalHeader.Size = UDim2.new(1, -20, 0, 36)
ModalHeader.Position = UDim2.fromOffset(10, 10)
ModalHeader.BackgroundTransparency = 1
ModalHeader.Parent = ModalCard

local MTitle = Instance.new("TextLabel")
MTitle.Size = UDim2.new(0.65, 0, 1, 0)
MTitle.Position = UDim2.fromOffset(5, 0)
MTitle.BackgroundTransparency = 1
MTitle.Font = Enum.Font.GothamBold
MTitle.Text = Translations.ES.NoticeTitle
MTitle.TextColor3 = Theme.Text
MTitle.TextSize = 13
MTitle.TextXAlignment = Enum.TextXAlignment.Left
MTitle.Parent = ModalHeader

local FlagList = {
	{ code = "ES", flag = "🇪🇸 ES" },
	{ code = "EN", flag = "🇺🇸 US" },
	{ code = "PT", flag = "🇧🇷 PT" }
}
local currentLangIndex = 1

local FlagBtn = Instance.new("TextButton")
FlagBtn.Size = UDim2.fromOffset(68, 26)
FlagBtn.Position = UDim2.new(1, -70, 0, 4)
FlagBtn.BackgroundColor3 = Theme.Card
FlagBtn.BorderSizePixel = 0
FlagBtn.Font = Enum.Font.GothamSemibold
FlagBtn.Text = FlagList[1].flag
FlagBtn.TextColor3 = Theme.White
FlagBtn.TextSize = 11
FlagBtn.AutoButtonColor = false
FlagBtn.Parent = ModalHeader
corner(FlagBtn, 6)
stroke(FlagBtn, Theme.Stroke, 1, 0.3)

FlagBtn.Activated:Connect(function()
	currentLangIndex = (currentLangIndex % #FlagList) + 1
	local selected = FlagList[currentLangIndex]
	FlagBtn.Text = selected.flag
	updateLanguage(selected.code)
end)

local MMessage = Instance.new("TextLabel")
MMessage.Position = UDim2.fromOffset(15, 52)
MMessage.Size = UDim2.new(1, -30, 0, 90)
MMessage.BackgroundTransparency = 1
MMessage.Font = Enum.Font.Gotham
MMessage.Text = Translations.ES.NoticeMsg
MMessage.TextColor3 = Theme.SubText
MMessage.TextSize = 11
MMessage.TextWrapped = true
MMessage.TextYAlignment = Enum.TextYAlignment.Top
MMessage.Parent = ModalCard

local AcceptBtn = Instance.new("TextButton")
AcceptBtn.Size = UDim2.new(1, -30, 0, 34)
AcceptBtn.Position = UDim2.new(0, 15, 1, -44)
AcceptBtn.BackgroundColor3 = Theme.Purple2
AcceptBtn.AutoButtonColor = false
AcceptBtn.Font = Enum.Font.GothamBold
AcceptBtn.Text = Translations.ES.AcceptBtn
AcceptBtn.TextColor3 = Theme.White
AcceptBtn.TextSize = 11
AcceptBtn.Parent = ModalCard
corner(AcceptBtn, 8)
gradient(AcceptBtn, Theme.Purple, Theme.Purple2, 45)

updateModalLanguage = function(langKey)
	local t = Translations[langKey] or Translations.EN
	MTitle.Text = t.NoticeTitle
	MMessage.Text = t.NoticeMsg
	AcceptBtn.Text = t.AcceptBtn
end

local function showNoticeModal()
	ModalBlur.Enabled = true
	ModalOverlay.Visible = true
	TweenService:Create(ModalBlur, TweenInfo.new(0.3), { Size = 18 }):Play()
	TweenService:Create(ModalOverlay, TweenInfo.new(0.3), { BackgroundTransparency = 0.5 }):Play()
end

local function hideNoticeModal()
	local tw = TweenService:Create(ModalBlur, TweenInfo.new(0.25), { Size = 0 })
	TweenService:Create(ModalOverlay, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
	tw:Play()
	tw.Completed:Connect(function()
		ModalBlur.Enabled = false
		ModalOverlay.Visible = false
	end)
end

AcceptBtn.Activated:Connect(function()
	hideNoticeModal()
end)

----------------------------------------------------
-- EJECUCIÓN DE SECUENCIA DE CARGA
----------------------------------------------------
task.spawn(function()
	local phases = {
		{ progress = 0.25, text = "Actualizando..." },
		{ progress = 0.50, text = "Verificando entidades..." },
		{ progress = 0.75, text = "Inicializando Triggerbot & TeamCheck v2..." },
		{ progress = 0.90, text = "Cargando Aimbot y Movimiento..." },
		{ progress = 1.00, text = "¡Listo Crack!" }
	}
	
	for _, phase in ipairs(phases) do
		StatusText.Text = phase.text
		PercentText.Text = math.floor(phase.progress * 100) .. "%"
		
		local tween = TweenService:Create(BarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(phase.progress, 0, 1, 0)
		})
		tween:Play()
		tween.Completed:Wait()
		task.wait(0.1)
	end
	
	task.wait(0.1)
	
	local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local fadeBackground = TweenService:Create(LoadingGui, fadeInfo, { BackgroundTransparency = 1 })
	local fadeContainer = TweenService:Create(LoadingContainer, fadeInfo, { BackgroundTransparency = 1 })
	
	for _, child in ipairs(LoadingContainer:GetDescendants()) do
		if child:IsA("TextLabel") then
			TweenService:Create(child, fadeInfo, { TextTransparency = 1 }):Play()
		elseif child:IsA("Frame") then
			TweenService:Create(child, fadeInfo, { BackgroundTransparency = 1 }):Play()
		elseif child:IsA("ImageLabel") then
			TweenService:Create(child, fadeInfo, { ImageTransparency = 1 }):Play()
		elseif child:IsA("UIStroke") then
			TweenService:Create(child, fadeInfo, { Transparency = 1 }):Play()
		end
	end
	
	fadeBackground:Play()
	fadeContainer:Play()
	fadeBackground.Completed:Wait()
	LoadingGui:Destroy()
	
	if game.PlaceId == 135856908115931 then
		showNoticeModal()
	end
end)