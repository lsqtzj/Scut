------------------------------------------------------------------
-- ItemListLayer.lua
-- Author     : Zonglin Liu
-- Version    : 1.0
-- Date       :   
-- Description: �������꼼��Ӷ��ѡ���б�
------------------------------------------------------------------

module("ItemListLayer", package.seeall)


local weapType={
[4]=2,
[5]=5,
[6]=1,
}

--   funType  1װ��ѡ��   2�꼼ѡ��

--
-------------------------˽�нӿ�------------------------

function getBtnTable()
	return btnTable
end;
--
-- ��ʼ����Դ����Ա����
function initResource()
	btnTable = {}
end

function close()
	if heroLayer ~= nil then
		heroLayer:getParent():removeChild(heroLayer, true)
		heroLayer = nil
	end
	if mLayer ~= nil then
		mLayer:getParent():removeChild(mLayer, true)
		mLayer = nil
	end
	releaseResource()
end;

-- �ͷ���Դ
function releaseResource()
	heroLayer = nil
	mLayer = nil
end


function setInfo(scene, oldItemInfo)
	mScene = scene
	mOldItemInfo = oldItemInfo--   װ����userItemId   �꼼��itemInfo
end
-- ��������
function init(funType, itemType, choiceNum, generalID)

	initResource()
	mFunType = funType
	mItemType = itemType--װ����λ
	mChoiceNum = choiceNum
	mGeneralID = generalID
	



	-- ע������ص�

	
	-- �������
	mLayer= CCLayer:create()
	mScene:addChild(mLayer, 0)


	--��������
	local imageSize = SZ(pWinSize.width,pWinSize.height*0.855)
	local imageBg = CCSprite:create(P(Image.ImageBackground))
	imageBg:setScaleX(imageSize.width/imageBg:getContentSize().width)
	imageBg:setScaleY(imageSize.height/imageBg:getContentSize().height)
	imageBg:setAnchorPoint(PT(0,0))
	imageBg:setPosition(PT(0, pWinSize.height*0.145))
	mLayer:addChild(imageBg, 0)
	
	--���ΰ�ťceng
	local unTouchBtn =  ZyButton:new(Image.image_transparent)
	unTouchBtn:setScaleX(imageSize.width/unTouchBtn:getContentSize().width)
	unTouchBtn:setScaleY(imageSize.height/unTouchBtn:getContentSize().height)
	unTouchBtn:setAnchorPoint(PT(0,0))
	unTouchBtn:setPosition(PT(0,imageBg:getPosition().y))
	unTouchBtn:addto(mLayer, 0)	
	

	-- �˴���ӳ�����ʼ����
	local tabName = {}
	if mFunType == 1 then
		if mOldItemInfo then
			tabName = {Language.ROLE_CHANGEEQUIP}
		else
			tabName = {Language.ROLE_EQUIPCHOICE}
		end
	elseif mFuncType == 2 then
		if mOldItemInfo then
			tabName = {Language.ROLE_CHANGESKILL}
		else
			tabName = {Language.ROLE_SKILLCHOICE}
		end
	end
	
	creatTabBar(tabName)
	
	showList()
	

	--ȷ�ϰ�ť	
	local button = ZyButton:new(Image.image_button, nil, nil, Language.IDS_SURE, FONT_NAME, FONT_SM_SIZE)
	button:setAnchorPoint(PT(0,0))
	local startY = pWinSize.height*0.9
	if pWinSize.height == 960 then
		startY = pWinSize.height*0.91
	end
	
	button:setPosition(PT(pWinSize.width*0.8, startY))
	button:addto(mLayer, 0)
	button:registerScriptHandler(key_sure)

	btnTable.sureBtn = button

	if mFunType == 1 then-- 1װ��ѡ��   2�꼼ѡ��
		sendAction(1209)
	elseif mFunType == 2 then--2�꼼ѡ��
		sendAction(1483)
	end
	
end

function creatTabBar(tabName)
	local tabBar = ZyTabBar:new(Image.image_top_button_0, Image.image_top_button_1, tabName, FONT_NAME, FONT_SM_SIZE, 4, Image.image_LeftButtonNorPath, Image.image_rightButtonNorPath);
	tabBar:setCallbackFun(topTabBarAction); -----�����������
	tabBar:addto(mLayer,0) ------���
	tabBar:setColor(ZyColor:colorYellow())  ---������ɫ
	local startY = pWinSize.height*0.9
	if pWinSize.height == 960 then
		startY = pWinSize.height*0.91
	end
	tabBar:setPosition(PT(SX(25), startY))  -----��������
end;


function showList()
	if heroLayer ~= nil then
		heroLayer:getParent():removeChild(heroLayer, true)
		heroLayer = nil
	end

	local layer = CCLayer:create()
	mLayer:addChild(layer, 0)
	
	heroLayer = layer
	
	
	local list_width = pWinSize.width*0.9
	local list_height = pWinSize.height*0.65
	local list_x = pWinSize.width*0.5-list_width*0.5
	local list_y = pWinSize.height*0.24
	
	local line = 5
	
	local listSize = SZ(list_width, list_height)
	list = ScutCxList:node(listSize.height/line, ccc4(24, 24, 24, 0), listSize)
	list:setAnchorPoint(PT(0, 0))
	list:setPosition(PT(list_x, list_y))
	layer:addChild(list,0)
	
	heroList = list

	
	local label = CCLabelTTF:create("", FONT_NAME, FONT_SM_SIZE)
	label:setAnchorPoint(PT(0.5,0))
	label:setPosition(PT(list_x+list_width*0.5, list_y+list_height*0.5))
	layer:addChild(label, 0)
	noticeLabel = label
end

function showContent(info)
	local list = heroList
	heroList:clear()
	
	if #info.RecordTabel == 0 then
		if mFunType == 1 then
			noticeLabel:setString(Language.ROLE_NOEQUIP)
		elseif mFunType == 2 then
			noticeLabel:setString(Language.ROLE_NOSKILL)
		end
	else
		noticeLabel:setString("")
	end

	buttonTable = {}
	btnTable.buttonTable = buttonTable
	local currentWin = nil
	for k,v in ipairs(info.RecordTabel) do
		local listItem=ScutCxListItem:itemWithColor(ccc3(32, 24, 3))
		listItem:setOpacity(0)	
		
		local item,choiceBtn = nil
		if mFunType == 1 then
			item,choiceBtn = creatEquipItem(v,k)
			currentWin = 7
		elseif  mFunType == 2 then
			item,choiceBtn = creatSkillItem(v,k)
			currentWin = 11
		end
		buttonTable[k] = choiceBtn

		if item then
			local layout=CxLayout()
			layout.val_x.t = ABS_WITH_PIXEL
			layout.val_y.t = ABS_WITH_PIXEL
			layout.val_x.val.pixel_val =0
			layout.val_y.val.pixel_val =0
	
			listItem:addChildItem(item, layout)
		end
		list:addListItem(listItem, false) 
	end
	
	
	if GuideLayer.judgeIsGuide(currentWin) then
		GuideLayer.setScene(mScene)
		GuideLayer.init()
	end	
	
end;

--�����꼼��Ϣ
function creatSkillItem(info,  tag)
	local layer = CCLayer:create()
	
	local layerSize = SZ(list:getContentSize().width, list:getRowHeight())
	layer:setContentSize(layerSize)

	--����
	local itemBox=SZ((layerSize.width-SX(4)),(layerSize.height-SY(4)))	
	local itemBg = CCSprite:create(P("common/list_1020.9.png"))
	itemBg:setScaleX(itemBox.width/itemBg:getContentSize().width)
	itemBg:setScaleY(itemBox.height/itemBg:getContentSize().height)
	itemBg:setAnchorPoint(PT(0,0))
	itemBg:setPosition(PT(SX(2), SY(2)))	
	layer:addChild(itemBg, 0)
	
	local image = string.format("smallitem/%s.png", info.HeadID)
	local headItem = creatHeadItem(image, info.AbilityQuality, tag, actionPath)
	headItem:setAnchorPoint(PT(0,0))
	headItem:setPosition(PT(layerSize.width*0.05, layerSize.height*0.5-headItem:getContentSize().height*0.5))
	layer:addChild(headItem, 0)


	local startX = layerSize.width*0.25

	--��������
	local nameStr = info.AbilityName 
	if nameStr then
		local nameLabel = CCLabelTTF:create(nameStr, FONT_NAME, FONT_SM_SIZE)
		nameLabel:setAnchorPoint(PT(0,0))
		nameLabel:setPosition(PT(startX, layerSize.height*0.6))
		layer:addChild(nameLabel, 0)
	end

	--Ʒ��
	if genrealQuality[info.AbilityQuality ] then
		local qualityStr = Language.BAG_QUALITY..":"..genrealQuality[info.AbilityQuality ]
		local qualityLabel = CCLabelTTF:create(qualityStr, FONT_NAME, FONT_SM_SIZE)
		qualityLabel:setAnchorPoint(PT(0,0))
		qualityLabel:setPosition(PT(startX, layerSize.height*0.4))
		layer:addChild(qualityLabel, 0)
	end
	
	--�ȼ�
	local level = info.AbilityLv 
	if level then
		local levelStr = Language.ROLE_LEVEL..":"..level
		local levelLabel = CCLabelTTF:create(levelStr, FONT_NAME, FONT_SM_SIZE)
		levelLabel:setAnchorPoint(PT(0,0))
		levelLabel:setPosition(PT(startX, layerSize.height*0.2))
		layer:addChild(levelLabel, 0)	
	end	
	
	--�˺�����
	local AttackType  = AttackTypetTable[info.AttackType] 
	if AttackType then
		local levelLabel = CCLabelTTF:create(AttackType, FONT_NAME, FONT_SM_SIZE)
		levelLabel:setAnchorPoint(PT(0,0))
		levelLabel:setPosition(PT(layerSize.width*0.5, layerSize.height*0.2))
		layer:addChild(levelLabel, 0)	
	end

	local GeneralName = info.GeneralName
	if GeneralName  then
		local generalStr = Language.SKILL_EQUIP..GeneralName
		local generalLabel = CCLabelTTF:create(generalStr, FONT_NAME, FONT_SM_SIZE)
		generalLabel:setAnchorPoint(PT(0,0))
		generalLabel:setPosition(PT(layerSize.width*0.5, layerSize.height*0.6))
		layer:addChild(generalLabel, 0)	
	end

	--ѡ��ť	
	local button = ZyButton:new(Image.image_button_hook_0, Image.image_button_hook_1, nil)
	button:setAnchorPoint(PT(0,0))
	button:setPosition(PT(layerSize.width*0.85, layerSize.height*0.5-button:getContentSize().height*0.5))
	button:addto(layer, 0)
	button:setTag(tag)
--	button:registerScriptHandler(key_choicebtn)
	
	local actionBtn=UIHelper.createActionRect(itemBox,ItemListLayer.key_choicebtn,tag)
	actionBtn:setPosition(itemBg:getPosition())
	layer:addChild(actionBtn, 0)
	
	
	return layer,button	
end

--����������Ϣ
function creatEquipItem(info, tag)
	local layer = CCLayer:create()
	
	local layerSize = SZ(list:getContentSize().width, list:getRowHeight())
	layer:setContentSize(layerSize)

	--����
	
	local itemBox=SZ((layerSize.width-SX(4)),(layerSize.height-SY(4)))	
	local itemBg = CCSprite:create(P("common/list_1020.9.png"))
	itemBg:setScaleX(itemBox.width/itemBg:getContentSize().width)
	itemBg:setScaleY(itemBox.height/itemBg:getContentSize().height)
	itemBg:setAnchorPoint(PT(0,0))
	itemBg:setPosition(PT(SX(2), SY(2)))	
	layer:addChild(itemBg, 0)
	
	--����ͼƬ
	local image = string.format("smallitem/%s.png", info.HeadID)
	local quality = info.QualityType 
	local headItem = creatHeadItem(image, quality, tag, actionPath)
	headItem:setAnchorPoint(PT(0,0))
	headItem:setPosition(PT(layerSize.width*0.05, layerSize.height*0.5-headItem:getContentSize().height*0.5))
	layer:addChild(headItem, 0)

	local startX = layerSize.width*0.25

	--��������
	local nameStr = info.ItemName
	if nameStr then
		local nameLabel = CCLabelTTF:create(nameStr, FONT_NAME, FONT_SM_SIZE)
		nameLabel:setAnchorPoint(PT(0,0))
		nameLabel:setPosition(PT(startX, layerSize.height*0.6))
		layer:addChild(nameLabel, 0)
	end
	
	--Ʒ��
	if genrealQuality[info.QualityType ] then
		local qualityStr = Language.BAG_QUALITY..":"..genrealQuality[info.QualityType ]
		local qualityLabel = CCLabelTTF:create(qualityStr, FONT_NAME, FONT_SM_SIZE)
		qualityLabel:setAnchorPoint(PT(0,0))
		qualityLabel:setPosition(PT(startX, layerSize.height*0.4))
		layer:addChild(qualityLabel, 0)
	end
	
	--�ȼ�
	if info.CurLevel then
		local levelStr = Language.ROLE_LEVEL..":"..info.CurLevel
		local levelLabel = CCLabelTTF:create(levelStr, FONT_NAME, FONT_SM_SIZE)
		levelLabel:setAnchorPoint(PT(0,0))
		levelLabel:setPosition(PT(layerSize.width*0.45, layerSize.height*0.4))
		layer:addChild(levelLabel, 0)	
	end

	--����
	if info.AbilityList and #info.AbilityList > 0 then
		local AbilityStr = ""
		for k,v in ipairs(info.AbilityList) do
			AbilityStr = AbilityStr..Language.BAG_TYPE_[v.AbilityType].."+"..v.BaseNum.." "
		end
		local AbilityLabel = CCLabelTTF:create(AbilityStr, FONT_NAME, FONT_SM_SIZE)
		AbilityLabel:setAnchorPoint(PT(0,0))
		AbilityLabel:setPosition(PT(startX, layerSize.height*0.2))
		layer:addChild(AbilityLabel, 0)		
	end
	
	--
	---װ����˭����
	if info.GeneralName  then
		local quipName=CCLabelTTF:create(string.format(Language.EQUIP_EQUIPMAN,info.GeneralName ),FONT_NAME,FONT_SM_SIZE)
		quipName:setAnchorPoint(PT(0,0))
		quipName:setPosition(PT(layerSize.width*0.6, layerSize.height*0.6))
		layer:addChild(quipName,0)
	end	
	

	--ѡ��ť	
	local button = ZyButton:new(Image.image_button_hook_0, Image.image_button_hook_1, nil)
	button:setAnchorPoint(PT(0,0))
	button:setPosition(PT(layerSize.width*0.85, layerSize.height*0.5-button:getContentSize().height*0.5))
	button:addto(layer, 0)
	button:setTag(tag)
	--button:registerScriptHandler(key_choicebtn)
	
	local actionBtn=UIHelper.createActionRect(itemBox,ItemListLayer.key_choicebtn,tag)
	actionBtn:setPosition(itemBg:getPosition())
	layer:addChild(actionBtn, 0)
	
	return layer,button	
end;

--����ͷ��
function creatHeadItem(image, qualityType, tag, actionPath)

	-- ����
	local bgPic = getQualityBg(qualityType, 1)
	local menuItem = CCMenuItemImage:create(P(bgPic), P(bgPic))
	local btn = CCMenu:createWithItem(menuItem)
	btn:setAnchorPoint(PT(0,0))
	menuItem:setAnchorPoint(PT(0,0))
	if tag~= nil and tag~=-1 then
		menuItem:setTag(tag)
	end

	btn:setContentSize(SZ(menuItem:getContentSize().width,menuItem:getContentSize().height))
	
	
	--���ûص�
	if actionPath ~= nil then
		menuItem:registerScriptHandler(actionPath)
	end

	-- ����ͼ
	if image ~= nil and image ~= "" then
		local imageLabel = CCSprite:create(P(image))
		imageLabel:setAnchorPoint(CCPoint(0.5, 0.5))
		imageLabel:setPosition(PT(menuItem:getContentSize().width*0.5,menuItem:getContentSize().height*0.5))
		menuItem:addChild(imageLabel,0)
	end	

	return btn
end

--���ѡ��ť
function key_choicebtn(pNode, index)
	local tag = nil
	if index then
		tag = index
	else
		tag = pNode:getTag()
	end
	
	for k,v in ipairs(buttonTable) do
		if k == tag and not v._isSelected then
			v:selected()
		else
			v:unselected()
		end
	end	
end;

--ȷ�ϰ�ť
function key_sure()
	local isNoChice = true
	mTag = nil
	if buttonTable then
		for k,v in ipairs(buttonTable) do
			if v._isSelected then
				isNoChice = false
				mTag=k
			end
		end
	end	


	if isNoChice then
		if mOldItemInfo then
			unload()
		else	
			close()
		end		
	else
		putIn()
	end
end

--װ��
function putIn()
	local tag = mTag
	if mFunType == 1 then
		local UserItemID = mEquipInfo.RecordTabel[tag].UserItemID
		sendAction(12030, UserItemID)
	elseif mFunType == 2 then
		local itemInfo = mSkillInfo.RecordTabel[tag]
		sendAction(14840, itemInfo)
	end
end

--ж��
function unload()
	if mFunType == 1 then
		local UserItemID = mOldItemInfo
		sendAction(12031, UserItemID)
	elseif mFunType == 2 then
		local itemInfo = mOldItemInfo
		sendAction(14841, itemInfo)
	end
end




--��������
function sendAction(actionId, data)
	if actionId == 1209 then
		actionLayer.Action1209(mScene, nil, mItemType, mGeneralID)	
	elseif actionId == 12030 then--װ�� ����
		local UserItemID = data
		local GeneralID = mGeneralID
		actionLayer.Action1203(mScene, nil, GeneralID, UserItemID, 0)--0��װ�� 1��ж��          
	elseif actionId == 12031 then--װ�� ж��
		local UserItemID = data
		local GeneralID = mGeneralID
		actionLayer.Action1203(mScene, nil, GeneralID, UserItemID, 1)--0��װ��1��ж�� 	
	elseif actionId == 1483 then--�꼼�б�ӿ�
		actionLayer.Action1483(mScene, nil, 1, 200, 2)
	elseif actionId == 14840 then--Ӷ���꼼 װ����
		local itemInfo = data
		local GeneralID = mGeneralID
		actionLayer.Action1484(mScene, nil, 0, itemInfo.AbilityID , itemInfo.UserItemID,GeneralID, mItemType)--0��װ��1��ж��
	elseif actionId == 14841 then--Ӷ���꼼  ж��	
		local itemInfo = data
		local GeneralID = mGeneralID
		actionLayer.Action1484(mScene, nil, 1, itemInfo.AbilityID , itemInfo.UserItemID,GeneralID, mItemType)--0��װ��1��ж��		
	end

end

-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionId = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	if actionId == 1209 then
		local serverInfo = actionLayer._1209Callback(pScutScene, lpExternalData)
		if serverInfo ~= nil then
			mEquipInfo = serverInfo
			showContent(serverInfo)
		end

	elseif actionId == 1203 then
		local serverInfo = actionLayer._1203Callback(pScutScene, lpExternalData)
		if serverInfo ~= nil then
				close()
				HeroScene.refreshWin()
--			if userData == 0 then		
--				releaseResource()
--				HeroScene.refreshWin()
--			elseif  userData == 1 then
--				putIn()
--			end
		end
	elseif actionId == 1483 then
		local serverInfo = actionLayer._1483Callback(pScutScene, lpExternalData)
		if serverInfo ~= nil then	
			mSkillInfo = serverInfo
			showContent(serverInfo)			
		end	
	elseif actionId == 1484 then
		local serverInfo = actionLayer._1484Callback(pScutScene, lpExternalData)
		if serverInfo ~= nil then	
--			if userData == 0 then		
--				close()
--				HeroScene.refreshWin()
--			elseif  userData == 1 then
--				putIn()
--			end
				close()
				HeroScene.refreshWin()
		end
	end
end