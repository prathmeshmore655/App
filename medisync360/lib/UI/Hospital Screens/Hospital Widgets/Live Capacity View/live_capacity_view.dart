import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Repositories/hospital_repository.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Live%20Capacity%20View/live_capacity_view_bloc.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Live%20Capacity%20View/live_capacity_view_card.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Live%20Capacity%20View/live_capacity_view_state.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Live%20Capacity%20View/live_capcity_view_event.dart';

class HospitalCapacityScreen extends StatelessWidget {
  const HospitalCapacityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HospitalCapacityBloc(HospitalRepository())..add(FetchHospitals()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Live Hospital Capacity'),
          backgroundColor: Colors.blueAccent,
        ),
        body: BlocBuilder<HospitalCapacityBloc, HospitalCapacityState>(
          builder: (context, state) {
            if (state is HospitalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HospitalLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HospitalCapacityBloc>().add(FetchHospitals());
                },
                child: ListView.builder(
                  itemCount: state.hospitals.length,
                  itemBuilder: (context, index) {
                    return HospitalCard(hospital: state.hospitals[index]);
                  },
                ),
              );
            } else if (state is HospitalError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
