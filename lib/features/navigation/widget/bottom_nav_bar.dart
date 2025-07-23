import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_view_model.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_event.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_state.dart';

class MainBottomNavBar extends StatelessWidget {
  final Color activeColor;

  const MainBottomNavBar({super.key, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardViewModel, DashboardState>(
      builder: (context, state) {
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(state.screens.length, (index) {
                final icons = [
                  Icons.receipt_long,
                  Icons.bar_chart,
                  Icons.account_balance_wallet,
                  Icons.more_horiz,
                ];
                return IconButton(
                  icon: Icon(
                    icons[index],
                    color: state.selectedIndex == index
                        ? activeColor
                        : Colors.black54,
                  ),
                  onPressed: () {
                    context.read<DashboardViewModel>().add(
                          ChangeTabEvent(index),
                        );
                  },
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
