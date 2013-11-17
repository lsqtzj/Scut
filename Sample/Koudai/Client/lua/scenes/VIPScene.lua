------------------------------------------------------------------
-- VIPScene.lua.lua
-- Author     : WangTong
-- Version    : 1.0
-- Date       :
-- Description: 
------------------------------------------------------------------

module("VIPScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

_scene = nil 		-- ����
local layerBG=nil
 personalInfo=nil

--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��

-- �������
function pushScene(parent)
	_scene=parent
	initResource()
	createScene()
end
-- �˳�����
function popScene()
	releaseResource()
	CCDirector:sharedDirector():popScene()
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
	VIPRecharge = nil
	listSize = nil
	list = nil
	if layerBG then
        layerBG:getParent():removeChild(layerBG,true)
        layerBG=nil
	end
end

function closeAction()
releaseResource()

end

-- ��������
function createScene()
    if layerBG then
        return
    end
personalInfo=PersonalInfo.getPersonalInfo()
	-- ��ӱ���
	layerBG = CCLayer:create()
	_scene:addChild(layerBG, 0)
	----
	--���ΰ�ť
	local  actionBtn=UIHelper.createActionRect(pWinSize)
	layerBG:addChild(actionBtn,0)

	-- �˴���ӳ�����ʼ����
	--��������
	 local bgSprite = CCSprite:create(P("common/list_1076.png"))
	 bgSprite:setScaleX(pWinSize.width/bgSprite:getContentSize().width)
	 bgSprite:setScaleY(pWinSize.height/bgSprite:getContentSize().height)
	 bgSprite:setAnchorPoint(PT(0,0))
	 bgSprite:setPosition(PT(0,0))
	 layerBG:addChild(bgSprite,0)
	 
	 local bgSprite1 = CCSprite:create(P("common/list_1074.png"))
	 bgSprite1:setScaleX(pWinSize.width/bgSprite1:getContentSize().width)
	 bgSprite1:setScaleY(pWinSize.height/bgSprite1:getContentSize().height)
	 bgSprite1:setAnchorPoint(PT(0,0))
	 bgSprite1:setPosition(PT(0,0))
	 layerBG:addChild(bgSprite1,0)
	 
	
	------VIP�������
	local titleNameImage= "title/list_1100.png"
	local titleName = CCSprite:create(P(titleNameImage))
 	titleName:setAnchorPoint(PT(0.5,0))
	 titleName:setPosition(PT(pWinSize.width*0.5,pWinSize.height*0.9))
	layerBG:addChild(titleName,0)	
	
	--�رհ�ť
	local closeBtn=ZyButton:new("button/list_1046.png")
	closeBtn:registerScriptHandler(closeAction)						
	closeBtn:setAnchorPoint(PT(1,0))
	closeBtn:setPosition(PT(pWinSize.width-SX(2),
							pWinSize.height-closeBtn:getContentSize().height*1.1))	
	closeBtn:addto(layerBG,1)

	--vip��ʾ
	local VIPRecharge = Language.VIP_YUJU -------VIP�ٳ�ֵ����
	local nowValue =personalInfo._VipLv
	local jingshi = personalInfo.VipNextCold
	local nextValue = nil 
	local titleRecharge =nil
	if  nowValue == 10   then 
		nextValue = nowValue
		titleRecharge = CCLabelTTF:create(VIPRecharge,FONT_NAME,FONT_DEF_SIZE)
		layerBG:addChild(titleRecharge,0)
		titleRecharge:setAnchorPoint(PT(0,0))
		titleRecharge:setPosition(PT(pWinSize.width*0.07,pWinSize.height*0.9-titleRecharge:getContentSize().height-SY(2)))
		
		
		local VipNowImg = CCSprite:create(P("button/vip\_10.png"))
		VipNowImg:setAnchorPoint(PT(0,0))
		VipNowImg:setPosition(PT(pWinSize.width*0.07+titleRecharge:getContentSize().width,titleRecharge:getPosition().y-SY(1)))
		layerBG:addChild(VipNowImg,0)
		
		
	elseif  nowValue <10  and  nowValue > 0   then  
		nextValue = nowValue+1		
			----����ǰ��
			 titleRecharge = CCLabelTTF:create(VIPRecharge,FONT_NAME,FONT_DEF_SIZE)
			layerBG:addChild(titleRecharge,0)
			titleRecharge:setAnchorPoint(PT(0,0))
			titleRecharge:setPosition(PT(pWinSize.width*0.07,pWinSize.height*0.9-titleRecharge:getContentSize().height-SY(2)))
			local ImgNum = 0 
			local VIPImg_Num = "button/vip\_\%s.png"
			local VIPImg = ""
			if  nowValue<10 and nowValue>0  then 
			VIPImg = string.format(VIPImg_Num,nowValue) 
			end
			----VIP��������
			local VipNowImg = CCSprite:create(P(VIPImg))
			VipNowImg:setAnchorPoint(PT(0,0))
			VipNowImg:setPosition(PT(pWinSize.width*0.07+titleRecharge:getContentSize().width,titleRecharge:getPosition().y-SY(1)))
			layerBG:addChild(VipNowImg,0)
		
			
			----�ٳ�ֵ����
			local  jingshiStr = string.format(Language.VIP_Str,jingshi)
			local titleNum = CCLabelTTF:create(jingshiStr,FONT_NAME,FONT_DEF_SIZE)
			layerBG:addChild(titleNum,0)
			titleNum:setAnchorPoint(PT(0,0))
			titleNum:setPosition(PT(VipNowImg:getPosition().x+VipNowImg:getContentSize().width,
			titleRecharge:getPosition().y))
			
			
			------��һ��VIp������
			if  nowValue<10 and nowValue>0  then 
			VIPImg = string.format(VIPImg_Num,nextValue) 
			end
			local VipNextImg = CCSprite:create(P(VIPImg))
			VipNextImg:setAnchorPoint(PT(0,0))
			VipNextImg:setPosition(PT(titleNum:getPosition().x+titleNum:getContentSize().width,titleRecharge:getPosition().y-SY(1)))
			layerBG:addChild(VipNextImg,0)
			
	elseif  	nowValue == 0 then 
		nextValue = nowValue+1	
		local titleStr = string.format(Language.VIP_OStr,jingshi)
		titleRecharge = CCLabelTTF:create(titleStr,FONT_NAME,FONT_DEF_SIZE)
		layerBG:addChild(titleRecharge,0)
		titleRecharge:setAnchorPoint(PT(0,0))
		titleRecharge:setPosition(PT(pWinSize.width*0.07,pWinSize.height*0.9-titleRecharge:getContentSize().height-SY(2)))
		
		local VipNowImg = CCSprite:create(P("button/vip\_1.png"))
		VipNowImg:setAnchorPoint(PT(0,0))
		VipNowImg:setPosition(PT(pWinSize.width*0.07+titleRecharge:getContentSize().width,titleRecharge:getPosition().y-SY(1)))
		layerBG:addChild(VipNowImg,0)
				
	end

			
	
		
	
	
	
	-----vip����
	
	local startY=titleRecharge:getPosition().y-SY(2)
	listSize = SZ(pWinSize.width*0.9,pWinSize.height*0.8)
	local listRowH=listSize.height*0.5
	list = ScutCxList:node(listRowH,ccc4(24,24,24,0),listSize)
	list:setAnchorPoint(PT(0,0))
	list:setPosition(PT((pWinSize.width-listSize.width)/2,
							startY-listSize.height))
	layerBG:addChild(list,0)
	list:setTouchEnabled(true)

	local vip_privilege = {
	Language.VIP1,Language.VIP2,Language.VIP3,
	Language.VIP4,Language.VIP5,Language.VIP6,
	Language.VIP7,Language.VIP8,Language.VIP9,
	Language.VIP10}
	
	for i=1,#vip_privilege do 
		
	
		local item = ScutCxListItem:itemWithColor(ccc3(25,57,45))	
		item:setOpacity(0)
		local layout = CxLayout()
		layout.val_x.t = ABS_WITH_PIXEL
		layout.val_y.t = ABS_WITH_PIXEL	
		layout.val_x.val.pixel_val =0
		layout.val_y.val.pixel_val =0
		
		
		local itemLayer,rowH= addTxt(vip_privilege[i],"VIP"..i,list)	
		list:setRowHeight(rowH)	
		item:addChildItem(itemLayer,layout)
		list:addListItem(item,false)
	end
	
	
end


---����ƶ������֣�VIP�Żݾ�����Ϣ
function addTxt(VIStr,VIIStr,list)
	local layer = CCLayer:create()
	local background = CCSprite:create(P("common/list_1038.9.png"))
	layer:addChild(background, 0)	  
	local RowHeight =listSize.height*0.5
	local contentWidth=list:getContentSize().width*0.9
	----VIP����	
	local contentStr=string.format("<label >%s</label>",VIStr)
	local contentLabel=ZyMultiLabel:new(contentStr,contentWidth,FONT_NAME,FONT_SM_SIZE)
	contentLabel:setAnchorPoint(PT(0,0))
	 local posX=(list:getContentSize().width-contentWidth)/2		
	 local height=SY(10)
	 local posY=(height-SY(2))/2
	 contentLabel:setPosition(PT(posX,posY))
	 contentLabel:addto(layer,0)
	RowHeight=contentLabel:getContentSize().height
	 --VIP����
	 local VipTitleLabel = CCLabelTTF:create(VIIStr,FONT_NAME,FONT_BIG_SIZE);
	 layer:addChild(VipTitleLabel,0)
	 VipTitleLabel:setAnchorPoint(PT(0.5,0))
	 VipTitleLabel:setPosition(PT(list:getContentSize().width/2,
	 					contentLabel:getPosition().y+contentLabel:getContentSize().height+SY(2)))	 						
	 RowHeight=RowHeight+VipTitleLabel:getContentSize().height+height		

	 background:setScaleX(listSize.width/background:getContentSize().width)
	 background:setScaleY(RowHeight/background:getContentSize().height)
 	 background:setAnchorPoint(PT(0,0))
	 background:setPosition(PT(0,0))
      	 return layer,RowHeight
end


