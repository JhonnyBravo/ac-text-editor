VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ExcelController"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Implements DataTransferRepository

'''
'Access テーブルのデータを Excel へ出力する。
'
'@param objModel 入力元テーブル名と出力先ファイルパスの情報を格納した DataTransfer オブジェクトを指定する。
'''
Private Sub DataTransferRepository_exportData(objModel As Object)
    Dim objDt As DataTransfer
    Set objDt = objModel

    On Error GoTo catch

    With objDt
        DoCmd.TransferSpreadsheet acExport, acSpreadsheetTypeExcel12Xml, .source, .destination, True
    End With

    Exit Sub
catch:
    Dim strMsg As String

    strMsg = "エラーが発生しました。 " & Err.Description
    Debug.Print strMsg
    MsgBox strMsg
End Sub

'''
'Excel を読込み、 Access テーブルへ登録する。
'
'@param objModel 入力元ファイルのパスを格納した DataTransfer オブジェクトを指定する。
'''
Private Sub DataTransferRepository_importData(objModel As Object)
    Dim objDt As DataTransfer
    Set objDt = objModel

    Dim objExcel As New Excel.Application
    Dim objWorkbook As Excel.Workbook
    Dim objSheet As Excel.Worksheet

    On Error GoTo catch

    With objExcel
        .Visible = True
        Set objWorkbook = .Workbooks.Open(objDt.source)
        Set objSheet = objWorkbook.Sheets(1)

        Dim strRowEnd As String
        Dim strColEnd As String

        strRowEnd = "A2"
        strColEnd = "C2"

        With objSheet.Range("A2")
            If .Cells(1, 1).Value <> "" And .Cells(2, 1).Value <> "" Then
                strRowEnd = .End(xlDown).Address
            End If
        End With

        Dim objRange As Range
        Dim varRecordset

        Set objRange = objSheet.Range(strRowEnd & ":" & strColEnd)
        varRecordset = objRange

        Dim lngRow As Long
        Dim objAc As CrudRepository
        Dim objArticles As Articles

        Set objAc = New ArticlesController

        For lngRow = 1 To UBound(varRecordset)
            Set objArticles = New Articles

            With objArticles
                .id = varRecordset(lngRow, 1)
                .title = varRecordset(lngRow, 2)
                .contents = varRecordset(lngRow, 3)
            End With

            objAc.createRecord objArticles
        Next
    End With

    GoTo finally
catch:
    Dim strMsg As String

    strMsg = "エラーが発生しました。 " & Err.Description
    Debug.Print strMsg
    MsgBox strMsg
finally:
    objWorkbook.Close
    objExcel.Quit
    Set objAc = Nothing
End Sub
