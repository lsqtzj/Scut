------------------------------------------------------------------
-- BSDiscountScene.lua.lua
-- Author     : yeyq

-- Version    : 1.0
-- Date       :
-- Description: �̳Ǵ���
------------------------------------------------------------------

module("BSDiscountScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

local g_scene = nil 		-- ����
local g_layer = nil 
local g_activeTable = nil



-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()
end
-- �ͷ���Դ
function releaseResource()
	if  g_layer  then
		g_layer:getParent():removeChild(g_layer,true)
		g_layer = nil 		
	end
end
-- ��������
function init(mScene,Flayer,table)
	g_scene = mScene
	initResource()
	g_activeTable= table
	-- ��ӱ���
	g_layer = CCLayer:create()
	Flayer:addChild(g_layer, 0)
	-- ע�ᴥ���¼�
	g_layer.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHBEGAN, "BSDiscountScene.touchBegan")
	g_layer.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHMOVED, "BSDiscountScene.touchMove")
	g_layer.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHENDED, "BSDiscountScene.touchEnd")

	-- �˴���ӳ�����ʼ����
	local BgImgW  = pWinSize.width*0.92
	local BgImgH = pWinSize.height*0.69
	local  BgImg = CCSprite:create(P("activeBg/list_1157.jpg"))
	BgImg:setScaleX(BgImgW/BgImg:getContentSize().width)
	BgImg:setScaleY(BgImgH/BgImg:getContentSize().height)
	g_layer:addChild(BgImg,0)
	BgImg:setAnchorPoint(PT(0,0))
	BgImg:setPosition(PT(pWinSize.width*0.5-BgImgW/2,pWinSize.height*0.21))
	
	
	
	local strImg = CCSprite:create(P("title/list_1158.png"))
	g_layer:addChild(strImg,0)
	strImg:setAnchorPoint(PT(0,0))
	titleHeight = BgImg:getPosition().y+BgImgH-SY(50)	
	strImg:setPosition(PT((pWinSize.width-strImg:getContentSize().width)/2,titleHeight))

	
	local gotoButton  = ZyButton:new("button/list_1023.png",nil,nil,Language.RecruitScene_buttonStr,FONT_NAME,FONT_SM_SIZE)
	gotoButton:setAnchorPoint(PT(0.5,0.5))
	gotoButton:setPosition(PT(pWinSize.width*0.5,pWinSize.height*0.3))
	gotoButton:addto(g_layer,0)
	gotoButton:registerScriptHandler(gotoAction)

	showLayer()
	
	
end
function showLayer()
		local  BSDiscount_Str =   string.format(Language.Active_Date,g_activeTable.StartDate,g_activeTable.EndDate)
		local activeStr= CCLabelTTF:create(BSDiscount_Str,FONT_NAME,FONT_SM_SIZE)
		g_layer:addChild(activeStr,0)
		activeStr:setAnchorPoint(PT(0,0))
		activeStr:setPosition(PT(pWinSize.width*0.05,titleHeight-SY(20)))
		
		local contentStr= string.format(Language.Active_ContentStr,g_activeTable.FestivalDesc )
		local str = string.format("<label>%s</label>",contentStr)
		local activeStr1 = ZyMultiLabel:new(str,pWinSize.width*0.9,FONT_NAME,FONT_SM_SIZE)
		activeStr1:addto(g_layer,0)
		activeStr1:setAnchorPoint(PT(0,0))
		activeStr1:setPosition(PT(activeStr:getPosition().x,activeStr:getPosition().y-SY(20)))
end
function gotoAction()
	MainMenuLayer.funcAction(true,37)
end


-- ��������
function touchBegan(e)
end
-- �����ƶ�
function touchMove(e)
end
-- ��������
function touchEnd(e)
end
-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionID = NdReader:getActionID()

	local userData = ScutRequestParam:getParamData(lpExternalData)
end