enum KeyValue {
  current,
  high,
  low,
  range,
  rangeDiv4,
  highCost,
  middleCost,
  lowCost,
  superPress,
  absolutePress,
  nestPress,
  nestSupport,
  absoluteSupport,
  superSupport,
  dayLongAttack15,
  dayLongMiddle15,
  dayLongDefense15,
  dayShortAttack15,
  dayShortMiddle15,
  dayShortDefense15,
  dayLongAttack30,
  dayLongMiddle30,
  dayLongDefense30,
  dayShortAttack30,
  dayShortMiddle30,
  dayShortDefense30,
  nightLongAttack15,
  nightLongMiddle15,
  nightLongDefense15,
  nightShortAttack15,
  nightShortMiddle15,
  nightShortDefense15,
  nightLongAttack30,
  nightLongMiddle30,
  nightLongDefense30,
  nightShortAttack30,
  nightShortMiddle30,
  nightShortDefense30,
}

extension KeyValueName on KeyValue {
  String get title {
    switch (this) {
      case KeyValue.current:
        return '現價';
      case KeyValue.high:
        return '高點';
      case KeyValue.low:
        return '低點';
      case KeyValue.range:
        return '點差';
      case KeyValue.rangeDiv4:
        return '點差/4';
      case KeyValue.highCost:
        return '高成本';
      case KeyValue.middleCost:
        return '中成本';
      case KeyValue.lowCost:
        return '低成本';
      case KeyValue.superPress:
        return '超漲';
      case KeyValue.absolutePress:
        return '壓二';
      case KeyValue.nestPress:
        return '壓一';
      case KeyValue.nestSupport:
        return '撐一';
      case KeyValue.absoluteSupport:
        return '撐二';
      case KeyValue.superSupport:
        return '超跌';
      case KeyValue.dayLongAttack15:
        return '日盤，15分多方最大邏輯，攻擊價';
      case KeyValue.dayLongMiddle15:
        return '日盤，15分多方最大邏輯，中關價';
      case KeyValue.dayLongDefense15:
        return '日盤，15分多方最大邏輯，防守價';
      case KeyValue.dayShortAttack15:
        return '日盤，15分空方最大邏輯，攻擊價';
      case KeyValue.dayShortMiddle15:
        return '日盤，15分空方最大邏輯，中關價';
      case KeyValue.dayShortDefense15:
        return '日盤，15分空方最大邏輯，防守價';
      case KeyValue.dayLongAttack30:
        return '日盤，30分多方最大邏輯，攻擊價';
      case KeyValue.dayLongMiddle30:
        return '日盤，30分多方最大邏輯，中關價';
      case KeyValue.dayLongDefense30:
        return '日盤，30分多方最大邏輯，防守價';
      case KeyValue.dayShortAttack30:
        return '日盤，30分空方最大邏輯，攻擊價';
      case KeyValue.dayShortMiddle30:
        return '日盤，30分空方最大邏輯，中關價';
      case KeyValue.dayShortDefense30:
        return '日盤，30分空方最大邏輯，防守價';
      case KeyValue.nightLongAttack15:
        return '夜盤，15分多方最大邏輯，攻擊價';
      case KeyValue.nightLongMiddle15:
        return '夜盤，15分多方最大邏輯，中關價';
      case KeyValue.nightLongDefense15:
        return '夜盤，15分多方最大邏輯，防守價';
      case KeyValue.nightShortAttack15:
        return '夜盤，15分空方最大邏輯，攻擊價';
      case KeyValue.nightShortMiddle15:
        return '夜盤，15分空方最大邏輯，中關價';
      case KeyValue.nightShortDefense15:
        return '夜盤，15分空方最大邏輯，防守價';
      case KeyValue.nightLongAttack30:
        return '夜盤，30分多方最大邏輯，攻擊價';
      case KeyValue.nightLongMiddle30:
        return '夜盤，30分多方最大邏輯，中關價';
      case KeyValue.nightLongDefense30:
        return '夜盤，30分多方最大邏輯，防守價';
      case KeyValue.nightShortAttack30:
        return '夜盤，30分空方最大邏輯，攻擊價';
      case KeyValue.nightShortMiddle30:
        return '夜盤，30分空方最大邏輯，中關價';
      case KeyValue.nightShortDefense30:
        return '夜盤，30分空方最大邏輯，防守價';
    }
  }
}