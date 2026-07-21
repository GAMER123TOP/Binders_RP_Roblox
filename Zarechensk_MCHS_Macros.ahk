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
    global OverlayGui, CurrentPage
    if IsSet(OverlayGui) && OverlayGui.Hwnd
        OverlayGui.Destroy()
    
    OverlayGui := Gui("+AlwaysOnTop -Caption +ToolWindow +Border")
    OverlayGui.SetFont("s9 w400", "Montserrat")
    OverlayGui.Title := "МЧС макрос"
    
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.SetFont("s10 w600", "Montserrat SemiBold")
    OverlayGui.Add("Text",, "  ГОРЯЧИЕ КЛАВИШИ МЧС — СТР. " CurrentPage "/2")
    OverlayGui.SetFont("s9 w400", "Montserrat")
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    
    if (CurrentPage = 1) {
        OverlayGui.Add("Text",, "  Numpad1 / F1  → Прибытие на вызов")
        OverlayGui.Add("Text",, "  Numpad2 / F2  → Осмотр места ЧП")
        OverlayGui.Add("Text",, "  Numpad3 / F3  → Разведка в дыму")
        OverlayGui.Add("Text",, "  Numpad4 / F4  → Надевание СИЗОД")
        OverlayGui.Add("Text",, "  Numpad5 / F5  → Тушение огня")
        OverlayGui.Add("Text",, "  Numpad6 / F6  → Развёртывание рукава")
        OverlayGui.Add("Text",, "  Numpad7 / F7  → Эвакуация людей")
        OverlayGui.Add("Text",, "  Numpad8 / F8  → Проливка места")
        OverlayGui.Add("Text",, "  Numpad9 / F9  → Рация")
        OverlayGui.Add("Text",, "  Numpad0 / F10 → Общий сбор")
        OverlayGui.Add("Text",, "  Ctrl+Numpad1 / Ctrl+F1 → Проверка СИЗОД")
        OverlayGui.Add("Text",, "  Ctrl+Numpad2 / Ctrl+F2 → Замена баллона")
        OverlayGui.Add("Text",, "  Ctrl+Numpad3 / Ctrl+F3 → Снятие СИЗОД")
        OverlayGui.Add("Text",, "  Ctrl+Numpad4 / Ctrl+F4 → Спасательные работы")
        OverlayGui.Add("Text",, "  Ctrl+Numpad5 / Ctrl+F5 → Вскрытие двери")
        OverlayGui.Add("Text",, "  Ctrl+Numpad6 / Ctrl+F6 → Поиск в дыму")
        OverlayGui.Add("Text",, "  Ctrl+Numpad7 / Ctrl+F7 → Доклад командиру")
        OverlayGui.Add("Text",, "  Ctrl+Numpad8 / Ctrl+F8 → Запрос подкрепления")
        OverlayGui.Add("Text",, "  Ctrl+Numpad9 / Ctrl+F9 → Отчёт об окончании")
        OverlayGui.Add("Text",, "  Ctrl+Numpad0 / Ctrl+F10 → Отбой тревоги")
    } else {
        OverlayGui.Add("Text",, "  Shift+Numpad1 / Shift+F1 → Первая помощь")
        OverlayGui.Add("Text",, "  Shift+Numpad2 / Shift+F2 → Проверка герметичности СИЗОД")
        OverlayGui.Add("Text",, "  Shift+Numpad3 / Shift+F3 → Проверка стёкол СИЗОД")
        OverlayGui.Add("Text",, "  Shift+Numpad4 / Shift+F4 → Проверка клапана СИЗОД")
        OverlayGui.Add("Text",, "  Shift+Numpad5 / Shift+F5 → Проверка огнетушителя")
        OverlayGui.Add("Text",, "  Shift+Numpad6 / Shift+F6 → Проверка соединения рукава")
        OverlayGui.Add("Text",, "  Shift+Numpad7 / Shift+F7 → Пересчёт эвакуированных")
        OverlayGui.Add("Text",, "  Shift+Numpad8 / Shift+F8 → Проверка температуры")
        OverlayGui.Add("Text",, "  Shift+Numpad9 / Shift+F9 → Настройка рации")
        OverlayGui.Add("Text",, "  Shift+Numpad0 / Shift+F10 → Проверка готовности экипажа")
        OverlayGui.Add("Text",, "  Alt+Numpad1 / Alt+F1 → Доклад о ходе работ")
        OverlayGui.Add("Text",, "  Alt+Numpad2 / Alt+F2 → Доклад о расходе воды")
        OverlayGui.Add("Text",, "  Alt+Numpad3 / Alt+F3 → Доклад о технике")
        OverlayGui.Add("Text",, "  Alt+Numpad4 / Alt+F4 → Проверка пульса")
        OverlayGui.Add("Text",, "  Alt+Numpad5 / Alt+F5 → Проверка двери")
        OverlayGui.Add("Text",, "  Alt+Numpad6 / Alt+F6 → Прислушивание в дыму")
        OverlayGui.Add("Text",, "  Alt+Numpad7 / Alt+F7 → Доклад о завершении этапа")
        OverlayGui.Add("Text",, "  Alt+Numpad8 / Alt+F8 → Уточнение времени подкрепления")
        OverlayGui.Add("Text",, "  Alt+Numpad9 / Alt+F9 → Сдача отчёта")
        OverlayGui.Add("Text",, "  Alt+Numpad0 / Alt+F10 → Объявление отбоя")
    }
    
    OverlayGui.SetFont("s9 w400", "Montserrat")
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    
    BtnPrev := OverlayGui.Add("Button", "w40", "◄")
    BtnPrev.OnEvent("Click", (*) => SwitchPage(-1))

    PageText := OverlayGui.Add("Text", "x+5 yp+5 w50 Center", "СТР " CurrentPage "/2")

    BtnNext := OverlayGui.Add("Button", "x+5 yp-5 w40", "►")
    BtnNext.OnEvent("Click", (*) => SwitchPage(1))
    
    OverlayGui.Add("Text", "x10", "═══════════════════════════════════════")
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

SwitchPage(direction) {
    global CurrentPage
    CurrentPage += direction
    if (CurrentPage < 1)
        CurrentPage := 2
    if (CurrentPage > 2)
        CurrentPage := 1
    ShowOverlay()
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
;   ИНТЕРФЕЙСЫ
; =====================================================

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

GetVictimsCountInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Количество пострадавших"
    MyGui.Add("Text",, "Введите количество пострадавших:")
    MyGui.Add("Edit", "vCount w100")
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

GetRadioMessage() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Сообщение для рации"
    MyGui.Add("Text",, "Введите сообщение:")
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

GetSituationInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Характер ЧП"
    MyGui.Add("Text",, "Выберите характер ЧП:")
    
    Choice := ""
    
    FireClick(*) {
        Choice := "ПОЖАР"
        MyGui.Hide()
    }
    DTPClick(*) {
        Choice := "ДТП"
        MyGui.Hide()
    }
    GasClick(*) {
        Choice := "УТЕЧКА ГАЗА"
        MyGui.Hide()
    }
    RubbleClick(*) {
        Choice := "ЗАВАЛ"
        MyGui.Hide()
    }
    
    MyGui.Add("Button", "w100 y+10 x10", "ПОЖАР").OnEvent("Click", FireClick)
    MyGui.Add("Button", "x+5 w100", "ДТП").OnEvent("Click", DTPClick)
    MyGui.Add("Button", "x+5 w100", "УТЕЧКА ГАЗА").OnEvent("Click", GasClick)
    MyGui.Add("Button", "x+5 w100", "ЗАВАЛ").OnEvent("Click", RubbleClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

; =====================================================
;   МАКРОСЫ МЧС - СТРАНИЦА 1
; =====================================================

; ===== 1. ПРИБЫТИЕ (Numpad1 / F1) =====
Numpad1::
F1:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Прибытие на вызов")
    ToolTip("Прибытие...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetAddressInput()
    if !IsObject(Data)
        return
    Address := Data.Address

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me прибыл на место вызова по адресу: " Address)
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do На месте ЧП слышны крики, чувствуется запах гари")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 2. ОСМОТР (Numpad2 / F2) =====
Numpad2::
F2:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Осмотр места ЧП")
    ToolTip("Осмотр...")
    SetTimer(() => ToolTip(), -1500)

    Situation := GetSituationInput()
    if (Situation = "")
        return

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me осматривает место происшествия, оценивает обстановку")
    Send("{Enter}")
    PauseWithCheck(300)

    if (Situation = "ПОЖАР") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Огонь распространяется на соседние здания, слышен треск")
    } else if (Situation = "ДТП") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Машины сильно деформированы, есть риск возгорания топлива")
    } else if (Situation = "УТЕЧКА ГАЗА") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do В воздухе чувствуется запах газа, есть угроза взрыва")
    } else if (Situation = "ЗАВАЛ") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Конструкции нестабильны, есть риск обрушения")
    }
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 3. РАЗВЕДКА (Numpad3 / F3) =====
Numpad3::
F3:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Разведка в дыму")
    ToolTip("Разведка...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me надевает СИЗОД, проверяет герметичность")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do СИЗОД готов, дыхание через аппарат свободное")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me входит в задымлённое помещение, пригибаясь")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Видимость почти нулевая, чувствуется сильное задымление")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me ведёт рукой вдоль стены, ориентируясь на ощупь")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Поиск идёт вслепую, слышен треск горящих конструкций")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 4. НАДЕВАНИЕ СИЗОД (Numpad4 / F4) =====
Numpad4::
F4:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Надевание СИЗОД")
    ToolTip("СИЗОД...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me достаёт СИЗОД, проверяет целостность маски")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Маска герметична, баллон заправлен")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me надевает СИЗОД, регулирует крепления")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Маска плотно прилегает, дыхание свободное")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 5. ТУШЕНИЕ (Numpad5 / F5) =====
Numpad5::
F5:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Тушение огня")
    ToolTip("Тушение...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me снимает огнетушитель с крепления (4-5 кг)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Огнетушитель в руке, чувствуется вес")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me выдёргивает чеку, направляет раструб на огонь")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Из огнетушителя выходит белая пена, пламя гаснет")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 6. РАЗВЁРТЫВАНИЕ РУКАВА (Numpad6 / F6) =====
Numpad6::
F6:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Развёртывание рукава")
    ToolTip("Рукав...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me открывает отсек пожарной машины, достаёт рукав")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Рукав скатан, готов к развёртыванию")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me подключает рукав к выходу на пожарной машине")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Соединение герметично, зажимы зафиксированы")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me разворачивает рукав в сторону очага возгорания")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Рукав заполняется водой, давление нарастает")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me направляет ствол на огонь, открывает подачу воды")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Вода бьёт мощной струёй, пламя сбивается")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 7. ЭВАКУАЦИЯ (Numpad7 / F7) =====
Numpad7::
F7:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Эвакуация людей")
    ToolTip("Эвакуация...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me выводит людей из опасной зоны, прикрывая лицо")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Люди испуганы, но все целы, эвакуация завершена")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 8. ПРОЛИВКА (Numpad8 / F8) =====
Numpad8::
F8:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Проливка места")
    ToolTip("Проливка...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проливает место пожара водой")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Поверхность остывает, дым рассеивается")
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
    SendToDiscord("⚡ МЧС: Рация")
    ToolTip("Рация...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetRadioMessage()
    if !IsObject(Data)
        return
    Message := Data.Message

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
    SendText("-Р- " Message)
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me отпустил кнопку и убрал рацию")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 10. ОБЩИЙ СБОР (Numpad0 / F10) =====
Numpad0::
F10:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Общий сбор")
    ToolTip("Сбор...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me объявляет сбор всех свободных экипажей МЧС")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do На месте ЧП паника, слышны крики о помощи")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me запрыгивает в машину, заводит двигатель")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Машина готова к выезду, все на местах")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 11. ПРОВЕРКА СИЗОД (Ctrl+Numpad1 / Ctrl+F1) =====
^Numpad1::
^F1:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Проверка СИЗОД")
    ToolTip("Проверка СИЗОД...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверяет давление в баллоне СИЗОД")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Давление в норме, воздуха хватит на 30 минут")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 12. ЗАМЕНА БАЛЛОНА (Ctrl+Numpad2 / Ctrl+F2) =====
^Numpad2::
^F2:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Замена баллона")
    ToolTip("Замена баллона...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me заменяет пустой баллон СИЗОД на полный")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Баллон зафиксирован, система герметична")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 13. СНЯТИЕ СИЗОД (Ctrl+Numpad3 / Ctrl+F3) =====
^Numpad3::
^F3:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Снятие СИЗОД")
    ToolTip("Снятие СИЗОД...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me снимает СИЗОД, вытирает лицо")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do СИЗОД убран в чехол, готов к использованию")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 14. СПАСАТЕЛЬНЫЕ РАБОТЫ (Ctrl+Numpad4 / Ctrl+F4) =====
^Numpad4::
^F4:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Спасательные работы")
    ToolTip("Спасательные работы...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me оценивает завал, ищет безопасный подход")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Из-под завалов слышны слабые стоны")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me аккуратно разбирает завалы, работая руками")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пострадавший найден, зажат плитой")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me освобождает пострадавшего, оказывает первую помощь")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пострадавший в сознании, дыхание стабильное")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 15. ВСКРЫТИЕ ДВЕРИ (Ctrl+Numpad5 / Ctrl+F5) =====
^Numpad5::
^F5:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Вскрытие двери")
    ToolTip("Вскрытие...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me вскрывает заблокированную дверь с помощью лома")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Дверь поддаётся, проход открыт")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 16. ПОИСК В ДЫМУ (Ctrl+Numpad6 / Ctrl+F6) =====
^Numpad6::
^F6:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Поиск в дыму")
    ToolTip("Поиск...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me ведёт поиск в сильно задымлённом помещении")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Видимость нулевая, поиск идёт вслепую")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me нащупывает стены, двигается медленно")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Слышен треск, но людей не видно")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 17. ДОКЛАД КОМАНДИРУ (Ctrl+Numpad7 / Ctrl+F7) =====
^Numpad7::
^F7:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Доклад командиру")
    ToolTip("Доклад...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetVictimsCountInput()
    if !IsObject(Data)
        return
    Count := Data.Count

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me подходит к командиру, докладывает обстановку")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пожар локализован, угрозы распространения нет")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me докладывает количество пострадавших")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пострадавших: " Count ", переданы медикам")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me запрашивает дальнейшие указания")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Командир кивает, отдаёт приказ на проливку")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 18. ЗАПРОС ПОДКРЕПЛЕНИЯ (Ctrl+Numpad8 / Ctrl+F8) =====
^Numpad8::
^F8:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Запрос подкрепления")
    ToolTip("Подкрепление...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me запрашивает подкрепление по рации")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Рация передала: `"Подкрепление в пути`"")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 19. ОТЧЁТ ОБ ОКОНЧАНИИ (Ctrl+Numpad9 / Ctrl+F9) =====
^Numpad9::
^F9:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Отчёт об окончании")
    ToolTip("Отчёт...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me докладывает об окончании работ")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Объект безопасен, очаг возгорания нейтрализован")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 20. ОТБОЙ ТРЕВОГИ (Ctrl+Numpad0 / Ctrl+F10) =====
^Numpad0::
^F10:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Отбой тревоги")
    ToolTip("Отбой...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me отбой тревоги, вызов ложный")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do При повторной проверке очаг не обнаружен")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; =====================================================
;   МАКРОСЫ МЧС - СТРАНИЦА 2
; =====================================================

; ===== 1. ПЕРВАЯ ПОМОЩЬ (Shift+Numpad1 / Shift+F1) =====
+Numpad1::
+F1:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Первая помощь")
    ToolTip("Первая помощь...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me осматривает пострадавшего на наличие травм")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do У пострадавшего ссадины и ушибы, переломов нет")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me накладывает стерильную повязку на рану")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Кровотечение остановлено, повязка наложена правильно")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me укладывает пострадавшего в устойчивое боковое положение")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Дыхание свободное, пострадавший в сознании")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 2. ГЕРМЕТИЧНОСТЬ (Shift+Numpad2 / Shift+F2) =====
+Numpad2::
+F2:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Проверка герметичности СИЗОД")
    ToolTip("Герметичность...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверяет герметичность маски СИЗОД")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Маска плотно прилегает, утечек нет")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 3. СТЁКЛА (Shift+Numpad3 / Shift+F3) =====
+Numpad3::
+F3:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Проверка стёкол СИЗОД")
    ToolTip("Стёкла...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me снимает маску СИЗОД, проверяет стёкла")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Стёкла целы, маска готова к повторному использованию")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 4. КЛАПАН (Shift+Numpad4 / Shift+F4) =====
+Numpad4::
+F4:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Проверка клапана СИЗОД")
    ToolTip("Клапан...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверяет клапан выдоха СИЗОД")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Клапан работает исправно, воздух выходит свободно")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 5. ОГНЕТУШИТЕЛЬ (Shift+Numpad5 / Shift+F5) =====
+Numpad5::
+F5:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Проверка огнетушителя")
    ToolTip("Огнетушитель...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверяет срок годности огнетушителя")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Срок годности в норме, огнетушитель готов к применению")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 6. СОЕДИНЕНИЕ (Shift+Numpad6 / Shift+F6) =====
+Numpad6::
+F6:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Проверка соединения рукава")
    ToolTip("Соединение...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверяет соединение рукава с машиной")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Соединение герметично, подтеканий нет")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 7. ПЕРЕСЧЁТ (Shift+Numpad7 / Shift+F7) =====
+Numpad7::
+F7:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Пересчёт эвакуированных")
    ToolTip("Пересчёт...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me пересчитывает эвакуированных людей")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Все на месте, потерь нет")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 8. ТЕМПЕРАТУРА (Shift+Numpad8 / Shift+F8) =====
+Numpad8::
+F8:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Проверка температуры")
    ToolTip("Температура...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверяет температуру после проливки")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Температура в норме, возгорание исключено")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 9. НАСТРОЙКА РАЦИИ (Shift+Numpad9 / Shift+F9) =====
+Numpad9::
+F9:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Настройка рации")
    ToolTip("Настройка рации...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me настраивает частоту рации")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Связь установлена, помех нет")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 10. ГОТОВНОСТЬ (Shift+Numpad0 / Shift+F10) =====
+Numpad0::
+F10:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Проверка готовности экипажа")
    ToolTip("Готовность...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверяет готовность экипажа")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Все сотрудники на местах, готовы к выезду")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 11. ХОД РАБОТ (Alt+Numpad1 / Alt+F1) =====
!Numpad1::
!F1:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Доклад о ходе работ")
    ToolTip("Ход работ...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me докладывает о ходе работ")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Работы идут по плану, отклонений нет")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 12. РАСХОД ВОДЫ (Alt+Numpad2 / Alt+F2) =====
!Numpad2::
!F2:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Доклад о расходе воды")
    ToolTip("Расход воды...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me докладывает о расходе воды")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Воды достаточно, запас пополнен")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 13. ТЕХНИКА (Alt+Numpad3 / Alt+F3) =====
!Numpad3::
!F3:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Доклад о технике")
    ToolTip("Техника...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me докладывает о состоянии техники")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Техника исправна, готова к дальнейшей работе")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 14. ПУЛЬС (Alt+Numpad4 / Alt+F4) =====
!Numpad4::
!F4:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Проверка пульса")
    ToolTip("Пульс...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверяет пульс у пострадавшего")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пульс прощупывается, ритмичный")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 15. ДВЕРЬ (Alt+Numpad5 / Alt+F5) =====
!Numpad5::
!F5:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Проверка двери")
    ToolTip("Дверь...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверяет дверь на наличие заклинивания")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Дверь открывается свободно")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 16. ПРИСЛУШИВАНИЕ (Alt+Numpad6 / Alt+F6) =====
!Numpad6::
!F6:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Прислушивание в дыму")
    ToolTip("Прислушивание...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me прислушивается к звукам в дыму")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Слышны голоса, поиск продолжается")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 17. ЗАВЕРШЕНИЕ ЭТАПА (Alt+Numpad7 / Alt+F7) =====
!Numpad7::
!F7:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Доклад о завершении этапа")
    ToolTip("Завершение этапа...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me докладывает о завершении этапа работ")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Этап завершён, приступаю к следующему")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 18. ВРЕМЯ ПОДКРЕПЛЕНИЯ (Alt+Numpad8 / Alt+F8) =====
!Numpad8::
!F8:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Уточнение времени подкрепления")
    ToolTip("Время подкрепления...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me уточняет время прибытия подкрепления")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Подкрепление прибудет через 5 минут")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 19. СДАЧА ОТЧЁТА (Alt+Numpad9 / Alt+F9) =====
!Numpad9::
!F9:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Сдача отчёта")
    ToolTip("Сдача отчёта...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me сдаёт отчёт о работе")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Отчёт принят, замечаний нет")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 20. ОБЪЯВЛЕНИЕ ОТБОЯ (Alt+Numpad0 / Alt+F10) =====
!Numpad0::
!F10:: {
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    SendToDiscord("⚡ МЧС: Объявление отбоя")
    ToolTip("Объявление отбоя...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me объявляет отбой для личного состава")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Все расходятся, дежурство продолжается")
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