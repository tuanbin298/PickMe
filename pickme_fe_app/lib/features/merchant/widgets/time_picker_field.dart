import 'package:flutter/material.dart';

class TimePickerField extends StatefulWidget {
  final String label;
  final IconData icon;
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final Color? color;
  final bool readOnly;

  const TimePickerField({
    super.key,
    this.initialTime,
    this.color,
    required this.label,
    required this.icon,
    required this.onTimeSelected,
    required this.readOnly,
  });

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  TimeOfDay? _selectedTime;

  // Assign TimeOfDay.now() to _selectedTime when init screen
  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
  }

  // Method to display clock and get time
  Future<void> pickTime() async {
    if (!mounted) return;

    final userPicked = await showTimePicker(
      context: context,
      initialTime: _selectedTime!,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,

              // AM/PM UI
              dayPeriodShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: Colors.blueAccent),
              ),
              dayPeriodColor: MaterialStateColor.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? Colors.blueAccent
                    : Colors.grey.shade200,
              ),
              dayPeriodTextColor: MaterialStateColor.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? Colors.white
                    : Colors.black87,
              ),

              // Hour and Minute UI
              hourMinuteColor: MaterialStateColor.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? Colors.blue.shade50
                    : Colors.grey.shade100,
              ),
              hourMinuteShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: Colors.blueAccent, width: 1),
              ),

              // Mode keyboard
              entryModeIconColor: Colors.blueAccent,
              helpTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            colorScheme: ColorScheme.light(
              primary: Colors.blueAccent, // Màu chính của picker
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
            ),
          ),

          // Take enviroment information and display it
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
    );

    // Update time when user choose into _selectedTime
    if (userPicked != null && userPicked != _selectedTime) {
      setState(() {
        _selectedTime = userPicked;
      });

      // Call to parent widget, to refesh UI
      widget.onTimeSelected(userPicked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.readOnly ? null : pickTime,
      child: InputDecorator(
        decoration: InputDecoration(
          // Label
          label: RichText(
            text: TextSpan(
              text: widget.label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 25),
              children: const [
                TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          prefixIcon: Icon(widget.icon, color: widget.color),
          suffixIcon: const Icon(Icons.access_time),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1.5),
          ),
        ),

        // Text time
        child: Text(
          _selectedTime!.format(context),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
