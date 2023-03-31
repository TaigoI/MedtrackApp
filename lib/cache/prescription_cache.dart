import 'package:medtrack/api/prescription_api.dart';
import 'package:medtrack/components/prescription.dart';

class PrescriptionCache {

  late Duration _cacheValidDuration;
  late DateTime _lastFetchTime;
  late List<Prescription> _allRecords;

  PrescriptionCache(){
    _cacheValidDuration = const Duration(seconds: 30);
    _lastFetchTime = DateTime.fromMillisecondsSinceEpoch(0);
    _allRecords = [];
  }

  /// Refreshes all records from the API, replacing the ones that are in the cache.
  /// Notifies listeners if notifyListeners is true.
  Future<void> refreshAllRecords() async{
    _allRecords = await PrescriptionAPI.getAll(); // This makes the actual HTTP request
    _lastFetchTime = DateTime.now();
  }


  /// If the cache time has expired, or forceRefresh is true, records are refreshed from the API before being returned.
  /// Otherwise the cached records are returned.
  Future<List<Prescription>> getAllRecords({bool forceRefresh = false}) async{
    bool shouldRefreshFromApi = (_allRecords.isEmpty || _lastFetchTime.isBefore(DateTime.now().subtract(_cacheValidDuration)) || forceRefresh);

    if(shouldRefreshFromApi) {
      await refreshAllRecords();
    }

    return _allRecords;
  }
}
