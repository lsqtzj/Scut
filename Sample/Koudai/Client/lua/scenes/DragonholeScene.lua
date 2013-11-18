
-- DragonholeScene.lua.lua
-- Author     :Lysong
-- Version    : 1.0.0.0
-- Date       :
-- Description:
------------------------------------------------------------------

module("DragonholeScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

local mScene= nil 
local mLayer=nil
local  mtable={
    	 	{pic="smallitem/icon_3069.png"},
    	 	{pic="smallitem/icon_4010.png"},
    	 	{pic="smallitem/icon_4035.png"},
    	 	{pic="smallitem/icon_4074.png"},
    	 	{pic="smallitem/icon_4089.png"},
    	 	{pic="smallitem/icon_6012.png"},
    	 	{pic="smallitem/icon_8014.png"},
    	 	{pic="smallitem/icon_4109.png"},
    	 }
local index=nil
local type=nil
local list1={}
local list2={}
local mRecordTabel={}
local image=nil
local priceNum=nil
local mClassTable={}
--local position={}
--
---------------���нӿ�(�������������̶����øı�)--------
--

-- ��������Сд��ĸ��ʼ��ÿ��������Ӧע��

function setLayer(scene, layer)
	fatherLayer = layer
	mScene = scene
end;

-- �������
function close()
	 if showLayer ~= nil then
		showLayer:getParent():removeChild(showLayer, true)
		showLayer = nil
	end
	if wenziLayer ~= nil then
		wenziLayer:getParent():removeChild(wenziLayer, true)
		wenziLayer = nil
	end
	if mLayer then
		mLayer:getParent():removeChild(mLayer, true)
		mLayer = nil
	end
	initResource()
end


-- �˳�����
function closeScene()
	releaseResource()
	CCDirector:sharedDirector():popScene()
end

--
-------------------------˽�нӿ�------------------------
--
-- ��ʼ����Դ����Ա����
function initResource()
end

-- �ͷ���Դ
function releaseResource()
	showLayer=nil
	mLayer=nil
	g_getBtn=nil
end
-- ��������
function init()
	
	initResource()
	local layer = CCLayer:create()
	fatherLayer:addChild(layer, 0)
	mLayer= layer
	
	-- �˴���ӳ�����ʼ����                  
	local bg1 = "longxue/map_1012.png"
	local imageBg = CCSprite:create(P(bg1));
	imageBg:setScaleX(pWinSize.width*0.92/imageBg:getContentSize().width)
	imageBg:setScaleY(pWinSize.height*0.7/imageBg:getContentSize().height)
	imageBg:setAnchorPoint(PT(0,0))
	imageBg:setPosition(PT(pWinSize.width*0.04,pWinSize.height*0.2))
	mLayer:addChild(imageBg,0)
	
	local imageBg = CCSprite:create(P("shengjita/list_3016.9.png"));
	imageBg:setScaleX(pWinSize.width/imageBg:getContentSize().width*0.85)
	imageBg:setScaleY(pWinSize.height/imageBg:getContentSize().height*0.15)
	imageBg:setAnchorPoint(PT(0,0))
	imageBg:setPosition(PT(pWinSize.width*0.08,pWinSize.height*0.69))
	mLayer:addChild(imageBg,0)
	
	--����
	local content=string.format("<label>%s</label>",Language.JIESHAO)
	local multiWidth=pWinSize.width*0.75
	local ndMultiLabe=ZyMultiLabel:new(content,multiWidth,FONT_NAME,FONT_SM_SIZE)
	ndMultiLabe:setAnchorPoint(PT(0,1))
--	ndMultiLabe:setPosition(PT((pWinSize.width-ndMultiLabe:getContentSize().width)/2,imageBg:getPosition().y+SY(3)))
	ndMultiLabe:setPosition(PT((pWinSize.width-ndMultiLabe:getContentSize().width)/2,imageBg:getPosition().y+(pWinSize.height*0.15-ndMultiLabe:getContentSize().height)/2))
	ndMultiLabe:addto(mLayer,0)
	
       local str={
       	{name=Language.ZHUANJIA},
       	{name=Language.DASHI},
       	{name=Language.ZONGSHI}
       }
       mClassTable=str
       for  k, v in pairs(str) do
	    	--��ť
--	    	position[k]={}
		 wzbackBtn= ZyButton:new("longxue/list_3034_3.png", "longxue/list_3034_2.png", nil, nil,nil, FONT_SM_SIZE)
		 wzbackBtn:setAnchorPoint(PT(0,0))
		 wzbackBtn:setPosition(PT((pWinSize.width-wzbackBtn:getContentSize().width*3)/2+(k-1)*wzbackBtn:getContentSize().width*1.1,pWinSize.height*0.34))
--		 position[k].x=(pWinSize.width-wzbackBtn:getContentSize().width*3)/2+(k-1)*wzbackBtn:getContentSize().width*1.1
--		 position[k].y
		 wzbackBtn:addto(mLayer,0)
		 wzbackBtn:setTag(k)
		 wzbackBtn:registerScriptHandler(choiceClassAction)
		 v.clickBtn=wzbackBtn
	end
	
	--��Ѩ������
	local titleBg = CCSprite:create(P("longxue/list_3033.png"))
	titleBg:setAnchorPoint(PT(0,0))
	titleBg:setPosition(PT((pWinSize.width-titleBg:getContentSize().width)/2, pWinSize.height*0.63))
	mLayer:addChild(titleBg, 0)
	
	index=5--��õڼ�������ʱ���ɷ�����·�
	
	str[1].clickBtn:selected()
	type=1
	actionLayer.Action12101(mScene,nil,type)
--	showContent()
	wenzi()
end

function wenziceng()
	if wenziLayer ~= nil then
		wenziLayer:getParent():removeChild(wenziLayer, true)
		wenziLayer = nil
	end
end

function wenzi()
	
	if wenziLayer ~= nil then
		wenziLayer:getParent():removeChild(wenziLayer, true)
		wenziLayer = nil
	end
	local layer = CCLayer:create()
	mLayer:addChild(layer, 0)
	wenziLayer = layer
--	local str={
--       	{name=Language.ZHUANJIA},
--       	{name=Language.DASHI},
--       	{name=Language.ZONGSHI}
--       }
--	for  k, v in pairs(str) do
		local qbxiaohao = CCLabelTTF:create(Language.ZHUANJIA,FONT_NAME,FONT_SMM_SIZE)
		local chazhi=(wzbackBtn:getContentSize().width-qbxiaohao:getContentSize().width)/2
		wenziLayer:addChild(qbxiaohao,0)
		qbxiaohao:setAnchorPoint(PT(0,0))
		if type==1 then
		qbxiaohao:setPosition(PT((pWinSize.width-wzbackBtn:getContentSize().width*3)/2+(1-1)*wzbackBtn:getContentSize().width*1.1+SX(5)+chazhi,pWinSize.height*0.34+SY(5)))
		else
		qbxiaohao:setPosition(PT((pWinSize.width-wzbackBtn:getContentSize().width*3)/2+(1-1)*wzbackBtn:getContentSize().width*1.1+chazhi,pWinSize.height*0.34+SY(3)))
		end
--	end
	
	local qbxiaohao = CCLabelTTF:create(Language.DASHI,FONT_NAME,FONT_SMM_SIZE)
	wenziLayer:addChild(qbxiaohao,0)
	qbxiaohao:setAnchorPoint(PT(0,0))
	if type==2 then
	qbxiaohao:setPosition(PT((pWinSize.width-wzbackBtn:getContentSize().width*3)/2+(2-1)*wzbackBtn:getContentSize().width*1.1+SX(5)+chazhi,pWinSize.height*0.34+SY(5)))
	else
	qbxiaohao:setPosition(PT((pWinSize.width-wzbackBtn:getContentSize().width*3)/2+(2-1)*wzbackBtn:getContentSize().width*1.1+chazhi,pWinSize.height*0.34+SY(3)))
	end
	
	local qbxiaohao = CCLabelTTF:create(Language.ZONGSHI,FONT_NAME,FONT_SMM_SIZE)
	wenziLayer:addChild(qbxiaohao,0)
	qbxiaohao:setAnchorPoint(PT(0,0))
	if type==3 then
	qbxiaohao:setPosition(PT((pWinSize.width-wzbackBtn:getContentSize().width*3)/2+(3-1)*wzbackBtn:getContentSize().width*1.1+SX(5)+chazhi,pWinSize.height*0.34+SY(5)))
	else
	qbxiaohao:setPosition(PT((pWinSize.width-wzbackBtn:getContentSize().width*3)/2+(3-1)*wzbackBtn:getContentSize().width*1.1+chazhi,pWinSize.height*0.34+SY(3)))
	end
	
end;

function choiceClassAction(node)
	local tag=node:getTag()
	type=tag
	actionLayer.Action12101(mScene,nil,type)
	for k, v in pairs(mClassTable) do
		if k==tag then
			v.clickBtn:selected()
		else
			v.clickBtn:unselected()
		end
	end
	wenzi()
end;
--[[
function callbackTabBar(bar,pNode)

    local index =pNode:getTag();
    type=index
    actionLayer.Action12101(mScene,nil,type)

end;
--]]
function releseShowLayer()
	if showLayer ~= nil then
		showLayer:getParent():removeChild(showLayer, true)
		showLayer = nil
	end
end

function showContent()
	if showLayer ~= nil then
		showLayer:getParent():removeChild(showLayer, true)
		showLayer = nil
	end
	local layer = CCLayer:create()
	mLayer:addChild(layer, 0)
	showLayer = layer
	
	--����ǰ����ť
	local getBtn=ZyButton:new(Image.image_button_red_c_0, Image.image_button_red_c_1, Image.image_button_hui_c, Language.STARTQUBAO, FONT_NAME, FONT_SM_SIZE)
	getBtn:setAnchorPoint(PT(0,0))
	getBtn:setPosition(PT((pWinSize.width-getBtn:getContentSize().width)/2,pWinSize.height*0.27))
	getBtn:registerScriptHandler(goto)
	getBtn:addto(showLayer, 0)
	
	g_getBtn = getBtn
	
	--����ʣ�����
	local tiaozhan=Language.SHENGYUCISHU..list1.LastNum.."/"..list1.MaxNum
	local challenge = CCLabelTTF:create(tiaozhan,FONT_NAME,FONT_SMM_SIZE)
	showLayer:addChild(challenge,1)
	challenge:setAnchorPoint(PT(0,0))
	challenge:setPosition(PT(pWinSize.width*0.05,pWinSize.height*0.24))
	
	--�����ʱ��
	if list1.ActivityEndTime==nil then
	    list1.ActivityEndTime=""
	end
	local challenge = CCLabelTTF:create(Language.ACTIVEENDTIME..list1.ActivityEndTime,FONT_NAME,FONT_SMM_SIZE)
	showLayer:addChild(challenge,1)
	challenge:setAnchorPoint(PT(0,0))
	challenge:setPosition(PT(pWinSize.width*0.05,pWinSize.height*0.21))
	
	--ȡ������
	local qbxiaohao = CCLabelTTF:create(Language.QUBAOXIAOHAO,FONT_NAME,FONT_SMM_SIZE)
	showLayer:addChild(qbxiaohao,1)
	qbxiaohao:setAnchorPoint(PT(0,0))
	qbxiaohao:setPosition(PT(pWinSize.width*0.36,pWinSize.height*0.21))
	--���ͼ
	if list1.UserType==0 then
		image="mainUI/list_1007.png"
	elseif list1.UserType==1 then
		image="mainUI/list_1006.png"
	end
	local starImg=CCSprite:create(P(image))
	starImg:setAnchorPoint(PT(0,0))
	starImg:setPosition(PT(qbxiaohao:getPosition().x+qbxiaohao:getContentSize().width-SX(5),pWinSize.height*0.2))
	showLayer:addChild(starImg,0)
	--���Ľ��
	local qbxiaohao = CCLabelTTF:create(list1.ExpendNum,FONT_NAME,FONT_SMM_SIZE)
	showLayer:addChild(qbxiaohao,1)
	qbxiaohao:setAnchorPoint(PT(0,0))
	qbxiaohao:setPosition(PT(starImg:getPosition().x+starImg:getContentSize().width,pWinSize.height*0.21))
	
	--����
	local qbxiaohao = CCLabelTTF:create(Language.XIANYOU,FONT_NAME,FONT_SMM_SIZE)
	showLayer:addChild(qbxiaohao,1)
	qbxiaohao:setAnchorPoint(PT(0,0))
	qbxiaohao:setPosition(PT(pWinSize.width*0.66,pWinSize.height*0.21))
	--���ͼ
	local starImg=CCSprite:create(P(image))
	starImg:setAnchorPoint(PT(0,0))
	starImg:setPosition(PT(qbxiaohao:getPosition().x+qbxiaohao:getContentSize().width-SX(5),pWinSize.height*0.2))
	showLayer:addChild(starImg,0)
	--���н��
	local qbxiaohao = CCLabelTTF:create(list1.HaveNum,FONT_NAME,FONT_SMM_SIZE)
	showLayer:addChild(qbxiaohao,1)
	qbxiaohao:setAnchorPoint(PT(0,0))
	qbxiaohao:setPosition(PT(starImg:getPosition().x+starImg:getContentSize().width,pWinSize.height*0.21))
	
	local kuang=CCSprite:create(P("longxue/list_3034_1.png"))
	kuang:setAnchorPoint(PT(0,0))
	kuang:setPosition(PT((pWinSize.width-kuang:getContentSize().width)/2,pWinSize.height*0.37))
	showLayer:addChild(kuang,0)
	
	local boxSize = SZ(pWinSize.width*0.55, pWinSize.height*0.8)
	priceBox = {}
--	for i,v in ipairs(mtable) do
	for i,v in ipairs(mRecordTabel) do
		local image = nil
		image = string.format("smallitem/%s.png", mRecordTabel[i].HeadID)
		local tu=CCSprite:create(P(image))
		local chax=(kuang:getContentSize().width/4-tu:getContentSize().width)/2
		local chay=(kuang:getContentSize().height/2-tu:getContentSize().height)/2
--		image=mRecordTabel[i].HeadID
		local item = createItemButton(image,i)
		posX = kuang:getPosition().x+chax+(i-1)%4*(tu:getContentSize().width+chax*1.5)
--		posX = boxSize.width*0.25+boxSize.width/3*((i-1)%4)
		posY = kuang:getPosition().y+kuang:getContentSize().height+chay-SY(6)-(math.ceil(i/4))*(chay*1.5+tu:getContentSize().height)
--		posY = boxSize.height*0.77-boxSize.height/7*(math.ceil(i/4))
		item:setAnchorPoint(PT(0,0))
		item:setPosition(PT(posX, posY))
		layer:addChild(item, 0)
		
		priceBox[i] = item
	
	end
	
end

function removetm()
    if tmLayer ~= nil then
        tmLayer:getParent():removeChild(tmLayer,true)
        tmLayer = nil
    end
end

function inittm()
    removetm()
    tmLayer=CCLayer:create()
    tmLayer:setAnchorPoint(PT(0,0));
    tmLayer:setPosition(PT(0,0));
    mLayer:addChild(tmLayer,0)
end

function tmceng()

	local posX=pWinSize.width
    	local posY=pWinSize.height
	inittm()
	--͸��
	local touming=ZyButton:new("common/tou_ming.9.png","common/tou_ming.9.png", nil,nil,nil, FONT_SM_SIZE)
	touming:setScaleX(posX/touming:getContentSize().width)
	touming:setScaleY(posY/touming:getContentSize().height)
	touming:setAnchorPoint(PT(0,0))
	touming:setPosition(PT(0,0));
	touming:addto(tmLayer)
	
end

function goto()
	
	if list1.LastNum>0 then
		g_getBtn:setEnabled(false)
		actionLayer.Action12102(mScene,nil,type)
	else
		ZyToast.show(mScene,Language.SHENGYUCISHUBUZU)
	end
--	startAction(index)
end

--�������������ͼƬ
function createItemButton(image,tag)
	-- ����
	
	local bgSprite=CCSprite:create(P(Image.image_zhenfa_beijing))
	
	local imageSprite = CCSprite:create(P(image))
	imageSprite:setAnchorPoint(CCPoint(0.5, 0.5))
	imageSprite:setPosition(PT(bgSprite:getContentSize().width*0.5,bgSprite:getContentSize().height*0.5))
	bgSprite:addChild(imageSprite,0)
	
	return bgSprite
end

function startAction(priceNumF)
	priceNum = priceNumF
	time = 0
	coldTime = 0.05
	

	selectAI()
	tmceng()
end

function selectAI()
	if choiceImage == nil then
		choiceImage = CCSprite:create(P("longxue/list_3035.png"))
		choiceImage:setAnchorPoint(PT(0.5, 0.5))
		showLayer:addChild(choiceImage,0)	        
		choiceNum = 0
	end
	
	if choiceNum == 8 then
		choiceNum = 1
		time = time+1
	else
		choiceNum = choiceNum+1
	end
	
	if time == 3 then
		coldTime = coldTime+0.02
	elseif time == 4 then
		coldTime = coldTime+0.03
	end

	local pos = PT(priceBox[choiceNum]:getPosition().x+priceBox[choiceNum]:getContentSize().width*0.5, priceBox[choiceNum]:getPosition().y+priceBox[choiceNum]:getContentSize().height*0.5)	
	choiceImage:setPosition(PT(pos.x, pos.y))

	if time >= 4 and choiceNum == priceNum then
		delayExec("DragonholeScene.send",0.5)
	else
		delayExec("DragonholeScene.selectAI", coldTime, nil)
	end
end

function removesend()
    if sendLayer ~= nil then
        sendLayer:getParent():removeChild(sendLayer,true)
        sendLayer = nil
    end
end

function initsend()
    removesend()
    sendLayer=CCLayer:create()
    sendLayer:setAnchorPoint(PT(0,0));
    sendLayer:setPosition(PT(0,0));
    mLayer:addChild(sendLayer,0)
end

function send()

	local posX=pWinSize.width
    	local posY=pWinSize.height
	removetm()
	initsend()
	--͸��
	local touming=ZyButton:new("common/list_1020.9.png","common/list_1020.9.png", nil,nil,nil, FONT_SM_SIZE)
	touming:setScaleX(posX/touming:getContentSize().width)
	touming:setScaleY(posY/touming:getContentSize().height)
	touming:setAnchorPoint(PT(0,0))
	touming:setPosition(PT(0,0));
	touming:addto(sendLayer)
	
	local background= CCSprite:create(P("common/List_2008.9.png"));
	background:setScaleX(posX/background:getContentSize().width*0.4)
	background:setScaleY(posY/background:getContentSize().height*0.4)
    	background:setAnchorPoint(PT(0,0))
    	background:setPosition(PT(posX*0.3,posY*0.3))
    	sendLayer:addChild(background,0)
    	
    	--��ϲ
    	local qbxiaohao = CCLabelTTF:create(Language.GONGXI,FONT_NAME,FONT_SMM_SIZE)
	sendLayer:addChild(qbxiaohao,0)
	qbxiaohao:setAnchorPoint(PT(0,0))
	qbxiaohao:setPosition(PT(posX*0.45,posY*0.65))
	
	--��ȡ�ˣ�
    	local qbxiaohao = CCLabelTTF:create(Language.SHENTOU,FONT_NAME,FONT_SMM_SIZE)
	sendLayer:addChild(qbxiaohao,0)
	qbxiaohao:setAnchorPoint(PT(0,0))
	qbxiaohao:setPosition(PT(posX*0.37,posY*0.6))
	
	--��ȡ��õ�
	if list2.LairRewardName==nil then
		list2.LairRewardName=""
	end
	local qbxiaohao = CCLabelTTF:create(list2.LairRewardName.."*"..list2.LairRewardNum,FONT_NAME,FONT_SMM_SIZE)
	sendLayer:addChild(qbxiaohao,0)
	qbxiaohao:setAnchorPoint(PT(0,0))
	qbxiaohao:setPosition(PT(posX*0.37,posY*0.57))
    	
--    	LairRewardHead
    	local huode= CCSprite:create(P("common/icon_8015_4.png"));
    	huode:setAnchorPoint(PT(0,0))
    	huode:setPosition(PT(background:getPosition().x+(posX*0.4-huode:getContentSize().width)/2,posY*0.45))
    	sendLayer:addChild(huode,0)
    	if list2.LairRewardHead~=nil then
	    	local image = string.format("smallitem/%s.png",list2.LairRewardHead)
	    	local huode= CCSprite:create(P(image));
	    	huode:setAnchorPoint(PT(0,0))
	    	huode:setPosition(PT(background:getPosition().x+(posX*0.4-huode:getContentSize().width)/2,posY*0.458))
	    	sendLayer:addChild(huode,0)
	end
    	
    	--����
    	local qbxiaohao = CCLabelTTF:create(list2.LairRewardNum,FONT_NAME,FONT_SMM_SIZE)
	sendLayer:addChild(qbxiaohao,0)

	qbxiaohao:setAnchorPoint(PT(0,0))
	qbxiaohao:setPosition(PT(background:getPosition().x+(posX*0.4-qbxiaohao:getContentSize().width)/2,posY*0.42))

	qbxiaohao:setAnchorPoint(PT(0.5,0))
	qbxiaohao:setPosition(PT(posX*0.5,posY*0.42))

	--posX*0.09+rowH*(k-1)*1.5+liebiao:getContentSize().width/2
	--position[i].x-pWinSize.width*0.05-taskLabel:getContentSize().width/2
	
	--ȷ����ť
	local quedingBtn= ZyButton:new(Image.image_button_red_c_0,Image.image_button_red_c_1, nil,Language.IDS_SURE,nil, FONT_SM_SIZE)
	quedingBtn:setAnchorPoint(PT(0,0))
	quedingBtn:setPosition(PT(posX*0.38,posY*0.33))
	quedingBtn:registerScriptHandler(suresend)
	quedingBtn:addto(sendLayer,1)

end

function suresend()
	removesend()
	choiceImage=nil
	actionLayer.Action12101(mScene,nil,type)
end

---�ӳٽ��з���
function delayExec(funName,nDuration,parent)
	local  action = CCSequence:createWithTwoActions(
	CCDelayTime:create(nDuration),
	CCCallFunc:create(funName));
	local layer = mLayer
	if parent then
		layer=parent
	end
	if layer then
		layer:runAction(action)
	end
end



-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionID = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)
	
	if actionID==12101 then
		local serverInfo=actionLayer._12101Callback(pScutScene, lpExternalData)
 		if serverInfo~=nil then
			list1=serverInfo
			mRecordTabel=serverInfo.RecordTabel
		end
		showContent()
	elseif actionID==12102 then
		if ZyReader:getResult()== eScutNetSuccess then
			local serverInfo=actionLayer._12102Callback(pScutScene, lpExternalData)
	 		if serverInfo~=nil then
				list2=serverInfo
			end
			startAction(list2.postion)
		elseif ZyReader:getResult()== 1 then

		else
			ZyToast.show(mScene,ZyReader:readErrorMsg())
			g_getBtn:setEnabled(true)
		end
	end
	
end