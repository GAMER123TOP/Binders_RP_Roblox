#Requires AutoHotkey v2.0
SendMode("Event")
SetKeyDelay(50, 50)

; ===== ГЛОБАЛЬНЫЕ НАСТРОЙКИ =====
global StopMacro := false
global LoadedFonts := []


; ===== ПУТЬ К ПАПКЕ ASSETS =====
global AssetsPath := "C:\Users\" A_UserName "\Binders\assets\"

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

; ===== ОСТАНОВКА МАКРОСОВ =====
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
    OverlayGui.Title := "ФСБ макрос"
    
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.SetFont("s10 w600", "Montserrat SemiBold")
    OverlayGui.Add("Text",, "  ГОРЯЧИЕ КЛАВИШИ ФСБ")
    OverlayGui.SetFont("s9 w400", "Montserrat")
    OverlayGui.Add("Text",, "═══════════════════════════════════════")
    OverlayGui.Add("Text",, "  Numpad1 / F1  → Представление")
    OverlayGui.Add("Text",, "  Numpad2 / F2  → Удостоверение")
    OverlayGui.Add("Text",, "  Numpad3 / F3  → Наручники / Обыск")
    OverlayGui.Add("Text",, "  Numpad4 / F4  → Рация")
    OverlayGui.Add("Text",, "  Numpad5 / F5  → Миранда")
    OverlayGui.Add("Text",, "  Numpad6 / F6  → Вести к машине / ИВС")
    OverlayGui.Add("Text",, "  Numpad7 / F7  → ТТ-33 в боевое")
    OverlayGui.Add("Text",, "  Numpad8 / F8  → Мегафон")
    OverlayGui.Add("Text",, "  Numpad9 / F9  → АС `"Вал`" в боевое")
    OverlayGui.Add("Text",, "  Numpad0 / F10 → Вытаскивание из машины")
    OverlayGui.Add("Text",, "  Ctrl+Numpad1 / Ctrl+F1 → Получение Дозора")
    OverlayGui.Add("Text",, "  Ctrl+Numpad2 / Ctrl+F2 → Включение записи")
    OverlayGui.Add("Text",, "  Ctrl+Numpad3 / Ctrl+F3 → Проверка заряда")
    OverlayGui.Add("Text",, "  Ctrl+Numpad4 / Ctrl+F4 → Технический сбой")
    OverlayGui.Add("Text",, "  Ctrl+Numpad5 / Ctrl+F5 → Окончание записи")
    OverlayGui.Add("Text",, "  Ctrl+Numpad6 / Ctrl+F6 → Сдача Дозора")
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

; ===== ПОЛНАЯ ОСТАНОВКА =====
^Esc:: {
    ToolTip("Остановка скрипта...")
    SetTimer(() => ToolTip(), -1500)
    Sleep(500)
    ExitApp()
}

; ===== ПАУЗА =====
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

GetUserInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Введите данные для отыгровки"
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

GetRadioMessage() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Введите сообщение для рации"
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

GetReloadChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Перезарядка ТТ-33"
    MyGui.Add("Text",, "Нужна перезарядка ТТ-33?")
    
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

GetReloadChoiceVAL() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Перезарядка АС «Вал»"
    MyGui.Add("Text",, "Нужна перезарядка АС «Вал»?")
    
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

GetCuffChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Наручники / Обыск"
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

ShowSearchInfo() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Типы обыска"
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

GetSearchType() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Тип обыска"
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

GetWitnessChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Понятые"
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

GetContrabandQuestion() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Обнаружение запрещённых предметов"
    MyGui.Add("Text",, "Есть запрещёнка?")
    
    Choice := ""
    
    MyGui.Add("Button", "Default w70 y+10 x10", "ДА").OnEvent("Click", (*) => (Choice := "ДА", MyGui.Hide()))
    MyGui.Add("Button", "x+10 w70", "НЕТ").OnEvent("Click", (*) => (Choice := "НЕТ", MyGui.Hide()))
    MyGui.Show()
    WinWaitClose(MyGui)
    MyGui.Destroy()
    return Choice
}

GetContrabandAmount() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Количество изъятого"
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

GetMegaphoneInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Мегафон"
    MyGui.Add("Text",, "Марка и модель машины:")
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

GetArrestChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Доставление"
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

GetExtractChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Вытаскивание из машины"
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

GetExtractDoorChoice() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Дверь"
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

GetAccidentInput() {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.SetFont("s9 w400", "Montserrat")
    MyGui.Title := "Данные авто"
    MyGui.Add("Text",, "Марка и модель машины:")
    MyGui.Add("Edit", "vCarModel w250")
    MyGui.Add("Text",, "Цвет машины:")
    MyGui.Add("Edit", "vCarColor w250")
    MyGui.Add("Text",, "Государственный номер:")
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

; =====================================================
;   МАКРОСЫ
; =====================================================

; ===== 1. ПРЕДСТАВЛЕНИЕ (Numpad1 / F1) =====
Numpad1::
F1::
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
    SendText("-Здравия желаю, " Data.Department " УФСБ по г. Зареченску, " Data.Rank " " Data.LastName)
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 2. УДОСТОВЕРЕНИЕ (Numpad2 / F2) =====
Numpad2::
F2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Удостоверение...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me достал удостоверение из кармана")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Удостоверение раскрыто и поднято на уровень глаз")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me задержал удостоверение на несколько секунд")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me свернул удостоверение")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Удостоверение свёрнуто")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me убрал удостоверение обратно в карман")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 3. НАРУЧНИКИ / ОБЫСК (Numpad3 / F3) =====
Numpad3::
F3::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    
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
        SendText("/me достал БРС-3 из кобуры для наручников")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me надел БРС-3 на запястья задержанного")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do БРС-3 защёлкнуты")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me проверил надёжность фиксации замков")
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
        SendText("/me достал связку ключей")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me вставил ключ в замочную скважину БРС-3")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Ключ вставлен в замочную скважину БРС-3")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me отщёлкнул замки и снял наручники")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do БРС-3 сняты")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me убрал БРС-3 обратно в кобуру для наручников")
        Send("{Enter}")
        PauseWithCheck(300)

        ToolTip("Готово!")
        SetTimer(() => ToolTip(), -1500)
    }
    else if (Action = "ОБЫСК") {
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
            SendText("/me надел одноразовые перчатки")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/me провёл рукой по верхней одежде задержанного")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/do Проверка на наличие оружия или опасных предметов")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/do Есть запрещенные предметы?")
            Send("{Enter}")
            PauseWithCheck(300)
        }
        else if (SearchType = "ЛИЧНЫЙ") {
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
                SendText("/do Присутствуют понятые, ведётся видеозапись")
                Send("{Enter}")
                PauseWithCheck(300)
            }
            else {
                ToolTip("Личный обыск без понятых...")
                SetTimer(() => ToolTip(), -1500)

                Send("{. down}")
                Sleep(30)
                Send("{. up}")
                PauseWithCheck(300)
                SendText("/do Понятые отсутствуют, ведётся видеозапись")
                Send("{Enter}")
                PauseWithCheck(300)
            }

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/me надел одноразовые перчатки")
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
            PauseWithCheck(300)

            Send("{. down}")
            Sleep(30)
            Send("{. up}")
            PauseWithCheck(300)
            SendText("/do Есть запрещенные предметы?")
            Send("{Enter}")
            PauseWithCheck(300)            
        }

        Contraband := GetContrabandQuestion()
        if (Contraband = "ДА") {
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

; ===== 4. РАЦИЯ (Numpad4 / F4) =====
Numpad4::
F4::
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

; ===== 5. МИРАНДА (Numpad5 / F5) =====
Numpad5::
F5::
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
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Требовать присутствия адвоката")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Совершить один звонок")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Знать причину задержания")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-Получать документы на подпись только после внимательного прочтения")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 6. ВЕСТИ К МАШИНЕ / ИВС (Numpad6 / F6) =====
Numpad6::
F6::
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
        SendText("/me взял задержанного за запястья и повёл к служебной машине")
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

; ===== 7. ТТ-33 В БОЕВОЕ (Numpad7 / F7) =====
Numpad7::
F7::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("ТТ-33 в боевое...")
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
    SendText("/me достал Тульский Токарева из кобуры")
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
    SendText("/do ТТ-33 готов к применению, оружие в боевом положении")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 8. МЕГАФОН (Numpad8 / F8) =====
Numpad8::
F8::
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

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("-М- " CarColor " " CarModel ", прижимаемся к обочине, 1 законное требование!")
    Send("{Enter}")
    PauseWithCheck(300)

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

; ===== 9. АС «ВАЛ» В БОЕВОЕ (Numpad9 / F9) =====
Numpad9::
F9::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("АС Вал...")
    SetTimer(() => ToolTip(), -1500)

    Choice := GetReloadChoiceVAL()
    if (Choice = "") {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me снял АС «Вал» с груди (da da da)")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Оружие в руке, глушитель закреплён")
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
        SendText("/me убрал пустой магазин в подсумок")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/me достал из подсумка полный магазин")
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
    SendText("/do АС «Вал» готов к применению")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 10. ВЫТАСКИВАНИЕ ИЗ МАШИНЫ (Numpad0 / F10) =====
Numpad0::
F10::
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

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me прибыл на место проверки")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Автомобиль " CarColor " " CarModel " (" PlateNumber ")")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Основание для проверки?")
    Send("{Enter}")
    PauseWithCheck(300)

    Reason := GetExtractChoice()
    if (Reason = "") {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    if (Reason = "ОТКАЗ") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Водитель отказался подчиниться требованию")
        Send("{Enter}")
        PauseWithCheck(300)
    } else if (Reason = "РОЗЫСК/УГОН") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Автомобиль находится в розыске")
        Send("{Enter}")
        PauseWithCheck(300)
    } else if (Reason = "ОПАСНОСТЬ") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Водитель представляет угрозу")
        Send("{Enter}")
        PauseWithCheck(300)
    } else if (Reason = "СПАСЕНИЕ") {
        Send("{. down}")
        Sleep(30)
        Send("{. up}")
        PauseWithCheck(300)
        SendText("/do Требуется срочное вмешательство")
        Send("{Enter}")
        PauseWithCheck(300)
    }

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Дверь заблокирована?")
    Send("{Enter}")
    PauseWithCheck(300)

    DoorChoice := GetExtractDoorChoice()
    if (DoorChoice = "") {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

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

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 11. ПОЛУЧЕНИЕ ДОЗОРА (Ctrl+Numpad1 / Ctrl+F1) =====
^Numpad1::
^F1::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Получение Дозора...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me взял с зарядной станции закреплённый за ним «Дозор-77»")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Устройство заряжено на 100%, готово к работе")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверил целостность корпуса и работу линзы")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Дата и время синхронизированы, устройство готово к использованию")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 12. ВКЛЮЧЕНИЕ ЗАПИСИ (Ctrl+Numpad2 / Ctrl+F2) =====
^Numpad2::
^F2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Включение записи...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me нажал кнопку включения на устройстве")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do На экране загорелся красный индикатор записи")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Ведётся непрерывная аудио- и видеозапись")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 13. ПРОВЕРКА ЗАРЯДА (Ctrl+Numpad3 / Ctrl+F3) =====
^Numpad3::
^F3::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Проверка заряда...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me проверил светодиодные индикаторы на устройстве")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Индикатор записи горит, заряд 95%")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 14. ТЕХНИЧЕСКИЙ СБОЙ (Ctrl+Numpad4 / Ctrl+F4) =====
^Numpad4::
^F4::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Технический сбой...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me заметил неисправность на индикаторе устройства")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Устройство зависло, запись не ведётся")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me доложил о поломке дежурному")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 15. ОКОНЧАНИЕ ЗАПИСИ (Ctrl+Numpad5 / Ctrl+F5) =====
^Numpad5::
^F5::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Окончание записи...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me нажал кнопку остановки записи на устройстве")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Запись остановлена, файл сохранён на карту памяти")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 16. СДАЧА ДОЗОРА (Ctrl+Numpad6 / Ctrl+F6) =====
^Numpad6::
^F6::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    ToolTip("Сдача Дозора...")
    SetTimer(() => ToolTip(), -1500)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me установил устройство на зарядную станцию")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Терминал начал автоматическое скачивание файлов")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Аккумулятор заряжается, файлы архивируются на сервер")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/me поставил отметку в журнале учёта о возврате устройства")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Дежурный подтвердил сдачу исправного устройства")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{. down}")
    Sleep(30)
    Send("{. up}")
    PauseWithCheck(300)
    SendText("/do Видеозаписи хранятся на сервере")
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
