#pragma compile(Console, True)

; Define the path to the property file
Global $sIniFile = "coordinates.ini"
Global $endProgram = False

; Function to close Chrome if it's open
Func CloseChrome()
	ConsoleWrite("closing chomes" & @CRLF)
    If ProcessExists("chrome.exe") Then
        ProcessClose("chrome.exe")
    EndIf
	Sleep(1000)
EndFunc

; Function to open Chrome and navigate to the URL
Func OpenChrome()
	ConsoleWrite("OpenChrome start" & @CRLF)
	ShellExecute("chrome.exe", "https://nice-identity.signin.aws.amazon.com/console")
    WinWaitActive("[CLASS:Chrome_WidgetWin_1]")
	ConsoleWrite("OpenChrome end" & @CRLF)
EndFunc

; Function to click the yellow sign-in button
Func ClickSignInButton()
	ConsoleWrite("wait 8 seconds" & @CRLF)
	Sleep(8000) ; Wait for the page to load
	ConsoleWrite("ClickSignInButton start" & @CRLF)
	Local $iLogin1_X = IniRead($sIniFile, "Coordinates", "login1_x", "0")
    Local $iLogin1_Y = IniRead($sIniFile, "Coordinates", "login1_y", "0")
    MouseClick("left", $iLogin1_X, $iLogin1_Y)    
	ConsoleWrite("ClickSignInButton end" & @CRLF)
EndFunc

; Function to handle MFA
Func HandleMFA()
	ConsoleWrite("wait 5 seconds" & @CRLF)
	Sleep(5000) ; Wait for the page to load	
	ConsoleWrite("HandleMFA start" & @CRLF)
	; Read coordinates from the INI file
    Local $iMfa1_X = IniRead($sIniFile, "Coordinates", "mfa1_x", "0")
    Local $iMfa1_Y = IniRead($sIniFile, "Coordinates", "mfa1_y", "0")
    Local $iMfa2_X = IniRead($sIniFile, "Coordinates", "mfa2_x", "0")
    Local $iMfa2_Y = IniRead($sIniFile, "Coordinates", "mfa2_y", "0")
    Local $iMfa3_X = IniRead($sIniFile, "Coordinates", "mfa3_x", "0")
    Local $iMfa3_Y = IniRead($sIniFile, "Coordinates", "mfa3_y", "0")
    Local $iLogin2_X = IniRead($sIniFile, "Coordinates", "login2_x", "0")
    Local $iLogin2_Y = IniRead($sIniFile, "Coordinates", "login2_y", "0")

    ; Click on the authenticator plugin
    MouseClick("left", $iMfa1_X, $iMfa1_Y)
    Sleep(1000)
    ; Click on the MFA code
    MouseClick("left", $iMfa2_X, $iMfa2_Y)
    ; Click on the MFA text area
    MouseClick("left", $iMfa3_X, $iMfa3_Y)
    Send("^v") ; Paste the copied MFA code
    MouseClick("left", $iLogin2_X, $iLogin2_Y)   
    ConsoleWrite("HandleMFA end" & @CRLF)
EndFunc

; Function to switch to the right role
Func SwitchRole()
	ConsoleWrite("wait 8 seconds" & @CRLF)
	Sleep(8000) ; Wait for the page to load
	ConsoleWrite("SwitchRole start" & @CRLF)
    ; Read coordinates from the INI file
    Local $iRole1_X = IniRead($sIniFile, "Coordinates", "role1_x", "0")
    Local $iRole1_Y = IniRead($sIniFile, "Coordinates", "role1_y", "0")
    Local $iRole2_X = IniRead($sIniFile, "Coordinates", "role2_x", "0")
    Local $iRole2_Y = IniRead($sIniFile, "Coordinates", "role2_y", "0")
    ; Click on the role link
    MouseClick("left", $iRole1_X, $iRole1_Y)
    Sleep(3000)
    ; Click on the PROD role
    MouseClick("left", $iRole2_X, $iRole2_Y)    
    ConsoleWrite("SwitchRole end" & @CRLF)
EndFunc

; Function to navigate to the CloudWatch dashboard
Func NavigateToDashboard()
	ConsoleWrite("wait 7 seconds" & @CRLF)
	Sleep(7000) ; Wait for the page to load
	ConsoleWrite("NavigateToDashboard start" & @CRLF)
	ShellExecute("chrome.exe", "https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#dashboards/dashboard/production-CXWFM-Executive-Dashboard?start=PT336H&end=null")
    WinWaitActive("[CLASS:Chrome_WidgetWin_1]")
	ConsoleWrite("NavigateToDashboard end" & @CRLF)	
	Sleep(30000) ; Wait b4 first refresh
EndFunc

Func StartRefresh($iRefresh_X, $iRefresh_Y)
	ConsoleWrite("Refresh start" & @CRLF)
	MouseClick("left", $iRefresh_X, $iRefresh_Y)
	ConsoleWrite("Refresh end" & @CRLF)	
EndFunc

Func reactionFunction()
   $endProgram = True
EndFunc

While True
	ConsoleWrite("starting 10 hours cycle!!!!!! (Cntrl C to exit" & @CRLF)
	HotKeySet("^c", "reactionFunction")
    CloseChrome()
    OpenChrome()
	If $endProgram Then
		ConsoleWrite("ending program!!!!!!" & @CRLF)
		Exit
	EndIf
    ClickSignInButton()
	If $endProgram Then
		ConsoleWrite("ending program!!!!!!" & @CRLF)
		Exit
	EndIf
    HandleMFA()
	If $endProgram Then
		ConsoleWrite("ending program!!!!!!" & @CRLF)
		Exit
	EndIf
    SwitchRole()
	If $endProgram Then
		ConsoleWrite("ending program!!!!!!" & @CRLF)
		Exit
	EndIf
    NavigateToDashboard()
	If $endProgram Then
		ConsoleWrite("ending program!!!!!!" & @CRLF)
		Exit
	EndIf
	
	ConsoleWrite("hotkey set" & @CRLF)
	; Refresh every 12 minutes for 10 hours
    Local $iRefreshStartTime = TimerInit()
	 ; Read coordinates from the INI file
    Local $iRefresh_X = IniRead($sIniFile, "Coordinates", "refresh_x", "0")
    Local $iRefresh_Y = IniRead($sIniFile, "Coordinates", "refresh_y", "0")
	While TimerDiff($iRefreshStartTime) < 36000000 ; 10 hours in milliseconds        
		Local $iRefreshCycleStartTime = TimerInit()
        While TimerDiff($iRefreshCycleStartTime) < 720000 ; 12 minutes in milliseconds		
            If $endProgram Then
				ConsoleWrite("ending program!!!!!!" & @CRLF)
                Exit
            EndIf			
            Sleep(3000) ; 1 second in milliseconds
        WEnd
        StartRefresh($iRefresh_X, $iRefresh_Y)
    WEnd
    ConsoleWrite("End 10 hours cycle!!!!!!" & @CRLF) 
WEnd