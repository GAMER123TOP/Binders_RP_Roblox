#Requires AutoHotkey v2.0
SendMode("Event")
SetKeyDelay(50, 50)

; ===== ГЛОБАЛЬНЫЕ НАСТРОЙКИ =====
global StopMacro := false

; =====================================================
;   АВТОМАТИЧЕСКАЯ ЗАГРУЗКА ШРИФТОВ MONTSERRAT
; =====================================================
global LoadedFonts := []
global FontUrls := [
    "https://github.com/google/fonts/raw/main/ofl/montserrat/Montserrat-Regular.ttf",
    "https://github.com/google/fonts/raw/main/ofl/montserrat/Montserrat-Light.ttf",
    "https://github.com/google/fonts/raw/main/ofl/montserrat/Montserrat-SemiBold.ttf"
]

LoadFonts() {
    global LoadedFonts
    for url in FontUrls {
        fName := StrSplit(url, "/")[-1]
        fPath := A_ScriptDir "\" fName
        
        if !FileExist(fPath) {
            try {
                whr := ComObject("WinHttp.WinHttpRequest.5.1")
                whr.Open("GET", url, false)
                whr.Send()
                ADO := ComObject("ADODB.Stream")
                ADO.Type := 1
                ADO.Open()
                ADO.Write(whr.ResponseBody)
                ADO.SaveToFile(fPath, 2)
                ADO.Close()
            } catch {
                continue 
            }
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
!Esc::  ; Alt+Esc - остановка всех макросов (без закрытия скрипта)
{
    global StopMacro
    StopMacro := true
    ToolTip("Макросы остановлены!")
    SetTimer(() => ToolTip(), -2000)
}

; ===== ГЛАВНЫЙ ОВЕРЛЕЙ =====
ShowOverlay() {
    global OverlayGui
    OverlayGui := Gui("+AlwaysOnTop -Caption +ToolWindow +Border")
    OverlayGui.SetFont("s9 w400", "Montserrat")  ; Regular
    OverlayGui.Title := "СМП макрос"
    
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.SetFont("s10 w600", "Montserrat SemiBold")  ; SemiBold для заголовка
    OverlayGui.Add("Text", "Center w280", "ГОРЯЧИЕ КЛАВИШИ СМП")
    OverlayGui.SetFont("s9 w400", "Montserrat")  ; Regular для основного текста
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
    OverlayGui.SetFont("s8 w300", "Montserrat Light")  ; Light для подсказок
    OverlayGui.Add("Text",, "  Alt+F1 → Настройки клавиш")
    OverlayGui.Add("Text",, "  Ctrl+Esc → Остановка")
    OverlayGui.Add("Text",, "  Ctrl+R   → Перезапуск")
    OverlayGui.SetFont("s9 w400", "Montserrat")  ; Regular
    OverlayGui.Add("Text",, "═══════════════════════════════════════")

    ; === КНОПКА ЗАКРЫТИЯ ===
    BtnClose := OverlayGui.Add("Button", "Default w100 x10 y+10", "ЗАКРЫТЬ")
    BtnClose.OnEvent("Click", (*) => ExitApp())
    
    OverlayGui.Show()

    ; === ПЕРЕТАСКИВАНИЕ ЧЕРЕЗ OnMessage ===
    OnMessage(0x201, DragWindow)
}

; ===== ФУНКЦИЯ ДЛЯ ПЕРЕТАСКИВАНИЯ ОКНА =====
DragWindow(wParam, lParam, msg, hwnd) {
    global OverlayGui
    if (hwnd == OverlayGui.Hwnd) {
        PostMessage(0x112, 0xF011, 0,, OverlayGui)
        return true
    }
}

ShowOverlay()

; ===== ПОЛНАЯ ОСТАНОВКА СКРИПТА (Ctrl+Esc) =====
^Esc::
{
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
    MyGui.SetFont("s9 w400", "Montserrat")  ; Regular
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
    MyGui.SetFont("s9 w400", "Montserrat")  ; Regular
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
    MyGui.SetFont("s9 w400", "Montserrat")  ; Regular
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
    MyGui.SetFont("s9 w400", "Montserrat")  ; Regular
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
    MyGui.SetFont("s9 w400", "Montserrat")  ; Regular
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
    MyGui.SetFont("s9 w400", "Montserrat")  ; Regular
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
F1::
{
    global StopMacro, GetAddressInput
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Прибытие...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetAddressInput()
    if !Data
        return
    Address := Data.Address

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me прибыл на вызов по адресу: " Address " (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Скорая помощь на месте, оснащение готово (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 2. ОСМОТР ПАЦИЕНТА (Numpad2 / F2) =====
Numpad2::
F2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Осмотр...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me провёл первичный осмотр пациента (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Пульс: в норме, дыхание: ровное, кожные покровы: бледные (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 3. ПРОВЕРКА ПУЛЬСА / СЛР (Numpad3 / F3) =====
Numpad3::
F3::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Пульс / СЛР...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me проверил пульс у пациента (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Пульс есть? (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Choice := GetPulseChoice()
    if (Choice = "") {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    if (Choice = "ЕСТЬ") {
        Send("{Г down}")
        Sleep(30)
        Send("{Г up}")
        Sleep(50)
        Send("{Backspace}")
        PauseWithCheck(300)
        SendText("/do Пульс прощупывается, ритмичный (da da da)")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{Г down}")
        Sleep(30)
        Send("{Г up}")
        Sleep(50)
        Send("{Backspace}")
        PauseWithCheck(300)
        SendText("/do Артериальное давление в пределах нормы (da da da)")
        Send("{Enter}")
        PauseWithCheck(300)
    } else {
        Send("{Г down}")
        Sleep(30)
        Send("{Г up}")
        Sleep(50)
        Send("{Backspace}")
        PauseWithCheck(300)
        SendText("/do Пульс отсутствует! Начинаю реанимацию (da da da)")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{Г down}")
        Sleep(30)
        Send("{Г up}")
        Sleep(50)
        Send("{Backspace}")
        PauseWithCheck(300)
        SendText("/me приступил к сердечно-лёгочной реанимации (da da da)")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{Г down}")
        Sleep(30)
        Send("{Г up}")
        Sleep(50)
        Send("{Backspace}")
        PauseWithCheck(300)
        SendText("/me выполняет непрямой массаж сердца (da da da)")
        Send("{Enter}")
        PauseWithCheck(500)

        Send("{Г down}")
        Sleep(30)
        Send("{Г up}")
        Sleep(50)
        Send("{Backspace}")
        PauseWithCheck(300)
        SendText("/me провёл искусственную вентиляцию лёгких (da da da)")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{Г down}")
        Sleep(30)
        Send("{Г up}")
        Sleep(50)
        Send("{Backspace}")
        PauseWithCheck(300)
        SendText("/do Цикл СЛР завершён, пульс восстановлен? (da da da)")
        Send("{Enter}")
        PauseWithCheck(300)

        Result := GetSLRResultChoice()
        if (Result = "") {
            ToolTip("Отменено!")
            SetTimer(() => ToolTip(), -1500)
            return
        }

        if (Result = "ВОССТАНОВЛЕН") {
            Send("{Г down}")
            Sleep(30)
            Send("{Г up}")
            Sleep(50)
            Send("{Backspace}")
            PauseWithCheck(300)
            SendText("/do Пульс восстановлен, пациент стабилен (da da da)")
            Send("{Enter}")
            PauseWithCheck(300)
        } else {
            Send("{Г down}")
            Sleep(30)
            Send("{Г up}")
            Sleep(50)
            Send("{Backspace}")
            PauseWithCheck(300)
            SendText("/do Пульс не восстановлен! Продолжаю реанимацию (da da da)")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{Г down}")
            Sleep(30)
            Send("{Г up}")
            Sleep(50)
            Send("{Backspace}")
            PauseWithCheck(300)
            SendText("/me продолжаю СЛР до приезда подмоги (da da da)")
            Send("{Enter}")
            PauseWithCheck(300)
        }
    }

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 4. ИВЛ / КИСЛОРОД (Numpad4 / F4) =====
Numpad4::
F4::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("ИВЛ...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me подключил пациента к аппарату ИВЛ (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Подача кислорода: 40%, сатурация: 98% (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 5. ИНЪЕКЦИЯ / УКОЛ (Numpad5 / F5) =====
Numpad5::
F5::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Инъекция...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me сделал внутримышечную инъекцию (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Препарат введён, пациент стабилен (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 6. ЗАПИСЬ В КАРТУ (Numpad6 / F6) =====
Numpad6::
F6::
{
    global StopMacro, GetDiagnosisInput
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Запись...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetDiagnosisInput()
    if !Data
        return
    Diagnosis := Data.Diagnosis

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me заполнил медицинскую карту пациента (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Диагноз: " Diagnosis " (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 7. ВЫЗОВ ПОДМОГИ (Numpad7 / F7) =====
Numpad7::
F7::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Подмога...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me вызвал подмогу по рации (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do На место направлена дополнительная бригада (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 8. ОТЧЁТ О ГОСПИТАЛИЗАЦИИ (Numpad8 / F8) =====
Numpad8::
F8::
{
    global StopMacro, GetPatientInput
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Отчёт...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetPatientInput()
    if !Data
        return
    Patient := Data.Patient

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me передал отчёт о госпитализации (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Пациент " Patient " госпитализирован (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 9. РАЦИЯ (Numpad9 / F9) =====
Numpad9::
F9::
{
    global StopMacro, GetRadioMessage
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Рация...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetRadioMessage()
    if !Data
        return

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me снял рацию (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me зажал кнопку PPT (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Из динамика послышался звук включения (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("-Р- " Data.Message " (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me отпустил кнопку и убрал рацию (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; =====================================================
;   МАКРОСЫ ПМП (Ctrl+Numpad1-9 / Ctrl+F1-F9)
; =====================================================

; ===== 10. ОЦЕНКА СОСТОЯНИЯ (Ctrl+Numpad1 / Ctrl+F1) =====
^Numpad1::
^F1::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Оценка состояния...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me провёл быстрый осмотр пострадавшего (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Сознание: ясное, дыхание: свободное, пульс: прощупывается (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Кожные покровы: бледные, видимых травм не обнаружено (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 11. ДАВЯЩАЯ ПОВЯЗКА (Ctrl+Numpad2 / Ctrl+F2) =====
^Numpad2::
^F2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Давящая повязка...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me наложил стерильную давящую повязку (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Повязка наложена правильно, кровотечение остановлено (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 12. ШИНА (Ctrl+Numpad3 / Ctrl+F3) =====
^Numpad3::
^F3::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Шина...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me наложил шину на повреждённую конечность (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Конечность обездвижена, шина зафиксирована (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 13. ЖГУТ (Ctrl+Numpad4 / Ctrl+F4) =====
^Numpad4::
^F4::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Жгут...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me наложил жгут выше места кровотечения (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Кровотечение остановлено, время наложения зафиксировано (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 14. УСТОЙЧИВОЕ БОКОВОЕ ПОЛОЖЕНИЕ (Ctrl+Numpad5 / Ctrl+F5) =====
^Numpad5::
^F5::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Боковое положение...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me перевёл пострадавшего в устойчивое боковое положение (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Дыхательные пути свободны, поза стабильна (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 15. ХОЛОД НА ТРАВМУ (Ctrl+Numpad6 / Ctrl+F6) =====
^Numpad6::
^F6::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Холод...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me приложил холод к месту травмы (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Отёк уменьшается, боль притупляется (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 16. ПОМОЩЬ ПРИ ПЕРЕЛОМЕ (Ctrl+Numpad7 / Ctrl+F7) =====
^Numpad7::
^F7::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Перелом...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me оценил состояние перелома, обездвижил конечность (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Повреждённая область зафиксирована, ожидание скорой (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 17. ВЫЗОВ СКОРОЙ / ЭВАКУАЦИЯ (Ctrl+Numpad8 / Ctrl+F8) =====
^Numpad8::
^F8::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Эвакуация...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me вызвал скорую помощь и подготовил пострадавшего к эвакуации (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Пострадавший готов к транспортировке (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 18. ТРАНСПОРТИРОВКА НА НОСИЛКАХ (Ctrl+Numpad9 / Ctrl+F9) =====
^Numpad9::
^F9::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Носилки...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me перенёс пострадавшего на носилки, зафиксировал ремнями (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Пострадавший зафиксирован, транспортировка безопасна (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== ПЕРЕЗАПУСК (Ctrl+R) =====
^r::
{
    ToolTip("Перезапуск...")
    SetTimer(() => ToolTip(), -1500)
    Sleep(500)
    Reload()
}