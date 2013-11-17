
------------------------------------------------------------------
-- MenuBtnConfig.lua
-- Author     : ChenJM
-- Version    : 1.15
-- Date       :   
-- Description:��ť���� ,
------------------------------------------------------------------
module("MenuBtnConfig", package.seeall)

--[[
�ƹ���ļӶ��
ħ����
ħ��
ǿ��
����
�꼼ѧϰ
����
������
����
�����ڶ���ǿ������
������
ׯ԰��ֲ������
����
�ճ�����
���
����ˮ��
�����̵�
����ս
����BOSS��ս
�ͻ�
ÿ��̽��
ׯ԰��ֲ��Ǯ��
���˸���
ʥ������ս
ɨ��
��ɫ
����
����
�����ͼ
--]]
MenuId = {
	eJiuGuan	 = 1,--�ƹ�
	eMoFaZheng	 = 2,--ħ����
	eMoShu	     = 3,--ħ��
	eQiangHua	 = 4,--ǿ��
	ePeiYang	 = 5,--����
	eXiuLian     = 7,--����
	eHaoYou 	 = 9,--����
	eJingJiChang = 11,--������
	eZhuangYuan  = 12,--ׯ԰��ֲ������
	eGongHui     = 13,--����
	eDailyTast   = 14,--�ճ�����
	eGoldHole	 = 15,--���
	eMingYunShuijin	= 16,--����ˮ��
	eDailyAdventure	= 17,--�����̵�
	eJueSe 	= 26,--��ɫ
	eSaoDang  = 25,--ɨ��
	eBeiBao = 27,--����
	eRenWu 	= 28,--����
	eWorldMap     = 29,--�����ͼ
	eGuoJia  = 30,  --����ѡ��
	eAllMenu  = 100,  --
	eFengLin = 36,--����
	eTianDiJie = 35,--��ؽ�
	eMall = 37,--�̳�
	eChuanCheng = 38,--����
	eKuaFu = 39,--���µ�һ�����ս��
	eLaXin = 40,--���¿�

	eYongBin = 47,--Ӷ��
	eEquip = 48,--װ��
	eHunji= 49,--�꼼
	eYongBLevel= 50,--����
	ePlot = 51,--����
	eChaDang = 100,--A--�˵�
	eXinJian = 102,--A --�ż�
	eSheZhi = 103,--A	--����
	eShangZhen = 104,--�ҵ���Ӫ  ---A		
}


local MenuItemTables={
	[MenuId.eMoFaZheng]=0,
	[MenuId.eMoShu]=0,
	[MenuId.eQiangHua]=0,
	[MenuId.ePeiYang]=0,
	[MenuId.eXiuLian]=0,
	[MenuId.eHaoYou]=0,
	[MenuId.eJingJiChang]=0,
	[MenuId.eZhuangYuan]=0,
	[MenuId.eGongHui]=0,
	[MenuId.eDailyTast]=0,
	[MenuId.eGoldHole]=0,
	[MenuId.eMingYunShuijin]=0,
	[MenuId.eDailyAdventure]=0,
	[MenuId.eSaoDang]=0,
	[MenuId.eJueSe]=0,
	[MenuId.eBeiBao]=0,
	[MenuId.eRenWu]=0,
	[MenuId.eWorldMap]=0,
	[MenuId.eGuoJia]=0,
	[MenuId.eJiuGuan]=0,
	[MenuId.eFengLin]=0,
	[MenuId.eTianDiJie]=0,


	}
	
	function clearMenuItemTables ()
		MenuItemTables=nil
		MenuItemTables={}
	end;

function  getMenuItem(id)
	if  MenuItemTables[id]==1 then
		return true
	end
	return false
end;

function  setMenuItem(key)
	MenuItemTables[key]=1
end;
