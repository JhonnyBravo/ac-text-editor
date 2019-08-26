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
'更新用フォームを起動する。
'''
Private Sub btnUpdate_Click()
    Dim lngId As Long
    lngId = Me.txtId

    DoCmd.OpenForm "Editor", acNormal, , , acFormEdit, acWindowNormal, lngId
End Sub
