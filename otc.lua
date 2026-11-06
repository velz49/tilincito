-- ============================================================
-- SEXYBOY SCRIPTS

local BASE_URL = "https://velzarscripts.pages.dev"
local SCRIPT_ID = "otc" 
local function httpRequest(opts)
    local f = (syn and syn.request) or http_request or (http and http.request) or request
    if not f then error("Tu executor no soporta requests HTTP.") end
    return f(opts)
end

local function getHWID()
    local ok, id = pcall(function()
        if gethwid then return gethwid() end
        if syn and syn.get_hwid then return syn.get_hwid() end
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and id then return tostring(id) end
    return "unknown-" .. tostring(math.random(100000, 999999))
end

-- R
local function rc4(dataBytes, key)
    local S = {}
    for i = 0, 255 do S[i] = i end
    local j = 0
    local keyLen = #key
    for i = 0, 255 do
        j = (j + S[i] + string.byte(key, (i % keyLen) + 1)) % 256
        S[i], S[j] = S[j], S[i]
    end
    local out = {}
    local i2, j2 = 0, 0
    for n = 1, #dataBytes do
        i2 = (i2 + 1) % 256
        j2 = (j2 + S[i2]) % 256
        S[i2], S[j2] = S[j2], S[i2]
        local k = S[(S[i2] + S[j2]) % 256]
        out[n] = string.char(bit32.bxor(string.byte(dataBytes, n), k))
    end
    return table.concat(out)
end

local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function base64Decode(data)
    data = string.gsub(data, "[^" .. b64chars .. "=]", "")
    return (data:gsub(".", function(x)
        if x == "=" then return "" end
        local r, f = "", (b64chars:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0") end
        return r
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if #x ~= 8 then return "" end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0) end
        return string.char(c)
    end))
end

local function main()
    local hwid = getHWID()
    local Http = game:GetService("HttpService")

    -- sdf
    local authRes = httpRequest({
        Url = BASE_URL .. "/api/auth",
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = Http:JSONEncode({ hwid = hwid, script = SCRIPT_ID }),
    })
    local authData = Http:JSONDecode(authRes.Body)
    if not authData.token then
        error("[Velzar] No se pudo autenticar: " .. tostring(authData.error))
    end

    -- lolo
    local payloadRes = httpRequest({
        Url = BASE_URL .. "/api/payload?t=" .. authData.token,
        Method = "GET",
    })
    local payloadData = Http:JSONDecode(payloadRes.Body)
    if not payloadData.payload then
        error("[Velzar] No se pudo obtener el script: " .. tostring(payloadData.error))
    end

    -- watt
    local encryptedBytes = base64Decode(payloadData.payload)
    local sourceCode = rc4(encryptedBytes, authData.token)

    local fn, err = loadstring(sourceCode)
    if not fn then error("[Velzar] Error al cargar el script: " .. tostring(err)) end
    fn()
end

local ok, err = pcall(main)
if not ok then warn("[Velzar Scripts] " .. tostring(err)) end
