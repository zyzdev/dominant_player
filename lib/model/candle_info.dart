class CandleInfo {

  /// K棒週期
  final int period;

  /// 開盤價
  final int open;
  /// 高點
  final int high;
  /// 收盤價
  final int close;
  /// 低點
  final int low;
  /// 中關
  late final double middle = (high + low) / 2;
  /// 成交量
  final int volume;
  /// 開始時間
  final String startTime;
  /// 結束時間
  final String endTime;

  /// 收盤到開盤的差距
  late int closeToOpen = close - open;
  /// K棒長度
  late int distance = high - low;
  /// K棒實體長度
  late final int bodyLength = closeToOpen.abs();

  /// 高點到開盤的長度
  late int highToOpenDis = high - open;
  /// 低點到開盤的長度
  late int lowToOpenDis = open - low;
  /// 高點到收盤的差距
  late int highToCloseDis = high - close;
  /// 收盤到低點的差距
  late int lowToCloseDis = close - low;

  /// 上影線長度
  late int upperShadowDis = high - close;
  /// 下影線長度
  late int lowerShadowDis = close - low;

  /// 是否收長上影
  late bool isCloseWithLongUpperShadow = upperShadowDis > bodyLength * 2 && upperShadowDis > lowerShadowDis;
  /// 是否收長下影
  late bool isCloseWithLongLowerShadow = lowerShadowDis > bodyLength * 2 && lowerShadowDis > upperShadowDis;

  late String time = '${startTime.substring(0, 2)}:${startTime.substring(2, 4)}';

  CandleInfo({
    required this.period,
    required this.open,
    required this.high,
    required this.close,
    required this.low,
    required this.volume,
    required this.startTime,
    required this.endTime,
  });

  @override
  String toString() {
    return 'CandleInfo{period: $period, open: $open, high: $high, close: $close, low: $low, middle: $middle, volume: $volume, startTime: $startTime, endTime: $endTime, closeToOpen: $closeToOpen, distance: $distance, highToOpenDis: $highToOpenDis, lowToOpenDis: $lowToOpenDis, highToCloseDis: $highToCloseDis, lowToCloseDis: $lowToCloseDis, upperShadowDis: $upperShadowDis, lowerShadowDis: $lowerShadowDis}';
  }
}
