------------------------------------------------------------------
-- WorldBossToScene.lua.lua
-- Author     : yeyq

-- Version    : 1.0
-- Date       :
-- Description: 
------------------------------------------------------------------

module("WorldBossToScene", package.seeall)

-- �������õ��ĳ�Ա����Ҫ���ļ�ͷ���������������ӱ�Ҫ��˵��
-- ��Ա����ͳһ���»��߿�ʼ�����ӵ�����ĸҪСд

local g_scene = nil 
local g_LayerBg = nil 
local g_activeTable = nil 
local g_rankList = nil
local g_mLayer = nil 
local g_list = nil 
local g_listSize = nil
local g_attackLayer = nil 
local g_reviveTimeNum = nil 
local g_bossActtack = nil 
local g_LayerBgTo = nil 
local g_mAction = nil 


local numImgTable = { [0]="list_1202", [1]="list_1203", [2]="list_1204", [3]="list_1205", [4]="list_1206", [5]="list_1207", [6]="list_1208", [7]="list_1209", [8]="list_1210", [9]="list_1211", }

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
	g_mAction = 0 
end


function close()
	if g_mLayer then
		g_mLayer:getParent():removeChild(g_mLayer, true)
		g_mLayer = nil
	end

	if g_LayerBg then
		g_LayerBg:getParent():removeChild(g_LayerBg, true)
		g_LayerBg = nil
	end
	releaseResource()
end

-- �ͷ���Դ
function releaseResource()
	g_LastRankList = nil
	g_rankList = nil
	_isShowLast = nil
	g_mLayer = nil
	g_scene = nil
	g_LayerBg=nil
	g_LayerBgTo=nil
	g_activeTable=nil
	g_challengeButton=nil
	g_lastTimeshowLayer=nil
end
-- ��������
function init(scene, fatherLayer)
	g_scene = scene
	
	-- ��ӱ���
	local layerBg = CCLayer:create()
	fatherLayer:addChild(layerBg, 0)
	g_LayerBg = layerBg


	-- �˴���ӳ�����ʼ����
--	local bgImg = CCSprite:create(P("common/list_1024.png"))
--	bgImg:setScaleX(pWinSize.width/bgImg:getContentSize().width)
--	bgImg:setScaleY(pWinSize.height*0.86/bgImg:getContentSize().height)
--	bgImg:setAnchorPoint(PT(0,0))
--	bgImg:setPosition(PT(0,pWinSize.height*0.14))
--	layerBg:addChild(bgImg,0)

	showLayerMWorld()
end

--���ʾ����
function showLayerMWorld()
	local activeInfo = g_activeTable
	local layer =  CCLayer:create()
	g_mLayer = layer
	g_LayerBg:addChild(layer,1)
	
	
	----͸������
	local toumingImg = CCSprite:create(P("common/list_1038.9.png"))
	toumingImg:setColor(ccc3(255,255,255))
	toumingImg:setScaleX(pWinSize.width*0.92/toumingImg:getContentSize().width)
	toumingImg:setScaleY(pWinSize.height*0.69/toumingImg:getContentSize().height)
	toumingImg:setAnchorPoint(PT(0,0))
	toumingImg:setPosition(PT(pWinSize.width*0.04,pWinSize.height*0.21))
	layer:addChild(toumingImg,0)
	
	---����boss����
	local titleValueStr = activeInfo.Descp
	
	local titleValue =  CCLabelTTF:create(titleValueStr, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(titleValue,0)
	titleValue:setAnchorPoint(PT(0.5,0))
	titleValue:setPosition(PT(pWinSize.width*0.5,pWinSize.height*0.62))
	
	---����boss ͼ��
	local BossImg = CCSprite:create(P("mainUI/list_1123.png"))
	BossImg:setAnchorPoint(PT(0.5,0))
	BossImg:setPosition(PT(pWinSize.width*0.5,titleValue:getPosition().y+SY(7)))
	layer:addChild(BossImg,0)
	
	
	----���  ����սʿ  33��
	local titleStr1 = string.format(Language.WORLDBOSS_TITLE2, activeInfo.ActiveName, activeInfo.BossLv)
	local titleStr =  CCLabelTTF:create(titleStr1, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(titleStr,0)
	titleStr:setAnchorPoint(PT(0.5,0))
	titleStr:setPosition(PT(pWinSize.width*0.5,titleValue:getPosition().y-SX(15)))
	
	
	--- �ʱ��
	local str2 = string.format(Language.WORLDBOSS_STARTDAY, activeInfo.BeginDate, activeInfo.EndDate  )
	local titleDay =  CCLabelTTF:create(str2, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(titleDay,0)
	titleDay:setAnchorPoint(PT(0.5,0))
	titleDay:setPosition(PT(pWinSize.width*0.5,titleStr:getPosition().y-SX(15)))
	
	
	----�ϴ����������
	
	local lastTimeBgImgX = pWinSize.width*0.74
	local lastTimeBgImgY = pWinSize.height*0.2+SY(5)
	local lastTimeBgImg = CCSprite:create(P("common/list_1052.9.png"))
	lastTimeBgImg:setColor(ccc3(255,255,255))
	lastTimeBgImg:setScaleY(lastTimeBgImgY/lastTimeBgImg:getContentSize().height)
	lastTimeBgImg:setAnchorPoint(PT(0,0))
	lastTimeBgImg:setPosition(PT((pWinSize.width - lastTimeBgImg:getContentSize().width)/2,titleDay:getPosition().y-SY(2)-lastTimeBgImgY))
	layer:addChild(lastTimeBgImg,0)
	
	
	----�ϴ�ս���İ�ť
	local lastTimeButton = ZyButton:new("button/bottom_1002_2.9.png",nil,nil,Language.WORLDBOSS_BUTTONStr,FONT_NAME,FONT_SM_SIZE)
	lastTimeButton:addto(layer,0)
	lastTimeButton:setAnchorPoint(PT(0.5,0.5))
	lastTimeButton:setPosition(PT(pWinSize.width*0.8,lastTimeBgImg:getPosition().y-SY(20)))
	lastTimeButton:registerScriptHandler(lastTimeFunc)

	
	
		----������ս�İ�ť	
	local challengeButton = ZyButton:new("button/bottom_1002_2.9.png",nil,nil,Language.WORLDBOSS_Challenge,FONT_NAME,FONT_SM_SIZE)
	challengeButton:addto(layer,0)
	challengeButton:setAnchorPoint(PT(0.5,0.5))
	challengeButton:setPosition(PT(pWinSize.width*0.2,lastTimeButton:getPosition().y))
	challengeButton:registerScriptHandler(goAttackBoss)
	if activeInfo.EnableStatus ~= 1 then
		challengeButton:setVisible(false)
	end	
	g_challengeButton = challengeButton
	
	
	-----�ϴ�����������
	local lastTimeContentHead =  CCLabelTTF:create(Language.WORLDBOSS_LASTTIMERANKING, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(lastTimeContentHead,0)
	lastTimeContentHead:setAnchorPoint(PT(0.5,0))
	lastTimeContentHead:setPosition(PT(pWinSize.width*0.5,lastTimeBgImgY+lastTimeBgImg:getPosition().y-SY(15)))


	local startX = pWinSize.width*0.385
	----���1
	local rankingStr = ""--string.format(Language.WORLDBOSS_RankContentStr1,"123132")
	local lastTimeContent1 =  CCLabelTTF:create(rankingStr, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(lastTimeContent1,0)
	lastTimeContent1:setAnchorPoint(PT(0,0))
	lastTimeContent1:setPosition(PT(startX, lastTimeContentHead:getPosition().y-SY(15)))
	
	----���2
	local rankingStr = ""--string.format(Language.WORLDBOSS_RankContentStr2,"123132")
	local lastTimeContent2 =  CCLabelTTF:create(rankingStr, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(lastTimeContent2,0)
	lastTimeContent2:setAnchorPoint(PT(0,0))
	lastTimeContent2:setPosition(PT(startX, lastTimeContent1:getPosition().y-SY(15)))
	
	----���3
	local rankingStr = ""--string.format(Language.WORLDBOSS_RankContentStr3,"123132")
	local lastTimeContent3 =  CCLabelTTF:create(rankingStr, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(lastTimeContent3,0)
	lastTimeContent3:setAnchorPoint(PT(0,0))
	lastTimeContent3:setPosition(PT(startX, lastTimeContent2:getPosition().y-SY(15)))
	
	
	
	frontTable = {}
	frontTable[1] = lastTimeContent1
	frontTable[2] = lastTimeContent2
	frontTable[3] = lastTimeContent3
	
	sendAction(5406, 0)
	
end

--������ս��ť�����Ӧ
function goAttackBoss()
	sendAction(5401)
end


--�ϴ�ǰ����
function setBeforeRank(table)
	local rankTable = {Language.WORLDBOSS_RankContentStr1, Language.WORLDBOSS_RankContentStr2, Language.WORLDBOSS_RankContentStr3} 
	if table and #table > 0 then
		for k,v in ipairs(frontTable) do
			if table[k] then
				local rankingStr = string.format(rankTable[k], table[k].UserName)
				v:setString(rankingStr)
			end
		end
	end
	
	if #table == 0 then
		local item = frontTable[2]
		local pos = PT(pWinSize.width*0.5, item:getPosition().y)
		item:setAnchorPoint(PT(0.5, 0))
		item:setPosition(pos)
		item:setString(Language.ACTIVE_NOLASTBOSS)
	end
end;


----�ϴ�ս����ѯ
function lastTimeFunc()
	if g_LastRankList ~= nil then
		if #g_LastRankList.RecordTabel > 0 then
			lastTimeshowLayer()
		else
			ZyToast.show(g_scene, Language.ACTIVE_NOLASTBOSS,1,0.2)
		end
	else
		_isShowLast = true
		sendAction(5406,0)
	end	
end

function closeLastTime()
	_isShowLast = false
	if  g_lastTimeshowLayer  then 
		g_lastTimeshowLayer:getParent():removeChild(g_lastTimeshowLayer,true)
		g_lastTimeshowLayer = nil
	end

end;

----����ϴ�ս��
function lastTimeshowLayer()
	if  g_lastTimeshowLayer  then 
		g_lastTimeshowLayer:getParent():removeChild(g_lastTimeshowLayer,true)
		g_lastTimeshowLayer = nil
	end
	local layer  = CCLayer:create()
	g_lastTimeshowLayer = layer
	g_scene:addChild(layer,1)

	
	lastTimeBg(layer)
	
	local closeBtn=ZyButton:new("button/list_1046.png")
	closeBtn:setAnchorPoint(PT(0,0))
	closeBtn:setPosition(PT(pWinSize.width-closeBtn:getContentSize().width*1.1,
							pWinSize.height-closeBtn:getContentSize().height*1.2))
	closeBtn:addto(layer,1)
	closeBtn:registerScriptHandler(closeLastTime)
	
	
	g_listSize = SZ(pWinSize.width,pWinSize.height*0.58)
	g_list = ScutCxList:node(g_listSize.height*0.35,ccc4(24,24,24,0),g_listSize)
	g_list:setAnchorPoint(PT(0,0))
	g_list:setPosition(PT((pWinSize.width-g_listSize.width)/2,pWinSize.height*0.22))
	layer:addChild(g_list,0)
	g_list:setTouchEnabled(true)
	
	----�ϴ�ս���������
	local titleStr = CCSprite:create(P("title/list_1108.png"))
	titleStr:setAnchorPoint(PT(0.5,0))
	titleStr:setPosition(PT(pWinSize.width*0.5,pWinSize.height*0.91))
	layer:addChild(titleStr,0)
	
	---��˭ɱ��   �������� ��
	local lastTimeCotentBg = CCSprite:create(P("common/list_1052.9.png"))
	lastTimeCotentBg:setColor(ccc3(250,250,250))
	lastTimeCotentBg:setScaleY(pWinSize.height*0.08/lastTimeCotentBg:getContentSize().height)
	lastTimeCotentBg:setAnchorPoint(PT(0,0))
	lastTimeCotentBg:setPosition(PT(pWinSize.width*0.5 - lastTimeCotentBg:getContentSize().width/2
										,pWinSize.height*0.81))
	layer:addChild(lastTimeCotentBg,0)
	
	---��˭ɱ��   ��������  ��XX�ֱ�XXXɱ�� ����XXX
	local winnerStr = ""
	if g_LastRankList._nickName then
		winnerStr = string.format(Language.WORLDBOSS_ATTACKVALUE, g_LastRankList._nickName)
	else
		winnerStr = Language.WORLDBOSS_NOKILL
	end
	
	local attackRankingStr = string.format(Language.WORLDBOSS_ATTACKBOSS, g_activeTable.BossLv, winnerStr)
	
	local  attackRankingStrW  = lastTimeCotentBg:getContentSize().width*0.94
	local lastTimeCotent = ZyMultiLabel:new(attackRankingStr,attackRankingStrW,FONT_NAME,FONT_SM_SIZE)
	lastTimeCotent:addto(layer,0)
	lastTimeCotent:setAnchorPoint(PT(0,0))
	lastTimeCotent:setPosition(PT(lastTimeCotentBg:getPosition().x+lastTimeCotentBg:getContentSize().width/2-attackRankingStrW/2,
								lastTimeCotentBg:getPosition().y+(pWinSize.height*0.08-lastTimeCotent:getContentSize().height)/2))
	
	
	listFunc()
end

function lastTimeBg(layer)
	local bgImg = CCSprite:create(P("common/list_1024.png"))
	bgImg:setScaleX(pWinSize.width/bgImg:getContentSize().width)
	bgImg:setScaleY(pWinSize.height*0.86/bgImg:getContentSize().height)
	bgImg:setAnchorPoint(PT(0,0))
	bgImg:setPosition(PT(0,pWinSize.height*0.14))
	layer:addChild(bgImg,0)
	
	local boxSize = SZ(pWinSize.width, pWinSize.height*0.86)
	local actionBtn=UIHelper.createActionRect(boxSize,nil,tag)
	actionBtn:setAnchorPoint(PT(0,0))
	actionBtn:setPosition(bgImg:getPosition())
	layer:addChild(actionBtn, 0)	
end;

---�ϴ�ս����list
function listFunc()
	local tableLabel = g_LastRankList.RecordTabel  
	for  i=1,10 do
		if tableLabel[i] then
			local item = ScutCxListItem:itemWithColor(ccc3(255,255,255))	--25,57,45
			item:setOpacity(0)
			local layout = CxLayout()
			layout.val_x.t = ABS_WITH_PIXEL
			layout.val_y.t = ABS_WITH_PIXEL	
			layout.val_x.val.pixel_val =0
			layout.val_y.val.pixel_val =0
			
			
			local itemLayer = CCLayer:create()
			local g_listH = g_list:getRowHeight()
			
			----�󱳾�ͼƬ�Ĵ�С setPosition()
			local backgroundImgX = g_listSize.width*0.86
			local backgroundImgY  = g_listSize.height*0.35*0.7
			local backgroundImgPX = (g_listSize.width-backgroundImgX)/2
			local backgroundImgPY =  0
			
	
			
			--�󱳾�ͼƬ
			local backgroundImg=CCSprite:create(P("common/list_1038.9.png"))
			backgroundImg:setColor(ccc3(250,250,250))
			backgroundImg:setScaleX(backgroundImgX/backgroundImg:getContentSize().width)
			backgroundImg:setScaleY(backgroundImgY/backgroundImg:getContentSize().height)
			backgroundImg:setAnchorPoint(PT(0,0))
			backgroundImg:setPosition(PT(backgroundImgPX,backgroundImgPY))
			itemLayer:addChild(backgroundImg,0)
			
			rowH = backgroundImgY
			-----��ɱBOSS�������
			local NumStrImg=creatImgNum(i)
			NumStrImg:setAnchorPoint(PT(0.5,0))
			NumStrImg:setPosition(PT(backgroundImgX*0.14,backgroundImgY/2-NumStrImg:getContentSize().height/2))
			backgroundImg:addChild(NumStrImg,0)
			
			---��ɱBOSS�����ľ�����Ϣ
			local attackPlayer =  CCLabelTTF:create(tableLabel[i].UserName, FONT_NAME, FONT_SM_SIZE)
			attackPlayer:setAnchorPoint(PT(0,0))
			attackPlayer:setPosition(PT(g_listSize.width*0.3,backgroundImgY-SY(12)))
			itemLayer:addChild(attackPlayer,0)
			
			--"�˺�Ѫ��:%s"
			local listStr = string.format(Language.WORLDBOSS_ATTACKVALUE1, tableLabel[i].DamageNum)
			local attackPlayer1 =  CCLabelTTF:create(listStr, FONT_NAME, FONT_SM_SIZE)
			attackPlayer1:setAnchorPoint(PT(0,0))
			attackPlayer1:setPosition(PT(attackPlayer:getPosition().x,attackPlayer:getPosition().y-SY(10)))
			itemLayer:addChild(attackPlayer1,0)
			
			--�ȼ�
			local listStr = string.format(Language.WORLDBOSS_ATTACKVALUE2, tableLabel[i].UserLv)
			local attackPlayer2 =  CCLabelTTF:create(listStr, FONT_NAME, FONT_SM_SIZE)
				attackPlayer2:setAnchorPoint(PT(0,0))
			attackPlayer2:setPosition(PT(attackPlayer1:getPosition().x,attackPlayer1:getPosition().y-SY(10)))
			itemLayer:addChild(attackPlayer2,0)
			
			----�鿴��ť
			local listButton = ZyButton:new("button/list_1039.png",nil,nil,Language.WORLDBOSS_BUTTONStr1,FONT_NAME,FONT_SM_SIZE) 
			listButton:addto(itemLayer,0)
			listButton:setAnchorPoint(PT(0,0))
			listButton:setTag(i)
			listButton:setPosition(PT(backgroundImgX*0.9-(listButton:getContentSize().width)/2,(rowH-listButton:getContentSize().height)/2))
			listButton:registerScriptHandler(gotoHeroAction)
			
			g_list:setRowHeight(rowH)	
			item:addChildItem(itemLayer,layout)
			g_list:addListItem(item,false)	
		end
	end
end

--����ͼƬ  2λ��
function creatImgNum(num)
	local m,n = nil--ʮλ ��λ
	n = num%10
	if num >= 10 then
		m = math.floor(num/10)%10
	end
	local layer = CCLayer:create()
	local startX = 0
	
	if m then
		local tenPic = string.format("common/%s.png", numImgTable[m])
		local tenImg = CCSprite:create(P(tenPic))
		tenImg:setAnchorPoint(PT(0,0))
		tenImg:setPosition(startX,0)
		layer:addChild(tenImg, 0)
		
		startX = tenImg:getContentSize().width
	end
	
	
	local unitsPic = string.format("common/%s.png", numImgTable[n])
	local unitsImg = CCSprite:create(P(unitsPic))
	unitsImg:setAnchorPoint(PT(0,0))
	unitsImg:setPosition(PT(startX,0))
	layer:addChild(unitsImg, 0)
	
	layer:setContentSize(SZ(startX+unitsImg:getContentSize().width, unitsImg:getContentSize().height))
	
	return layer
	
end;


--�ϴ�������Ҿ���鿴
function gotoHeroAction(pNode)
	local tag = pNode:getTag()
	local playerId = g_LastRankList.RecordTabel[tag].UserID   
	HeroScene.pushScene(nil, playerId)
end

---------------------------------------------------------------------------------

----����ʱ��
function reviveTime()
	g_reviveTimeNum = g_reviveTimeNum -1 
	if g_reviveTimeNum == 0  then 
		delayExec("WorldBossToScene.reviveSucceed",0.1)
	end
end

----�ӳ�ʱ�䷽��
function delayExec(funName,nDuration)
	local  action = CCSequence:createWithTwoActions(
	CCDelayTime:create(nDuration),
	CCCallFunc:create(funName));
	if g_mLayer ~= nil then
		g_mLayer:runAction(action)
	end
end
----�ӳ�ʱ�����Ϊ  

	--ֹͣ��ʱ�� ��ť��ԭ��    ֹͣ����ʱ��
function stopTimer()
	--CCScheduler:sharedScheduler():unscheduleScriptFunc("WorldBossToScene.timer")	
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(schedulerEntry1)
end

function timer(t)
	g_bossActtack.codeTime = g_bossActtack.codeTime-1
	if g_bossActtack.codeTime <= 0 then
		delayExec("WorldBossToScene.refreshWin", 0.1)
	else
		_titleStr2Num:setString(g_bossActtack.codeTime)
	end
end


--�ر�����boss��������
function closeLayerWorld()
	if   g_LayerBgTo  ~= nil  then
		g_LayerBgTo:getParent():removeChild(g_LayerBgTo,true)	
		g_LayerBgTo = nil		
	end
	stopTimer()
end

----- ���  ������ս ��������   5401����
function showLayerWorld()
	if fightLayer then
		return
	end
	closeLayerWorld()
	
	local layer = CCLayer:create()
	g_LayerBgTo  = layer
	g_scene:addChild(layer,1)

	--����
	creatBg(layer)
	
	
	
	local startX = pWinSize.width*0.1
	local height = pWinSize.height*0.67
	----��ʾ�� �� "��ʿ���Ѿ�����%s��,������˺�:"       �˺�����ֵ
	if g_bossActtack.combatNum or g_bossActtack.damageNum then
		local  titleStr1C = string.format(Language.WORLDBOSS_REVIVESTR, g_bossActtack.combatNum)
		local titleStr1 =  CCLabelTTF:create(titleStr1C, FONT_NAME, FONT_DEF_SIZE)
		layer:addChild(titleStr1,0)
		titleStr1:setAnchorPoint(PT(0,0))
		titleStr1:setPosition(PT(startX, height))
		
		local titleStr1Num =  CCLabelTTF:create(g_bossActtack.damageNum, FONT_NAME, FONT_DEF_SIZE)
		titleStr1Num:setColor(ccc3(255,0,0))
		layer:addChild(titleStr1Num,0)
		titleStr1Num:setAnchorPoint(PT(0,0))
		titleStr1Num:setPosition(PT(titleStr1:getPosition().x+titleStr1:getContentSize().width+SX(1),titleStr1:getPosition().y))		
	end

	--    ��ʾ�� ��       "��սһ���е���,�ȴ�����:"
	if g_bossActtack.codeTime and g_bossActtack.codeTime > 0 then
		local titleStr2 =  CCLabelTTF:create(Language.WORLDBOSS_RESPAWN, FONT_NAME, FONT_DEF_SIZE)
		layer:addChild(titleStr2,0)
		titleStr2:setAnchorPoint(PT(0,0))
		height = height-titleStr2:getContentSize().height
		titleStr2:setPosition(PT(startX, height))
	
		
		---��ȴʱ��   ��   ��ֵ
		local titleStr2Num =  CCLabelTTF:create(g_bossActtack.codeTime , FONT_NAME, FONT_DEF_SIZE)
		titleStr2Num:setColor(ccc3(255,0,0))
		layer:addChild(titleStr2Num,0)
		titleStr2Num:setAnchorPoint(PT(0,0))
		titleStr2Num:setPosition(PT(titleStr2:getPosition().x+titleStr2:getContentSize().width+SX(1),titleStr2:getPosition().y))
		
		_titleStr2Num = titleStr2Num
		   schedulerEntry1 = 	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(timer, 1, false)
	--	CCScheduler:sharedScheduler():scheduleScriptFunc("WorldBossToScene.timer", 1, false)
	end
	
	--��ť
	creatButton(layer)
	
	--boss��Ϣ
	creatBossInfo(layer)
	
	
	---�������а��
	local RankingImg = CCSprite:create(P("common/list_1052.9.png"))
	RankingImg:setScaleY(pWinSize.height*0.25/RankingImg:getContentSize().height)
	RankingImg:setAnchorPoint(PT(0,0))
	RankingImg:setPosition(PT((pWinSize.width-RankingImg:getContentSize().width)/2,pWinSize.height*0.08))
	layer:addChild(RankingImg,0)
	--�˺����� ����
	local HeadTitle = CCLabelTTF:create(Language.WORLDBOSS_attackListStr, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(HeadTitle,0)
	HeadTitle:setColor(ccc3(255,255,255))
	HeadTitle:setAnchorPoint(PT(0.5,0))
	HeadTitle:setPosition(PT(pWinSize.width*0.5,
								RankingImg:getPosition().y+pWinSize.height*0.25-SY(10)))
	
	--�˺�list
	g_tListSize = SZ(RankingImg:getContentSize().width*0.98,pWinSize.height*0.2)
	g_tList = ScutCxList:node(pWinSize.height*0.2/5,ccc4(24,24,24,0),g_tListSize)
	g_tList:setAnchorPoint(PT(0,0))
	g_tList:setPosition(PT((pWinSize.width-g_tList:getContentSize().width)/2
							,RankingImg:getPosition().y+SY(3)))
	layer:addChild(g_tList,0)
	g_tList:setTouchEnabled(true)

	
	sendAction(5406, 1)
end

--bossս����   ���β�
function creatBg(layer)


	local unTouchBtn =  ZyButton:new(Image.image_transparent,Image.image_transparent)
	unTouchBtn:setScaleX(pWinSize.width/unTouchBtn:getContentSize().width)
	unTouchBtn:setScaleY(pWinSize.height/unTouchBtn:getContentSize().height)
	unTouchBtn:setAnchorPoint(PT(0,0))
	unTouchBtn:setPosition(PT(0,0))
	unTouchBtn:addto(layer, 0)

	---����� 768x1024
	local bgactiveImg = CCSprite:create(P("common/list_1076.png"))
	bgactiveImg:setScaleX(pWinSize.width/bgactiveImg:getContentSize().width)
	bgactiveImg:setScaleY(pWinSize.height/bgactiveImg:getContentSize().height)
	bgactiveImg:setAnchorPoint(PT(0,0))
	bgactiveImg:setPosition(PT(0,0))
	layer:addChild(bgactiveImg,0)
	
--	������߿�1024��ɫ�߿�
	local bgBorderImg = CCSprite:create(P("common/list_1074.png"))
	bgBorderImg:setScaleX(pWinSize.width/bgBorderImg:getContentSize().width)
	bgBorderImg:setScaleY(pWinSize.height/bgBorderImg:getContentSize().height)
	bgBorderImg:setAnchorPoint(PT(0,0))
	bgBorderImg:setPosition(PT(0,0))
	layer:addChild(bgBorderImg,0)
	
	
	--- �����
	local bgImg = CCSprite:create(P("activeBg/list_1138.jpg"))
	bgImg:setScaleX(pWinSize.width*0.92/bgImg:getContentSize().width)
	bgImg:setScaleY(pWinSize.height*0.91/bgImg:getContentSize().height)
	bgImg:setAnchorPoint(PT(0,0))
	bgImg:setPosition(PT((pWinSize.width-pWinSize.width*0.92)/2,pWinSize.height*0.06))
	layer:addChild(bgImg,0)
end

--��ť�б�
function creatButton(layer)
	---�˳�bossս��
	local buttonLeft = ZyButton:new("button/bottom_1002_2.9.png",nil,nil,Language.WORLDBOSS_ButtonStr1,FONT_NAME,FONT_SM_SIZE)
	local buttonRate = (pWinSize.width-buttonLeft:getContentSize().width*3)/4
	buttonLeft:addto(layer,0)
	buttonLeft:setAnchorPoint(PT(0,0.5))
	buttonLeft:setPosition(PT(buttonRate,pWinSize.height*0.6))
	buttonLeft:registerScriptHandler(closeLayerWorld)
	
	--��ʯ����
	local buttonTobuttonX = SX(25)
	local buttonCenter = ZyButton:new(Image.image_button_red_c_0, Image.image_button_red_c_1, Image.image_button_hui_c,Language.WORLDBOSS_ButtonStr2,FONT_NAME,FONT_SM_SIZE)

	buttonCenter:setAnchorPoint(PT(0,0.5))
	buttonCenter:setPosition(PT(buttonLeft:getPosition().x+buttonLeft:getContentSize().width+buttonRate,buttonLeft:getPosition().y))
	buttonCenter:registerScriptHandler(inspireFunc)
	
	--20
	local glodNum = g_bossActtack.GlodNum
	local moneyNum = CCLabelTTF:create(glodNum, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(moneyNum,0)
	moneyNum:setAnchorPoint(PT(0,0.5))
	moneyNum:setPosition(PT(pWinSize.width*0.37,buttonCenter:getPosition().y-SY(20)))
	
	local moneyImg = CCSprite:create(P("mainUI/list_1006.png"))
	moneyImg:setAnchorPoint(PT(0,0.5))
	moneyImg:setPosition(PT(moneyNum:getPosition().x+SX(20),moneyNum:getPosition().y))
	layer:addChild(moneyImg,0)
	
	
	local attackImg = CCSprite:create(P("mainUI/list_1035.png"))
	attackImg:setAnchorPoint(PT(0,0.5))
	attackImg:setPosition(PT(moneyImg:getPosition().x+SX(35),moneyImg:getPosition().y))
	layer:addChild(attackImg,0)
	 
	local inspirePercent  = g_bossActtack.InspireNum 
	local attackNum = CCLabelTTF:create(inspirePercent, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(attackNum,0)
	attackNum:setAnchorPoint(PT(0,0.5))
	attackNum:setPosition(PT(attackImg:getPosition().x+SX(30),attackImg:getPosition().y))
	if inspirePercent>= 100 then
		buttonCenter:setEnabled(false)
	end
	
-------------------------	
	---����
	local buttonRight = ZyButton:new(Image.image_button_red_c_0, Image.image_button_red_c_1, Image.image_button_hui_c,Language.WORLDBOSS_ButtonStr3,FONT_NAME,FONT_SM_SIZE)

	buttonRight:setAnchorPoint(PT(0,0.5))
	buttonRight:setPosition(PT(buttonCenter:getPosition().x+buttonCenter:getContentSize().width+buttonRate,
									buttonCenter:getPosition().y))
	buttonRight:registerScriptHandler(reviveFunc)
	if g_bossActtack.ReLiveNum >= 5 then
		buttonRight:setEnabled(false)
	end
	
	
	if isShowVip() or PersonalInfo.getPersonalInfo()._VipLv >= 3 then
		buttonCenter:addto(layer,0)
		buttonRight:addto(layer,0)	
	end
	
	
	local backGoldNum = g_bossActtack.BackGoldNum 
	local moneyNumRight = CCLabelTTF:create(backGoldNum, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(moneyNumRight,0)
	moneyNumRight:setAnchorPoint(PT(0,0.5))
	moneyNumRight:setPosition(PT(pWinSize.width*0.7,buttonCenter:getPosition().y-SY(20)))
	
	local moneyImgRight = CCSprite:create(P("mainUI/list_1006.png"))
	moneyImgRight:setAnchorPoint(PT(0,0.5))
	moneyImgRight:setPosition(PT(moneyNumRight:getPosition().x+SX(20),moneyNumRight:getPosition().y))
	layer:addChild(moneyImgRight,0)


	local attackImg = CCSprite:create(P("mainUI/list_1035.png"))
	attackImg:setAnchorPoint(PT(0,0.5))
	attackImg:setPosition(PT(moneyImgRight:getPosition().x+SX(35),moneyImgRight:getPosition().y))
	layer:addChild(attackImg,0)
	
	local inspirePercent  = g_bossActtack.reliveInspirePercent 
	local attackNum = CCLabelTTF:create(inspirePercent, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(attackNum,0)
	attackNum:setAnchorPoint(PT(0,0.5))
	attackNum:setPosition(PT(attackImg:getPosition().x+SX(30),attackImg:getPosition().y))
	
	
	
end;

--boss��Ϣ     Ѫ�������ƣ���ս��ť
function creatBossInfo(layer)
	------boss��
	local bossBorderImg = CCSprite:create(P("common/list_1089.9.png"))
	bossBorderImg:setScaleX(pWinSize.width*0.9/bossBorderImg:getContentSize().width)
	bossBorderImg:setScaleY(pWinSize.height*0.2/bossBorderImg:getContentSize().height)
	bossBorderImg:setAnchorPoint(PT(0,0.5))
	bossBorderImg:setPosition(PT(pWinSize.width*0.05,pWinSize.height*0.425))
	layer:addChild(bossBorderImg,0)
	
	local attackButton = ZyButton:new("common/list_1090.png",nil,nil,nil,FONT_NAME,FONT_SM_SIZE)
	attackButton:addto(layer,0)
	attackButton:setAnchorPoint(PT(0,0.5))
	attackButton:setPosition(PT(pWinSize.width*0.65,bossBorderImg:getPosition().y))
	attackButton:setVisible(true)
	attackButton:registerScriptHandler(attackGoalFunc)
	
	
	---- boss����
	local name = ""
	if g_activeTable.ActiveName then
		name = g_activeTable.ActiveName
	end	
	local bossName = CCLabelTTF:create(name, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(bossName,0)
	bossName:setColor(ccc3(255,0,0))
	bossName:setAnchorPoint(PT(0,0.5))
	bossName:setPosition(PT(pWinSize.width*0.3,attackButton:getPosition().y+SY(10)))

	
	----Ѫ����
	local bloodBorderImg = CCSprite:create(P("imageupdate/list_1116.png"))
--	bloodBorderImg:setScaleX((259/640)*pWinSize.width/bloodBorderImg:getContentSize().width)
	bloodBorderImg:setAnchorPoint(PT(0,0.5))
	bloodBorderImg:setPosition(PT(pWinSize.width*0.2,bossName:getPosition().y-SY(20)))
	layer:addChild(bloodBorderImg,0)
	--Ѫ��
	if bloodLayer then 
		bloodLayer:getParent():removeChild(bloodLayer,true)
		bloodLayer = nil 
	end
	local bloodLayer = CCLayer:create()
	layer:addChild(bloodLayer, 0)
	
	----��Ҫ����5404�ӿ�ˢ��Ѫ��
	--local currLifeNum = g_bossActtack.BossLiftNum 
--	local  maxLifeNum = g_bossActtack.BossMaxLift  

	local prog =  g_bossActtack.BossLiftNum/g_bossActtack.BossMaxLift   
	local maxLong=bloodBorderImg:getContentSize().width*0.83
	local width=maxLong*prog
	
--	local blood = (50/100)
	local bloodImg = CCSprite:create(P("common/list_5003.9.png"))
	bloodImg:setScaleX(width/bloodImg:getContentSize().width)
	bloodImg:setScaleY(bloodBorderImg:getContentSize().height*0.5/bloodImg:getContentSize().height)
	bloodImg:setAnchorPoint(PT(0,0.5))
	bloodImg:setPosition(PT(bloodBorderImg:getPosition().x+bloodBorderImg:getContentSize().width*0.087, bloodBorderImg:getPosition().y+bloodBorderImg:getContentSize().height*0.08))
	layer:addChild(bloodImg,0)
	
	--Ѫ���ٷֱ�
	local percentStr = ((prog-prog%0.0001)*100).."%"
	local bloodPercent = CCLabelTTF:create(percentStr, FONT_NAME, FONT_SM_SIZE)
	layer:addChild(bloodPercent,0)
	bloodPercent:setAnchorPoint(PT(0.5,0.5))
	bloodPercent:setPosition(PT(bloodBorderImg:getPosition().x+bloodBorderImg:getContentSize().width*0.5,bloodBorderImg:getPosition().y))
	
end

--���谴ť
function inspireFunc()
	if PersonalInfo.getPersonalInfo()._VipLv >= 3 then
		sendAction(5402, 3)
	else
		local notice = string.format(Language.ACTIVE_VIPOPEN, 3)
		ZyToast.show(g_scene,notice,1.5,0.35)
	end
end

function askISInspire(index, content, tag)
	if index == 1 then
		sendAction(5402, 4)
	end
end;

--���ť
function reviveFunc()
	if PersonalInfo.getPersonalInfo()._VipLv >= 3 then
		sendAction(5403,1)
	else
		local notice = string.format(Language.ACTIVE_VIPOPEN, 3)
		ZyToast.show(g_scene,notice,1.5,0.35)
	end
end

function askIsRevive(index, content, tag)
	if index == 1 then
		sendAction(5403, 2)
	end
end;


--�����˺������б�
function tRankingFunc()
	local info = g_rankList.RecordTabel
	for i=1,10 do
		if info and info[i] then
			local item = ScutCxListItem:itemWithColor(ccc3(255,255,255))	--25,57,45
			item:setOpacity(0)
			local layout = CxLayout()
			layout.val_x.t = ABS_WITH_PIXEL
			layout.val_y.t = ABS_WITH_PIXEL	
			layout.val_x.val.pixel_val =0
			layout.val_y.val.pixel_val =0
			

			local itemLayer = CCLayer:create()
			local list_H = g_tList:getRowHeight()
			local list_width = g_tList:getContentSize().width
			local Num = CCLabelTTF:create(i,FONT_NAME, FONT_SM_SIZE)
			itemLayer:addChild(Num,0)
			Num:setAnchorPoint(PT(0,0))
			Num:setPosition(PT(list_width*0.05,0))
			
--			if  i~= 1 then
--				Num:setString(i)			
--			end
--			
			
			local listName = CCLabelTTF:create(info[i].UserName ,FONT_NAME, FONT_SM_SIZE)
			itemLayer:addChild(listName,0)
			listName:setAnchorPoint(PT(0,0))
			listName:setPosition(PT(list_width*0.15,0))
			
			local listLvStr = string.format(Language.WORLDBOSS_AttackLV, info[i].UserLv)
			local listLv = CCLabelTTF:create(listLvStr, FONT_NAME, FONT_SM_SIZE)
			itemLayer:addChild(listLv,0)
			listLv:setAnchorPoint(PT(0,0))
			listLv:setPosition(PT(list_width*0.45,0))
			
			local listNumStrt = info[i].DamageNum
			local listNum = CCLabelTTF:create(listNumStrt, FONT_NAME, FONT_SM_SIZE)
			itemLayer:addChild(listNum,0)
			listNum:setAnchorPoint(PT(0,0))
			listNum:setPosition(PT(list_width*0.75,0))
			
		--	rowH =listNum:getContentSize().height
			
		--	g_tList:setRowHeight(rowH)	
			item:addChildItem(itemLayer,layout)
			g_tList:addListItem(item,false)
		end			
	end
end

--��������ť�����Ӧ
function attackGoalFunc()
	sendAction(5405)
end

----------------��ʼս��
function startFight(info)
	if fightLayer then
		fightLayer:getParent():removeChild(fightLayer, true)
		fightLayer = nil
	end
	local layer = CCLayer:create()
	g_scene:addChild(layer, 5)

		
	--���ΰ�ť
	local actionBtn=UIHelper.createActionRect(pWinSize)
	actionBtn:setPosition(PT(0,0))
	layer:addChild(actionBtn,0)
	
	local imageBg = CCSprite:create(P("map/map_1001.jpg"))
	imageBg:setScaleX(pWinSize.width/imageBg:getContentSize().width)
	imageBg:setScaleY(pWinSize.height/imageBg:getContentSize().height)
	imageBg:setAnchorPoint(PT(0,0))
	imageBg:setPosition(PT(0,0))
	layer:addChild(imageBg, 0)	
	
	
	fightLayer = layer

	local battleType = 3
	local IsOverCombat = nil--1����
	PlotFightLayer.setFightInfo(info,IsOverCombat,battleType)

	PlotFightLayer.init(fightLayer)

end;


function battleOver(info)
	local resultStr = ""
	if info.IsWin == 1 then
		resultStr = resultStr..Language.PLOT_WIN
	else
		resultStr = resultStr..Language.PLOT_FALSE
	end

	resultStr = resultStr..Language.IDS_COMMA
	
	resultStr=resultStr..string.format(Language.BOSS_HURT_NUM,info.DamageNum)..Language.IDS_COMMA
	
	if (info.GameCoin ~= nil and info.GameCoin > 0) or (info.GameCoin ~= nil and info.GameCoin > 0) then
		resultStr = resultStr..Language.BAG_TIP9..Language.IDS_COLON
	end
	if info.GameCoin ~= nil and info.GameCoin > 0 then
		resultStr = resultStr..info.GameCoin..Language.IDS_GOLD
	end
	if info.ObtainNum ~= nil and info.ObtainNum > 0 then
		if info.GameCoin ~= nil and info.GameCoin > 0 then
			resultStr = resultStr..Language.IDS_COMMA
		end	
		resultStr = resultStr..Language.BASICE_YUELI..info.ObtainNum
	end	
	
--	 IDS_COMMA
	local box = ZyMessageBoxEx:new()
	box:doPrompt(g_scene, nil, resultStr,Language.IDS_OK,closeFightLayer)
	
end

function closeFightLayer()
	if fightLayer then
		fightLayer:getParent():removeChild(fightLayer, true)
		fightLayer = nil
	end
	PlotFightLayer.releaseResource()
	refreshWin()
end;

---------------
function refreshWin()
	sendAction(5401)
end;

-----------------------------------------------------------------
--��������
function sendAction(actionId, ops)
	if actionId == 5401 then
	--	actionLayer.action5401(g_scene, nil)
		stopTimer()
		actionLayer.Action5401(g_scene,nil,1,10,g_activeTable.ActiveId)
	elseif actionId == 5402 then--����  1��������ʾ2������ȷ��3����ʯ��ʾ4����ʯȷ�� 
		actionLayer.Action5402(g_scene,nil, ops, g_activeTable.ActiveId)
	elseif actionId == 5403 then--1����ʾ    2��ȷ��
		actionLayer.Action5403(g_scene,nil, ops, g_activeTable.ActiveId)
	elseif acitonId == 5404 then
		actionLayer.Action5404(g_scene,nil,g_activeTable.ActiveId)
	elseif actionId == 5405 then
		actionLayer.Action5405(g_scene,nil,g_activeTable.ActiveId)
	elseif actionId == 5406 then
		local IsCurr = ops
		actionLayer.Action5406(g_scene,nil,g_activeTable.ActiveId, IsCurr)--�Ƿ������� 0������ 1������
	elseif actionId == 3009 then
		local ActiveType  = 19--FuncEnum
		actionLayer.Action3009(g_scene,nil,ActiveType)

	end
end

-- ����ص�
function networkCallback(pScutScene, lpExternalData)
	local actionID = ZyReader:getActionID()
	local userData = ScutRequestParam:getParamData(lpExternalData)	
	if actionID == 1401 then
		local serverInfo = actionLayer._1401Callback(pScutScene, lpExternalData)	
		if   serverInfo ~= nil then 
			local headTabel = serverInfo.RecordTabel
			HeroScene.createScene()
			HeroScene.showHeroHead(headTabel)
		end		
	elseif  actionID == 1403 then 
		local serverInfo = actionLayer._1403Callback(pScutScene, lpExternalData)	
		if   serverInfo ~= nil  and    serverInfo ~= {}   then 
			local headTabel = serverInfo.RecordTabel
			HeroScene.createScene()
			HeroScene.showHeroHead(headTabel)
		end
	elseif actionID == 5401 then
		local serverInfo = actionLayer._5401Callback(pScutScene, lpExternalData)	
		if serverInfo ~= nil then 
			g_bossActtack = serverInfo
		
			if serverInfo.CombatStatus == 1 or serverInfo.CombatStatus == 2 then--0	δ��ʼ--1	�ȴ�--2	ս��--3	�ѻ�ɱ--4	�ѽ���
				showLayerWorld()
			else
				g_challengeButton:setVisible(false)
				closeLayerWorld()
				TrialScene.refreshWin()
			end
		elseif ZyReader:getResult() == 1 then
			g_challengeButton:setVisible(false)
			closeLayerWorld()
			TrialScene.refreshWin()
		else
			ZyToast.show(pScutScene,ZyReader:readErrorMsg(),1.5,0.35)	
		end
	elseif actionID == 5402 then
		if ZyReader:getResult() == 4 then	
			sendAction(5401)
		elseif ZyReader:getResult() == 3 then
			local box = ZyMessageBoxEx:new()
			box:doQuery(pScutScene, Language.TIP_TIP, ZyReader:readErrorMsg(), Language.IDS_SURE, Language.IDS_CANCEL, askISInspire)
		else	
			ZyToast.show(pScutScene,ZyReader:readErrorMsg(),1.5,0.35)
		end
	elseif actionID == 5403 then
		if ZyReader:getResult() == 2 then	
			sendAction(5401)
		elseif ZyReader:getResult() == 1 then
			local box = ZyMessageBoxEx:new()
			box:doQuery(pScutScene, Language.TIP_TIP, ZyReader:readErrorMsg(), Language.IDS_SURE, Language.IDS_CANCEL, askIsRevive)
		else	
			ZyToast.show(pScutScene,ZyReader:readErrorMsg(),1.5,0.35)			
		end		
	elseif actionID == 5404 then
		local serverInfo = actionLayer._5404Callback(pScutScene, lpExternalData)	
		if   serverInfo ~= nil then 
			g_bossActtack.BossLiftNum =  serverInfo.CurrLifeNum 
			g_bossActtack.BossMaxLift  =  serverInfo.MaxLifeNum 
		end	
	elseif actionID == 5405 then
		local serverInfo = actionLayer._5405Callback(pScutScene, lpExternalData)	
		if serverInfo then
			startFight(serverInfo)
		end
	elseif actionID == 5406  then
		local serverInfo = actionLayer._5406Callback(pScutScene, lpExternalData)	
		if serverInfo ~= nil then
			if userData == 0 then--����
				g_LastRankList = serverInfo
				if _isShowLast then
					if #serverInfo.RecordTabel > 0 then
						lastTimeshowLayer()
					else
						ZyToast.show(pScutScene, Language.ACTIVE_NOLASTBOSS,1,0.2)
					end
				else
					setBeforeRank(serverInfo.RecordTabel)
				end
			elseif userData == 1 then--����
				g_rankList = serverInfo
				if #serverInfo.RecordTabel > 0 then
					tRankingFunc()
				end			
			end
		end			
	else
		commonCallback.networkCallback(pScutScene, lpExternalData)	
	end
end


