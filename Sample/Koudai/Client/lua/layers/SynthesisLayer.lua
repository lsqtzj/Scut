--
-- SynthesisLayer.lua
-- Author     : JunMing Chen
-- Version    : 1.1.0.0
-- Date       : 2013-3-8
-- Description:�ϳ�ϵͳ
--

module("SynthesisLayer", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

local mScene = nil 		-- ����
local mLayer = nil 		
local mCurrentTab=nil
local mItemID=nil
local mData=nil
--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��


-- �˳�����
function closeLayer()
	if mLayer then
		mLayer:getParent():removeChild(mLayer,true)
		mLayer=nil
	end
	releaseResource()
end


function setItemID(value, equipId)
	mItemID=value
	mEquipItemID = equipId
end;
function setDataInfo(value, bgType)
	mData=value
	mBgType = bgType
end;

-- ������� -- ��������
function init(scene)
	if mScene then
		return
	end
	mScene = scene
	-- ��ӱ���
	mLayer =CCLayer:create()
	mScene:addChild(mLayer, 0)

			mScene:registerScriptHandler(SpriteEase_onEnterOrExit)
	
	-----------------
	local bgSprite=CCSprite:create(P("common/list_1024.png"))
	local boxSize=SZ(pWinSize.width,pWinSize.height*0.855)
	bgSprite:setScaleX(boxSize.width/bgSprite:getContentSize().width)
	bgSprite:setScaleY(boxSize.height/bgSprite:getContentSize().height)
	bgSprite:setAnchorPoint(PT(0.5,0))
	bgSprite:setPosition(PT(pWinSize.width/2,pWinSize.height*0.145))
	mLayer:addChild(bgSprite,0)
	local startX=pWinSize.width*0.05
	--����
	for k=1 ,2 do
		local pingBiBtn=UIHelper.createActionRect(boxSize)
		pingBiBtn:setPosition(PT(0,bgSprite:getPosition().y))
		mLayer:addChild(pingBiBtn,0)
	end
	
	--����
	--local titleLabel=CCLabelTTF:create(Language.PROP_TITLE,FONT_NAME,FONT_BIG_SIZE)
	local titleLabel=CCSprite:create(P("title/list_1114.png"))
	titleLabel:setAnchorPoint(PT(0.5,0))
	titleLabel:setPosition(PT(pWinSize.width/2,
						pWinSize.height*0.965-titleLabel:getContentSize().height))
	mLayer:addChild(titleLabel,0)
	-- �رհ�ť
	local closeBtn=ZyButton:new("button/list_1046.png")
	closeBtn:setAnchorPoint(PT(0,0))
	closeBtn:setPosition(PT(pWinSize.width-closeBtn:getContentSize().width*1.2,
							pWinSize.height-closeBtn:getContentSize().height*1.2))
	closeBtn:addto(mLayer,0)
	closeBtn:registerScriptHandler(closeLayer)
	

	----------------------------------���������̶�λ��

	local midSize=SZ(pWinSize.width*0.925,boxSize.height*0.8)
	local midSprite=CCSprite:create(P("common/list_1038.9.png"))
	midSprite:setScaleX(midSize.width/midSprite:getContentSize().width)
	midSprite:setScaleY(midSize.height/midSprite:getContentSize().height)
	midSprite:setAnchorPoint(PT(0.5,0))
	local startY=bgSprite:getPosition().y+pWinSize.height*0.073
	midSprite:setPosition(PT(pWinSize.width/2, startY))
	mLayer:addChild(midSprite,0)
	
	---
	local midBgSprite=CCSprite:create(P("common/list_1084.png"))
	startY=midSprite:getPosition().y+midSize.height*0.95
	local midBgSize=SZ(midBgSprite:getContentSize().width*1.3,pWinSize.height)
	local colW=midBgSize.width/3
	local rowH=boxSize.height*0.65/7
	local startX=(pWinSize.width-midBgSize.width)/2+colW/2
	local startY=startY-rowH/2
	local posTable={2,4,6,10,12,14}
	local mBgTecture=IMAGE(Image.Image_normalItemBg)
	local mateTable=mData.RecordTabel2
	for k, v in ipairs(posTable) do
		--��ƷͼƬ
		if mateTable[k] then
			local goodBg=createItem(mBgTecture,mateTable[k].HeadID,mateTable[k].MaterialsName
								,mateTable[k].CurNum,mateTable[k].MaxNum)
			local posX=startX+((v-1)%3)*colW
			local posY=startY-math.floor((v-1)/3)*rowH
			goodBg:setPosition(PT(posX,posY))
			mLayer:addChild(goodBg,1)
		end
	end
	
	------------------------�ϳɵ���Ʒλ��  �м�λ��
	local itemSprite=createItem(mBgTecture,mData.HeadID,mData.ItemName)
	local posX=startX+((8-1)%3)*colW
	local posY=startY-math.floor((8-1)/3)*rowH
	itemSprite:setPosition(PT(posX,posY))
	mLayer:addChild(itemSprite,1)
	---
	midBgSprite:setAnchorPoint(PT(0.5,0.5))
	midBgSprite:setPosition(PT(itemSprite:getPosition().x,
								itemSprite:getPosition().y))
	mLayer:addChild(midBgSprite,0)
	
	-----------------------�ϳ�Ԥ��
	startY=midSprite:getPosition().y+SY(2)
	local tipSize=SZ(pWinSize.width,pWinSize.height*0.18)
	local tipBg=CCSprite:create(P("common/list_1052.9.png"))
	tipBg:setScaleY(tipSize.height/tipBg:getContentSize().height)	
	tipBg:setAnchorPoint(PT(0.5,0))
	tipBg:setPosition(PT(pWinSize.width/2,startY))
	mLayer:addChild(tipBg,0)
	startX=pWinSize.width/2-tipBg:getContentSize().width*0.48
	startY=startY-SY(2)+tipSize.height
	local rowH=tipSize.height/6
	local tipLabel=CCLabelTTF:create(Language.PROP_TIP..":",FONT_NAME,FONT_SM_SIZE)
	tipLabel:setAnchorPoint(PT(0,0))
	tipLabel:setPosition(PT(startX,
							startY-rowH))
	mLayer:addChild(tipLabel,0)
	--------�ϳɵ���Ʒ���� 
	local nameLabel=CCLabelTTF:create(Language.PROP_NAME ..":" .. mData.ItemName,
								FONT_NAME,FONT_SM_SIZE)
	nameLabel:setAnchorPoint(PT(0,0))
	nameLabel:setPosition(PT(tipLabel:getPosition().x,
							tipLabel:getPosition().y-rowH))
	mLayer:addChild(nameLabel,0)
	----��õ����� 
	local charLabel=CCLabelTTF:create(Language.PROP_CHARTER ..":",
								FONT_NAME,FONT_SM_SIZE)
	charLabel:setAnchorPoint(PT(0,0))
	charLabel:setPosition(PT(nameLabel:getPosition().x,
							nameLabel:getPosition().y-rowH))
	mLayer:addChild(charLabel,0)
	local startX=nameLabel:getPosition().x+charLabel:getContentSize().width+SX(2)
	local startY=charLabel:getPosition().y
	local colW=boxSize.width*0.3
	if mData.RecordTabel and #mData.RecordTabel>0 then
	for k, v in pairs(mData.RecordTabel) do
		local str=(Language.BAG_TYPE_[v.AbilityType] or "") .. "+" .. v.BaseNum	
		local label=CCLabelTTF:create(str,FONT_NAME,FONT_SM_SIZE)
		label:setAnchorPoint(PT(0,0))
		local posX=startX+colW*((k-1)%2)
		local posY=startY-rowH*math.floor((k-1)/2)
		label:setPosition(PT(posX,posY))
		mLayer:addChild(label,0)	
	end
	else
		local noneLabel=CCLabelTTF:create(Language.IDS_NONE,
									FONT_NAME,FONT_SM_SIZE)
		noneLabel:setAnchorPoint(PT(0,0))
		noneLabel:setPosition(PT(charLabel:getPosition().x+charLabel:getContentSize().width,
								charLabel:getPosition().y))
		mLayer:addChild(noneLabel,0)								
	end
	
--���İ�ť
	startY=charLabel:getPosition().y-math.floor(#mData.RecordTabel/2)*rowH
	local makeBtn=ZyButton:new("button/list_1039.png",nil,nil,Language.PROP_MAKE	)
	makeBtn:setAnchorPoint(PT(0,0))
	makeBtn:setPosition(PT(pWinSize.width/2-makeBtn:getContentSize().width/2,
							tipBg:getPosition().y+SY(2)))
	makeBtn:addto(mLayer,0)
	makeBtn:registerScriptHandler(makeAction)
end

function SpriteEase_onEnterOrExit (tag)
    if tag == "exit" then
        releaseResource()
    end
end


--����
function makeAction()
	if not isClick then
		isClick=true
		sendAction(1603, 1)--1����ͨ�ϳ�
	end
end;

function jingshiMake(clickedButtonIndex, content, tag)
	if clickedButtonIndex == 1 then
		sendAction(1603, 2)--2����ʯ�ϳ�
	end
end

function AskIsMake(clickedButtonIndex, content, tag)
	if clickedButtonIndex == 1 then
		sendAction(1603, 3)--3��ȷ�Ͼ�ʯ�ϳ�
	end
end;


function sendAction(actionId, ops)
	if actionId == 1603 then
		local ItemID = nil--����ID
		local UserItemID = nil--Ӷ������װ��ID
		if mEquipItemID then
			UserItemID = mEquipItemID
		else
		 	ItemID = mItemID
		end
		actionLayer.Action1603(mScene,nil,ItemID,UserItemID,ops)--   ops 1����ͨ�ϳ�2����ʯ�ϳ�3��ȷ�Ͼ�ʯ�ϳ�
	end
end;

function  createItem(mBgTecture,image,name,curNum ,maxNum)
		local goodBg=CCSprite:createWithTexture(mBgTecture)
		goodBg:setAnchorPoint(PT(0.5,0.5))
		if image then
		local path=string.format("smallitem/%s.png",image)
		local imageSprite=CCSprite:create(P(path))
		imageSprite:setAnchorPoint(PT(0.5,0.5))
		imageSprite:setPosition(PT(goodBg:getContentSize().width/2,
									goodBg:getContentSize().height/2))
		goodBg:addChild(imageSprite,0)	
		local goodName=CCLabelTTF:create(name,FONT_NAME,FONT_SM_SIZE)
		goodName:setAnchorPoint(PT(0.5,1))
		goodName:setPosition(PT(imageSprite:getPosition().x,0))
		goodBg:addChild(goodName,0)
			if curNum then
				local numStr=string.format("%d/%d",curNum,maxNum)
				local numLabel=CCLabelTTF:create(numStr,
								FONT_NAME,FONT_SM_SIZE)
				numLabel:setAnchorPoint(PT(1,0))
				numLabel:setPosition(PT(goodBg:getContentSize().width*0.94,goodBg:getContentSize().height*0.06))
				goodBg:addChild(numLabel,0)
			end
		end
		return goodBg
end;

--
-------------------------˽�нӿ�------------------------


-- ��ʼ����Դ����Ա����
function initResource()

end

-- �ͷ���Դ
function releaseResource()
 	mScene = nil 		-- ����
 	mLayer = nil 	
	mData=nil
	mEquipItemID=nil	
end

---��ʯ���� ��ֵ����
function  czAction(clickedButtonIndex,content,tag)
	if clickedButtonIndex == ID_MBOK then
		TopUpScene.init()
	end
end


-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionID = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	if actionID==1603 then
		if ZyReader:getResult() == eScutNetSuccess then
			closeLayer()
			if mBgType then
				HeroScene.showCreatSuccess()
				HeroScene.refreshWin()
			else
				BagScene.showLayer()
				BagScene.showCreatSuccess()
			end
		elseif ZyReader:getResult() == 1 then--��ʯ���㷵��1	
			local box = ZyMessageBoxEx:new()
			box:doQuery(pScutScene, nil, Language.Business_Str,Language.TIP_YES,Language.TIP_NO,czAction)				
		elseif ZyReader:getResult() == 2 then--ȷ�Ͼ�ʯ����2
				local box = ZyMessageBoxEx:new()
				box:doQuery(pScutScene, nil, ZyReader:readErrorMsg(),Language.IDS_SURE,Language.IDS_CANCEL,AskIsMake)
		elseif  ZyReader:getResult() == 3 then--���ϲ���CODE����3
			if isShowVip() then
				ZyToast.show(pScutScene,Language.PROP_ENOUGH)
			else
				ZyToast.show(pScutScene,Language.PROP_ENOUGHNOVIP)
			end
		else
			ZyToast.show(pScutScene,ZyReader:readErrorMsg())
		end		
	end
	isClick=false
	
end

