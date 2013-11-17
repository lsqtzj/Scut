------------------------------------------------------------------
-- mainapp.lua
-- Author     : Xin Zhang
-- Version    : 1.0.0.0
-- Date       : 2011-10-15
-- Description:
------------------------------------------------------------------

local strModuleName = "mainapp";
CCLuaLog("Module " .. strModuleName .. " loaded.");
strModuleName = nil;

------------------------------------------------------------------
-- ���� ��ʼ���������� ��ʼ ����
------------------------------------------------------------------

local strRootDir = ScutDataLogic.CFileHelper:getPath("lua");
local strTmpPkgPath = package.path;

local strSubDirs =
{
	"action",
	"common",
	"datapool",
	"Global",
	"layers",
	"LuaClass",
	"scenes",
	"lib",
	"conFig",
	"chatFunction",
	"battle",
	"commupdate",
	"payment",
	-- �ڴ�����µ�Ŀ¼
};

-- ���������ļ���
for key, value in ipairs(strSubDirs) do
	local strOld = strTmpPkgPath;
	if(1 == key) then
		strTmpPkgPath = string.format("%s/%s/?.lua%s", strRootDir, value, strOld);
	else
		strTmpPkgPath = string.format("%s/%s/?.lua;%s", strRootDir, value, strOld);
	end
	CCLuaLog(value .. " added.");
	strOld = nil;
end

package.path = string.format("%s/?.lua;%s", strRootDir, strTmpPkgPath);
strTmpPkgPath = nil;

------------------------------------------------------------------
-- ���� ��ʼ���������� ���� ����
------------------------------------------------------------------

-- require�����ڻ���������ʼ��֮�󣬱����ļ��Ҳ������������
require("lib.lib");
require("lib.RequireLuaClass");
require("scenes.LanScenes");
require("common.CommandDataResove")
require("lib.ScutScene")
require("lib.FrameManager")
--require("payment.channelEngine")
math.randomseed(tostring(os.time()):reverse():sub(1, 6))  

------------------------------------------------------------------
-- ���� Э���������ע�� ��ʼ ����
------------------------------------------------------------------
function PushReceiverCallback(pScutScene, lpExternalData)
end
function processCommonData(lpScene)
	return true;
end

function netDecodeEnd(pScutScene, nTag)
	LoadingScene.hide();
	ZyLoading.hide(pScutScene, nTag)
end


g_frame_mgr = FrameManager:new()
    g_frame_mgr:init()

    function OnHandleData(pScene, nTag, nNetRet, pData, lpExternalData)
        pScene = tolua.cast(pScene, "CCScene")
        g_scenes[pScene]:execCallback(nTag, nNetRet, pData,lpExternalData)
    end
CCDirector:sharedDirector():RegisterSocketPushHandler("PushReceiverCallback")
--ScutScene:registerNetCommonDataFunc("processCommonData");
--ScutScene:registerNetErrorFunc("LanScenes.netConnectError");
ScutScene:registerNetDecodeEnd("netDecodeEnd");
CCDirector:sharedDirector():RegisterBackHandler("MainScene.closeApp")
--ע��crash log�ص�
CCDirector:sharedDirector():RegisterErrorHandler("err_handler")



function err_handler(str)
	ZyRequestCounter = ZyRequestCounter + 1
	ZyWriter:writeString("ActionId",404 );
	ZyWriter:writeString("ErrorInfo", str)
	ScutDataLogic.CDataRequest:Instance():AsyncExecRequest(ScutScene, ZyWriter:generatePostData(), ZyRequestCounter, nil);
	ScutDataLogic.CNetWriter:resetData()
end
------------------------------------------------------------------
-- ���� Э���������ע�� ���� ����
------------------------------------------------------------------
--

LanScenes.init()

collectgarbage("setpause", 150)
collectgarbage("setstepmul", 1000)
--]]

