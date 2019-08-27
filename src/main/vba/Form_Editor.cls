VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Editor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

'''
'Viewer フォームのレコードを更新して
'Editor フォームを閉じる。
'''
Private Sub btnClose_Click()
    Forms("Viewer").Requery
    DoCmd.Close acForm, Me.Name, acSaveNo
End Sub

'''
'レコードを削除する。
'''
Private Sub btnDelete_Click()
    Dim lngId As Long

    With Me
        If IsNull(.txtId) = False Then
            lngId = .txtId

            Dim objDb As DAO.Database
            Dim objRs As DAO.Recordset

            Set objDb = Application.CurrentDb
            Set objRs = objDb.OpenRecordset("articles", dbOpenDynaset)

            With objRs
                .FindFirst "id=" & lngId
                .Delete
            End With

            MsgBox "削除しました。"

            objRs.Close
            objDb.Close
        End If
    End With
End Sub

'''
'レコードを新規登録または更新する。
'''
Private Sub btnSave_Click()
    Dim lngId As Long
    Dim strTitle As String
    Dim strContents As String

    With Me
        If IsNull(.txtTitle.Value) Or IsNull(.txtContents.Value) Then
            MsgBox "Title または Contents が入力されていません。"
            Exit Sub
        Else
            strTitle = .txtTitle
            strContents = .txtContents
        End If
    End With

    Dim objDb As DAO.Database
    Dim objRs As DAO.Recordset

    Set objDb = Application.CurrentDb
    Set objRs = objDb.OpenRecordset("articles", dbOpenDynaset)

    If IsNull(Me.txtId) Then
        'ID が Null である場合は新規登録を実行する。
        With objRs
            If .RecordCount = 0 Then
                lngId = 1
            Else
                lngId = DMax("id", "articles") + 1
            End If

            .AddNew

            .Fields("id").Value = lngId
            .Fields("title").Value = strTitle
            .Fields("contents").Value = strContents

            .Update
        End With

        MsgBox "登録しました。"
    Else
        'ID が Null ではない場合は既存レコードを更新する。
        With objRs
            lngId = Me.txtId

            .FindFirst "id=" & lngId
            .Edit

            .Fields("title").Value = strTitle
            .Fields("contents").Value = strContents

            .Update
        End With

        MsgBox "更新しました。"
    End If

    objRs.Close
    objDb.Close
End Sub

'''
'Editor フォームを起動する。
'''
Private Sub Form_Open(Cancel As Integer)
    Dim lngId As Long

    With Me
        If IsNull(.OpenArgs) Then
            '新規登録モードで開いた場合
            .txtId = Null
            .txtTitle = Null
            .txtContents = Null
        Else
            '編集モードで開いた場合
            lngId = .OpenArgs

            Dim objDb As DAO.Database
            Dim objRs As DAO.Recordset

            Set objDb = Application.CurrentDb
            Set objRs = objDb.OpenRecordset("articles", dbOpenDynaset)

            objRs.FindFirst "id=" & lngId

            .txtId = objRs.Fields("id").Value
            .txtTitle = objRs.Fields("title").Value
            .txtContents = objRs.Fields("contents").Value

            objRs.Close
            objDb.Close
        End If
    End With
End Sub
