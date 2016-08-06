@echo off

SET BIJI_PATH=c:\Users\dedi\Documents\GitHub\Biji.Corona

IF NOT EXIST "theme.lua" (
	echo "Copying theme template..."
	copy %BIJI_PATH%\theme.lua .
)

echo "Copying fonts..."
xcopy /Y %BIJI_PATH%\fonts fonts\

echo "Copying icons..."
xcopy /Y %BIJI_PATH%\icons icons\

echo "Copying pre libs..."
xcopy /Y %BIJI_PATH%\libs libs\

echo "Copying biji toolkit..."
xcopy /Y %BIJI_PATH%\biji biji\
xcopy /Y %BIJI_PATH%\biji.sync.bat .
xcopy /Y %BIJI_PATH%\default.lua .
