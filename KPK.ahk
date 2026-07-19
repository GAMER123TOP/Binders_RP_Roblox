#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)

global myGui := "", tabCtrl := "", searchEdit := "", resultEdit := ""
global CachePath := ""
global TabsArray := ["УК", "КоАП", "ФЗОП", "УПК", "Конституция", "ПДД"]

; ===== ССЫЛКИ НА ФАЙЛЫ =====
global FilesMap := Map(
    "УК", {name: "uk.txt", url: "https://raw.githubusercontent.com/GAMER123TOP/Binders_RP_Roblox/refs/heads/KPK/uk.txt"},
    "КоАП", {name: "koap.txt", url: "https://raw.githubusercontent.com/GAMER123TOP/Binders_RP_Roblox/refs/heads/KPK/koap.txt"},
    "ФЗОП", {name: "fzop.txt", url: "https://raw.githubusercontent.com/GAMER123TOP/Binders_RP_Roblox/refs/heads/KPK/fzop.txt"},
    "УПК", {name: "upk.txt", url: "https://raw.githubusercontent.com/GAMER123TOP/Binders_RP_Roblox/refs/heads/KPK/upk.txt"},
    "Конституция", {name: "kons.txt", url: "https://raw.githubusercontent.com/GAMER123TOP/Binders_RP_Roblox/refs/heads/KPK/kons.txt"},
    "ПДД", {name: "pdd.txt", url: "https://raw.githubusercontent.com/GAMER123TOP/Binders_RP_Roblox/refs/heads/KPK/pdd.txt"}
)

; Хоткей Win+J для моментального открытия КПК
#j:: {
    OpenShporaWindow()
}

; ===== ПУТЬ К КЭШУ =====
GetCachePath() {
    cachePath := A_Temp "\Shpargalka\"
    if !DirExist(cachePath)
        DirCreate(cachePath)
    return cachePath
}

; ===== СКАЧИВАНИЕ ФАЙЛА =====
DownloadFile(url, localPath) {
    try {
        whr := ComObject("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", url, false)
        whr.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
        whr.Send()
        ADO := ComObject("ADODB.Stream")
        ADO.Type := 1
        ADO.Open()
        ADO.Write(whr.ResponseBody)
        ADO.SaveToFile(localPath, 2)
        ADO.Close()
        whr := "", ADO := ""
        return true
    } catch {
        return false
    }
}

; ===== ПРОВЕРКА И ОБНОВЛЕНИЕ ФАЙЛОВ =====
UpdateFiles() {
    global CachePath, FilesMap
    CachePath := GetCachePath()
    needUpdate := false
    
    for section, data in FilesMap {
        localPath := CachePath data.name
        if !FileExist(localPath) {
            needUpdate := true
            break
        }
        
        try {
            modTime := FileGetTime(localPath)
            if DateDiff(A_NowUTC, modTime, "Days") > 7 {
                needUpdate := true
                break
            }
        } catch {
            needUpdate := true
            break
        }
    }
    
    if needUpdate {
        for section, data in FilesMap {
            localPath := CachePath data.name
            if !DownloadFile(data.url, localPath) {
                ToolTip("Не удалось скачать: " data.name)
                SetTimer(() => ToolTip(), -2000)
                return ""
            }
        }
    }
    return CachePath
}

; ===== ПУТЬ К РЕЕСТРУ ДЛЯ ЗАКЛАДОК =====
KPKRegPath() {
    return "HKEY_CURRENT_USER\Software\Binders\KPK"
}

; ===== ИНИЦИАЛИЗАЦИЯ РЕЕСТРА =====
InitRegistry() {
    regPath := KPKRegPath()
    try {
        ; Пытаемся прочитать Count. Если его нет — выпадет в catch
        RegRead(regPath, "Count")
    } catch {
        ; Если параметра нет, создаем структуру и ставим 0
        try {
            RegCreateKey(regPath)
            RegWrite(0, "REG_SZ", regPath, "Count")
        }
    }
}

; ===== ДОБАВЛЕНИЕ ЗАКЛАДКИ =====
AddBookmark(*) {
    global resultEdit, tabCtrl, TabsArray
    
    if (resultEdit.Value == "" || resultEdit.Value == "Начните вводить запрос..." || resultEdit.Value == "Ничего не найдено...") {
        ToolTip("Сначала найдите статью!")
        SetTimer(() => ToolTip(), -2000)
        return
    }
    
    regPath := KPKRegPath()
    count := Number(RegRead(regPath, "Count"))
    
    count += 1
    activeTab := TabsArray[tabCtrl.Value]
    firstLine := StrSplit(resultEdit.Value, "`n")[1]
    bookmarkData := "[" activeTab "] " . firstLine . "`n" . resultEdit.Value
    
    RegWrite(count, "REG_SZ", regPath, "Count")
    RegWrite(bookmarkData, "REG_SZ", regPath, "Bookmark_" . count)
    
    ToolTip("Статья добавлена в закладки! (" count ")")
    SetTimer(() => ToolTip(), -2000)
}

; ===== ПОКАЗ ЗАКЛАДОК =====
ShowBookmarks(*) {
    global TabsArray, tabCtrl, resultEdit, myGui
    regPath := KPKRegPath()
    
    count := Number(RegRead(regPath, "Count"))
    
    if (count == 0) {
        MsgBox("Закладок пока нет.", "Закладки", 64)
        return
    }
    
    bookmarks := []
    Loop count {
        try {
            data := RegRead(regPath, "Bookmark_" . A_Index)
            if (data != "") {
                bookmarks.Push(data)
            }
        }
    }
    
    if (bookmarks.Length == 0) {
        MsgBox("Закладок нет.", "Закладки", 64)
        return
    }
    
    bmGui := Gui("+Resize", "Закладки")
    bmGui.SetFont("s9", "Segoe UI")
    bmGui.Add("Text",, "Ваши сохранённые статьи (" bookmarks.Length " шт.):")
    
    listBox := bmGui.Add("ListBox", "w500 h300 Choose1")
    
    listBoxItems := []
    Loop bookmarks.Length {
        bm := bookmarks[A_Index]
        firstLine := StrSplit(bm, "`n")[1]
        listBoxItems.Push(firstLine)
    }
    listBox.Add(listBoxItems)
    
    ; ----- КНОПКА ОТКРЫТЬ -----
    bmGui.Add("Button", "w100 x10 y+10", "Открыть").OnEvent("Click", BtnOpenClick)
    
    BtnOpenClick(*) {
        selected := listBox.Text
        if (selected == "")
            return
        
        Loop bookmarks.Length {
            bm := bookmarks[A_Index]
            firstLine := StrSplit(bm, "`n")[1]
            if (firstLine == selected) {
                parts := StrSplit(bm, "`n", "`r")
                if (parts.Length >= 2) {
                    section := parts[1]
                    Loop TabsArray.Length {
                        tabName := TabsArray[A_Index]
                        if InStr(section, tabName) {
                            tabCtrl.Choose(A_Index)
                            content := ""
                            Loop parts.Length - 1 {
                                content .= parts[A_Index + 1] . "`n"
                            }
                            resultEdit.Value := Trim(content, "`n")
                            bmGui.Destroy()
                            if WinExist("ahk_id " myGui.Hwnd) {
                                WinActivate("ahk_id " myGui.Hwnd)
                            }
                            return
                        }
                    }
                }
            }
        }
    }
    
    ; ----- КНОПКА УДАЛИТЬ -----
    bmGui.Add("Button", "w100 x+5 yp", "Удалить").OnEvent("Click", BtnDeleteClick)
    
    BtnDeleteClick(*) {
        selected := listBox.Text
        if (selected == "")
            return
        
        Loop bookmarks.Length {
            bm := bookmarks[A_Index]
            firstLine := StrSplit(bm, "`n")[1]
            if (firstLine == selected) {
                try RegDelete(regPath, "Bookmark_" . A_Index)
                ReindexBookmarks()
                bmGui.Destroy()
                ShowBookmarks()
                return
            }
        }
    }
    
    ; ----- КНОПКА ОЧИСТИТЬ ВСЁ -----
    bmGui.Add("Button", "w100 x+5 yp", "Очистить всё").OnEvent("Click", BtnClearAllClick)
    
    BtnClearAllClick(*) {
        if (MsgBox("Удалить все закладки?", "Подтверждение", 4) == "Yes") {
            Loop bookmarks.Length {
                try RegDelete(regPath, "Bookmark_" . A_Index)
            }
            RegWrite(0, "REG_SZ", regPath, "Count") ; Сбрасываем счетчик обратно на 0
            bmGui.Destroy()
            ToolTip("Все закладки удалены!")
            SetTimer(() => ToolTip(), -2000)
        }
    }
    
    ; ----- КНОПКА ЗАКРЫТЬ -----
    bmGui.Add("Button", "w100 x+5 yp", "Закрыть").OnEvent("Click", (*) => bmGui.Destroy())
    bmGui.Show()
}

; ===== ПЕРЕИНДЕКСАЦИЯ ЗАКЛАДОК =====
ReindexBookmarks() {
    regPath := KPKRegPath()
    bookmarks := []
    maxIndex := 100 
    
    Loop maxIndex {
        try {
            data := RegRead(regPath, "Bookmark_" . A_Index)
            if (data != "") {
                bookmarks.Push(data)
            }
        }
    }
    
    Loop maxIndex {
        try RegDelete(regPath, "Bookmark_" . A_Index)
    }
    
    if (bookmarks.Length == 0) {
        RegWrite(0, "REG_SZ", regPath, "Count") ; Если удалили последнюю, пишем 0
        return
    }
    
    Loop bookmarks.Length {
        RegWrite(bookmarks[A_Index], "REG_SZ", regPath, "Bookmark_" . A_Index)
    }
    RegWrite(bookmarks.Length, "REG_SZ", regPath, "Count")
}

; ===== ГЛАВНОЕ ОКНО ШПОРЫ =====
OpenShporaWindow() {
    global myGui, tabCtrl, searchEdit, resultEdit, CachePath, TabsArray
    
    if (myGui) {
        try {
            if WinExist("ahk_id " myGui.Hwnd) {
                WinActivate("ahk_id " myGui.Hwnd)
                return
            } else {
                myGui := ""
            }
        } catch {
            myGui := ""
        }
    }
    
    ; Гарантируем, что ветка реестра и параметр Count (хотя бы со значением 0) существуют
    InitRegistry()
    
    CachePath := UpdateFiles()
    
    myGui := Gui("+Resize", "Единая Шпора по кодексам")
    myGui.SetFont("s10", "Segoe UI")
    
    tabCtrl := myGui.Add("Tab3", "w720 h40", TabsArray)
    tabCtrl.UseTab()
    
    myGui.Add("Text", "x15 y+15", "Введите номер статьи или ключевое слово:")
    searchEdit := myGui.Add("Edit", "w500 x15 y+5 vSearchTerm")
    
    myGui.Add("Button", "w100 x+10 yp", "В закладки").OnEvent("Click", AddBookmark)
    myGui.Add("Button", "x+5 w100", "Закладки").OnEvent("Click", ShowBookmarks)
    
    resultEdit := myGui.Add("Edit", "w700 h430 x15 y+10 +ReadOnly +Multi +VScroll vResultWindow")
    
    searchEdit.OnEvent("Change", SearchRoutine)
    tabCtrl.OnEvent("Change", SearchRoutine)
    
    myGui.OnEvent("Escape", (*) => CloseGui())
    myGui.OnEvent("Close", (*) => CloseGui())
    
    myGui.Show()
    resultEdit.Value := "Начните вводить запрос..."
    searchEdit.Focus()
}

CloseGui() {
    global myGui
    if (myGui) {
        myGui.Destroy()
        myGui := ""
    }
}

; ===== ПОИСК =====
SearchRoutine(*) {
    global searchEdit, resultEdit, tabCtrl, CachePath, TabsArray
    
    searchTerm := Trim(searchEdit.Value)
    
    if (StrLen(searchTerm) < 1) {
        resultEdit.Value := "Начните вводить запрос..."
        return
    }
    
    activeTab := TabsArray[tabCtrl.Value]
    fileName := ""
    
    switch activeTab {
        case "УК":          fileName := "uk.txt"
        case "КоАП":        fileName := "koap.txt"
        case "ФЗОП":        fileName := "fzop.txt"
        case "УПК":         fileName := "upk.txt"
        case "Конституция": fileName := "kons.txt"
        case "ПДД":         fileName := "pdd.txt"
    }
    
    fullPath := CachePath fileName
    if !FileExist(fullPath) {
        resultEdit.Value := "Ошибка: Файл '" . fileName . "' не найден!`nПроверьте интернет-соединение."
        return
    }
    
    try {
        cleanText := FileRead(fullPath, "UTF-8")
    } catch {
        try {
            cleanText := FileRead(fullPath, "CP1251")
        } catch {
            resultEdit.Value := "Ошибка чтения файла."
            return
        }
    }
    
    finalResultText := ""
    blockContent := ""
    readingBlock := false
    foundBlocks := []
    
    Loop Parse, cleanText, "`n", "`r" {
        currentLine := Trim(A_LoopField)
        if (currentLine == "")
            continue
        
        isNewBlock := RegExMatch(currentLine, "i)^\s*(Статья|Ст\.)\s*\d+") || (fileName = "pdd.txt" && RegExMatch(currentLine, "^\s*\d+\.\d+"))
        
        if (isNewBlock) {
            if (readingBlock) {
                if (blockContent != "") {
                    foundBlocks.Push(Trim(blockContent, "`r`n"))
                }
                readingBlock := false
                blockContent := ""
            }
            
            if (IsMatch(currentLine, searchTerm)) {
                readingBlock := true
                blockContent := currentLine . "`n"
            }
        } else if (readingBlock) {
            blockContent .= currentLine . "`n"
        }
    }
    
    if (readingBlock && blockContent != "") {
        foundBlocks.Push(Trim(blockContent, "`r`n"))
    }
    
    if (foundBlocks.Length > 0) {
        finalResultText := ""
        Loop foundBlocks.Length {
            finalResultText .= foundBlocks[A_Index] . "`n`n"
        }
    } else {
        matchCount := 0
        Loop Parse, cleanText, "`n", "`r" {
            currentLine := Trim(A_LoopField)
            if (currentLine == "")
                continue
            
            if InStr(StrLower(currentLine), StrLower(searchTerm)) {
                finalResultText .= currentLine . "`n----------------------------------------`n"
                matchCount++
                if (matchCount >= 40) {
                    finalResultText .= "[Выведено первые 40 совпадений. Уточните ваш запрос...]"
                    break
                }
            }
        }
    }
    
    if (finalResultText != "") {
        resultEdit.Value := Trim(finalResultText, "`n")
    } else {
        resultEdit.Value := "Ничего не найдено в разделе [" . activeTab . "] по запросу: " . searchTerm
    }
}

; ===== ФУНКЦИЯ СРАВНЕНИЯ =====
IsMatch(text, query) {
    if RegExMatch(query, "^[\d\.]+$") {
        return RegExMatch(text, "i)^\s*(Статья|Ст\.)\s*" . query . "\b") || RegExMatch(text, "^\s*" . query . "\b")
    }
    return InStr(StrLower(text), StrLower(query))
}