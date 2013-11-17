using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;

namespace ZyGames.OA.WatchService.BLL.Tools
{
    /// <summary>
    /// ϵͳ����ƻ�����
    /// </summary>
    public static class SchTasksOperate
    {
        private static string programBat = "schtasks-query.bat";
        private static string programName = "schtasks.exe";
        /// <summary>
        /// 
        /// </summary>
        /// <param name="taskName">����ƻ���</param>
        /// <param name="taskPath">����λ��</param>
        /// <returns></returns>
        public static string Create(string taskName, string taskPath)
        {
            string args = string.Format("/Create /RU system /TN {0} /SC ONSTART /TR \"{1}\" /F", taskName, taskPath);
            return CommandExeHelper.Run(programName, args);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="taskName">����ƻ���</param>
        /// <returns></returns>
        public static string Delete(string taskName)
        {
            string args = string.Format("/delete /tn \"{0}\" /F", taskName);
            return CommandExeHelper.Run(programName, args);

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="taskName">����ƻ���</param>
        /// <returns></returns>
        public static string StartRun(string taskName)
        {
            string args = string.Format("/run /tn \"{0}\" ", taskName);
            return CommandExeHelper.Run(programName, args);

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="taskName">����ƻ���</param>
        /// <returns></returns>
        public static string StopRun(string taskName)
        {
            string args = string.Format("/end /tn \"{0}\" ", taskName);
            return CommandExeHelper.Run(programName, args);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="taskName">����ƻ���</param>
        /// <returns></returns>
        public static bool CheckRun(string taskName)
        {
            FileInfo file = new FileInfo(programBat);
            if (!file.Exists)
            {
                throw new FileNotFoundException("����ƻ���ѯ�������ļ�������", programBat);
            }
            if (file.Directory != null)
            {
                string path = file.Directory.FullName;
                string result = CommandExeHelper.Run(programBat, taskName, path);
                int index = result.IndexOf(taskName);
                if (index != -1)
                {
                    result = result.Substring(index, result.Length - index);
                    return result.ToLower().IndexOf("running") != -1;
                }
            }
            return false;
        }
    }
}