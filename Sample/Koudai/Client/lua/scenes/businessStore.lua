------------------------------------------------------------------
-- businessStore.lua.lua
-- Author     : WangTong
-- Version    : 1.0
-- Date       :
-- Description: 
------------------------------------------------------------------

module("businessStore", package.seeall)
require("layers.HotalLayer")



-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

_scene = nil 		-- ����
mCurrentTab = 1  ----��ǰ��ť�ı��
pageTable = {}
goodsTable = {}
numberAge = "1" 
list = nil
imageFile = nil 
goodsId = nil
indexClick = nil  ------- ��ǰ�����ҳ��
czLayer = nil 
mValue = nil   --------��Ʒ�۸�
buttonRightTo = nil
gapLayer = nil 
--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��

-- �������
local mScene=nil;

MenuId = {
	eJiuGuang = 1,
	eDaoJu = 2,
	eLiBao = 3,
}

tabName = {
	[MenuId.eJiuGuang] = Language.SHOP_HOTAL,
	[MenuId.eDaoJu] = Language.SHOP_PROP,
	[MenuId.eLiBao] = Language.SHOP_GIFTBAG,
}

function pushScene()
	initResource()
	createScene()
end


--
-------------------------˽�нӿ�---------------5---------
--
-- ��ʼ����Դ����Ա����
function initResource()
	_scene = nil 		-- ����
mCurrentTab = 1  ----��ǰ��ť�ı��
pageTable = {}
goodsTable = {}
numberAge = "1" 
list = nil
imageFile = nil 
goodsId = nil
indexClick = nil  ------- ��ǰ�����ҳ��
czLayer = nil 
mValue = nil   --------��Ʒ�۸�
gapLayer = nil 
local mScene=nil;

MenuId = {
	eJiuGuang = 1,
	eDaoJu = 2,
	eLiBao = 3,
}
buttonLeft = nil
tabName = {
	[MenuId.eJiuGuang] = Language.SHOP_HOTAL,
	[MenuId.eDaoJu] = Language.SHOP_PROP,
	[MenuId.eLiBao] = Language.SHOP_GIFTBAG,
}

end

function close()
	closeAllLayer()
	if layerBG then
		layerBG:getParent():removeChild(layerBG,true)
		layerBG = nil
	end
end;


-- �ͷ���Դ
function releaseResource()
	HotalLayer.releaseResource()
	layerBG=nil
	gapLayer=nil
	
	_scene = nil 		-- ����
	mCurrentTab = nil  ----��ǰ��ť�ı��
	pageTable = nil
	goodsTable = nil
	numberAge = nil
	list = nil
	imageFile = nil 
	goodsId = nil
	indexClick = nil  ------- ��ǰ�����ҳ��
	czLayer = nil 
	mValue = nil   --------��Ʒ�۸�
	
	
	MenuId = nil
	tabName =nil
buttonLeft = nil 
end

function  closeAllLayer()
	if  gapLayer  then
		gapLayer:getParent():removeChild(gapLayer,true)
		gapLayer = nil 		
	end
	HotalLayer.close()
	GuideLayer.close()
end;
-- ��������
function createScene()
	local scene  = ScutScene:new()
	-- ע������ص�
	scene:registerCallback(networkCallback)
	_scene = scene.root 
	_scene:registerScriptHandler(SpriteEase_onEnterOrExit)
	SlideInLReplaceScene(_scene,1)
	
	
	-- ��ӱ���
	 layerBG = CCLayer:create()
	_scene:addChild(layerBG, 0)
	
	
	-- ע�ᴥ���¼�
--	layerBG.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHBEGAN, "businessStore.touchBegan")
--	layerBG.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHMOVED, "businessStore.touchMove")
--	layerBG.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHENDED, "businessStore.touchEnd")
	if  not mCurrentTab then
			mCurrentTab=MenuId.eJiuGuang
			
	end
	
	-- �˴���ӳ�����ʼ����
	--��������
	---

	local bglayerY = pWinSize.height*0.145
	local bglayerPY = pWinSize.height*0.68
	local bglayer =  CCSprite:create(P("common/list_1040.png"))
	bglayer:setScaleX(pWinSize.width/bglayer:getContentSize().width)
	bglayer:setScaleY(bglayerPY/bglayer:getContentSize().height)
	layerBG:addChild(bglayer,0)
	bglayer:setAnchorPoint(PT(0,0))
	bglayer:setPosition(PT(0,bglayerY))
	


	
	local czImg = "title/list_1110.png"
	local czImgString= CCSprite:create(P(czImg))

	--��ֵ����
	local czImgString= CCSprite:create(P( "title/list_1110.png"))

	layerBG:addChild(czImgString,0)
	--czImgString:setScaleX(czButton:getContentSize().width*0.7/czImgString:getContentSize().width)
	--czImgString:setScaleY(czButton:getContentSize().height*0.7/czImgString:getContentSize().height)
	czImgString:setAnchorPoint(PT(0,0))
	czImgString:setPosition(PT(pWinSize.width*0.825,bglayer:getPosition().y+bglayerPY-SY(16)))
	
	---list
	listSize = SZ(pWinSize.width,pWinSize.height*0.53)
	list = ScutCxList:node(listSize.height*0.35,ccc4(24,24,24,0),listSize)
	list:setAnchorPoint(PT(0,0))
	list:setPosition(PT((pWinSize.width-listSize.width)/2,pWinSize.height*0.24))
	layerBG:addChild(list,0)
    list:setTouchEnabled(true)
	----�ƹݵ��������ЧӦ��ť���
	local tabBar=ZyTabBar:new(nil,nil,tabName,FONT_NAME,FONT_SM_SIZE,3)
	mTabBar=tabBar
	tabBar:addto(layerBG,2)
	tabBar:setColor(ZyColor:colorYellow())
	tabBar:setAnchorPoint(PT(0,0))
	tabBar:selectItem(mCurrentTab);				--����ĸ���ť
	tabBar:setCallbackFun(callbackTabBar);		--�����Ӧ���¼�
	tabBar:setPosition(PT(SX(21),bglayer:getPosition().y+bglayerPY-SY(16)))

	MainMenuLayer.init(1, _scene)
	
	showLayer()
end


function SpriteEase_onEnterOrExit (tag)
    if tag == "exit" then
        releaseResource()
    end
end
function callbackTabBar(bar,pNode)---- ������ť
	local index=pNode:getTag(); ----��ť�ı��
	if index~=mCurrentTab then
	    mCurrentTab = index; 
	    showLayer()
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
--tab�л�����
function showLayer(item)
	local next = nil
	local index = mCurrentTab
	if next ~= mCurrentTab and item ~=nil  then 
		next = item:getTag()
		index = next
	end 
	closeAllLayer()
	
	if  index == MenuId.eDaoJu then
		indexClick = 1
		list:clear();
		 
		actionLayer.Action7001(_scene,nil,1,1,15);
	elseif index==MenuId.eLiBao then
		indexClick = 2
		list:clear();
		actionLayer.Action7001(_scene,nil,2,1,15); ---- 
	elseif index==MenuId.eJiuGuang then
		list:clear();
		HotalLayer.init(_scene, layerBG)
	end
end

----չʾ�̳�ͨ�ý���
function showShop()
	for  i=1,#goodsTable do
		local item = ScutCxListItem:itemWithColor(ccc3(25,57,45))	
		item:setOpacity(0)
		local layout = CxLayout()
		layout.val_x.t = ABS_WITH_PIXEL
		layout.val_y.t = ABS_WITH_PIXEL	
		layout.val_x.val.pixel_val =0
		layout.val_y.val.pixel_val =0
		
		
		local itemLayer = CCLayer:create()
		item:addChildItem(itemLayer,layout)
		list:addListItem(item,false)
		local listHeight =  list:getRowHeight()
		
		----�󱳾�ͼƬ�Ĵ�С setPosition()
		local backgroundImgX = listSize.width*0.86
		local backgroundImgY  = listSize.height*0.35*0.98
		local backgroundImgPX = (listSize.width-backgroundImgX)/2
		local backgroundImgPY =  0
		
		----ͷ��ĳ���
		local  headX = listSize.width*0.16
		
		
		--�󱳾�ͼƬ
		local backgroundImg=CCSprite:create(P("common/list_1038.9.png"))
		backgroundImg:setAnchorPoint(PT(0,0))
		backgroundImg:setScaleX(backgroundImgX/backgroundImg:getContentSize().width)
		backgroundImg:setScaleY(backgroundImgY/backgroundImg:getContentSize().height)
		backgroundImg:setPosition(PT(backgroundImgPX,backgroundImgPY))
		itemLayer:addChild(backgroundImg,0)
		
		
		----  ͷ�񱳾��߿�
		local headBgImg=CCSprite:create(P(Image.Image_normalItemBg))
		headBgImg:setAnchorPoint(PT(0,0.5))
		headBgImg:setPosition(PT(backgroundImgPX+SY(3),backgroundImgY*0.65))
		itemLayer:addChild(headBgImg,0)
	

		local goodsHead = goodsTable[i].HeadID    ----- ͼƬ
		local image= string.format("smallitem/%s.png",goodsHead)
		local headImg = CCSprite:create(P(image));
		headImg:setAnchorPoint(PT(0,0.5))
		headImg:setPosition(PT(backgroundImgPX+SY(5),backgroundImgY*0.65))
		itemLayer:addChild(headImg,0)
			 -----����
		local playName = goodsTable[i].ItemName   
		local playName  = CCLabelTTF:create(playName,FONT_NAME,FONT_SM_SIZE)
		itemLayer:addChild(playName,0)
		playName:setAnchorPoint(PT(0,0.5))
		playName:setPosition(PT(headImg:getPosition().x+headX+SY(8),backgroundImgY*0.85))
		
		
		-------��Ʒ����
		local playQualiy = goodsTable[i].ItemDescribe  
		local toString = "<label color='%s'>%s</label>"
		local to = "255,255,255"
		local playQualiyTo = string.format(toString,to,playQualiy)
		local  showWidth =  item:getContentSize().width*0.6
		local playLabel = ZyMultiLabel:new(playQualiyTo,showWidth,FONT_NAME,FONT_SM_SIZE,nil,nil)
		local RowHeight=playLabel:getContentSize().height
		playLabel:setAnchorPoint(PT(0,0))
		playLabel:setPosition(PT(playName:getPosition().x,listHeight*0.8-SY(2)-RowHeight))
		playLabel:addto(itemLayer)
		
		----��Ʒ�۸�
		local playPricet  =Language.bgNumber
		local toValue = goodsTable[i].ItemPrice 
		mValue = toValue
		local playPriceTo = string.format(playPricet,toValue)
		local playPrice  = CCLabelTTF:create(playPriceTo,FONT_NAME,FONT_SM_SIZE)
		itemLayer:addChild(playPrice,0)
		playPrice:setAnchorPoint(PT(0,0.5))
		playPrice:setPosition(PT(playName:getPosition().x,playLabel:getPosition().y-SY(15))) 
		---�۸���ͼ��
		local imageBg = CCSprite:create(P("mainUI/list_1006.png"));
		imageBg:setAnchorPoint(PT(0,0.5))
		imageBg:setPosition(PT(playName:getPosition().x+playPrice:getContentSize().width+SY(3),
								playPrice:getPosition().y))
		itemLayer:addChild(imageBg,0)
		
		---�ؼ�  
		 local toTeJia = goodsTable[i].SpecialPrice 
		if  toTeJia ~= nil  and toTeJia ~= 0 then
			mValue = toTeJia
			local goodsTeJia  =Language.tobe
			local goodsValue = string.format(goodsTeJia,toTeJia)
			local itemTxt5  = CCLabelTTF:create(goodsValue,FONT_NAME,FONT_SM_SIZE)
			itemLayer:addChild(itemTxt5,0)
			itemTxt5:setAnchorPoint(PT(0,0.5))
			itemTxt5:setPosition(PT(playName:getPosition().x,playPrice:getPosition().y-SY(15))) 
			
			local imageBg = CCSprite:create(P("mainUI/list_1006.png"));
			imageBg:setAnchorPoint(PT(0,0.5))
			imageBg:setPosition(PT(playName:getPosition().x+itemTxt5:getContentSize().width+SY(3),
									itemTxt5:getPosition().y))
			itemLayer:addChild(imageBg,0)
		end
		
		----����ť
		local string = Language.Shopping
		buyButton=ZyButton:new("button/list_1039.png",nil,nil,string,FONT_NAME,FONT_SM_SIZE)
		buyButton:setAnchorPoint(PT(0,0))
		buyButton:setPosition(PT(item:getContentSize().width*0.85-buyButton:getContentSize().width,listHeight*0.8*0.15))
		buyButton:setTag(i)
		buyButton:addto(itemLayer,0)
		buyButton:registerScriptHandler(onclickButton)
	end
	if  #goodsTable <=0  then
			gapLayer = CCLayer:create()
			layerBG:addChild(gapLayer,0)
			local str = Language.Business_KONGBAI
			local   gapStr = CCLabelTTF:create(str,FONT_NAME,FONT_SM_SIZE)
			gapLayer:addChild(gapStr,0)
			gapStr:setAnchorPoint(PT(0.5,0))
			gapStr:setPosition(PT(pWinSize.width*0.5,pWinSize.height*0.5)) 
	end
end


function onclickButton(item)----- ��������

	local tag  = item:getTag()
	local name =  goodsTable[tag].ItemName  
	
	goodsId =  goodsTable[tag].ItemID 
	local  toValue = goodsTable[tag].ItemPrice 
	 local toTeJia = goodsTable[tag].SpecialPrice 
	 mValue = toValue
	 if  toTeJia ~=0     then 
	 	mValue = toTeJia
	 end
	
	ButtonLayer =  CCLayer:create()
	layerBG:addChild(ButtonLayer,4)
	ButtonLayer:setAnchorPoint(PT(0,0))
	ButtonLayer:setPosition(PT(0,0))
	
	local touming=ZyButton:new(Image.image_toumingPath,Image.image_toumingPath,Image.image_toumingPath);
	touming:setAnchorPoint(PT(0,0))
	touming:setPosition(PT(0,0))
	touming:setScaleX(pWinSize.width/touming:getContentSize().width)
	touming:setScaleY(pWinSize.height/touming:getContentSize().height)
	touming:addto(ButtonLayer,0)

					
	local buyBigImg = CCSprite:create(P("common/list_1054.png"));
	local scale = pWinSize.width/buyBigImg:getContentSize().width
	buyBigImg:setScale(scale)
	buyBigImg:setAnchorPoint(PT(0,0))
	buyBigImg:setPosition(PT(0,pWinSize.height*0.5-buyBigImg:getContentSize().height*0.5*scale))
	ButtonLayer:addChild(buyBigImg,0)  
	
	local imageFile =   "mainUI/list_1022_2.png"							
	local buyBigBaseImg = CCSprite:create(P(imageFile));
	buyBigBaseImg:setAnchorPoint(PT(0,0))
	buyBigBaseImg:setScaleX(pWinSize.width/buyBigBaseImg:getContentSize().width)
	buyBigBaseImg:setPosition(PT(0,buyBigImg:getPosition().y))
	ButtonLayer:addChild(buyBigBaseImg,0)  
	
	---�м�͸��ͼƬ
	local imageFile =   "common/list_1052.9.png"							
	local buyBigBetweenImg = CCSprite:create(P(imageFile));
	buyBigBetweenImg:setScaleY(buyBigImg:getContentSize().height*scale*0.7/buyBigBetweenImg:getContentSize().height)
	buyBigBetweenImg:setAnchorPoint(PT(0,0))
	buyBigBetweenImg:setPosition(PT((pWinSize.width-buyBigBetweenImg:getContentSize().width)/2,
					buyBigImg:getPosition().y+buyBigImg:getContentSize().height*0.1*scale))
	ButtonLayer:addChild(buyBigBetweenImg,0)  
	
	

	
	addWenzi()
	
	local goodsString_1 = string.format(Language.goodsString,name)
	local titleRecharge = CCLabelTTF:create(goodsString_1,FONT_NAME,FONT_SM_SIZE)
	titleRecharge:setColor(ccc3(255,255,255))
	ButtonLayer:addChild(titleRecharge,1)
	titleRecharge:setAnchorPoint(PT(0.5,0.5))
	titleRecharge:setPosition(PT(pWinSize.width*0.5,
				buyBigBetweenImg:getPosition().y+buyBigImg:getContentSize().height*scale*0.6))
	
	
	wenziTo()

	
	local touming1=ZyButton:new("button/list_1039.png",nil,nil,Language.CloseButton,FONT_NAME,FONT_SM_SIZE);
	touming1:addto(ButtonLayer,100)
	touming1:setAnchorPoint(PT(0.5,0))
	touming1:setPosition(PT(pWinSize.width*0.5-SX(100),pWinSize.height*0.35))
	touming1:registerScriptHandler(closeButton)

	local touming2=ZyButton:new("button/list_1039.png",nil,nil,Language.QueDingButton,FONT_NAME,FONT_SM_SIZE);
	touming2:addto(ButtonLayer,100)
	touming2:setAnchorPoint(PT(0.5,0))
	touming2:setPosition(PT(pWinSize.width*0.5+SX(100),pWinSize.height*0.35))
	touming2:registerScriptHandler(QuedingButton)   
	
end
function sumValue() 
	local item = mValue
	local  toto = numberAge*item
	local much = string.format(Language.Sum, toto)
	return much
end
function wenziTo()   ---- �ܼ۶���
	sum = sumValue()
	
	titleRecharge2 = CCLabelTTF:create(sum,FONT_NAME,FONT_SM_SIZE)
	titleRecharge2:setColor(ccc3(255,255,255))
	ButtonLayer:addChild(titleRecharge2,1)
	titleRecharge2:setAnchorPoint(PT(0.5,0))
	titleRecharge2:setPosition(PT(pWinSize.width*0.5,pWinSize.height*0.42))
end

function addWenzi(posY)

	local pos_y = pWinSize.height*0.5
	
	local imageFile =   "common/list_1049.png"							----��ɫͼƬ
	local requestBg = CCSprite:create(P(imageFile));
	requestBg:setScaleX(pWinSize.width*0.25/requestBg:getContentSize().width)
	requestBg:setAnchorPoint(PT(0.5,0.5))
	requestBg:setPosition(PT(pWinSize.width*0.5,pos_y))
	ButtonLayer:addChild(requestBg,1) 	
	
	numberAge1= CCLabelTTF:create(numberAge,FONT_NAME,FONT_SM_SIZE)
	ButtonLayer:addChild(numberAge1,1)
	numberAge1:setColor(ccc3(0,0,0))
	numberAge1:setAnchorPoint(PT(0.5,0.5))
	numberAge1:setPosition(PT(pWinSize.width*0.5, pos_y))
	
	
 	
	
	local buttonLImg = "button/list_1069.png"
	local buttonRImg = "button/list_1068.png"

	buttonLeft = ZyButton:new(buttonRImg,nil,nil,nil,FONT_NAME,FONT_SM_SIZE);
	buttonLeft:addto(ButtonLayer,2)
	buttonLeft:setTag(1)
	buttonLeft:setAnchorPoint(PT(0.5,0.5))
	buttonLeft:setPosition(PT(pWinSize.width*0.5+SX(100), pos_y))
	buttonLeft:registerScriptHandler(UpdateAdd)
	buttonLeft:setVisible(true)
	
	buttonRight = ZyButton:new(buttonLImg,nil,nil,nil,FONT_NAME,FONT_SM_SIZE);
	buttonRight:addto(ButtonLayer,2)
	buttonRight:setTag(1)
	buttonRight:setAnchorPoint(PT(0.5,0.5))
	buttonRight:setPosition(PT(pWinSize.width*0.5-SX(100), pos_y))
	buttonRight:registerScriptHandler(UpdateReduce)
	buttonRight:setVisible(false)
	

	
end


------��������
function UpdateAdd(item)
	local addTo = item:getTag()
	numberAge = numberAge+addTo
	if  tonumber(numberAge) >1     then
		buttonRight:setVisible(true)
	end
	if tonumber(numberAge) > 98 then 
		buttonLeft:setVisible(false)
	end
	sum = sumValue()	
	titleRecharge2:setString(sum)
	numberAge1:setString(numberAge)
end
function UpdateReduce(item)
	local reduceTo = item:getTag()
	numberAge = numberAge-reduceTo
	if  numberAge <= 0  then 
		numberAge =1
	end
	if tonumber(numberAge)<=1 then
		buttonRight:setVisible(false)
	end;
	if tonumber(numberAge)<=99 then 
		buttonLeft:setVisible(true)
	end
	sum = sumValue()
	titleRecharge2:setString(sum)
	numberAge1:setString(numberAge)
end;
	


function closeButton()  ------  ȡ������
		ButtonLayer:getParent():removeChild(ButtonLayer,true)
		ButtonLayer = nil
		numberAge = 1		
end
function QuedingButton()  ---- ȷ�Ͻ���
	
	actionLayer.Action7004(_scene,nil,goodsId,indexClick,numberAge)
end
-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionId = ZyReader:getActionID()
	if actionId==7001 then--��ȡ�б�
		local serverInfo=actionLayer._7001Callback(pScutScene, lpExternalData) ----���������������
		if serverInfo~=nil then
			local  servertable  = serverInfo.RecordTabel
			goodsTable = servertable
			showShop()
				
		end
	elseif actionId == 7004 then-- ���򷵻�
		 if ZyReader:getResult() == eScutNetSuccess then
		 		
		 	ButtonLayer:getParent():removeChild(ButtonLayer,true)
		 		numberAge = 1
		
				MainMenuLayer.refreshWin()
		 		ZyToast.show(pScutScene,Language.Shoped,0.8,0.03)
		 elseif 	ZyReader:getResult() == 3 then 
		

		 else 
		 	ZyToast.show(pScutScene,ZyReader:readErrorMsg(),0.8,1)
		 end
	elseif actionId == 7009 then  ----------��Ʒ����ӿ�
		local nResult = ZyReader:_7009getResult()
		isClick = false
		if nResult==0 or nResult == 2 then
			mMagicColdTime = 0
		elseif nResult == 1 then 
			local box = ZyMessageBoxEx:new()
			box:doQuery(mLayer,Language.TIP_TIP,ZyReader:readErrorMs(),Language.TIP_YES,Language.TIP_NO,coldButtonMessageBoxAction)
		else
			ZyToast.show(pScutScene,ZyReader:readErrorMsg(),3,0.35)
		end
	end
	
	if actionId == 1402 or actionId == 1404 then
		HotalLayer.networkCallback(pScutScene, lpExternalData)
	end
	
	commonCallback.networkCallback(pScutScene, lpExternalData)
end