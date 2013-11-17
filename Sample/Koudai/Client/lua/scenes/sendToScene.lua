------------------------------------------------------------------
-- sendToScene.lua.lua
-- Author     : yeyq

-- Version    : 1.0
-- Date       :
-- Description:  �;���
------------------------------------------------------------------

module("sendToScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

_scene = nil 		-- ����
loveLayer = nil    -- ��ʾ��
layerBG = nil  ---- ����
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
	releaseResource()
	MainScene.init()
end

--
-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()
	_scene = nil 		-- ����
	layerBG = nil  ---- ����
	loveLayer =  nil  ----��ʾ��
end
-- �ͷ���Դ
function releaseResource()
	_scene = nil 		-- ����
layerBG = nil  ---- ����

if layerBG then
		layerBG:getParent():removeChild(layerBG, true)
		layerBG = nil
	end
end
-- ��������
function createScene()
	local scene  = ScutScene:new()
	-- ע������ص�
	scene:registerCallback(networkCallback)
	_scene = scene.root
	-- ��ӱ���
	layerBG = CCLayer:create()
	_scene:addChild(layerBG, 0)
	-- ע�ᴥ���¼�
	layerBG.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHBEGAN, "sendToScene.touchBegan")
	layerBG.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHMOVED, "sendToScene.touchMove")
	layerBG.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHENDED, "sendToScene.touchEnd")

	-- �˴���ӳ�����ʼ����
	local bigBgImg = CCSprite:create(P(Image.image_BIG));
	bigBgImg:setAnchorPoint(PT(0,0))
	bigBgImg:setPosition(PT(0,0))
	layerBG:addChild(bigBgImg, 0)
	
	local borderImg = CCSprite:create(P(Image.image_BIGBorder));
--	borderImg:setScaleX(pWinSize.width/sendBgImg:getContentSize().width)
	borderImg:setAnchorPoint(PT(0,0))
	borderImg:setPosition(PT(0,0))
	layerBG:addChild(borderImg, 0)
	
	

	
	--�رհ�ť
	local closeBtn=ZyButton:new("button/list_1046.png")
	closeBtn:registerScriptHandler(closeAction)						
	closeBtn:setAnchorPoint(PT(1,0))
	closeBtn:setPosition(PT(pWinSize.width-SX(2),
							pWinSize.height-closeBtn:getContentSize().height*1.1))	
	closeBtn:addto(layerBG,2)
	
	
	
	showLayer()
	
end
function showLayer()
	if loveLayer~=nil  then
			loveLayer:getParent():removeChild(loveLayer,true)
	end
	loveLayer = CCLayer:create()
	layerBG:addChild(loveLayer,1)
	
	
	
	local sendBgImgX =pWinSize.width*0.92
	local sendBgImg = CCSprite:create(P(Image.image_bgSendImg));
	sendBgImg:setScaleX(sendBgImgX/sendBgImg:getContentSize().width)
	sendBgImg:setScaleY(pWinSize.height*0.91/sendBgImg:getContentSize().height)
	
	sendBgImg:setAnchorPoint(PT(0,0))
	sendBgImg:setPosition(PT((pWinSize.width-sendBgImgX)/2,pWinSize.height*0.06))
	loveLayer:addChild(sendBgImg, 0)
	
	
	
	
	local loveImg = Image.image_loveHert
	--	local lovedImg = 
	
	local loveStr = Language.SEND_LOVE_ONE
	local loveButton = ZyButton:new(loveImg,nil,lovedImg,nil,FONT_NAME,FONT_SM_SIZE);
	loveButton:addto(loveLayer,0)
	loveButton:setTag(1)  																			
	loveButton:setAnchorPoint(PT(0,0))
	loveButton:setPosition(PT( pWinSize.width*0.07,pWinSize.height*0.42))
	loveButton:registerScriptHandler(onclick)
--	if  numberTime > 0 then 
	--	loveButton:setIsEnabled(false) ---�Ƿ���
--	end	
	local loveStr = CCLabelTTF:create(loveStr,FONT_NAME,FONT_SM_SIZE)
	loveLayer:addChild(loveStr,1)
	loveStr:setAnchorPoint(PT(0.5,0))
	loveStr:setPosition(PT(loveButton:getPosition().x+loveButton:getContentSize().width*0.5,
						loveButton:getPosition().y+loveButton:getContentSize().height*0.65))
		


	
	local loveStr1 = Language.SEND_LOVE_TO
	local loveButtonTo = ZyButton:new(loveImg,nil,lovedImg,nil,FONT_NAME,FONT_SM_SIZE);
	loveButtonTo:addto(loveLayer,0)
	loveButton:setTag(2)  																			
	loveButtonTo:setAnchorPoint(PT(0,0))
	loveButtonTo:setPosition(PT(pWinSize.width*0.54,pWinSize.height*0.38))
	loveButtonTo:registerScriptHandler(onclick)
--	if  numberTime > 0 then 
--		loveButtonTo:setIsEnabled(false) ---�Ƿ���
--	end	
	
	local loveStrTo= CCLabelTTF:create(loveStr1,FONT_NAME,FONT_SM_SIZE)
	loveLayer:addChild(loveStrTo,1)
	loveStrTo:setAnchorPoint(PT(0.5,0))
	loveStrTo:setPosition(PT(loveButtonTo:getPosition().x+loveButtonTo:getContentSize().width*0.5,
	loveButtonTo:getPosition().y+loveButtonTo:getContentSize().height*0.65))
	
	
	

end
function onclick()
	
end
function closeAction()
	popScene()
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
	
	if actionID == 11001 then 
		local serverInfo=actionLayer._11001Callback(pScutScene, lpExternalData)
		if serverInfo~=nil then
			
		
		end
	end 
	if actionID == 11002 then
		local serverInfo1 = actionLayer._11002Callback(pScutScene, lpExternalData)
		if serverInfo1 ~= nil then 
		
		end 
	end
	if actionID == 11003 then
	    if ZyReader:getResult() == 1  then
			local box = ZyMessageBoxEx:new()
			box:doQuery(pScutScene, nil, ZyReader:readErrorMsg() , Language.doString_OK, Language.IDS_BACK,refreshButton) 
	    elseif     ZyReader:getResult() == 0 then
	    		actionLayer.Action11001(_scene,nil)	
	    else
		       ZyToast.show(pScutScene,ZyReader:readErrorMsg(),1.5,0.35)
	    end
	end   
	
	
	local userData = ScutRequestParam:getParamData(lpExternalData)
end