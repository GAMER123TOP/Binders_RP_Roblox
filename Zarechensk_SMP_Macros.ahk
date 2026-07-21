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
    OverlayGui.Title := "СМП макрос"
    
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.SetFont("s10 w600", "Montserrat SemiBold")
    OverlayGui.Add("Text",, "  ГОРЯЧИЕ КЛАВИШИ СМП")
    OverlayGui.SetFont("s9 w400", "Montserrat")
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.Add("Text",, "  Numpad1 / F1  → Прибытие на вызов")
    OverlayGui.Add("Text",, "  Numpad2 / F2  → Осмотр пациента")
    OverlayGui.Add("Text",, "  Numpad3 / F3  → Проверка пульса / СЛР")
    OverlayGui.Add("Text",, "  Numpad4 / F4  → ИВЛ / Кислород")
    OverlayGui.Add("Text",, "  Numpad5 / F5  → Инъекция / Укол")
    OverlayGui.Add("Text",, "  Numpad6 / F6  → Запись в карту")
    OverlayGui.Add("Text",, "  Numpad7 / F7  → Вызов подмоги")
    OverlayGui.Add("Text",, "  Numpad8 / F8  → Отчёт о госпитализации")
    OverlayGui.Add("Text",, "  Numpad9 / F9  → Рация")
    OverlayGui.Add("Text",, "  Ctrl+Numpad1 / Ctrl+F1 → Оценка состояния")
    OverlayGui.Add("Text",, "  Ctrl+Numpad2 / Ctrl+F2 → Давящая повязка")
    OverlayGui.Add("Text",, "  Ctrl+Numpad3 / Ctrl+F3 → Шина")
    OverlayGui.Add("Text",, "  Ctrl+Numpad4 / Ctrl+F4 → Жгут")
    OverlayGui.Add("Text",, "  Ctrl+Numpad5 / Ctrl+F5 → Устойчивое боковое положение")
    OverlayGui.Add("Text",, "  Ctrl+Numpad6 / Ctrl+F6 → Холод на травму")
    OverlayGui.Add("Text",, "  Ctrl+Numpad7 / Ctrl+F7 → Помощь при переломе")
    OverlayGui.Add("Text",, "  Ctrl+Numpad8 / Ctrl+F8 → Вызов скорой / эвакуация")
    OverlayGui.Add("Text",, "  Ctrl+Numpad9 / Ctrl+F9 → Транспортировка на носилках")
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

; ===== GUI: ВВОД АДРЕСА =====
GetAddressInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Адрес вызова"
    MyGui.Add("Text",, "Введите адрес вызова:")
    MyGui.Add("Edit", "vAddress w250")
    
    MyGui.Add("Button", "Default w100 y+10 x10", "ОК").OnEvent("Click", (*) => MyGui.Hide())
    MyGui.Add("Button", "x+10 w100", "Отмена").OnEvent("Click", (*) => MyGui.Destroy())
    
    MyGui.Show()
    WinWaitClose(MyGui)
    try {
        Data := MyGui.Submit(false)
        MyGui.Destroy()
        return Data
    } catch {
        MyGui.Destroy()
        return ""
    }
}

; ===== GUI: ВВОД ДИАГНОЗА =====
GetDiagnosisInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Диагноз"
    MyGui.Add("Text",, "Введите диагноз пациента:")
    MyGui.Add("Edit", "vDiagnosis w250")
    
    MyGui.Add("Button", "Default w100 y+10 x10", "ОК").OnEvent("Click", (*) => MyGui.Hide())
    MyGui.Add("Button", "x+10 w100", "Отмена").OnEvent("Click", (*) => MyGui.Destroy())
    
    MyGui.Show()
    WinWaitClose(MyGui)
    try {
        Data := MyGui.Submit(false)
        MyGui.Destroy()
        return Data
    } catch {
        MyGui.Destroy()
        return ""
    }
}

; ===== GUI: ВВОД ДАННЫХ ПАЦИЕНТА =====
GetPatientInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Данные пациента"
    MyGui.Add("Text",, "Введите данные пациента (ФИО):")
    MyGui.Add("Edit", "vPatient w250")
    
    MyGui.Add("Button", "Default w100 y+10 x10", "ОК").OnEvent("Click", (*) => MyGui.Hide())
    MyGui.Add("Button", "x+10 w100", "Отмена").OnEvent("Click", (*) => MyGui.Destroy())
    
    MyGui.Show()
    WinWaitClose(MyGui)
    try {
        Data := MyGui.Submit(false)
        MyGui.Destroy()
        return Data
    } catch {
        MyGui.Destroy()
        return ""
    }
}

; ===== GUI: ВВОД СООБЩЕНИЯ ДЛЯ РАЦИИ =====
GetRadioMessage() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Введите сообщение для рации"
    MyGui.Add("Text",, "Сообщение:")
    MyGui.Add("Edit", "vMessage w300")
    
    MyGui.Add("Button", "Default w100 y+10 x10", "ОК").OnEvent("Click", (*) => MyGui.Hide())
    MyGui.Add("Button", "x+10 w100", "Отмена").OnEvent("Click", (*) => MyGui.Destroy())
    
    MyGui.Show()
    WinWaitClose(MyGui)
    try {
        Data := MyGui.Submit(false)
        MyGui.Destroy()
        return Data
    } catch {
        MyGui.Destroy()
        return ""
    }
}

; ===== GUI: ЕСТЬ ЛИ ПУЛЬС? =====
GetPulseChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Пульс"
    MyGui.Add("Text",, "Пульс есть?")
    
    Choice := ""
    
    YesClick(*) {
        Choice := "ЕСТЬ"
        MyGui.Hide()
    }
    
    NoClick(*) {
        Choice := "НЕТ"
        MyGui.Hide()
    }
    
    MyGui.Add("Button", "Default w70 y+10 x10", "ДА").OnEvent("Click", YesClick)
    MyGui.Add("Button", "x+10 w70", "НЕТ").OnEvent("Click", NoClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

; ===== GUI: РЕЗУЛЬТАТ СЛР =====
GetSLRResultChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Результат СЛР"
    MyGui.Add("Text",, "Цикл СЛР завершён, пульс восстановлен?")
    
    Choice := ""
    
    YesClick(*) {
        Choice := "ВОССТАНОВЛЕН"
        MyGui.Hide()
    }
    
    NoClick(*) {
        Choice := "НЕ ВОССТАНОВЛЕН"
        MyGui.Hide()
    }
    
    MyGui.Add("Button", "Default w100 y+10 x10", "ДА").OnEvent("Click", YesClick)
    MyGui.Add("Button", "x+10 w100", "НЕТ").OnEvent("Click", NoClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

; =====================================================
;   МАКРОСЫ СМП
; =====================================================

; ===== 1. ПРИБЫТИЕ НА ВЫЗОВ (Numpad1 / F1) =====
Numpad1::
F1:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Прибытие")
    ToolTip("Прибытие...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetAddressInput()
    if !Data
        return
    Address := Data.Address

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me прибыл на вызов по адресу: " Address)
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Скорая помощь на месте, оснащение готово")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 2. ОСМОТР ПАЦИЕНТА (Numpad2 / F2) =====
Numpad2::
F2:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Осмотр пациента")
    ToolTip("Осмотр...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me провёл первичный осмотр пациента")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пульс: в норме, дыхание: ровное, кожные покровы: бледные")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 3. ПРОВЕРКА ПУЛЬСА / СЛР (Numpad3 / F3) =====
Numpad3::
F3:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Проверка пульса/СЛР")
    ToolTip("Пульс / СЛР...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверил пульс у пациента")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пульс есть?")
    Send("{Enter}")
    PauseWithCheck(300)

    Choice := GetPulseChoice()
    if (Choice = "") {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    if (Choice = "ЕСТЬ") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Пульс прощупывается, ритмичный")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Артериальное давление в пределах нормы")
        Send("{Enter}")
        PauseWithCheck(300)
    } else {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Пульс отсутствует! Начинаю реанимацию")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me приступил к сердечно-лёгочной реанимации")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me выполняет непрямой массаж сердца")
        Send("{Enter}")
        PauseWithCheck(500)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me провёл искусственную вентиляцию лёгких")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Цикл СЛР завершён, пульс восстановлен?")
        Send("{Enter}")
        PauseWithCheck(300)

        Result := GetSLRResultChoice()
        if (Result = "") {
            ToolTip("Отменено!")
            SetTimer(() => ToolTip(), -1500)
            return
        }

        if (Result = "ВОССТАНОВЛЕН") {
            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/do Пульс восстановлен, пациент стабилен")
            Send("{Enter}")
            PauseWithCheck(300)
        } else {
            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/do Пульс не восстановлен! Продолжаю реанимацию")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/me продолжаю СЛР до приезда подмоги")
            Send("{Enter}")
            PauseWithCheck(300)
        }
    }

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 4. ИВЛ / КИСЛОРОД (Numpad4 / F4) =====
Numpad4::
F4:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: ИВЛ/Кислород")
    ToolTip("ИВЛ...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me подключил пациента к аппарату ИВЛ")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Подача кислорода: 40%, сатурация: 98%")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 5. ИНЪЕКЦИЯ / УКОЛ (Numpad5 / F5) =====
Numpad5::
F5:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Инъекция")
    ToolTip("Инъекция...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me сделал внутримышечную инъекцию")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Препарат введён, пациент стабилен")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 6. ЗАПИСЬ В КАРТУ (Numpad6 / F6) =====
Numpad6::
F6:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Запись в карту")
    ToolTip("Запись...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetDiagnosisInput()
    if !Data
        return
    Diagnosis := Data.Diagnosis

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me заполнил медицинскую карту пациента")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Диагноз: " Diagnosis)
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 7. ВЫЗОВ ПОДМОГИ (Numpad7 / F7) =====
Numpad7::
F7:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Вызов подмоги")
    ToolTip("Подмога...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me вызвал подмогу по рации")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do На место направлена дополнительная бригада")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 8. ОТЧЁТ О ГОСПИТАЛИЗАЦИИ (Numpad8 / F8) =====
Numpad8::
F8:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Отчёт о госпитализации")
    ToolTip("Отчёт...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetPatientInput()
    if !Data
        return
    Patient := Data.Patient

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me передал отчёт о госпитализации")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пациент " Patient " госпитализирован")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 9. РАЦИЯ (Numpad9 / F9) =====
Numpad9::
F9:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Рация")
    ToolTip("Рация...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetRadioMessage()
    if !Data
        return

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me снял рацию")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me зажал кнопку PPT")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Из динамика послышался звук включения")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Р- " Data.Message)
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me отпустил кнопку и убрал рацию")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 10. ОЦЕНКА СОСТОЯНИЯ (Ctrl+Numpad1 / Ctrl+F1) =====
^Numpad1::
^F1:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Оценка состояния")
    ToolTip("Оценка состояния...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me провёл быстрый осмотр пострадавшего")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Сознание: ясное, дыхание: свободное, пульс: прощупывается")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Кожные покровы: бледные, видимых травм не обнаружено")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 11. ДАВЯЩАЯ ПОВЯЗКА (Ctrl+Numpad2 / Ctrl+F2) =====
^Numpad2::
^F2:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Давящая повязка")
    ToolTip("Давящая повязка...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me наложил стерильную давящую повязку")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Повязка наложена правильно, кровотечение остановлено")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 12. ШИНА (Ctrl+Numpad3 / Ctrl+F3) =====
^Numpad3::
^F3:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Шина")
    ToolTip("Шина...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me наложил шину на повреждённую конечность")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Конечность обездвижена, шина зафиксирована")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 13. ЖГУТ (Ctrl+Numpad4 / Ctrl+F4) =====
^Numpad4::
^F4:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Жгут")
    ToolTip("Жгут...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me наложил жгут выше места кровотечения")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Кровотечение остановлено, время наложения зафиксировано")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 14. УСТОЙЧИВОЕ БОКОВОЕ ПОЛОЖЕНИЕ (Ctrl+Numpad5 / Ctrl+F5) =====
^Numpad5::
^F5:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Боковое положение")
    ToolTip("Боковое положение...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me перевёл пострадавшего в устойчивое боковое положение")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Дыхательные пути свободны, поза стабильна")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 15. ХОЛОД НА ТРАВМУ (Ctrl+Numpad6 / Ctrl+F6) =====
^Numpad6::
^F6:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Холод на травму")
    ToolTip("Холод...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me приложил холод к месту травмы")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Отёк уменьшается, боль притупляется")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 16. ПОМОЩЬ ПРИ ПЕРЕЛОМЕ (Ctrl+Numpad7 / Ctrl+F7) =====
^Numpad7::
^F7:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Помощь при переломе")
    ToolTip("Перелом...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me оценил состояние перелома, обездвижил конечность")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Повреждённая область зафиксирована, ожидание скорой")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 17. ВЫЗОВ СКОРОЙ / ЭВАКУАЦИЯ (Ctrl+Numpad8 / Ctrl+F8) =====
^Numpad8::
^F8:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Вызов скорой/эвакуация")
    ToolTip("Эвакуация...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me вызвал скорую помощь и подготовил пострадавшего к эвакуации")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пострадавший готов к транспортировке")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 18. ТРАНСПОРТИРОВКА НА НОСИЛКАХ (Ctrl+Numpad9 / Ctrl+F9) =====
^Numpad9::
^F9:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ СМП: Транспортировка на носилках")
    ToolTip("Носилки...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me перенёс пострадавшего на носилки, зафиксировал ремнями")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пострадавший зафиксирован, транспортировка безопасна")
    Send("{Enter}")

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