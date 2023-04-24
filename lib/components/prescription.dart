class PrescriptionModel {

  String key;
  String doctorName;
  String doctorRegistration; //ex.: 7156 CRM-AL

  PrescriptionModel({
    required this.key,
    required this.doctorName,
    required this.doctorRegistration,
  });

  /*persist(){
    //collection.doc(key).set(toJSON());
  }

  delete(){
    //collection.doc(key).set(toJSON());
  }

  static Future<PrescriptionModel> fromStorage(String key) async {
    var item = await collection.doc(key).get();
    return PrescriptionModel.fromJson(item!, key);
  }*/

  factory PrescriptionModel.fromJson(Map<String, dynamic> json, String key) {
    var prescription = PrescriptionModel(
        key: key,
        doctorName: json['doctorName'].toString(),
        doctorRegistration: json['doctorRegistration'].toString(),
    );
    return prescription;
  }

  toJSON() {
    Map<String, dynamic> json = {
      "key": key,
      "doctorName": doctorName,
      "doctorRegistration": doctorRegistration,
    };
    return json;
  }

}

/*
class Prescription extends StatefulWidget {
  final PrescriptionModel model;
  final List<PrescriptionItem> items;

  const Prescription({super.key, required this.title, required this.items, required this.deleteFunction});

  factory Prescription.fromJson(Function deleteFunction, Map<String, dynamic> json) {
    return Prescription(
      deleteFunction: deleteFunction,
      title: json['title'],
      items: (json['items'] as List)
          .map((json) => PrescriptionItem.fromJson(json))
          .toList(),
    );
  }

  toJSONEncodable() {
    Map<String, dynamic> m = {};
    m['title'] = title;
    m['items'] = items.map((item) {
      return item.toJSONEncodable();
    }).toList();
    return m;
  }

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin:
                const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 4),
            child: Row(
              children: <Widget>[
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(onPressed: () { widget.deleteFunction(widget.key); }, icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
              child: Column(children: widget.items)),
        ],
      ),
    );
  }
}
*/