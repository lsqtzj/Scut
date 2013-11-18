module ("MagicScene",package.seeall);--ħ������
--require("lib.lib")
--require("action.actionLayer")
--require("layers.InheritLayer")

local mLayer=nil
local mTabBar=nil

----
local magicScene        = nil --����
local mTopListLayer     = nil --ͷ��TobBar��

local mMagicList_Layer  = nil --�����б��
local mMagicList        = nil --�����б�
local mMagicList_StartX = nil
local mMagicList_StartY = nil
local mMagicList_Width  = nil
local mMagicList_Height = nil
local mMagicDetail_StartX = nil--�ұ���ϸ����
local mMagicDetail_StartY = nil
local mMagicDetail_Layer  = nil
local mMagicDetail_Width  = nil
local mMagicDetail_Height = nil
local right_background = nil--�ұ���ϸ������
local left_background  = nil
local mMagicDataList          = nil --�������洢
local mTeamMagicDataList      = nil --�󷨴洢
local mMagicButtonList  = nil
local mCurrentTabIndex  = nil
local mCurrentListIndex = nil
local mUserExperience = 0 --���ʣ������
local mMagicColdTime  = 0 --��ȴʱ��
local mExpLable = nil
local mMagicDetailVector = nil
local mQueueID = nil --���м���id
local nGridWidth = nil
local m_magicData = nil
local m_currentSelectDetail = nil
local m_fucImageLable = nil
local isClick=nil
local startTimeElapse=nil

local m_upgradeBtnStrLabel = nil
local m_upgradeButton = nil

local tabId = {
	eGongFa	= 1,--����
	eZhenFa	= 2,--��
	eChuanCheng = 3,--����
}

local tabName={
	[tabId.eGongFa]			= Language.MAGIC_GONGFA, 
	[tabId.eZhenFa]			= Language.MAGIC_ZHENFA, 
--	[tabId.eChuanCheng]	= Language.INHERIT_TITLE,
}

function movemagicList(page)
	mNowPage=page+1
end;

--�رհ�Ť��Ӧ
function closeAction()
	releaseAll()  -----  �ر�ħ������
	release()  ----- �ͷű���
	--CCDirector:sharedDirector():popScene();--�رյ�ǰ����
	mLayer=nil  -----����
	magicScene        = nil --����
end

function releaseAll()
	closeMagicLayer()
--	releaseInheritLayer()
end

--�ͷ�
function release()
	--CCScheduler:sharedScheduler():unscheduleScriptFunc("MagicScene.timeElapse")
	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(schedulerEntry1)
	isClick = nil
	mTabBar = nil
	startTimeElapse = nil
	mTopListLayer     = nil --ͷ��TobBar��
	mMagicList_Layer  = nil --�����б��
	mMagicList        = nil --�����б�
	mMagicList_StartX = nil
	mMagicList_StartY = nil
	mMagicList_Width  = nil
	mMagicList_Height = nil
	mMagicDetail_StartX = nil--�ұ���ϸ����
	mMagicDetail_StartY = nil
	mMagicDetail_Layer  = nil
	mMagicDetail_Width  = nil
	mMagicDetail_Height = nil
	right_background = nil--�ұ���ϸ������
	left_background = nil
	
	mMagicButtonList  = nil
	mCurrentTabIndex  = nil
	mCurrentListIndex = nil
	mUserExperience = nil --���ʣ������
	mMagicColdTime  = nil --��ȴʱ��
	mExpLable = nil
	mMagicDetailVector = nil
	mQueueID = nil
	nGridWidth = nil
	m_fucImageLable = nil
	m_upgradeButton = nil
	m_upgradeBtnStrLabel = nil
	magicLayer = nil
	
	

	
	mLayer=nil  -----����
	magicScene        = nil --����
end

--��ʼ��
function initRelease()

	---------���list����
	nGridWidth = SX(70)
	mMagicList_Width  = pWinSize.width*0.9
	mMagicList_Height = pWinSize.height*0.33
	mMagicList_StartX = SX(24)
	mMagicList_StartY = pWinSize.height*0.51
    
    	mMagicDetail_StartX = SX(24)
	mMagicDetail_Width  = mMagicList_Width
	mMagicDetail_Height = pWinSize.height*0.27
	mMagicDetail_StartY = pWinSize.height*0.22
	mCurrentTabIndex = 1
	mCurrentListIndex = 1
	mNowPage = 1
	mMaxPage = 1
	mUserExperience = 0 --���ʣ������
	mMagicColdTime  = 0--��ȴʱ��
	mMagicDataList = {}
	mTeamMagicDataList = {}
	mMagicListCur_MagicID   = 1--ħ��id
	mMagicListCur_MagicType = 2--ħ������
	mMagicListCur_MagicName = 3--ħ����������
	mMagicListCur_HeadID    = 4--ͼƬid
	mMagicListCur_MagicLv   = 5--ħ���ȼ�
	mMagicListCur_IsUp      = 6--�Ƿ��������
end


function init()
	if magicScene ~= nil then
		return
	end
    local scene = ScutScene:new()  --����
	scene:registerCallback(netCallback)--��������ص�����
	magicScene = scene.root
	magicScene:registerScriptHandler(SpriteEase_onEnterOrExit)
	SlideInLReplaceScene(magicScene,1)

	
	initRelease() -----��ʼ��

	mLayer = CCLayer:create()    -----��
	mLayer:setPosition(PT(0,0))  -----��������
	magicScene:addChild(mLayer,2)


	--��������
	creatBg()
	

	mTopListLayer     = CCLayer:create();
	mTopListLayer:setPosition(PT(0,0))
	mLayer:addChild(mTopListLayer,2)  -------------------


    
	MainMenuLayer.init(2, mLayer)
    
    
	createTabBar(tabName) ----�л�����
	
	creatMagicLayer()  -----ħ�����汳��
	
	sendRequestDataListFirst()------��һ������
	
	schedulerEntry1 = 	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(timeElapse, 1, false)
	--CCScheduler:sharedScheduler():scheduleScriptFunc("MagicScene.timeElapse",1, false)---������
end

function creatBg()
	local midSprite=CCSprite:create(P(Image.image_halfbackground))
	local boxSize=SZ(pWinSize.width,pWinSize.height*0.855)
	midSprite:setScaleX(boxSize.width/midSprite:getContentSize().width)
	midSprite:setScaleY(boxSize.height/midSprite:getContentSize().height)	
	midSprite:setAnchorPoint(PT(0,0))
	midSprite:setPosition(PT(0,pWinSize.height*0.145))
	mLayer:addChild(midSprite,0)
	
	local headTitleBg=CCSprite:create(P("title/list_1104.png"))
	headTitleBg:setAnchorPoint(PT(0.5, 1))
	headTitleBg:setPosition(CCPoint(pWinSize.width/2, pWinSize.height*0.96))
	mLayer:addChild(headTitleBg, 0)
end;


function SpriteEase_onEnterOrExit (tag)
    if tag == "exit" then
        release()
    end
end



--ħ�����汳��
function creatMagicLayer()
	if magicLayer ~= nil then
		magicLayer:getParent():removeChild(magicLayer,true)
		magicLayer = nil
	end
	magicLayer = CCLayer:create()	
	mLayer:addChild(magicLayer,0)

	local left_background  = CCSprite:create(P("common/list_1038.9.png"));--����
	left_background:setAnchorPoint(PT(0,0))
	left_background:setPosition(PT(mMagicList_StartX,mMagicList_StartY))
	left_background:setScaleX((mMagicList_Width)/left_background:getContentSize().width)
	left_background:setScaleY((mMagicList_Height)/left_background:getContentSize().height)
	magicLayer:addChild(left_background,0)
	----------�ұ����鱳��-------
	local right_background = CCSprite:create(P("common/list_1038.9.png"));--����

	right_background:setScaleX(mMagicDetail_Width/right_background:getContentSize().width)
	right_background:setScaleY(mMagicDetail_Height/right_background:getContentSize().height)
	right_background:setAnchorPoint(PT(0,0))
	right_background:setPosition(PT(mMagicDetail_StartX,mMagicDetail_StartY))
	magicLayer:addChild(right_background,0)

	local tmpScale = mMagicList_Height/mMagicList_Width
	local row = 4
	local line = 2
	
	local nGridWidth = (mMagicList_Width*0.9)/row
	local nGridHeight = (mMagicList_Height*0.9)/line
	if tmpScale > 1 then
		nGridWidth = nGridWidth*tmpScale
	end

	mMagicList =  ScutCxList:node(mMagicList_Height,ccc4(24, 24, 24, 255), CCSize(mMagicList_Width,mMagicList_Height-SY(10)))
	mMagicList:setAnchorPoint(PT(0,0))
	mMagicList:setPosition(PT(mMagicList_StartX,mMagicList_StartY+SY(5)))
	mMagicList:registerLoadEvent(movemagicList)	
--	mMagicList:setHorizontal(true)--�ݺ��ƶ�����
	mMagicList:setPageTurnEffect(true)
	mMagicList:setRecodeNumPerPage(1)
	magicLayer:addChild(mMagicList,0)
	

end

--�ر�ħ������
function closeMagicLayer()
	m_upgradeButton = nil
	m_upgradeBtnStrLabel = nil
	if m_fucImageLable ~= nil then
		m_fucImageLable:getParent():removeChild(m_fucImageLable,true)
		m_fucImageLable = nil
	end
	
	if mMagicDetail_Layer~= nil then
		mMagicDetail_Layer:getParent():removeChild(mMagicDetail_Layer,true)
		mMagicDetail_Layer = nil
	end
		
	if magicLayer ~= nil then
		magicLayer:getParent():removeChild(magicLayer,true)
		magicLayer = nil
	end
	mExpLable = nil
end

function relsaseBgAndList() 	
	if right_background ~= nil then
        	right_background:getParent():removeChild(right_background,true)
        	right_background = nil
	end
	if left_background ~= nil then
        	left_background:getParent():removeChild(left_background,true)
        	left_background = nil
	end
	if m_fucImageLable ~= nil then
		m_fucImageLable:getParent():removeChild(m_fucImageLable,true)
		m_fucImageLable = nil
	end
	if mMagicList_Layer ~= nil then
		mMagicList = nil
		mMagicList_Layer:getParent():removeChild(mMagicList_Layer,true)
		mMagicList_Layer = nil
	end
		
	
	 	
end;

--Tab�����л�
function createTabBar(tabName)
	if mTabBar~=nil then
		mTabBar:remove()
		mTabBar=nil
	end
	local tabBar = ZyTabBar:new(Image.image_top_button_0, Image.image_top_button_1, tabName, FONT_NAME, FONT_SM_SIZE, tabMax, Image.image_LeftButtonNorPath, Image.image_rightButtonNorPath);
	mTabBar = tabBar; ---- ��ť
	tabBar:setCallbackFun(topTabBarAction); -----�����������
	tabBar:addto(mTopListLayer,5) ------���
	tabBar:setColor(ZyColor:colorYellow())  ---������ɫ
	tabBar:setPosition(PT(SX(25),pWinSize.height*0.835))  -----��������
end

--ͷ��TabBar�ص�����
function topTabBarAction(bar,pNode)
	local index  = pNode:getTag();
	if mCurrentTabIndex ~= index then
		mCurrentTabIndex =index
		mCurrentListIndex = 1
		mNowPage = 1
		releaseAll()
		if mCurrentTabIndex == tabId.eGongFa or mCurrentTabIndex == tabId.eZhenFa then
			creatMagicLayer()
			sendRequestDataListFirst()
		elseif mCurrentTabIndex == tabId.eChuanCheng then
			creatInheritLayer()
		end
	end
end



function getScene()
	return magicScene
end

function releaseInheritLayer()
        if InheritLayer.mLayer ~= nil then
        	InheritLayer.releaseAll()
        end
        if inheritLayer ~= nil then
        	inheritLayer:getParent():removeChild(inheritLayer,true)
        	inheritLayer = nil
        end
end

       	
function creatInheritLayer()
	if inheritLayer ~= nil then
		inheritLayer:getParent():removeChild(inheritLayer,true)
		inheritLayer = nil
	end

	inheritLayer = CCLayer:create()
	mLayer:addChild(inheritLayer,4)

	InheritLayer.init(inheritLayer)
end

function getCurrentSelectDataList()
	if mCurrentTabIndex == tabId.eGongFa then
		return mMagicDataList
	elseif mCurrentTabIndex == tabId.eZhenFa then
		return mTeamMagicDataList
	else
		return nil
	end
end

--��ʾ�����б�
function showMagicList()
	if m_fucImageLable ~= nil then
		m_fucImageLable:getParent():removeChild(m_fucImageLable,true)
		m_fucImageLable = nil
	end
	if mMagicList_Layer ~= nil then
		mMagicList_Layer:getParent():removeChild(mMagicList_Layer,true)
	end
	mMagicList_Layer = nil
	mMagicList_Layer = CCLayer:create()
	mLayer:addChild(mMagicList_Layer,2)
	
	local line = 2
	local row = 4
	
	local tmpScale = mMagicList_Height/mMagicList_Width
	local nGridWidth = (mMagicList_Width*0.9)/row
	local nGridHeight = (mMagicList_Height*0.9)/line
	if tmpScale > 1 then
		nGridWidth = nGridWidth*tmpScale
	end
	labelList={}
	local listIndex = 1
	local tmpDataList = getCurrentSelectDataList()
	local layout = CxLayout()
	layout.val_x.t = ABS_WITH_PIXEL
	layout.val_y.t = ABS_WITH_PIXEL
	mMagicButtonList = {}
	local nAmount = 0
	if tmpDataList then
		nAmount = #tmpDataList
	end
	local mMaxPage = math.ceil(nAmount/row/line)

	local nScale = 1
	local image_h=Tools.get_image_h(Image.image_zhenfa_beijing)
	local image_w=Tools.get_image_w(Image.image_zhenfa_beijing)
	local list_y=(mMagicList_Height-nGridHeight*line+(nGridHeight-image_h))/2+SY(10)--�б����ݸ߶�
	local list_x=(mMagicList_Width-SX(10)-nGridWidth*row+(nGridWidth-image_w))/2--�б���������
	for i = 1,mMaxPage do
		local listItem=ScutCxListItem:itemWithColor(ccc3(24, 24, 24))
		listItem:setOpacity(0)
		listItem:setDrawTopLine(false)
		listItem:setDrawBottomLine(false)
		listItem:setDrawSelected(false)
		for index =1,line do
			local dy = (line-index)*(nGridHeight)+ list_y
			for j=1,row do
				local dx = nGridWidth*(j-1)+list_x
				local actionPath = nil
				local image = nil
				local name = nil
				local level = nil
				if tmpDataList ~= nil and tmpDataList[listIndex] ~= nil then
					--����ͼƬ
					image = string.format("smallitem/%s.png",tmpDataList[listIndex].HeadID)
					name = tmpDataList[listIndex].MagicName
					level = string.format(Language.MAGIC_LEVEL,tmpDataList[listIndex].MagicLv)
					actionPath =magicListAction
					local tag = listIndex
					local isLock = nil
					
					if mCurrentTabIndex == tabId.eZhenFa and tmpDataList[listIndex].IsEnabled == 0 then
						tag = tmpDataList[listIndex].IsLv
						actionPath = clickLockAction
						isLock = true
					end
					
					local btn = createItemButton(image,nScale,actionPath,tag,name,level, isLock)
					layout.val_x.val.pixel_val = dx
					layout.val_y.val.pixel_val = dy
					listIndex = listIndex+1
					listItem:addChildItem(btn,layout)
					
				end

			end
		end
		mMagicList:addListItem(listItem,false)
	end
	if mNowPage ~= 1 then
		mMagicList:turnToPage(mNowPage-1)
	end
end

--δ�����󷨵����Ӧ
function clickLockAction(pNode)
	local tag = pNode:getTag()
	local str = string.format(Language.MAGIC_OPEN, tag)
	
	ZyToast.show(magicScene, str, 1.5, 0.35)
end;



function createItemButton(image,nScale,actionPath,tag,name,level, isLock)
	-- ����
	local menuItem = CCMenuItemImage:create(P(Image.image_zhenfa_beijing), P(Image.image_zhenfa_beijing))
	local btn = CCMenu:createWithItem(menuItem)
	btn:setAnchorPoint(PT(0,0))
	menuItem:setAnchorPoint(PT(0,0))
	if tag~= nil and tag~=-1 then
		menuItem:setTag(tag)
	end
	
	--��������
	if nScale == nil then
		nScale = 1
	end
	menuItem:setScale(nScale)
    
	--���ûص�
	if actionPath ~= nil then
		menuItem:registerScriptTapHandler(function () actionPath(menuItem) end )
	end
    
	-- ����ͼ
	if image ~= nil and image ~= "" then
		local imageLabel = CCSprite:create(P(image))
		imageLabel:setAnchorPoint(CCPoint(0.5, 0.5))
		imageLabel:setPosition(PT(menuItem:getContentSize().width*0.5,menuItem:getContentSize().height*0.5))
		menuItem:addChild(imageLabel,0)
	end
    
	--�ȼ�
	if name ~= nil then
		local nameLabel22 = CCLabelTTF:create(level, FONT_NAME, FONT_SM_SIZE-2)
		nameLabel22:setAnchorPoint(CCPoint(1, 0))
		nameLabel22:setPosition(PT(menuItem:getContentSize().width-SX(3),SY(3)))
		menuItem:addChild(nameLabel22,1)
		
		labelList[tag]=nameLabel22
	end
    
	if name ~= nil then
		local nameLabel = CCLabelTTF:create(name, FONT_NAME, FONT_SM_SIZE-2)
		nameLabel:setAnchorPoint(CCPoint(0.5, 0))
		nameLabel:setPosition(PT(menuItem:getContentSize().width/2,-nameLabel:getContentSize().height-SY(1)))
		menuItem:addChild(nameLabel,1)
	end
    
	if image~=nil and tag == mCurrentListIndex then
		m_fucImageLable = CCSprite:create(P(Image.Image_choicebox))
		m_fucImageLable:setAnchorPoint(CCPoint(0.5, 0.5))
		m_fucImageLable:setPosition(PT(menuItem:getContentSize().width*0.5,menuItem:getContentSize().height*0.5))
		menuItem:addChild(m_fucImageLable,0)
	end
	
	
	if isLock then
--		local lockBg = CCSprite:create(P(Image.image_lock))
--		lockBg:setAnchorPoint(CCPoint(0.5, 0.5))
--		lockBg:setPosition(PT(menuItem:getContentSize().width*0.5,menuItem:getContentSize().height*0.5))
--		menuItem:addChild(lockBg,0)	
		local lockLabel = CCLabelTTF:create(Language.MAGIC_UNOPEN, FONT_NAME, FONT_SM_SIZE-2)
		lockLabel:setAnchorPoint(CCPoint(0, 1))
		lockLabel:setPosition(PT(SX(3),menuItem:getContentSize().height-SY(3)))
		menuItem:addChild(lockLabel,1)	
		
		
	end

	btn:setContentSize(SZ(menuItem:getContentSize().width*nScale,menuItem:getContentSize().height*nScale))
	return btn
end

--����б���Ӧ
function magicListAction(pNode,index)
	if pNode ~= nil then
		if pNode:getTag()~=nil then
		
			if m_fucImageLable ~= nil then
				m_fucImageLable:getParent():removeChild(m_fucImageLable,true)
				m_fucImageLable = nil
			end
			
			if  m_fucImageLable == nil then
				m_fucImageLable = CCSprite:create(P(Image.Image_choicebox))
				m_fucImageLable:setAnchorPoint(CCPoint(0.5, 0.5))
				m_fucImageLable:setPosition(PT(pNode:getContentSize().width*0.5,pNode:getContentSize().height*0.5))
				pNode:addChild(m_fucImageLable,0)
			end
			
			mCurrentListIndex = pNode:getTag()
			local tmpDataList = getCurrentSelectDataList()
			if tmpDataList ~= nil and tmpDataList[mCurrentListIndex] ~= nil then
				local magicInfo = MagicConfig.getMagicInfo(tmpDataList[mCurrentListIndex].MagicID)
				setCurrentSelectDetail(magicInfo,tmpDataList[mCurrentListIndex].MagicLv)
			end
			
		end
	end
end

function setCurrentSelectDetail(magicInfo,magicLv)
	if magicInfo~=nil then
		m_currentSelectDetail = {}
		m_currentSelectDetail.MagicName = magicInfo.MagicName
		m_currentSelectDetail.MagicLv   = magicLv
		m_currentSelectDetail.MagicID   = magicInfo.MagicID
		m_currentSelectDetail.MagicDesc = magicInfo.MagicDesc
		m_currentSelectDetail.HeadID    = magicInfo.HeadID
		local levInfo   = magicInfo.MagicLevelInfo[magicLv+1]--��һ����������
		if levInfo~= nil then
			m_currentSelectDetail.requestLevel     = levInfo.EscalateMinLv--��Ҫ��ɫ�ȼ�
			m_currentSelectDetail.requestExpNum    = levInfo.ExpNum--��������
			m_currentSelectDetail.ColdTime         = levInfo.ColdTime--������ȴʱ��
		else
			m_currentSelectDetail.isMaxLev = true
		end
		showMagicDetail()
	end
end

--�ұ�ħ��������ϸ
function showMagicDetail()
	if mMagicDetail_Layer ~= nil then
		m_upgradeBtnStrLabel = nil
		m_upgradeButton = nil
		mMagicDetail_Layer:getParent():removeChild(mMagicDetail_Layer,true)
	end
	mMagicDetail_Layer = nil
	mMagicDetail_Layer = CCLayer:create()
	magicLayer:addChild(mMagicDetail_Layer,3)
	local nGridWidth = SY(60)
	local statX      = mMagicDetail_StartX+SX(5)
	local statY      = mMagicDetail_StartY+mMagicDetail_Height
	--ħ��ͼ�񱳾�
	local magicBg=CCMenuItemImage:create(P(Image.image_zhenfa_beijing), P(Image.image_zhenfa_beijing))
	magicBg:setAnchorPoint(PT(0,0))
	magicBg:setPosition(PT(statX,statY-magicBg:getContentSize().height-SY(5)))
	mMagicDetail_Layer:addChild(magicBg,0)
	if m_currentSelectDetail ==nil then
		return
	end
	
	
	--ħ��ͼ��
	local imgStr = string.format("smallitem/%s.png",m_currentSelectDetail.HeadID)
	local magicImg = CCSprite:create(P(imgStr))
--	magicImg:setScaleX((magicBg:getContentSize().width-SX(3))/magicBg:getContentSize().width)
--	magicImg:setScaleY((magicBg:getContentSize().height-SY(3))/magicBg:getContentSize().height)
	magicImg:setAnchorPoint(PT(0.5,0.5))
	magicImg:setPosition(PT(magicBg:getPosition().x+magicBg:getContentSize().width/2,magicBg:getPosition().y+magicBg:getContentSize().height/2))
	mMagicDetail_Layer:addChild(magicImg,0)
	
	
	statX = mMagicDetail_Width*0.275
	local height = SY(2)
	--ħ�����ƣ�
	local nameLabel  = CCLabelTTF:create(Language.MAGIC_NAME..":"..m_currentSelectDetail.MagicName,FONT_NAME,FONT_SM_SIZE)
	nameLabel:setAnchorPoint(PT(0,0))
	statY = statY-nameLabel:getContentSize().height*1.5-height
	nameLabel:setPosition(PT(statX, statY))
	mMagicDetail_Layer:addChild(nameLabel,0)
	
	--ħ���ȼ�	
	local maxLevStr = ""
	if m_currentSelectDetail.isMaxLev == true then
		maxLevStr = Language.MAGIC_MESSAGE[6]
	end
	local levlabel = CCLabelTTF:create(Language.IDS_LEVEL..":"..string.format(Language.MAGIC_LEVEL,m_currentSelectDetail.MagicLv)..maxLevStr,FONT_NAME,FONT_SM_SIZE);
	levlabel:setAnchorPoint(PT(0,0))
	statY = statY-levlabel:getContentSize().height-height
	levlabel:setPosition(PT(statX, statY))
	mMagicDetail_Layer:addChild(levlabel,0)

	--ħ����������
	local tmpNameList = {}
	if mCurrentTabIndex == 1 then
		tmpNameList  = {Language.MAGIC_FUNCDESCG,Language.MAGIC_CONSUMPEXP,Language.MAGIC_LEVNEEDS}
	else
		tmpNameList = {Language.MAGIC_FUNCDESCZ,Language.MAGIC_CONSUMPEXP,Language.MAGIC_LEVNEEDS}
	end
	local showWidth      = mMagicDetail_Width*0.73
	local showHeight     = SY(20)
--	local addHeight = 0
	local personInfo = PersonalInfo.getPersonalInfo()
	local isUp = true
	local isShowUpBtn = true
	if m_currentSelectDetail.isMaxLev == true then--�Ѿ�����
		local xmlContent   = string.format("<label color='255, 255, 255' >%s</label>",tmpNameList[1]..":")
		local colorStr = "255, 255, 255"
		xmlContent = xmlContent..string.format("<label color='%s' >%s</label>",colorStr , m_currentSelectDetail.MagicDesc)
		local ndMultiLabel = ZyMultiLabel:new(xmlContent,showWidth,FONT_NAME,FONT_SM_SIZE,nil,nil)
	--	addHeight = addHeight + ndMultiLabel:getContentSize().height
		statY = statY-ndMultiLabel:getContentSize().height-height
		ndMultiLabel:setPosition(PT(statX, statY))
		ndMultiLabel:addto(mMagicDetail_Layer,1)
		isShowUpBtn = false
	else
		for i = 1,3 do
			local xmlContent   = string.format("<label color='255, 255, 255' >%s</label>",tmpNameList[i]..":")
			local tmpStr = ""
			local colorStr = "255, 255, 255"
			if i == 1 then
				tmpStr = m_currentSelectDetail.MagicDesc
			elseif i== 2 then
				if m_currentSelectDetail.requestExpNum > mUserExperience then
					colorStr = "255,0,0"
					isUp = false
				end
				tmpStr = m_currentSelectDetail.requestExpNum..""..Language.MAGIC_MESSAGE[1]
			elseif i == 3 then
				if personInfo~=nil and m_currentSelectDetail.requestLevel > personInfo._UserLv then
					colorStr = "255,0,0"
					isUp = false
				end
				tmpStr = m_currentSelectDetail.requestLevel..""..Language.MAGIC_MESSAGE[3]
			end
			xmlContent = xmlContent..string.format("<label color='%s' >%s</label>",colorStr,tmpStr)
			local ndMultiLabel = ZyMultiLabel:new(xmlContent,showWidth,FONT_NAME,FONT_SM_SIZE,nil,nil)
			statY = statY-ndMultiLabel:getContentSize().height-height
			ndMultiLabel:setPosition(PT(statX, statY))
			ndMultiLabel:addto(mMagicDetail_Layer,1)
		end
	end

	
	local posX=mMagicDetail_StartX+mMagicDetail_Width*0.96
	m_upgradeButton=ZyButton:new(Image.image_button_red_c_0,Image.image_button_red_c_1,Image.image_button_hui_c)
	m_upgradeButton:setAnchorPoint(PT(0,0.5))
	m_upgradeButton:setPosition(PT(posX-m_upgradeButton:getContentSize().width,
					mMagicDetail_StartY+SY(15)))
	m_upgradeButton:registerScriptHandler(upgradeButtonAction)
	m_upgradeButton:addto(mMagicDetail_Layer,1)
	
	
	local buttonStr = Language.MAGIC_UPGRADE
	local color = ZyColor:colorYellow()
	m_upgradeBtnStrLabel=CCLabelTTF:create(buttonStr,FONT_NAME,FONT_SM_SIZE);
	m_upgradeBtnStrLabel:setAnchorPoint(PT(0.5,0.5))
	m_upgradeBtnStrLabel:setPosition(PT(m_upgradeButton:getPosition().x+m_upgradeButton:getContentSize().width/2,
						m_upgradeButton:getPosition().y))
	mMagicDetail_Layer:addChild(m_upgradeBtnStrLabel,2)
	
	if m_currentSelectDetail.isMaxLev == true  or m_currentSelectDetail.requestExpNum > mUserExperience or m_currentSelectDetail.requestLevel > personInfo._UserLv then
		m_upgradeButton:setEnabled(false)
	else
		m_upgradeBtnStrLabel:setColor(color)--������ɫ
	end
	


end

--����������ť
function upgradeButtonAction()
	if not isClick then
		isClick=true
		if m_currentSelectDetail~= nil and m_currentSelectDetail.MagicID  then
			actionLayer.Action1503(magicScene,nil,m_currentSelectDetail.MagicID )
		end
	end
end

--��ʾ���ʣ������
function showUserExperience()
	if mUserExperience == nil then
		mUserExperience = 0
	end
	if mExpLable == nil then
		mExpLable = CCLabelTTF:create(string.format(Language.MAGIC_SURPLUSEXP,mUserExperience),FONT_NAME,FONT_SM_SIZE)
		mExpLable:setAnchorPoint(PT(0, 1))
		mExpLable:setPosition(PT( pWinSize.height*0.05, pWinSize.height*0.26))			
		magicLayer:addChild(mExpLable,1)
	else
		mExpLable:setString(string.format(Language.MAGIC_SURPLUSEXP,mUserExperience))
	end

end


--������ȴʱ��
function actionUnCold()
    if mQueueID ~= nil then
        actionLayer.Action1702(magicScene,nil,mQueueID,1)
    end
end

function coldButtonMessageBoxAction(clickedButtonIndex)
	if clickedButtonIndex==ID_MBOK then
		if mQueueID ~= nil then
			actionLayer.Action1702(magicScene,nil,mQueueID,2)
		end
	end
end

--Time Action��ʱ���ص�����
function timeElapse(pt)
	if startTimeElapse then
		mMagicColdTime = mMagicColdTime - pt
		if mMagicColdTime > 0 then
			if m_upgradeBtnStrLabel ~= nil then
				local buttonStr = Language.EQUIP_TIME.." "..formatTime(mMagicColdTime)
				m_upgradeBtnStrLabel:setString(buttonStr)
				m_upgradeBtnStrLabel:setColor(ZyColor:colorWhite())--������ɫ
			end
		else
			if m_upgradeBtnStrLabel ~= nil and m_upgradeButton ~= nil then
				m_upgradeBtnStrLabel:setString(Language.EMBATTLE_UPGRADE)
				m_upgradeBtnStrLabel:setColor(ZyColor:colorYellow())--������ɫ
				m_upgradeButton:setScaleX(1)--�������ű���
				m_upgradeButton:setPosition(PT(mMagicDetail_StartX+(mMagicDetail_Width-m_upgradeButton:getContentSize().width)/2,m_upgradeBtnStrLabel:getPosition().y+m_upgradeBtnStrLabel:getContentSize().height/2))
			end
			startTimeElapse = false
		end
	end
end

function setMagicListInfo(serverInfo)
	if serverInfo ~= nil then
		mUserExperience  = serverInfo.ExpNum--����
		mMagicColdTime   = serverInfo.ColdTime--��ȴʱ��
		mQueueID         = serverInfo.QueueID
		mMaxPage         = serverInfo.PageCount
		if mMaxPage == nil or mMaxPage < 1 then
			mMaxPage = 1
		end
		if mMagicColdTime > 0 then
			startTimeElapse = true
		end
	
		if serverInfo.RecordTabel ~= nil then
			m_magicData = {}
			if mCurrentTabIndex == tabId.eGongFa then
				m_magicData.magicList     = serverInfo.RecordTabel
			elseif mCurrentTabIndex == tabId.eZhenFa then
				m_magicData.zengFaList    = serverInfo.RecordTabel
			end
		end
	end
end

function getCurrentSelectDataList()
	if m_magicData~=nil then
		if mCurrentTabIndex == tabId.eGongFa then
			return m_magicData.magicList
		elseif mCurrentTabIndex == tabId.eZhenFa then
			return m_magicData.zengFaList
		end
	end
	return nil
end

function sendRequestDataListFirst()
	startTimeElapse=false
    	actionLayer.Action1501(magicScene,nil,1,60,mCurrentTabIndex)
end

function netCallback(pScutScene, lpExternalData)
	local actionId = ZyReader:getActionID();
	if actionId==1501 then--��ȡ�б�
		isClick=false
		local serverInfo=actionLayer._1501Callback(pScutScene, lpExternalData)
		setMagicListInfo(serverInfo)
	        if isLevelUp ~= true then
	                showMagicList()
	        end
             isLevelUp=false
		showUserExperience()
		local tmpDataList = getCurrentSelectDataList()
		if tmpDataList~=nil and tmpDataList[mCurrentListIndex]~= nil then
			local magicInfo = MagicConfig.getMagicInfo(tmpDataList[mCurrentListIndex].MagicID)
			setCurrentSelectDetail(magicInfo,tmpDataList[mCurrentListIndex].MagicLv)
		end
	elseif actionId==1503 then--��������
		local serverInfo=actionLayer._1503Callback(pScutScene, lpExternalData)
		if serverInfo ~= nil then
			local tmpDataList = getCurrentSelectDataList()
			tmpDataList[mCurrentListIndex].MagicLv = tmpDataList[mCurrentListIndex].MagicLv+1
			local level = string.format(Language.MAGIC_LEVEL,tmpDataList[mCurrentListIndex].MagicLv)
			labelList[mCurrentListIndex]:setString(level)
			isLevelUp=true
			sendRequestDataListFirst()
		else
			isClick=false
		end
	elseif actionId == 1702 then
		local nResult = ZyReader:getResult()
		isClick = false
		if nResult==0 or nResult == 2 then--�ɹ�
			mMagicColdTime = 0
		elseif nResult == 1 then--1��ʹ�þ�ʯ
			local box = ZyMessageBoxEx:new()
			box:doQuery(mLayer,Language.TIP_TIP,ZyReader:readErrorMsg(),Language.TIP_YES,Language.TIP_NO,coldButtonMessageBoxAction)
		else
			ZyToast.show(pScutScene,ZyReader:readErrorMsg(),3,0.35)
		end
	end

	commonCallback.networkCallback(pScutScene, lpExternalData)
end

