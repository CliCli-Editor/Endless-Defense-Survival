local SoundManager = class("SoundManager")

function SoundManager:ctor()
    self._bgm = nil
    self._bgmVolume = 50
    self._soundList = {}
end

function SoundManager:playBGM(bgmId)
    self._bgm:stop(y3.player(y3.gameApp:getMyPlayerId()))
    local options = { loop = true, fade_in = 1, fade_out = 1 }
    self._bgm = y3.sound.play(y3.player(y3.gameApp:getMyPlayerId()), bgmId, options)
    self._bgm:set_volume(y3.player(y3.gameApp:getMyPlayerId()), self._bgmVolume)
end

function SoundManager:setBgmVolume(volume)
    self._bgmVolume = volume
    if self._bgm then
        self._bgm:set_volume(y3.player(y3.gameApp:getMyPlayerId()), self._bgmVolume)
    end
end

function SoundManager:getBgmVolume()
    return self._bgmVolume
end

function SoundManager:stopBGM()
    if self._bgm then
        self._bgm:stop(y3.player(y3.gameApp:getMyPlayerId()))
    end
end

function SoundManager:playSound(soundId)
end

return SoundManager
