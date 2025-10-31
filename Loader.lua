-- ================================
--   EXPLOIT-OPTIMIZED GAME LOADER
-- ================================
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local GameDetector = {}

local Games = {
    ["3008"] = {
        placeIds = {2768379856},
        keywords = {"3008"},
        url = "https://bleu.rip/scripts/Anthrax_3008.txt"
    },
    ["steal"] = {
        placeIds = {109983668079237},
        keywords = {"brainrot"},
        url = "https://bleu.rip/scripts/Anthrax_stealabrainrot.txt"
    },
    ["blockspin"] = {
        placeIds = {104715542330896},
        keywords = {"blockspin"},
        url = "https://bleu.rip/scripts/Anthrax_Blockspin.txt"
    },
    ["airsoftfe"] = {
        placeIds = {292439477},
        keywords = {"phantom"},
        url = "https://bleu.rip/scripts/Anthrax_AirsoftFE.txt"
    },
    ["badbusiness"] = {
        placeIds = {1168263273},
        keywords = {"bad business"},
        url = "https://raw.githubusercontent.com/your-repo/scripts/main/badbusiness.lua"
    },
    ["mm2"] = {
        placeIds = {142823291},
        keywords = {"murder mystery"},
        url = "https://raw.githubusercontent.com/your-repo/scripts/main/mm2.lua"
    },
    ["shootplayers"] = {
        placeIds = {11124905486},
        keywords = {"shoot players"},
        url = "https://bleu.rip/scripts/Anthrax_ShootPeopleOffamap.txt"
    },
    ["fish"] = {
        placeIds = {},
        keywords = {"fish"},
        url = "https://raw.githubusercontent.com/your-repo/scripts/main/fish.lua"
    },
    ["airsoft"] = {
        placeIds = {},
        keywords = {"airsoft"},
        url = "https://raw.githubusercontent.com/your-repo/scripts/main/airsoftfe.lua"
    }
}


-- ======================
-- Detect Game Function
-- ======================
function GameDetector.detect()
    local id = game.PlaceId
    
    -- Check PlaceId first
    for gameName, gameData in pairs(Games) do
        for _, placeId in pairs(gameData.placeIds) do
            if placeId == id then
                return gameData.url
            end
        end
    end

    -- Fallback to name detection
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(id)
    end)

    if success and info and info.Name then
        local lowerName = info.Name:lower()
        for gameName, gameData in pairs(Games) do
            for _, keyword in pairs(gameData.keywords) do
                if string.find(lowerName, keyword) then
                    return gameData.url
                end
            end
        end
    end

    return nil
end

-- ======================
-- Load Game Script
-- ======================
function GameDetector.load()
    local scriptUrl = GameDetector.detect()
    
    if not scriptUrl then
        print("[❌] Game not recognized. PlaceId: " .. game.PlaceId)
        return false
    end

    local success, err = pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)



    return success
end

-- ======================
-- Manual Mapping Support
-- ======================
function GameDetector.add(gameName, placeId, url, keywords)
    if not Games[gameName] then
        Games[gameName] = {
            placeIds = {},
            keywords = keywords or {},
            url = url
        }
    end
    
    if placeId then
        table.insert(Games[gameName].placeIds, placeId)
    end
    
    if url then
        Games[gameName].url = url
    end
end

-- ======================
-- Auto-Execute
-- ======================
function GameDetector.auto()
    return GameDetector.load()
end

-- Auto-run the detector
GameDetector.load()

return GameDetector
