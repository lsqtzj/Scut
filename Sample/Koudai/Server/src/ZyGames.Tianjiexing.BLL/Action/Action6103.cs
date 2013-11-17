﻿/****************************************************************************
Copyright (c) 2013-2015 scutgame.com

http://www.scutgame.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
using System;
using System.Data;
using ZyGames.Framework.Common;

using ZyGames.Framework.Game.Service;
using ZyGames.Tianjiexing.Lang;
using ZyGames.Tianjiexing.Model;
using ZyGames.Tianjiexing.BLL.Combat;
using ZyGames.Tianjiexing.BLL.Base;
using ZyGames.Tianjiexing.Model.Config;


namespace ZyGames.Tianjiexing.BLL.Action
{

    /// <summary>
    /// 6103_公会Boss战欲火重生接口
    /// </summary>
    public class Action6103 : BaseAction
    {
        private const int GoldNum = 5;
        private const int MaxNum = 5;
        private int Ops;
        private double _reliveInspirePercent;
        private int _activeId;



        public Action6103(HttpGet httpGet)
            : base(ActionIDDefine.Cst_Action6103, httpGet)
        {

        }

        public override void BuildPacket()
        {
            PushIntoStack((_reliveInspirePercent * 100).ToInt());
        }

        public override bool GetUrlElement()
        {
            if (httpGet.GetInt("Ops", ref Ops, 1, 2)
                && httpGet.GetInt("ActiveId", ref _activeId))
            {
                return true;
            }
            return false;
        }

        public override bool TakeAction()
        {
            if (!string.IsNullOrEmpty(ContextUser.MercenariesID))
            {
                if (CombatHelper.GuildBossKill(ContextUser.MercenariesID))
                {
                    ErrorCode = LanguageManager.GetLang().ErrorCode;
                    ErrorInfo = LanguageManager.GetLang().St5405_BossKilled;
                    return false;
                }
                GuildBossCombat bossCombat = new GuildBossCombat(ContextUser.MercenariesID);
                UserGuild guild = bossCombat.UserGuild;
                if (guild != null)
                {
                    if (!VipHelper.GetVipOpenFun(ContextUser.VipLv, ExpandType.BossChongSheng))
                    {
                        ErrorCode = LanguageManager.GetLang().ErrorCode;
                        ErrorInfo = LanguageManager.GetLang().St_VipNotEnoughNotFuntion;
                        return false;
                    }
                    CombatStatus combatStatus = guild.CombatStatus;
                    if (combatStatus != CombatStatus.Wait && combatStatus != CombatStatus.Combat)
                    {
                        ErrorCode = LanguageManager.GetLang().ErrorCode;
                        ErrorInfo = LanguageManager.GetLang().St5402_CombatNoStart;
                        return false;
                    }
                    ErrorCode = Ops;

                    BossUser bossUser = bossCombat.GetCombatUser(Uid);
                    if (bossUser != null && !bossUser.IsRelive)
                    {
                        ErrorCode = LanguageManager.GetLang().ErrorCode;
                        ErrorInfo = LanguageManager.GetLang().St5403_IsLive;
                        return false;

                    }
                    if (bossUser != null && bossUser.ReliveNum >= MaxNum)
                    {
                        ErrorCode = LanguageManager.GetLang().ErrorCode;
                        ErrorInfo = LanguageManager.GetLang().St5403_IsReLiveMaxNum;
                        return false;

                    }
                    int goldNum = GoldNum * (bossUser.ReliveNum + 1);
                    if (Ops == 1)
                    {
                        ErrorInfo = string.Format(LanguageManager.GetLang().St5403_CombatGoldTip, goldNum);
                    }
                    else if (Ops == 2)
                    {
                        if (ContextUser.GoldNum < goldNum)
                        {
                            ErrorCode = LanguageManager.GetLang().ErrorCode;
                            ErrorInfo = LanguageManager.GetLang().St_GoldNotEnough;
                            return false;
                        }
                        if (bossUser != null && bossUser.IsRelive)
                        {
                            if (bossUser.IsRelive)
                            {
                                ContextUser.UseGold = MathUtils.Addition(ContextUser.UseGold, goldNum, int.MaxValue);
                                //ContextUser.Update();
                                bossUser.IsRelive = false;
                                bossUser.ReliveBeginDate = DateTime.MinValue;
                                bossUser.ReliveInspirePercent = MathUtils.Addition(bossUser.ReliveInspirePercent, CountryCombat.InspireIncrease, 1);
                                _reliveInspirePercent = bossUser.ReliveInspirePercent;
                                bossUser.ReliveNum++;
                            }
                        }
                    }
                }
            }
            return true;
        }
    }
}