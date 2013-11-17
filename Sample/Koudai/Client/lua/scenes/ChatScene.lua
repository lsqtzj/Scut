------------------------------------------------------------------
-- ChatScene.lua
-- Author     :JUNM Chen
-- Version    : 1.0
-- Date       :
-- Description: ,����ϵͳ
------------------------------------------------------------------
module("ChatScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд
local mScene = nil 		-- ����
local mLayer=nil
local mChatLayer=nil
local mList=nil
local personalInfo=nil
--���ڴ��� listItem ����Ϣ��
local  _chatMessage={}
--���ڼ�ס����
local  _allMessage={}
local maxNum=30
local mCurrentTab=1
local mInputEdit=nil
local ChatItemNum=0
local mChatItemLabel=nil
--
---------------���нӿ�(�������������̶����øı�)--------
--
-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��

-- �˳�����
function closeScene()
	releaseResource()
	MainScene.init()
end

--�����
function  clearLocalMessage()
	_allMessage={}
	_chatMessage={}	
end;

-- �������
function init(scene)
	if mScene then
		return
	end
	initResource()
	local scene  = ScutScene:new()
	mScene = scene.root
		mScene:registerScriptHandler(SpriteEase_onEnterOrExit)
	-- ע������ص�
	scene:registerCallback(networkCallback)
	SlideInLReplaceScene(mScene,1)
	mLayer = CCLayer:create()
	mScene:addChild(mLayer, 0)
	-- ��ӱ���
	if not  mCurrentTab then
		mCurrentTab=1
	end	
	--
	local bgLayer=createContentLayer()
	bgLayer:setPosition(PT(0,0))
	mLayer:addChild(bgLayer,0)
	
	local closeBtn=ZyButton:new("button/list_1046.png")
	closeBtn:setAnchorPoint(PT(0,0))
	closeBtn:setPosition(PT(pWinSize.width-closeBtn:getContentSize().width*1.2,
							pWinSize.height-closeBtn:getContentSize().height*1.2))
	--closeBtn:addto(mLayer,0)
	closeBtn:registerScriptHandler(closeScene)
	
	
	MainMenuLayer.init(2, mScene)	
	
	showLayer()	
end

function SpriteEase_onEnterOrExit (tag)
    if tag == "exit" then
        releaseResource()
    end
end

---����������
function  createContentLayer()

	--
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
	local boxSize=SZ(pWinSize.width,pWinSize.height*0.855)
	midSprite:setAnchorPoint(PT(0.5,0))
	midSprite:setScaleX(boxSize.width/midSprite:getContentSize().width)
	midSprite:setScaleY(boxSize.height/midSprite:getContentSize().height)
	
	midSprite:setPosition(PT(pWinSize.width/2,pWinSize.height*0.145))
	layer:addChild(midSprite,0)
	
	return layer
end;

--����tabbar
function  createTabbar(tabStr,layer,posY)
	local tabBar=nil
	local midSprite=CCSprite:create(P("common/list_1024.png"))
	if tabStr then
	  	local titleSprite=CCSprite:create(P("common/list_1041.png"))
		titleSprite:setAnchorPoint(PT(0,0))
		tabBar=titleSprite
		local tabBar_X=pWinSize.width*0.04
		local tabBar_Y=pWinSize.height/2+midSprite:getContentSize().height/2-tabBar:getContentSize().height
		if posY then
			tabBar_Y=posY-tabBar:getContentSize().height-SY(4)
		end
		titleSprite:setPosition(PT(tabBar_X,tabBar_Y))
		layer:addChild(titleSprite,1)
		--
		local label=CCLabelTTF:create(tabStr[1],FONT_NAME,FONT_DEF_SIZE)
		label:setAnchorPoint(PT(0.5,0.5))
		label:setPosition(PT(tabBar_X+titleSprite:getContentSize().width/2,
								tabBar_Y+titleSprite:getContentSize().height/2))
		layer:addChild(label,1)
	end
	return tabBar
end;

--�������
function showLayer()
	if mCurrentTab ==1 then
		createChatLayer()
	end
end;

---�ͷ���Ϣ��
function  releaseChatLayer()
	if mChatLayer then
		mChatLayer:getParent():removeChild(mChatLayer,true)
		mChatLayer=nil
	end
end;

---������Ϣ��
function  createChatLayer()
	releaseChatLayer()
	local layer=CCLayer:create()
	mChatLayer=layer
	mLayer:addChild(layer)

	local tilteLabel=CCSprite:create(P("title/list_1105.png"))
	tilteLabel:setAnchorPoint(PT(0.5,0))
	layer:addChild(tilteLabel,0)
	tilteLabel:setPosition(PT(pWinSize.width/2,pWinSize.height*0.96-tilteLabel:getContentSize().height))
	
	local listSize=SZ(pWinSize.width*0.9,pWinSize.height*0.55)
	local listX=(pWinSize.width-listSize.width)/2
	local listY=pWinSize.height*0.86-listSize.height*1.02
	local mListRowHeight=listSize.height/8
	local list = ScutCxList:node(mListRowHeight, ccc4(24, 24, 24, 0), listSize)
	list:setAnchorPoint(PT(0,0))
    list:setTouchEnabled(true)
---
	local bgSprite=CCSprite:create(P("common/list_1038.9.png"))
	bgSprite:setScaleX(listSize.width/bgSprite:getContentSize().width)
	bgSprite:setScaleY(listSize.height*1.04/bgSprite:getContentSize().height)
	bgSprite:setAnchorPoint(PT(0,0))
	bgSprite:setPosition(PT(listX,pWinSize.height*0.86-listSize.height*1.04))
	layer:addChild(bgSprite,0)
	
	list:setPosition(PT(listX,listY))
	list:setRecodeNumPerPage(1)
	layer:addChild(list,1)
	mList=list
	
	----
	local chatNumSprite=CCSprite:create(P("common/list_1186.png"))
	chatNumSprite:setAnchorPoint(PT(0,0.5))
	chatNumSprite:setPosition(PT(pWinSize.width*0.1,
			bgSprite:getPosition().y-chatNumSprite:getContentSize().height*0.8))
	layer:addChild(chatNumSprite,1)
	
	--
	local numLabel=CCLabelTTF:create("+" .. ChatItemNum .. Language.CHAT_GOODNUM, FONT_NAME,FONT_SM_SIZE)
	numLabel:setAnchorPoint(PT(0,0.5))
	numLabel:setPosition(PT(chatNumSprite:getPosition().x+chatNumSprite:getContentSize().width*1.1,
							chatNumSprite:getPosition().y))
	layer:addChild(numLabel,1)
	mChatItemLabel=numLabel
	
	--���Ͱ�ť
	local sentBtn=ZyButton:new("button/list_1039.png",nil,nil,
									Language.CHAT_SEND)
	sentBtn:setAnchorPoint(PT(0,0.5))
	sentBtn:setPosition(PT(pWinSize.width*0.7,chatNumSprite:getPosition().y))
	sentBtn:addto(layer,1)
	sentBtn:registerScriptHandler(sendAction)
	refreshChatList()
	
	--ˢ��һ��
	actionLayer.Action9204(mScene,false)
		
    schedulerEntry1 = 	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(timeElapse, 5, false)
	


	--CCScheduler:sharedScheduler():scheduleScriptFunc("ChatScene.timeElapse",5, false)
end;

--��ʱ��
function timeElapse(dt)
	if not isClick then
		isClick=true
		actionLayer.Action9204(mScene,false)
	end
end;

--�ͷ������
function  releaseInputLayer()
	if mInputEdit then
		mInputEdit:release()
		mInputEdit=nil
	end
	if mInputLayer then
		mInputLayer:getParent():removeChild(mInputLayer,true)
		mInputLayer=nil
	end
end;

--���������
function  sendAction()
	releaseInputLayer()
	local layer=CCLayer:create()
	mInputLayer=layer
	mChatLayer:addChild(layer,2)
	layer:setAnchorPoint(PT(0,0))
	layer:setPosition(PT(0,0))
-------
	for k=1 ,2 do
		local pingbiBtn=UIHelper.createActionRect(pWinSize)
		pingbiBtn:setPosition(PT(0,0))
		layer:addChild(pingbiBtn,0)
	end
	
	local bgSprite=CCSprite:create(P("common/list_1054.png"))
	local bgSize=SZ(pWinSize.width,bgSprite:getContentSize().height)
	bgSprite:setScaleX(bgSize.width/bgSprite:getContentSize().width)
	bgSprite:setScaleY(bgSize.height/bgSprite:getContentSize().height)
	bgSprite:setAnchorPoint(PT(0.5,0.5))
	bgSprite:setPosition(PT(pWinSize.width/2,pWinSize.height/2))
	layer:addChild(bgSprite,0)
	local startX=pWinSize.width/2-bgSize.width*0.4
	local startY=pWinSize.height/2+bgSize.height*0.3
	--����
	local titleTip=CCLabelTTF:create(Language.CHAT_TITLETIP,FONT_NAME,FONT_DEF_SIZE)
	titleTip:setAnchorPoint(PT(0.5,0))
	titleTip:setPosition(PT(pWinSize.width/2,startY-titleTip:getContentSize().height*1.5))
	layer:addChild(titleTip,0)	

	--�����
	local editSize=SZ(bgSize.width*0.8, titleTip:getContentSize().height*4)
	local startY=pWinSize.height-titleTip:getPosition().y+titleTip:getContentSize().height
	mInputEdit= CScutEdit:new();
	mInputEdit:init(true, false)
	mInputEdit:setRect(CCRect(pWinSize.width/2-bgSize.width*0.4,startY,editSize.width,editSize.height))
	
	--ȡ�� ȷ����ť
	local cancelBtn=ZyButton:new("button/list_1023.png",nil,nil,
						Language.IDS_CANCEL)
	cancelBtn:setAnchorPoint(PT(0,0))
	cancelBtn:setPosition(PT(startX,pWinSize.height/2-bgSize.height*0.4))
	cancelBtn:addto(layer,0)
	cancelBtn:registerScriptHandler(releaseInputLayer)
	
	local sureBtn=ZyButton:new("button/list_1023.png",nil,nil,
						Language.CHAT_SEND)
	sureBtn:setAnchorPoint(PT(0,0))
	sureBtn:setPosition(PT(pWinSize.width/2+bgSize.width*0.4-cancelBtn:getContentSize().width,
								cancelBtn:getPosition().y))
	sureBtn:addto(layer,0)
	sureBtn:registerScriptHandler(sendMessageAction)
end;

---ȷ�����Ͱ�ť
function sendMessageAction()
	local content=mInputEdit:GetEditText()
	if content and string.len(content)>0 then
		if not isClick then
		isClick=true
		actionLayer.Action9203(mScene,nil ,2,content)
		end
	else
		setEditVisible(false)	
		ZyToast.show(mScene,Language.CHAT_TIPS,0.5,0.15)
		delayExec("ChatScene.setEditSee",0.7)
	end
end;

--���������ɼ�
function  setEditVisible(value)
	if mInputEdit then
		mInputEdit:setVisible(value)
	end
end;

function  setEditSee()
	 setEditVisible(true)
end;

--��һ�ν������ ����ˢ�½����ʱ�� ȫ�����Ʊ�
function  refreshChatList()
	if mList  and  _chatMessage[mCurrentTab] then
		mList:clear()
		local mData= _chatMessage[mCurrentTab]
		local layout = CxLayout()
		layout.val_x.t = ABS_WITH_PIXEL
		layout.val_y.t = ABS_WITH_PIXEL
		layout.val_x.val.pixel_val = 0
		layout.val_y.val.pixel_val = 0	
		for k, v in pairs(mData) do
		 	local listItem = ScutCxListItem:itemWithColor(ccc3(24,24,24))
			listItem:setOpacity(0)
			local recordLayer,listHeight=createListItem(v,k)
			listItem:addChildItem(recordLayer, layout)
			mList:setRowHeight(listHeight)
			mList:addListItem(listItem, true)
		end
	 end
end;

---����һ��������Ϣ
function  createListItem(chat,index,type)
	personalInfo=PersonalInfo.getPersonalInfo()
	local layer=CCLayer:create()
	local bgSprite=CCSprite:create(P("common/list_1102.png"))
	bgSprite:setAnchorPoint(PT(0.5,0))
	bgSprite:setScaleX(pWinSize.width*0.9/bgSprite:getContentSize().width)
	bgSprite:setPosition(PT(pWinSize.width*0.45,0))
	layer:addChild(bgSprite,0)
	--����	
	local colorText = ccBLUE
	local channel = Language.CHAT_TITLE6
	if chat.ChatType == 2 then
		colorText = ccGREEN
		channel = Language.CHAT_TITLE2
	elseif chat.ChatType == 3 then
		colorText = ccYELLOW
		channel = Language.CHAT_TITLE3
	elseif chat.ChatType == 4 then
		colorText = ccWHITE
		channel = Language.CHAT_TITLE4
	end
	if chat.UserID=="1000000" then
		colorText = ccBLUE
		channel = Language.CHAT_TITLE6
	end
	local xmlContent=""
	-- Ƶ��
	local tips = Language.CHAT_LEFT..channel..Language.CHAT_RIGHT
	xmlContent = xmlContent..string.format("<label color='%d,%d,%d' >%s</label>",colorText.r,colorText.g,colorText.b,tips)
	xmlContent=""
	----����
	local color = ccPINK
	local sayPoint=string.format("<label  >%s</label>",":")
	if chat.UserID~="1000000" then
		--���署��
			if  chat.UserName==personalInfo._NickName then
				--�Լ����Ļ�
				local str=Language.CHAT_LEFT..Language.CHAT_ME..Language.CHAT_RIGHT
				xmlContent=xmlContent .. string.format("<label color='0,200,133' >%s</label>",str)
			else
				--���˽��Ļ�
				local str=Language.CHAT_LEFT..chat.UserName..Language.CHAT_RIGHT
				
				xmlContent=xmlContent .. string.format("<label color='255,255,0' class='ChatScene.clickPlyer' userdata='%s'>%s</label>",chat.UserID,str)
				if chat.UserVipLv >0 and chat.UserVipLv<=10 and isShowVip() then
					xmlContent=xmlContent..string.format("<image src='%s'/>",string.format("button/vip_%d.png",chat.UserVipLv))
				end
			end
			xmlContent=xmlContent ..  sayPoint
	end

	--���������ת��Ϊͼ��
	if chat.UserVipLv >= 1 then
		--chat.Content= ChatSpecialLayer.faceChange(chat.Content)
	end
			-- ��Ϣ����
	if string.sub(chat.Content,1,1) == "<" then
		xmlContent=xmlContent..chat.Content
	else
		xmlContent=xmlContent..string.format("<label >%s</label>", chat.Content)
	end
	xmlContent=xmlContent..string.format("<label color='111,111,111'>%s</label>","("..chat.SendDate..")")	
	xmlContent = string.gsub(xmlContent,"<label >%s*</label>","")
	
	local contentWidth=pWinSize.width*0.85
	if type then
		 contentWidth=pWinSize.width*0.85
	end
	local startX=pWinSize.width*0.01
	local contentLabel=ZyMultiLabel:new(xmlContent,contentWidth,FONT_NAME,FONT_SM_SIZE);
	contentLabel:setAnchorPoint(PT(0,0))
	contentLabel:addto(layer,1)
	local itemHeight=contentLabel:getContentSize().height+bgSprite:getContentSize().height*2+SY(5)
	contentLabel:setPosition(PT(startX,bgSprite:getContentSize().height+SY(3)))
	return layer,itemHeight
end;



function clickPlyer(pNode)
    local linklabel=ZyLinkLable.getLingLabel(pNode)
    local UserData = linklabel:getUserData()[1]
     createOpretionLayer(UserData,pNode)

end;



---�Ӻ��Ѱ�ť
function  releaseOprationLayer()
	if mOprationLayer then
		mOprationLayer:getParent():removeChild(mOprationLayer,true)
		mOprationLayer=nil
	end
end;

function  createOpretionLayer(tag,pNode)
	if mLayer then
	releaseOprationLayer()
	local layer=CCLayer:create()
	mOprationLayer=layer
	mLayer:addChild(layer,0)
	layer:setPosition(PT(0,0))
	local nodeLayer=CCLayer:create()
	layer:addChild(nodeLayer,2)
	
	local pos =pNode:getParent():convertToWorldSpace(pNode:getPosition())
	local layerX=pos.x+pNode:getContentSize().width*0.5
	local layerY=pos.y 
	nodeLayer:setPosition(PT(layerX,layerY))
	local boxSize=SZ(pWinSize.width,pWinSize.height*0.845)
	
	local uiBtn=UIHelper.createActionRect(boxSize,ChatScene.releaseOprationLayer)
	uiBtn:setPosition(PT(0,pWinSize.height*0.145))
	layer:addChild(uiBtn,0)
	
	local btn=ZyButton:new("button/list_1039.png",nil,nil,Language.FIREND_ADD)
	btn:addto(nodeLayer,0)
	btn:setAnchorPoint(PT(0,0))
	btn:setPosition(PT(0,0))
	btn:setTag(tag)
	btn:registerScriptHandler(addFriend)
	end
end;


function addFriend(node)
local tag=node:getTag()
if tag then
	actionLayer.Action9103(mScene,nil,tag)
end
end;


---��ӵ�����Ϣ  �����������µ��������ݵ�����ӣ�
function appendMessage(index)
	if mList then
		local listItem = ScutCxListItem:itemWithColor(ccc3(24,24,24))
		listItem:setOpacity(0)
		local layout = CxLayout()
		layout.val_x.t = ABS_WITH_PIXEL
		layout.val_y.t = ABS_WITH_PIXEL
		layout.val_x.val.pixel_val = 0
		layout.val_y.val.pixel_val = 0	
		local info =_chatMessage[1][index]		
		local recordLayer,listHeight=createListItem(info,index)
		listItem:addChildItem(recordLayer, layout)
		mList:setRowHeight(listHeight)
		mList:addListItem(listItem, true)		
	end
end

--
-------------------------˽�нӿ�------------------------
--

-- ��ʼ����Դ����Ա����
function initResource()
	personalInfo=PersonalInfo.getPersonalInfo()
end

-- �ͷ���Դ
function releaseResource()
	--CCScheduler:sharedScheduler():unscheduleScriptFunc("ChatScene.timeElapse")
	 --    schedulerEntry1 = 	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(timeElapse, 5, false)
	
	 CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(schedulerEntry1)
	mLayer=nil
	mInputEdit=nil
	mChatLayer=nil
	mScene=nil
	mList=nil
	mInputLayer=nil
	mOprationLayer=nil
	mChatItemLabel=nil
end

-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionID = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	if actionID ==9204 then
		_9204Callback(pScutScene, lpExternalData)
		isClick=false
	elseif actionID ==9203 then
    		if ZyReader:getResult() == eScutNetSuccess then
    			 releaseInputLayer()
			 actionLayer.Action9204(pScutScene,false)	
    		elseif  ZyReader:getResult() ==3 then
    			setEditVisible(false)
			local box = ZyMessageBoxEx:new()
			box:doQuery(mLayer,nil,ZyReader:readErrorMsg(),Language.IDS_SURE,Language.IDS_CANCEL,makeGotoShop)
    		else
    			setEditVisible(false)
			ZyToast.show(pScutScene,ZyReader:readErrorMsg(),0.5,0.15)	
			delayExec("ChatScene.setEditSee",0.7)
    		end
    		isClick=false
    	elseif actionID ==9103 then
	    	if ZyReader:getResult() == eScutNetSuccess then
	    		ZyToast.show(pScutScene,Language.CHAT_ADDFRIEND,0.5,0.15)	
	    		releaseOprationLayer()
	    	else
	    		ZyToast.show(pScutScene,ZyReader:readErrorMsg(),0.5,0.15)	
	    	end
	end
	
end


--�Ƿ�ȥ�̵�
function makeGotoShop(clickedButtonIndex,content,tag)
	if clickedButtonIndex == 1 then--ȷ��
		businessStore.pushScene()		
	else
		setEditSee()
	end
end


-- //�µ���Ϣϵͳ(9024)
function _9204Callback(pScutScene, lpExternalData)
    if ZyReader:getResult() == eScutNetSuccess then
        local ChatMaxNum= ZyReader:getInt()
        DataTabel=nil
        local recordNum=ZyReader:getInt()
        local tNum={}
        if recordNum~=nil and recordNum>0 then
        	DataTabel={}
            for k=1,recordNum do
             	local mRecordTabel_1={}
             	ZyReader:recordBegin()
                mRecordTabel_1.UserID= ZyReader:readString()
                mRecordTabel_1.UserName= ZyReader:readString()
                mRecordTabel_1.Content= ZyReader:readString()
                mRecordTabel_1.SendDate= ZyReader:readString()
                mRecordTabel_1.ChatType= ZyReader:getWORD()
                mRecordTabel_1.ReUser= ZyReader:readString()
                mRecordTabel_1.ReUserName= ZyReader:readString()
                mRecordTabel_1.IsFriend= ZyReader:getInt()
                mRecordTabel_1.UserVipLv= ZyReader:getWORD()
                mRecordTabel_1.ReUserVipLv= ZyReader:getWORD()
                ZyReader:recordEnd()
                ZyTable.push_back(DataTabel,mRecordTabel_1)
-------------------------------------------------	 	
		   if mRecordTabel_1.ChatType ~= 0 then
		   	----1 ��ȫ��
			 appendLocalMessage(1, mRecordTabel_1)	
		   end
		   	appendLocalMessage(mRecordTabel_1.ChatType, mRecordTabel_1)
		   ---����Ƶ���������������
		  	 if tNum[mRecordTabel_1.ChatType] then
				tNum[mRecordTabel_1.ChatType] = tNum[mRecordTabel_1.ChatType]+1
		    	else
				tNum[mRecordTabel_1.ChatType] = 1;
		   	 end
         	end
        end        
        ChatItemNum= ZyReader:getInt()
        if mChatItemLabel then
        	mChatItemLabel:setString("+" .. ChatItemNum .. Language.CHAT_GOODNUM)
        end
	 local mChatType = ScutRequestParam:getParamData(lpExternalData)
		 if recordNum > 0 then
		   local tMessage = getLocalMessage(mChatType)
			if #tMessage > 0 then 
			  	 if recordNum > maxNum  then
					recordNum = maxNum
				 end
				 for index=#tMessage-recordNum+1 , #tMessage  do
				     if index==#tMessage then
				        MainMenuLayer.rebuildMessage()
				     end
				 	if mScene and mList then
						appendMessage(index, mChatType)
					end
				 end
			  end
		  end	   
    else
        ZyToast.show(pScutScene, ZyReader:readErrorMsg(),0.8,0.35)   
    end
end


--����һ����Ϣ  ���������ʱһ��������
function appendLocalMessage(messageType,message)
	if _chatMessage[messageType] == nil then
		_chatMessage[messageType]={}
	end
	if _allMessage[messageType]==nil then
		_allMessage[messageType]={}
	end
	local messageInfo=ZyTable.th_table_dup(message) 
	messageInfo.index=#_allMessage[messageType]+1
	table.insert(_allMessage[messageType],messageInfo)
	--���� maxNum  ɾ����һ��
	if #_chatMessage[messageType] >=maxNum then
		removeMessage(messageType,1)
	end
	table.insert(_chatMessage[messageType],messageInfo)
end


--ɾ��һ����Ϣ
function removeMessage(messageType,index)
	if _chatMessage[messageType] then
		table.remove(_chatMessage[messageType],index)
	end
end

--�������ڴ����� ������Ϣ
function getLocalMessage(messageType)
	if messageType then
		if _chatMessage[messageType] then
			return _chatMessage[messageType]		
		end
	end
	return {}
end

---�ӳٽ��з���
function delayExec(funName,nDuration)
    local  action = CCSequence:createWithTwoActions(
    CCDelayTime:create(nDuration),
    CCCallFunc:create(funName));
    mLayer:runAction(action)
end
