VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CrudRepository"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Compare Database
Option Explicit

'''
'@return recordset レコードセットを開いて返す。
'''
Public Function findAll() As DAO.Recordset

End Function

'''
'@param lngId 検索対象とするレコードの ID 番号を指定する。
'@return recordset 指定した ID を持つレコードまで移動し、レコードセットを返す。
'''
Public Function findById(lngId As Long) As DAO.Recordset

End Function

'''
'レコードを新規登録する。
'
'@param objModel 新規登録するモデルオブジェクトを指定する。
'''
Public Sub createRecord(objModel As Object)

End Sub

'''
'既存レコードを更新する。
'
'@param objModel 更新情報を格納したモデルオブジェクトを指定する。
'''
Public Sub updateRecord(objModel As Object)

End Sub

'''
'レコードを削除する。
'
'@param objModel 削除情報を格納したモデルオブジェクトを指定する。
'''
Public Sub deleteRecord(objModel As Object)

End Sub
