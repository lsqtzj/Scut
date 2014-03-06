/****************************************************************************
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
using System.Linq;
using System.IO;

namespace ZyGames.Framework.Script
{
    /// <summary>
    /// �ű�����
    /// </summary>
    public enum ScriptType
    {
        /// <summary>
        /// 
        /// </summary>
        Unkown,
        /// <summary>
        /// 
        /// </summary>
        Python = 1,
        /// <summary>
        /// 
        /// </summary>
        Csharp
    }
    /// <summary>
    /// �ű��ļ���Ϣ
    /// </summary>
    public abstract class ScriptFileInfo
    {
        private readonly string _fileCode;
        private readonly string _fileName;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fileCode">�ļ����</param>
        /// <param name="fileName">����·�����ļ���</param>
        protected ScriptFileInfo(string fileCode, string fileName)
        {
            _fileCode = fileCode;
            _fileName = fileName;
        }

        protected ScriptType _type;

        /// <summary>
        /// �ű�����
        /// </summary>
        public ScriptType Type
        {
            get { return _type; }
        }

        /// <summary>
        /// Object type.
        /// </summary>
        public Type ObjType { get; set; }

        /// <summary>
        /// �ļ����
        /// </summary>
        public string FileCode
        {
            get { return _fileCode; }
        }

        /// <summary>
        /// ����·�����ļ���
        /// </summary>
        public string FileName
        {
            get { return _fileName; }
        }

        /// <summary>
        /// 
        /// </summary>
        public string GroupName { get; set; }

        /// <summary>
        /// MD5��ϣCode
        /// </summary>
        public string HashCode { get; set; }

    }
}