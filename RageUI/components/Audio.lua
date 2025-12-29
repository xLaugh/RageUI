local _PlaySoundFrontend = PlaySoundFrontend
local _GetSoundId = GetSoundId
local _StopSound = StopSound
local _ReleaseSoundId = ReleaseSoundId

-- Cache pour le son loopé
local loopedAudioId = nil
local loopedAudioBusy = false

---PlaySound - Optimisé
---@param Library string
---@param Sound string
---@param IsLooped boolean
---@return nil
---@public
function RageUI.PlaySound(Library, Sound, IsLooped)
    if not IsLooped then
        _PlaySoundFrontend(-1, Sound, Library, true)
    else
        if not loopedAudioBusy then
            loopedAudioBusy = true
            Citizen.CreateThread(function()
                loopedAudioId = _GetSoundId()
                _PlaySoundFrontend(loopedAudioId, Sound, Library, true)
                Citizen.Wait(1)
                _StopSound(loopedAudioId)
                _ReleaseSoundId(loopedAudioId)
                loopedAudioId = nil
                loopedAudioBusy = false
            end)
        end
    end
end
