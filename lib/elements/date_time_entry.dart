import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class DateTimeEntry extends StatefulWidget {
  final String entryLabel;
  final String entry;
  final IconData icon;
  final String? tripStartDate;
  final DateTimePickerType entryType;
  final TextEditingController controller;
  final ValueSetter<String>? onChange;

  const DateTimeEntry({
    required this.entry,
    required this.icon,
    required this.entryLabel,
    required this.entryType,
    required this.controller,
    this.onChange,
    this.tripStartDate,
  });

  @override
  State<DateTimeEntry> createState() => _DateTimeEntryState();
}

class _DateTimeEntryState extends State<DateTimeEntry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            child: Icon(widget.icon),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.entryLabel,
                style: GoogleFonts.ptSans(fontSize: 16, color: Colors.black),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 40,
                width: 90,
                child: Localizations(
                  delegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  locale: Locale('en', ''),
                  child: DateTimePicker(
                    controller: widget.controller,
                    type: widget.entryType,
                    dateLabelText: 'Date',
                    use24HourFormat: true,
                    locale: Locale('en', ''),
                    initialDate: widget.tripStartDate != null
                        ? DateTime.parse(widget.tripStartDate!)
                        : DateTime.now(),
                    firstDate: widget.tripStartDate != null
                        ? DateTime.parse(widget.tripStartDate!)
                        : DateTime.now(),
                    lastDate: DateTime.now().add(
                      Duration(days: 60),
                    ),
                    initialTime: TimeOfDay.fromDateTime(
                      DateTime.now().add(
                        Duration(minutes: 15),
                      ),
                    ),
                    style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Select',
                      hintStyle:
                          GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                    ),
                    onChanged: widget.onChange != null
                        ? (input) {
                            widget.onChange!(input);
                          }
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
