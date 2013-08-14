class StatePreposition
  def initialize(name)
    @name = name.mb_chars.upcase
  end

  def format
    "ESTADO #{preposition} #{@name}"
  end

  def preposition
    case @name
      when *STATES[:da] then 'DA'
      when *STATES[:de] then 'DE'
      else 'DO'
    end
  end

  STATES = {
    :do => [
      'ACRE',
      'AMAPÁ',
      'AMAZONAS',
      'CEARÁ',
      'ESPÍRITO SANTO',
      'MARANHÃO',
      'PARÁ',
      'PARANÁ',
      'PIAUÍ',
      'RIO DE JANEIRO',
      'RIO GRANDE DO NORTE',
      'RIO GRANDE DO SUL',
      'TOCANTINS'
    ],
    :de => [
      'ALAGOAS',
      'GOIÁS',
      'MATO GROSSO',
      'MATO GROSSO DO SUL',
      'MINAS GERAIS',
      'PERNAMBUCO',
      'RONDÔNIA',
      'RORAIMA',
      'SANTA CATARINA',
      'SÃO PAULO',
      'SERGIPE'
    ],
    :da => [
      'BAHIA',
      'PARAÍBA'
    ]
  }
end
