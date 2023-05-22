import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medtrack/enums/dose_unit.dart';
import 'package:medtrack/enums/plural.dart';
import 'package:medtrack/enums/time_unit.dart';
import 'package:medtrack/models/medication.dart';

class MedicationPage extends StatefulWidget {
  final Medication medication;
  final bool isNew;

  const MedicationPage({super.key, required this.medication, required this.isNew});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    getInputDecoration(String? label, String? hint){
      return InputDecoration(
        labelText: label,
        hintText: hint,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.outline)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.primary, width: 2)),
        suffixStyle: TextStyle(color: colors.onSurfaceVariant),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("${widget.isNew ? 'Novo' : 'Editar'} Remédio"),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            children: [
              // Text("Hello Medication Page ${widget.medication.key}"),
              Form(
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: () {
                    Form.of(primaryFocus!.context!).save();
                  },
                  child: Column(
                    children: [
                      Card(
                          child: Container(
                              margin: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                      initialValue: widget.medication.patientName,
                                      decoration: getInputDecoration("Paciente", "Nome completo"),
                                      onSaved: (String? value) {setState(() {widget.medication.patientName = value!;});}
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                              initialValue: widget.medication.doctorName,
                                              decoration: getInputDecoration("Médico", "Nome completo"),
                                              onSaved: (String? value) {setState(() {widget.medication.doctorName = value!;});}
                                          )
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                              initialValue: widget.medication.doctorRegistration,
                                              decoration: getInputDecoration("Registro", "CRM-AL 0000"),
                                              onSaved: (String? value) {setState(() {widget.medication.doctorRegistration = value!;});}
                                          )
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  TextFormField(
                                      initialValue: widget.medication.medicationName,
                                      decoration: getInputDecoration("Medicamento", "Paracetamol"),
                                      onSaved: (String? value) {setState(() {widget.medication.medicationName = value!;});}
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                      initialValue: widget.medication.medicationDosage,
                                      decoration: getInputDecoration("Dosagem", "500mg Comprimido"),
                                      onSaved: (String? value) {setState(() {widget.medication.medicationDosage = value!;});}
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                              initialValue: widget.medication.doseAmount.toString(),
                                              decoration: getInputDecoration("Dose", "1"),
                                              onSaved: (String? value) {setState(() {widget.medication.doseAmount = int.parse(value!);});}
                                          )
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          flex: 1,
                                          child: DropdownButtonFormField(
                                            value: widget.medication.doseUnit,
                                            decoration: getInputDecoration(null, null),
                                            items: DoseUnitOption.values.map((e) => DropdownMenuItem(value: e,child: Text(
                                                DoseUnitController.asText(PluralController.fromAmount(widget.medication.doseAmount), e, true)
                                            ),)).toList(),
                                            onChanged: (value) {setState(() {widget.medication.doseUnit = value!;});},
                                            onSaved: (value) {setState(() {widget.medication.doseUnit = value!;});},
                                          )
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                              initialValue: widget.medication.interval.toString(),
                                              decoration: getInputDecoration("Intervalo entre doses","1"),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                              onSaved: (String? value) {setState(() {widget.medication.interval = int.parse(value!);});}
                                          )
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          flex: 2,
                                          child: DropdownButtonFormField(
                                            value: widget.medication.intervalUnit,
                                            decoration: getInputDecoration(null, null),
                                            items: TimeUnitOption.values.map((e) => DropdownMenuItem(value: e,child: Text(
                                                TimeUnitController.asText(PluralController.fromAmount(widget.medication.interval), e, true)
                                            ),)).toList(),
                                            onChanged: (value) {setState(() {widget.medication.intervalUnit = value!;});},
                                            onSaved: (value) {setState(() {widget.medication.intervalUnit = value!;});},
                                          )
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                      initialValue: widget.medication.occurrences.toString(),
                                      decoration: getInputDecoration("Total de doses", "1"),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                      onSaved: (String? value) {setState(() {widget.medication.occurrences = int.parse(value!);});}
                                  ),
                                  const SizedBox(height: 24),
                                  TextFormField(
                                      minLines: 3,
                                      initialValue: widget.medication.comments,
                                      decoration: getInputDecoration("Instruções", null),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      onSaved: (String? value) {setState(() {widget.medication.comments = value!;});}
                                  )
                                ],
                              )
                          )
                      )
                    ],
                  )
              ),
              const SizedBox(height: 16),
              SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, double.infinity) // put the width and height you want
                            ),
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              widget.medication.save();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Medicamento ${widget.isNew ? 'adicionado' : 'atualizado'} com sucesso!')),
                              );
                            },
                            child: const Text('Salvar'),
                          )
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

//TextFormField(
//  decoration: textFormInputDecoration,
//  onSaved: (String? value) {debugPrint('Value for field $index saved as "$value"');}
//)