------------------------------------------------------------------
-- spriteBlessLayer.lua.lua
-- Author     : 	Chenjp

-- Version    : 1.0
-- Date       :
-- Description: ����ף��ϵͳ
------------------------------------------------------------------

module("spriteBlessLayer", package.seeall)

--require("layers.MainMenuLayer")
--require("scene.MainScene")

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд


--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��

 local pMainScene=nil
--
-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()
	info=nil
	rewardsLayer =nil
	wizardLayer=nil
end
-- �ͷ���Դ
function releaseResource()
	pMainScene=nil
	info=nil
	rewardsLayer =nil
	wizardLayer=nil
	wizardSprite=nil
	ScutAnimation.CScutAnimationManager:GetInstance():UnLoadSprite("donghua_1009")
end

function stopMove(node)
    if wizardSprite then
	local moveX=math.random(0,pWinSize.width-wizardSprite:getContentSize().width)
	local moveY=0
	node:setPosition(PT(moveX,moveY))
	local moveX=math.random(0,pWinSize.width-wizardSprite:getContentSize().width)
	local moveY=pWinSize.height-wizardSprite:getContentSize().height
	local move_time=30
	local moveAct = CCMoveTo:create(move_time,PT(moveX,moveY));
	local fun=CCCallFuncN:create(spriteBlessLayer.stopMove)
	local action=CCSequence:createWithTwoActions(moveAct,fun)
	node:runAction(action)	
	end
end;

--Ʈ���ľ���
function  createActionLayer(scene,num)
	if  wizardLayer or not scene or not num or num<=0 then
	    return
	end
	pMainScene=scene
	wizardLayer=CCLayer:create()
	mAnimationLayer=wizardLayer
	pMainScene:addChild(wizardLayer, 2)
	
	wizardSprite=ScutAnimation.CScutAnimationManager:GetInstance():LoadSprite("donghua_1009")
	wizardSprite:setCurAni(0)
	wizardSprite:play()	
		
	wizardSprite:setAnchorPoint(PT(0,0))
	local startX=math.random(0,pWinSize.width)
	local startY=math.random(0,pWinSize.height)
	wizardSprite:setPosition(PT(startX,startY))
	wizardLayer:addChild(wizardSprite,0)
	
	
	
	local btn = UIHelper.createActionRect(wizardSprite:getContentSize(),MainScene.getRewards)
	btn:setPosition(PT(-wizardSprite:getContentSize().width*0.5,0))
	wizardSprite:addChild(btn, 0)
	

	local moveX=math.random(0,pWinSize.width-wizardSprite:getContentSize().width)
	local moveY=pWinSize.height-wizardSprite:getContentSize().height
	local move_time=30
	local moveAct = CCMoveTo:create(move_time,PT(moveX,moveY));
	local fun=CCCallFuncN:create(stopMove)
	local action=CCSequence:createWithTwoActions(moveAct,fun)
	wizardSprite:runAction(action)
end;



--����������ɺ�  ��ʾף������
function finishAnimation(pSprite, curAniIndex, curFrameIndex, nPlayingFlag)
	if nPlayingFlag == 1 then
		pSprite:registerFrameCallback("")
		delayRemove(pSprite)
	end
end

function delayRemove(sprite)
	if sprite ~= nil then
		local delayAct = CCDelayTime:create(2)
		local funcName = CCCallFuncN:create(spriteBlessLayer.removeTmpSprite)
		local act = CCSequence:createWithTwoActions(delayAct,funcName)
		sprite:runAction(act)
		sprite = nil
	end
	
end

function removeTmpSprite(sprite)
    if sprite ~= nil then
        sprite:removeFromParentAndCleanup(true)
        sprite = nil
    end
    
    showRewards()
end

--����ף������
function showRewards()
	
	if info then
		
		--Ů��ͼ
		local girlSprite=CCSprite:create(P("common/list_4000_2.png"))
		girlSprite:setAnchorPoint(PT(0,0))
		rewardsLayer:addChild(girlSprite, 1)
		
		--������
		local bgSprite = CCSprite:create(P("common/list_4000_1.9.png"))
		bgSprite:setScaleX(pWinSize.width/bgSprite:getContentSize().width)
		bgSprite:setScaleY(girlSprite:getContentSize().height*0.9/bgSprite:getContentSize().height)
		bgSprite:setAnchorPoint(PT(0.5,0.5))
		bgSprite:setPosition(PT(pWinSize.width/2,pWinSize.height/2))
		rewardsLayer:addChild(bgSprite, 0)
		
		girlSprite:setPosition(PT(0,bgSprite:getPosition().y-girlSprite:getContentSize().height*0.9/2+SY(2)))
		
		if info.RewardInfo and info.Num then
			--��������
			rewardsStr = CCLabelTTF:create(Language.SPRITE_REWARDS1 ..info.RewardInfo.."*"..info.Num, FONT_NAME, FONT_SM_SIZE)
			rewardsStr:setAnchorPoint(PT(0.5,0))
			rewardsStr:setPosition(PT(pWinSize.width/2,bgSprite:getPosition().y+girlSprite:getContentSize().height*0.9/2-rewardsStr:getContentSize().height*2))
			rewardsLayer:addChild(rewardsStr, 0)
		end;
		
		if  info.HeadID then
			--����ͷ��
			local image=string.format("smallitem/%s.png",info.HeadID)
			rewardSprite= creatItem(image, nil, nil, 3)	
			rewardSprite:setAnchorPoint(PT(0.5,0))
			rewardSprite:setPosition(PT(pWinSize.width/2,rewardsStr:getPosition().y-rewardSprite:getContentSize().height))
			rewardsLayer:addChild(rewardSprite,0)
			
			--��������
			rewardsNum = CCLabelTTF:create(info.Num, FONT_NAME, FONT_SM_SIZE)
			rewardsNum:setAnchorPoint(PT(0.5,0))
			rewardSprite:setPosition(PT(pWinSize.width/2,rewardSprite:getPosition().y-rewardsNum:getContentSize().height*1.1))
			rewardsLayer:addChild(rewardsNum, 0)
			--������
			--local rewardSprite = creatItem(image, nil, info.Num, 1)	
		end;
		delayExec(spriteBlessLayer.exitRewards,2)
	end;
end;

--�����Ʒͼ��
function creatItem(image, quality)
	local imageBg = getQualityBg(quality, 1)
	local menuItem = CCMenuItemImage:create(P(imageBg), P(imageBg))
	local btn = CCMenu:createWithItem(menuItem)
	
	menuItem:setAnchorPoint(PT(0.5,0))
	if menberCallBack then 
	    menuItem:registerScriptTapHandler(menberCallBack)
	end 
	if tag then
		menuItem:setTag(tag)
	end
	btn:setContentSize(SZ(menuItem:getContentSize().width, menuItem:getContentSize().height))
	
	--Ӷ��ͷ��
	if image then
		local imageLabel = CCMenuItemImage:create(P(image),P(image))
		if imageLabel == nil then
			 return btn 
		end
		imageLabel:setAnchorPoint(PT(0.5,0))
		imageLabel:setPosition(PT(menuItem:getContentSize().width*0.5,menuItem:getPosition().y+SY(3)))
		menuItem:addChild(imageLabel,0)
	end
	
	return btn
end;

function exitRewards()
	if rewardsLayer  then
		pMainScene:removeChild(rewardsLayer,true)
	end;
	ScutAnimation.CScutAnimationManager:GetInstance():UnLoadSprite("donghua_1010")
	releaseResource()
	MainMenuLayer.refreshWin()
	--if PersonalInfo:getPersonalInfo()._WizardNum>0  then
		--MainScene.createAccelerometer()
	--end;
end;

function sendAction(actionId)
	if  actionId==3013 then
	
		actionLayer.Action3013(pMainScene, nil)
	end
end;

---�ӳٽ��з���
function delayExec(funName,nDuration)
	local action = CCSequence:createWithTwoActions(
	CCDelayTime:create(nDuration),
	CCCallFunc:create(funName));
	if wizardLayer then
		wizardLayer:runAction(action)
	end
end

-- ����ص�
function _3013Callback(pScutScene, lpExternalData)
	local actionId = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	if actionId ==3013  then
		local serverInfo = actionLayer._3013Callback(pScutScene, lpExternalData)
		if serverInfo then 
		    info=serverInfo
            --showRewards()
            
            --������������
            if wizardSprite and wizardLayer then
                ScutAnimation.CScutAnimationManager:GetInstance():UnLoadSprite("donghua_1009")
                wizardLayer:removeChild(wizardSprite,true)
            end;
            
            	rewardsLayer=CCLayer:create()
		pMainScene:addChild(rewardsLayer,30)
		
		local untouch = UIHelper.createActionRect(pWinSize)
		untouch:setPosition(PT(0,0))
		rewardsLayer:addChild(untouch, 0)
            
            
            local rewardSprite=ScutAnimation.CScutAnimationManager:GetInstance():LoadSprite("donghua_1010")
            rewardSprite:play()
            rewardSprite:registerFrameCallback("spriteBlessLayer.finishAnimation")
            rewardSprite:setPosition(PT(pWinSize.width*0.5,0))    
            wizardLayer:addChild(rewardSprite, 0)
		end	
	end
end;
