VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "DataTransfer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Private propSource As String
Private propDestination As String

'''
'@return source 入力元のエンティティ名またはパスを返す。
'''
Public Property Get source() As String
    source = propSource
End Property

'''
'@param strSource 入力元のエンティティ名またはパスを指定する。
'''
Public Property Let source(strSource As String)
    propSource = strSource
End Property

'''
'@return 出力先のエンティティ名またはパスを返す。
'''
Public Property Get destination() As String
    destination = propDestination
End Property

'''
'@param strDestination 出力先のエンティティ名またはパスを指定する。
'''
Public Property Let destination(strDestination As String)
    propDestination = strDestination
End Property
