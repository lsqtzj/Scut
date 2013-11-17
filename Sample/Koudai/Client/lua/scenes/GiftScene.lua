------------------------------------------------------------------
-- GiftScene.lua.lua
-- Author     : yeyq

-- Version    : 1.0
-- Date       :
-- Description: 
------------------------------------------------------------------

module("GiftScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

_scene = nil 		-- ����
goodsTable = nil 
mList = nil 
layerBG = nil 
listSize = nil 
--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��

-- �������
function pushScene()
	initResource()
	createScene()
	CCDirector:sharedDirector():pushScene(_scene)
end
-- �˳�����
function popScene()
	releaseResource()
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
	mList=nil
	removelist()
	if  layerBG  then
		layerBG:getParent():removeChild(layerBG,true)	
		layerBG = nil
	end
end
-- ��������
--function init(mScene,mLayer,Id)
function init(scene,Id)
	_scene = scene
	mScene=scene
	goodId	 =	Id
	
	layerBG = CCLayer:create()
	layerBG:setAnchorPoint(PT(0,0))
	layerBG:setPosition(PT(0,0))	
	mScene:addChild(layerBG,1)


	-- �˴���ӳ�����ʼ����
	
	local bgButton=ZyButton:new(Image.image_transparent)
	bgButton:setScaleX(pWinSize.width/bgButton:getContentSize().width)
	bgButton:setScaleY(pWinSize.height/bgButton:getContentSize().height)
	bgButton:setAnchorPoint(PT(0,0))
	bgButton:setPosition(PT(0,pWinSize.height*0.145))
	bgButton:addto(layerBG, 0)
	
	
--	local BgImg = CCSprite:create(P("common/list_1024.png"))
--	BgImg:setScaleX(pWinSize.width/BgImg:getContentSize().width)
--	BgImg:setScaleY(pWinSize.height*0.855/BgImg:getContentSize().height)
--	BgImg:setAnchorPoint(PT(0,0))
--	BgImg:setPosition(PT(0,pWinSize.width*0.145))	
--	layerBG:addChild(BgImg,0)

	local imageBg = CCSprite:create(P("common/list_1024.png"))
	imageBg:setAnchorPoint(PT(0,0))
	imageBg:setPosition(PT(0,pWinSize.height*0.145))
	imageBg:setScaleX(pWinSize.width/imageBg:getContentSize().width)
	imageBg:setScaleY(pWinSize.height*0.855/imageBg:getContentSize().height)
	layerBG:addChild(imageBg, 0)


	
---[[
	
	---- ���Ԥ��
	
	local titleImg = CCSprite:create(P("title/list_1214.png"))
	titleImg:setAnchorPoint(PT(0.5,0.5))
	titleImg:setPosition(PT(pWinSize.width*0.5,pWinSize.height*0.935))
	layerBG:addChild(titleImg, 0)
	
	----ʹ�ú���Ի��������Ʒ:
	local title2Str = CCLabelTTF:create(Language.Gift_title2Str,FONT_NAME,FONT_SM_SIZE)	
	layerBG:addChild(title2Str,0)
	title2Str:setAnchorPoint(PT(0.5,1))
	title2Str:setPosition(PT(pWinSize.width*0.5,pWinSize.height*0.89))	

	---ȷ�ϰ�ť
	KButon = ZyButton:new(Image.image_button, image_button, Image.image_button_hui_c,Language.IDS_SURE,FONT_NAME,FONT_SM_SIZE)
	KButon:addto(layerBG,0)
	KButon:setAnchorPoint(PT(0,0))
	KButon:setPosition(PT(pWinSize.width*0.4-KButon:getContentSize().width, pWinSize.height*0.25))
	KButon:registerScriptHandler(winFunc)
	
	---���ذ�ť
	local backButon = ZyButton:new(Image.image_button, Image.image_button, Image.image_button_hui_c,Language.IDS_BACK,FONT_NAME,FONT_SM_SIZE)
	backButon:addto(layerBG,0)
	backButon:setAnchorPoint(PT(0,0))
	backButon:setPosition(PT(pWinSize.width*0.6, pWinSize.height*0.25))
	backButon:registerScriptHandler(backAction)
	
	createlist()
	
	actionLayer.Action1114(mScene,nil ,goodId)	
--	showLayer()
	--]]
end

function removelist()
    if listLayer ~= nil then
        listLayer:getParent():removeChild(listLayer,true)
        listLayer = nil
    end
end

function initlist()
    removelist()
    listLayer=CCLayer:create()
    listLayer:setAnchorPoint(PT(0,0));
    listLayer:setPosition(PT(0,0));
    layerBG:addChild(listLayer,0)
end

function createlist()
	initlist()
	local listSize = SZ(pWinSize.width*0.9,pWinSize.height*0.55)
	local listRowH=listSize.height*0.25
	local list = ScutCxList:node(listRowH,ccc4(24,24,24,0),listSize)
	list:setTouchEnabled(true)
	mList = list
	list:setAnchorPoint(PT(0,0))
	list:setPosition(PT(pWinSize.width*0.05,KButon:getPosition().y+SY(20)))
	listLayer:addChild(list,1)
end

function winFunc()
	
	actionLayer.Action1606(_scene,nil ,goodId)
	--[[
	local tishi=""
	for i=1,#goodsTable do
		if goodsTable[i].Type == 1 then--���
			nameStr = Language.IDS_GOLD
		elseif goodsTable[i].Type == 6 then--��ʯ
			nameStr = Language.IDS_JINGSHI
		end
	tishi=tishi..Language.BAG_TIP9..nameStr.."*"..goodsTable[i].Num.."  "
	end
	ZyToast.show(_scene,tishi,1,0.35)
	--]]
--	releaseResource()
--	BagScene.GiftFtoBagFunc(goodId)
end
function backAction()
	releaseResource()
	MainMenuLayer.refreshWin()
	BagScene.showLayer()
end
function showLayer()
	local layout = CxLayout()
	layout.val_x.t = ABS_WITH_PIXEL
	layout.val_y.t = ABS_WITH_PIXEL	
	layout.val_x.val.pixel_val =0
	layout.val_y.val.pixel_val =0
	for i=1,#goodsTable  do
		local item = ScutCxListItem:itemWithColor(ccc3(25,57,45))	
		item:setOpacity(0)
		local itemLayer  = addItem(i)
		item:addChildItem(itemLayer,layout)
		mList:addListItem(item,false)
	end
end

function addItem(i)
		local itemLayer = CCLayer:create()
	
		local listSize = mList:getContentSize()
		local headX = listSize.width*0.3
		local headY = listSize.height*0.25*0.5
		
		local bgImg = CCSprite:create(P("common/list_1038.9.png"))
		bgImg:setScaleX(pWinSize.width*0.8/bgImg:getContentSize().width)
		bgImg:setScaleY(listSize.height*0.25/bgImg:getContentSize().height)
		itemLayer:addChild(bgImg,0)
		bgImg:setAnchorPoint(PT(0.5,0.5))
		bgImg:setPosition(PT(listSize.width*0.5,headY))
		
		----ͷ��߿�
		local headBgImg = CCSprite:create(P("common/list_1012.png"))
		itemLayer:addChild(headBgImg,0)
		headBgImg:setAnchorPoint(PT(0.5,0.5))
		headBgImg:setPosition(PT(headX,headY))
		
		----ͷ��
		local headImgTo = nil
		if goodsTable[i].Type == 1 then--���
			headImgTo = "smallitem/icon_8012.png"
		elseif goodsTable[i].Type == 6 then--��ʯ
			headImgTo = "smallitem/icon_8010.png"
		else
			headImgTo = string.format("smallitem/\%s.png",goodsTable[i].HeadID)
		end
		local headBgImg = CCSprite:create(P(headImgTo))
		itemLayer:addChild(headBgImg,0)
		headBgImg:setAnchorPoint(PT(0.5,0.5))
		headBgImg:setPosition(PT(headX,headY))
		----����
		
		local strTitle = CCLabelTTF:create(Language.BAG_nameStr,FONT_NAME,FONT_SM_SIZE)	
		itemLayer:addChild(strTitle,1)
		strTitle:setAnchorPoint(PT(0,0.5))
		strTitle:setPosition(PT(headX+headBgImg:getContentSize().width+SX(2),headY-SY(2)))
		
		----����
		local nameStr = ""
		if goodsTable[i].ItemName  then
			nameStr = goodsTable[i].ItemName			
		end
		if goodsTable[i].Type == 1 then--���
			nameStr = Language.IDS_GOLD
		elseif goodsTable[i].Type == 6 then--��ʯ
			nameStr = Language.IDS_JINGSHI
		end
		local name = CCLabelTTF:create(nameStr,FONT_NAME,FONT_SM_SIZE)	
		itemLayer:addChild(name,1)
		name:setAnchorPoint(PT(0,0.5))
		name:setPosition(PT(headX+headBgImg:getContentSize().width+SX(2),headY+SY(8)))
		
		----����
		local Num =  CCLabelTTF:create(goodsTable[i].Num ,FONT_NAME,FONT_SM_SIZE)	
		itemLayer:addChild(Num,1)
		Num:setAnchorPoint(PT(0,0.5))
		Num:setPosition(PT(headX+headBgImg:getContentSize().width+strTitle:getContentSize().width+SX(1),headY-SY(2)))

		return itemLayer
end


-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionID = ZyReader:getActionID()
	if actionID == 1114	then
		local serverInfo = actionLayer._1114Callback(pScutScene, lpExternalData)
		if  serverInfo ~= nil  then
			goodsTable = serverInfo.goods	
		end
		showLayer()
--		if mDetailLayer~=nil  then 
--			mDetailLayer:getParent():removeChild(mDetailLayer,true)
--			mDetailLayer = nil 
--		end
		
--		GiftScene.networkCallback(pScutScene, lpExternalData)
--		GiftScene.init(mScene,mLayer,goodId)
	elseif actionID == 1606 then 
		local serverInfo=actionLayer._1606Callback(pScutScene, lpExternalData)
 		if serverInfo~=nil then
			local HasNextGift=serverInfo.HasNextGift
			local Content=serverInfo.Content
			if HasNextGift==1 then
--				GiftScene.releaseResource()
				mList=nil
				createlist()
				actionLayer.Action1114(mScene,nil ,goodId)
				ZyToast.show(mScene,Content,1,0.35)
			else
				GiftScene.releaseResource()
				MainMenuLayer.refreshWin()
				BagScene.refreshWin()
				ZyToast.show(mScene,Content,1,0.35)
			end
		end;
	end
end
