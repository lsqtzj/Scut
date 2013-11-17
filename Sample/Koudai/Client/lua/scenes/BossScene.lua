------------------------------------------------------------------
-- BossScene.lua
-- Author     :
-- Version    : 1.0
-- Date       :
-- Description: ,
------------------------------------------------------------------
module("BossScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

local mScene = nil 		-- ����
local mLayer=nil
local mCurrentTab=nil
--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��

-- �������

-- �������
function init(scene)
	if mScene then
		return
	end
	initResource()
	local scene = ScutScene:new()
		
	-- ע������ص�
	scene:registerCallback("BossScene.networkCallback")
	mScene = scene.root
	mScene:registerScriptHandler(SpriteEase_onEnterOrExit)
	SlideInLReplaceScene(mScene,1)
	mLayer = CCLayer:create()
	mScene:addChild(mLayer, 0)
	-- ��ӱ���
	if not  mCurrentTab then
		mCurrentTab=1
	end		
	local bgLayer=createContentLayer()
	bgLayer:setPosition(PT(0,0))
	mLayer:addChild(bgLayer,0)
	
	MainMenuLayer.init(2, mScene)
	mServerData={}
	mServerData.RecordTabel={
	{1},{2},
	{1},{2},
	{1},{2},
	}
	createTopLayer()
	showLayer()	
end
function SpriteEase_onEnterOrExit (tag)
    if tag == "exit" then
        releaseResource()
    end
end


---����������
function  createContentLayer()
	local layer=CCLayer:create()
	layer:setAnchorPoint(PT(0,0))
	--�󱳾�
	local bgSprite=CCSprite:create(P("common/list_1015.png"))
	bgSprite:setAnchorPoint(PT(0.5,0.5))
	bgSprite:setScaleX(pWinSize.width/bgSprite:getContentSize().width)
	bgSprite:setScaleY(pWinSize.height/bgSprite:getContentSize().height)
	bgSprite:setPosition(PT(pWinSize.width/2,pWinSize.height/2))
	layer:addChild(bgSprite,0)
	--�м��
	local midSprite=CCSprite:create(P("common/list_1024.png"))
	local boxSize=SZ(pWinSize.width,midSprite:getContentSize().height)
	midSprite:setAnchorPoint(PT(0.5,0))
	midSprite:setScaleX(boxSize.width/bgSprite:getContentSize().width)
	midSprite:setPosition(PT(pWinSize.width/2,pWinSize.height-boxSize.height))
	layer:addChild(midSprite,0)
	return layer
end;

--Ӷ��ѡ��
function  createTopLayer()
	if mServerData.RecordTabel then
		local layer=CCLayer:create()
		local bgSprite=CCSprite:create(P("mainUI/list_1000.png"))
		bgSprite:setAnchorPoint(PT(0.5,0))
		bgSprite:setScaleX(pWinSize.width/bgSprite:getContentSize().width)
		bgSprite:setPosition(PT(pWinSize.width/2,pWinSize.height-bgSprite:getContentSize().height))
		layer:addChild(bgSprite,0)
		local lSprite=CCSprite:create(P("button/list_1069.png"))
		lSprite:setAnchorPoint(PT(0,0.5))
		lSprite:setPosition(PT(0,pWinSize.height-bgSprite:getContentSize().height/2))
		layer:addChild(lSprite,0)
		local rSprite=CCSprite:create(P("button/list_1068.png"))
		rSprite:setAnchorPoint(PT(0,0.5))
		rSprite:setPosition(PT(pWinSize.width-rSprite:getContentSize().width,
							lSprite:getPosition().y))
		layer:addChild(rSprite,0)
		 ---LIST �ؼ�
		local listSize=SZ(pWinSize.width*0.8,bgSprite:getContentSize().height*0.8)
		local listX=(pWinSize.width-listSize.width)/2
		local listY=pWinSize.height-listSize.height-bgSprite:getContentSize().height*0.1
		local mListColWidth=listSize.width/4
		local list = ScutCxList:node(mListColWidth, ccc4(24, 24, 24, 0), listSize)
		list:setAnchorPoint(PT(0,0))
		list:setPosition(PT(listX,listY))
		list:setRecodeNumPerPage(1)
		list:setTouchEnabled(true)
		layer:addChild(list,1)
		list:setHorizontal(true)	
		local layout = CxLayout()
		layout.val_x.t = ABS_WITH_PIXEL
		layout.val_y.t = ABS_WITH_PIXEL
		layout.val_x.val.pixel_val = 0
		layout.val_y.val.pixel_val = 0
		for k, v in pairs(mServerData.RecordTabel) do
		 	local listItem = ScutCxListItem:itemWithColor(ccc3(24,24,24))
			listItem:setOpacity(50)
			local layer=CCLayer:create()
			local imagePath=string.format("smallitem/%s.png","Figure_1001_1")
			local headSprite=CCSprite:create(P(imagePath))
			headSprite:setAnchorPoint(PT(0.5,0.5))
			headSprite:setPosition(PT(mListColWidth/2,listSize.height/2))
			layer:addChild(headSprite,0)
			local actionBtn,menuItemHead=UIHelper.createActionRect(SZ(mListColWidth,listSize.height),BossScene.choiceBossAction,k)
			actionBtn:setPosition(PT(0,0))
			layer:addChild(actionBtn,0)
		
			listItem:addChildItem(layer, layout)
			list:addListItem(listItem, false)
		end
		list:selectChild(mCurrentTab-1)
		mCurrentGeneral=mServerData.RecordTabel[1]
		mLayer:addChild(layer,0)
	end	
end;

function showLayer()
	

end;
function releaseBossLayer()
	if mBossLayer then
		mBossLayer:getParent():removeChild(mBossLayer,true)
		mBossLayer=nil
	end
end;

function createBossLayer()
	releaseBossLayer()
	local layer=CCLayer:create()
	mBossLayer=layer
	mLayer:addChild(layer,0)
	
end;

-- �˳�����
function closeScene()
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
	mLayer=nil
	mScene=nil
end


-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionID = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
end



