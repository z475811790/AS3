@echo off
@echo 开始生成文件

protoc.exe  --plugin=protoc-gen-as3=protoc-gen-as3.bat --as3_out=../SocketClient/src ./proto/*.proto
IF ERRORLEVEL 1 goto exeFail
IF ERRORLEVEL 0 goto exeSuccess

:exeFail
echo 文件生成失败

:exeSuccess
echo 文件生成成功

pause







