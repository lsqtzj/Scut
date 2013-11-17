------------------------------------------------------------------
-- UpGradeScene.lua.lua
-- Author     : yeyq

-- Version    : 1.0
-- Date       :
-- Description: ����������ȡ
------------------------------------------------------------------

module("UpGradeScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

local g_scene = nil 		-- ����
local g_layer = nil
local g_tList= nil 
local g_tListSize = nil
local g_VipNum = nil 
--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��


function setData(info)
	g_DataInfo = info
end;
--
-------------------------˽�нӿ�------------------------

function close()
	if g_layer then
		g_layer:getParent():removeChild(g_layer, nil)
		g_layer = nil
	end
	releaseResource()
end
--
-- ��ʼ����Դ����Ա����
function initResource()
	g_VipNum = 0
end
-- �ͷ���Դ
function releaseResource()
	g_scene = nil 		-- ����
	g_layer = nil
	g_VipNum= nil
	g_tList= nil 
	g_tListSize = nil
	g_DataInfo=nil
end
-- ��������
function init(Scene,FLayer)
	g_scene = Scene
	initResource()
	-- ��ӱ���
	local layer = CCLayer:create()
	FLayer:addChild(layer,0)
	g_layer = layer

	-- ��������  �����о�ϲ
	local HeadTitleImg = CCSprite:create(P("title/list_1148.png"))
	layer:addChild(HeadTitleImg,0)
	HeadTitleImg:setAnchorPoint(PT(0.5,0))
	HeadTitleImg:setPosition(PT(pWinSize.width/2,pWinSize.height*0.76))
	
	
	----��䣺�װ��Ļ᳤��������Ϸ�дﵽָ���ĵȼ�ʱ������ȡ��ʯ,������VIP����Ŷ
	local UpGradeStrW = pWinSize.width*0.84
	local str = Language.UpGrade_Str1
	if accountInfo.getRetailId() == "0004" then
		str = Language.UpGrade_Str1NOVIP
	end
	local UpGradeStr = ZyMultiLabel:new(str,UpGradeStrW,FONT_NAME,FONT_SM_SIZE)
	UpGradeStr:addto(layer,0)
	UpGradeStr:setAnchorPoint(PT(0,0))
	UpGradeStr:setPosition(PT((pWinSize.width - UpGradeStrW)/2,pWinSize.height*0.76-HeadTitleImg:getContentSize().height))
	

	-- list
	local  listSize = SZ(pWinSize.width*0.84,UpGradeStr:getPosition().y-pWinSize.height*0.21)
	g_tListSize = listSize
	g_tList = ScutCxList:node(listSize.height/5,ccc4(24,24,24,0),listSize)
	g_tList:setAnchorPoint(PT(0,0))
	g_tList:setPosition(PT((pWinSize.width - listSize.width)/2,pWinSize.height*0.21))
	layer:addChild(g_tList,0)
		g_tList:setTouchEnabled(true)
	showList()
end

function delayExec(funName,nDuration)
	local action = CCSequence:createWithTwoActions(
	CCDelayTime:create(nDuration),
	CCCallFunc:create(funName));
	if g_layer then
		g_layer:runAction(action)
	end
end

function showList()
	if not g_DataInfo then
		return
	end

	for k,v in ipairs(g_DataInfo.RecordTabel) do 
			local listItem = ScutCxListItem:itemWithColor(ccc3(255,255,255))	--25,57,45
			listItem:setOpacity(0)
			local layout = CxLayout()
			layout.val_x.t = ABS_WITH_PIXEL
			layout.val_y.t = ABS_WITH_PIXEL	
			layout.val_x.val.pixel_val =0
			layout.val_y.val.pixel_val =0
			
			local item = creatItem(v,k)		

			listItem:addChildItem(item,layout)
			g_tList:addListItem(listItem,false)		
	end
end

function creatItem(info, tag)
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

	
	---�Ǹ��ȼ�����ͼ��
	local LvBgImg = CCSprite:create(P("mainUI/list_1147.png"))
	LvBgImg:setAnchorPoint(PT(0,0))
	LvBgImg:setPosition(PT(SX(15),listH/2-LvBgImg:getContentSize().height/2))
	itemLayer:addChild(LvBgImg,0)
	-- �ȼ�
	local nowLV = info.RestrainNum 
	local lvNum = CCLabelTTF:create(nowLV,FONT_NAME,FONT_DEF_SIZE)
	LvBgImg:addChild(lvNum,0)
	lvNum:setAnchorPoint(PT(0.5,0.5))
	lvNum:setPosition(PT(LvBgImg:getContentSize().width/2,LvBgImg:getContentSize().height*0.6))
	
	local itemStr1 = string.format("<label>%s</label>", info.FestivalDesc)
	local itemStrW = listW*0.56
	local itemStr = ZyMultiLabel:new(itemStr1,itemStrW,FONT_NAME,FONT_SM_SIZE)
	itemStr:addto(itemLayer,0)
	itemStr:setAnchorPoint(PT(0,0))
	itemStr:setPosition(PT(LvBgImg:getPosition().y+LvBgImg:getContentSize().width+SX(15)
									,listH/2 - itemStr:getContentSize().height/2))
									

		----��ֵ��ť
		local czButton  = ZyButton:new("button/list_1039.png","button/list_1039.png","button/list_1039_1.png",Language.UpGrade_ButtonStr)
		czButton:addto(itemLayer,0)
		czButton:setAnchorPoint(PT(0,0))
		czButton:setPosition(PT(listW - czButton:getContentSize().width - SX(15)
								,listH/2-czButton:getContentSize().height/2))
		czButton:registerScriptHandler(isClickFunc)
		czButton:setTag(tag)
		czButton:setEnabled(false)
		if info.IsReceive == 0 or info.IsReceive == 2 then--0���� 1���� 2������ȡ
			if info.IsReceive == 2 then
				czButton:setString(Language.ACTIVE_HAVERECEIVE)
			end
		elseif info.IsReceive == 1 then
			czButton:setEnabled(true)
		end

	return itemLayer
end

function closeLayer()
	if g_layer then
		g_layer:getParent():removeChild(g_layer,true)
	end
end

--��ȡ��ť
function isClickFunc(pNode)
	if not isClick then
		isClick=false	
		local tag = pNode:getTag()
		local FestivalID = g_DataInfo.RecordTabel[tag].FestivalID 
		actionLayer.Action3014(g_scene, nil, FestivalID)
	end
end

function setIsClick(value)
	isClick=value	
end


-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionID = NdReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
end