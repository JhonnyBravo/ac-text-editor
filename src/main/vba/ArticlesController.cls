VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ArticlesController"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Implements CrudRepository

Private objDb As DAO.Database
Private objRs As DAO.Recordset

Private Sub Class_Initialize()
    Set objDb = Application.CurrentDb
    Set objRs = objDb.OpenRecordset("articles", dbOpenDynaset)
End Sub

Private Sub Class_Terminate()
    objRs.Close
    objDb.Close
End Sub

'''
'新しい記事を登録する。
'
'@param objModel 登録対象とする Articles オブジェクトを指定する。
'''
Private Sub CrudRepository_createRecord(objModel As Object)
    Dim objArticles As Articles
    Set objArticles = objModel

    With objRs
        If .RecordCount = 0 Then
            objArticles.id = 1
        Else
            objArticles.id = DMax("id", "articles") + 1
        End If

        .AddNew

        .Fields("id").Value = objArticles.id
        .Fields("title").Value = objArticles.title
        .Fields("contents").Value = objArticles.contents

        .Update
    End With

    MsgBox "登録しました。"
End Sub

'''
'記事を削除する。
'
'@param objModel 削除情報を格納した Articles オブジェクトを指定する。
'''
Private Sub CrudRepository_deleteRecord(objModel As Object)
    Dim objArticles As Articles
    Dim objCr As CrudRepository

    Set objArticles = objModel
    Set objCr = Me

    objCr.findById(objArticles.id).Delete
    MsgBox "削除しました。"
End Sub

'''
'@return recordset articles テーブルを開き、レコードセットを返す。
'''
Private Function CrudRepository_findAll() As DAO.Recordset
    Set CrudRepository_findAll = objRs
End Function

'''
'@param lngId 検索対象とする記事の ID 番号を指定する。
'@return recordset 指定した ID を持つレコードまで移動し、レコードセットを返す。
'''
Private Function CrudRepository_findById(lngId As Long) As DAO.Recordset
    objRs.FindFirst "id=" & lngId
    Set CrudRepository_findById = objRs
End Function

'''
'既存の記事を更新する。
'
'@param objModel 更新情報を格納した Articles オブジェクトを指定する。
'''
Private Sub CrudRepository_updateRecord(objModel As Object)
    Dim objArticles As Articles
    Dim objCr As CrudRepository

    Set objArticles = objModel
    Set objCr = Me

    With objCr.findById(objArticles.id)
        .Edit

        .Fields("title").Value = objArticles.title
        .Fields("contents").Value = objArticles.contents

        .Update
    End With

    MsgBox "更新しました。"
End Sub
