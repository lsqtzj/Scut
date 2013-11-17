
-- SbattleScene.lua.lua
-- Author     :Lysong
-- Version    : 1.0.0.0
-- Date       :
-- Description:
------------------------------------------------------------------

module("SbattleScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

local mScene= nil 
local mLayer=nil
local fightinfo={}

--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��



-- �������
function init(info)
	 initResource()
	 createScene(info)
end


-- �˳�����
function closeScene()
	releaseResource()
	fightinfo={}
	CCDirector:sharedDirector():popScene()
end

--
-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()
end

-- �ͷ���Դ
function releaseResource()
end
-- ��������
function createScene(info)
	local scene = ScutScene:new()
	-- ע������ص�
	scene:registerCallback(networkCallback)
	mScene = scene.root
	CCDirector:sharedDirector():pushScene(mScene)
	fightinfo=info
	-- ��ӱ���
	mLayer = CCLayer:create()
	mScene:addChild(mLayer, 0)
	
	-- �˴���ӳ�����ʼ����
	--���ΰ�ť
	local actionBtn=UIHelper.createActionRect(pWinSize)
	actionBtn:setPosition(PT(0,0))
	mLayer:addChild(actionBtn,0)
	
	local image  = string.format("map/%s.jpg",fightinfo.BgScene)
	local imageBg = CCSprite:create(P(image))
	imageBg:setScaleX(pWinSize.width/imageBg:getContentSize().width)
	imageBg:setScaleY(pWinSize.height/imageBg:getContentSize().height)
	imageBg:setAnchorPoint(PT(0,0))
	imageBg:setPosition(PT(0,0))
	mLayer:addChild(imageBg, 0)	
	
	fightLayer = mLayer
	
	local battleType = 5
	local IsOverCombat = nil--1����
	PlotFightLayer.setFightInfo(fightinfo,IsOverCombat,battleType)
	
	PlotFightLayer.init(fightLayer)
	
end

--���Ŷ���  ʤ��/ʧ��
function playAnimation(skill, index, tag)
	local attribuAni=ScutAnimation.CScutAnimationManager:GetInstance():LoadSprite(skill)
	if index then
		attribuAni:setCurAni(index)
	end
	if tag then
		attribuAni:setTag(tag)
	end
	attribuAni:play()
	attribuAni:registerFrameCallback("SbattleScene.finishAnimation")
	mLayer:addChild(attribuAni, 4)
	attribuAni:setPosition(PT(pWinSize.width*0.5, pWinSize.height*0.5))

end

--����������ɺ� 
function finishAnimation(pSprite, curAniIndex, curFrameIndex, nPlayingFlag)
	if nPlayingFlag == 2 then
		pSprite:registerFrameCallback("")
		delayRemove(pSprite)
--		battleOver()
	end
end

function delayRemove(sprite)
	if sprite ~= nil then
		local delayAct = CCDelayTime:create(0.1)
		local funcName = CCCallFuncN:create(SbattleScene.removeTmpSprite)
		local act = CCSequence:createWithTwoActions(delayAct,funcName)
		sprite:runAction(act)
		sprite = nil
	end
	
end

function removeTmpSprite(sprite)
	local tag = sprite:getTag()
	if sprite ~= nil then
		sprite:removeFromParentAndCleanup(true)
		sprite = nil
	end
    
    	
	if tag == 1 then
		closeFightLayer()
		PersonalInfo.getPersonalInfo().Shengjita=0
        	TrialScene.init()
	elseif tag == 2 then
		closeFightLayer()
		SBattleResult.createScene(PersonalInfo.getPersonalInfo().Score,PersonalInfo.getPersonalInfo().StarNum)
	end
end

function roundOver(info)
    PersonalInfo.getPersonalInfo().Score=info.Score
    PersonalInfo.getPersonalInfo().StarNum=info.StarNum
    isWin = false
	if info.IsWin == 0 then--ʧ��
		playAnimation("donghua_1002_2", nil, 1)
	elseif info.IsWin == 1 then--�ɹ�
		isWin = true
		playAnimation("donghua_1002_1", nil, 2)
	end
end

function closeFightLayer()
	if fightLayer then
		fightLayer:getParent():removeChild(fightLayer, true)
		fightLayer = nil
	end
	closeScene()
	PlotFightLayer.releaseResource()
end;

-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionId = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	
	
	
end