 import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/home_cubit.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final mapCubit = BlocProvider.of<HomeCubit>(context);
        final size = MediaQuery.of(context).size;
        return Container(
          width: double.maxFinite,
          height: size.height * 0.12,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 2))
              ]),
          child: mapCubit.currentAddress != null &&
              state is! AddressLoading &&
              state is! HomeLoading
              ? Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
                horizontal: size.width * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address:',
                  style: TextStyle(
                      fontSize: size.height*0.027, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height * 0.009,
                ),
                Flexible(
                  child: AutoSizeText(
                    mapCubit.currentAddress!.displayName,
                    style: TextStyle(
                      fontSize: size.height*0.020,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

}


