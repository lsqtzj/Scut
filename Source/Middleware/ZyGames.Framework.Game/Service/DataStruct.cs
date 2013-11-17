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
using System.Collections;
using System.Text;
using ZyGames.Framework.Common.Log;

namespace ZyGames.Framework.Game.Service
{

    /// <summary>
    /// DataStruct 的摘要说明
    /// </summary>
    public class DataStruct
    {
        /// <summary>
        /// 写日志的对象
        /// </summary>
        protected static BaseLog oBaseLog = null;
        /// <summary>
        /// 数据输出栈
        /// </summary>
        protected ArrayList arrayList = new ArrayList();
        /// <summary>
        /// 临时记录holddata长度
        /// </summary>
        protected int htInfoHoldData = 0;
        /// <summary>
        /// 跟踪BUFFER
        /// </summary>
        protected StringBuilder _traceBuffer = new StringBuilder();
        /// <summary>
        /// Int类型
        /// </summary>
        /// <param name="obj"></param>
        public void PushIntoStack(int obj)
        {
            PushIntoStackObj(obj);
        }
        /// <summary>
        /// 输出Short类型
        /// </summary>
        /// <param name="obj"></param>
        public void PushShortIntoStack(int obj)
        {
            PushIntoStackObj((short)obj);
        }
        /// <summary>
        /// short类型
        /// </summary>
        /// <param name="obj"></param>
        public void PushIntoStack(short obj)
        {
            PushIntoStackObj(obj);
        }
        /// <summary>
        /// 输出Byte类型
        /// </summary>
        /// <param name="obj"></param>
        public void PushByteIntoStack(int obj)
        {
            PushIntoStackObj((byte)obj);
        }
        /// <summary>
        /// byte类型
        /// </summary>
        /// <param name="obj"></param>
        public void PushIntoStack(byte obj)
        {
            PushIntoStackObj(obj);
        }
        /// <summary>
        /// string类型
        /// </summary>
        /// <param name="obj"></param>
        public void PushIntoStack(string obj)
        {
            obj = obj ?? "";
            PushIntoStackObj(obj);
        }
        /// <summary>
        /// 将数据加到栈尾
        /// </summary>
        /// <param name="obj"></param>
        public void PushIntoStack(DataStruct obj)
        {
            PushIntoStackObj(obj);
        }
        /// <summary>
        /// 将数据加到栈尾
        /// </summary>
        /// <param name="obj"></param>
        private void PushIntoStackObj(object obj)
        {
            if (_traceBuffer.Length > 0)
            {
                _traceBuffer.Append(",");
            }
            if (obj is DataStruct)
            {
                _traceBuffer.AppendLine();
                _traceBuffer.Append("{");
                _traceBuffer.AppendFormat("\"Struct\":{0}", ((DataStruct)obj).GetTraceString());
                _traceBuffer.Append("}");
            }
            else
            {
                _traceBuffer.AppendFormat("\"Item\":\"{0}\"", obj);
            }
            PushIntoStackObj(obj, -1);
        }

        /// <summary>
        /// 取出跟踪输出
        /// </summary>
        /// <returns></returns>
        public string GetTraceString()
        {
            return _traceBuffer.ToString();
        }
        /// <summary>
        /// 清空输出栈
        /// </summary>
        protected void CleanStack()
        {
            this.arrayList.Clear();
        }

        /// <summary>
        /// 将数据插入到栈中的指定位置，如果aIndex小于零，则加到栈尾
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="aIndex"></param>
        private void PushIntoStackObj(object obj, int aIndex)
        {
            if (aIndex < 0)
            {
                arrayList.Add(obj);
            }
            else
            {
                arrayList.Insert(aIndex, obj);
            }
            htInfoHoldData += GetObjLength(obj);
        }

        /// <summary>
        /// 计算并返回本协议内容的全部长度
        /// </summary>
        /// <returns></returns>
        protected int GetContentLen()
        {
            int iLen = 0;
            foreach (object obj in arrayList)
            {
                iLen += GetObjLength(obj);
            }
            return iLen + 4;
        }

        /// <summary>
        /// 判定传入对象类型，并计算其所占的字节数
        /// </summary>
        /// <param name="obj"></param>
        /// <returns>占用字节数</returns>
        protected int GetObjLength(object obj)
        {
            if (obj.GetType() == typeof(String))
            {
                return GetStringLen(Convert.ToString(obj));
            }
            else if (obj.GetType() == typeof(Int32))
            {
                return GetDWordLen();
            }
            else if (obj.GetType() == typeof(Int16))
            {
                return GetWordLen();
            }
            else if (obj.GetType() == typeof(Byte))
            {
                return GetByteLen();
            }
            else if (obj.GetType() == typeof(DataStruct))
            {
                return ((DataStruct)obj).GetContentLen();
            }
            else
            {
                Type t = obj.GetType();
                throw new Exception();
                //return 0;
            }
        }
        /// <summary>
        /// 内部输出Action的值
        /// </summary>
        /// <returns>无</returns>
        protected void InternalWriteAction(IGameResponse response)
        {
            foreach (object obj in arrayList)
            {
                if (obj.GetType() == typeof(String))
                {
                    WriteString(response, Convert.ToString(obj));
                }
                else if (obj.GetType() == typeof(Int32))
                {
                    WriteDWord(response, Convert.ToInt32(obj));
                }
                else if (obj.GetType() == typeof(Int16))
                {
                    WriteWord(response, Convert.ToInt16(obj));
                }
                else if (obj.GetType() == typeof(Byte))
                {
                    WriteByte(response, Convert.ToByte(obj));
                }
                else if (obj.GetType() == typeof(DataStruct))
                {
                    DataStruct ds = ((DataStruct)obj);
                    ds.WriteActionNum(response);
                    ds.InternalWriteAction(response);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="response"></param>
        /// <param name="aAction"></param>
        /// <param name="errorCode"></param>
        /// <param name="errorInfo"></param>
        /// <param name="msgId">消息初始ID</param>
        /// <param name="st"></param>
        public void WriteAction(IGameResponse response, int aAction, int errorCode, string errorInfo, int msgId, string st = "st")
        {
            WriteHead(response, aAction, errorCode, errorInfo, msgId, st);
        }

        /// <summary>
        /// 输出当前协议
        /// </summary>
        protected void WriteHead(IGameResponse response, int aAction, int errorCode, string errorInfo, int msgId, string st)
        {
            PushIntoStackObj(errorCode, 0);
            PushIntoStackObj(msgId, 1);
            //结果String
            PushIntoStackObj(errorInfo, 2);
            PushIntoStackObj(aAction, 3);
            //St
            PushIntoStackObj(st, 4);
            WriteActionNum(response);
            InternalWriteAction(response);
        }

        /// <summary>
        /// 计算Action协议占用的字节长度
        /// </summary>
        protected void WriteActionNum(IGameResponse response)
        {
            int iActionNum = GetContentLen();
            WriteDWord(response, iActionNum);
        }
        /// <summary>
        /// 写入字节流
        /// </summary>
        /// <param name="aValue"></param>
        /// <param name="response"></param>
        protected static void WriteString(IGameResponse response, string aValue)
        {
            byte[] outputStream = System.Text.Encoding.UTF8.GetBytes(aValue);
            int iLen = outputStream.Length;
            byte[] outputStreamForLen = BitConverter.GetBytes(iLen);
            response.BinaryWrite(outputStreamForLen);
            if (outputStream.Length > 0)
            {
                response.BinaryWrite(outputStream);
            }
        }
        /// <summary>
        /// 写入字节流
        /// </summary>
        /// <param name="aValue"></param>
        /// <param name="response"></param>
        protected static void WriteDWord(IGameResponse response, Int32 aValue)
        {
            byte[] outputStream = BitConverter.GetBytes(aValue);
            response.Write(outputStream);
        }
        /// <summary>
        /// 写入字节流
        /// </summary>
        /// <param name="aValue"></param>
        /// <param name="response"></param>
        protected static void WriteWord(IGameResponse response, Int16 aValue)
        {
            byte[] outputStream = BitConverter.GetBytes(aValue);
            response.Write(outputStream);
        }
        /// <summary>
        /// 写入字节流
        /// </summary>
        /// <param name="aByte"></param>
        /// <param name="m_Response"></param>
        protected static void WriteByte(IGameResponse m_Response, byte aByte)
        {
            byte[] outputStream = new byte[1];
            outputStream[0] = aByte;
            //m_Response.OutputStream.Write(outputStream, 0, outputStream.Length);
            m_Response.Write(outputStream);
        }

        #region //计算输出对象长度
        /// <summary>
        /// 计算字符串下发时，占用的字节流长度，字符串长度+4个字节（标出字符串的实际长度）
        /// </summary>
        /// <returns></returns>
        public static int GetStringLen(string str)
        {
            byte[] outputStream = System.Text.Encoding.UTF8.GetBytes(str);
            return outputStream.Length + 4;
        }
        /// <summary>
        /// 计算int型数据下发时，占用的字节长度
        /// </summary>
        /// <returns></returns>
        public static int GetDWordLen()
        {
            return 4;
        }
        /// <summary>
        /// 计算short型数据下发时，占用的字节长度
        /// </summary>
        /// <returns></returns>
        public static int GetWordLen()
        {
            return 2;
        }
        /// <summary>
        /// 计算Byte型数据下发时，占用的字节长度
        /// </summary>
        /// <returns></returns>
        public static int GetByteLen()
        {
            return 1;
        }

        #endregion
    }
}