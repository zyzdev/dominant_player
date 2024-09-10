class ChartInfo {
  final int period;

  final int open;
  final int high;
  final int close;
  final int low;
  late final double middle = (high + low) / 2;
  final int volume;
  final String startTime;
  final String endTime;

  late int highToOpenDis = high - open;
  late int lowToOpenDis = open - low;
  late int closeToOpen = close - open;
  late int distance = high - low;

  late int highToCloseDis = high - close;
  late int lowToCloseDis = close - low;

  ChartInfo({
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
    return 'ChartInfo{period: $period, open: $open, high: $high, close: $close, low: $low, middle: $middle, volume: $volume, startTime: $startTime, endTime: $endTime, highToOpenDis: $highToOpenDis, lowToOpenDis: $lowToOpenDis, closeToOpen: $closeToOpen, distance: $distance}';
  }
}
