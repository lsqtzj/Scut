@echo off

cd %cd%

set dbServer=.
set dbAcount=sa
set dbPass=123
set gameuser=game_user
set gameName=Ddz
set dbpath=%cd%\Data

@echo ���ò������£�
@echo     [dbServer] ���ݿ������:%dbServer%
@echo     [dbAcount] �ɴ������ݿ���ʺ�(sa):%dbAcount%
@echo     [dbPass]   �ɴ������ݿ������(sa):%dbPass%
@echo     [gameuser] ��Ϸ��¼�ʺ�:%gameuser%
@echo     [gameName] ��Ϸ��Ŀ����:%gameName%
@echo     [dbpath] ���ݿ�洢·��:%dbpath%
@echo ================================================================

MD %dbpath%

Sqlcmd -? 2>nul 1>nul
if errorlevel 1 (
echo �밲װsqlcmd֧�֡�&pause>nul
exit
)

@echo ���ڴ�����Ϸ%4���ݿ�...
Sqlcmd -S %dbServer% -U %dbAcount% -P %dbPass% -d master -i ������Ϸ���ݿ�.sql -v gameuser="%gameuser%" gameName="%gameName%" dbpath="%dbpath%"


@echo ���ڳ�ʼ����Ϸ��������...
Sqlcmd -S %dbServer% -U %dbAcount% -P %dbPass% -d master -i ���ÿ��ʼ����.sql -v gameName="%gameName%"

@echo ִ�гɹ�

ECHO ���н�����& PAUSE

