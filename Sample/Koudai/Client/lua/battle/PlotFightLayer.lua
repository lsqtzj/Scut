------------------------------------------------------------------
-- PlotFightLayer.lua
-- Author     : Zonglin Liu 
-- Version    : 1.0
-- Date       :   
-- Description: ս������
------------------------------------------------------------------

module("PlotFightLayer", package.seeall)
require("battle.BattleResult")--����ͨ������
require("scenes.SBattleResult")--ʥ����ͨ������
---------------------------------------


_scene = nil 		-- ����

--ÿ����ٶ�
local fightSpeed=pWinSize.height
--Ѫ������
local hpBar_LongLenth = ZyImage:imageSize("common/list_1032.png").width*0.95


--_battleType   ս������  nil��ͨ������ 1������,  2�ż�������3����boss , 4���ѽ���ս�� ,5ʥ����,6����

function setFightInfo(info, isOverCombat, battleType)
	_AllFightInfoTable=info
	IsOverCombat = isOverCombat
	
	_battleType = battleType
end

-- �ͷ���Դ
function releaseResource()
_overBtn = nil
isNotNpc = nil--�Ƿ�npc ����  �� �ж��Ƿ����ȹ�ֵ
_battleType=nil
ScutAnimation.CScutAnimationManager:GetInstance():ReleaseAllAniGroup()
end

--��ʼ����
function initResource()
	stopFightTag = false
	personalInfo=PersonalInfo.getPersonalInfo()
	if _AllFightInfoTable~=nil then
		_FiguresGeneralInfo=_AllFightInfoTable.AgainstTable
		_EnemyGeneralInfo=_AllFightInfoTable.DefendingTable
		_FightInfo=_AllFightInfoTable.FightProcessTable	
	end
	if _battleType == 1 or _battleType == 2 or _battleType == 4 then
		isNotNpc = true
	end
	
end;


-- ��ʼ��
function init(mainScene)

	initResource()
	_scene = mainScene
	_layer=CCLayer:create()
	-- ע�ᴥ���¼�
--	_layer.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHBEGAN, "PlotFightLayer.touchBegan")
--	_layer.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHMOVED, "PlotFightLayer.touchMove")
--	_layer.__CCTouchDelegate__:registerScriptTouchHandler(CCTOUCHENDED, "PlotFightLayer.touchEnd")
--	_layer:setIsTouchEnabled(true)
	_scene:addChild(_layer,3)
-----------------------------------------------�����
	_SpriteLayer=CCLayer:create()
	_SpriteLayer:setAnchorPoint(PT(0,0))
	_SpriteLayer:setPosition(PT(0,0))
	_layer:addChild(_SpriteLayer,0)
----����������ť
	quickOver()

----��ʼս��ѭ��
	_fightState = EnumFightState.EFightBegin
	fightEngine()	
end

----����������ť
function quickOver()
	-----������ ����ͨ���� ������ս���ӿ�
	if IsOverCombat ==1 then
		local overBtn = ZyButton:new(Image.image_button, nil, nil, Language.PLOT_JUMP, FONT_NAME, FONT_SM_SIZE)
		overBtn:setAnchorPoint(PT(0,0))
		overBtn:setPosition(PT(pWinSize.width*0.9975-overBtn:getContentSize().width, pWinSize.height*0.0025))
		overBtn:registerScriptHandler(JumpFightAction)
		overBtn:addto(_layer, 0)
		_overBtn = overBtn
	end
end


--����ս��
function JumpFightAction()
	_overBtn:setEnabled(false)
	stopFight()
end


----------ֹͣս��
function stopFight()
	_fightState = EnumFightState.ERoundEnd
	_curState = EnumAttackProcess.eAttackEnd
	stopFightTag = true
	_layer:stopAllActions()
	if _battleType == nil then
		battleScene.isQuickEnd(_AllFightInfoTable)
	else
		fightOver()
	end
end


---ս������
EnumFightState = {
	EFightBegin		= 0,	---ս����ʼ
	EFightDataInit 	= 1,	---���ݳ�ʼ��
	EShowEffect		= 2, ---��ʼ��Ч
	ERoundBegin 	= 3,	---�غϿ�ʼ
	ERoundEnd		= 4,	---�غϽ���
	EFightEnd 		= 5, ---ս������
}

function fightEngine()
	_fightState = _fightState + 1
	if _fightState == EnumFightState.EFightDataInit then
		---���ݳ�ʼ��----��������
		fightDataInit()
		initPlayerPosition()
	elseif _fightState == EnumFightState.EShowEffect then
		showFirstEffect()--��ʼ��Ч
	elseif _fightState == EnumFightState.ERoundBegin then
		playNextRound()
	elseif _fightState == EnumFightState.ERoundEnd then
		---һ��ս�����Ž���
		fightOver()
	end
end;


---ս�����ݳ�ʼ��
function  fightDataInit()
	_FightAroundIndex=0
end;

---��ʼ������
function  initPlayerPosition()
	--���û�м���  �� �з���Ϣ ս�����Ž���
	if _FiguresGeneralInfo==nil or _EnemyGeneralInfo == nil then
		_fightState = EnumFightState.ERoundBegin
		fightEngine()
		return
	end
	
	--����������
	for k, v in ipairs(_FiguresGeneralInfo) do
		if v and v.LiveNum>0 then
			v.Role = 0
		--	local headImg = string.format("smallitem/%s.png", v.AttGeneralHeadID)
			local headImg = string.format("battleHead/%s.png", v.AttGeneralHeadID)
			local name = v.AttGeneralName
			local level = nil
			local memberCallBack = ""
			local position = v.AttPosition		
			local pos=getProsPosition(position,true)
			local tag = k
			local quality = v.AttGeneralQuality
	
			local FiguresSprite=HumanCard:new()
			FiguresSprite:createPlayer(_SpriteLayer, headImg, speed, name, layerTag,Tag, quality)
			FiguresSprite:setPosition(pos.x, pos.y)				

			v.sprite=FiguresSprite
			if v.MomentumNum>=100 then
				FiguresSprite:MomentumMax()		
			end
			local hgBar=createHpLabel(v.LiveNum,v.LiveMaxNum)
			v.hgBar=hgBar
			hgBar:setPosition(PT(pos.x+FiguresSprite:getContentSize().width/2-hpBar_LongLenth/2,
			pos.y-hgBar:getContentSize().height))
			_SpriteLayer:addChild(hgBar,0)
		end
	end
	
	--�����з�����
	for k, v in ipairs(_EnemyGeneralInfo) do
		if  v and v.LiveNum>0 then
			v.Role = 1
	--		local headImg = string.format("smallitem/%s.png", v.AttGeneralHeadID)
			local headImg = string.format("battleHead/%s.png", v.AttGeneralHeadID)
			local name = v.AttGeneralName
			local level = nil
			local memberCallBack = ""
			local position = v.AttPosition
			local pos=getProsPosition(position,false)	
			local tag = k
			local layerTag = 0
			local quality = v.AttGeneralQuality
			
			local FiguresSprite=HumanCard:new()
			FiguresSprite:createPlayer(_SpriteLayer, headImg, speed, name, layerTag,Tag,quality)
			FiguresSprite:setPosition(pos.x, pos.y)				
			v.sprite=FiguresSprite				
			if v.MomentumNum>=100 then
				FiguresSprite:MomentumMax()		
			end
			local hgBar=createHpLabel(v.LiveNum,v.LiveMaxNum)
			v.hgBar=hgBar
			hgBar:setPosition(PT(pos.x+FiguresSprite:getContentSize().width/2-hpBar_LongLenth/2,
			pos.y-hgBar:getContentSize().height))
			_SpriteLayer:addChild(hgBar,0)
		end
	end

	local cardSize=CCSprite:create(P("common/list_1032.png"))
	---�����ȹ�
	local userItem,itemSize = creatPriorityItem(_AllFightInfoTable.UserTalPriority)
	userItem:setAnchorPoint(PT(0,0))
	local pos = getProsPosition(1, true)
	userItem:setPosition(PT(0, pos.y+cardSize:getContentSize().height+itemSize.height*0.2))
	_SpriteLayer:addChild(userItem,0)
	
	
	--�з��ȹ�
	local npcPriority = "???" 
	if isNotNpc then
		npcPriority = _AllFightInfoTable.NpcTalPriority
	end
	local npcItem,itemSize = creatPriorityItem(npcPriority)
	npcItem:setAnchorPoint(PT(0,0))
	local pos = getProsPosition(1, false)	
	npcItem:setPosition(PT(0, pos.y-itemSize.height*1.2))
	_SpriteLayer:addChild(npcItem,0)	

	delayExec(PlotFightLayer.fightEngine, 0.5)
end;

--�����ȹ�ֵ
function creatPriorityItem(num)
	local layer = CCLayer:create()
	local sprite = CCSprite:create(P("battle/list_1136.png"))
	sprite:setAnchorPoint(PT(0,0))
	sprite:setPosition(PT(0,0))
	layer:addChild(sprite, 0)
	local numStr = ""
	if num then
		numStr = num
	end
	local numLabel = CCLabelTTF:create(numStr, FONT_NAME, FONT_SM_SIZE)
	numLabel:setAnchorPoint(PT(0,0.5))
	numLabel:setPosition(PT(sprite:getContentSize().width, sprite:getContentSize().height*0.5))
	layer:addChild(numLabel, 0)
	
	layerSize = SZ(sprite:getContentSize().width+numLabel:getContentSize().width, sprite:getContentSize().height)
	
	return layer,layerSize
end

--����Ѫ��
function  createHpLabel(Hp,maxHp)
	local scale=Hp/maxHp
	if scale>1 then
		scale=1
	elseif scale>0 and scale < 0.05 then
		scale = 0.05 
	end
	local longLenth=hpBar_LongLenth*Hp/maxHp
	local sprite=CCSprite:create(P("common/list_5003.9.png"))
	sprite:setAnchorPoint(PT(0,0))
	sprite:setScaleX(longLenth/sprite:getContentSize().width)
	return sprite
end;
	
--��ȡ�����λ��
function getProsPosition(location, bEnd)
	local startX=0
	local startY=SY(3)	

	startX = pWinSize.width*0.1+pWinSize.width*0.3*((location-1)%3)
	
	if bEnd then---   true  or false
		startY=pWinSize.height*0.25-math.floor((location-1)/3)*pWinSize.height*0.18
	else
		startY=pWinSize.height*0.615+math.floor((location-1)/3)*pWinSize.height*0.18
	end
	return PT(startX,startY)
end

--��ʼ��Ч��ʾ
function showFirstEffect()
---[[
	_showFirstEffectNum = 0
	_fristEffectNum = 0
	
	for k, v in pairs(_AllFightInfoTable.FirstEffectTabel) do
		_fristEffectNum = _fristEffectNum+1
	end

	_AllFightInfoTable.FirstEffectTabel = resetData(_AllFightInfoTable.FirstEffectTabel)


	_FirstEffectTabel = {}
	if _fristEffectNum > 0 then
		_isFirstShow = true
		for k, v in pairs(_AllFightInfoTable.FirstEffectTabel) do
			for n,m in ipairs(v.RecordTabel) do
				local actionLayer = CCLayer:create()
				actionLayer:setTag(#_FirstEffectTabel+1)
				_SpriteLayer:addChild(actionLayer, 0)
				m.lalyer = actionLayer
				
				_FirstEffectTabel[#_FirstEffectTabel+1]=m	
				
				local delayNum = 0.01+(n-1)*0.99
				delayExec(PlotFightLayer.showSingleFirstEffect, delayNum, actionLayer)
				
			end	
		end	
	else
		fightEngine()
	end
	
	
--]]
--fightEngine()
end

function resetData(info)
	local mRecordTabel = {}
	for k,v in ipairs(info) do
		if v.RecordTabel == nil then
			v.RecordTabel = {}
			v.RecordTabel[1]  = v
		end
	end
	
	
	for k,v in ipairs(info) do
		local isHave = true
		for m,n in ipairs(mRecordTabel) do
			if v.Position == n.Position and v.Role == n.Role then
				n.RecordTabel[#n.RecordTabel+1] = v
				isHave = false
			end
		end
		
		if isHave then
			mRecordTabel[#mRecordTabel+1] = v
		end
	end
	return mRecordTabel
end




function showSingleFirstEffect(pNode, index)
	local tag = nil
	if index then
		tag = index
	else
		tag = pNode:getTag()
	end
	v = _FirstEffectTabel[tag]
	local sprite,info = getSpirte(v.Role ,v.Position)
	local strImg = string.format("skilltitle/%s.png", v.FntHeadID)
	showContent(nil,sprite, strImg)
	local attribuAni=ScutAnimation.CScutAnimationManager:GetInstance():LoadSprite(v.EffectID1)
	attribuAni:registerFrameCallback("PlotFightLayer.finishAnimation")
--	attribuAni:setAnchorPoint(PT(0.5,0.5))
	local defPos = sprite:getPosition()
	attribuAni:setPosition(PT(defPos.x+sprite:getContentSize().width*0.5, defPos.y))	
	_SpriteLayer:addChild(attribuAni, 1)
	attribuAni:play()
	
end


--�������ƶ�
---[[
--����������ɺ� 
function finishAnimation(pSprite, curAniIndex, curFrameIndex, nPlayingFlag)
	if nPlayingFlag == 2 then
		pSprite:registerFrameCallback("")
		delayRemove(pSprite)
	end
end

function delayRemove(sprite)
	if sprite ~= nil then
		local delayAct = CCDelayTime:create(0.1)
		local funcName = CCCallFuncN:create(PlotFightLayer.removeTmpSprite)
		local act = CCSequence:createWithTwoActions(delayAct,funcName)
		sprite:runAction(act)
		sprite = nil
	end
	_showFirstEffectNum=_showFirstEffectNum+1
	if _showFirstEffectNum >= _fristEffectNum then
		_FirstEffectTabel=nil
		fightEngine()
	end
end

--�꼼�����������
function removeTmpSprite(sprite)
	local tag = sprite:getTag()
	if sprite ~= nil then
		sprite:removeFromParentAndCleanup(true)
		sprite = nil
	end
--	local currentFightSprite=_fighterInfo.sprite
--	if _CurrentAroundInfo.MomentumNum>=100 then
--		currentFightSprite:MomentumMax()
--	else
--		currentFightSprite:MomentumNotMax()
--	end
--		
--  	DefInjury()
end
--]]




--������һ�غ��ж�
function  playNextRound()

	if _fightState == EnumFightState.EFightEnd then
		return false
	end
	_FightAroundIndex=_FightAroundIndex+1
	_CurrentAroundInfo=_FightInfo[_FightAroundIndex]
	if _FightInfo and _FightAroundIndex > #_FightInfo then
		--��һ����
		fightEngine()
	else
		--���ŵ�ǰ�غ϶���
		playCurRoundAnimate()
	end;
end;




--��������
EnumAttackProcess = {
	eAttackBegin 		= 0,--�����غϿ�ʼ
	eShowEffect			= 1,--��ʾdebuffЧ��
	eTriggerEffect		= 2,--��������
	eMoveToRival 		= 3,--�ƶ�
	eAttackAnimate 		= 4,--��������
	eDefTrigger			= 5,--���ط���������
	eAttackBackMove	= 6,--�����ƶ�
	eAttackBackAnimate	= 7,--��������
	eAttackBackReplace	= 8,	--���ڷ���  �油Ӷ���ϳ�
	eAttackEnd			= 9,--�����غϽ���
}


local fightProcessDefend={}
local fightProcessFighter={}



---���ŵ�ǰ�غ϶���
function playCurRoundAnimate()
	initCurRoundData()
	normalAttackProcess()
end;

----��ʼ��ս������
function initCurRoundData()
	_fighterInfo={}
	_defendInfo={}
	
	effectTimes=0--Ч�����Ŵ���
	_curState=0--ս���غϽ׶�
	
	
	---״̬Ϊһ�غ�ս���Ŀ�ʼ
	_curState=EnumAttackProcess.eAttackBegin
	
	---��ȡ������ ���� ����Ϣ
	local sprite, info =getSpirte(_CurrentAroundInfo.Role,_CurrentAroundInfo.Position)
	_fighterInfo = info

	---�жϷ��ط��Ƿ������� û�����ݽ������غ�
	if _CurrentAroundInfo.DefendFightTable~=nil and #_CurrentAroundInfo.DefendFightTable >0  then
		--	1	����	 --2	���򹥻�3	���򹥻� 4	ȫ�幥��
		---���ط������Ƕ�� ���������������
		for k, v in pairs(_CurrentAroundInfo.DefendFightTable) do
			local sprite, info=getSpirte(v.Role, v.Position)
			if sprite and info then
				local num = #_defendInfo+1 			
				_defendInfo[num]={}
				_defendInfo[num].spriteInfo = info
				_defendInfo[num].defInfo = v
			end
		end
	else
		--û��debuff��غ�ֱ�ӽ���
		if _CurrentAroundInfo.GeneralEffects~=nil and #_CurrentAroundInfo.GeneralEffects>0 then	
		else
			_curState= EnumAttackProcess.eAttackEnd
		end
	end	
end;

--�����׶�����
function normalAttackProcess()
	if stopFightTag then
		return
	end
	_curState = _curState + 1 ---������һ״̬
	if _curState == EnumAttackProcess.eShowEffect then--��ʾdebuffЧ��---------------�ж� Ч�� ���ж��� ״̬
		local currentSprite=_fighterInfo.sprite
		local currentFightInfo=_fighterInfo
		_hpNum = 0--��Ѫ����Ч����
		_isSHowHpNum = 0--����ʾ����
		for k, v in pairs(_CurrentAroundInfo.GeneralEffects) do
			if v.ConDamageNum and v.ConDamageNum > 0 then
				_hpNum = _hpNum+1
			end
		end
		
		local delayNum = 0
		currentSprite:releaseEffectImage()
		if _CurrentAroundInfo.GeneralEffects and #_CurrentAroundInfo.GeneralEffects>0 then
			for k, v in pairs(_CurrentAroundInfo.GeneralEffects) do
				UpAttribute(v.GeneralEffect,v.IsIncrease,currentSprite)
				currentSprite:addEffectImage(v.GeneralEffect)
				if v.ConDamageNum and v.ConDamageNum > 0 then
					delayNum = delayNum+1
					local fun = "PlotFightLayer.afterShowAttribute"
					showHurtHp(v.ConDamageNum, currentFightInfo, currentSprite, fun, nil, delayNum)		
				end
			end
		end
		if _hpNum > 0 then
			
		else
			delayExec(PlotFightLayer.normalAttackProcess, 0.1)
		end
	elseif _curState == EnumAttackProcess.eTriggerEffect then--��������������
		delayExec(PlotFightLayer.normalAttackProcess, 0.1)
   	elseif _curState == EnumAttackProcess.eMoveToRival then--Ӷ����������
   		--�Ƿ��б��������� ���� ���Ź�������   
   		if #_defendInfo > 0 then
   			_fighterInfo.sprite:attack()
   			delayExec(PlotFightLayer.normalAttackProcess, 0.1)
   		else
			--���û�й���Ŀ��ֱ�ӽ�����һ�غ�
			delayExec(PlotFightLayer.playNextRound, 0.1)
   		end
	elseif _curState == EnumAttackProcess.eAttackAnimate then--��������
		if #_defendInfo > 0 then
			---���Ź�������
		   	playNormalAttackAnimate()
		else
			--���û�й���Ŀ��ֱ�ӽ�����һ�غ�
			delayExec(PlotFightLayer.playNextRound, 0.1)
		end			
	elseif _curState == EnumAttackProcess.eDefTrigger then--������������
		delayExec(PlotFightLayer.normalAttackProcess, 0.01)
	elseif _curState == EnumAttackProcess.eAttackBackMove then--������������
		local fangJiAction= fightBackAction()--������������ʾ��������

		if not fangJiAction  then
			_curState = EnumAttackProcess.eAttackEnd	
			delayExec(PlotFightLayer.normalAttackProcess, 0.01)
		end
	elseif _curState == EnumAttackProcess.eAttackBackAnimate then----��������
		_curState = EnumAttackProcess.eAttackEnd
		delayExec(PlotFightLayer.normalAttackProcess, 0.01)
	elseif  _curState == EnumAttackProcess.eAttackBackReplace then--�������� �滻Ӷ��
		delayExec(PlotFightLayer.normalAttackProcess, 0.1)		
	elseif _curState == EnumAttackProcess.eAttackEnd then--ս������
		delayExec(PlotFightLayer.playNextRound, 0.1)
	else
		delayExec(PlotFightLayer.playNextRound, 0.1)
	end
end

function UpAttribute(state,upOrdown,sprite)

--[[2������    3�꼼����     4ħ������     5�������     6�꼼����     7ħ������
8����     9����    10�ƻ�    11����    12����      13��      14��ɱ       22����
--]]
	local attributeTable={[2]="icon_7220",[3]="icon_7219",[4]="icon_7222",
	[5]="icon_7214",[6]="icon_7221",[7]="icon_7223",[8]="icon_7213",[9]="icon_7211",
--		[10]="icon_7220",[11]="icon_7220",--10�ƻ�    11����û��
	[12]="icon_7212",[13]="icon_7210",
	--	[14]="icon_7210",-- 14��ɱû��
	[22]="icon_7224"
	}
	---1�½�  2 ����
	local stateTable={"battle/icon_7209.png","battle/icon_7208.png"}
	if not attributeTable[state] or not stateTable[upOrdown+1] then
		return
	end
	
	local attribuImg = string.format("battle/%s.png", attributeTable[state])
	local attribuAni = CCSprite:create(P(attribuImg))
	attribuAni:setAnchorPoint(PT(0,0))
	attribuAni:setPosition(PT(sprite:getPosition().x+sprite:getContentSize().width*0.5,sprite:getPosition().y+sprite:getContentSize().height*0.6))
	sprite:getParent():addChild(attribuAni, 0)
	

	local stateAni= CCSprite:create(P(stateTable[upOrdown+1]))
	stateAni:setAnchorPoint(PT(0,0))
	local position = PT(attribuAni:getContentSize().width*1.1,-stateAni:getContentSize().height*0.3)
	stateAni:setPosition(position)
	attribuAni:addChild(stateAni,0)
	
	position.y = attribuAni:getContentSize().height*0.5
	
	local action1 = CCMoveTo:create(0.5, position)
	local action2 = CCFadeOut:create(0.5)--����
	local funcName = CCCallFuncN:create(PlotFightLayer.UpAttributeOver)
	local action3 = CCSequence:createWithTwoActions(action2,funcName)
	local actionHarm=CCSequence:createWithTwoActions(action1,action3)
	stateAni:runAction(actionHarm)		

end

function UpAttributeOver(stateAni)
	if stateAni then
		attribuAni = stateAni:getParent()		
		stateAni:getParent():removeChild(stateAni, true)
		stateAni = nil	
		attribuAni:getParent():removeChild(attribuAni, true)
		attribuAni = nil
	end
	if _isFirstShow then
		_showFirstEffectNum = _showFirstEffectNum+1
		if _fristEffectNum >= _showFirstEffectNum then
			_isFirstShow = false
			fightEngine()
		end
	end
end

--Ч����Ѫ�� �����ж�
function afterShowAttribute(pNode)
	if pNode then
		pNode:getParent():removeChild(pNode, true)
		pNode = nil
	end
	_isSHowHpNum = _isSHowHpNum+1
	if _isSHowHpNum >=_hpNum then
		if _fighterInfo.LiveNum <= 0 then
			_fighterInfo.sprite:setVisible(false)
			local pos = _fighterInfo.sprite:getPosition()
			
			local tombstoneImg = CCSprite:create(P("battle/list_1163.png"))
			tombstoneImg:setAnchorPoint(PT(0,0))
			tombstoneImg:setPosition(pos)
			_layer:addChild(tombstoneImg,0)		
		end
		delayExec(PlotFightLayer.normalAttackProcess, 0.1)
	end
end

function nextAction()
	if _curState > 0 and _curState < 9 then
		delayExec(PlotFightLayer.normalAttackProcess, 0.1)
	else
		delayExec(PlotFightLayer.playNextRound, 0.1)
	end
end;

-----------------------
--����
function attackMove(sprite)
	sprite:attack()	
end;

-------------------

-----���Ź�������
function playNormalAttackAnimate()
	local currentFightSprite=_fighterInfo.sprite
	local pos=PT(currentFightSprite:getPosition().x+currentFightSprite:getContentSize().width/2,currentFightSprite:getPosition().y+currentFightSprite:getContentSize().height/2)
	_CurrentAroundInfo.MomentumNum=_CurrentAroundInfo.AttGeneralQishi
	defendCount = 0
		local skillSpr = "skill_1000"--��ͨ����
		if _CurrentAroundInfo.AttEffectID then--�꼼����
			skillSpr = _CurrentAroundInfo.AttEffectID	
			--��������ͼƬ
			local strImg = string.format("skilltitle/%s.png", _CurrentAroundInfo.FntHeadID)
			showContent(nil,currentFightSprite, strImg)
		end
	
		local tag=1
		if _defendInfo and  #_defendInfo>1 then
			tag=2
		end
		local defSprite = _defendInfo[tag].spriteInfo.sprite
		local defPos=PT(defSprite:getPosition().x+defSprite:getContentSize().width/2,defSprite:getPosition().y)		

		--��������
		local skillSprite=Human:new()		
		skillSprite:createNpc(_SpriteLayer,skillSpr,nil,nil,pos.x,pos.y, 1)
		if _fighterInfo.Role == 1 then
			skillSprite:setScaleY(-1)
			skillSprite:setAnchorPoint(0, 1)
		end
		_skillSprite = skillSprite		
		--�����ƶ�
		skillMove(skillSprite, defSprite)

end;

--�꼼������ʾ
function  showContent(str,sprite,pic)
	if sprite~=nil and (str or pic) then
		local label = nil
		if str~=nil then
			label=CCLabelTTF:create(str,FONT_NAME,FONT_SM_SIZE)
			label:setColor(ZyColor:colorYellow())
		else
			label = CCSprite:create(P(pic))
		end
		label:setAnchorPoint(PT(0.5,0))
		label:setOpacity(255)
		_SpriteLayer:addChild(label,sprite:getZOrder()+1)
		local position = CCPoint(sprite:getPosition().x+sprite:getContentSize().width*0.5, sprite:getPosition().y+sprite:getContentSize().height*0.05)
		
		label:setPosition(position)
		label:setVisible(true)
		position.y = position.y + sprite:getContentSize().height*0.8
		local action1 = CCMoveTo:create(0.5, position)
		local action3 = CCFadeOut:create(1)
		local funcName = CCCallFuncN:create(PlotFightLayer.finishLabelShow)
		local action3 = CCSequence:createWithTwoActions(action3,funcName)
		local actionHarm=CCSequence:createWithTwoActions(action1,action3)
		label:runAction(actionHarm)
	end
end;

--�꼼������ʾ����
function  finishLabelShow(sprite)
    if sprite ~= nil then
        sprite:removeFromParentAndCleanup(true)
        sprite = nil
    end
end;


--�����ƶ�

--�����ƶ�
function skillMove(skillSprite, defSprite)	

	local currentDefSprite=defSprite
	local pos=currentDefSprite:getPosition()

--		---�ж��Ǵ������ȥ

	pos.x = pos.x+currentDefSprite:getContentSize().width/2
	pos.y = pos.y
	if _fighterInfo.Role == 1 then
		pos.y = pos.y+currentDefSprite:getContentSize().height/2
	end
	
	local oldPos=_fighterInfo.sprite:getPosition()
	
	--
	local time=math.abs(pos.y-oldPos.y)/fightSpeed
   	local actionBy = CCMoveTo:create(time, pos)
	local funcName = CCCallFuncN:create(PlotFightLayer.skillMoveEnd)
	local act = CCSequence:createWithTwoActions(actionBy,funcName)
-----	���þ������ʾ�㼶
	skillSprite:runAction(act)

	
end;

--�����ƶ�����
function skillMoveEnd()

	_skillSprite:remove()

	local currentFightSprite=_fighterInfo.sprite
	if _CurrentAroundInfo.MomentumNum>=100 then
		currentFightSprite:MomentumMax()
	else
		currentFightSprite:MomentumNotMax()
	end
		
  	DefInjury()
  	
end;

---���ط�����
function DefInjury()
	--���ط���������Ϣ

	for k,v in ipairs(_defendInfo) do
		local defInfo= v.defInfo
		local spriteInfo = v.spriteInfo
		local sprite = spriteInfo.sprite	
		
		if defInfo.IsShanBi == 1 then--�Ƿ�����
			local func = PlotFightLayer.afterDefend
			sprite:dodge(func)
			showContent(nil,sprite, "battle/icon_7212.png")
		else
			if defInfo.IsGeDang==1 then--�Ƿ��
				showContent(nil,sprite, "battle/icon_7210.png")
			elseif defInfo.IsBaoji==1  then--�Ƿ񱩻�
				showContent(nil,sprite, "battle/icon_7213.png")
			end
			
			local LiveNum = defInfo.TargetGeneralLiveNum
			local hurtNum = defInfo.TargetDamageNum
			local labelHarm = defInfo._labelHarm
			


			local funcName =PlotFightLayer.JudgeDefendIfDead
			local tag = k			
	
			if hurtNum and  hurtNum ~= 0 then
				showHurtHp(hurtNum, spriteInfo, sprite, funcName, tag)
			else
				JudgeDefendIfDead(nil, tag)
			end

	--		--debuff
			if defInfo.GeneralEffects and #defInfo.GeneralEffects >0 then
				sprite:releaseEffectImage()
				for k,v in ipairs (defInfo.GeneralEffects) do
					sprite:addEffectImage(v.GeneralEffect)
					UpAttribute(v.GeneralEffect,v.IsIncrease,sprite)
				end
			end
		end

	end
end

--��ѪЧ��
function showHurtHp(hurtNum, currentInfo, sprite, fun, tag, delayNum)

	currentInfo.LiveNum=currentInfo.LiveNum-hurtNum
	if currentInfo.LiveNum> currentInfo.LiveMaxNum then
		currentInfo.LiveNum=currentInfo.LiveMaxNum
	end
	if currentInfo.LiveNum<0 then
	     currentInfo.LiveNum=0
	end
	
	local labelHarm = nil--��Ѫ����Ѫ ����
	if hurtNum >= 0 then
		labelHarm = getNumberSprite(hurtNum, 1)
	else
		labelHarm = getNumberSprite(hurtNum, 2)
	end
	local position = CCPoint(sprite:getPosition().x, sprite:getPosition().y+sprite:getContentSize().height*0.5)
	labelHarm:setPosition(position)
	labelHarm:setVisible(true)
	_SpriteLayer:addChild(labelHarm,sprite:getZOrder()+1)
	
	
	if tag then
		labelHarm:setTag(tag)
	end
	sprite:defend()
	position.y =sprite:getPosition().y+sprite:getContentSize().height*0.8
	local action1 = CCMoveTo:create(0.35, position)
	local action2 = CCFadeOut:create(0.1)--����
	local funcName = CCCallFuncN:create(fun)
	local action3 = CCSequence:createWithTwoActions(action2,funcName)
	local actionHarm=CCSequence:createWithTwoActions(action1,action3)
	
	if delayNum == nil then
		delayNum = 0
	end
	local delayTime = 0.01+delayNum*0.2
	
	local action = CCSequence:createWithTwoActions(CCFadeOut:create(delayTime), actionHarm)
	labelHarm:runAction(action)	

	local hgBar = currentInfo.hgBar
	if hgBar then		
		local nScale = currentInfo.LiveNum/currentInfo.LiveMaxNum
		if nScale > 0 then
			if nScale>0 and nScale < 0.05 then--ֵ̫С�� ���Ż᲻��
				nScale = 0.05
			elseif nScale > 1 then
				nScale = 1
			end
			hgBar:setScaleX(nScale*hpBar_LongLenth/hgBar:getContentSize().width)
		else
			hgBar:setVisible(false)
		end
	end
end


--�жϱ��������Ƿ�����
function JudgeDefendIfDead(pNode, index)
	local tag = nil
	if index then
		tag = index
	else
		tag = pNode:getTag()
	end
	if tag then
		if _defendInfo[tag].defInfo.TargetGeneralLiveNum <= 0 then
			_defendInfo[tag].spriteInfo.sprite:setVisible(false)
			local pos = _defendInfo[tag].spriteInfo.sprite:getPosition()
			
			local tombstoneImg = CCSprite:create(P("battle/list_1163.png"))
			tombstoneImg:setAnchorPoint(PT(0,0))
			tombstoneImg:setPosition(pos)
			_layer:addChild(tombstoneImg,0)	
			
		end	
		
		if _defendInfo[tag].defInfo.TargetGeneralQishi >= 100 then
			_defendInfo[tag].spriteInfo.sprite:MomentumMax()
		else
			_defendInfo[tag].spriteInfo.sprite:MomentumNotMax()		
		end
	end
	
	
	if pNode then
		pNode:getParent():removeChild(pNode, true)
		pNode = nil
	end
	afterDefend()
end


--������֮��  �ж��Ƿ������һ�׶�
function afterDefend()
	defendCount = defendCount+1
	
	--���б�������Ҳ������
	if defendCount >= #_defendInfo then
		delayExec(PlotFightLayer.normalAttackProcess, 0.1)
	end
end


---�ӳٽ��з���
function delayExec(funName,nDuration,parent)
	local  action = CCSequence:createWithTwoActions(
	CCDelayTime:create(nDuration),
	CCCallFuncN:create(funName));
	local layer = _layer
	if parent then
		layer=parent
	end
	if layer then
		layer:runAction(action)
	end	
end

-----��ȡ����
function  getSpirte(role,position)
	if role ~=nil then 
		local generalInfo=_FiguresGeneralInfo
		if role==1 then
			generalInfo=_EnemyGeneralInfo
		end
		for k, v in ipairs(generalInfo) do
			if v and v.AttPosition==position and v.LiveNum > 0 then
				return v.sprite,v
			end
		end
	end
	return false
end;


--ս������
function fightOver()
	if _battleType == nil then
		battleScene.roundOver(_AllFightInfoTable)
	elseif _battleType == 1 or _battleType == 2  or _battleType == 4  or _battleType==7 then--������
		CompetitiveBattle.battleOver(_AllFightInfoTable)
	elseif _battleType == 3 then--����boss
		WorldBossToScene.battleOver(_AllFightInfoTable)
	elseif _battleType == 5 then--ʥ����
		SbattleScene.roundOver(_AllFightInfoTable)
	elseif _battleType == 6 then--����
		RbattleScene.roundOver(_AllFightInfoTable)
	end
end

--������������
function fightBackAction()
	local fangJiAction = false
	local defSprite = _fighterInfo.sprite
	
	_fightBackSkillSprite = {}
	_attackBackNum = 0
	for k, v in pairs(_defendInfo) do
		if v.defInfo.IsFangji==1 then
			fangJiAction=true
			_attackBackNum=_attackBackNum+1	
			
			
			local sprite=v.spriteInfo.sprite
			sprite:attack()
			showContent(nil,sprite, "battle/icon_7225.png")
		
			local pos = sprite:getPosition()
			
				--��������
			local skillSpr = "skill_1000"--��ͨ����
			local skillSprite=Human:new()		
			skillSprite:createNpc(_SpriteLayer,skillSpr,nil,nil,pos.x,pos.y, 1)
			if v.spriteInfo.Role == 1 then
				skillSprite:setScaleY(-1)
				skillSprite:setAnchorPoint(0, 1)
			end
			skillSprite:setSpriteTag(k)
			
			_fightBackSkillSprite[k] = skillSprite
		
			--�����ƶ�
			AttackBackMove(skillSprite, defSprite)
		
		end
	end
	
	return fangJiAction
end

--���������ƶ�
function AttackBackMove(skillSprite, defSprite)	

	local currentDefSprite=defSprite
	local pos=currentDefSprite:getPosition()

--		---�ж��Ǵ������ȥ

	pos.x = pos.x+currentDefSprite:getContentSize().width/2
	pos.y = pos.y
--	if _fighterInfo.Role == 0 then
--		pos.y = pos.y
--	end
	
	local oldPos=skillSprite:getPosition()
	
	--
	local time=math.abs(pos.y-oldPos.y)/fightSpeed
   	local actionBy = CCMoveTo:create(time, pos)
	local funcName = CCCallFuncN:create(PlotFightLayer.endForAttackBack)
	local act = CCSequence:createWithTwoActions(actionBy,funcName)
-----	���þ������ʾ�㼶
	skillSprite:runAction(act)

end

function endForAttackBack(pNode)
	local tag = pNode:getTag()

	_fightBackSkillSprite[tag]:remove()
		
	local hurtNum = _defendInfo[tag].defInfo.FangjiDamageNum
	showHurtHp(hurtNum, _fighterInfo, _fighterInfo.sprite, PlotFightLayer.judgeFightBackDeath, tag, delayNum)
end

--���������ж�
function judgeFightBackDeath(pNode)
	if pNode then
		pNode:getParent():removeChild(pNode, true)
		pNode = nil
	end
	_attackBackNum = _attackBackNum-1
	if  _attackBackNum <= 0 then
		if _fighterInfo.LiveNum <= 0 then
			_fighterInfo.sprite:setVisible(false)
			local pos = _fighterInfo.sprite:getPosition()
			
			local tombstoneImg = CCSprite:create(P("battle/list_1163.png"))
			tombstoneImg:setAnchorPoint(PT(0,0))
			tombstoneImg:setPosition(pos)
			_layer:addChild(tombstoneImg,0)		
		end
		delayExec(PlotFightLayer.normalAttackProcess, 0.01)
	end
end

function judgeFangji()
	local isFangji = false
	for k,v in ipairs(_AllFightInfoTable.FightProcessTable) do
		for n,m in ipairs(v.DefendFightTable) do
			if m.IsFangji == 1 then
				isFangji = true
			end
		end
	end
	
	if isFangji then
		ZyToast.show(_layer, "fangji", 1, 0.5)
	else
		ZyToast.show(_layer, "no fangji", 1, 0.5)
	end
end
