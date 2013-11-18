require("datapool.Image")
MB_STYLE_TITLE 		= 1 --����
MB_STYLE_MESSAGE 	= 2  --����
MB_STYLE_LBUTTON 	= 3
MB_STYLE_RBUTTON 	= 4
MB_STYLE_MODIFY		= 5
MB_STYLE_THEME		= 6
MB_STYLE_GOTO_PAGE	= 7
MB_STYLE_CLOSE		= 8
MB_STYLE_PROMPT		= 9
MB_STYLE_RENAME		= 10 --����
MB_STYLE_PRINT		= 11--������ʾ


ID_MBOK 		= 1   --���
ID_MBCANCEL 	= 2
MB_THEME_NORMAL 	= 1

--��Դ
local BackGroundPath="common/transparentBg.png";
local BgBox="common/list_4000_1.9.png"
local closeButton="button/list_1046.png"
local ButtonNor=Image.image_button_red_c_0
local ButtonClk=Image.image_button_red_c_1
local topHeight=SY(12)
local edgeWidth=SX(10)

ZyMessageBoxEx = {
	_parent 		= nil,
	_layerBox 		= nil,
	_layerBG 	    = nil,
	_funCallback 	= nil,
	_nTag 			= 0,
	_userInfo 		= {},
	_tableStyle 	= {[MB_STYLE_THEME] = MB_THEME_NORMAL},
	_tableParam		= {},
	_edit 			= nil,
	_size			= nil,
	_bShow          = nil,
	_message        = nil,
	
	_title=nil,
	_content=nil,
	_rButton=nil,
	_lButton=nil,
	_showType=nil,
}

-- ����ʵ��
function ZyMessageBoxEx:new()
	local instance = {}
	setmetatable(instance, self)
	self.__index = self
	instance:initStyle()
	return instance
end

-- ���ò�������
function ZyMessageBoxEx:setTag(tag)
	self._nTag = tag
end

-- ��ʾ��
-- �������strButtonΪnil, �������Ͻ���ʾһ���˳���ť
function ZyMessageBoxEx:doPrompt(parent, strTitle, strMessage, strButton,funCallBack)
	if ZyMessageBoxEx == self and self._bShow then
		return
	end
	self._funCallback = funCallBack
	self._parent = parent
	self._title= strTitle 
	self._content= strMessage
	self._rButton = strButton
	self:initMessageBox()
end


-- ѯ�ʿ�
function ZyMessageBoxEx:doQuery(parent, strTitle, strMessage, strButtonL, strButtonR, funCallBack,Color)
    if ZyMessageBoxEx == self and self._bShow then
		return
	end
	self._parent = parent
	self._funCallback = funCallBack
	self._title = strTitle
	self._content = strMessage
	self._rButton= strButtonR
	self._lButton = strButtonL
	self:initMessageBox()
end

-- �޸�
function ZyMessageBoxEx:doModify(parent, title, prompt,strButtonR, strButtonL,funCallback)
	self._parent = parent
	self._funCallback = funCallback
	self._tableParam.prompt = prompt
	self._tableStyle[MB_STYLE_MODIFY] = true
	self._title= title
	self._rButton = strButtonR
	self._lButton= strButtonL	
	self:initMessageBox()
end


--�������������������������������������� ����Ϊ˽�нӿ� ����������������������������������������������
--
-- �Զ�����
function ZyMessageBoxEx:autoHide(fInterval)
	if fInterval == nil then
		fInterval = 3
	end
	gClassPool[1] = self
	  schedulerEntry1 = 	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(timerMBAutoHide, fInterval, false)
	--CCScheduler:sharedScheduler():scheduleScriptFunc("timerMBAutoHide", fInterval, false)
end

-- ��ʼ��һЩ����
function ZyMessageBoxEx:initStyle()
	self._parent   = nil
	self._layerBox = nil
	self._layerBG  = nil
	self._funCallback = nil
	self._nTag = 0
	self._userInfo = {}
	self._tableStyle = {[MB_STYLE_THEME] = MB_THEME_NORMAL}
	self._tableParam = {}
	self._edit = nil
	self._size = nil
	self._bShow = false
end

-- �رնԻ���
function ZyMessageBoxEx:onCloseMessagebox()
	if self._edit ~= nil then
		self._edit:release()
		self._edit = nil
	end
	
	if self._funCallback==nil then
		isNetCall=false
	end
	
	if self._tableStyle[MB_STYLE_CONTRIBUTE] == true then
		for key, value in ipairs(self._tableParam.edit) do
			value:release()
		end
	end
	if self._layerBG ~= nil then
		self._parent:removeChild(self._layerBG, true)
	end
	self:initStyle()
end


function ZyMessageBoxEx:isShow()
	return self._bShow
end


--���Ⱦ�Ҫȥ����
function ZyMessageBoxEx:isGrilShow(value)
	self._showType=value
end;

-- ��ʼ������
function ZyMessageBoxEx:initMessageBox()
	self._bShow = true
	local layer=CCLayer:create()
	self._parent:addChild(layer,9)
	self._layerBG=layer
  
	--�󱳾�
	local actionBtn=UIHelper.createActionRect(pWinSize)
	layer:addChild(actionBtn,0)
	actionBtn:setPosition(PT(0,0))
	--��ɫ����
	local toumingBg=CCSprite:create(P(BackGroundPath))
	toumingBg:setScaleX(pWinSize.width/ toumingBg:getContentSize().width)
	toumingBg:setScaleY(pWinSize.height / toumingBg:getContentSize().height)
	toumingBg:setAnchorPoint(PT(0,0))
	toumingBg:setPosition(CCPoint(0, 0))
	layer:addChild(toumingBg,0)	

	--Ů��ͼ
	local labelWidth=pWinSize.width*0.76
	local girlSprite
	if self._showType then
	girlSprite=CCSprite:create(P("common/list_4000_2.png"))
	girlSprite:setAnchorPoint(PT(0,0))
	labelWidth=pWinSize.width*0.6
	layer:addChild(girlSprite, 1)
	end
	
	--������
	local bgSprite = CCSprite:create(P(BgBox))
	bgSprite:setAnchorPoint(PT(0.5,0.5))
	bgSprite:setPosition(PT(pWinSize.width/2,pWinSize.height/2))
	layer:addChild(bgSprite, 0)
		
	local titlteLabel=nil
	local contentLabel=nil
	local bgHeight=0
	
	--��������
	if self._title then
		titlteLabell = CCLabelTTF:create(self._title, FONT_NAME, FONT_DEF_SIZE)
		titlteLabell:setAnchorPoint(CCPoint(0.5, 0))
		layer:addChild(titlteLabell, 0, 0)
		bgHeight=bgHeight+titlteLabell:getContentSize().height*1.2
	end
	
	--��������
	if self._content then
		--����	
		local contentStr=string.format("<label>%s</label>",self._content )
		contentLabel= ZyMultiLabel:new(contentStr,labelWidth,FONT_NAME,FONT_DEF_SIZE)
		contentLabel:addto(layer,0)
		bgHeight=bgHeight+contentLabel:getContentSize().height	
	end
	--����������ť
	local rBtn=nil
	if self._rButton   then
		local button=ZyButton:new(ButtonNor,ButtonClk,nil,self._rButton,FONT_NAME,FONT_SM_SIZE)
		button:registerScriptHandler(function () actionMessageboxLeftButton(button._menuItem) end )
		local item=button._menuItem
		gClassPool[item] = self
		button:addto(layer,0)
		rBtn=button		
		bgHeight=bgHeight+button:getContentSize().height*1.2
	end
	
	local lBtn=nil
	if self._lButton   then
		local button=ZyButton:new(ButtonNor,ButtonClk,nil,self._lButton,FONT_NAME,FONT_SM_SIZE)
		button:registerScriptHandler(function() actionMessageboxLeftButton(button._menuItem) end )
		local item=button._menuItem
		gClassPool[item] = self
		button:addto(layer,0)
		lBtn=button		
			
	end
	
	--��������ͼ��С	
	local boxHeight=bgHeight+pWinSize.height*0.03>pWinSize.height*0.3
								and bgHeight+pWinSize.height*0.03 or pWinSize.height*0.3
	local size =SZ(pWinSize.width*0.8,boxHeight) 
	if girlSprite then
		size =SZ(pWinSize.width,boxHeight) 
	end
	
	--����ͼ����
	bgSprite:setScaleX(size.width/bgSprite:getContentSize().width)
	bgSprite:setScaleY(size.height/bgSprite:getContentSize().height)
	--��������λ��
	local startY=bgSprite:getPosition().y+size.height/2-pWinSize.height*0.01 
	local midPos=pWinSize.width/2
	local posX=pWinSize.width/2-size.width*0.45
	
	--��ʼλ��
	if girlSprite then
		midPos=pWinSize.width/2+girlSprite:getContentSize().width/2
		posX=girlSprite:getContentSize().width+(pWinSize.width-girlSprite:getContentSize().width-labelWidth)*0.5
	end
	
	--̧ͷλ��
	if titlteLabel then
		startY=startY-titlteLabel:getContentSize().height
		titlteLabel:setPosition(PT(midPos,startY))
	end
	
	--����λ��
	if contentLabel then
		startY=startY-contentLabel:getContentSize().height-SY(3)
		if not girlSprite then
			startY=bgSprite:getPosition().y+size.height*0.1-contentLabel:getContentSize().height/2
			posX=bgSprite:getPosition().x-contentLabel:getContentSize().width/2
		end
		contentLabel:setPosition(PT(posX,startY))
	end
	
	--����������ťλ��
	startY=bgSprite:getPosition().y-size.height/2+pWinSize.height*0.01 	
	if rBtn and  lBtn then
		rBtn:setPosition(PT(midPos-rBtn:getContentSize().width*1.5,startY))
	elseif rBtn and not lBtn then
		rBtn:setPosition(PT(midPos-rBtn:getContentSize().width*0.5,startY))	
	end
	
	if lBtn then
		lBtn:setPosition(PT(midPos+lBtn:getContentSize().width*0.5,startY))
	end
	
	--Ů��λ��
	if girlSprite then
		--Ů��ͼ����λ��
		girlSprite:setPosition(PT(0, 
						bgSprite:getPosition().y-size.height/2+girlSprite:getContentSize().height*0.02))
	end
	
    -- �޸�
	if self._tableStyle[MB_STYLE_MODIFY] ~= nil then
		local offsetX =pWinSize.width/2-size.width*0.4
		local offsetY =pWinSize.height*0.5
		local label = CCLabelTTF:create(self._tableParam.prompt, FONT_NAME, FONT_SM_SIZE)
		label:setAnchorPoint(CCPoint(0, 0))
		label:setPosition(CCPoint(offsetX, offsetY))
		layer:addChild(label, 0)
		local editSize = CCSize(size.width/2, SY(22))
		offsetY = offsetY -editSize.height/2-label:getContentSize().height/2
		offsetX=offsetX+label:getContentSize().width
		
		-- �༭��	
		local edit = CScutEdit:new()
		edit:init(false, false)	
		edit:setRect(CCRect(offsetX, offsetY, editSize.width, editSize.height))
		self._edit = edit
	end
end


function ZyMessageBoxEx:setEditTextSize(size)
	self._edit:setMaxText(size)
end




-- �Ұ�ť(ȡ��)����
function actionMessageboxRightButton(pNode)
	local bClose = true
	local box = gClassPool[pNode]
	if box._funCallback ~= nil then
		box._funCallback(ID_MBCANCEL,  nil,box._nTag)
	end
	
	if bClose then
		box:onCloseMessagebox()
	end
end

function actionMessageboxLeftButton(pNode)
	local bClose= true;
	local box = gClassPool[pNode]
	if box._tableStyle[MB_STYLE_MODIFY] == true then
		box._userInfo.content=box._edit:GetEditText()
	elseif box._tableStyle[MB_STYLE_RENAME] == true then
		box._userInfo.content=box._edit:GetEditText()
	end
	if box._funCallback ~= nil then
		box._funCallback(ID_MBOK,  box._userInfo.content,box._nTag)
	end
	if bClose then
		box:onCloseMessagebox()
	end
end

-- �ص�ԭ�� function funCallback(int clickedButtonIndex, void userInfo, int tag)
function ZyMessageBoxEx:setCallbackFun(fun)
	self._funCallback = fun
end
