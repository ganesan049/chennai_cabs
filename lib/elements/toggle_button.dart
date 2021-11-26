import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToggleButton extends StatefulWidget {

  const ToggleButton({required this.toggleStateChange});

  final ValueSetter<bool> toggleStateChange;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool off = true;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Use Reward points',
        style: GoogleFonts.ptSans(),
      ),
      trailing: InkWell(
        onTap: () {
          widget.toggleStateChange(off);
          setState(() => off = !off);
          if (off) {
            controller.reverse();
          } else {
            controller.forward();
          }
        },
        child: AnimatedContainer(
          height: 20,
          width: 40,
          duration: Duration(milliseconds: 100),
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: off ? Colors.grey : Colors.green,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0),
                  end: Offset(0.9, 0),
                ).animate(
                  CurvedAnimation(curve: Curves.easeIn, parent: controller),
                ),
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
