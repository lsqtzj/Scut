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
using System.Collections.Generic;
using System.Data;
using ZyGames.Framework.Data.Sql;

namespace ZyGames.Framework.Data
{

    /// <summary>
    /// 程序集内使用
    /// </summary>
    public class CommandFilter
    {
        private Dictionary<string, IDataParameter> _parameter = new Dictionary<string, IDataParameter>();
        /// <summary>
        /// 
        /// </summary>
        public CommandFilter()
        {
            Condition = string.Empty;
        }

        /// <summary>
        /// 
        /// </summary>
        public string Condition
        {
            get;
            set;
        }
        /// <summary>
        /// 
        /// </summary>
        public IDataParameter[] Parameters
        {
            get
            {
                int index = 0;
                IDataParameter[] resultList = new IDataParameter[_parameter.Count];
                foreach (KeyValuePair<string, IDataParameter> item in _parameter)
                {
                    resultList[index] = item.Value;
                    index++;
                }
                return resultList;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="dbType"></param>
        /// <param name="size"></param>
        /// <param name="value"></param>
        public void AddParam(string paramName, SqlDbType dbType, int size, object value)
        {
            AddParam(SqlParamHelper.MakeInParam(paramName, dbType, size, value));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="param"></param>
        public void AddParam(IDataParameter param)
        {
            if (param != null)
            {
                string paramKey = param.GetFieldName();
                //todo 修正：多个@参数
                //if (!param.ParameterName.StartsWith(_preParamChar))
                //{
                //    param.ParameterName = _preParamChar + param.ParameterName;
                //}
                if (_parameter.ContainsKey(paramKey))
                {
                    _parameter[paramKey] = param;
                }
                else
                {
                    _parameter.Add(paramKey, param);
                }
            }
        }
    }
}