--
-- CommandDataResove.lua.lua
-- 
--


module("CommandDataResove", package.seeall)



local progressLabel = nil
local unzipLabel = nil	

--��Դ������
function resourceUpdated(pScutScene, nTag)
   
end

function mbo_resourceUpdated()
    CCDirector:sharedDirector():endToLua();
end