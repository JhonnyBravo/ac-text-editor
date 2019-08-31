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
Private Sub closeForm()
    Forms("Viewer").Requery
    DoCmd.Close acForm, Me.Name, acSaveNo
End Sub

Private Sub btnClose_Click()
    closeForm
End Sub

'''
'レコードを削除する。
'''
Private Sub btnDelete_Click()
    With Me
        If IsNull(.txtId) = False Then
            Dim objArticles As Articles

            Set objArticles = New Articles
            objArticles.id = .txtId

            Dim objCr As CrudRepository

            Set objCr = New ArticlesController
            objCr.deleteRecord objArticles

            Set objCr = Nothing
            MsgBox "削除しました。"
            closeForm
        End If
    End With
End Sub

'''
'レコードを新規登録または更新する。
'''
Private Sub btnSave_Click()
    With Me
        If IsNull(.txtTitle.Value) Or IsNull(.txtContents.Value) Then
            MsgBox "Title または Contents が入力されていません。"
            Exit Sub
        End If
    End With

    Dim objArticles As Articles
    Set objArticles = New Articles

    With objArticles
        .title = Me.txtTitle
        .contents = Me.txtContents
    End With

    Dim objCr As CrudRepository

    If IsNull(Me.txtId) Then
        'ID が Null である場合は新規登録を実行する。
        Set objCr = New ArticlesController
        objCr.createRecord objArticles

        Set objCr = Nothing
        MsgBox "登録しました。"
        closeForm
    Else
        'ID が Null ではない場合は既存レコードを更新する。
        objArticles.id = Me.txtId

        Set objCr = New ArticlesController
        objCr.updateRecord objArticles

        Set objCr = Nothing
        MsgBox "更新しました。"
        closeForm
    End If
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
            Dim objCr As CrudRepository
            Dim objRs As DAO.Recordset

            Set objCr = New ArticlesController
            Set objRs = objCr.findById(.OpenArgs)

            .txtId = objRs.Fields("id").Value
            .txtTitle = objRs.Fields("title").Value
            .txtContents = objRs.Fields("contents").Value

            Set objCr = Nothing
        End If
    End With
End Sub
