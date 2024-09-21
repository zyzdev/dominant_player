import 'package:dio/dio.dart';
import 'package:dominant_player/model/chart_data.dart';
import 'package:dominant_player/model/current_price.dart';
import 'package:dominant_player/model/index_statistics.dart';
import 'package:dominant_player/model/product_months_info.dart';
import 'package:dominant_player/model/transaction_statistics.dart';
import 'package:dominant_player/model/txf_info.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'https://mis.taifex.com.tw/')
abstract class FutureClient {
  factory FutureClient(Dio dio) = _FutureClient;

  static final FutureClient instance = FutureClient(Dio());

  @POST('futures/api/getQuoteList')
  Future<TxfResponse> getTxfInfo(@Body() TxfRequest request);

  @POST('futures/api/getCmdyMonthDDLItemByKind')
  Future<ProductMonthsInfoResponse> getProductMonthsInfo(
      @Body() TxfRequest request);

  @POST('futures/api/getChartData1M')
  Future<ChartDataResponse> getCurrentChartInfo(
      @Field('SymbolID') String symbolID);

  @POST('futures/api/getChartData1M_mem')
  Future<CurrentPriceResponse> getCurrentPrice(
      @Field('SymbolID') String symbolID);
}

@RestApi(baseUrl: 'https://www.twse.com.tw/')
abstract class TaiexClient {
  factory TaiexClient(Dio dio) = _TaiexClient;

  static final TaiexClient instance = TaiexClient(Dio());

  @GET('rwd/zh/afterTrading/MI_5MINS')
  Future<TransactionStatisticsResponse> getTransactionStatistics([
    @Query('date') String? date,
    @Query('response') String response = 'json',
  ]);

  @GET('rwd/zh/TAIEX/MI_5MINS_INDEX')
  Future<IndexStatisticsResponse> getIndexStatistics([
    @Query('date') String? date,
    @Query('response') String response = 'json',
  ]);
}
