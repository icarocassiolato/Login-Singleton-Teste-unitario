object DMUsuarioDados: TDMUsuarioDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object FdcConexao: TFDConnection
    BeforeConnect = FdcConexaoBeforeConnect
    Left = 40
    Top = 16
  end
  object FdqUsuario: TFDQuery
    Connection = FdcConexao
    Left = 40
    Top = 64
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 136
    Top = 16
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 136
    Top = 64
  end
end
