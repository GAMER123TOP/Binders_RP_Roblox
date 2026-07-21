#Requires AutoHotkey v2.0
SendMode("Event")
SetKeyDelay(50, 50)

; ===== ГЛОБАЛЬНЫЕ НАСТРОЙКИ =====
global VersionURL := "https://raw.githubusercontent.com/GAMER123TOP/Binders_RP_Roblox/refs/heads/assets/versions.txt"
global CurrentVersion := "2.6.0"
global StopMacro := false
global LoadedFonts := []

; ===== DISCORD ЛОГИ =====
global DiscordWebhook := "https://discord.com/api/webhooks/1526931342334623764/r8C1JtwxR6-ct_bmDVBTfOP-tLcyDTHY3Fy_-mf3_OYdTIepMTaUErPzDnhdkprK16JD"
global LastLogTime := 0

GetHWID() {
    try {
        hwid := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography", "MachineGuid")
        return "HWID-" SubStr(hwid, 1, 8)
    } catch {
        return "PC-" A_ComputerName
    }
}

; =====================================================
;   ОСНОВНАЯ ФУНКЦИЯ ОТПРАВКИ В DISCORD
; =====================================================

SendToDiscord(message) {
    global DiscordWebhook, LastLogTime, CurrentVersion
    
    if (A_TickCount - LastLogTime < 5000) {
        return
    }
    LastLogTime := A_TickCount
    
    userID := GetHWID()
    timestamp := FormatTime(A_Now, "dd.MM.yyyy HH:mm:ss")
    pcName := A_ComputerName
    version := CurrentVersion
    
    fullMessage := "[" timestamp "] [" userID "] [v" version "] [" pcName "] " message
    
    try {
        data := '{"content": "' fullMessage '"}'
        whr := ComObject("WinHttp.WinHttpRequest.5.1")
        whr.Open("POST", DiscordWebhook, false)
        whr.SetRequestHeader("Content-Type", "application/json")
        whr.Send(data)
    } catch {
        ; Игнорируем
    }
}

if (A_Args.Length == 0 || A_Args[1] != "FromLauncher") {
    MsgBox("Ошибка: Запуск макроса разрешен только через Лаунчер!", "Отказ в доступе", "IconX")
    ExitApp()
}

; ===== ПУТЬ К ПАПКЕ ASSETS (ПОЛЬЗОВАТЕЛЬСКАЯ) =====
global AssetsPath := "C:\Users\" A_UserName "\Binders\assets\"

; ===== СПИСОК ШРИФТОВ =====
global FontFiles := [
    "Montserrat-Regular.ttf",
    "Montserrat-Light.ttf",
    "Montserrat-SemiBold.ttf"
]

LoadFonts() {
    global LoadedFonts, AssetsPath, FontFiles
    
    if !DirExist(AssetsPath) {
        MsgBox("Папка Assets не найдена по пути: " AssetsPath "`nЗагрузите шрифты через лаунчер.", "Ошибка", 16)
        return
    }
    
    for fName in FontFiles {
        fPath := AssetsPath fName
        
        if !FileExist(fPath) {
            MsgBox("Шрифт не найден: " fName "`nЗагрузите шрифты через лаунчер.", "Ошибка", 16)
            continue
        }
        
        if DllCall("Gdi32\AddFontResourceEx", "Str", fPath, "UInt", 0x10, "UInt", 0) {
            LoadedFonts.Push(fPath)
        }
    }
}

OnExit(UnloadFonts)
UnloadFonts(*) {
    global LoadedFonts
    for fPath in LoadedFonts {
        DllCall("Gdi32\RemoveFontResourceEx", "Str", fPath, "UInt", 0x10, "UInt", 0)
    }
}

LoadFonts()

; ===== ОСТАНОВКА МАКРОСОВ (Alt+Esc) =====
!Esc:: {
    global StopMacro
    StopMacro := true
    ToolTip("Макросы остановлены!")
    SetTimer(() => ToolTip(), -2000)
}

; ===== ГЛАВНЫЙ ОВЕРЛЕЙ =====
ShowOverlay() {
    global OverlayGui
    OverlayGui := Gui("+AlwaysOnTop -Caption +ToolWindow +Border")
    OverlayGui.SetFont("s9 w400", "Montserrat")
    OverlayGui.Title := "МВД макрос"
    
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.SetFont("s10 w600", "Montserrat SemiBold")
    OverlayGui.Add("Text",, "  ГОРЯЧИЕ КЛАВИШИ ОПГ")
    OverlayGui.SetFont("s9 w400", "Montserrat")
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.Add("Text",, "  Numpad1 / F1  → Снятие M4A1")
    OverlayGui.Add("Text",, "  Numpad2 / F2  → Стяжки")
    OverlayGui.Add("Text",, "  Numpad3 / F3  → Удар рукой")
    OverlayGui.Add("Text",, "  Numpad4 / F4  → Удар ногой")
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.SetFont("s8 w300", "Montserrat Light")
    OverlayGui.Add("Text",, "  Ctrl+Esc → Остановка")
    OverlayGui.Add("Text",, "  Ctrl+R   → Перезапуск")
    OverlayGui.SetFont("s9 w400", "Montserrat")
    OverlayGui.Add("Text",, "═══════════════════════════════════════")

    BtnClose := OverlayGui.Add("Button", "Default w100 x10 y+10", "ЗАКРЫТЬ")
    BtnClose.OnEvent("Click", (*) => ExitApp())
    
    OverlayGui.Show()
    OnMessage(0x201, DragWindow)
}

DragWindow(wParam, lParam, msg, hwnd) {
    global OverlayGui
    if (hwnd == OverlayGui.Hwnd) {
        PostMessage(0x112, 0xF011, 0,, OverlayGui)
        return true
    }
}

ShowOverlay()

; ===== ПОЛНАЯ ОСТАНОВКА СКРИПТА (Ctrl+Esc) =====
^Esc:: {
    ToolTip("Остановка скрипта...")
    SetTimer(() => ToolTip(), -1500)
    Sleep(500)
    ExitApp()
}

; ===== ПАУЗА С ПРОВЕРКОЙ =====
PauseWithCheck(ms) {
    global StopMacro
    Loop {
        if StopMacro {
            ToolTip("Макрос остановлен!")
            SetTimer(() => ToolTip(), -1500)
            return
        }
        if (A_Index > ms / 50)
            break
        Sleep(50)
    }
}

; =====================================================
;   МАКРОСЫ
; =====================================================

; ===== 1. СНЯТИЕ M4A1 (Numpad1) =====
Numpad1::
F1:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ ОПГ: Снятие M4A1")
    ToolTip("Снятие M4A1...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do M4A1 на поясе")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me стянул M4A1 с пояса")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me передёрнул затвор M4A1")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 2. СТЯЖКИ (Numpad2) =====
Numpad2::
F2:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ ОПГ: Стяжки")
    ToolTip("Стяжки...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("M4A1 на поясе")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me завёл руки за спину")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me стянул руки стяжками")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 3. УДАР РУКОЙ (Numpad3) =====
Numpad3::
F3:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ ОПГ: Удар рукой")
    ToolTip("Удар рукой...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me замахнулся правой рукой, заводя её за голову")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me выкинул правую руку в голову противника")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 4. УДАР НОГОЙ (Numpad4) =====
Numpad4::
F4:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ ОПГ: Удар ногой")
    ToolTip("Удар ногой...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me завёл правую ногу за левую, замахиваясь")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me выкинул правую ногу вперёд")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me попал правой ногой в челюсть противника")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== ПЕРЕЗАПУСК (Ctrl+R) =====
^r:: {
    ToolTip("Перезапуск...")
    SetTimer(() => ToolTip(), -1500)
    Sleep(500)
    Reload()
}