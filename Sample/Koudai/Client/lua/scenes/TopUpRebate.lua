------------------------------------------------------------------
-- TopUpRebate.lua.lua
-- Author     : yeyq

-- Version    : 1.0
-- Date       :
-- Description: 
------------------------------------------------------------------

module("TopUpRebate", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

local g_scene = nil 		-- ����
local g_Layer = nil 
local g_personalInfo = nil 
--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��

function setData(currentInfo)
	g_activeTable = currentInfo
end

--
-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()
end
-- �ͷ���Դ
function releaseResource()
	close()
	g_scene = nil 		-- ����
	g_Layer = nil 
	g_personalInfo = nil
	g_activeTable=nil	
end
-- ��������
function init(Scene,fLayer)
	g_scene = Scene
	
	
	-- ��ӱ���
	local layer = CCLayer:create()
	g_Layer = layer
	fLayer:addChild(layer, 0)
	-- ע�ᴥ���¼�
	layer.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHBEGAN, "TopUpRebate.touchBegan")
	layer.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHMOVED, "TopUpRebate.touchMove")
	layer.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHENDED, "TopUpRebate.touchEnd")
	-- list
	local  listSize = SZ(pWinSize.width*0.84,pWinSize.height*0.45)
	g_tListSize = listSize
	g_tList = ScutCxList:node(listSize.height/4,ccc4(24,24,24,0),listSize)
	g_tList:setAnchorPoint(PT(0,0))
	g_tList:setPosition(PT((pWinSize.width - listSize.width)/2,pWinSize.height*0.21))
	layer:addChild(g_tList,1)
	g_tList:setTouchEnabled(true)
	
	----��ֵ�������
	local HeadTitleImg = CCSprite:create(P("title/list_1146.png"))
	layer:addChild(HeadTitleImg,1)
	HeadTitleImg:setAnchorPoint(PT(0.5,0))
	HeadTitleImg:setPosition(PT(pWinSize.width/2,pWinSize.height*0.76))
	
	---�ʻ���Ϣ
	g_personalInfo=PersonalInfo.getPersonalInfo()
	
	--vip��ʾ���
	local VIPRecharge = Language.VIP_YUJU -------VIP�ٳ�ֵ����
	local nowValue =g_personalInfo._VipLv
	local jingshi = g_personalInfo.VipNextCold
	local nextValue = nil 
	local titleRecharge =nil
	local StringY = pWinSize.height*0.21+listSize.height
	if  nowValue == 10   then 
		nextValue = nowValue
		titleRecharge = CCLabelTTF:create(VIPRecharge,FONT_NAME,FONT_DEF_SIZE)
		layer:addChild(titleRecharge,0)
		titleRecharge:setAnchorPoint(PT(0,0))
		titleRecharge:setPosition(PT(pWinSize.width*0.07,StringY))
		
		
		local VipNowImg = CCSprite:create(P("button/vip_10.png"))
		VipNowImg:setAnchorPoint(PT(0,0))
		VipNowImg:setPosition(PT(pWinSize.width*0.07+titleRecharge:getContentSize().width,StringY))
		layer:addChild(VipNowImg,0)
		
		
	elseif  nowValue <10  and  nowValue > 0   then  
		nextValue = nowValue+1		
			----����ǰ��
			 titleRecharge = CCLabelTTF:create(VIPRecharge,FONT_NAME,FONT_DEF_SIZE)
			layer:addChild(titleRecharge,0)
			titleRecharge:setAnchorPoint(PT(0,0))
			titleRecharge:setPosition(PT(pWinSize.width*0.07,StringY))
			local ImgNum = 0 
			local VIPImg_Num = "button/vip_%s.png"
			local VIPImg = ""
			if  nowValue<10 and nowValue>0  then 
			VIPImg = string.format(VIPImg_Num,nowValue) 
			end
			----VIP��������
			local VipNowImg = CCSprite:create(P(VIPImg))
			VipNowImg:setAnchorPoint(PT(0,0))
			VipNowImg:setPosition(PT(pWinSize.width*0.07+titleRecharge:getContentSize().width,StringY))
			layer:addChild(VipNowImg,0)
		
			
			----�ٳ�ֵ����
			local  jingshiStr = string.format(Language.VIP_Str,jingshi)
			local titleNum = CCLabelTTF:create(jingshiStr,FONT_NAME,FONT_DEF_SIZE)
			layer:addChild(titleNum,0)
			titleNum:setAnchorPoint(PT(0,0))
			titleNum:setPosition(PT(VipNowImg:getPosition().x+VipNowImg:getContentSize().width,
			StringY))
			
			
			------��һ��VIp������
			if  nowValue<10 and nowValue>0  then 
			VIPImg = string.format(VIPImg_Num,nextValue) 
			end
			local VipNextImg = CCSprite:create(P(VIPImg))
			VipNextImg:setAnchorPoint(PT(0,0))
			VipNextImg:setPosition(PT(titleNum:getPosition().x+titleNum:getContentSize().width,StringY))
			layer:addChild(VipNextImg,0)
			
	elseif  	nowValue == 0 then 
		nextValue = nowValue+1	
		local titleStr = string.format(Language.VIP_OStr,jingshi)
		titleRecharge = CCLabelTTF:create(titleStr,FONT_NAME,FONT_DEF_SIZE)
		layer:addChild(titleRecharge,0)
		titleRecharge:setAnchorPoint(PT(0,0))
		titleRecharge:setPosition(PT(pWinSize.width*0.07,StringY))
		
		local VipNowImg = CCSprite:create(P("button/vip_1.png"))
		VipNowImg:setAnchorPoint(PT(0,0))
		VipNowImg:setPosition(PT(pWinSize.width*0.07+titleRecharge:getContentSize().width,StringY))
		layer:addChild(VipNowImg,0)
				
	end
	

	
	local titleStr = CCLabelTTF:create(Language.TopUpRebate_TitleStr,FONT_NAME,FONT_DEF_SIZE)
	layer:addChild(titleStr,0)
	titleStr:setAnchorPoint(PT(0,0))
	titleStr:setPosition(PT(pWinSize.width*0.07,StringY + titleStr:getContentSize().height + SY(3)))
	
	local vipButton  = ZyButton:new("button/bottom_1002_2.9.png",nil,nil,Language.TopUpRebate_ButtonStr)
	vipButton:addto(layer,0)
	vipButton:setAnchorPoint(PT(0,0))
	vipButton:setPosition(PT(g_tList:getPosition().x+listSize.width - vipButton:getContentSize().width,
								StringY + titleStr:getContentSize().height + SY(3)))
	vipButton:registerScriptHandler(goVIPFunc)
	
	
	
	showList()
end
function goVIPFunc()
	VIPScene.pushScene(g_scene)
end
function close()
	if  g_Layer   then
		g_Layer:getParent():removeChild(g_Layer,true)
		g_Layer= nil
	end
end
function showList()
	for k,v in ipairs(g_activeTable.RecordTabel) do
		local item = ScutCxListItem:itemWithColor(ccc3(255,255,255))	--25,57,45
		item:setOpacity(0)
		local layout = CxLayout()
		layout.val_x.t = ABS_WITH_PIXEL
		layout.val_y.t = ABS_WITH_PIXEL	
		layout.val_x.val.pixel_val =0
		layout.val_y.val.pixel_val =0
		local listH = g_tList:getRowHeight()
		local listW = pWinSize.width*0.84
		local itemLayer = CCLayer:create()
		
		
		--- list ����
		local listBgImgH = listH*0.9
		local listBgImg = CCSprite:create(P("common/list_1038.9.png"))
		listBgImg:setScaleX(listW/listBgImg:getContentSize().width)
		listBgImg:setScaleY(listBgImgH/listBgImg:getContentSize().height)
		listBgImg:setAnchorPoint(PT(0,0))
		listBgImg:setPosition(PT(0,listH/2 - listBgImgH/2))
		itemLayer:addChild(listBgImg,0)
		

		
		if v.IsReceive == 2 then--0���� 1���� 2������ȡ
			czButton:setEnabled(false)
			czButton:setString(Language.ACTIVE_HAVERECEIVE)
		elseif v.IsReceive == 1 then
			czButton:setString(Language.ACTIVE_BUTTONSTR2)
			czButton:registerScriptHandler(isClickFunc)
		end		
		
		
		local itemStr1 = string.format("<label>%s</label>", v.FestivalDesc)
		local itemStrW = listW*0.7
		local itemStr = ZyMultiLabel:new(itemStr1,itemStrW,FONT_NAME,FONT_SM_SIZE)
		itemStr:addto(itemLayer,0)
		itemStr:setAnchorPoint(PT(0,0))
		itemStr:setPosition(PT(listW*0.05,listH/2 - itemStr:getContentSize().height/2))
									
			
		item:addChildItem(itemLayer,layout)
		g_tList:addListItem(item,false)		
	
	end
end

--��ȡ��ť
function isClickFunc(pNode)
	if not isClick then
		isClick=false	
		local tag = pNode:getTag()
		local FestivalID = g_activeTable.RecordTabel[tag].FestivalID 
		actionLayer.Action3014(g_scene, nil, FestivalID)
	end
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
	local actionID = ZyReader:getActionID()

end