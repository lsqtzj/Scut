------------------------------------------------------------------
--PushReceiverLayer.lua
-- Author     : JMChen
-- Version    : 1.0.0.0
-- Date       : 2011-10-15
-- Description:
------------------------------------------------------------------


module("PushReceiverLayer", package.seeall)


--����������֪ͨ�ص�
function PushReceiverCallback(pScutScene, lpExternalData)

	local actionId = ScutDataLogic.CNetReader:getInstance():getActionID()
	local result = ScutDataLogic.CNetReader:getInstance():getResult()
	
	if actionId==1001 then
	    
	        local box = ZyMessageBoxEx:new()
            box:doPrompt(pScutScene, nil, actionId, "OK")
		--local table =  testScene._1001Callback(pScutScene, lpExternalData);
        --if table then
            --testScene.update(table.RecordTabel)--��������
		--end	
	end
	--]]
end