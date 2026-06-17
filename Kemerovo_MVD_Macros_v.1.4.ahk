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

; ===== ГЛААВНЫЙ ОВЕРЛЕЙ ====
ShowOverlay() {
    global OverlayGui
    OverlayGui := Gui("+AlwaysOnTop -Caption +ToolWindow +Border")
    OverlayGui.Title := "МВД макрос"
    
    ; === ТЕКСТ ОВЕРЛЕЯ ===
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.Add("Text",, "  ГОРЯЧИЕ КЛАВИШИ МВД")
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.Add("Text",, "  Numpad1 / F1  → Чистка ПМ")
    OverlayGui.Add("Text",, "  Numpad2 / F2  → Представление")
    OverlayGui.Add("Text",, "  Numpad3 / F3  → Ксива")
    OverlayGui.Add("Text",, "  Numpad4 / F4  → Наручники / Обыск")
    OverlayGui.Add("Text",, "  Numpad5 / F5  → Рация")
    OverlayGui.Add("Text",, "  Numpad6 / F6  → Миранда")
    OverlayGui.Add("Text",, "  Numpad7 / F7  → Вести к машине / ИВС")
    OverlayGui.Add("Text",, "  Numpad8 / F8  → ПМ в боевое")
    OverlayGui.Add("Text",, "  Numpad9 / F9  → Мегафон")
    OverlayGui.Add("Text",, "  Numpad0 / F10 → Штраф")
    OverlayGui.Add("Text",, "  Ctrl+Numpad1 / Ctrl+F1 → Вытаскивание из машины")
    OverlayGui.Add("Text",, "  Ctrl+Numpad2 / Ctrl+F2 → Оформление ДТП")
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

; ===== GUI: ВВОД ДАННЫХ ДЛЯ ПРЕДСТАВЛЕНИЯ =====
GetUserInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Введите данные для отыгровки"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Отдел:")
    MyGui.Add("Edit", "vDepartment w220")
    MyGui.Add("Text",, "Звание:")
    MyGui.Add("Edit", "vRank w220")
    MyGui.Add("Text",, "Фамилия:")
    MyGui.Add("Edit", "vLastName w220")
    
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
    MyGui.Title := "Введите сообщение для рации"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Сообщение:")
    MyGui.Add("Edit", "vMessage w320")
    
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

; ===== GUI: ВЫБОР ПЕРЕЗАРЯДКИ ПМ =====
GetReloadChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Перезарядка ПМ"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Нужна перезарядка ПМ?")
    
    Choice := ""
    
    YesClick(*) {
        Choice := "ДА"
        MyGui.Hide()
    }
    
    NoClick(*) {
        Choice := "НЕТ"
        MyGui.Hide()
    }
     
    MyGui.Add("Button", "Default w70 x10 y+10", "ДА").OnEvent("Click", YesClick)
    MyGui.Add("Button", "x+10 w70", "НЕТ").OnEvent("Click", NoClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

; ===== GUI: ВЫБОР ДЕЙСТВИЯ ДЛЯ НАРУЧНИКОВ/ОБЫСКА =====
GetCuffChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Наручники / Обыск"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Выберите действие:")
    
    Choice := ""
    
    CuffClick(*) {
        Choice := "НАДЕТЬ"
        MyGui.Hide()
    }
    
    ReleaseClick(*) {
        Choice := "СНЯТЬ"
        MyGui.Hide()
    }
    
    SearchClick(*) {
        Choice := "ОБЫСК"
        MyGui.Hide()
    }
    
    MyGui.Add("Button", "Default w70 y+10 x10", "НАДЕТЬ").OnEvent("Click", CuffClick)
    MyGui.Add("Button", "x+5 w70", "СНЯТЬ").OnEvent("Click", ReleaseClick)
    MyGui.Add("Button", "x+5 w70", "ОБЫСК").OnEvent("Click", SearchClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

; ===== GUI: ИНФОРМАЦИЯ О ТИПАХ ОБЫСКА =====
ShowSearchInfo() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Типы обыска"
    MyGui.SetFont("s9")
    
    MyGui.Add("Text",, "Поверхностная проверка (досмотр)")
    MyGui.Add("Text",, "Это превентивная мера, направленная на выявление потенциальной угрозы.")
    MyGui.Add("Text",, "Цель: Проверка на наличие оружия или запрещенных предметов, если у полиции есть основания полагать, что вы можете представлять опасность.")
    MyGui.Add("Text",, "Как проводится: Полицейский визуально осматривает вас, проводит руками по вашей одежде, может использовать специальные приборы (металлоискатель) или осматривать личные вещи.")
    MyGui.Add("Text",, "Ограничения: Вы остаетесь в своей одежде. Это не является следственным действием и не требует составления протокола в обязательном порядке при первичном контакте.")
    MyGui.Add("Text",, "")
     
    MyGui.Add("Text",, "Личный обыск")
    MyGui.Add("Text",, "Это полноценное процессуальное или следственное действие, направленное на поиск доказательств.")
    MyGui.Add("Text",, "Цель: Обнаружение и изъятие предметов, орудий преступления или документов, имеющих значение для уголовного дела.")
    MyGui.Add("Text",, "Основания: Проводится строго после возбуждения уголовного дела или при задержании подозреваемого.")
    MyGui.Add("Text",, "Как проводится: Осуществляется уполномоченным лицом в присутствии понятых. При этом обыскивающий и понятые обязательно должны быть одного пола с обыскиваемым.")
    MyGui.Add("Text",, "Процедура: Составляется официальный протокол с перечислением всех изъятых вещей.")
    MyGui.Add("Text",, "Официальное регулирование процедуры в РФ описано в УПК РФ Статья 184.")
    MyGui.Add("Text",, "")
    
    MyGui.Add("Button", "Default", "ПОНЯТНО").OnEvent("Click", (*) => MyGui.Hide())
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
}

; ===== GUI: ВЫБОР ТИПА ОБЫСКА =====
GetSearchType() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Тип обыска"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Какой обыск проводим?")
    
    Result := {Choice: ""}
    
    InfoClick(*) {
        MyGui.Hide()
        ShowSearchInfo()
        Result.Choice := GetSearchType()
    }
    
    SurfaceClick(*) {
        Result.Choice := "ПОВЕРХНОСТНЫЙ"
        MyGui.Hide()
    }
    
    PersonalClick(*) {
        Result.Choice := "ЛИЧНЫЙ"
        MyGui.Hide()
    }
    
    MyGui.Add("Button", "Default", "ЧТО ЭТО?").OnEvent("Click", InfoClick)
    MyGui.Add("Button", "x+m", "ПОВЕРХНОСТНЫЙ").OnEvent("Click", SurfaceClick)
    MyGui.Add("Button", "x+m", "ЛИЧНЫЙ").OnEvent("Click", PersonalClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Result.Choice
}

; ===== GUI: ВЫБОР ПОНЯТЫХ =====
GetWitnessChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Понятые"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Понятые присутствуют?")
    
    Choice := ""
    
    WithClick(*) {
        Choice := "С ПОНЯТЫМИ"
        MyGui.Hide()
    }
    
    WithoutClick(*) {
        Choice := "БЕЗ ПОНЯТЫХ"
        MyGui.Hide()
    }
    
    MyGui.Add("Button", "Default w100 y+10 x10", "С ПОНЯТЫМИ").OnEvent("Click", WithClick)
    MyGui.Add("Button", "x+10 w100", "БЕЗ ПОНЯТЫХ").OnEvent("Click", WithoutClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

; ===== GUI: ЕСТЬ ЗАПРЕЩЁНКА? =====
GetContrabandQuestion() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Обнаружение запрещённых предметов"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Есть запрещёнка?")
    
    Choice := ""
    MyGui.Add("Button", "Default w70 y+10 x10", "ДА").OnEvent("Click", (*) => (Choice := "ДА", MyGui.Hide()))
    MyGui.Add("Button", "x+10 w70", "НЕТ").OnEvent("Click", (*) => (Choice := "НЕТ", MyGui.Hide()))
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

; ===== GUI: КОЛ-ВО ИЗЪЯТОГО =====
GetContrabandAmount() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Количество изъятого"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Введите количество изъятых предметов:")
    MyGui.Add("Edit", "vAmount w180")
    
    MyGui.Add("Button", "Default w80 y+10 x10", "ОК").OnEvent("Click", (*) => MyGui.Hide())
    
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

; ===== GUI: ВВОД ДАННЫХ ДЛЯ МЕГАФОНА =====
GetMegaphoneInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Мегафон"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Марка и модель машины (например: BMW X5):")
    MyGui.Add("Edit", "vCarModel w250")
    MyGui.Add("Text",, "Цвет машины:")
    MyGui.Add("Edit", "vCarColor w250")
    MyGui.Add("Text",, "Сколько предупреждений будет?")
    MyGui.Add("DropDownList", "vWarnings w250 Choose1", ["1", "2", "3"])
    
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

; ===== GUI: ВВОД ДАННЫХ ДЛЯ ШТРАФА =====
GetFineInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Решение по правонарушению"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Фамилия Имя водителя:")
    MyGui.Add("Edit", "vDriverName w280")
    MyGui.Add("Text",, "Марка и модель:")
    MyGui.Add("Edit", "vCar w280")
    MyGui.Add("Text",, "Госномер автомобиля:")
    MyGui.Add("Edit", "vPlate w280")
    MyGui.Add("Text",, "Статья:")
    MyGui.Add("Edit", "vLaw w280")
    MyGui.Add("Text",, "Сумма:")
    MyGui.Add("Edit", "vSum w280")
    MyGui.Add("Text",, "Тип документа:")
    MyGui.Add("Text",, "ПОСТАНОВЛЕНИЕ - водитель согласен, ПРОТОКОЛ - водитель не согласен")
    MyGui.Add("DropDownList", "vDocType w280 Choose1", ["ПОСТАНОВЛЕНИЕ", "ПРОТОКОЛ"])

    MyGui.Add("Button", "Default w140 y+10 x10", "ВЫПИСАТЬ ШТРАФ").OnEvent("Click", (*) => (MyGui.Result := "FINE", MyGui.Hide()))
    MyGui.Add("Button", "x+10 w140", "ПРЕДУПРЕЖДЕНИЕ").OnEvent("Click", (*) => (MyGui.Result := "WARN", MyGui.Hide()))
    
    MyGui.Show()
    WinWaitClose(MyGui)
    try {
        Data := MyGui.Submit()
        Data.Result := MyGui.Result
        MyGui.Destroy()
        return Data
    } catch {
        return ""
    }
}

; ===== GUI: ВЫБОР ДЕЙСТВИЯ ДЛЯ NUMPAD7 =====
GetArrestChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Доставление"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Куда доставляем задержанного?")
    
    Choice := ""
    
    CarClick(*) {
        Choice := "МАШИНА"
        MyGui.Hide()
    }
    
    KPClick(*) {
        Choice := "ИВС"
        MyGui.Hide()
    }
    
    MyGui.Add("Button", "Default w100 y+10 x10", "К МАШИНЕ").OnEvent("Click", CarClick)
    MyGui.Add("Button", "x+10 w100", "В ИВС").OnEvent("Click", KPClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

; ===== GUI: ВЫБОР ОСНОВАНИЯ ДЛЯ ВЫТАСКИВАНИЯ =====
GetExtractChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Вытаскивание из машины"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Выберите причину:")
    
    Choice := ""
    
    RefuseClick(*) {
        Choice := "ОТКАЗ"
        MyGui.Hide()
    }
    
    CriminalClick(*) {
        Choice := "РОЗЫСК/УГОН"
        MyGui.Hide()
    }
    
    DangerClick(*) {
        Choice := "ОПАСНОСТЬ"
        MyGui.Hide()
    }
    
    RescueClick(*) {
        Choice := "СПАСЕНИЕ"
        MyGui.Hide()
    }
    
    MyGui.Add("Button", "Default w140 y+10 x10", "ОТКАЗ ПОДЧИНИТЬСЯ").OnEvent("Click", RefuseClick)
    MyGui.Add("Button", "x+5 w140", "РОЗЫСК/УГОН").OnEvent("Click", CriminalClick)
    MyGui.Add("Button", "w140 y+5 x10", "ОПАСНОЕ ПОВЕДЕНИЕ").OnEvent("Click", DangerClick)
    MyGui.Add("Button", "x+5 w140", "СПАСЕНИЕ ЖИЗНИ").OnEvent("Click", RescueClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

; ===== GUI: ДВЕРЬ ЗАБЛОКИРОВАНА? =====
GetExtractDoorChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Дверь"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Дверь не заблокирована?")
    
    Choice := ""
    
    YesClick(*) {
        Choice := "ЗАБЛОКИРОВАНА"
        MyGui.Hide()
    }
    
    NoClick(*) {
        Choice := "ОТКРЫТА"
        MyGui.Hide()
    }
    
    MyGui.Add("Button", "Default w100 y+10 x10", "ДА (заблокирована)").OnEvent("Click", YesClick)
    MyGui.Add("Button", "x+10 w100", "НЕТ (открыта)").OnEvent("Click", NoClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

; ===== GUI: ВВОД ДАННЫХ ДЛЯ ВЫТАСКИВАНИЯ =====
GetAccidentInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Данные авто"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Марка и модель машины (например: BMW X5):")
    MyGui.Add("Edit", "vCarModel w250")
    MyGui.Add("Text",, "Цвет машины:")
    MyGui.Add("Edit", "vCarColor w250")
    MyGui.Add("Text",, "Государственный номер (например: А123ВС):")
    MyGui.Add("Edit", "vPlateNumber w250")
    
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

; ===== GUI: ВВОД ДАННЫХ ДЛЯ ОФОРМЛЕНИЯ ДТП =====
GetAccidentFullInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Оформление ДТП"
    MyGui.SetFont("s9")
    MyGui.Add("Text",, "Фамилия Имя водителя 1 (виновник):")
    MyGui.Add("Edit", "vDriver1 w250")
    MyGui.Add("Text",, "Марка и модель авто 1:")
    MyGui.Add("Edit", "vCar1Model w250")
    MyGui.Add("Text",, "Госномер авто 1:")
    MyGui.Add("Edit", "vCar1Plate w250")
    MyGui.Add("Text",, "Цвет авто 1:")
    MyGui.Add("Edit", "vCar1Color w250")
    MyGui.Add("Text",, "")
    MyGui.Add("Text",, "Фамилия Имя водителя 2 (потерпевший):")
    MyGui.Add("Edit", "vDriver2 w250")
    MyGui.Add("Text",, "Марка и модель авто 2:")
    MyGui.Add("Edit", "vCar2Model w250")
    MyGui.Add("Text",, "Госномер авто 2:")
    MyGui.Add("Edit", "vCar2Plate w250")
    MyGui.Add("Text",, "Цвет авто 2:")
    MyGui.Add("Edit", "vCar2Color w250")
    MyGui.Add("Text",, "")
    MyGui.Add("Text",, "Место ДТП (например: перекрёсток Ленина и Пушкина):")
    MyGui.Add("Edit", "vLocation w250")
    MyGui.Add("Text",, "Повреждения автомобилей:")
    MyGui.Add("Edit", "vDamage w250")
    MyGui.Add("Text",, "Есть ли пострадавшие?")
    MyGui.Add("Edit", "vInjured w250", "Нет")
    MyGui.Add("Text",, "Есть ли полис ОСАГО у виновника?")
    MyGui.Add("Edit", "vOsago w250", "Да")
    MyGui.Add("Text",, "Согласен ли виновник с нарушением?")
    MyGui.Add("Text",, "(ДА - постановление, НЕТ - протокол)")
    MyGui.Add("Edit", "vAgreement w250", "ДА")
    
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

; =====================================================
;   МАКРОСЫ
; =====================================================

; ===== 1. ЧИСТКА ПМ (Numpad1) =====
Numpad1::
F1::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Чистка ПМ...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me взял Пистолет Макарова в правую руку")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пистолет разряжен и готов к чистке")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me аккуратно разобрал ПМ и положил детали на полку")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me взял шомпол и прочистил ствол")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me смазал затвор маслом из баночки")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Ствол и затвор полностью обслужены")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me протёр ПМ сухой тряпочкой")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me собрал ПМ обратно и вставил магазин")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Пистолет готов к использованию")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 2. ПРЕДСТАВЛЕНИЕ (Numpad2) =====
Numpad2::
F2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Представление...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetUserInput()
    if !Data
        return

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Здравия желаю, " Data.Department " УМВД России по г. Кемерово, " Data.Rank " " Data.LastName " (da da da da da da) " )
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 3. КСИВА (Numpad3) =====
Numpad3::
F3::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Ксива...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me достал ксиву из кармана рубашки")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Ксива раскрыта и поднята на уровень глаз")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me задержал ксиву на несколько секунд")
    Send("{Enter}")
    PauseWithCheck(6000)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me свернул ксиву")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Ксива свёрнута")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me убрал ксиву обратно в карман")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 4. НАРУЧНИК / ОБЫСК (Numpad4) =====
Numpad4::
F4::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    
    ; Выбор действия (Надеть, Снять, Обыск)
    Action := GetCuffChoice()
    if (Action = "")
        return

    if (Action = "НАДЕТЬ") {
        ToolTip("Надевание наручников...")
        SetTimer(() => ToolTip(), -1500)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me резким движением руки снял наручники с тактического пояса")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me заломил руки задерживаемому за спину и сковал его")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Задерживаемый скован наручниками за спиной")
        Send("{Enter}")
        PauseWithCheck(300)

        ToolTip("Готово!")
        SetTimer(() => ToolTip(), -1500)
    }
    else if (Action = "СНЯТЬ") {
        ToolTip("Снятие наручников...")
        SetTimer(() => ToolTip(), -1500)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me достал ключ из кармана брюк и вставил в замок наручников")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me повернул ключ, расстегнул наручники и снял их с задержанного")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me повесил наручники обратно на тактический пояс")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Наручники закреплены на поясе")
        Send("{Enter}")
        PauseWithCheck(300)

        ToolTip("Готово!")
        SetTimer(() => ToolTip(), -1500)
    }
    else if (Action = "ОБЫСК") {
        ; Выбор типа обыска (Поверхностный или Личный)
        SearchType := GetSearchType()
        if (SearchType = "")
            return

        if (SearchType = "ПОВЕРХНОСТНЫЙ") {
            ToolTip("Поверхностный осмотр...")
            SetTimer(() => ToolTip(), -1500)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/me надел резиновые перчатки, лежащие в кармане")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/me похлопал по карманам и торсу человека напротив")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/do Процесс поверхностного осмотра...")
            Send("{Enter}")
            PauseWithCheck(400)
        }
        else if (SearchType = "ЛИЧНЫЙ") {
            ; Выбор понятых
            Witness := GetWitnessChoice()
            if (Witness = "")
                return

            if (Witness = "С ПОНЯТЫМИ") {
                ToolTip("Личный обыск с понятыми...")
                SetTimer(() => ToolTip(), -1500)

                Send("{. down}")
                Sleep(30)
                Send("{. up}")
                PauseWithCheck(300)
                SendText("/me обратился к понятым, стоящим рядом")
                Send("{Enter}")
                PauseWithCheck(300)

                Send("{. down}")
                Sleep(30)
                Send("{. up}")
                PauseWithCheck(300)
                SendText("- Уважаемые понятые, прошу вас фиксировать процесс личного обыска.")
                Send("{Enter}")
                PauseWithCheck(300)
            }
            else {
                ToolTip("Личный обыск под видеофиксацию...")
                SetTimer(() => ToolTip(), -1500)

                Send("{. down}")
                Sleep(30)
                Send("{. up}")
                PauseWithCheck(300)
                SendText("/me включил свою нагрудную боди-камеру для фиксации обыска")
                Send("{Enter}")
                PauseWithCheck(300)

                Send("{. down}")
                Sleep(30)
                Send("{. up}")
                PauseWithCheck(300)
                SendText("/do Нагрудная боди-камера ведёт запись в облако")
                Send("{Enter}")
                PauseWithCheck(300)
            }

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/me надел стерильные резиновые перчатки")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/me начал тщательно проверять внутренние карманы и содержимое одежды")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/do Процесс тщательного обыска...")
            Send("{Enter}")
            PauseWithCheck(500)
        }

        ; Проверка на наличие запрещенки
        Contraband := GetContrabandQuestion()
        if (Contraband = "ДА") {
            ; Ввод количества изъятого
            ContrabandData := GetContrabandAmount()
            if (ContrabandData = "")
                return
            
            Amount := ContrabandData.Amount

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/me обнаружил запрещенные предметы у обыскиваемого")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/me аккуратно изъял запрещенные предметы в количестве " Amount " шт.")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/me поместил изъятое в специальный зип-пакет")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/do Изъятое упаковано в зип-пакет и опечатано")
            Send("{Enter}")
            PauseWithCheck(300)
        }
        else {
            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/do Ничего запрещенного не обнаружено")
            Send("{Enter}")
            PauseWithCheck(300)
        }

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me снял резиновые перчатки и утилизировал их")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Осмотр полностью завершен")
        Send("{Enter}")
        PauseWithCheck(300)

        ToolTip("Готово!")
        SetTimer(() => ToolTip(), -1500)
    }
}

; ===== 5. РАЦИЯ (Numpad5) =====
Numpad5::
F5::
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
    SendText("/me зажал оранжевую кнопку PPT")
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

; ===== 6. МИРАНДА (Numpad6) =====
Numpad6::
F6::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Миранда...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Вы имеете законное право хранить молчание")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Требовать присутствия адвоката")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Совершить один звонок")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Знать причину задержания")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Получать документы на подпись только после внимательного прочтения")
    Send("{Enter}")
    PauseWithCheck(400)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 7. ВЕСТИ К МАШИНЕ / ИВС (Numpad7) =====
Numpad7::
F7::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Доставление...")
    SetTimer(() => ToolTip(), -1500)

    Choice := GetArrestChoice()
    if (Choice = "") {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    if (Choice = "МАШИНА") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me взял задержанного за запястья и повёл к патрульной машине")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me усадил задержанного в служебный транспорт")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me закрыл дверь и направился к водительскому месту")
        Send("{Enter}")
        PauseWithCheck(300)
    }

    if (Choice = "ИВС") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me взял задержанного и повёл в сторону дежурной части")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me доставил задержанного в ИВС")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Задержанный помещён в изолятор временного содержания")
        Send("{Enter}")
        PauseWithCheck(300)
    }

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 8. ПЕРЕВОД ПМ В БОЕВОЕ ПОЛОЖЕНИЕ (Numpad8) =====
Numpad8::
F8::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("ПМ в боевое...")
    SetTimer(() => ToolTip(), -1500)

    Choice := GetReloadChoice()
    if (Choice = "") {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me достал Пистолет Макарова из кобуры")
    Send("{Enter}")
    PauseWithCheck(300)

    if (Choice = "ДА") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me снял пустой магазин")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me убрал пустой магазин в карман")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me достал из кармана полный магазин")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me вставил полный магазин на место старого")
        Send("{Enter}")
        PauseWithCheck(300)
    }

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me передёрнул затвор, дослав патрон в патронник")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do ПМ готов к применению, оружие в боевом положении")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 9. МЕГАФОН (Numpad9) =====
Numpad9::
F9::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Мегафон...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetMegaphoneInput()
    if !IsObject(Data)
        return

    CarModel := Data.CarModel
    CarColor := Data.CarColor
    Warnings := Data.Warnings

    ; === ДОСТАЁМ МЕГАФОН ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me достал мегафон и поднёс ко рту")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Из мегафона послышался усиленный голос")
    Send("{Enter}")
    PauseWithCheck(300)

    ; === ПЕРВОЕ ТРЕБОВАНИЕ ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-М- " CarColor " " CarModel ", прижимаемся к обочине, 1 законное требование!")
    Send("{Enter}")
    PauseWithCheck(300)

    ; === ЕСЛИ ПРЕДУПРЕЖДЕНИЙ БОЛЬШЕ 1 ===
    if (Warnings > 1) {
        Loop Warnings - 1 {
            RandomDelay := Random(15000, 20000)
            CurrentWarning := A_Index + 1
            ToolTip("Следующее предупреждение через " Round(RandomDelay / 1000) " секунд...")
            SetTimer(() => ToolTip(), -2000)
            Sleep(RandomDelay)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            
            if (CurrentWarning = 3) {
                SendText("-М- " CarColor " " CarModel ", ПРЕДУПРЕЖДЕНИЕ " CurrentWarning "! Остановитесь! Иначе будет открыт огонь по колёсам!")
            } else {
                SendText("-М- " CarColor " " CarModel ", повторяю, прижимаемся к обочине, " CurrentWarning " законное требование!")
            }
            Send("{Enter}")
            PauseWithCheck(300)
        }
    }

    ; === УБИРАЕМ МЕГАФОН ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me убрал мегафон")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 10. ШТРАФ (Numpad0) =====
Numpad0::
F10::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Штраф...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetFineInput()
    if !IsObject(Data) || Data.Result = ""
        return

    ; === ЛОГИКА УСТНОГО ПРЕДУПРЕЖДЕНИЯ ===
    if (Data.Result = "WARN") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me провёл профилактическую беседу с водителем")
        Send("{Enter}")
        PauseWithCheck(300)
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        SendText("-Гражданин, вы нарушаете ПДД. В следующий раз будет выписан штраф. Счастливого пути.")
        Send("{Enter}")
        PauseWithCheck(300)
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        SendText("/me отдал все документы обратно")
        Send("{Enter}")
        return
    }

    ; === ЛОГИКА ВЫПИСКИ ШТРАФА ===
    DriverName := Data.DriverName
    CarModel   := Data.Car          
    PlateNumber:= Data.Plate        
    Article    := Data.Law          
    Amount     := Data.Sum          
    DocType    := Data.DocType      

    if InStr(DocType, "ПОСТАНОВЛЕНИЕ")
        DocText := "постановление, так как водитель согласен,"
    else
        DocText := "протокол"

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me сверил марку и модель авто: " CarModel)
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me сверил госномер авто: " PlateNumber)
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me включил КПК и открыл базу данных")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Выполняется проверка гражданина...")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Выполняется проверка транспортного средства...")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Нарушение, статья: " Article ", сумма: " Amount " руб.")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Электронные данные успешно сохранены в системе")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me составил " DocText " по факту административного нарушения")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Водитель поставил подпись о получении копии на планшете")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me вернул бланки и документы обратно водителю")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Общий установленный срок для оплаты: 60 дней")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Штраф оплатите в банке. Сумма: " Amount " руб ")
    Send("{Enter}")
    PauseWithCheck(300)

    ; === УБИРАЕМ КПК ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me заблокировал и убрал КПК")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== ВЫТАСКИВАНИЕ ИЗ МАШИНЫ (Ctrl+Numpad1) =====
^Numpad1::
^F1::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Вытаскивание из машины...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetAccidentInput()
    if !Data
        return

    CarModel := Data.CarModel
    CarColor := Data.CarColor
    PlateNumber := Data.PlateNumber

    ; === 1. ПРИБЫТИЕ ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me прибыл на место происшествия")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Автомобиль " CarColor " " CarModel " (" PlateNumber ")")
    Send("{Enter}")
    PauseWithCheck(300)

    ; === 2. ВЫБОР ОСНОВАНИЯ ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Основание для вытаскивания?")
    Send("{Enter}")
    PauseWithCheck(300)

    Reason := GetExtractChoice()
    if (Reason = "") {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    ; === 3. ОЗВУЧИВАНИЕ ОСНОВАНИЯ ===
    if (Reason = "ОТКАЗ") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Водитель отказался подчиниться законному требованию")
        Send("{Enter}")
        PauseWithCheck(300)
    } else if (Reason = "РОЗЫСК/УГОН") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Автомобиль находится в розыске / есть подозрение на угон")
        Send("{Enter}")
        PauseWithCheck(300)
    } else if (Reason = "ОПАСНОСТЬ") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Водитель ведёт себя неадекватно, есть угроза для окружающих")
        Send("{Enter}")
        PauseWithCheck(300)
    } else if (Reason = "СПАСЕНИЕ") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Водитель нуждается в срочной помощи / есть угроза жизни")
        Send("{Enter}")
        PauseWithCheck(300)
    }

    ; === 4. ДВЕРЬ ЗАБЛОКИРОВАНА? ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Дверь не заблокирована?")
    Send("{Enter}")
    PauseWithCheck(300)

    DoorChoice := GetExtractDoorChoice()
    if (DoorChoice = "") {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    ; === 5. ВЗЛОМ / ОТКРЫТИЕ ===
    if (DoorChoice = "ЗАБЛОКИРОВАНА") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me достал резиновую дубинку")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me разбил боковое стекло")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Стекло разбито, осколки осыпались")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me открыл дверь через разбитое окно")
        Send("{Enter}")
        PauseWithCheck(300)
    } else {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me открыл дверь")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Дверь открыта")
        Send("{Enter}")
        PauseWithCheck(300)
    }

    ; === 6. ВЫТАСКИВАНИЕ ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me взял водителя за плечо")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me аккуратно вытащил водителя из машины")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Водитель извлечён из автомобиля")
    Send("{Enter}")
    PauseWithCheck(300)

    ; === 7. ОЦЕНКА СОСТОЯНИЯ ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Водитель на осмотре, признаков опьянения не выявлено")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== ОФОРМЛЕНИЕ ДТП (Ctrl+Numpad2) =====
^Numpad2::
^F2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Оформление ДТП...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetAccidentFullInput()
    if !Data
        return

    Driver1 := Data.Driver1
    Car1Model := Data.Car1Model
    Car1Plate := Data.Car1Plate
    Car1Color := Data.Car1Color
    Driver2 := Data.Driver2
    Car2Model := Data.Car2Model
    Car2Plate := Data.Car2Plate
    Car2Color := Data.Car2Color
    Location := Data.Location
    Damage := Data.Damage
    Injured := Data.Injured
    Osago := Data.Osago
    Agreement := Data.Agreement

    ; === 1. ПЕРВЫЕ ДЕЙСТВИЯ ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me включил аварийную сигнализацию")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me выставил знак аварийной остановки")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверил наличие пострадавших: " Injured)
    Send("{Enter}")
    PauseWithCheck(300)

    if (Injured != "Нет") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me вызвал скорую помощь")
        Send("{Enter}")
        PauseWithCheck(300)
    }

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me зафиксировал обстановку на фото и видео")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Место ДТП: " Location)
    Send("{Enter}")
    PauseWithCheck(300)

    ; === 2. ПРОВЕРКА ДОКУМЕНТОВ ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверил документы участников")
    Send("{Enter}")
    PauseWithCheck(300)

    ; === 3. ПРОВЕРКА ОСАГО ===
    if (Osago = "Нет") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do У водителя " Driver1 " отсутствует полис ОСАГО")
        Send("{Enter}")
        PauseWithCheck(300)
    }

    ; === 4. ОФОРМЛЕНИЕ ДОКУМЕНТОВ ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me составил схему ДТП")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Повреждения: " Damage)
    Send("{Enter}")
    PauseWithCheck(300)

    if (Agreement = "ДА") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me составил постановление об административном правонарушении")
        Send("{Enter}")
        PauseWithCheck(300)
    } else {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me составил протокол об административном правонарушении")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Дело будет направлено на разбор в суд")
        Send("{Enter}")
        PauseWithCheck(300)
    }

    ; === 5. ЗАВЕРШЕНИЕ ===
    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me участники внимательно прочитали документы")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me участники поставили подписи")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me вручил копии документов участникам")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do ДТП оформлено")
    Send("{Enter}")
    PauseWithCheck(300)

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
