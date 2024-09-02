import 'package:dio/dio.dart';
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
}
