@echo off
@echo ��ʼ�����ļ�

protoc.exe  --plugin=protoc-gen-as3=protoc-gen-as3.bat --as3_out=../SocketClient/src ./proto/*.proto
IF ERRORLEVEL 1 goto exeFail
IF ERRORLEVEL 0 goto exeSuccess

:exeFail
echo �ļ�����ʧ��

:exeSuccess
echo �ļ����ɳɹ�

pause







