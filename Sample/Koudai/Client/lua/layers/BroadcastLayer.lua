------------------------------------------------------------------
-- BroadcastLayer.lua
-- Author     : Zonglin Liu
-- Version    : 1.0
-- Date       :   
-- Description: ������㲥
------------------------------------------------------------------

module("BroadcastLayer", package.seeall)


mScene = nil 		-- ����
_count = 0
--�㲥����
--ϵͳ�㲥>��Ϸ�ڲ��㲥>��ҹ㲥

function close()

	if mLayer then
		mLayer:stopAllActions()
	end
	if mList then
		mList:clear()
		mList = nil
	end
	
end

function releaseResource()
mLayer=nil
mList=nil
isfresh=nil
--CCScheduler:unscheduleScriptEntry("BroadcastLayer.refresh")
isHide=nil
end;

function initResource()
	isfresh = false
end;

--һ���㲥�������
function runOver()
	show()
end
function refresh()
	_count = _count+1
	if isfresh and _count%20 == 0 then
		sendAction(9205)
	end
end;

function removeCurrent(layer)
	if layer ~= nil then
		layer:getParent():removeChild(layer, true)
		layer = nil
	end
	if isHide then
		isHide = nil
		hide()
	end
end;

function init(scene)
	
	mScene = scene
	mLayer = CCLayer:create()
	mLayer:setVisible(false)
	creatBg()
--	CCScheduler:sharedScheduler():scheduleScriptFunc("BroadcastLayer.refresh",1,false)	
	return mLayer
end

function creatBg()
	local bgWidth = pWinSize.width
	local bgHeight = pWinSize.height*0.03
	

	--����
	local bgSprite = CCSprite:create(P("common/list_1140.9.png"))
	bgSprite:setScaleX(bgWidth/bgSprite:getContentSize().width)
	bgSprite:setScaleY(bgHeight/bgSprite:getContentSize().height)
	bgSprite:setContentSize(SZ(bgWidth, bgHeight))
	bgSprite:setAnchorPoint(PT(0,0))
	bgSprite:setPosition(PT(0,0))
	mLayer:addChild(bgSprite, 0)
	

	
	--
	local layerSize = SZ(bgWidth, bgHeight)
		--���������С
	mLayer:setContentSize(layerSize)
	
	
	--���ΰ�ť
	local unTouchBtn =  ZyButton:new(Image.image_transparent)
	unTouchBtn:setScaleX(layerSize.width/unTouchBtn:getContentSize().width)
	unTouchBtn:setScaleY(layerSize.height/unTouchBtn:getContentSize().height)
	unTouchBtn:setAnchorPoint(PT(0,0))
	unTouchBtn:setPosition(PT(0,0))
	unTouchBtn:addto(mLayer, 0)
	

	--����list����������ʾ��
	local label=CCLabelTTF:create(Language.IDS_SURE,FONT_NAME,FONT_SM_SIZE)
	local height=label:getContentSize().height
	listSize = SZ(bgWidth*0.95, height)
	local startX = bgWidth*0.5-listSize.width*0.5
	local startY = bgHeight*0.5-listSize.height*0.5
	
	local list = ScutCxList:node(listSize.width, ccc4(24, 24, 24, 0), listSize)
	list:setPosition(PT(startX, startY))
	list:setHorizontal(true)
	list:SetSilence(true)
	mLayer:addChild(list, 0)
	list:setTouchEnabled(true)
	mList = list

	
	--������ʾ��
	listItem = ScutCxListItem:itemWithColor(ccc3(24,24,24))
	listItem:setOpacity(50)
	list:addListItem(listItem, false)	
	list:disableAllCtrlEvent()		

	



	
	currentIndex = 0
	isFirst = 1--�Ƿ��һ���㲥
	
	

	sendAction(9205)
end

function show()
	mLayer:setVisible(true)
	currentIndex = currentIndex+1
	if currentIndex > #mDataTable then
		isHide = true
	--	getNewMessage()
		return
	end
	
	local layer = CCLayer:create()
	local layout = CxLayout()
	layout.val_x.t = ABS_WITH_PIXEL
	layout.val_y.t = ABS_WITH_PIXEL
	layout.val_x.t = 0
	layout.val_y.t = 0
	listItem:addChildItem(layer, layout)
	
	local currentInfo = mDataTable[currentIndex]
	
	local msg = ""
	local isSys = nil
	if currentInfo.BroadcastType == 1 then
		isSys = true
	elseif currentInfo.BroadcastType == 3 then
		if currentInfo.UserName then
			msg = string.format(Language.NOTICE_NAME, currentInfo.UserName)
		end
	end
	
	msg = msg..currentInfo.Content
	msg = string.gsub(msg, "\n", "")
	---
	
	local startX = layer:getContentSize().width*0.95
	if isFirst == 1 then
		startX = 0
	end
	
	local sysLabel = nil
	if isSys then
		local sysStr = string.format(Language.NOTICE_NAME, Language.NOTICE_SYSTEM)
		sysLabel = CCLabelTTF:create(sysStr, FONT_NAME, FONT_SM_SIZE)
		sysLabel:setAnchorPoint(PT(0, 0))
		sysLabel:setPosition(PT(startX, 0))		
		layer:addChild(sysLabel, 0)
		sysLabel:setColor(ZyColor:colorYellow())
		
		startX = startX+sysLabel:getContentSize().width
	end
	

	local label = CCLabelTTF:create(msg, FONT_NAME, FONT_SM_SIZE)
	label:setAnchorPoint(PT(0, 0))
	label:setPosition(PT(startX, 0))		
	layer:addChild(label, 0)

	--�ƶ�����
	local nDistance = label:getContentSize().width+listSize.width
	if isFirst == 1 then
		nDistance = label:getContentSize().width
	end
	if sysLabel then
		nDistance = nDistance+sysLabel:getContentSize().width
	end
		
	local speed = 2--һ���ƶ����ٸ����ֵľ���
	
	
	--�����ƶ����붼Ϊ���ֳ���
	--�����ƶ���Ӧʱ��  Ϊ distance/speed,  ����һ��ʱ   Ϊ ��dostamce-listSize.width��
	
	--���ֳ��ֺ�ͣ��ʱ��
	local waitTime = 2
	
	--�����ƶ�����ʧ������ʱ��
	local nTime = math.floor(nDistance/ZyFont.wideWordWidth(FONT_NAME, FONT_SM_SIZE)/speed)
	
	--����β����ʾʱ��
	local mTime = math.floor((nDistance-listSize.width)/ZyFont.wideWordWidth(FONT_NAME, FONT_SM_SIZE)/speed)	
	if mTime <= 0 then
		mTime = 0.01
	end
	
	

	
	--�����ƶ�
	local action = CCMoveTo:create(nTime, PT(0-nDistance, layer:getPosition().y) )
	--�ȴ����ƶ�����
	local sequence1 = CCSequence:createWithTwoActions(CCDelayTime:create(waitTime), action )
	local sequence2 = CCSequence:createWithTwoActions(sequence1, CCCallFuncN:create(removeCurrent) )
	
	--����β������ʾʱ��Ӧ
	local actionFuncCall = CCCallFuncN:create(runOver)
	local sequence3 = CCSequence:createWithTwoActions( CCDelayTime:create(waitTime+mTime), actionFuncCall)
	
	layer:stopAllActions()
	layer:runAction(sequence2)
	
	label:runAction(sequence3)
	
	isFirst = 0
	
	
	
	
	
	
	
end






function getNewMessage()
	sendAction(9205)
end;

function hide()
	mLayer:setVisible(false)
end;

--��������
function sendAction(actionId)
	if actionId == 9205 then
		isfresh = false
		actionLayer.Action9205(mScene, false)
	end
end


-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionId = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	if actionId == 9205 then
		local serverInfo = actionLayer._9205Callback(pScutScene, lpExternalData)
		if serverInfo ~= nil then
			mDataTable = serverInfo
			currentIndex = 0
			if #mDataTable > 0 then
				isfresh = false
				show()
			else
				isfresh = true
			end
		else
			isfresh = true	
		end
	elseif actionId == 2 then


	end
end