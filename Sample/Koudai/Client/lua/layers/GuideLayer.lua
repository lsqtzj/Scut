------------------------------------------------------------------
-- GuideLayer.lua
-- Author     : Zonglin Liu
-- Version    : 1.0
-- Date       :   
-- Description: 
------------------------------------------------------------------

module("GuideLayer", package.seeall)


_IsGuide = nil
_GuideId = nil
mTaskStep = 1

function hide()
	if mLayer then
		mLayer:setVisible(false)
	end
	if priceLayer then
		priceLayer:setVisible(false)
	end
end

function show()
	if mLayer then
		mLayer:setVisible(true)
	end
	if priceLayer then
		priceLayer:setVisible(true)
	end
end


function  getTaskStep()
	return mTaskStep
end;


function setTaskStep(step)
	mTaskStep=step
end;

function setIsGuide(value, taskId, step)
	_IsGuide = value
	_GuideId = taskId
	mTaskStep = step
end;

function getIsGuide()
	return _IsGuide,_GuideId, mTaskStep
end;

-----------------------------------------------------
function judgeIsGuide(tag)
	local index = tag
	_currentWin = tag
	local _IsGuide, _GuideId, mTaskStep = GuideLayer.getIsGuide()	
	local isTrue = false

	
	if _IsGuide == 0 then
	
	else
		return false
	end

	local table = GuideConfigInfo.getJudgeInfo(_GuideId, mTaskStep)
	if table then
		for k,v in ipairs(table) do
			if v == _currentWin then
				isTrue = true
			end
		end
	end

	return isTrue
end






--
-------------------------˽�нӿ�------------------------
--


function close()
	if touchLayer then
		touchLayer:getParent():removeChild(touchLayer, true)
		touchLayer = nil	
	end
	if mLayer then
		mLayer:getParent():removeChild(mLayer, true)
		mLayer = nil	
	end
end


-- ��ʼ����Դ����Ա����
function initResource()
	
end

-- �ͷ���Դ
function releaseResource()
	touchLayer=nil
	mLayer = nil
	_currentWin = nil
	_layerRank=nil
end

-- ��������
function setScene(scene,layerRank)
	mScene =scene
	if layerRank then
		_layerRank = layerRank
	else
		_layerRank = 10
	end
end

function init()
 	close()
	-- �������
	mLayer= CCLayer:create()
	
	if layerRank == nil then
		_layerRank = 10
	end
	mScene:addChild(mLayer, _layerRank)
	
	showTask()
end

function nextStep()
	mTaskStep = mTaskStep+1
	showTask()
end

function showTask()
	if _GuideId == 1001 then
		showTask1001()
	elseif _GuideId == 1002 then
		showTask1002()
	elseif _GuideId == 1003 then
		showTask1003()
	elseif _GuideId == 1004 then
		showTask1004()
	elseif _GuideId == 1005 then
		showTask1005()
	elseif _GuideId == 1006 then
		showTask1006()
	elseif _GuideId == 1007 then
		showTask1007()
	elseif _GuideId == 1008 then
		showTask1008()
	elseif _GuideId == 1009 then
		showTask1009()
	elseif _GuideId == 1010 then
		showTask1010()
	elseif _GuideId == 1011 then
		showTask1011()	
	elseif _GuideId == 1012 then
		showTask1012()	
	elseif _GuideId == 1013 then
		showTask1013()				
	end

end


function nextCallBack()
	close()
	if _GuideId == 1001 then
		_1001CallBack()
	elseif _GuideId == 1002 then	
		_1002CallBack()
	elseif _GuideId == 1003 then	
		_1003CallBack()
	elseif _GuideId == 1004 then	
		_1004CallBack()
	elseif _GuideId == 1005 then	
		_1005CallBack()
	elseif _GuideId == 1006 then	
		_1006CallBack()
	elseif _GuideId == 1007 then	
		_1007CallBack()
	elseif _GuideId == 1008 then	
		_1008CallBack()
	elseif _GuideId == 1009 then	
		_1009CallBack()
	elseif _GuideId == 1010 then	
		_1010CallBack()
	elseif _GuideId == 1011 then	
		_1011CallBack()
	elseif _GuideId == 1012 then	
		_1012CallBack()	
	elseif _GuideId == 1013 then	
		_1013CallBack()	
	end
end;


--------------------------
--�жϵ������ĸ����Ƿ��������ĸ���
function judgeIsEnterRight(index)
	local isTrue = nil
	if _GuideId == 1001 and mTaskStep == 2 and index == 1 then
		isTrue = true
	elseif _GuideId == 1004 and mTaskStep == 2 and index == 2 then
		isTrue= true
	elseif _GuideId == 1005 and mTaskStep == 2 and index == 3 then
		isTrue= true
	elseif _GuideId == 1008 and mTaskStep == 2 and index == 4 then
		isTrue= true
	elseif _GuideId == 1009 and mTaskStep == 2 and index == 5 then
		isTrue= true
	elseif _GuideId == 1011 and mTaskStep == 2 and index == 6 then
		isTrue= true
	end
	if isTrue then
		mTaskStep = mTaskStep+1
	end
end


--�������Ǹ�����
function guidePlotIndex()
	local isTrue, index = nil
	if _GuideId == 1001 and mTaskStep == 3 then
		isTrue = true
		index = 1
	elseif _GuideId == 1004 and mTaskStep == 2 then
		isTrue = true
		index = 2
	elseif _GuideId == 1005 and mTaskStep == 2  then
		isTrue= true
		index = 3
	elseif _GuideId == 1008 and mTaskStep == 2 then
		isTrue= true
		index = 4 
	elseif _GuideId == 1009 and mTaskStep == 2 then
		isTrue= true
		index = 5
	elseif _GuideId == 1011 and mTaskStep == 2 then
		isTrue= true
		index = 6 
	end	
	return isTrue,index
end

----------------------------
--1001 ��һ�θ���ս��	������������븱��ָ�����棬��ս��һ������
function showTask1001()
	if mTaskStep == 1 then
		askIsJump()
	elseif mTaskStep == 2 then
		local btnTable = MainMenuLayer.getBtnTable()
		local item = btnTable.menu[3]
		
		local button=ZyButton:new("mainUI/list_1029_1.png", "mainUI/list_1029_2.png")
		createArowGuide(mLayer, item, button)
		createGuideNpc(mLayer,1001,3)
	elseif mTaskStep == 3 then
		local btnTable = PlotListScene.getButtonTable()
		local item = btnTable[1]
		local button = ZyButton:new("button/list_1039.png",nil, nil, Language.PLOT_GOTO, FONT_NAME, FONT_SM_SIZE)
		local posY = pWinSize.height*0.2
		item:setVisible(false)
		
		createArowGuide(mLayer, item, button)
		createGuideNpc(mLayer, 1001, 4, nil, nil, posY)
	elseif mTaskStep == 4 then
--		createGuideNpc(mLayer,1001,5)	
--		creatTouchLayer(1)
		mTaskStep = 0	
		oneTaskOver()
	end
end

function _1001CallBack()
	if mTaskStep == 1 then
		
	elseif mTaskStep == 2 then
		mTaskStep = 3
		MainMenuLayer.funcAction(nil, 51)
	elseif mTaskStep == 3 then
		mTaskStep = 4	
		PlotListScene.enterPlotAction(nil, 1)
	elseif mTaskStep == 4 then
		mTaskStep = 0	
		oneTaskOver()
	end

end

--ѯ���Ƿ�������������
function askIsJump()
	local box = ZyMessageBoxEx:new()
	box:isGrilShow(true)
	local strMessage = GuideConfigInfo.getConfigInfo(1001, 1)
	box:doQuery(mLayer, "", strMessage, Language.GUIDE_NEXT, Language.GUIDE_JUMP, askIsJumpCallback)	
end


function askIsJumpCallback(index, content, tag)
	if index == 1 then
		nextStep()
	elseif index == 2 then
		local box = ZyMessageBoxEx:new()
		local strMessage = GuideConfigInfo.getConfigInfo(1001, 2)		
		box:doQuery(mLayer, "", strMessage, Language.TIP_YES, Language.TIP_NO, isJumpCallback)
	end
end

--ȷ���Ƿ�������������
function isJumpCallback(index, content, tag)
	if index == 1 then
		sendAction(10931)
	elseif index == 2 then
		askIsJump()
	end
end


---------------------
--1002 ��������	��ļ���һ��Ӷ����ָ����������ͽ��棬��ѡ��Ӷ������
function showTask1002()
	if mTaskStep == 1 then--����̵�
		local btnTable = MainMenuLayer.getBtnTable()
		local item = btnTable.menu[5]
		local button=ZyButton:new("mainUI/list_1030_1.png", "mainUI/list_1030_2.png")
		
		createArowGuide(mLayer, item, button)
		createGuideNpc(mLayer,1002,1)
	elseif mTaskStep == 2 then--�����ļ
		local btnTable = HotalLayer.getBtnTable()
		local item = btnTable[3]
		local button = ZyButton:new("button/list_1039.png", nil, nil, Language.PUB_RECRIUIT, FONT_NAME, FONT_SM_SIZE)
		
		createArowGuide(mLayer, item, button)
	elseif mTaskStep == 3 then--�����ر�
		local btnTable = HotalLayer.getBtnTable()
		local item = btnTable[5]
		local button = ZyButton:new("button/list_1039.png", nil, nil, Language.IDS_GOON, FONT_NAME, FONT_SM_SIZE)
		
		createArowGuide(mLayer, item, button)	
	elseif mTaskStep == 4 then
		mTaskStep = 0
		oneTaskOver()	
	end
end

function _1002CallBack()
	if mTaskStep == 1 then
		mTaskStep = 2
		MainMenuLayer.funcAction(nil, 37)
		
	elseif mTaskStep == 2 then
		mTaskStep = 3
		HotalLayer.key_recruitBtn(nil, 3)	
	elseif mTaskStep == 3 then
		mTaskStep = 4
		HotalLayer.closeNewHero()	
	elseif mTaskStep == 4 then
		mTaskStep = 0
		oneTaskOver()
	end

end

---------------------------
--1003 ��������	��ļ���һ��Ӷ����ָ����������ͽ��棬��ѡ��Ӷ������
function showTask1003()
		
	if mTaskStep == 1 then--�����
		local btnTable = MainMenuLayer.getBtnTable()
		local item = btnTable.menu[4]
		local button=ZyButton:new("mainUI/list_1028_1.png", "mainUI/list_1028_2.png")
	
		createArowGuide(mLayer, item, button)
		

		createGuideNpc(mLayer,1003,1)
	elseif mTaskStep == 2 then--���Ӷ��
--		local btnTable = EmbattleScene.getBtnTable()
--		local item = nil
--		for k,v in pairs(btnTable.memberTable) do
--			item = v
--		end
--		
--		
--		local isCocosTouch = true
--		createArowGuide(mLayer, item, button)
--		local posY = pWinSize.height*0.14
--		createGuideNpc(mLayer,1003,2, nil, nil, posY)
	elseif mTaskStep == 3 then--�����
		local btnTable = EmbattleScene.getBtnTable()
		local item = nil
		for k,v in pairs(btnTable.openArrayTable) do
			if v.IsStations==0 then
				item = v.sprite
			end
		end
		if item then
			createArowGuide(mLayer, item)
		else
			nextStep()
		end		
	
	elseif mTaskStep == 4 then--�������
		local btnTable = EmbattleScene.getBtnTable()
		local item = btnTable.saveBtn
		local button=ZyButton:new(Image.image_button_red_c_0, Image.image_button_red_c_1, Image.image_button_hui_c, Language.EMBATTLE_STAR_ZHENFA, FONT_NAME, FONT_SM_SIZE)
		button:setColor(ccYELLOW)		
		
		
		createArowGuide(mLayer, item,button)
		createGuideNpc(mLayer,1003,3)		
	end
end

function _1003CallBack()
	if mTaskStep == 1 then
		mTaskStep = 2
		MainMenuLayer.funcAction(nil, 2)
		
	elseif mTaskStep == 2 then
		mTaskStep = 3
		init()
	elseif mTaskStep == 3 then
		mTaskStep = 4
		init()
	elseif mTaskStep == 4 then
		mTaskStep = 0
		EmbattleScene.saveArrayAction()
		oneTaskOver()

	end

end

---------------------------
--1004	ͨ������2	ָ������븱�����棬����ڶ�������	1003	NULL	1	2
function showTask1004()	
	if mTaskStep == 1 then	
		local btnTable = MainMenuLayer.getBtnTable()
		local item = btnTable.menu[3]
		local button=ZyButton:new("mainUI/list_1029_1.png", "mainUI/list_1029_2.png")
		createArowGuide(mLayer, item, button)
		createGuideNpc(mLayer,1004,1)	
	elseif mTaskStep == 2 then
		local btnTable = PlotListScene.getButtonTable()
		local item = btnTable[2]
		local button = ZyButton:new("button/list_1039.png",nil, nil, Language.PLOT_GOTO, FONT_NAME, FONT_SM_SIZE)
		item:setVisible(false)
		
		createArowGuide(mLayer, item, button)
	elseif mTaskStep == 3 then		
		mTaskStep = 0
		oneTaskOver()
	end
end

function _1004CallBack()
	if mTaskStep == 1 then	
		mTaskStep = 2	
		MainMenuLayer.funcAction(nil, 51)	
	elseif mTaskStep == 2 then
		mTaskStep = 3	
		PlotListScene.enterPlotAction(nil, 2)
	elseif mTaskStep == 3 then
		mTaskStep = 0	
		oneTaskOver()	
	end
end
------------------------------------
--1005	ͨ������3	ָ��������ɽ3������һ�������������һ���ض�����������ְҵ�ͣ�
function showTask1005()
	if mTaskStep == 1 then	
		local item = BattleResult.getBtn()
		local button = ZyButton:new("button/list_1023.png",nil,nil,Language.IDS_COLSE)
		item:setVisible(false)
		
		createArowGuide(mLayer, item, button)
		createGuideNpc(mLayer,1005,1)
	elseif mTaskStep == 2 then
		local btnTable = PlotListScene.getButtonTable()
		local item = btnTable[3]
		local button = ZyButton:new("button/list_1039.png",nil, nil, Language.PLOT_GOTO, FONT_NAME, FONT_SM_SIZE)
		item:setVisible(false)
		
		createArowGuide(mLayer, item, button)
	elseif mTaskStep == 3 then	
		mTaskStep = 0
		oneTaskOver()
	end
end

function _1005CallBack()
	if mTaskStep == 1 then	
		mTaskStep = 2	
		BattleResult.popScene()
	elseif mTaskStep == 2 then
		mTaskStep = 3
		PlotListScene.enterPlotAction(nil, 3)
	elseif mTaskStep == 3 then
		mTaskStep = 0	
		oneTaskOver()
	end
end
------------------------------------
--1006	װ������	ָ������Ӷ���������һ��Ӷ��װ��������
function showTask1006()	
	if mTaskStep == 1 then--������������
		if _currentWin == 1 then
			nextStep()
			return
		end			
		local btnTable = MainMenuLayer.getBtnTable()
		local item = btnTable.menu[1]
		local button=ZyButton:new("mainUI/list_1027_1.png", "mainUI/list_1027_2.png")		
		
		
		createArowGuide(mLayer, item, button)	
	elseif mTaskStep == 2 then--���Ӷ��
		local btnTable = MainMenuLayer.getBtnTable()
		local item =nil
		if btnTable.guideHero then
			item = btnTable.guideHero
		else
			item = btnTable.hero[1]		
		end
		local tag = item:getTag()


		local heroDetail = MainMenuLayer.heroInfo.RecordTabel[tag]
		local qualityType = heroDetail.GeneralQuality
		local picBg = getQualityBg(qualityType, 1)
		local image = string.format("smallitem/%s.png", heroDetail.HeadID)
		local button=ZyButton:new(picBg,picBg)		
		
		local imageLabel = CCSprite:create(P(image))
		imageLabel:setAnchorPoint(CCPoint(0.5, 0.5))
		imageLabel:setPosition(PT(button:getContentSize().width*0.5,button:getContentSize().height*0.5))
		button:addChild(imageLabel,0)		


		createArowGuide(mLayer, item, button)
	elseif mTaskStep == 3 then--���װ����
		local m_current_Info = HeroScene.getCurrentHeroInfo()
		if m_current_Info.Equipt[2] then
			mTaskStep = 0	
			oneTaskOver()				
		else
			local btnTable = HeroScene.getBtnTable()
			local item = btnTable.box[2]
			
			
			local picBg = Image.image_touxiang_beijing	
			local button=ZyButton:new(picBg,picBg)		
			local equipTable = {"list_1192", "list_1191", "list_1190", "list_1199", "list_1193",}
			local image = string.format("common/%s.png", equipTable[HeroScene.m_current_Info.CareerID])
			local imageLabel = CCSprite:create(P(image))
			imageLabel:setAnchorPoint(CCPoint(0.5, 0.5))
			imageLabel:setPosition(PT(button:getContentSize().width*0.5,button:getContentSize().height*0.5))
			button:addChild(imageLabel,0)	
		
			local posY = pWinSize.height*0.2
			createArowGuide(mLayer, item, button)
			
			createGuideNpc(mLayer,1006,1, nil, nil, posY)
		end
	elseif mTaskStep == 4 then--ѡ��װ��
		local btnTable = ItemListLayer.getBtnTable()
		if btnTable and btnTable.buttonTable and btnTable.buttonTable[1] then
			local item = btnTable.buttonTable[1]
			local button = ZyButton:new(Image.image_button_hook_0, Image.image_button_hook_1, nil)

			createArowGuide(mLayer, item, button)	
		end
	elseif mTaskStep == 5 then--���ȷ��
		local btnTable = ItemListLayer.getBtnTable()
		local item = btnTable.sureBtn
		local button = ZyButton:new(Image.image_button, nil, nil, Language.IDS_SURE, FONT_NAME, FONT_SM_SIZE)		
		
		createArowGuide(mLayer, item, button)		
	elseif mTaskStep == 6 then--1006���
		mTaskStep = 0	
		oneTaskOver()			
	end
end

function _1006CallBack()
	if mTaskStep == 1 then	
		mTaskStep = 2	
		MainMenuLayer.funcAction(nil, 52)		
	elseif mTaskStep == 2 then
		mTaskStep = 3
		local btnTable = MainMenuLayer.getBtnTable()
		local item =nil
		local index = nil
		if btnTable.guideHero then
			item = btnTable.guideHero
		else
			index = 1
		end		
		MainMenuLayer.key_hero(item, index)
	elseif mTaskStep == 3 then
		mTaskStep = 4	
		HeroScene.choiceAction(pNode, 2)
	elseif mTaskStep == 4 then
		mTaskStep = 5
		ItemListLayer.key_choicebtn(nil,1)
		init()
	elseif mTaskStep == 5 then
		mTaskStep = 6		
		ItemListLayer.key_sure()
	elseif mTaskStep == 6 then
		mTaskStep = 0	
		oneTaskOver()		
	end
end
------------------------------------
--1007	ǿ������	         װ���������󣬿���ǿ�����ܣ���ָ�������ǿ������ǿ��������	
function showTask1007()	
	if mTaskStep == 1 then--���װ��	
		local btnTable = HeroScene.getBtnTable()
		local item = btnTable.box[2]
		
		
			local equiptInfo = HeroScene.m_current_Info.Equipt[2]
			local picBg = getQualityBg(equiptInfo.QualityType,1)
			local button=ZyButton:new(picBg,picBg)		
			
			local image = string.format("smallitem/%s.png", equiptInfo.HeadPic)
			local imageLabel = CCSprite:create(P(image))
			imageLabel:setAnchorPoint(CCPoint(0.5, 0.5))
			imageLabel:setPosition(PT(button:getContentSize().width*0.5,button:getContentSize().height*0.5))
			button:addChild(imageLabel,0)
			
			local posY = pWinSize.height*0.2
			
		createArowGuide(mLayer, item, button)
		createGuideNpc(mLayer,1007,1, nil, nil, posY)				
	elseif mTaskStep == 2 then--ѡ��ǿ����ť
		local btnTable = HeroAccessory.getBtnTable()
		local item = btnTable.strenBtn
		

		local button=ZyButton:new("button/list_1023.png",nil,nil,Language.ROLE_EQUIPSTRONG )
	
		createArowGuide(mLayer, item, button)	
	elseif mTaskStep == 3 then--���ǿ����ť
		local btnTable = HeroAccessory.getBtnTable()
		local item = btnTable.strenBtn
		local button=ZyButton:new("button/list_1039.png",nil,nil,Language.EQUIP_STREN)		
		
		createArowGuide(mLayer, item, button)
	elseif mTaskStep ==4 then
		mTaskStep = 0	
		oneTaskOver()			
	end
end

function _1007CallBack()
	if mTaskStep == 1 then	
		mTaskStep = 2	
		HeroScene.choiceAction(pNode, 2)
	elseif mTaskStep == 2 then
		mTaskStep = 3
		HeroAccessory.equipLvUp()
	elseif mTaskStep == 3 then
		mTaskStep = 4	
		HeroAccessory.strenWeaponAction()
	elseif mTaskStep ==4 then
		mTaskStep = 0	
		oneTaskOver()			
	end
end

------------------------------------
--1008	ͨ������4	������������븱��ָ�����棬��ս���ĸ�����	
function showTask1008()	
	if mTaskStep == 1 then--����������
		local btnTable = MainMenuLayer.getBtnTable()
		local item = btnTable.menu[3]
		local button=ZyButton:new("mainUI/list_1029_1.png", "mainUI/list_1029_2.png")

		createArowGuide(mLayer, item, button)
		createGuideNpc(mLayer,1008,1)	
	elseif mTaskStep == 2 then--ѡ���4������
		local btnTable = PlotListScene.getButtonTable()
		local item = btnTable[4]
		local button = ZyButton:new("button/list_1039.png",nil, nil, Language.PLOT_GOTO, FONT_NAME, FONT_SM_SIZE)		
		item:setVisible(false)
		
		createArowGuide(mLayer, item, button)
	elseif mTaskStep == 3 then
		mTaskStep = 0	
		oneTaskOver()		
	end
end

function _1008CallBack()
	if mTaskStep == 1 then	
		mTaskStep = 2	
		MainMenuLayer.funcAction(nil, 51)		
	elseif mTaskStep == 2 then
		mTaskStep = 3	
		PlotListScene.enterPlotAction(nil, 4)
	elseif mTaskStep == 3 then
		mTaskStep = 0	
		oneTaskOver()		
	end
end
------------------------------------
--1009	ͨ������5	������������븱��ָ�����棬��ս���������
function showTask1009()	
	if mTaskStep == 1 then	--����������
		local item = BattleResult.getBtn()
		local button = ZyButton:new("button/list_1023.png",nil,nil,Language.IDS_COLSE)		
		
		createArowGuide(mLayer, item, button)	
	elseif mTaskStep == 2 then--ѡ���5������
		local btnTable = PlotListScene.getButtonTable()
		local item = btnTable[5]
		local button = ZyButton:new("button/list_1039.png",nil, nil, Language.PLOT_GOTO, FONT_NAME, FONT_SM_SIZE)			
		item:setVisible(false)

		createArowGuide(mLayer, item, button)
	elseif mTaskStep == 3 then
		mTaskStep = 0	
		oneTaskOver()		
	end
end

function _1009CallBack()
	if mTaskStep == 1 then	
		mTaskStep = 2	
		BattleResult.popScene()	
	elseif mTaskStep == 2 then
		mTaskStep = 3	
		PlotListScene.enterPlotAction(nil, 5)
	elseif mTaskStep == 3 then
		mTaskStep = 0	
		oneTaskOver()		
	end
end
------------------------------------
--1010	Ӷ������	ָ����Ե�һ��Ӷ����������
function showTask1010()	
	if mTaskStep == 1 then	--������������
		if _currentWin == 1 then
			nextStep()
			return
		end			
		local btnTable = MainMenuLayer.getBtnTable()
		local item = btnTable.menu[1]
		local button=ZyButton:new("mainUI/list_1027_1.png", "mainUI/list_1027_2.png")			
		
		createArowGuide(mLayer, item, button)
		createGuideNpc(mLayer,1010,1)	
	elseif mTaskStep == 2 then--���������ť
		local btnTable = MainMenuLayer.getBtnTable()
		local item = btnTable.middle[6]
		local button = ZyButton:new("mainUI/list_1026_1.png","mainUI/list_1026_2.png")
		
		local imageLabel = CCSprite:create(P("title/list_1020.png"))
		imageLabel:setAnchorPoint(CCPoint(0.5, 0.5))
		imageLabel:setPosition(PT(button:getContentSize().width*0.5,button:getContentSize().height*0.5))
		button:addChild(imageLabel,0)		
		
		
		createArowGuide(mLayer, item, button)
	elseif mTaskStep == 3 then--���ѡ��Ӷ��
		local btnTable = HeroLvUp.getBtnTable()
		local item = btnTable.imageBg
		local button = ZyButton:new("common/list_1085.png","common/list_1085.png",nil)	
		
		local noticeLabel = CCLabelTTF:create(Language.ROLE_POINTCHOICE, FONT_NAME, FONT_SM_SIZE)
		noticeLabel:setAnchorPoint(PT(0.5, 0.5))
		noticeLabel:setPosition(PT(button:getContentSize().width*0.5, button:getContentSize().height*0.5))
		button:addChild(noticeLabel, 0)	



		createArowGuide(mLayer, item, button)		
	elseif mTaskStep == 4 then--ѡ��Ӷ��
		local btnTable = HeroLvUpChoiceLayer.getBtnTable()
		local item = btnTable.buttonTable[1]
		local button = ZyButton:new(Image.image_button_hook_0, Image.image_button_hook_1, nil)		
		
		createArowGuide(mLayer, item, button)			
	elseif mTaskStep == 5 then--���ȷ��
		local btnTable = HeroLvUpChoiceLayer.getBtnTable()
		local item = btnTable.sureBtn
		local button = ZyButton:new(Image.image_button, nil, nil, Language.IDS_SURE, FONT_NAME, FONT_SM_SIZE)		
		
		createArowGuide(mLayer, item, button)		
	elseif mTaskStep == 6 then--���ѡ���鿨
		local btnTable = HeroLvUp.getBtnTable()
		local item = btnTable.cardTable[1]
		local button = ZyButton:new(Image.image_touxiang_beijing, Image.image_touxiang_beijing, nil)	

		createArowGuide(mLayer, item, button)			
	elseif mTaskStep == 7 then--ѡ��Ӷ�����鿨
		local btnTable = HeroLvUpChoiceLayer.getBtnTable()
		local item = btnTable.buttonTable[1]
		local button = ZyButton:new(Image.image_button_hook_0, Image.image_button_hook_1, nil)			
		
		createArowGuide(mLayer, item, button)			
	elseif mTaskStep == 8 then--���ȷ��
		local btnTable = HeroLvUpChoiceLayer.getBtnTable()
		local item = btnTable.sureBtn
		local button = ZyButton:new(Image.image_button, nil, nil, Language.IDS_SURE, FONT_NAME, FONT_SM_SIZE)				
		
		createArowGuide(mLayer, item, button)		
	elseif mTaskStep == 9 then--���������ť
		local btnTable = HeroLvUp.getBtnTable()
		local item = btnTable.lvUpBtn
		local button = ZyButton:new(Image.image_button, nil, nil, Language.ROLE_LVUP, FONT_NAME, FONT_SM_SIZE)		
		
		createArowGuide(mLayer, item, button)		
	end
end

function _1010CallBack()
	if mTaskStep == 1 then	
		mTaskStep = 2	
		MainMenuLayer.funcAction(nil, 52)			
	elseif mTaskStep == 2 then--���������ť
		mTaskStep = 3	
		MainMenuLayer.funcAction(nil, 50)
	elseif mTaskStep == 3 then--���ѡ��Ӷ��
		mTaskStep = 4
		HeroLvUp.key_hero()
	elseif mTaskStep == 4 then--ѡ��Ӷ��
		mTaskStep = 5
		HeroLvUpChoiceLayer.key_choicebtn(nil,1)
		init()	
	elseif mTaskStep == 5 then--���ȷ��
		mTaskStep = 6		
		HeroLvUpChoiceLayer.key_sure()	
	elseif mTaskStep == 6 then--���ѡ���鿨
		mTaskStep = 7
		HeroLvUp.key_to_choiceCost()
	elseif mTaskStep == 7 then--ѡ��Ӷ�����鿨
		mTaskStep = 8
		HeroLvUpChoiceLayer.key_choicebtn(nil,1)
		init()		
	elseif mTaskStep == 8 then--���ȷ��
		mTaskStep = 9		
		HeroLvUpChoiceLayer.key_sure()		
	elseif mTaskStep == 9 then--���������ť
		HeroLvUp.LvUpAction()
		mTaskStep = 0	
		oneTaskOver()			
	end
end
------------------------------------
--1011	ͨ������6	������������븱��ָ�����棬��ս����������
function showTask1011()	
	if mTaskStep == 1 then	--�������
		local btnTable = MainMenuLayer.getBtnTable()
		local item = btnTable.menu[3]
		local button=ZyButton:new("mainUI/list_1029_1.png", "mainUI/list_1029_2.png")		
		item:setVisible(false)

		createArowGuide(mLayer, item, button)
		createGuideNpc(mLayer,1011,1)	
	elseif mTaskStep == 2 then--��ս����������
		local btnTable = PlotListScene.getButtonTable()
		local item = btnTable[6]
		local button = ZyButton:new("button/list_1039.png",nil, nil, Language.PLOT_GOTO, FONT_NAME, FONT_SM_SIZE)				
		item:setVisible(false)

		createArowGuide(mLayer, item, button)

	elseif mTaskStep == 3 then
		mTaskStep = 0	
		oneTaskOver()		
	end
end

function _1011CallBack()
	if mTaskStep == 1 then	
		mTaskStep = 2	
		MainMenuLayer.funcAction(nil, 51)			
	elseif mTaskStep == 2 then
		mTaskStep = 3	
		PlotListScene.enterPlotAction(nil, 6)
	elseif mTaskStep == 3 then
		mTaskStep = 0	
		oneTaskOver()			
	end
end
------------------------------------
--1012	�����������	�������
function showTask1012()	
	if mTaskStep == 1 then
		creatTouchLayer(nextCallBack)	
		createGuideNpc(mLayer,1012,1)	
	end
end

function _1012CallBack()
	if mTaskStep == 1 then	
		mTaskStep = 0	
		oneTaskOver()		
	end
end


--�����򿪱���
function showTask1013()
	if mTaskStep == 1 then		
		local btnTable = MainMenuLayer.getBtnTable()
		local item = btnTable.menu[2]
		local button=ZyButton:new("mainUI/list_1031_1.png", "mainUI/list_1031_2.png")
		
		createArowGuide(mLayer, item, button)
	--	createGuideNpc(mLayer,1001,1)	
	elseif mTaskStep == 2 then
		mTaskStep = 0	
		oneTaskOver()		
	end
end

function _1013CallBack()
	if mTaskStep == 1 then	
		mTaskStep = 2	
		MainMenuLayer.funcAction(nil, 27)
	elseif mTaskStep == 2 then
		mTaskStep = 0	
		oneTaskOver()		
	end		
end

------------------------------------

------------------------------------
--��ͷ
function createArowGuide(layer,item, button)

	creatTouchLayer()

	local boxSize = item:getContentSize()
	local position = item:getParent():convertToWorldSpace(item:getPosition())
	

	--��ͷ
	local crowSprite=CCSprite:createWithTexture(IMAGE("common/list_1170_1.png"))
	crowSprite:setAnchorPoint(PT(0.5,0))
	layer:addChild(crowSprite,0)
	
	--��ť
	if button then
		button:setAnchorPoint(PT(0,0))
		button:setPosition(PT(position.x+boxSize.width*0.5-button:getContentSize().width*0.5, position.y+boxSize.height*0.5-button:getContentSize().height*0.5))
		button:registerScriptHandler(nextCallBack)
		button:addto(layer, 0)	
	end

	--��Ȧ
	local lightBtn = CCSprite:create(P("common/list_1171.png"))
	lightBtn:setAnchorPoint(PT(0,0))
	lightBtn:setPosition(PT(position.x+boxSize.width*0.5-lightBtn:getContentSize().width*0.5, position.y+boxSize.height*0.5-lightBtn:getContentSize().height*0.5))
	layer:addChild(lightBtn, 0)		


	local posY=position.y+lightBtn:getContentSize().height*0.4
	local posX=position.x+boxSize.width/2
	local oldPos=PT(posX,posY+SY(5))
	local movePos=PT(posX,  posY)
	
	crowSprite:setPosition(oldPos)
	local action1 = CCMoveTo:create(0.5,movePos )
	local action2 = CCMoveTo:create(0.5, oldPos)
	local action3 = CCSequence:createWithTwoActions(action1, action2)
	crowSprite:runAction(CCRepeatForever:create(action3))
end;


---------npc��
function createGuideNpc(layer, taskId, step, ItemInfo, str, posY)

	local guideTaskStr = GuideConfigInfo.getConfigInfo(taskId, step)
	if str then
		guideTaskStr = str
	end
	if ItemInfo then
		local strs = ""
		for k,v in ipairs(ItemInfo) do
			strs = strs..v.ItemName.."x"..v.itemNum
			if k ~= #ItemInfo then
				strs = strs..Language.IDS_COMMA
			end
		end
		guideTaskStr = string.format(guideTaskStr, strs)
	end

	
	--������
	local bgSprite = CCSprite:create(P("common/list_4000_1.9.png"))
	bgSprite:setAnchorPoint(PT(0.5,0.5))
	bgSprite:setPosition(PT(pWinSize.width/2,posY or pWinSize.height/2))
	layer:addChild(bgSprite, 0)
	
	--Ů��ͼ
	local girlSprite=CCSprite:create(P("common/list_4000_2.png"))
	girlSprite:setAnchorPoint(PT(0,0))
	layer:addChild(girlSprite, 0)	
	
	--����
	local labelWidth=pWinSize.width*0.95-girlSprite:getContentSize().width
	local contentStr=string.format("<label>%s</label>",guideTaskStr)
	local contentLabel = ZyMultiLabel:new(contentStr,labelWidth,FONT_NAME,FONT_DEF_SIZE)
	contentLabel:addto(layer,0)
	--��������ͼ��С	
	local bgHeight=contentLabel:getContentSize().height+pWinSize.height*0.03>pWinSize.height*0.22
							and contentLabel:getContentSize().height+pWinSize.height*0.03 or pWinSize.height*0.22
	if ItemInfo then
		bgHeight = pWinSize.height*0.325
	end
							
							
	local size =SZ(pWinSize.width,bgHeight) 
	
	--����ͼ����
	bgSprite:setScaleX(pWinSize.width/bgSprite:getContentSize().width)
	bgSprite:setScaleY(size.height/bgSprite:getContentSize().height)
	
	--Ů��ͼ����λ��
	girlSprite:setPosition(PT(0, 
					bgSprite:getPosition().y-size.height/2+girlSprite:getContentSize().height*0.02))
	--��������λ��
	local startY=bgSprite:getPosition().y+size.height/2-pWinSize.height*0.02 
	contentLabel:setPosition(PT(girlSprite:getContentSize().width+pWinSize.width*0.03, 
					startY-contentLabel:getContentSize().height))
					
	if ItemInfo then
		for k,v in ipairs(ItemInfo) do
			local name = v.ItemName  
			local image = string.format("smallitem/%s.png",v.HeadID)
			local num = v.itemNum  
			local item = creatItem(image, name, num)	
			item:setAnchorPoint(PT(0,0))
			local pos_x = size.width*0.65-item:getContentSize().width*0.65*#ItemInfo+(k-1)*item:getContentSize().width*1.3
			local pos_y = size.height*0.15
			item:setPosition(PT(pos_x, pos_y))
			bgSprite:addChild(item, 0)	
		end
	end

	--������ʾ
	layer:setAnchorPoint(PT(0,0))
	layer:setPosition(PT(0,0))
end;


---------------------------

function closeTouchLayer()
	if touchLayer then
		touchLayer:getParent():removeChild(touchLayer, true)
		touchLayer = nil	
	end
end

function creatTouchLayer(func)
	if touchLayer then
		touchLayer:getParent():removeChild(touchLayer, true)
		touchLayer = nil	
	end

	local layer = CCLayer:create()
	layer:setAnchorPoint(PT(0,0))
	layer:setPosition(PT(0,0))
	mLayer:addChild(layer, 0)

	touchLayer = layer
	

	
	local button=ZyButton:new("common/transparentBg.png", "common/transparentBg.png")
	button:setScaleX(pWinSize.width/button:getContentSize().width)
	button:setScaleY(pWinSize.height/button:getContentSize().height)
	button:setAnchorPoint(PT(0,0))
	button:setPosition(PT(0,0))
	button:addto(layer, 0)
	

	if func then
		button:registerScriptHandler(func)
	end
	
end


function oneTaskOver()
	sendAction(1093)
end;

function getPrize()
	sendAction(1094)
end

--��������
function sendAction(actionId)
	if actionId == 1093 then
		actionLayer.Action1093(mScene, nil, _GuideId, 0)
	elseif actionId == 10931 then
		actionLayer.Action1093(mScene, nil, _GuideId, 1)
	elseif actionId == 1094 then
		actionLayer.Action1094(mScene, nil,_GuideId)
	end

end

-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionId = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	if actionId == 1093 then
		local serverInfo = actionLayer._1093Callback(pScutScene, lpExternalData)
		if serverInfo then
			setIsGuide(1,_GuideId,0)
			getPrize()
		end
	elseif actionId == 1094 then
		local serverInfo = actionLayer._1094Callback(pScutScene, lpExternalData)
		if serverInfo then
		--[[
			serverInfo.isPass=0
			serverInfo.GuideId=1002
			local  RecordTabel = {}
			RecordTabel.ItemName="adsfa"
			RecordTabel.HeadID="Icon_1000"
			RecordTabel.itemNum=10
			serverInfo.RecordTabel={}
			serverInfo.RecordTabel[1] = RecordTabel		

		--]]	 
			 
			

			if serverInfo.RecordTabel and #serverInfo.RecordTabel > 0 then
				creatTouchLayer(judgeIsHaveNext)
				createGuideNpc(mLayer, _GuideId, mTaskStep, serverInfo.RecordTabel)
				if MainMenuLayer.getIsGotoLv() then
					hide()
				end
				setIsGuide(serverInfo.isPass,  serverInfo.GuideId, 1)
			else
				setIsGuide(serverInfo.isPass,  serverInfo.GuideId, 1)
				judgeIsHaveNext()
			end
			
			
		end	
	end
end

--�ж��Ƿ�����һ������
function judgeIsHaveNext()
	close()
	if judgeIsGuide(_currentWin) then
		init()
		if MainMenuLayer.getIsGotoLv() then
			hide()
		end
	end
end



--�����Ʒͼ��
function creatItem(image, name, num)
	local menuItem = CCMenuItemImage:create(P(Image.image_touxiang_beijing), P(Image.image_touxiang_beijing))
	local btn = CCMenu:createWithItem(menuItem)
	
	menuItem:setAnchorPoint(PT(0,0))
	if menberCallBack then 
	    menuItem:registerScriptHandler(menberCallBack)
	end
	if tag then
		menuItem:setTag(tag)
	end
	btn:setContentSize(SZ(menuItem:getContentSize().width, menuItem:getContentSize().height))
	
	--Ӷ��ͷ��
	if image then
		local imageLabel = CCMenuItemImage:create(P(image),P(image))
		if imageLabel == nil then
			 return btn 
		end
		imageLabel:setAnchorPoint(CCPoint(0.5, 0.5))
		imageLabel:setPosition(PT(menuItem:getContentSize().width*0.5,menuItem:getContentSize().height*0.5))
		menuItem:addChild(imageLabel,0)
	end
--	if num then
--		local numLabel=CCLabelTTF:create("x"..num,FONT_NAME,FONT_FMM_SIZE)
--		numLabel:setAnchorPoint(PT(1,0))
--		numLabel:setPosition(PT(menuItem:getContentSize().width*0.95, menuItem:getContentSize().height*0.05))
--		menuItem:addChild(numLabel,0)
--	end
	if name then
		local nameLabel = CCLabelTTF:create(name.." x"..num, FONT_NAME, FONT_FMM_SIZE)
		nameLabel:setAnchorPoint(PT(0.5,0))
		nameLabel:setPosition(PT(menuItem:getContentSize().width*0.5, -nameLabel:getContentSize().height*1.4))
		menuItem:addChild(nameLabel, 0)	
	end
	
	return btn
end;


---�ӳٽ��з���
function delayExec(funName,nDuration,parent)
	local  action = CCSequence:createWithTwoActions(
	CCDelayTime:create(nDuration),
	CCCallFuncN:create(funName));
	local layer = priceLayer
	if parent then
		layer=parent
	end
	if layer then
		layer:runAction(action)
	end	
end
