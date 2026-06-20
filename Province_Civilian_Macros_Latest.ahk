; =====================================================
;   МАКРОСЫ
; =====================================================

; ===== 1. СМОТРИТ ПО СТОРОНАМ (Numpad1) =====
Numpad1::
F1::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me медленно повернул голову, осматриваясь по сторонам (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Взгляд пробежал по прохожим и машинам (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 2. ДОСТАЁТ ТЕЛЕФОН (Numpad2) =====
Numpad2::
F2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me полез в карман и достал телефон (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Экран загорелся, пальцы пробежали по стеклу (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 3. УБИРАЕТ ТЕЛЕФОН (Numpad3) =====
Numpad3::
F3::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me убрал телефон обратно в карман (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Телефон скрылся в кармане куртки (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 4. ОТКРЫВАЕТ ДВЕРЬ (Numpad4) =====
Numpad4::
F4::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me взялся за ручку и открыл дверь (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Дверь со скрипом отворилась (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 5. ЗАКРЫВАЕТ ДВЕРЬ (Numpad5) =====
Numpad5::
F5::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me взялся за ручку и плавно закрыл дверь (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Дверь захлопнулась с глухим стуком (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 6. САДИТСЯ В МАШИНУ (Numpad6) =====
Numpad6::
F6::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me открыл дверь и сел в машину (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me пристегнулся и закрыл дверь (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 7. ВЫХОДИТ ИЗ МАШИНЫ (Numpad7) =====
Numpad7::
F7::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me отстегнул ремень и открыл дверь (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me вышел из машины и закрыл дверь (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 8. ПОВОРАЧИВАЕТСЯ К ... (Numpad8) =====
Numpad8::
F8::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Data := GetActionInput()
    if !Data
        return
    ActionText := Data.ActionText
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me плавно развернулся к " ActionText " (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Взгляд устремился в сторону " ActionText " (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 9. СМОТРИТ НА ... (Numpad9) =====
Numpad9::
F9::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Data := GetActionInput()
    if !Data
        return
    ActionText := Data.ActionText
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me пристально посмотрел на " ActionText " (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Взгляд остановился на " ActionText " (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 10. ПРОТЯГИВАЕТ ... (Numpad0) =====
Numpad0::
F10::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Data := GetActionInput()
    if !Data
        return
    ActionText := Data.ActionText
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me протянул руку и передал " ActionText " (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Рука замерла в ожидании (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 11. ЭМОЦИЯ (Ctrl+Numpad1) =====
^Numpad1::
^F1::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Choice := GetEmotionChoice()
    if Choice = "" {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me " Choice " (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 12. АНИМАЦИЯ (Ctrl+Numpad2) =====
^Numpad2::
^F2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Choice := GetAnimationChoice()
    if Choice = "" {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me " Choice " (da da da)")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}
