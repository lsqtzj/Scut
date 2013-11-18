------------------------------------------------------------------
-- HeroLvUpChoiceLayer.lua
-- Author     : Zonglin Liu
-- Version    : 1.0
-- Date       :   
-- Description: 
------------------------------------------------------------------

module("HeroLvUpChoiceLayer", package.seeall)

local chartTable={}
local cardnum={}
local cardnumber=nil

function releaseResource()
	choiceLayer = nil
	heroLayer = nil
	cardTable=nil
end;

function setCardTable(table)
	cardTable = table
end

function getCardTable()
	return cardTable
end;


function getBtnTable()
	return btnTable
end;


function initResource()
	btnTable = {}
end;
--ѡ�����
function init(scene,type)
	initResource()
	choiceType = type--1Ӷ��ѡ��  2���鿨Ƭѡ��
	
	mScene = scene

	local layer = CCLayer:create()
	mScene:addChild(layer, 0)
	
	choiceLayer = layer
	
	--��������
	--�м��
	local midSprite=CCSprite:create(P("common/list_1043.png"))
	local boxSize=SZ(pWinSize.width,pWinSize.height*0.68)
	midSprite:setScaleX(boxSize.width/midSprite:getContentSize().width)
	midSprite:setScaleY(boxSize.height/midSprite:getContentSize().height)
	midSprite:setAnchorPoint(PT(0.5,0))
	midSprite:setPosition(PT(pWinSize.width/2,pWinSize.height*0.145))
	layer:addChild(midSprite,0)


	--���ΰ�ťceng
	local unTouchBtn =  ZyButton:new(Image.image_transparent)
	unTouchBtn:setScaleX(boxSize.width/unTouchBtn:getContentSize().width)
	unTouchBtn:setScaleY(boxSize.height/unTouchBtn:getContentSize().height)
	unTouchBtn:setAnchorPoint(PT(0,0))
	unTouchBtn:setPosition(PT(0,midSprite:getPosition().x))
	unTouchBtn:addto(layer, 0)


	
	local tabName = {Language.BAG_HERO}
	if choiceType == 2 then
		tabName = {Language.ROLE_CARDLIST}
	end
	createTabbar(tabName, choiceLayer)
	
	--ȷ�ϰ�ť	
	local button = ZyButton:new(Image.image_button, nil, nil, Language.IDS_SURE, FONT_NAME, FONT_SM_SIZE)
	button:setAnchorPoint(PT(0,0))
	button:setPosition(PT(pWinSize.width*0.8, pWinSize.height*0.77))
	button:addto(choiceLayer, 0)
	button:registerScriptHandler(key_sure)
	
	btnTable.sureBtn = button
	cardnumber=1
	
	creatList()	
	
end;

--����Tab
function createTabbar(tabName, layer)
	local tabBar = ZyTabBar:new(Image.image_top_button_0, Image.image_top_button_1, tabName, FONT_NAME, FONT_SM_SIZE, 4, Image.image_LeftButtonNorPath, Image.image_rightButtonNorPath);
	tabBar:setCallbackFun(topTabBarAction); -----�����������
	tabBar:addto(layer,0) ------���
	tabBar:setColor(ZyColor:colorYellow())  ---������ɫ
	tabBar:setPosition(PT(SX(25),pWinSize.height*0.775))  -----��������
end

--����ѡ���б�
function creatList()
	if heroLayer ~= nil then
		heroLayer:getParent():removeChild(heroLayer, true)
		heroLayer = nil
	end

	local layer = CCLayer:create()
	choiceLayer:addChild(layer, 0)
	
	heroLayer = layer
	
	
	local list_width = pWinSize.width*0.9
	local list_height = pWinSize.height*0.52
	local list_x = pWinSize.width*0.5-list_width*0.5
	local list_y = pWinSize.height*0.23
	local line = 4
	
	local listSize = SZ(list_width, list_height)
	list = ScutCxList:node(listSize.height/line, ccc4(24, 24, 24, 0), listSize)
	list:setAnchorPoint(PT(0, 0))
	list:setPosition(PT(list_x, list_y))
	layer:addChild(list,0)
    list:setTouchEnabled(true)
	skillList = list
	list:setTouchEnabled(true)
	
	local label = CCLabelTTF:create("", FONT_NAME, FONT_SM_SIZE)
	label:setAnchorPoint(PT(0.5,0))
	label:setPosition(PT(list_x+list_width*0.5, list_y+list_height*0.5))
	layer:addChild(label, 0)
	noticeLabel = label
	
	choiceNum = 0--��ѡ�����
	
end

--��ʾ��ѡ��
function showList(info)
	local list = skillList
	list:clear()
	
	infoTabel = info
	buttonTable = {}
	btnTable.buttonTable = buttonTable	
	
	if infoTabel and #infoTabel == 0 then
		if choiceType == 1 then
			noticeLabel:setString(Language.ROLE_NOCHOICEHERO)
		else
			noticeLabel:setString(Language.ROLE_NOEXPCARD)
		end
		return
	else
		noticeLabel:setString("")
	end
	
	local currentWin = nil
	for k,v in ipairs(infoTabel) do
		local listItem=ScutCxListItem:itemWithColor(ccc3(32, 24, 3))
		listItem:setOpacity(0)	
		
		local item,choiceBtn = nil
		if choiceType == 2 then--choiceType --1Ӷ��ѡ��  2���鿨Ƭѡ��
			item,choiceBtn = creatCardItem(v,k)
			buttonTable[k] = choiceBtn
			currentWin = 12
		elseif choiceType == 1 then
			item,choiceBtn = creatManItem(v,k)
			buttonTable[k] = choiceBtn
			currentWin = 11
		end
		
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


--����Ӷ����Ϣ
function creatManItem(info, tag)
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
	
	
	--	--Ӷ��ͷ��
	local image = nil
	if info.HeadID then
 		image = string.format("smallitem/%s.png", info.HeadID)
	end
	local quality = info.GeneralQuality 
	local headItem = creatHeadItem(image, tag, nil, quality)
	headItem:setAnchorPoint(PT(0,0))
	headItem:setPosition(PT(layerSize.width*0.05, layerSize.height*0.5-headItem:getContentSize().height*0.5))
	layer:addChild(headItem, 0)


	local startX = layerSize.width*0.25

	--Ӷ������
	local nameStr = info.GeneralName 
	if nameStr then
		local nameLabel = CCLabelTTF:create(nameStr, FONT_NAME, FONT_SM_SIZE)
		nameLabel:setAnchorPoint(PT(0,0))
		nameLabel:setPosition(PT(startX, layerSize.height*0.6))
		layer:addChild(nameLabel, 0)
	end
	
	--Ʒ��
	if info.GeneralQuality  and genrealQuality[info.GeneralQuality ] then
		local qualityStr = Language.BAG_QUALITY..":"..genrealQuality[info.GeneralQuality ]
		local qualityLabel = CCLabelTTF:create(qualityStr, FONT_NAME, FONT_SM_SIZE)
		qualityLabel:setAnchorPoint(PT(0,0))
		qualityLabel:setPosition(PT(startX, layerSize.height*0.4))
		layer:addChild(qualityLabel, 0)
	end
	
	--�ȼ�
	local level = info.GeneralLv  
	if level then
		local levelStr = Language.ROLE_LEVEL..":"..level
		local levelLabel = CCLabelTTF:create(levelStr, FONT_NAME, FONT_SM_SIZE)
		levelLabel:setAnchorPoint(PT(0,0))
		levelLabel:setPosition(PT(startX, layerSize.height*0.2))
		layer:addChild(levelLabel, 0)	
	end

	if info.IsBattle  == 1 then
		local label = CCLabelTTF:create(Language.BAG_INGROUP, FONT_NAME, FONT_SM_SIZE)
		label:setAnchorPoint(PT(0,0))
		label:setPosition(PT( layerSize.width*0.6, layerSize.height*0.6))
		layer:addChild(label, 0)	

	end

	--ѡ��ť	
	local button = ZyButton:new(Image.image_button_hook_0, Image.image_button_hook_1, nil)
	button:setAnchorPoint(PT(0,0))
	button:setPosition(PT(layerSize.width*0.85, layerSize.height*0.5-button:getContentSize().height*0.5))
	button:addto(layer, 0)
	button:setTag(tag)
	
	local actionPath = HeroLvUpChoiceLayer.choiceLvUpHero
	--button:registerScriptHandler(actionPath)
	
	local actionBtn=UIHelper.createActionRect(itemBox,actionPath,tag)
	actionBtn:setPosition(itemBg:getPosition())
	layer:addChild(actionBtn, 0)
	
	return layer,button	
end;

--����Ӷ�����鿨
function creatCardItem(info, tag)
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
	
	
	--Ӷ�����鿨ͼƬ
	local image = nil
	if info.HeadID then
 		image = string.format("smallitem/%s.png", info.HeadID)
	end
	local headItem = creatHeadItem(image, tag, nil)
	headItem:setAnchorPoint(PT(0,0))
	headItem:setPosition(PT(layerSize.width*0.05, layerSize.height*0.5-headItem:getContentSize().height*0.5))
	layer:addChild(headItem, 0)


	local startX = layerSize.width*0.25

	--Ӷ������
	local nameStr = info.ItemName  
	if nameStr then
		local nameLabel = CCLabelTTF:create(nameStr, FONT_NAME, FONT_SM_SIZE)
		nameLabel:setAnchorPoint(PT(0,0))
		nameLabel:setPosition(PT(startX, layerSize.height*0.6))
		layer:addChild(nameLabel, 0)
	end
	
	--���� 
	if info.Experience  then
		local expStr = Language.BAG_EXP..":".. info.Experience
		local expLabel = CCLabelTTF:create(expStr, FONT_NAME, FONT_SM_SIZE)
		expLabel:setAnchorPoint(PT(0,0))
		expLabel:setPosition(PT(startX, layerSize.height*0.4))
		layer:addChild(expLabel, 0)
	end
	
	--����
	cardnum[tag]={}
	cardnum[tag].num=info.ItemNum
	local num = info.ItemNum   
	if num then
		local numStr = Language.IDS_NUM..":"..num
		local numLabel = CCLabelTTF:create(numStr, FONT_NAME, FONT_SM_SIZE)
		numLabel:setAnchorPoint(PT(0,0))
		numLabel:setPosition(PT(startX, layerSize.height*0.2))
		layer:addChild(numLabel, 0)	
	end


	--ѡ��ť	
	local button = ZyButton:new(Image.image_button_hook_0, Image.image_button_hook_1, nil)
	button:setAnchorPoint(PT(0,0))
	button:setPosition(PT(layerSize.width*0.85, layerSize.height*0.5-button:getContentSize().height*0.5))
	button:addto(layer, 0)
	button:setTag(tag)
	
	
	for k,v in ipairs(cardTable) do
		if info.UserItemID == v.UserItemID then
			button:selected()
		end
	end
	
	local actionPath = HeroLvUpChoiceLayer.key_choicebtn
	
	local itemBox2=SZ((layerSize.width-SX(4))/4,(layerSize.height-SY(4)))
	local actionBtn=UIHelper.createActionRect(itemBox2,actionPath,tag)
	actionBtn:setPosition(PT(layerSize.width*0.78,SY(2)))
	layer:addChild(actionBtn, 0)	

	
	--��ѡ��ť	
	local lbutton = ZyButton:new(Image.image_LeftButtonNorPath, Image.image_LeftButtonNorPath, nil)
	lbutton:setAnchorPoint(PT(0,0))
	lbutton:setPosition(PT(layerSize.width*0.55, layerSize.height*0.5-lbutton:getContentSize().height*0.5))
	lbutton:registerScriptHandler(Lbtn)
	lbutton:addto(layer, 1)
	lbutton:setTag(tag)
	
	local count = CCLabelTTF:create(cardnum[tag].num, FONT_NAME, FONT_SM_SIZE)
	count:setAnchorPoint(PT(0,0))
	count:setPosition(PT(lbutton:getPosition().x+lbutton:getContentSize().width+SX(17), layerSize.height*0.5-count:getContentSize().height*0.5))
	layer:addChild(count, 0)	
	
	--��ѡ��ť	
	local rbutton = ZyButton:new(Image.image_rightButtonNorPath, Image.image_rightButtonNorPath, nil)
	rbutton:setAnchorPoint(PT(0,0))
	rbutton:setPosition(PT(count:getPosition().x+count:getContentSize().width+SX(20), layerSize.height*0.5-rbutton:getContentSize().height*0.5))
	rbutton:registerScriptHandler(Rbtn)
	rbutton:addto(layer,1)
	rbutton:setTag(tag)
	

	
	chartTable[tag]={}
	chartTable[tag].valueLabel=count
	chartTable[tag].value=cardnum[tag].num
	
	return layer,button	
end


function Rbtn(node)
	local tag=node:getTag()
	if chartTable[tag].value<cardnum[tag].num then
		chartTable[tag].value=chartTable[tag].value+1
--		cardnumber=chartTable[tag].value
		chartTable[tag].valueLabel:setString(chartTable[tag].value)
	end
end;

function Lbtn(node)
	local tag=node:getTag()
	if chartTable[tag].value>1 then
		chartTable[tag].value=chartTable[tag].value-1
--		cardnumber=chartTable[tag].value
		chartTable[tag].valueLabel:setString(chartTable[tag].value)
	end
end;
------------
--����ͷ��
function creatHeadItem(image, tag, actionPath,quality)

	-- ����
	local bgPic = getQualityBg(quality,1)
	local menuItem = CCMenuItemImage:create(P(bgPic), P(bgPic))
	local btn = CCMenu:createWithItem(menuItem)
	btn:setAnchorPoint(PT(0,0))
	menuItem:setAnchorPoint(PT(0,0))
	if tag~= nil and tag~=-1 then
		menuItem:setTag(tag)
	end

	btn:setContentSize(SZ(menuItem:getContentSize().width,menuItem:getContentSize().height))
	
	
    
	-- ����ͼ
	if image ~= nil and image ~= "" then
		local imageLabel = CCSprite:create(P(image))
		imageLabel:setAnchorPoint(CCPoint(0.5, 0.5))
		imageLabel:setPosition(PT(menuItem:getContentSize().width*0.5,menuItem:getContentSize().height*0.5))
		menuItem:addChild(imageLabel,0)
	end	

	return btn
end

--���ѡ��ť   ѡ�����Ŀ�
function key_choicebtn(pNode, index)
	local tag = nil
	if index then
		tag = index
	else
		tag = pNode:getTag()
	end
	if buttonTable[tag]._isSelected == true then
		buttonTable[tag]:unselected()
		choiceNum = choiceNum-1
	else
		if choiceNum < 6 then
			buttonTable[tag]:selected()
			choiceNum = choiceNum+1
		end
	end
end;

--ѡ������Ӷ��
function choiceLvUpHero(pNode)
	local tag = pNode
	for k,v in ipairs(buttonTable) do
		if k == tag and not v._isSelected then
			v:selected()
		else
			v:unselected()
		end
	end	
	
end

--�ر�ѡ�����
function closeChoiceLayer()
	if heroLayer ~= nil then
		heroLayer:getParent():removeChild(heroLayer, true)
		heroLayer = nil
	end
	if choiceLayer ~= nil then
		choiceLayer:getParent():removeChild(choiceLayer, true)
		choiceLayer = nil
	end
end



------------------------------------------
--ȷ�ϰ�ť
function key_sure()
	if choiceType == 1 then--1Ӷ��ѡ��  2���鿨Ƭѡ��
		local generalID = nil
		for k,v in ipairs(buttonTable) do
			if v._isSelected then
				generalID = infoTabel[k].GeneralID
			end
		end
		if generalID then
			HeroLvUp.setGeneralID(generalID)
			HeroLvUp.sendAction(1441)
		end
	elseif choiceType == 2 then
		local itemString = nil
		local numString = nil
		for k,v in ipairs(buttonTable) do
			if itemString == nil and v._isSelected then
				itemString = infoTabel[k].UserItemID 
			elseif v._isSelected then
				itemString = itemString..","..infoTabel[k].UserItemID 
			end
			if numString == nil and v._isSelected then
				numString = chartTable[k].value 
			elseif v._isSelected then
				numString = numString..","..chartTable[k].value  
			end
		end	
		if itemString then
			HeroLvUp.sendAction(1445, itemString,numString)
		end
	end
	closeChoiceLayer()
end



--��������
function sendAction(actionId,data)
	if actionId == 14 then


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