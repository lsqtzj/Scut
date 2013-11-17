
-- SBattleResult.lua.lua
-- Author     :Lysong
-- Version    : 1.0.0.0
-- Date       :
-- Description:
------------------------------------------------------------------

module("SBattleResult", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

mScene = nil 		-- ����

local list1={}

-- �������
function init()
	initResource()
	createScene()
	
end

-- �˳�����
function popScene()
	
--	if list1.Exchange==0 then--��Ϊ0�ǽ����콱
		PersonalInfo.getPersonalInfo().Shengjita=1
		releaseResource()
		TrialScene.init()
--	elseif list1.Exchange~=0 then--����ս��
		
--	end


--	ShengjitaScene.releseShowLayer()
--	ShengjitaScene.gotoScene(mScene)
--	ShengjitaScene.showduihuan()
end


--
-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()

end

-- �ͷ���Դ
function releaseResource()
	rewardLayer =nil
	
end

-- ��������
function createScene(Score,StarNum)
	local scene = ScutScene:new()
    mScene = scene.root
	scene:registerCallback(networkCallback)

		mScene:registerScriptHandler(SpriteEase_onEnterOrExit)
	SlideInLReplaceScene(mScene,1)
	
	-- �������
	mLayer= CCLayer:create()
	mScene:addChild(mLayer, 1)
	
	score=Score
	starnum=StarNum

	--��������
--	local bgLayer = UIHelper.createUIBg(nil, nil, nil,"BattleResult.popScene")
--	mLayer:addChild(bgLayer,0)

	local bgLayer = creatBg(tabStr)
	mLayer:addChild(bgLayer, 0)	


	-- �˴���ӳ�����ʼ����
	
	--����һ��
	local topBtn=ZyButton:new("button/list_1023.png",nil,nil,Language.ZHANDOUHUIFANG)
	topBtn:registerScriptHandler(againAction)
	topBtn:setAnchorPoint(PT(0,0))
	topBtn:setPosition(PT(pWinSize.width*0.45-topBtn:getContentSize().width, pWinSize.height*0.225))	
	topBtn:addto(mLayer, 0)	
	
	--�ر�
	local topBtn=ZyButton:new("button/list_1023.png",nil,nil,Language.IDS_COLSE)
	topBtn:registerScriptHandler(popScene)
--	topBtn:registerScriptHandler(lingquAction)
	topBtn:setAnchorPoint(PT(0,0))
	topBtn:setPosition(PT(pWinSize.width*0.55, pWinSize.height*0.225))	
	topBtn:addto(mLayer, 0)
	

	MainMenuLayer.init(1, mScene)
	
	actionLayer.Action4406(mScene, nil,1,Score,StarNum)

end


function SpriteEase_onEnterOrExit (tag)
    if tag == "exit" then
        releaseResource()
    end
end



function againAction()
	local fightInfo=ZyTable.th_table_dup(PersonalInfo.getPersonalInfo().fightinfo)	
	SbattleScene.init(fightInfo)
end

--��������
function creatBg(tabStr)
	local layer = CCLayer:create()
	
	local boxSize = SZ(pWinSize.width, pWinSize.height*0.7)
	local pos_x = 0
	local pos_y = pWinSize.height*0.145
	
	local bgSprite=CCSprite:create(P("common/list_1043.png"))
	bgSprite:setAnchorPoint(PT(0,0))
	bgSprite:setPosition(PT(pos_x,pos_y))
	bgSprite:setScaleX(boxSize.width/bgSprite:getContentSize().width)
	bgSprite:setScaleY(boxSize.height/bgSprite:getContentSize().height)
	layer:addChild(bgSprite,0)
	
	--����
	local titleSprite=CCSprite:create(P("title/list_1098.png"))
	titleSprite:setAnchorPoint(PT(0.5,0))
	titleSprite:setPosition(PT(pos_x+boxSize.width*0.5,pos_y+boxSize.height*0.9-titleSprite:getContentSize().height))
	layer:addChild(titleSprite,0)
	

	layer:setContentSize(boxSize)

	
	return layer
end;

--��ʾ����
function showReward()

	local layer = CCLayer:create()
	mLayer:addChild(layer, 0)
	
	rewardLayer = layer	
	

	local titleSize = FONT_DEF_SIZE
	
	local startX = pWinSize.width*0.05
	local height = pWinSize.height*0.7
	
	--��������
	local label = CCLabelTTF:create(Language.YONGCHUANG..list1.CurrentLayer..Language.CENG, FONT_NAME, titleSize)
	label:setAnchorPoint(PT(0.5,0))
	label:setPosition(PT(pWinSize.width/2, height))
	layer:addChild(label, 0)
	--�Ǽ�ͼstarnum score
	if starnum*score==1 then
		image="mainUI/list_3043.png"
	elseif starnum*score==2 then
		image="mainUI/list_3044.png"
	elseif starnum*score==3 then
		image="mainUI/list_3045.png"
	elseif starnum*score==4 then
		image="mainUI/list_3050.png"
	elseif starnum*score==6 then
		image="mainUI/list_3046.png"
	elseif starnum*score==9 then
		image="mainUI/list_3047.png"
	end
	local starImg=CCSprite:create(P(image))
	starImg:setAnchorPoint(PT(0.5,0))
	starImg:setPosition(PT(pWinSize.width/2,label:getPosition().y-starImg:getContentSize().height*1.1))
	layer:addChild(starImg,0)	
	
	local assessLabel = CCLabelTTF:create(Language.ZHANDOU_1..list1.Exchange..Language.ZHANDOU_2, FONT_NAME, titleSize)
	assessLabel:setAnchorPoint(PT(0,0))
	height = height-assessLabel:getContentSize().height*1.5
	assessLabel:setPosition(PT((pWinSize.width-assessLabel:getContentSize().width)/2, starImg:getPosition().y-assessLabel:getContentSize().height*4))
	layer:addChild(assessLabel, 0)
	
	local assessLabel1 = CCLabelTTF:create(Language.ZHANDOU_1..list1.Receive..Language.ZHANDOU_3, FONT_NAME, titleSize)
	assessLabel1:setAnchorPoint(PT(0,0))
	height = height-assessLabel1:getContentSize().height*1.5
	assessLabel1:setPosition(PT((pWinSize.width-assessLabel1:getContentSize().width)/2,assessLabel:getPosition().y-assessLabel1:getContentSize().height*1.2 ))
	layer:addChild(assessLabel1, 0)
	

end

function  createBar(width,picPath,currentValue,maxValue,pos,father)
    local  proBar = CCSprite:create(P(picPath))
	if not maxValue or maxValue < 0 then
		maxValue=100
	end
	if not currentValue then
		currentValue = 0
	end
	
	local scale=currentValue/maxValue 
	if scale>1 then
		scale=1
	end
	draw_w=width*scale  --ʵ�ʻ��Ƴ���
	
	if draw_w< proBar:getContentSize().width then
		draw_w= proBar:getContentSize().width
	end
	proBar:setScaleX(draw_w/proBar:getContentSize().width)
	proBar:setAnchorPoint(PT(0,0))
	proBar:setPosition(PT(pos.x,pos.y))
	father:addChild(proBar,1)
	if currentValue==0 then
		proBar:setVisible(false)
	end
	
	return proBar
end;

-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionId = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	
	if actionId==4406 then
		local serverInfo=actionLayer._4406Callback(pScutScene, lpExternalData)
 		if serverInfo~=nil then
			list1=serverInfo
			PersonalInfo.getPersonalInfo().Exchange=list1.Exchange
			PersonalInfo.getPersonalInfo().Receive=list1.Receive
		end;
		showReward()
--	elseif actionId==4401 then
--		ShengjitaScene.gotoScene(mScene)
--		popScene()
--		ShengjitaScene.networkCallback(pScutScene, lpExternalData)
	end
	
end