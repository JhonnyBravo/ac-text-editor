VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CsvController"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Implements DataTransferRepository

'''
'Access テーブルのデータを CSV へ出力する。
'
'@param objModel 入力元テーブル名と出力先ファイルパスの情報を格納した DataTransfer オブジェクトを指定する。
'''
Private Sub DataTransferRepository_exportData(objModel As Object)
    Dim objDt As DataTransfer
    Set objDt = objModel

    On Error GoTo catch

    With objDt
        DoCmd.TransferText acExportDelim, , .source, .destination, True
    End With

    Exit Sub
catch:
    Dim strMsg As String
    strMsg = "エラーが発生しました。 " & Err.Description
    Debug.Print strMsg
    MsgBox strMsg
End Sub

'''
'CSV を読込み、 Access テーブルへ登録する。
'
'@param objModel 入力元ファイルのパスを格納した DataTransfer オブジェクトを指定する。
'''
Private Sub DataTransferRepository_importData(objModel As Object)
    Dim objDt As DataTransfer
    Set objDt = objModel

    Dim objFso As New FileSystemObject
    Dim objStream As TextStream

    Dim objAc As CrudRepository
    Dim objArticles As Articles
    Dim varRecord As Variant

    On Error GoTo catch

    Set objStream = objFso.GetFile(objDt.source).OpenAsTextStream(ForReading)

    With objStream
        .SkipLine

        Set objAc = New ArticlesController

        While .AtEndOfLine = False
            varRecord = Split(Replace(.ReadLine, """", ""), ",")
            Set objArticles = New Articles

            With objArticles
                .id = varRecord(0)
                .title = varRecord(1)
                .contents = varRecord(2)
            End With

            objAc.createRecord objArticles
        Wend
    End With

    GoTo finally
catch:
    Dim strMsg As String

    strMsg = "エラーが発生しました。 " & Err.Description
    Debug.Print strMsg
    MsgBox strMsg
finally:
    objStream.Close
    Set objAc = Nothing
End Sub
