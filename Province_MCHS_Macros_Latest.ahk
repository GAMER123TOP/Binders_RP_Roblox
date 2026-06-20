#Requires AutoHotkey v2.0
SendMode("Event")
SetKeyDelay(50, 50)

; ===== ГЛОБАЛЬНЫЕ НАСТРОЙКИ =====
global StopMacro := false
global CurrentPage := 1

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
    global OverlayGui, CurrentPage
    if IsSet(OverlayGui) && OverlayGui.Hwnd
        OverlayGui.Destroy()
    
    OverlayGui := Gui("+AlwaysOnTop -Caption +ToolWindow +Border")
    OverlayGui.Title := "МЧС макрос"
    
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.Add("Text",, "  ГОРЯЧИЕ КЛАВИШИ МЧС — СТР. " CurrentPage "/2")
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
    
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    
    ; ===== КНОПКИ ПЕРЕКЛЮЧЕНИЯ СТРАНИЦ =====
    BtnPrev := OverlayGui.Add("Button", "w40", "◄")
    BtnPrev.OnEvent("Click", (*) => SwitchPage(-1)) ; Оживили кнопку "Назад"

    PageText := OverlayGui.Add("Text", "x+5 yp+5 w50 Center", "СТР " CurrentPage "/2")

    BtnNext := OverlayGui.Add("Button", "x+5 yp-5 w40", "►")
    BtnNext.OnEvent("Click", (*) => SwitchPage(1))  ; Оживили кнопку "Вперед"
    
    ; ===== НИЖНИЙ БЛОК (Выровнен с x10) =====
    OverlayGui.Add("Text", "x10", "═══════════════════════════════════════")
    OverlayGui.Add("Text",, "  Ctrl+Esc → Остановка")
    OverlayGui.Add("Text",, "  Ctrl+R   → Перезапуск")
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

; ===== ФУНКЦИЯ ПЕРЕКЛЮЧЕНИЯ СТРАНИЦ =====
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

; =====================================================
;   ИНТЕРФЕЙСЫ
; =====================================================

; ===== GUI: АДРЕС ВЫЗОВА =====
GetAddressInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Адрес вызова"
    MyGui.SetFont("s9")
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

; ===== GUI: КОЛИЧЕСТВО ПОСТРАДАВШИХ =====
GetVictimsCountInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Количество пострадавших"
    MyGui.SetFont("s9")
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

; ===== GUI: СООБЩЕНИЕ ДЛЯ РАЦИИ =====
GetRadioMessage() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Сообщение для рации"
    MyGui.SetFont("s9")
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

; ===== GUI: ХАРАКТЕР ЧП =====
GetSituationInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Характер ЧП"
    MyGui.SetFont("s9")
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
F1::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Прибытие...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetAddressInput()
    if !IsObject(Data)
        return
    Address := Data.Address

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me прибыл на место вызова по адресу: " Address " (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do На месте ЧП слышны крики, чувствуется запах гари (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 2. ОСМОТР (Numpad2 / F2) =====
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

    Situation := GetSituationInput()
    if (Situation = "")
        return

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me осматривает место происшествия, оценивает обстановку (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    if (Situation = "ПОЖАР") {
        Send("{Г down}")
        Sleep(30)
        Send("{Г up}")
        Sleep(50)
        Send("{Backspace}")
        PauseWithCheck(300)
        SendText("/do Огонь распространяется на соседние здания, слышен треск (da da da)")
    } else if (Situation = "ДТП") {
        Send("{Г down}")
        Sleep(30)
        Send("{Г up}")
        Sleep(50)
        Send("{Backspace}")
        PauseWithCheck(300)
        SendText("/do Машины сильно деформированы, есть риск возгорания топлива (da da da)")
    } else if (Situation = "УТЕЧКА ГАЗА") {
        Send("{Г down}")
        Sleep(30)
        Send("{Г up}")
        Sleep(50)
        Send("{Backspace}")
        PauseWithCheck(300)
        SendText("/do В воздухе чувствуется запах газа, есть угроза взрыва (da da da)")
    } else if (Situation = "ЗАВАЛ") {
        Send("{Г down}")
        Sleep(30)
        Send("{Г up}")
        Sleep(50)
        Send("{Backspace}")
        PauseWithCheck(300)
        SendText("/do Конструкции нестабильны, есть риск обрушения (da da da)")
    }
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 3. РАЗВЕДКА (Numpad3 / F3) =====
Numpad3::
F3::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Разведка...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me надевает СИЗОД, проверяет герметичность (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do СИЗОД готов, дыхание через аппарат свободное (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me входит в задымлённое помещение, пригибаясь (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Видимость почти нулевая, чувствуется сильное задымление (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me ведёт рукой вдоль стены, ориентируясь на ощупь (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Поиск идёт вслепую, слышен треск горящих конструкций (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 4. НАДЕВАНИЕ СИЗОД (Numpad4 / F4) =====
Numpad4::
F4::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("СИЗОД...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me достаёт СИЗОД, проверяет целостность маски (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Маска герметична, баллон заправлен (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me надевает СИЗОД, регулирует крепления (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Маска плотно прилегает, дыхание свободное (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 5. ТУШЕНИЕ (Numpad5 / F5) =====
Numpad5::
F5::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Тушение...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me снимает огнетушитель с крепления (4-5 кг) (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Огнетушитель в руке, чувствуется вес (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me выдёргивает чеку, направляет раструб на огонь (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Из огнетушителя выходит белая пена, пламя гаснет (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 6. РАЗВЁРТЫВАНИЕ РУКАВА (Numpad6 / F6) =====
Numpad6::
F6::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Рукав...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me открывает отсек пожарной машины, достаёт рукав (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Рукав скатан, готов к развёртыванию (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me подключает рукав к выходу на пожарной машине (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Соединение герметично, зажимы зафиксированы (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me разворачивает рукав в сторону очага возгорания (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Рукав заполняется водой, давление нарастает (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me направляет ствол на огонь, открывает подачу воды (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Вода бьёт мощной струёй, пламя сбивается (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 7. ЭВАКУАЦИЯ (Numpad7 / F7) =====
Numpad7::
F7::
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
    SendText("/me выводит людей из опасной зоны, прикрывая лицо (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Люди испуганы, но все целы, эвакуация завершена (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 8. ПРОЛИВКА (Numpad8 / F8) =====
Numpad8::
F8::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Проливка...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me проливает место пожара водой (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Поверхность остывает, дым рассеивается (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 9. РАЦИЯ (Numpad9 / F9) =====
Numpad9::
F9::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Рация...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetRadioMessage()
    if !IsObject(Data)
        return
    Message := Data.Message

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
    SendText("-Р- " Message " (da da da)")
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

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 10. ОБЩИЙ СБОР (Numpad0 / F10) =====
Numpad0::
F10::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Сбор...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me объявляет сбор всех свободных экипажей МЧС (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do На месте ЧП паника, слышны крики о помощи (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me запрыгивает в машину, заводит двигатель (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Машина готова к выезду, все на местах (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 11. ПРОВЕРКА СИЗОД (Ctrl+Numpad1 / Ctrl+F1) =====
^Numpad1::
^F1::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Проверка СИЗОД...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me проверяет давление в баллоне СИЗОД (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Давление в норме, воздуха хватит на 30 минут (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 12. ЗАМЕНА БАЛЛОНА (Ctrl+Numpad2 / Ctrl+F2) =====
^Numpad2::
^F2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Замена баллона...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me заменяет пустой баллон СИЗОД на полный (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Баллон зафиксирован, система герметична (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 13. СНЯТИЕ СИЗОД (Ctrl+Numpad3 / Ctrl+F3) =====
^Numpad3::
^F3::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Снятие СИЗОД...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me снимает СИЗОД, вытирает лицо (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do СИЗОД убран в чехол, готов к использованию (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 14. СПАСАТЕЛЬНЫЕ РАБОТЫ (Ctrl+Numpad4 / Ctrl+F4) =====
^Numpad4::
^F4::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Спасательные работы...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me оценивает завал, ищет безопасный подход (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Из-под завалов слышны слабые стоны (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me аккуратно разбирает завалы, работая руками (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Пострадавший найден, зажат плитой (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me освобождает пострадавшего, оказывает первую помощь (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Пострадавший в сознании, дыхание стабильное (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 15. ВСКРЫТИЕ ДВЕРИ (Ctrl+Numpad5 / Ctrl+F5) =====
^Numpad5::
^F5::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Вскрытие...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me вскрывает заблокированную дверь с помощью лома (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Дверь поддаётся, проход открыт (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 16. ПОИСК В ДЫМУ (Ctrl+Numpad6 / Ctrl+F6) =====
^Numpad6::
^F6::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Поиск...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me ведёт поиск в сильно задымлённом помещении (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Видимость нулевая, поиск идёт вслепую (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me нащупывает стены, двигается медленно (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Слышен треск, но людей не видно (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 17. ДОКЛАД КОМАНДИРУ (Ctrl+Numpad7 / Ctrl+F7) =====
^Numpad7::
^F7::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Доклад...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetVictimsCountInput()
    if !IsObject(Data)
        return
    Count := Data.Count

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me подходит к командиру, докладывает обстановку (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Пожар локализован, угрозы распространения нет (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me докладывает количество пострадавших (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Пострадавших: " Count ", переданы медикам (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me запрашивает дальнейшие указания (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Командир кивает, отдаёт приказ на проливку (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 18. ЗАПРОС ПОДКРЕПЛЕНИЯ (Ctrl+Numpad8 / Ctrl+F8) =====
^Numpad8::
^F8::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Подкрепление...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me запрашивает подкрепление по рации (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Рация передала: `"Подкрепление в пути`" (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 19. ОТЧЁТ ОБ ОКОНЧАНИИ (Ctrl+Numpad9 / Ctrl+F9) =====
^Numpad9::
^F9::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Отчёт...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me докладывает об окончании работ (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Объект безопасен, очаг возгорания нейтрализован (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 20. ОТБОЙ ТРЕВОГИ (Ctrl+Numpad0 / Ctrl+F10) =====
^Numpad0::
^F10::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Отбой...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me отбой тревоги, вызов ложный (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do При повторной проверке очаг не обнаружен (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; =====================================================
;   МАКРОСЫ МЧС - СТРАНИЦА 2
; =====================================================

; ===== 1. ПЕРВАЯ ПОМОЩЬ (Shift+Numpad1 / Shift+F1) =====
+Numpad1::
+F1::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Первая помощь...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me осматривает пострадавшего на наличие травм (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do У пострадавшего ссадины и ушибы, переломов нет (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me накладывает стерильную повязку на рану (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Кровотечение остановлено, повязка наложена правильно (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me укладывает пострадавшего в устойчивое боковое положение (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Дыхание свободное, пострадавший в сознании (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 2. ГЕРМЕТИЧНОСТЬ (Shift+Numpad2 / Shift+F2) =====
+Numpad2::
+F2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Герметичность...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me проверяет герметичность маски СИЗОД (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Маска плотно прилегает, утечек нет (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 3. СТЁКЛА (Shift+Numpad3 / Shift+F3) =====
+Numpad3::
+F3::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Стёкла...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me снимает маску СИЗОД, проверяет стёкла (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Стёкла целы, маска готова к повторному использованию (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 4. КЛАПАН (Shift+Numpad4 / Shift+F4) =====
+Numpad4::
+F4::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Клапан...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me проверяет клапан выдоха СИЗОД (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Клапан работает исправно, воздух выходит свободно (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 5. ОГНЕТУШИТЕЛЬ (Shift+Numpad5 / Shift+F5) =====
+Numpad5::
+F5::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Огнетушитель...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me проверяет срок годности огнетушителя (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Срок годности в норме, огнетушитель готов к применению (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 6. СОЕДИНЕНИЕ (Shift+Numpad6 / Shift+F6) =====
+Numpad6::
+F6::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Соединение...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me проверяет соединение рукава с машиной (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Соединение герметично, подтеканий нет (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 7. ПЕРЕСЧЁТ (Shift+Numpad7 / Shift+F7) =====
+Numpad7::
+F7::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Пересчёт...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me пересчитывает эвакуированных людей (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Все на месте, потерь нет (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 8. ТЕМПЕРАТУРА (Shift+Numpad8 / Shift+F8) =====
+Numpad8::
+F8::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Температура...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me проверяет температуру после проливки (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Температура в норме, возгорание исключено (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 9. НАСТРОЙКА РАЦИИ (Shift+Numpad9 / Shift+F9) =====
+Numpad9::
+F9::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Настройка рации...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me настраивает частоту рации (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Связь установлена, помех нет (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 10. ГОТОВНОСТЬ (Shift+Numpad0 / Shift+F10) =====
+Numpad0::
+F10::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Готовность...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me проверяет готовность экипажа (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Все сотрудники на местах, готовы к выезду (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 11. ХОД РАБОТ (Alt+Numpad1 / Alt+F1) =====
!Numpad1::
!F1::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Ход работ...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me докладывает о ходе работ (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Работы идут по плану, отклонений нет (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 12. РАСХОД ВОДЫ (Alt+Numpad2 / Alt+F2) =====
!Numpad2::
!F2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Расход воды...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me докладывает о расходе воды (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Воды достаточно, запас пополнен (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 13. ТЕХНИКА (Alt+Numpad3 / Alt+F3) =====
!Numpad3::
!F3::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Техника...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me докладывает о состоянии техники (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Техника исправна, готова к дальнейшей работе (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 14. ПУЛЬС (Alt+Numpad4 / Alt+F4) =====
!Numpad4::
!F4::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Пульс...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me проверяет пульс у пострадавшего (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Пульс прощупывается, ритмичный (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 15. ДВЕРЬ (Alt+Numpad5 / Alt+F5) =====
!Numpad5::
!F5::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Дверь...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me проверяет дверь на наличие заклинивания (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Дверь открывается свободно (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 16. ПРИСЛУШИВАНИЕ (Alt+Numpad6 / Alt+F6) =====
!Numpad6::
!F6::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Прислушивание...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me прислушивается к звукам в дыму (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Слышны голоса, поиск продолжается (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 17. ЗАВЕРШЕНИЕ ЭТАПА (Alt+Numpad7 / Alt+F7) =====
!Numpad7::
!F7::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Завершение этапа...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me докладывает о завершении этапа работ (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Этап завершён, приступаю к следующему (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 18. ВРЕМЯ ПОДКРЕПЛЕНИЯ (Alt+Numpad8 / Alt+F8) =====
!Numpad8::
!F8::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Время подкрепления...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me уточняет время прибытия подкрепления (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Подкрепление прибудет через 5 минут (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 19. СДАЧА ОТЧЁТА (Alt+Numpad9 / Alt+F9) =====
!Numpad9::
!F9::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Сдача отчёта...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me сдаёт отчёт о работе (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Отчёт принят, замечаний нет (da da da)")
    Send("{Enter}")

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 20. ОБЪЯВЛЕНИЕ ОТБОЯ (Alt+Numpad0 / Alt+F10) =====
!Numpad0::
!F10::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Объявление отбоя...")
    SetTimer(() => ToolTip(), -1500)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/me объявляет отбой для личного состава (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    PauseWithCheck(300)
    SendText("/do Все расходятся, дежурство продолжается (da da da)")
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
