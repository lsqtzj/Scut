------------------------------------------------------------------
-- PersonalInfo.lua
-- Author     : ChenJM
-- Version    : 1.15
-- Date       :   
-- Description: ��ɫ��Ϣ��,
------------------------------------------------------------------
---�����û�������������Ϣ---
require("lib.lib")
module("PersonalInfo", package.seeall)
my_ID=10000

local mPersonalInfo = {
	-----��ɫ��Ϣ
	_CityID=nil,--����ID
	_PointX=nil,
	_PointY=nil,
	_GeneralID=nil, --Ӷ��id
	_NickName      = nil,            --��ɫ����
	_GuideId=nil,
	_UserType=nil,           --�û�����
	_UserLv        =0,               --��ɫ�ȼ�
	_CareerID=nil,--ְҵID
	_Sex   =nil,     --�Ա�0��1Ů
	_HeadID     =1,               --��ɫͷ��
	_GoldNum=0,                    --��ʯ
	_GameCoin=0  ,                 --���
	_LifeNum=0 ,                   --��ǰ����
	_MaxLifeNum=0,                 --��ǰ��������
	_CountryID=0,
	_CountryID  =0,    --����ID
	_ItemLiveNum =0,       
	_ItemLiveMaxNum=0,   
	_WizardNum=0, --��������
	
	_EnergyNum=0,
	_MaxEnergyNum=0,
	_CurrExperience=0,
	_MaxExperience=0,
	_VipLv=0,
	_userID=nil,
	equip_level_MAX=90,  --װ��ǿ�����ȼ�
	_sprite=nil,--��ɫ����
	_speed=nil,--��ɫ�ƶ��ٶ�
	_GuildID=nil,--����ID GuildID
	_DataTabel_3003=nil,--
	_UserLocation=nil,--������ڵ�  1������ 2��������
	_BlessTable=nil,
	_UserExp = nil, --�������
	_UserStatus= nil,--���״̬UserStatus
	_PlotID= nil,--����ID
	_PictureID=nil,--��������ͼƬ
	_PictureTime =nil--����ʣ�����ʱ��
	,_Pid,
	VipNextCold=0,
	_SurplusEnergy=nil,
	FunEnum = nil,--�Id
	_Wings=nil,
	_PlotStatusID = nil,--����id
	_MercenarySeq = nil,--��������
	_CardUserID=nil,--ӭ�¿�	
	_IsChampion=nil,--�Ƿ���ս�ھ�
	Shengjita=nil,--�Ƿ���ʥ��������
	Exchange=nil,--�ɶһ�����
	Receive=nil,--����ȡ����
	EffNum=nil,--4402���뵥�����Ҫ���Ĳ���
	fightinfo=nil,--ս����Ϣ����������һ��
	Score=nil,--
	StarNum=nil,--
	HasNextBoss=nil,--�������Ƿ����¸�boss
	g_currentActiveID=nil,--�����м�¼�ϴ�ѡ��
	plotid=nil,--��ס�ż�ѡ�����ĸ�ͼ
	fuben_1=nil,--��ס���Ǹ�������ͼ
}

npc_state_={}

function getPersonalInfo()
	return mPersonalInfo
end

function setPersonalInfo(info)
	--����ID
	mPersonalInfo._CityID=info.CityID;	
	--Ӷ��id
	mPersonalInfo._GeneralID=info.GeneralID;	
	--����ID
	mPersonalInfo._GuildID=info.GuildID;	  
	--�ǳ�
	mPersonalInfo._NickName=info.NickName;
	--�ȼ�
	if mPersonalInfo._UserLv~=nil and 
		mPersonalInfo._UserLv~=0 and
		info.UserLv-mPersonalInfo._UserLv>0 
	then
--		MainMapLayer.playerLevelUp()
	end
	mPersonalInfo._UserLv=info.UserLv;
	---ְҵid
	mPersonalInfo._CareerID=info.CareerID;
	mPersonalInfo._Sex=info.Sex;
	mPersonalInfo._HeadID=info.HeadID;
	--��ʯ
	mPersonalInfo._GoldNum=info.GoldNum;
	--���
	mPersonalInfo._GameCoin=info.GameCoin;
	--��ǰ����
	mPersonalInfo._LifeNum=info.LifeNum		
	--��ǰ��������
	mPersonalInfo._MaxLifeNum=info.MaxLifeNum;
	--��ǰ����
	mPersonalInfo._EnergyNum=info.EnergyNum;
	--��ǰ��������
	mPersonalInfo._MaxEnergyNum=info.MaxEnergyNum;
	--	��ǰ����
	mPersonalInfo._CurrExperience=info.CurrExperience;
	--	������������
	mPersonalInfo._MaxExperience=info.MaxExperience;
	--	Vip�ȼ�
	mPersonalInfo._VipLv=info.VipLv;
	--	���ڹ���
	mPersonalInfo._CountryID=info.CountryID;
	--	Ѫ����ʣ��ֵ
	mPersonalInfo._ItemLiveNum=info.ItemLiveNum;
	--	Ѫ�������ֵ
	mPersonalInfo._ItemLiveMaxNum=info.ItemLiveMaxNum;
	--ף��
	mPersonalInfo._BlessTable=info.BlessTable;
	---������ڵ�
	mPersonalInfo._UserLocation=info.UserLocation
	--	�������
	mPersonalInfo._UserExp = info.UserExp
	--	���״̬
	mPersonalInfo._UserStatus = info.UserStatus
	--	ɨ������ID
	mPersonalInfo._PlotID = info.PlotID
	--	����
	mPersonalInfo._PictureID=info.PictureID	
	--����,ʱ���Ƿ�����
	mPersonalInfo._PictureTime=info.PictureTime
	-----	
	mPersonalInfo.VipNextCold=info.DemandGold
	mPersonalInfo._SurplusEnergy=info.SurplusEnergy
	if info.IsHelper and info.IsHelper~=0  then
		accountInfo.setHelpShow(info.IsHelper)
	end
	---
	--����id
	mPersonalInfo._PlotStatusID=info.PlotStatusID
	--������������
	mPersonalInfo._MercenarySeq=info.MercenarySeq
	
	--���¿���
	mPersonalInfo._CardUserID=info.CardUserID
	
	--�Ƿ���ս�ھ�
	mPersonalInfo._IsChampion = info.IsChampion
	
	--����Ӷ��
	mPersonalInfo._BattleNum = info.BattleNum
	
	--������Ӷ��
	mPersonalInfo._TotalBattle = info.TotalBattle
	

	--�����ָ�ʱ�� 
	mPersonalInfo._Rstore  = info.Rstore 
	
	--ȫ�������ָ�ʱ��
	mPersonalInfo._TotalRstore  = info.TotalRstore

	mPersonalInfo._HonourNum = info.HonourNum
	
	mPersonalInfo._NextHonourNum = info.NextHonourNum
	
	
	mPersonalInfo._CombatNum = info.CombatNum
	
	mPersonalInfo._TalPriority = info.TalPriority
	
	mPersonalInfo._IsLv = info.IsLv

	mPersonalInfo._EnergyNum = info.EnergyNum
	
	mPersonalInfo._unReadCount = info.unReadCount
	
	mPersonalInfo._WizardNum = info.WizardNum
	
	
	mPersonalInfo.Shengjita = info.Shengjita
	
	mPersonalInfo.Exchange = info.Exchange
	
	mPersonalInfo.Receive = info.Receive
	
	mPersonalInfo.EffNum = info.EffNum
	
	mPersonalInfo.fightinfo = info.fightinfo
	
	mPersonalInfo.Score=info.Score
	
	mPersonalInfo.StarNum=info.StarNum
	
	mPersonalInfo.HasNextBoss=info.HasNextBoss
	
	mPersonalInfo.g_currentActiveID=info.g_currentActiveID
	
	mPersonalInfo.plotid=info.plotid
	
end


function  setTaskBackValue(serverInfo)
    if serverInfo~=nil then
	if  serverInfo.UserLv-mPersonalInfo._UserLv>0 
	then
			MainMapLayer.playerLevelUp()
	end
	mPersonalInfo._UserLv=serverInfo.UserLv;
	mPersonalInfo._LifeNum=serverInfo.LifeNum;
	mPersonalInfo._MaxLifeNum=serverInfo.MaxLifeNum;
	mPersonalInfo._CurrExperience=serverInfo.CurrExperience;
	mPersonalInfo._MaxExperience=serverInfo.MaxExperience;
	mPersonalInfo._GameCoin=serverInfo.GameCoin;
	end
end;

function setUserStatus(nStatus)
    if mPersonalInfo~= nil then
        mPersonalInfo._UserStatus = nStatus
    end
    
end

function setFunEnum(nActiveId)
    if mPersonalInfo~= nil then
        mPersonalInfo.FunEnum = nActiveId
    end
end

function setNickName(nNickName)
    if mPersonalInfo~= nil then
        mPersonalInfo._NickName = nNickName
    end
end;

function setPictureId(nPictureID)
    if mPersonalInfo~= nil then
        mPersonalInfo._PictureID = nPictureID
    end
end;

function setUserLocation(nUserLocation)
    if mPersonalInfo~= nil then
        mPersonalInfo._UserLocation = nUserLocation
    end
end;

function setPlotInfo(nPlotStatusID, nMercenarySeq)
	if mPersonalInfo~= nil then
		mPersonalInfo._PlotStatusID = nPlotStatusID
		--������������
		mPersonalInfo._MercenarySeq = nMercenarySeq
	end
end

function  getCityXY(CityId)
     if mPersonalInfo._Citys~=nil and #mPersonalInfo._Citys>0 then
         for k, v in ipairs(mPersonalInfo._Citys) do
              if v.CityID==CityId then
                 return v.PointX,v.PointY
              end
         end
     end
end;

--С�˵�Event�¼�
local mRandomEvent = {}

function getRendomEventlst()
	return mRandomEvent
end

function pushEvent(EventItem)
	ZyTable.push_back(mRandomEvent, EventItem)
end

function removeEvent(pos)
	ZyTable.remove(pos)
end

function setMoney(goin, gold)--��ң���ʯ
	--��ʯ
	mPersonalInfo._GoldNum=gold
	--���
	mPersonalInfo._GameCoin=goin

end

