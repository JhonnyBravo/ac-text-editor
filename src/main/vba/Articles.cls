VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Articles"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Private propId As Long
Private propTitle As String
Private propContents As String

'''
'@return id 記事の ID 番号を返す。
'''
Public Property Get id() As Long
    id = propId
End Property

'''
'@param lngId 記事の ID として設定する整数を指定する。
'''
Public Property Let id(lngId As Long)
    propId = lngId
End Property

'''
'@return 記事のタイトルを返す。
'''
Public Property Get title() As String
    title = propTitle
End Property

'''
'@param strTitle 記事のタイトルを指定する。
'''
Public Property Let title(strTitle As String)
    propTitle = strTitle
End Property

'''
'@return contents 記事の本文を返す。
'''
Public Property Get contents() As String
    contents = propContents
End Property

'''
'@param strContents 記事の本文を指定する。
'''
Public Property Let contents(strContents As String)
    propContents = strContents
End Property
