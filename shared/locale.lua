--[[
════════════════════════════════════════════════════════════════════════════════════════════════
    
    🐺 LXR Poker V2.0 - Localization System
    
    Multi-language translation system for poker interface and notifications
    
════════════════════════════════════════════════════════════════════════════════════════════════
]]

Locale = {}
Locale.Languages = {}
Locale.Current = Config.Lang or 'en'

--[[
    Register a language
    @param lang string Language code (e.g., 'en', 'ka', 'es')
    @param translations table Translation strings
]]
function Locale.Register(lang, translations)
    Locale.Languages[lang] = translations
end

--[[
    Get translated string
    @param key string Translation key
    @param ... arguments for string.format
    @return string Translated text
]]
function Locale.Get(key, ...)
    local translations = Locale.Languages[Locale.Current] or Locale.Languages['en']
    if not translations then
        return 'MISSING LANGUAGE: ' .. Locale.Current
    end
    
    local text = translations[key]
    if not text then
        return 'MISSING TRANSLATION: ' .. key
    end
    
    if select('#', ...) > 0 then
        return string.format(text, ...)
    end
    
    return text
end

-- Shorthand function
function L(key, ...)
    return Locale.Get(key, ...)
end

-- Set language dynamically
function Locale.SetLanguage(lang)
    if Locale.Languages[lang] then
        Locale.Current = lang
        return true
    end
    return false
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ LOCALE SYSTEM INITIALIZED █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
