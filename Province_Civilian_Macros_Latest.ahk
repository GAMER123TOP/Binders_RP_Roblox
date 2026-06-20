#Requires AutoHotkey v2.0
SendMode("Event")
SetKeyDelay(50, 50)

; ===== ГЛОБАЛЬНЫЕ НАСТРОЙКИ =====
global StopMacro := false

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
    OverlayGui.Title := "Гражданские макросы"
    
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.Add("Text",, "  ГОРЯЧИЕ КЛАВИШИ")
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.Add("Text",, "  Numpad1 / F1  → Смотрит по сторонам")
    OverlayGui.Add("Text",, "  Numpad2 / F2  → Достаёт телефон")
    OverlayGui.Add("Text",, "  Numpad3 / F3  → Убирает телефон")
    OverlayGui.Add("Text",, "  Numpad4 / F4  → Открывает дверь")
    OverlayGui.Add("Text",, "  Numpad5 / F5  → Закрывает дверь")
    OverlayGui.Add("Text",, "  Numpad6 / F6  → Садится в машину")
    OverlayGui.Add("Text",, "  Numpad7 / F7  → Выходит из машины")
    OverlayGui.Add("Text",, "  Numpad8 / F8  → Поворачивается к ...")
    OverlayGui.Add("Text",, "  Numpad9 / F9  → Смотрит на ...")
    OverlayGui.Add("Text",, "  Numpad0 / F10  → Протягивает ...")
    OverlayGui.Add("Text",, "  Ctrl+Numpad1 / Ctrl+F1 → Эмоция")
    OverlayGui.Add("Text",, "  Ctrl+Numpad2 / Ctrl+F2 → Анимация")
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
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

; ===== GUI: ВВОД ТЕКСТА ДЛЯ ДЕЙСТВИЙ =====
GetActionInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Введите текст"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "К кому/чему действие?")
    MyGui.Add("Edit", "vActionText w250")
    
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

; ===== GUI: ВЫБОР ЭМОЦИИ =====
GetEmotionChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Эмоция"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Выберите эмоцию:")
    
    Choice := ""
    
    SmileClick(*) {
        Choice := "улыбнулся"
        MyGui.Hide()
    }
    
    AngryClick(*) {
        Choice := "нахмурился"
        MyGui.Hide()
    }
    
    SurpriseClick(*) {
        Choice := "удивлённо поднял бровь"
        MyGui.Hide()
    }
    
    SadClick(*) {
        Choice := "грустно вздохнул"
        MyGui.Hide()
    }
    
    ThoughtfulClick(*) {
        Choice := "задумался, прикоснувшись к подбородку"
        MyGui.Hide()
    }
    
    MyGui.Add("Button", "Default w110 y+10 x10", "УЛЫБНУЛСЯ").OnEvent("Click", SmileClick)
    MyGui.Add("Button", "x+5 w110", "НАХМУРИЛСЯ").OnEvent("Click", AngryClick)
    MyGui.Add("Button", "w110 y+5 x10", "УДИВИЛСЯ").OnEvent("Click", SurpriseClick)
    MyGui.Add("Button", "x+5 w110", "ГРУСТНЫЙ").OnEvent("Click", SadClick)
    MyGui.Add("Button", "w110 y+5 x10", "ЗАДУМАЛСЯ").OnEvent("Click", ThoughtfulClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

; ===== GUI: ВЫБОР АНИМАЦИИ =====
GetAnimationChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Анимация"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Выберите анимацию:")
    
    Choice := ""
    
    NodClick(*) {
        Choice := "кивнул головой"
        MyGui.Hide()
    }
    
    ShakeClick(*) {
        Choice := "покачал головой"
        MyGui.Hide()
    }
    
    ShrugClick(*) {
        Choice := "пожал плечами"
        MyGui.Hide()
    }
    
    WaveClick(*) {
        Choice := "помахал рукой"
        MyGui.Hide()
    }
    
    PointClick(*) {
        Choice := "указал рукой в сторону"
        MyGui.Hide()
    }
    
    MyGui.Add("Button", "Default w110 y+10 x10", "КИВНУЛ").OnEvent("Click", NodClick)
    MyGui.Add("Button", "x+5 w110", "ПОКАЧАЛ").OnEvent("Click", ShakeClick)
    MyGui.Add("Button", "w110 y+5 x10", "ПОЖАЛ ПЛЕЧАМИ").OnEvent("Click", ShrugClick)
    MyGui.Add("Button", "x+5 w110", "ПОМАХАЛ").OnEvent("Click", WaveClick)
    MyGui.Add("Button", "w110 y+5 x10", "УКАЗАЛ").OnEvent("Click", PointClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

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
    SendText("/me медленно повернул голову, осматриваясь по сторонам")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Взгляд пробежал по прохожим и машинам")
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
    SendText("/me полез в карман и достал телефон")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Экран загорелся, пальцы пробежали по стеклу")
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
    SendText("/me убрал телефон обратно в карман")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Телефон скрылся в кармане куртки")
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
    SendText("/me взялся за ручку и открыл дверь")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Дверь со скрипом отворилась")
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
    SendText("/me взялся за ручку и плавно закрыл дверь")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Дверь захлопнулась с глухим стуком")
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
    SendText("/me открыл дверь и сел в машину")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me пристегнулся и закрыл дверь")
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
    SendText("/me отстегнул ремень и открыл дверь")
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/me вышел из машины и закрыл дверь")
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
    SendText("/me плавно развернулся к " ActionText)
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Взгляд устремился в сторону " ActionText)
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
    SendText("/me пристально посмотрел на " ActionText)
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("/do Взгляд остановился на " ActionText)
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
    Send("{Backspace up}")
    PauseWithCheck(300)
    SendText("/me протянул руку и передал " ActionText)
    Send("{Enter}")
    PauseWithCheck(300)
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    PauseWithCheck(300)
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    SendText("/do Рука замерла в ожидании")
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
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me " Choice)
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
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me " Choice)
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
; 54545454544
