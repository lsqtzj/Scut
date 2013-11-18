
-- RelicScene.lua.lua
-- Author     :Lysong
-- Version    : 1.0.0.0
-- Date       :
-- Description:
------------------------------------------------------------------

module("RelicScene", package.seeall)

require("scenes.RelicArchaeology")

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

local mScene= nil 
local mLayer=nil

--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��

function setLayer(scene, layer)
	fatherLayer = layer
	mScene = scene
end;

-- �������
function close()
	 if showLayer ~= nil then
		showLayer:getParent():removeChild(showLayer, true)
		showLayer = nil
	end
	if mLayer then
		mLayer:getParent():removeChild(mLayer, true)
		mLayer = nil
	end
	initResource()
end


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
--	releseShowLayer()
	showLayer=nil
end
-- ��������
function init()
	initResource()
	local layer = CCLayer:create()
	fatherLayer:addChild(layer, 0)
	mLayer= layer
	

		mScene:registerScriptHandler(SpriteEase_onEnterOrExit)
		
	-- �˴���ӳ�����ʼ����                  
	local bg1 = "kaogu/map_1007.png"
	local imageBg = CCSprite:create(P(bg1));
	imageBg:setScaleX(pWinSize.width*0.92/imageBg:getContentSize().width)
	imageBg:setScaleY(pWinSize.height*0.7/imageBg:getContentSize().height)
	imageBg:setAnchorPoint(PT(0,0))
	imageBg:setPosition(PT(pWinSize.width*0.04,pWinSize.height*0.2))
	mLayer:addChild(imageBg,0)
	
	--����������
	local titleBg = CCSprite:create(P("kaogu/list_3020.png"))
	titleBg:setAnchorPoint(PT(0,0))
	titleBg:setPosition(PT((pWinSize.width-titleBg:getContentSize().width)/2, pWinSize.height*0.77))
	mLayer:addChild(titleBg, 0)
	
	showContent()
	
end

function SpriteEase_onEnterOrExit (tag)
    if tag == "exit" then
        releaseResource()
    end
end


function releseShowLayer()
	if showLayer ~= nil then
		showLayer:getParent():removeChild(showLayer, true)
		showLayer = nil
	end
end

function showContent()
	if showLayer ~= nil then
		showLayer:getParent():removeChild(showLayer, true)
		showLayer = nil
	end
	local layer = CCLayer:create()
	mLayer:addChild(layer, 0)
	showLayer = layer
	
	--��ʼ���Ű�ť
	local getBtn=ZyButton:new(Image.image_button_red_c_0,Image.image_button_red_c_1,nil,Language.STARTKAOGU,FONT_NAME,FONT_SM_SIZE)
	getBtn:setAnchorPoint(PT(0,0))
	getBtn:setPosition(PT((pWinSize.width-getBtn:getContentSize().width)/2,pWinSize.height*0.47))
	getBtn:registerScriptHandler(goto)
	getBtn:addto(showLayer, 0)
	
	local imageBg = CCSprite:create(P("shengjita/list_3016.9.png"));
	imageBg:setScaleX(pWinSize.width/imageBg:getContentSize().width*0.85)
	imageBg:setScaleY(pWinSize.height/imageBg:getContentSize().height*0.15)
	imageBg:setAnchorPoint(PT(0,0))
	imageBg:setPosition(PT(pWinSize.width*0.08,pWinSize.height*0.27))
	showLayer:addChild(imageBg,0)
	
	--����
	local content=string.format("<label>%s</label>",Language.KAOGUJIESHAO)
	local multiWidth=pWinSize.width*0.75
	local ndMultiLabe=ZyMultiLabel:new(content,multiWidth,FONT_NAME,FONT_SM_SIZE)
	ndMultiLabe:setAnchorPoint(PT(0,1))
	ndMultiLabe:setPosition(PT((pWinSize.width-ndMultiLabe:getContentSize().width)/2,imageBg:getPosition().y+(pWinSize.height*0.15-ndMultiLabe:getContentSize().height)/2))
	ndMultiLabe:addto(showLayer,0)
	
end

function goto()
	actionLayer.Action12057(mScene,nil)
--	close()
--	RelicArchaeology.init()
end;

-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionID = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	
	if actionID==12057 then
		local serverInfo=actionLayer._12057Callback(pScutScene, lpExternalData)
 		if serverInfo~=nil then
			mRecordTabel=serverInfo.RecordTabel
		end
		close()
		RelicArchaeology.init(mRecordTabel)
	end
	
end