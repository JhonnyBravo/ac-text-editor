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

    Dim objDt As DataTransfer
    Dim objDtr As DataTransferRepository

    Select Case Me.lstType.Value
        Case "CSV"
            Set objDt = New DataTransfer

            With objDt
                .source = "articles"
                .destination = strPath & "\articles_" & Format(Date, "yyyymmdd") & ".csv"
            End With

            Set objDtr = New CsvController
            objDtr.exportData objDt
        Case "Excel"
            Set objDt = New DataTransfer

            With objDt
                .source = "articles"
                .destination = strPath & "\articles_" & Format(Date, "yyyymmdd") & ".xlsx"
            End With

            Set objDtr = New ExcelController
            objDtr.exportData objDt
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
    Dim objDt As DataTransfer
    Dim objDtr As DataTransferRepository

    For Each objFile In objFiles
        If objFile.Path Like "*\articles_*.csv" Then
            Set objDt = New DataTransfer
            objDt.source = objFile.Path

            Set objDtr = New CsvController
            objDtr.importData objDt
        ElseIf objFile.Path Like "*\articles_*.xlsx" Then
            Set objDt = New DataTransfer
            objDt.source = objFile.Path

            Set objDtr = New ExcelController
            objDtr.importData objDt
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
