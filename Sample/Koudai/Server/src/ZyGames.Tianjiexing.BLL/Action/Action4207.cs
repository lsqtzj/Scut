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
using ZyGames.Framework.Game.Service;
using ZyGames.Tianjiexing.Lang;
using ZyGames.Tianjiexing.BLL.Combat;


namespace ZyGames.Tianjiexing.BLL.Action
{

    /// <summary>
    /// 4207_队伍位置调整接口
    /// </summary>
    public class Action4207 : BaseAction
    {
        private string toUser = string.Empty;
        private int IsUp = 0;


        public Action4207(HttpGet httpGet)
            : base(ActionIDDefine.Cst_Action4207, httpGet)
        {

        }

        public override void BuildPacket()
        {

        }

        public override bool GetUrlElement()
        {
            if (httpGet.GetString("ToUser", ref toUser)
                 && httpGet.GetInt("IsUp", ref IsUp))
            {
                return true;
            }
            return false;
        }

        public override bool TakeAction()
        {
            var plotTeam = new PlotTeamCombat(ContextUser);
            int teamId = plotTeam.GetTeamId(Uid);
            if (teamId != -1)
            {
                var team = plotTeam.GetTeam(teamId);
                if (!team.TeamUser.UserId.Equals(Uid))
                {
                    ErrorCode = LanguageManager.GetLang().ErrorCode;
                    return false;
                }
                plotTeam.MoveTeamPos(teamId, toUser, IsUp == 1);
            }
            return true;
        }
    }
}