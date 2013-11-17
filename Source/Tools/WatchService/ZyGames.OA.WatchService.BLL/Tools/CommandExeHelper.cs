using System;
using System.Diagnostics;

namespace ZyGames.OA.WatchService.BLL.Tools
{
    public static class CommandExeHelper
    {
        public static string CombineDir(string str1, string str2)
        {
            string val = @"\";
            str1 = str1 == null ? "" : str1.Replace("/", val).Replace(@"\\", val);
            str2 = str2 == null ? "" : str2.Replace("/", val).Replace(@"\\", val);
            str1 = str1.EndsWith(val) ? str1 : str1 + val;
            str2 = str2.Trim('\\');
            return str1 + str2;
        }

        public static string CombineUrl(string str1, string str2)
        {
            string val = @"\";
            str1 = str1 == null ? "" : str1.Replace(val, "/").Replace("//", val);
            str2 = str2 == null ? "" : str2.Replace(val, "/");
            str1 = str1.EndsWith("/") ? str1 : str1 + "/";
            str2 = str2.Trim('/');
            return str1 + str2;
        }

        public static string Run(string fileName, string arguments)
        {
            return Run(fileName, arguments, null);
        }

        public static string Run(string fileName, string arguments, string directory)
        {
            //ʵ����һ��������
            Process procExe = new Process();

            //���ϵͳ��Ϣ��ʹ�õ��� systeminfo.exe �������̨����
            //procExe.StartInfo.FileName = CurrentContext.Server.MapPath("/") + strSvnExePath;
            if (!string.IsNullOrEmpty(directory))
            {
                procExe.StartInfo.WorkingDirectory = directory;
            }
            procExe.StartInfo.FileName = fileName;

            if (!string.IsNullOrEmpty(arguments))
            {
                procExe.StartInfo.Arguments = arguments;
            }

            //��procExe�ı�׼��������ȫ���ض���.NET�ĳ�����

            procExe.StartInfo.UseShellExecute = false; //�˴�����Ϊfalse���������쳣
            procExe.StartInfo.RedirectStandardInput = true; //��׼����
            procExe.StartInfo.RedirectStandardOutput = true; //��׼���
            procExe.StartInfo.RedirectStandardError = true;

            //����ʾ�����д��ڽ���
            procExe.StartInfo.CreateNoWindow = true;
            procExe.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            var loger = new ZyGames.GameService.BaseService.LogService.BaseLog();
            try
            {
                procExe.Start(); //��������
            }
            catch (Exception Ex)
            {
                loger.SaveLog(Ex);
                return Ex.Message;
            }

            //��ȡ���
            //��Ҫ˵���ģ��˴���ָ����ʼ��ȡ��Ҫ��ȡ�����ݣ�
            //ֻ�еȽ����˳�����������õ�
            string strOutput = procExe.StandardOutput.ReadToEnd() + procExe.StandardError.ReadToEnd();
            loger.SaveLog(strOutput);

            procExe.WaitForExit();//�ȴ�����̨����ִ�����
            procExe.Close();//�رոý���
            procExe.Dispose();
            return strOutput;
        }
    }
}
