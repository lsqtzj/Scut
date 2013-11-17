------------------------------------------------------------------
-- RoleDetailScene.lua
-- Author     : Zonglin Liu
-- Version    : 1.0
-- Date       :   
-- Description: 
------------------------------------------------------------------

module("RoleDetailScene", package.seeall)


mScene = nil 		-- ����



-- �������
function pushScene()
	initResource()
	createScene()
	
end

-- �˳�����
function popScene()
	releaseResource()
	
end

--
-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()

end

-- �ͷ���Դ
function releaseResource()
	mLayer = nil
	mScene = nil
end

-- ��������
function createScene()
	local scene = ScutScene:new()
	mScene = scene.root
		mScene:registerScriptHandler(SpriteEase_onEnterOrExit)
	runningScene = CCDirector:sharedDirector():getRunningScene()
	if runningScene == nil then
		CCDirector:sharedDirector():runWithScene(mScene)
	else
		 SlideInLReplaceScene(mScene)
	end
	MainScene.releaseResource()

	-- ע������ص�
	scene:registerCallback(networkCallback)
	
	-- �������
	mLayer= CCLayer:create()
	mScene:addChild(mLayer, 0)


	--��������
	local bgLayer = UIHelper.createUIBg(nil,"",ZyColor:colorYellow(),"RoleDetailScene.popScene")
	mLayer:addChild(bgLayer,0)

	-- �˴���ӳ�����ʼ����
	
end


function SpriteEase_onEnterOrExit (tag)
    if tag == "exit" then
        releaseResource()
    end
end


--��������
function sendActionId(actionId)
	if actionId == 1 then


	elseif actionId == 2 then


	end

end

-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionId = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	if actionId == 1 then


	elseif actionId == 2 then


	end
end