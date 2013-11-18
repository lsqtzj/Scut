------------------------------------------------------------------
-- TodayToScene.lua.lua
-- Author     : yeyq

-- Version    : 1.0
-- Date       :
-- Description:    ÿ��̽�ս���
------------------------------------------------------------------

module("TodayToScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

local _scene = nil 		-- ����
button_Color = nil 
_strGood =nil 
rewardString2 = nil 
tMLayer = nil 
--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��

-- �������
function pushScene()
	initResource()
	init()
end


-- �˳�����
function close()
	if mLayer then
		mLayer:stopAllActions()
		mLayer:getParent():removeChild(mLayer,true)
		mLayer = nil
	end
	releaseResource()
end



--
-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()
	mLayer = nil 
	qID = nil      --����ID
	qContent = nil    ----- ��������
	aID1 = nil 			-------  ��һID
	aContent1 = nil  -------��һ
	aID2 = nil			---------�𰸶�ID
	aContent2 = nil 		 ---------�𰸶�
	AnswerId = nil
--	m_choice =  2  --------------
	choiceLayer = nil 
	nowCoolingImg = nil
	nowCooling = nil
	nowCoollingTo = nil
	OrTrue = 1
	timeLabel = {}
	timeLabel[1] = {}
	qLayer = nil
	spendLayer = nil 
	button_Color = nil 
	button_Red  = Image.image_TodayToScene_buttonRed
	button_Gray =Image.image_TodayToScene_buttonGray
	sNum = nil
	isEnd = nil 

end


-- �ͷ���Դ
function releaseResource()

	

	mLayer = nil 
	qID = nil      --����ID
	qContent = nil    ----- ��������
	aID1 = nil 			-------  ��һID
	aContent1 = nil  -------��һ
	aID2 = nil			---------�𰸶�ID
	aContent2 = nil 		 ---------�𰸶�
	AnswerId = nil
--	m_choice =  nil  --------------
	choiceLayer = nil 
	nowCoolingImg = nil
	nowCooling = nil
	nowCoollingTo = nil
	OrTrue = nil
	timeLabel = {}
	timeLabel[1] = {}
	qLayer = nil
	spendLayer = nil 
	isEnd = nil 
	stopRun()	
end
function setLayer(layer)
	tMLayer	 = layer
end
-- ��������
function init(fatherScene)

	initResource()

	_scene = fatherScene
	local layer = CCLayer:create()
	

	tMLayer:addChild(layer, 0)
	mLayer= layer
		
	-- �˴���ӳ�����ʼ����                  
	local bg1 = "activeBg/list_1082.jpg"
	local imageBg = CCSprite:create(P(bg1));
	imageBg:setScaleX(pWinSize.width*0.92/imageBg:getContentSize().width)
	imageBg:setScaleY(pWinSize.height*0.7/imageBg:getContentSize().height)
	imageBg:setAnchorPoint(PT(0,0))
	imageBg:setPosition(PT(pWinSize.width*0.04,pWinSize.height*0.2))
	mLayer:addChild(imageBg,0)
	actionLayer.Action11001(_scene,false)
 
end

function  releaseAllLayer()
		if  choiceLayer  then 
			choiceLayer:getParent():removeChild(choiceLayer,true)
			choiceLayer = nil 	
		end
		
		
		if  spendLayer then 
				spendLayer:getParent():removeChild(spendLayer,true)
				spendLayer = nil
		end
		
		if qLayer  then 
			qLayer:getParent():removeChild(qLayer,true)
			qLayer =nil 
		end		
end;

function showLayer()
	releaseAllLayer()
	qLayer = CCLayer:create()
	mLayer:addChild(qLayer,0)
	
	local fontSize = FONT_SM_SIZE
	if  isEnd==1   then 
		local gapStr = Language.TODAY_Str
		local gapString= CCLabelTTF:create(gapStr,FONT_NAME,fontSize)
		qLayer:addChild(gapString,3)
		gapString:setAnchorPoint(PT(0.5,0.5))
		gapString:setPosition(PT(pWinSize.width*0.5,pWinSize.height*0.5))
	end
		
	if qContent ~=nil and qContent~=" " 	then 
		---����
		local showWidth = pWinSize.width*0.84
		local sQuestion = Language.PriceValue
		local HONG_color = "255,250,250"
		local FuQuestion=	string.format(sQuestion,HONG_color,qContent)	
		local goodslabel = ZyMultiLabel:new(FuQuestion,showWidth,FONT_NAME,fontSize,nil,nil)
		goodslabel:setAnchorPoint(PT(0,1))
		goodslabel:setPosition(PT((pWinSize.width-showWidth)/4+pWinSize.width*0.05, pWinSize.height*0.8-goodslabel:getContentSize().height))
		goodslabel:addto(qLayer,0)

		---��		
		local button1 = ZyButton:new(button_Red,button_Red,button_Gray,aContent1,FONT_NAME,fontSize);
		button1:addto(qLayer,0)
		button1:setTag(aID1)																		
		button1:setAnchorPoint(PT(0,0))
		button1:setPosition(PT(pWinSize.width*0.5-button1:getContentSize().width*0.5,pWinSize.height*0.4))
		button1:registerScriptHandler(onclick)
		if   numberTime  >  0 then 
			button1:setIsEnabled(false)
		end		

	
		local button5 = ZyButton:new(button_Red, button_Red,button_Gray,aContent2,FONT_NAME,fontSize);
		button5:addto(qLayer,0)
		button5:setTag(aID2)  																			
		button5:setAnchorPoint(PT(0,0))
		button5:setPosition(PT(pWinSize.width*0.5-button5:getContentSize().width*0.5,pWinSize.height*0.5))
		button5:registerScriptHandler(onclick)
		if  numberTime > 0 then 
			button5:setEnabled(false) ---�Ƿ���
		end	
		
		
		if  numberTime <= 0 then 
			----�Ƿ񻨷Ѿ�ʯ
			local nowButton= ZyButton:new(Image.image_button_hook_0, Image.image_button_hook_1,nil,nil,FONT_NAME,fontSize)
			nowButton:addto(qLayer,0)
			nowButton:setAnchorPoint(PT(0,0.5))
			nowButton:setPosition(PT((pWinSize.width*0.5-nowButton:getContentSize().width)/2,
			pWinSize.height*0.3))
			--nowButton:registerScriptHandler(nowCooling1)
			
			mChoiceBtn = 	nowButton
			if m_choice == 1 then
				nowButton:selected()
			end	
			--���Ѿ�ʯ
			local WString = string.format(Language.spendMoney,sNum)
			local numberAge2= CCLabelTTF:create(WString,FONT_NAME,fontSize)
			numberAge2:setColor(ccc3(250,250,250))
			numberAge2:setAnchorPoint(PT(0,0.5))
			numberAge2:setPosition(PT(pWinSize.width*0.3,pWinSize.height*0.3))
			qLayer:addChild(numberAge2,3)
			
			local boxSize=SZ(nowButton:getContentSize().width+numberAge2:getContentSize().width,
								nowButton:getContentSize().height	)
								
			local actionBtn=UIHelper. createActionRect(boxSize,nowCooling1)
			actionBtn:setPosition(PT(nowButton:getPosition().x,
							nowButton:getPosition().y-nowButton:getContentSize().height/2))
			qLayer:addChild(actionBtn,3)
							
			
		elseif numberTime > 0 then 
			local button_Cooling = "button/list_1081.png"
			local coolButton = ZyButton:new(button_Cooling,nil,nil,nil,FONT_NAME,fontSize)
			coolButton:addto(qLayer,3)
			coolButton:setAnchorPoint(PT(0,0.5))
			coolButton:setPosition(PT((pWinSize.width*0.5-coolButton:getContentSize().width)/2,pWinSize.height*0.3))
			coolButton:registerScriptHandler(coolOnclick)	
			
			local wenzi2 = Language.spendTime
			local numberAge3 = CCLabelTTF:create(wenzi2,FONT_NAME,fontSize)
			numberAge3:setColor(ccc3(250,250,250))
			numberAge3:setAnchorPoint(PT(0,0.5))
			numberAge3:setPosition(PT(pWinSize.width*0.3,pWinSize.height*0.3))
			qLayer:addChild(numberAge3,3)
			
			local NToNumber =formatTime(numberTime)
			local numberAge1= CCLabelTTF:create(NToNumber,FONT_NAME,fontSize)
			numberAge1:setColor(ccc3(250,250,250))
			qLayer:addChild(numberAge1,3)
			numberAge1:setAnchorPoint(PT(0,0.5))
			numberAge1:setPosition(PT(pWinSize.width*0.32+numberAge3:getContentSize().width,pWinSize.height*0.3))
			
			
			timeLabel = 	numberAge1
			--CCScheduler:sharedScheduler():scheduleScriptFunc("TodayToScene.closeTime", 1, false)
			 schedulerEntry1 = 	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(timeElapse, 1, false)
			--]]
		end

	end
	
end


--�𰸵�����״̬
function  onclick(item)
	local answerId = item:getTag()
	m_choice = nil
	if mChoiceBtn and mChoiceBtn._isSelected then
		m_choice = 1
	else
		m_choice = 2
	end
	actionLayer.Action11002(_scene,nil,qID,answerId,m_choice)--1���� 2����
end

function delayExec(funName,nDuration)
	local  action = CCSequence:createWithTwoActions(
	CCDelayTime:create(nDuration),
	CCCallFunc:create(funName));
	if mLayer ~= nil then
		mLayer:runAction(action)
	end
end


function stopRun()
	----ֹͣ�ķ���
--	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(schedulerEntry1)
--	CCScheduler:sharedScheduler():unscheduleScriptFunc("TodayToScene.closeTime")	
end;


function coolOnclick()
	actionLayer.Action11003(_scene,nil,1)
end

function refreshButton(clickedButtonIndex, content, tag)
	if   clickedButtonIndex ==1 then 
		actionLayer.Action11003(_scene,nil,2)	
	end
end

----�Ƿ�ʹ�þ�ʯ��������ȴʱ��
function nowCooling1()
	if mChoiceBtn._isSelected then--1���� 2����
		mChoiceBtn:unselected()	
	else
		mChoiceBtn:selected()
	end
end
 -------------------------ʱ������
function closeTime() 
	if isStop == true then
		return
	end
	if numberTime >  0 then
		numberTime = numberTime -1
		NToNumber= formatTime(numberTime)
		timeLabel:setString(NToNumber)
	elseif  numberTime <= 0  then
		delayExec("TodayToScene.stopRun",0.1)
		isStop = true			
		if isEnd  == 1 then 
			showLayer()
		else  
			actionLayer.Action11001(_scene,nil)
		end 
	end
end




function toOnClick()

	actionLayer.Action11001(_scene,nil)
		
end




function closeAction()
	releaseResource()
	MainScene.init()
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


function  mysteriaAction()
	ZyToast.show(_scene,rewardString2,1.5, 0.35)
					
	actionLayer.Action11001(_scene,nil)
end
-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionID = ZyReader:getActionID()
	if actionID == 11001 then 
		local serverInfo=actionLayer._11001Callback(pScutScene, lpExternalData)
		if serverInfo~=nil and serverInfo ~= " " then
			goodsTable = serverInfo
			
			qID = goodsTable.QuestionID      --����ID
			qContent = goodsTable.QuestionContent    ----- ��������
			aID1 = goodsTable.AnswerID1 			-------  ��һID
			aContent1 = goodsTable.AnserContent1  -------��һ
			aID2 = goodsTable.AnswerID2			---------�𰸶�ID
			aContent2 = goodsTable.AnserContent2 		 ---------�𰸶�
			numberTime = goodsTable.CodeTime 				-------��ȴʱ��
			sNum = goodsTable.UseGold 	 -----�����ѵľ�ʯ
			isEnd = goodsTable. IsEnd
			
			showLayer()

			isStop = false
					
		end
	end 
	if actionID == 11002 then
	

		if ZyReader:getResult() == eScutNetSuccess or ZyReader:getResult() == 1 then
		
			local DataTabel={}
			DataTabel.CodeTime= ZyReader:getInt()
			local RecordNums_1=ZyReader:getInt()
			local RecordTabel_1={}
			if RecordNums_1~=0 then
				for k=1,RecordNums_1 do
					local mRecordTabel_1={}
					ZyReader:recordBegin()
					mRecordTabel_1.RewardType= ZyReader:getWORD()
					mRecordTabel_1.RewardNum= ZyReader:getInt()
					ZyReader:recordEnd()
					ZyTable.push_back(RecordTabel_1,mRecordTabel_1)
				end
			end
			DataTabel.RecordTabel = RecordTabel_1;
        
			local serverInfo1 = DataTabel
			local rewardStr = Language.TODAY_Str1  ----- %sX %s
			local rewType = nil 
			local rewardString = "" 
			local typeString = Language.toLabel
			
			if serverInfo1 ~= nil  and serverInfo1 ~= " " then 
				local question2_table = serverInfo1.RecordTabel
				for i=1,#question2_table  do
					rewardType =  question2_table[i].RewardType	
					rewardNum  =  question2_table[i].RewardNum 	
					rewType = typeString[rewardType]
					
					rewardString =rewardString..string.format(rewardStr,rewType,rewardNum)
				end
				 rewardString2 = Language.TODAY_Str2..":".. rewardString 
			end		
		
		
		
			if ZyReader:getResult() == eScutNetSuccess then
				actionLayer.Action11001(_scene,nil)					
				ZyToast.show(pScutScene,rewardString2,1.5,0.35)
			elseif ZyReader:getResult() == 1 then--���������¼� 
				delayExec("TodayToScene.stopRun",0.1)
				_strGood = ZyReader:readErrorMsg() 
				
				local box = ZyMessageBoxEx:new()
				box:doPrompt(pScutScene, nil, _strGood,Language.IDS_OK, mysteriaAction)

--				local box = ZyMessageBoxEx:new()
--				box:doQuery(pScutScene, nil,rewardString2,Language.okString,Language.noString,czAction)
			end
		else
			ZyToast.show(pScutScene,ZyReader:readErrorMsg(),1.5,0.35)
		end	
		
	end
	if actionID == 11003 then
	    if ZyReader:getResult() == 1  then
			local box = ZyMessageBoxEx:new()
			box:doQuery(pScutScene, nil, ZyReader:readErrorMsg() , Language.doString_OK, Language.IDS_BACK,refreshButton) 
	    elseif     ZyReader:getResult() == 0 then
	    		 delayExec("TodayToScene.stopRun",0.1)
	    		actionLayer.Action11001(_scene,nil)	
	    else
		       ZyToast.show(pScutScene,ZyReader:readErrorMsg(),1.5,0.35)
		      
	    end
	end   
end