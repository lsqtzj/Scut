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
using Microsoft.Scripting.Hosting;
using ZyGames.Framework.Game.Lang;
using ZyGames.Framework.Game.Service;

namespace ZyGames.Framework.Game.Contract.Action
{
    /// <summary>
    /// 提供脚本支持
    /// </summary>
    public class ScriptAction : AuthorizeAction
    {
        private readonly dynamic _scriptScope;
        private readonly bool _ignoreAuthorize;
        private dynamic _urlParam;
        private dynamic _actionResult;

        /// <summary>
        /// /
        /// </summary>
        /// <param name="aActionId"></param>
        /// <param name="httpGet"></param>
        /// <param name="scriptScope"></param>
        /// <param name="ignoreAuthorize">忽略授权</param>
        public ScriptAction(short aActionId, HttpGet httpGet, dynamic scriptScope, bool ignoreAuthorize)
            : base(aActionId, httpGet)
        {
            _scriptScope = scriptScope;
            _ignoreAuthorize = ignoreAuthorize;
        }
		/// <summary>
		/// 子类实现
		/// </summary>
        protected override void InitChildAction()
        {
        }
		/// <summary>
		/// 接收用户请求的参数，并根据相应类进行检测
		/// </summary>
		/// <returns></returns>
        public override bool GetUrlElement()
        {
            _urlParam = _scriptScope.getUrlElement(httpGet, this);
            return _urlParam != null && _urlParam.Result ? true : false;
        }
		/// <summary>
		/// 子类实现Action处理
		/// </summary>
		/// <returns></returns>
        public override bool TakeAction()
        {
            _actionResult = _scriptScope.takeAction(_urlParam, this);
            return _actionResult != null && _actionResult.Result ? true : false;
        }
		/// <summary>
		/// 创建返回协议内容输出栈
		/// </summary>
        public override void BuildPacket()
        {
            bool result =  _scriptScope.buildPacket(dataStruct, _urlParam, _actionResult);
            if (!result)
            {
                ErrorCode = Language.Instance.ErrorCode;
                if (IsRealse)
                {
                    ErrorInfo = Language.Instance.ServerBusy;
                }
            }
        }
		/// <summary>
		/// 不检查的ActionID
		/// </summary>
		/// <value><c>true</c> if ignore action identifier; otherwise, <c>false</c>.</value>
        protected override bool IgnoreActionId
        {
            get { return _ignoreAuthorize; }
        }
    }
}