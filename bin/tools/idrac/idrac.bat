@echo off

:: https://gist.github.com/xbb/4fd651c2493ad9284dbcb827dc8886d6#gistcomment-3502274
:: Also, keep in mind if you still have to update the java settings to allow the older TLS to work:
:: Java location .\jre\lib\security\java.security
:: Remove SSLv3 and 3DES_EDE_CBC from jdk.tls.disabledAlgorithms

set /P drachost="Host: "
set /p dracuser="Username: "
set "psCommand=powershell -Command "$pword = read-host 'Enter Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set dracpwd=%%p

IF NOT EXIST "avctKVM.jar" (
ECHO Grabbing avctKVM.jar from host...
powershell -Command "[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} ; $WebClient = New-Object System.Net.WebClient ; $WebClient.DownloadFile('https://%drachost%/software/avctKVM.jar','.\avctKVM.jar')"
)

IF NOT EXIST "lib" (
ECHO Creating lib directory
mkdir "lib"
)

IF NOT EXIST ".\lib\avmWinLib.dll" (
  IF NOT EXIST ".\lib\avctVMWin64.zip" (
    IF NOT EXIST ".\lib\avctVMWin64.jar" (
      ECHO Grabbing avctKVMWin64.jar from host...
      powershell -Command "[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} ; $WebClient = New-Object System.Net.WebClient ; $WebClient.DownloadFile('https://%drachost%/software/avctVMWin64.jar','.\lib\avctVMWin64.jar')"
    )
    ECHO Renaming avctVMWin64.jar to avctVMWin64.zip
    rename ".\lib\avctVMWin64.jar" avctVMWin64.zip
  )
  ECHO Unzipping avctKVMWin64.zip
  powershell Expand-Archive ".\lib\avctVMWin64.zip" -DestinationPath ".\lib"
  rmdir ".\lib\META-INF" /s /q
  erase ".\lib\avctVMWin64.zip" /q
)

IF NOT EXIST ".\lib\avctKVMIO.dll" (
  IF NOT EXIST ".\lib\avctKVMIOWin64.zip" (
    IF NOT EXIST ".\lib\avctKVMIOWin64.jar" (
      ECHO Grabbing avctKVMIOWin64.jar from host...
      powershell -Command "[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} ; $WebClient = New-Object System.Net.WebClient ; $WebClient.DownloadFile('https://%drachost%/software/avctKVMIOWin64.jar','.\lib\avctKVMIOWin64.jar')"
    )
    ECHO Renaming avctKVMIOWin64.jar to avctKVMIOWin64.zip
    rename ".\lib\avctKVMIOWin64.jar" avctKVMIOWin64.zip
  )
  ECHO Unzipping avctKVMIOWin64.zip
  powershell Expand-Archive ".\lib\avctKVMIOWin64.zip" -DestinationPath ".\lib"
  rmdir ".\lib\META-INF" /s /q
  erase ".\lib\avctKVMIOWin64.zip" /q
)

java -cp avctKVM.jar -Djava.library.path=.\lib com.avocent.idrac.kvm.Main ip=%drachost% kmport=5900 vport=5900 user=%dracuser% passwd=%dracpwd% apcp=1 version=2 vmprivilege=true "helpurl=https://%drachost%:443/help/contents.html"
