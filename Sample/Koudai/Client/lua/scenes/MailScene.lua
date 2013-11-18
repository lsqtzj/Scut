------------------------------------------------------------------
-- MailScene.lua
-- Author     :JUNM CHEN
-- Version    : 1.0
-- Date       :�ż�
-- Description: ,
------------------------------------------------------------------
module("MailScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

local mScene = nil 		-- ����
local mLayer=nil
local mCurrentTab=nil
local personalInfo=nil
local mServerData=nil

local topHeight=nil
local mNoneLabel=nil
--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��
-- �˳�����
function closeScene()
	releaseResource()
end


function init()
	if mScene then
		return
	end
	initResource()
	local scene  = ScutScene:new()
		mScene:registerScriptHandler(SpriteEase_onEnterOrExit)
		
	-- ע������ص�
	scene:registerCallback(networkCallback)
	mScene = scene.root 
	SlideInLReplaceScene(mScene,1)
	-- ��ӱ���
	mLayer = CCLayer:create()
	mScene:addChild(mLayer, 0)
	local topSprite=CCSprite:create(P("mainUI/list_1000.png"))
	topHeight=topSprite:getContentSize().height
	-- �˴���ӳ�����ʼ����
	if not  mCurrentTab then
		mCurrentTab=1
	end	
-----
	local bgLayer=createContentLayer()
	bgLayer:setPosition(PT(0,0))
	mLayer:addChild(bgLayer,0)
	local tabStr={Language.MAILL_ALL,Language.MAILL_FIGHT,Language.MAILL_FRIEND,Language.MAILL_SYSTEM}
	mTabBar=createTabbar(tabStr,mLayer)
	local listSize=SZ(pWinSize.width*0.9,pWinSize.height*0.6)
	local listX=(pWinSize.width-listSize.width)/2
	local listY=mTabBar:getPosition().y-listSize.height-SY(2)
	local mListRowHeight=pWinSize.height*0.18
	local list = ScutCxList:node(mListRowHeight, ccc4(24, 24, 24, 0), listSize)
	list:setAnchorPoint(PT(0,0))
	list:setPosition(PT(listX,listY))
	list:setRecodeNumPerPage(1)
	mLayer:addChild(list,0)
	list:setTouchEnabled(true)
	mList=list
	showLayer()	
	MainMenuLayer.init(1, mScene)
end;



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
	local midSprite=CCSprite:create(P("common/list_1040.png"))
	local boxSize=SZ(pWinSize.width,midSprite:getContentSize().height)
	midSprite:setAnchorPoint(PT(0.5,0))
	midSprite:setScaleX(boxSize.width/bgSprite:getContentSize().width)
	midSprite:setPosition(PT(pWinSize.width/2,pWinSize.height-boxSize.height-topHeight*1.1))
	layer:addChild(midSprite,0)
	return layer
end;

--����tabbar
function  createTabbar(tabStr,layer)
	local tabBar=nil
	local midSprite=CCSprite:create(P("common/list_1024.png"))
	if tabStr then
	  	tabBar=ZyTabBar:new(nil,nil,tabStr,FONT_NAME,FONT_SM_SIZE,3)
		tabBar:selectItem(mCurrentTab)	
		local tabBar_X=pWinSize.width*0.04
		local tabBar_Y=pWinSize.height-topHeight*1.1-tabBar:getContentSize().height
		tabBar:setAnchorPoint(PT(0,0))
		tabBar:setPosition(PT(tabBar_X,tabBar_Y))
		tabBar:setCallbackFun(callbackTabBar)
		tabBar:addto(layer,1)
	end
	return tabBar
end;

----tabbar��Ӧ
function callbackTabBar(bar,pNode)
    local index =pNode:getTag();
    if index ~=mCurrentTab then
	    mCurrentTab=index
	    showLayer()
    end
end;

--------û���ż���ʾ 
function  releaseNoLabel()
	if mNoneLabel then
		mNoneLabel:getParent():removeChild(mNoneLabel,true)
		mNoneLabel=nil
	end
end;

function  createNoLabel()
	releaseNoLabel()
	local noneLabel=CCLabelTTF:create(Language.MAILL_NONE,FONT_NAME,FONT_DEF_SIZE)
	mNoneLabel=noneLabel
	noneLabel:setAnchorPoint(PT(0.5,0.5))
	noneLabel:setPosition(PT(pWinSize.width/2,pWinSize.height*0.5))
	mLayer:addChild(noneLabel,2)
end;

--�������
function  showLayer()

	mServerData={}
	releaseNoLabel()
	if mCurrentTab==1 then
	elseif  mCurrentTab==2 then
		mServerData={{UserName=2,type=1},{UserName=2},}
	end
	 refreshMailList()
end;

--ˢ��list
function  refreshMailList()
	if mList and mServerData then
		mList:clear()
		if #mServerData>0 then
		local layout = CxLayout()
		layout.val_x.t = ABS_WITH_PIXEL
		layout.val_y.t = ABS_WITH_PIXEL
		layout.val_x.val.pixel_val = 0
		layout.val_y.val.pixel_val = 0
		for k, v in pairs(mServerData) do
		 	local listItem = ScutCxListItem:itemWithColor(ccc3(24,24,24))
			listItem:setOpacity(0)
			local itemLayer=createListItem(v,k)
			listItem:addChildItem(itemLayer, layout)
			mList:addListItem(listItem, false)
		end
		else
			 createNoLabel()
		end
	end
end;

function createListItem(info,index)
	local layer=CCLayer:create()
	local boxSize=SZ(mList:getContentSize().width,mList:getRowHeight())
	local startX=(pWinSize.width-boxSize.width)/2+SX(5)
	local startY=boxSize.height*0.9
	-----------
	local bgSprite=CCSprite:create(P("common/list_1038.9.png"))
	bgSprite:setScaleX(boxSize.width/bgSprite:getContentSize().width)
	bgSprite:setScaleY(boxSize.height/bgSprite:getContentSize().height)
	bgSprite:setAnchorPoint(PT(0,0))
	bgSprite:setPosition(PT(0,0))
	layer:addChild(bgSprite,0)
	------�������
	local userName=CCLabelTTF:create(info.UserName,FONT_NAME,FONT_SM_SIZE)
	userName:setAnchorPoint(PT(0,0))
	userName:setPosition(PT(startX,startY-userName:getContentSize().height))
	layer:addChild(userName,0)
	
	--˵������
	local contentStr=string.format("<label>%s</label>",Language.COMPETI_RETIP or Language.IDS_NONE)
	local contentLabel=ZyMultiLabel:new(contentStr,boxSize.width*0.9,FONT_NAME,FONT_SM_SIZE);
	contentLabel:setAnchorPoint(PT(0,0))
	contentLabel:setPosition(PT(startX,
								userName:getPosition().y-contentLabel:getContentSize().height-SY(2)))
	contentLabel:addto(layer,0)
	
	------ʱ��
	local timeLabel=CCLabelTTF:create(info.UserName,FONT_NAME,FONT_SM_SIZE)
	timeLabel:setAnchorPoint(PT(0,0))
	timeLabel:setPosition(PT(startX,SY(5)))
	layer:addChild(timeLabel,0)
	
	--������ť
	if info.type==1 then
		local attackBtn=ZyButton:new("button/list_1039.png",nil,nil,Language.MAILL_ATTACK)
		attackBtn:setAnchorPoint(PT(0,0))
		attackBtn:setPosition(PT(boxSize.width*0.95-attackBtn:getContentSize().width,
									timeLabel:getPosition().y))
		attackBtn:addto(layer,0)	
		attackBtn:setTag(index)
		attackBtn:registerScriptHandler("MailScene.attackBackAction")
	end
	return layer
	
end;

function attackBackAction(node)
	
end;





--
-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()
	personalInfo=PersonalInfo.getPersonalInfo()
	
	
end


-- �ͷ���Դ
function releaseResource()
	mLayer=nil
	mScene=nil
	mNoneLabel=nil
end


-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionID = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	
end