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
'現在フォームに表示しているレコードを削除する。
'''
Private Sub btnDelete_Click()
    Dim strLog As String

    On Error GoTo catch

    DoCmd.RunCommand acCmdDeleteRecord
    strLog = "レコードを削除しました。"
    GoTo finally
catch:
    strLog = Err.Description
finally:
    Debug.Print strLog
End Sub

'''
'Editor フォームを起動する。
'''
Private Sub Form_Open(Cancel As Integer)
    Dim lngId As Long

    With Me
        If IsNull(.OpenArgs) Then
            '新規登録モードで開いた場合
            .Filter = ""
            .FilterOn = False
        Else
            '編集モードで開いた場合
            lngId = .OpenArgs
            .Filter = "id=" & lngId
            .FilterOn = True
            .AllowAdditions = False
        End If
    End With
End Sub
