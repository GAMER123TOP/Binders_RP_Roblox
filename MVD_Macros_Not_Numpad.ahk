; ╓==========================================================╗
; ‖ MVD Macros for Roblox                                    ‖
; ‖ Версия: 1.0                                              ‖
; ‖ Автор: GAMER123TOP                                       ‖
; ‖                                                          ‖
; ‖ ВНИМАНИЕ!                                                ‖
; ‖ Использование на свой страх и риск.                      ‖
; ‖ Не нарушайте правила сервера и Roblox.                   ‖
; ‖ Автор не несёт ответственности за возможные блокировки.  ‖
; ‖                                                          ‖
; ‖ Горячие клавиши:                                         ‖
; ‖ F1  → Чистка ПМ                                          ‖
; ‖ F2  → Представление                                      ‖
; ‖ F3  → Ксива                                              ‖
; ‖ F4  → Наручники / Обыск                                  ‖
; ‖ F5  → Рация                                              ‖
; ‖ F6  → Миранда                                            ‖
; ‖ F7  → Арест                                              ‖
; ‖ F8  → ПМ в боевое                                        ‖
; ‖ Ctrl+F4 → Настройки                                      ‖
; ‖ Ctrl+Esc → Остановка                                     ‖
; ‖ Ctrl+R   → Перезапуск                                    ‖
; ╘==========================================================╛

#Requires AutoHotkey v2.0
SendMode("Event")
SetKeyDelay(50, 50)

; ===== ГЛОБАЛЬНЫЕ НАСТРОЙКИ =====
global ChatKey := "."  
global DefaultChatKey := "."
StopMacro := false

; ===== ФУНКЦИЯ: СМЕНИТЬ КЛАВИШУ ЧАТА =====
ChangeChatKey(*) {
    global ChatKey, ChatGui
    ChatGui := Gui()
    ChatGui.Title := "Сменить клавишу чата"
    ChatGui.Add("Text",, "Введите новую клавишу для открытия чата:")
    ChatGui.Add("Text",, "Например: . или U или /")
    ChatGui.Add("Edit", "vNewKey w200", ChatKey)
    BtnOK := ChatGui.Add("Button", "Default", "ОК")
    BtnOK.OnEvent("Click", SubmitChatKey)
    ChatGui.Show()
}

SubmitChatKey(*) {
    global ChatKey, ChatGui
    Submitted := ChatGui.Submit()
    if Submitted.NewKey != "" {
        ChatKey := Submitted.NewKey
        ToolTip("Клавиша чата изменена на: " ChatKey)
        SetTimer(() => ToolTip(), -2000)
    } else {
        ToolTip("Ошибка! Клавиша не может быть пустой!")
        SetTimer(() => ToolTip(), -2000)
    }
    ChatGui.Destroy()
}

; ===== ФУНКЦИЯ: СБРОС К ЗАВОДСКИМ =====
ResetToDefault(*) {
    global ChatKey, DefaultChatKey
    ChatKey := DefaultChatKey
    ToolTip("Клавиша чата сброшена на: " ChatKey)
    SetTimer(() => ToolTip(), -2000)
}

ShowOverlay() {
    MyGui := Gui()
    MyGui.Title := "MVD Macros"
    MyGui.Opt("+AlwaysOnTop")
    MyGui.Add("Text",, "═══════════════════════════════════════")
    MyGui.Add("Text",, "  ГОРЯЧИЕ КЛАВИШИ МВД")
    MyGui.Add("Text",, "═══════════════════════════════════════")
    MyGui.Add("Text",, "  F1  → Чистка ПМ")
    MyGui.Add("Text",, "  F2  → Представление")
    MyGui.Add("Text",, "  F3  → Ксива")
    MyGui.Add("Text",, "  F4  → Наручники / Обыск")
    MyGui.Add("Text",, "  F5  → Рация")
    MyGui.Add("Text",, "  F6  → Миранда")
    MyGui.Add("Text",, "  F7  → Арест")
    MyGui.Add("Text",, "  F8  → ПМ в боевое")
    MyGui.Add("Text",, "  F9  → (свободно)")
    MyGui.Add("Text",, "  F0  → (свободно)")
    MyGui.Add("Text",, "  Ctrl+F4 → Настройки")
    MyGui.Add("Text",, "═══════════════════════════════════════")
    MyGui.Add("Text",, "  Ctrl+Esc → Остановка")
    MyGui.Add("Text",, "  Ctrl+R   → Перезапуск")
    MyGui.Add("Text",, "═══════════════════════════════════════")
    
    BtnOK := MyGui.Add("Button", "Default", "ЗАКРЫТЬ")
    BtnOK.OnEvent("Click", (*) => MyGui.Destroy())
    
    MyGui.Show()
}

ShowOverlay()

; ===== ОСТАНОВКА (Ctrl+Esc) =====
^Esc::
{
    ToolTip("Остановка...")
    SetTimer(() => ToolTip(), -1500)
    Sleep(500)
    ExitApp()
}

; ===== ПАУЗА С ПРОВЕРКОЙ =====
PauseWithCheck(ms) {
    Loop {
        if StopMacro
            ExitApp
        if (A_Index > ms / 50)
            break
        Sleep(50)
    }
}

; ===== GUI: ВВОД ДАННЫХ ДЛЯ ПРЕДСТАВЛЕНИЯ =====
GetUserInput() {
    MyGui := Gui()
    MyGui.Title := "Введите данные для отыгровки"
    MyGui.Add("Text",, "Отдел (например: ДПС, УГРО, ППС):")
    MyGui.Add("Edit", "vDepartment w200")
    MyGui.Add("Text",, "Звание (например: Прапорщик, Капитан):")
    MyGui.Add("Edit", "vRank w200")
    MyGui.Add("Text",, "Фамилия:")
    MyGui.Add("Edit", "vLastName w200", "Вламиринов")
    BtnOK := MyGui.Add("Button", "Default", "ОК")
    BtnOK.OnEvent("Click", (*) => MyGui.Submit())
    MyGui.Add("Button", "x+m", "Отмена").OnEvent("Click", (*) => ExitApp())
    MyGui.Show()
    WinWaitClose(MyGui)
    return MyGui.Submit()
}

; ===== GUI: ВВОД СООБЩЕНИЯ ДЛЯ РАЦИИ =====
GetRadioMessage() {
    MyGui := Gui()
    MyGui.Title := "Введите сообщение для рации"
    MyGui.Add("Text",, "Сообщение:")
    MyGui.Add("Edit", "vMessage w300")
    BtnOK := MyGui.Add("Button", "Default", "ОК")
    BtnOK.OnEvent("Click", (*) => MyGui.Submit())
    MyGui.Add("Button", "x+m", "Отмена").OnEvent("Click", (*) => ExitApp())
    MyGui.Show()
    WinWaitClose(MyGui)
    return MyGui.Submit()
}

; ===== GUI: ВЫБОР ПЕРЕЗАРЯДКИ ПМ =====
GetReloadChoice() {
    MyGui := Gui()
    MyGui.Title := "Перезарядка ПМ"
    MyGui.Add("Text",, "Нужна перезарядка ПМ?")
    
    Choice := ""
    
    YesClick(*) {
        Choice := "ДА"
        MyGui.Destroy()
    }
    
    NoClick(*) {
        Choice := "НЕТ"
        MyGui.Destroy()
    }
    
    BtnYes := MyGui.Add("Button", "Default", "ДА")
    BtnYes.OnEvent("Click", YesClick)
    
    BtnNo := MyGui.Add("Button", "x+m", "НЕТ")
    BtnNo.OnEvent("Click", NoClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    return Choice
}

; ===== GUI: ВЫБОР ДЕЙСТВИЯ ДЛЯ НАРУЧНИКОВ/ОБЫСКА =====
GetCuffChoice() {
    MyGui := Gui()
    MyGui.Title := "Наручники / Обыск"
    MyGui.Add("Text",, "Выберите действие:")
    
    Choice := ""
    
    CuffClick(*) {
        Choice := "НАДЕТЬ"
        MyGui.Destroy()
    }
    
    ReleaseClick(*) {
        Choice := "СНЯТЬ"
        MyGui.Destroy()
    }
    
    SearchClick(*) {
        Choice := "ОБЫСК"
        MyGui.Destroy()
    }
    
    BtnCuff := MyGui.Add("Button", "Default", "НАДЕТЬ")
    BtnCuff.OnEvent("Click", CuffClick)
    
    BtnRelease := MyGui.Add("Button", "x+m", "СНЯТЬ")
    BtnRelease.OnEvent("Click", ReleaseClick)
    
    BtnSearch := MyGui.Add("Button", "x+m", "ОБЫСК")
    BtnSearch.OnEvent("Click", SearchClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    return Choice
}

; ===== GUI: ИНФОРМАЦИЯ О ТИПАХ ОБЫСКА =====
ShowSearchInfo() {
    MyGui := Gui()
    MyGui.Title := "Типы обыска"
    
    MyGui.Add("Text",, "ПОВЕРХНОСТНЫЙ ОСМОТР:")
    MyGui.Add("Text",, "Что это: Профилактическая мера для безопасности. Полицейский проводит рукой по верхней одежде, не залезая внутрь и не выворачивая карманы.")
    MyGui.Add("Text",, "Зачем: Чтобы быстро проверить, нет ли у человека при себе оружия или опасных предметов.")
    MyGui.Add("Text",, "Правила: Не требует понятых и специального постановления, проводится на месте (например, на улице или при входе на мероприятие).")
    MyGui.Add("Text",, "")
    
    MyGui.Add("Text",, "ЛИЧНЫЙ ОБЫСК (или обыск помещений/автомобиля):")
    MyGui.Add("Text",, "Что это: Полноценное процессуальное следственное действие.")
    MyGui.Add("Text",, "Зачем: Чтобы досконально осмотреть человека, его вещи или дом и найти любые улики, ценности или предметы, запрещенные к обороту.")
    MyGui.Add("Text",, "Правила: Почти всегда требует постановления следователя или решения суда. Обязательно присутствие понятых (или видеозапись), а если обыскивают человека — то понятые и тот, кто обыскивает, должны быть одного с ним пола. В России это строго регламентируется Уголовно-процессуальным кодексом (например, УПК РФ Статья 182)")
    MyGui.Add("Text",, "")
    
    BtnOK := MyGui.Add("Button", "Default", "ПОНЯТНО")
    BtnOK.OnEvent("Click", (*) => MyGui.Destroy())
    
    MyGui.Show()
    WinWaitClose(MyGui)
}

; ===== GUI: ВЫБОР ТИПА ОБЫСКА =====
GetSearchType() {
    MyGui := Gui()
    MyGui.Title := "Тип обыска"
    MyGui.Add("Text",, "Какой обыск проводим?")
    
    Choice := ""
    
    InfoClick(*) {
        MyGui.Destroy()
        ShowSearchInfo()
        Choice := GetSearchType()
    }
    
    SurfaceClick(*) {
        Choice := "ПОВЕРХНОСТНЫЙ"
        MyGui.Destroy()
    }
    
    PersonalClick(*) {
        Choice := "ЛИЧНЫЙ"
        MyGui.Destroy()
    }
    
    BtnInfo := MyGui.Add("Button", "Default", "ЧТО ЭТО?")
    BtnInfo.OnEvent("Click", InfoClick)
    
    BtnSurface := MyGui.Add("Button", "x+m", "ПОВЕРХНОСТНЫЙ")
    BtnSurface.OnEvent("Click", SurfaceClick)
    
    BtnPersonal := MyGui.Add("Button", "x+m", "ЛИЧНЫЙ")
    BtnPersonal.OnEvent("Click", PersonalClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    return Choice
}

; ===== GUI: ВЫБОР ПОНЯТЫХ =====
GetWitnessChoice() {
    MyGui := Gui()
    MyGui.Title := "Понятые"
    MyGui.Add("Text",, "Понятые присутствуют?")
    
    Choice := ""
    
    WithClick(*) {
        Choice := "С ПОНЯТЫМИ"
        MyGui.Destroy()
    }
    
    WithoutClick(*) {
        Choice := "БЕЗ ПОНЯТЫХ"
        MyGui.Destroy()
    }
    
    BtnWith := MyGui.Add("Button", "Default", "С ПОНЯТЫМИ")
    BtnWith.OnEvent("Click", WithClick)
    
    BtnWithout := MyGui.Add("Button", "x+m", "БЕЗ ПОНЯТЫХ")
    BtnWithout.OnEvent("Click", WithoutClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    return Choice
}

; ===== GUI: ВОПРОС "ЕСТЬ ЗАПРЕЩЁНКА?" =====
GetContrabandQuestion() {
    MyGui := Gui()
    MyGui.Title := "Обнаружение запрещённых предметов"
    MyGui.Add("Text",, "Есть запрещёнка?")
    
    Choice := ""
    
    YesClick(*) {
        Choice := "ДА"
        MyGui.Destroy()
    }
    
    NoClick(*) {
        Choice := "НЕТ"
        MyGui.Destroy()
    }
    
    BtnYes := MyGui.Add("Button", "Default", "ДА")
    BtnYes.OnEvent("Click", YesClick)
    
    BtnNo := MyGui.Add("Button", "x+m", "НЕТ")
    BtnNo.OnEvent("Click", NoClick)
    
    MyGui.Show()
    WinWaitClose(MyGui)
    return Choice
}

; ===== GUI: ВВОД КОЛИЧЕСТВА ЗАПРЕЩЁНКИ =====
GetContrabandAmount() {
    MyGui := Gui()
    MyGui.Title := "Изъятие запрещённых предметов"
    MyGui.Add("Text",, "Сколько запрещёнки изъято?")
    MyGui.Add("Edit", "vAmount w100", "0")
    BtnOK := MyGui.Add("Button", "Default", "ОК")
    BtnOK.OnEvent("Click", (*) => MyGui.Submit())
    MyGui.Add("Button", "x+m", "Отмена").OnEvent("Click", (*) => ExitApp())
    MyGui.Show()
    WinWaitClose(MyGui)
    return MyGui.Submit()
}

; =====================================================
;   МАКРОСЫ
; =====================================================

; ===== 1. ЧИСТКА ПМ (F1) =====
F1::
{
    global ChatKey
    ToolTip("Чистка ПМ...")
    SetTimer(() => ToolTip(), -1500)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me взял Пистолет Макарова в правую руку")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/do Пистолет разряжен и готов к чистке")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me аккуратно разобрал ПМ и положил детали на полку")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me взял шомпол и прочистил ствол")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me смазал затвор маслом из баночки")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/do Ствол и затвор полностью обслужены")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me протёр ПМ сухой тряпочкой")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me собрал ПМ обратно и вставил магазин")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/do Пистолет готов к использованию")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 2. ПРЕДСТАВЛЕНИЕ (F2) =====
F2::
{
    global ChatKey
    ToolTip("Представление...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetUserInput()
    if !Data
        return

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("-Здравия желаю, " Data.Department " МУ МВД по Зареченское, " Data.Rank " " Data.LastName)
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 3. КСИВА (F3) =====
F3::
{
    global ChatKey
    ToolTip("Ксива...")
    SetTimer(() => ToolTip(), -1500)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me достал ксиву из кармана рубашки")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/do Ксива раскрыта и поднята на уровень глаз")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me задержал ксиву на несколько секунд")
    Send("{Enter}")
    PauseWithCheck(6000)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me свернул ксиву")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/do Ксива свёрнута")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me убрал ксиву обратно в карман")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 4. НАРУЧНИКИ / ОБЫСК (F4) =====
F4::
{
    global ChatKey
    ToolTip("Наручники / Обыск...")
    SetTimer(() => ToolTip(), -1500)

    Choice := GetCuffChoice()
    if (Choice = "") {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    ; === НАДЕТЬ НАРУЧНИКИ ===
    if (Choice = "НАДЕТЬ") {
        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/me достал наручники БРС-2 из кобуры")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/me надел БРС-2 на запястья задержанного")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/do Наручники БРС-2 защёлкнуты")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/me проверил надёжность фиксации замков")
        Send("{Enter}")
        PauseWithCheck(300)
        
        ToolTip("Готово!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    ; === СНЯТЬ НАРУЧНИКИ ===
    if (Choice = "СНЯТЬ") {
        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/me достал ключ из чехла на поясе")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/do Ключ вставлен в замочную скважину")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/me отщёлкнул замки и снял наручники")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/do Наручники БРС-2 сняты")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/me убрал наручники обратно в кобуру")
        Send("{Enter}")
        PauseWithCheck(300)
        
        ToolTip("Готово!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    ; === ОБЫСК ===
    if (Choice = "ОБЫСК") {
        SearchType := GetSearchType()
        if (SearchType = "") {
            ToolTip("Отменено!")
            SetTimer(() => ToolTip(), -1500)
            return
        }

        ; --- ПОВЕРХНОСТНЫЙ ОБЫСК ---
        if (SearchType = "ПОВЕРХНОСТНЫЙ") {
            Send("{" ChatKey " down}")
            Sleep(30)
            Send("{" ChatKey " up}")
            PauseWithCheck(300)
            SendText("/me надел одноразовые перчатки")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{" ChatKey " down}")
            Sleep(30)
            Send("{" ChatKey " up}")
            PauseWithCheck(300)
            SendText("/me провёл рукой по верхней одежде задержанного")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{" ChatKey " down}")
            Sleep(30)
            Send("{" ChatKey " up}")
            PauseWithCheck(300)
            SendText("/do Проверка на наличие оружия или опасных предметов")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{" ChatKey " down}")
            Sleep(30)
            Send("{" ChatKey " up}")
            PauseWithCheck(300)
            SendText("/do Есть запрещенные предметы?")
            Send("{Enter}")
            PauseWithCheck(300)

            Contraband := GetContrabandQuestion()
            if (Contraband = "ДА") {
                Send("{" ChatKey " down}")
                Sleep(30)
                Send("{" ChatKey " up}")
                PauseWithCheck(300)
                SendText("/do Обнаружены запрещённые предметы!")
                Send("{Enter}")
                PauseWithCheck(300)

                Send("{" ChatKey " down}")
                Sleep(30)
                Send("{" ChatKey " up}")
                PauseWithCheck(300)
                SendText("/do Переход к личному обыску. Вызов понятых.")
                Send("{Enter}")
                PauseWithCheck(300)

                Witness := GetWitnessChoice()
                if (Witness = "С ПОНЯТЫМИ") {
                    Send("{" ChatKey " down}")
                    Sleep(30)
                    Send("{" ChatKey " up}")
                    PauseWithCheck(300)
                    SendText("/do Присутствуют понятые, ведётся видеозапись")
                    Send("{Enter}")
                    PauseWithCheck(300)
                } else {
                    Send("{" ChatKey " down}")
                    Sleep(30)
                    Send("{" ChatKey " up}")
                    PauseWithCheck(300)
                    SendText("/do Понятые отсутствуют, ведётся видеозапись")
                    Send("{Enter}")
                    PauseWithCheck(300)
                }

                Send("{" ChatKey " down}")
                Sleep(30)
                Send("{" ChatKey " up}")
                PauseWithCheck(300)
                SendText("/me провёл личный обыск с составлением протокола")
                Send("{Enter}")
                PauseWithCheck(300)

                Send("{" ChatKey " down}")
                Sleep(30)
                Send("{" ChatKey " up}")
                PauseWithCheck(300)
                SendText("/do Предметы изъяты и упакованы")
                Send("{Enter}")
                PauseWithCheck(300)

            } else {
                Send("{" ChatKey " down}")
                Sleep(30)
                Send("{" ChatKey " up}")
                PauseWithCheck(300)
                SendText("/do Ничего опасного не обнаружено")
                Send("{Enter}")
                PauseWithCheck(300)

                Send("{" ChatKey " down}")
                Sleep(30)
                Send("{" ChatKey " up}")
                PauseWithCheck(300)
                SendText("/me снял и убрал перчатки")
                Send("{Enter}")
                PauseWithCheck(300)
            }
            
            ToolTip("Готово!")
            SetTimer(() => ToolTip(), -1500)
            return
        }

        ; --- ЛИЧНЫЙ ОБЫСК ---
        if (SearchType = "ЛИЧНЫЙ") {
            Witness := GetWitnessChoice()
            if (Witness = "") {
                ToolTip("Отменено!")
                SetTimer(() => ToolTip(), -1500)
                return
            }

            Send("{" ChatKey " down}")
            Sleep(30)
            Send("{" ChatKey " up}")
            PauseWithCheck(300)
            SendText("/me надел одноразовые перчатки")
            Send("{Enter}")
            PauseWithCheck(300)

            Send("{" ChatKey " down}")
            Sleep(30)
            Send("{" ChatKey " up}")
            PauseWithCheck(300)
            SendText("/do Начало личного обыска")
            Send("{Enter}")
            PauseWithCheck(300)

            if (Witness = "С ПОНЯТЫМИ") {
                Send("{" ChatKey " down}")
                Sleep(30)
                Send("{" ChatKey " up}")
                PauseWithCheck(300)
                SendText("/do Присутствуют понятые, ведётся видеозапись")
                Send("{Enter}")
                PauseWithCheck(300)
            } else {
                Send("{" ChatKey " down}")
                Sleep(30)
                Send("{" ChatKey " up}")
                PauseWithCheck(300)
                SendText("/do Понятые отсутствуют, ведётся видеозапись")
                Send("{Enter}")
                PauseWithCheck(300)
            }

            Send("{" ChatKey " down}")
            Sleep(30)
            Send("{" ChatKey " up}")
            PauseWithCheck(300)
            SendText("/me провёл полный личный обыск")
            Send("{Enter}")
            PauseWithCheck(300)

            AmountData := GetContrabandAmount()
            if !AmountData
                return
            Amount := AmountData.Amount

            if (Amount = "0") {
                Send("{" ChatKey " down}")
                Sleep(30)
                Send("{" ChatKey " up}")
                PauseWithCheck(300)
                SendText("/do Изъятых предметов нету")
                Send("{Enter}")
                PauseWithCheck(300)
            } else {
                Send("{" ChatKey " down}")
                Sleep(30)
                Send("{" ChatKey " up}")
                PauseWithCheck(300)
                SendText("/do Изъято " Amount " единиц(ы) запрещённых предметов")
                Send("{Enter}")
                PauseWithCheck(300)

                Send("{" ChatKey " down}")
                Sleep(30)
                Send("{" ChatKey " up}")
                PauseWithCheck(300)
                SendText("/do Предметы изъяты и упакованы")
                Send("{Enter}")
                PauseWithCheck(300)
            }

            Send("{" ChatKey " down}")
            Sleep(30)
            Send("{" ChatKey " up}")
            PauseWithCheck(300)
            SendText("/me снял и убрал перчатки")
            Send("{Enter}")
            PauseWithCheck(300)
            
            ToolTip("Готово!")
            SetTimer(() => ToolTip(), -1500)
            return
        }
    }
}

; ===== 5. РАЦИЯ (F5) =====
F5::
{
    global ChatKey
    ToolTip("Рация...")
    SetTimer(() => ToolTip(), -1500)

    Data := GetRadioMessage()
    if !Data
        return

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me снял рацию")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me зажал оранжевую кнопку PPT")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/do Из динамика послышался звук включения")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("-Р- " Data.Message)
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me отпустил кнопку и убрал рацию")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 6. МИРАНДА (F6) =====
F6::
{
    global ChatKey
    ToolTip("Миранда...")
    SetTimer(() => ToolTip(), -1500)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("-Вы имеете законное право хранить молчание")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("-Требовать присутствия адвоката")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("-Совершить один звонок")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("-Знать причину задержания")
    Send("{Enter}")
    PauseWithCheck(400)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("-Получать документы на подпись только после внимательного прочтения")
    Send("{Enter}")
    PauseWithCheck(400)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 7. ПРОЦЕДУРА АРЕСТА (F7) =====
F7::
{
    global ChatKey
    ToolTip("Арест...")
    SetTimer(() => ToolTip(), -1500)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me взял задержанного за запястья и повёл к патрульной машине")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me усадил задержанного в служебный транспорт")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me закрыл дверь и направился к водительскому месту")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== 8. ПЕРЕВОД ПМ В БОЕВОЕ ПОЛОЖЕНИЕ (F8) =====
F8::
{
    global ChatKey
    ToolTip("ПМ в боевое...")
    SetTimer(() => ToolTip(), -1500)

    Choice := GetReloadChoice()
    if (Choice = "") {
        ToolTip("Отменено!")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me достал Пистолет Макарова из кобуры")
    Send("{Enter}")
    PauseWithCheck(300)

    if (Choice = "ДА") {
        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/me снял пустой магазин")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/me убрал пустой магазин в карман")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/me достал из кармана полный магазин")
        Send("{Enter}")
        PauseWithCheck(300)

        Send("{" ChatKey " down}")
        Sleep(30)
        Send("{" ChatKey " up}")
        PauseWithCheck(300)
        SendText("/me вставил полный магазин на место старого")
        Send("{Enter}")
        PauseWithCheck(300)
    }

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/me передёрнул затвор, дослав патрон в патронник")
    Send("{Enter}")
    PauseWithCheck(300)

    Send("{" ChatKey " down}")
    Sleep(30)
    Send("{" ChatKey " up}")
    PauseWithCheck(300)
    SendText("/do ПМ готов к применению, оружие в боевом положении")
    Send("{Enter}")
    PauseWithCheck(300)

    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

; ===== НАСТРОЙКИ (Ctrl+F4) =====
^F4::
{
    global ChatKey, ChangeChatKey, ResetToDefault
    SettingsGui := Gui()
    SettingsGui.Title := "Настройки"
    SettingsGui.Opt("+AlwaysOnTop")
    SettingsGui.Add("Text",, "═══════════════════════════════════════")
    SettingsGui.Add("Text",, "  НАСТРОЙКИ СКРИПТА")
    SettingsGui.Add("Text",, "═══════════════════════════════════════")
    SettingsGui.Add("Text",, "  Клавиша открытия чата: " ChatKey)
    SettingsGui.Add("Text",, "═══════════════════════════════════════")
    
    BtnChatKey := SettingsGui.Add("Button",, "Сменить клавишу чата")
    BtnChatKey.OnEvent("Click", ChangeChatKey)
    
    BtnReset := SettingsGui.Add("Button",, "Сброс к заводским")
    BtnReset.OnEvent("Click", ResetToDefault)
    
    BtnReload := SettingsGui.Add("Button",, "Перезапустить скрипт")
    BtnReload.OnEvent("Click", (*) => Reload())
    
    SettingsGui.Add("Text",, "")
    BtnClose := SettingsGui.Add("Button", "Default", "ЗАКРЫТЬ")
    BtnClose.OnEvent("Click", (*) => SettingsGui.Destroy())
    
    SettingsGui.Show()
}

; ===== ПЕРЕЗАПУСК (Ctrl+R) =====
^r::
{
    ToolTip("Перезапуск...")
    SetTimer(() => ToolTip(), -1500)
    Sleep(500)
    Reload()
}