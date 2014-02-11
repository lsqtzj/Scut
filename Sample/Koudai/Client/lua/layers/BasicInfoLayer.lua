------------------------------------------------------------------
-- BasicInfoLayer.lua
-- Author     : Zonglin Liu
-- Version    : 1.0
-- Date       :   
-- Description: 
------------------------------------------------------------------

module("BasicInfoLayer", package.seeall)


mScene = nil 		-- ����



-- �������
function pushScene()
	initResource()
	createScene()
	
end

-- �˳�����
function popScene()
	releaseResource()
	MainScene.init()
end



--
-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()

end

-- �ͷ���Դ
function releaseResource()
	if infoLayer ~= nil then
		infoLayer:getParent():removeChild(infoLayer, true)
		infoLayer = nil
	end
	 CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(schedulerEntry1)
end

-- ��������
function createScene()
	local scene = ScutScene:new()
	mScene = scene.root
	runningScene = CCDirector:sharedDirector():getRunningScene()
	if runningScene == nil then
		CCDirector:sharedDirector():runWithScene(mScene)
	else
		 SlideInLReplaceScene(mScene,1)
	end
	--MainScene.releaseResource()
    
	-- ע������ص�
	scene:registerCallback(networkCallback)
	mScene = scene.root
	-- �������
	mLayer= CCLayer:create()
	mScene:addChild(mLayer, 0)


	--��������
	local bgLayer = UIHelper.createUIBg(nil,"",ZyColor:colorYellow(),BasicInfoLayer.popScene)
 	mLayer:addChild(bgLayer,0)
	

	-- �˴���ӳ�����ʼ����
	manInfo()

	sendActon(1008)
end




function manInfo()

---[[
	if infoLayer ~= nil then
		infoLayer:getParent():removeChild(infoLayer, true)
		infoLayer = nil
	end
	
	local layer = CCLayer:create()
	mLayer:addChild(layer, 0)
	infoLayer = layer
	--]]
--	local layer = mLayer
--------------------����
	local topSprite=CCSprite:create(P("title/list_1112.png"))
	topSprite:setAnchorPoint(PT(0.5,0))
	topSprite:setPosition(PT(pWinSize.width/2,
								pWinSize.height*0.97-topSprite:getContentSize().height))
	layer:addChild(topSprite,0)

	---�м�ı���
	local posY=topSprite:getPosition().y
	local boxSize=SZ(pWinSize.width*0.9,pWinSize.height*0.8)
	local bgSprite=CCSprite:create(P("common/list_1038.9.png"))
	bgSprite:setScaleX(boxSize.width/bgSprite:getContentSize().width)
	bgSprite:setScaleY(boxSize.height/bgSprite:getContentSize().height)
	bgSprite:setAnchorPoint(PT(0.5,0))
	bgSprite:setPosition(PT(pWinSize.width/2,posY-boxSize.height))
	layer:addChild(bgSprite,0)
	
	local midSize=SZ(pWinSize.width*0.8,pWinSize.height*0.5)
	local midSprite=CCSprite:create(P("common/list_1052.9.png"))
	midSprite:setScaleY(midSize.height/midSprite:getContentSize().height)
	midSprite:setAnchorPoint(PT(0.5,0))
	midSprite:setPosition(PT(pWinSize.width/2,bgSprite:getPosition().y+boxSize.height*0.95-midSize.height))
	layer:addChild(midSprite,0)
	
	local height = midSprite:getPosition().y+midSize.height*0.9
	local startX =midSprite:getPosition().x-midSprite:getContentSize().width*0.45

	local space = SY(5)
	
	local personInfo = PersonalInfo.getPersonalInfo()
	
	--��ʿ����
	local name = creatLabel(layer, Language.BASICE_NAME, personInfo._NickName, startX, height)
	
--	 personInfo._VipLv = 1
	--vip�ȼ�ͼƬ
	if personInfo._VipLv and personInfo._VipLv > 0 and personInfo._VipLv <= 10 and isShowVip() then
		imagePath = string.format("button/vip_%s.png", personInfo._VipLv)
		local topSprite=CCSprite:create(P(imagePath))
		topSprite:setAnchorPoint(PT(0,0.5))
		topSprite:setPosition(PT(pWinSize.width/2,height+name:getContentSize().height*0.5))
		layer:addChild(topSprite,0)			
	end	
	
	space = name:getContentSize().height+space
	height = height-space
	
	
	

	
	--�ȼ�
	creatLabel(layer, Language.BASICE_LEVEL, personInfo._UserLv, startX, height)
	height = height-space

	--����Ӷ��
	creatLabel(layer, Language.BASICE_INGROUP, (personInfo._BattleNum or 0) .."/"..(personInfo._TotalBattle or 0) , startX, height)	
	height = height-space

	--��ʯ
	creatLabel(layer, Language.IDS_JINGSHI, personInfo._GoldNum, startX, height)
	height = height-space
	
	--���
	creatLabel(layer, Language.IDS_GOLD, personInfo._GameCoin, startX, height)
	height = height-space
	
	--����
	creatLabel(layer, Language.IDS_SPRITE, personInfo._EnergyNum.."/"..personInfo._MaxEnergyNum, startX, height)
	height = height-space
	
	--����
	creatLabel(layer, Language.BASICE_YUELI, personInfo._UserExp, startX, height)
	height = height-space
	
	--����
	creatLabel(layer, Language.BASICE_HENOUR, (personInfo._HonourNum or 0).."/"..(personInfo._NextHonourNum or 0), startX, height)
	height = height-space	
	
	--��һ�������ָ�
	_nextTime = PersonalInfo.getPersonalInfo()._Rstore
	local nextTime = Language.IDS_NONE
	if _nextTime and _nextTime > 0 then
		nextTime = getTimeStr(_nextTime)
	else
		_nextTime = nil		
	end-- 
	local name,nextLabel = creatLabel(layer, Language.BASICE_NEXT, nextTime, startX, height)	
	_nextLabel = nextLabel
	height = height-space

	--ȫ�������ָ�
	_allTime = PersonalInfo.getPersonalInfo()._TotalRstore
	local allTime = Language.IDS_NONE
	if _allTime and _allTime > 0 then
		nextTime = getTimeStr(_allTime)
	else
		_allTime = nil
	end	
	local name,allLabel = creatLabel(layer, Language.BASICE_ALL, allTime, startX, height)	
	_allLabel = allLabel

	

	local topBtn=ZyButton:new("button/list_1023.png",nil,nil,Language.TOPUP_VIPLOOK)
	topBtn:registerScriptHandler(moreVipAction)
	topBtn:setAnchorPoint(PT(0,0))
	topBtn:setPosition(PT(pWinSize.width*0.5-topBtn:getContentSize().width*0.5, pWinSize.height*0.2))	
	if isShowVip() then
		topBtn:addto(layer, 0)
	end
	 schedulerEntry1 = 	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(timer, 1, false)
--	CCScheduler:sharedScheduler():scheduleScriptFunc("BasicInfoLayer.timer", 1, false)
end

--��������
function creatLabel(parent, fitstName, secondName, x, y)
	if fitstName == nil then
		fitstName = ""
	end
	local firstLabel=CCLabelTTF:create(fitstName..": ",FONT_NAME,FONT_SM_SIZE)
	firstLabel:setAnchorPoint(PT(0,0))
	local color = ZyColor:colorYellow()
	if color~=nil then
		firstLabel:setColor(color)
	end
	firstLabel:setPosition(PT(x, y))
	parent:addChild(firstLabel,0)
	
	if secondName == nil then
		secondName = ""
	end
	local secondLabel=CCLabelTTF:create(secondName,FONT_NAME,FONT_SM_SIZE)
	secondLabel:setAnchorPoint(PT(0,0))
	secondLabel:setPosition(PT(firstLabel:getPosition().x+firstLabel:getContentSize().width, firstLabel:getPosition().y))
	parent:addChild(secondLabel,0)	
	
	return firstLabel,secondLabel
end

function getTimeStr(_time)
	local timeStr = ""
	
	if _time > 3600*24 then
		local day = math.floor(_time/3600/24)--��
		if day > 0 then
			timeStr = timeStr..string.format(Language.BASICE_DAY,day)
		end
	end
	local time = _time%(3600*24)
	timeStr = timeStr..formatTime(time)
	
	return timeStr
end

function timer()

	local isRefresh = false--�Ƿ�ˢ��

	if _nextTime then
		_nextTime = _nextTime-1
		if _nextTime > 0 then
			if _nextLabel and _nextTime then
			_nextLabel:setString(getTimeStr(_nextTime))
			end
		else
			isRefresh = true
		end
	end
	if _allTime then
		_allTime = _allTime-1
		if _allTime > 0 then
			if _allLabel then
				_allLabel:setString(getTimeStr(_allTime))
			end
		else
			isRefresh = true
		end		
	end
		
	if isRefresh then
		sendActon(1008)
	end		
end

----��תVIP
function moreVipAction()
	VIPScene.pushScene(mScene)
end

function sendActon(actionId)
	if actionId == 1008 then
		actionLayer.Action1008(mScene, nil)
	end
end;

-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionId = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	if actionId == 1008 then
		serverInfo = actionLayer._1008Callback(pScutScene, lpExteralData)
		if serverInfo ~= nil then
			PersonalInfo.setPersonalInfo(serverInfo)
			manInfo()
		end
	end
end