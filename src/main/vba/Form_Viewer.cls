VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Viewer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

'''
'新規登録用フォームを起動する。
'''
Private Sub btnCreate_Click()
    DoCmd.OpenForm "Editor", acNormal, , , acFormAdd, acWindowNormal
End Sub

'''
'記事データを CSV または Excel へ出力する。
'''
Private Sub btnExport_Click()
    Dim strPath As String

    If IsNull(Me.txtPath) Then
        MsgBox "出力先フォルダーのパスを指定してください。"
        Exit Sub
    End If

    strPath = Me.txtPath

    If IsNull(Me.lstType) Then
        MsgBox "出力ファイル形式を指定してください。"
        Exit Sub
    End If

    Select Case Me.lstType.Value
        Case "CSV"
            DoCmd.TransferText acExportDelim, , "articles", strPath & "\articles_" & Format(Date, "yyyymmdd") & ".csv", True
        Case "Excel"
            DoCmd.TransferSpreadsheet acExport, acSpreadsheetTypeExcel12Xml, "articles", strPath & "\articles_" & Format(Date, "yyyymmdd") & ".xlsx", True
    End Select

    MsgBox "完了しました。"
End Sub

'''
'CSV または Excel を読込み、 Access テーブルへ登録する。
'''
Private Sub btnImport_Click()
    If IsNull(Me.txtPath) Then
        MsgBox "ファイル取得元フォルダのパスを指定してください。"
        Exit Sub
    End If

    Dim objFso As New FileSystemObject
    Dim objFiles As Files
    Dim objFile As File

    Set objFiles = objFso.GetFolder(Me.txtPath).Files

    Dim varArray As Variant
    Dim objArticles As Articles
    Dim objAc As CrudRepository

    For Each objFile In objFiles
        If objFile.Path Like "*\articles_*.csv" Then
            Dim objStream As TextStream
            Dim strLine As String

            Set objStream = objFile.OpenAsTextStream(ForReading)

            With objStream
                .SkipLine

                Set objAc = New ArticlesController

                While .AtEndOfStream = False
                    strLine = .ReadLine
                    varArray = Split(Replace(strLine, """", ""), ",")
                    Set objArticles = New Articles

                    With objArticles
                        .id = varArray(0)
                        .title = varArray(1)
                        .contents = varArray(2)
                    End With

                    objAc.createRecord objArticles
                Wend

                .Close
                Set objAc = Nothing
            End With
        ElseIf objFile.Path Like "*\articles_*.xlsx" Then
            Dim objExcel As New Excel.Application
            Dim objWorkbook As Excel.Workbook
            Dim objWorksheet As Excel.Worksheet

            With objExcel
                .Visible = True
                Set objWorkbook = .Workbooks.Open(objFile.Path)
                Set objWorksheet = objWorkbook.Sheets(1)
            End With

            Dim strRowEnd As String
            Dim strColEnd As String

            strRowEnd = "A2"
            strColEnd = "C2"

            With objWorksheet.Range("A2")
                If .Cells(1, 1).Value <> "" And .Cells(2, 1).Value <> "" Then
                    strRowEnd = .End(xlDown).Address
                End If
            End With

            Dim objTable As Range

            Set objTable = objWorksheet.Range(strRowEnd & ":" & strColEnd)
            varArray = objTable

            Dim lngRow As Long

            Set objAc = New ArticlesController

            For lngRow = 1 To UBound(varArray)
                Set objArticles = New Articles

                With objArticles
                    .id = varArray(lngRow, 1)
                    .title = varArray(lngRow, 2)
                    .contents = varArray(lngRow, 3)
                End With

                objAc.createRecord objArticles
            Next

            objWorkbook.Close
            objExcel.Quit

            Set objAc = Nothing
        End If
    Next

    Me.Requery
    MsgBox "完了しました。"
End Sub

'''
'ファイルの出力先パスまたは入力元パスを設定する。
'''
Private Sub btnSetPath_Click()
    Dim objDialog As FileDialog
    Dim lngStatus As Long

    Set objDialog = Application.FileDialog(msoFileDialogFolderPicker)

    With objDialog
        .AllowMultiSelect = False
        .InitialFileName = Application.CurrentProject.Path
        lngStatus = .Show

        If lngStatus <> 0 Then
            Me.txtPath = .SelectedItems(1)
        End If
    End With
End Sub

'''
'更新用フォームを起動する。
'''
Private Sub btnUpdate_Click()
    Dim lngId As Long
    lngId = Me.txtId

    DoCmd.OpenForm "Editor", acNormal, , , acFormEdit, acWindowNormal, lngId
End Sub
