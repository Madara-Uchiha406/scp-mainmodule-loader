local HttpService = game:GetService("HttpService")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local MODULE_URL = "https://ton-serveur.com/module.lua"
local assetsFolder = ServerStorage:WaitForChild("MainModuleAssets")

local function loadRemoteModule(url)
	local ok, source = pcall(function()
		return HttpService:GetAsync(url, true)
	end)

	if not ok or type(source) ~= "string" or source == "" then
		warn("[SCP Loader] Échec du téléchargement du module :", source)
		return nil
	end

	local chunk, compileErr = loadstring(source)
	if not chunk then
		warn("[SCP Loader] Erreur de compilation Lua :", compileErr)
		return nil
	end

	local runOk, result = pcall(chunk)
	if not runOk then
		warn("[SCP Loader] Erreur d'exécution du chunk :", result)
		return nil
	end

	return result
end

local remoteModule = loadRemoteModule(MODULE_URL)
if type(remoteModule) == "table" and type(remoteModule.Init) == "function" then
	remoteModule.Init(assetsFolder)
else
	warn("[SCP Loader] Module invalide ou fonction Init manquante.")
end
