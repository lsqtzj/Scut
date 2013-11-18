------------------------------------------------------------------
-- CreatNewMan.lua
-- Author     : Zonglin Liu
-- Version    : 1.0
-- Date       :   
-- Description: ��ɫ��������
------------------------------------------------------------------

module("CreatNewMan", package.seeall)
require("lib.ZyRandomName")


mScene = nil 		-- ����



-- �������
function pushScene()
	initResource()
	createScene()
end

-- �˳�����
function popScene()
	releaseResource()
	LoginScene.init()
end

--
-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()
---[[
	heroTable = {
		--ְҵid   ְҵ����   �Ա�0��  1Ů��  ְҵ����  ͷ��ͼƬ  ȫ��ͼƬ  ѡ���Ч  x����  y����  �㼶
		{CareerId = 1, Career = Language.LOGIN_CAREER1, Sex = 0, DES = Language.LOGIN_DES1, headID = "smallitem/Icon_1000.png", bodyID = "common/list_1055.png", shadeID = "common/list_1060.png", posX = pWinSize.width*0.13, posY = pWinSize.height*0.65, Tag = 3, GeneralID = 20001, imageId = 1000, },
		
		{CareerId = 2, Career = Language.LOGIN_CAREER2, Sex = 1, DES = Language.LOGIN_DES2, headID = "smallitem/Icon_1001.png", bodyID = "common/list_1056.png", shadeID = "common/list_1061.png", posX = pWinSize.width*0.32, posY = pWinSize.height*0.7, Tag = 2, GeneralID = 20002, imageId = 1001, },
		
		{CareerId = 3, Career = Language.LOGIN_CAREER3, Sex = 0, DES = Language.LOGIN_DES3, headID = "smallitem/Icon_1002.png", bodyID = "common/list_1057.png", shadeID = "common/list_1062.png", posX = pWinSize.width*0.5, posY = pWinSize.height*0.73, Tag = 1, GeneralID = 20003, imageId = 1002, },
		
		{CareerId = 4, Career = Language.LOGIN_CAREER4, Sex = 0, DES = Language.LOGIN_DES4, headID = "smallitem/Icon_1003.png", bodyID = "common/list_1058.png", shadeID = "common/list_1063.png", posX = pWinSize.width*0.68, posY = pWinSize.height*0.68, Tag = 2, GeneralID = 20004, imageId = 1003,  },
		
		{CareerId = 5, Career = Language.LOGIN_CAREER5, Sex = 1, DES = Language.LOGIN_DES5, headID = "smallitem/Icon_1004.png", bodyID = "common/list_1059.png", shadeID = "common/list_1064.png", posX = pWinSize.width*0.87, posY = pWinSize.height*0.63, Tag = 3, GeneralID = 20005, imageId = 1004,  },
		
	}
	--]]
end

-- �ͷ���Դ
function releaseResource()
	backAction()
	if m_choiceImge then
		m_choiceImge:getParent():removeChild(m_choiceImge, true)
		m_choiceImge = nil
	end	
	if heroLayer ~= nil then
		heroLayer:getParent():removeChild(heroLayer, true)
		heroLayer = nil	
	end
	if bgLayer ~= nil then
		bgLayer:getParent():removeChild(bgLayer, true)
		bgLayer = nil
	end	
	careerDes = nil
	heroTable = nil
end

-- ��������
function createScene()
	local scene  = ScutScene:new()
	-- ע������ص�
	scene:registerCallback(networkCallback)	
    mScene = scene.root 
	runningScene = CCDirector:sharedDirector():getRunningScene()
	if runningScene == nil then
		CCDirector:sharedDirector():runWithScene(mScene)
	else
	--	 SlideInLReplaceScene(mScene)
		 commReplaceScene(mScene)
	end



	
	-- �������
	mLayer= CCLayer:create()
	mScene:addChild(mLayer, 0)

	
	-- �˴���ӳ�����ʼ����
	 creatBg()
	 
	 showHero()
	
	--actionLayer.Action1026(mScene, nil)
	 
end

--������ʼ����
function creatBg()
	if bgLayer ~= nil then
		bgLayer:getParent():removeChild(bgLayer, true)
		bgLayer = nil
	end

	local layer = CCLayer:create()
	mLayer:addChild(layer, 0)
	bgLayer = layer
	
	--�󱳾�
	local titleBg=CCSprite:create(P("common/list_1015.png"))
	titleBg:setAnchorPoint(PT(0,0))
	titleBg:setPosition(PT(0, 0))
	titleBg:setScaleX(pWinSize.width/titleBg:getContentSize().width)
	titleBg:setScaleY(pWinSize.height/titleBg:getContentSize().height)	
	layer:addChild(titleBg,0)		
	
	
	--��������
	local titleBg=CCSprite:create(P("common/list_1047.png"))
	titleBg:setAnchorPoint(PT(0.5,0))
	local scale = pWinSize.width/titleBg:getContentSize().width
	titleBg:setPosition(PT(pWinSize.width/2, pWinSize.height-titleBg:getContentSize().height*scale))
	titleBg:setScale(scale)
	layer:addChild(titleBg,0)
	
	--ѡ���ʼӢ��  ����
	local titleImg=CCSprite:create(P("title/list_1094.png"))
	titleImg:setAnchorPoint(PT(0.5,0))
	titleImg:setPosition(PT(pWinSize.width/2, pWinSize.height-titleImg:getContentSize().height*1.25))
	layer:addChild(titleImg,0)


	--Ӷ����̨����
	local heroBg=CCSprite:create(P("common/list_1066.png"))
	local scale = pWinSize.width/heroBg:getContentSize().width
	heroBg:setScale(scale)
	heroBg:setAnchorPoint(PT(0,0))
	heroBg:setPosition(PT(0, titleBg:getPosition().y-heroBg:getContentSize().height*scale))
	layer:addChild(heroBg,0)

	--�ײ�����
	local endBg=CCSprite:create(P("common/list_1054.png"))
	endBg:setScaleX(pWinSize.width/endBg:getContentSize().width)
	endBg:setScaleY(pWinSize.height*0.45/endBg:getContentSize().height)
	endBg:setAnchorPoint(PT(0,0))
	endBg:setPosition(PT(0, 0))
	layer:addChild(endBg,0)
	
	

	--ְҵ���ܱ���
	local desBg=CCSprite:create(P("common/list_1052.9.png"))
	desBg:setScaleY(pWinSize.height*0.1/desBg:getContentSize().height)
	desBg:setAnchorPoint(PT(0,0))
	desBg:setPosition(PT(pWinSize.width*0.5-desBg:getContentSize().width*0.5, pWinSize.height*0.11))
	layer:addChild(desBg,0)
	
	careerDes = CCLabelTTF:create("", FONT_NAME, FONT_SM_SIZE)
	careerDes:setAnchorPoint(PT(0,0))
	careerDes:setPosition(PT(desBg:getPosition().x+pWinSize.width*0.1, pWinSize.height*0.145))
	layer:addChild(careerDes,0)
	

	--���ذ�ť
	local exitBtn =ZyButton:new(Image.image_button_red_c_0, Image.image_button_red_c_1, nil, Language.IDS_BACK, FONT_NAME, FONT_SM_SIZE)
	exitBtn:setColorNormal(ZyColor:colorYellow())
	exitBtn:setAnchorPoint(PT(0,0))
	exitBtn:setPosition(PT(pWinSize.width*0.4-exitBtn:getContentSize().width, pWinSize.height*0.03))
	exitBtn:registerScriptHandler(popScene)
	exitBtn:addto(layer, 0)
	
	local RetailId=accountInfo.getRetailId()
	if RetailId == "0001" or RetailId == "0036" or RetailId == "0037" then
		exitBtn:setVisible(false)
	end
	
	--��һ����ť
	local nextBtn =ZyButton:new(Image.image_button_red_c_0, Image.image_button_red_c_1, nil, Language.IDS_NEXT, FONT_NAME, FONT_SM_SIZE)
	nextBtn:setColorNormal(ZyColor:colorYellow())
	nextBtn:setAnchorPoint(PT(0,0))
	nextBtn:setPosition(PT(pWinSize.width*0.6, pWinSize.height*0.03))
	nextBtn:registerScriptHandler(nextAction)
	nextBtn:addto(layer, 0)




	
	
	
end

--��ʾ��ʼӢ��
function showHero()
	if heroLayer ~= nil then
		heroLayer:getParent():removeChild(heroLayer, true)
		heroLayer = nil	
	end

	local layer = CCLayer:create()
	mLayer:addChild(layer, 0)
	
	heroLayer = layer


	buttonTabel={}
	for i=1,5 do

		local image = heroTable[i].headID
		local career = heroTable[i].Career
		local memberCallBack = CreatNewMan.key_head
		local item,m_choiceImge = creatHeadItem(image, career, i, memberCallBack)
		local pos_x = pWinSize.width*0.08+pWinSize.width*0.17*(i-1)
		local pos_y = pWinSize.height*0.23
		item:setAnchorPoint(PT(0,0))
		item:setPosition(PT(pos_x, pos_y))
		layer:addChild(item, 0)
		
		
---[[
		
		local sprite = ZyButton:new(heroTable[i].shadeID, heroTable[i].bodyID)
		local start_x = heroTable[i].posX-sprite:getContentSize().width*0.5
		local start_y = heroTable[i].posY-sprite:getContentSize().height*0.5
		sprite:setAnchorPoint(PT(0,0))
		sprite:setPosition(PT(start_x,start_y))
		sprite:registerScriptHandler(key_head)
		sprite:setTag(i)
		
		
		local desBg=CCSprite:create(P(heroTable[i].shadeID))
		desBg:setAnchorPoint(PT(0,0))
		desBg:setPosition(PT(start_x,start_y))
		layer:addChild(desBg, heroTable[i].Tag)		
		
		sprite:addto(layer, heroTable[i].Tag)
		
--]]


		buttonTabel[i] = {}
		buttonTabel[i].item  = item
		buttonTabel[i].m_choiceImge = m_choiceImge
		buttonTabel[i].sprite  = sprite
	end
	
	
	key_head(nil, 1)
	
	



end

--��������Ӷ��ͷ��
function creatHeadItem(image, career, tag, memberCallBack)
	local menuItem = CCMenuItemImage:create(P("common/list_1012.png"), P("common/list_1012.png"))
	local btn = CCMenu:createWithItem(menuItem)
	
	menuItem:setAnchorPoint(PT(0,0))
	menuItem:registerScriptTapHandler(function () memberCallBack(menuItem) end )
	if tag then
		menuItem:setTag(tag)
	end
	btn:setContentSize(SZ(menuItem:getContentSize().width, menuItem:getContentSize().height))
	
	-- ��ƷͼƬ
	if image then
		local imageLabel = CCMenuItemImage:create(P(image),P(image))
		if imageLabel == nil then
			 return btn 
		end
		imageLabel:setAnchorPoint(CCPoint(0.5, 0))
		imageLabel:setPosition(PT(menuItem:getContentSize().width*0.5, menuItem:getContentSize().height*0.07))
		menuItem:addChild(imageLabel,0)
	end


	--���Ʊ���
	local careerBg=CCSprite:create(P("common/list_1067.png"))
	careerBg:setAnchorPoint(PT(0,0))
	careerBg:setPosition(PT(menuItem:getContentSize().width*0.5-careerBg:getContentSize().width*0.5, menuItem:getContentSize().height*1.1))
	menuItem:addChild(careerBg,0)
	
	--����
	if career then
		local nameLabel = CCLabelTTF:create(career, FONT_NAME, FONT_SM_SIZE)
		nameLabel:setAnchorPoint(PT(0.5, 0))
		nameLabel:setPosition(PT(menuItem:getContentSize().width*0.5, careerBg:getPosition().y+careerBg:getContentSize().height*0.5-nameLabel:getContentSize().height*0.5))
		menuItem:addChild(nameLabel, 0)
	end
	
	local item = menuItem
	local m_choiceImge = CCSprite:create(P(Image.Image_choicebox))
	m_choiceImge:setAnchorPoint(CCPoint(0.5, 0.5))
	m_choiceImge:setPosition(PT(item:getContentSize().width*0.5,item:getContentSize().height*0.5))
	m_choiceImge:setScaleX((item:getContentSize().width)/m_choiceImge:getContentSize().width)
	m_choiceImge:setScaleY((item:getContentSize().height)/m_choiceImge:getContentSize().height)
	item:addChild(m_choiceImge,0)
	
	m_choiceImge:setVisible(false)
	return  btn,m_choiceImge


end;

--���Ӷ����Ӧ
function key_head(pNode, index)
	local tag =nil
	if index then
		tag = index
	else
		tag = pNode:getTag()
	end	
	for k,v in ipairs(buttonTabel) do
		if tag == k then
			v.sprite:selected()
			v.m_choiceImge:setVisible(true)
		else
			v.sprite:unselected()
			v.m_choiceImge:setVisible(false)
		end
	end
	careerDes:setString(heroTable[tag].DES)
	m_choiceID = tag
end

--------------------------------------------------
--�������ֽ���
function nextAction()
	inPutName()
end;

function inPutName()
	if inPutLayer ~= nil then
		inPutLayer:getParent():removeChild(inPutLayer, true)
		inPutLayer = nil
	end
	local layer = CCLayer:create()
	mLayer:addChild(layer, 0)
	
	inPutLayer = layer
	
	--���ΰ�ť
	local unTouchBtn =  ZyButton:new(Image.image_transparent)
	unTouchBtn:setScaleX(pWinSize.width/unTouchBtn:getContentSize().width)
	unTouchBtn:setScaleY(pWinSize.height/unTouchBtn:getContentSize().height)
	unTouchBtn:setAnchorPoint(PT(0,0))
	unTouchBtn:setPosition(PT(0,0))
	unTouchBtn:addto(layer, 0)
	
	--�󱳾�
	local titleBg=CCSprite:create(P("common/list_1015.png"))
	titleBg:setScaleX(pWinSize.width/titleBg:getContentSize().width)
	titleBg:setScaleY(pWinSize.height/titleBg:getContentSize().height)	
	titleBg:setAnchorPoint(PT(0,0))
	titleBg:setPosition(PT(0, 0))
	layer:addChild(titleBg,0)		
	
	
	--��������
	local titleBg=CCSprite:create(P("common/list_1047.png"))
	titleBg:setScaleX(pWinSize.width/titleBg:getContentSize().width)
	titleBg:setAnchorPoint(PT(0.5,0))
	titleBg:setPosition(PT(pWinSize.width/2, pWinSize.height-titleBg:getContentSize().height))
	layer:addChild(titleBg,0)	
	--�������û���  ����
	local titleLabel=CCLabelTTF:create(Language.LOGIN_TITLE2,FONT_NAME,FONT_BIG_SIZE);
	titleLabel:setAnchorPoint(PT(0.5,0))
	titleLabel:setPosition(PT(pWinSize.width/2,pWinSize.height-titleBg:getContentSize().height*0.5))
	layer:addChild(titleLabel, 0)
	
	--�ײ�����
	local endBg=CCSprite:create(P("common/list_1050.png"))
	endBg:setScaleX(pWinSize.width/titleBg:getContentSize().width)
	endBg:setAnchorPoint(PT(0,0))
	endBg:setPosition(PT(0, 0))
	layer:addChild(endBg,0)


	--����������ͼ
	
	local edit_width = pWinSize.width*0.7
	local edit_height = pWinSize.height*0.05
	local edit_x = pWinSize.width*0.5-edit_width*0.5
	local edit_y = pWinSize.height*0.75
	
	local bgEmpty= CCSprite:create(P(Image.image_input_beijing));
	bgEmpty:setScaleX(edit_width/bgEmpty:getContentSize().width)
	bgEmpty:setScaleY(edit_height/bgEmpty:getContentSize().width)
	bgEmpty:setAnchorPoint(PT(0,0))
	bgEmpty:setPosition(PT(edit_x, edit_y))
	layer:addChild(bgEmpty, 0)
	
	if m_EditTxt~=nil then
		m_EditTxt:release()
		m_EditTxt=nil
	end
	m_EditTxt = CScutEdit:new()
	m_EditTxt:init(false, false)
	m_EditTxt:setRect(CCRect(edit_x, pWinSize.height-edit_y-edit_height, edit_width, edit_height))
	m_EditTxt:setVisible(true)--�Ƿ���ʾ
	local str=ZyRandomName.RandomNickName()
	m_EditTxt:setText(str)
	--������ְ�ť ɫ��
	local randomNameBtn=ZyButton:new("common/icon_1237.png")
	randomNameBtn:setAnchorPoint(PT(0,0))
	randomNameBtn:setPosition(PT(edit_x+edit_width+SX(5),
					edit_y+edit_height*0.5-randomNameBtn:getContentSize().height*0.5))
	randomNameBtn:addto(layer,0)
	randomNameBtn:registerScriptHandler(randomNameAction)
	
	--���ذ�ť
	local exitBtn =ZyButton:new(Image.image_button_red_c_0, Image.image_button_red_c_1, nil, Language.IDS_BACK, FONT_NAME, FONT_SM_SIZE)
	exitBtn:setColorNormal(ZyColor:colorYellow())
	exitBtn:setAnchorPoint(PT(0,0))
	exitBtn:setPosition(PT(pWinSize.width*0.4-exitBtn:getContentSize().width, pWinSize.height*0.25))
	exitBtn:registerScriptHandler(backAction)
	exitBtn:addto(layer, 0)
	
	--������Ϸ��ť
	local nextBtn =ZyButton:new(Image.image_button_red_c_0, Image.image_button_red_c_1, nil, Language.LOGIN_IN, FONT_NAME, FONT_SM_SIZE)
	nextBtn:setColorNormal(ZyColor:colorYellow())
	nextBtn:setAnchorPoint(PT(0,0))
	nextBtn:setPosition(PT(pWinSize.width*0.6, pWinSize.height*0.25))
	nextBtn:registerScriptHandler(creatAction)
	nextBtn:addto(layer, 0)	

	--Ĭ������һ������
	randomNameAction()
end;

--���س�ʼӶ��ѡ�����
function backAction()
	if m_EditTxt~=nil then
		m_EditTxt:release()
		m_EditTxt=nil
	end
	if inPutLayer ~= nil then
		inPutLayer:getParent():removeChild(inPutLayer, true)
		inPutLayer = nil
	end	
end

function randomNameAction()
	local str=ZyRandomName.RandomNickName()
	if m_EditTxt then
		m_EditTxt:setText(str)
	end
end;


--������ɫ
function creatAction()
	local userName=m_EditTxt:GetEditText()
	local Sex = heroTable[m_choiceID].Sex or 0
	local head_ID = heroTable[m_choiceID].imageId or 0
	local CareerID= heroTable[m_choiceID].CareerId or 0
	local GeneralID = heroTable[m_choiceID].GeneralID--�������ѡӶ��������û����
	accountInfo.readMoble()
	local serverID=accountInfo.readServerId()
	local   mPassportID, mPassWord=accountInfo.readAccount()
	if PersonalInfo.getPersonalInfo()._Pid~=nil then
		mPassportID=PersonalInfo.getPersonalInfo()._Pid
	end
	m_EditTxt:setVisible(false)
	actionLayer.Action1005(mScene,nil,
	userName,
	Sex,
	head_ID,
	CareerID,
	accountInfo.mRetailID,
	mPassportID,
	accountInfo.mMobileType,
	pWinSize.width,
	pWinSize.height,
	accountInfo.ClientAppVersion,
	accountInfo.mGameType,
	serverID,
	GeneralID)	
end;









-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionId = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	if actionId == 1005 then--1005_������ɫ��ID=1005��
		local serverInfo = actionLayer._1005Callback(pScutScene, lpExternalData)
		m_EditTxt:setText("")
		m_EditTxt:setVisible(true)
		if serverInfo ~= nil then
			releaseResource()
			progressLayer.replaceScene(1)
		end
	elseif actionId == 1016 then-- 1016_���ȡ������ֽӿ�
  	     if ZyReader:getResult() == eScutNetSuccess then
	    		local str=ZyReader:readString()
			if m_EditTxt~=nil then
				m_EditTxt:setText(str)
			end
		else
			ZyToast.show(pScutScene,ZyReader:readErrorMsg(),1,0.35)
	   	 end	
	elseif actionId == 1026 then
		local serverInfo = actionLayer._1026Callback(pScutScene, lpExternalData)
		if serverInfo ~= nil then
			heroTable = serverInfo.RecordTabel
			showHero()
		end
	end
	
end