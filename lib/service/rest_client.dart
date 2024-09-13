import 'package:dio/dio.dart';
import 'package:dominant_player/model/chart_data.dart';
import 'package:dominant_player/model/current_price.dart';
import 'package:dominant_player/model/product_months_info.dart';
import 'package:dominant_player/model/txf_info.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'https://mis.taifex.com.tw/')
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  static final RestClient instance = RestClient(Dio());

  @POST('futures/api/getQuoteList')
  Future<TxfResponse> getTxfInfo(@Body() TxfRequest request);

  @POST('futures/api/getCmdyMonthDDLItemByKind')
  Future<ProductMonthsInfoResponse> getProductMonthsInfo(@Body() TxfRequest request);

  @POST('futures/api/getChartData1M')
  Future<ChartDataResponse> getCurrentChartInfo(@Field('SymbolID') String symbolID);

  @POST('futures/api/getChartData1M_mem')
  Future<CurrentPriceResponse> getCurrentPrice(@Field('SymbolID') String symbolID);
}
