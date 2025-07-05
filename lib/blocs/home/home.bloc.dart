import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/service.model.dart';
import 'home.event.dart';
import 'home.state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadServices>((event, emit) async {
      emit(HomeLoading());
      try {
        var box = await Hive.openBox<Service>('servicesBox');

        // Nếu box trống, ta thêm mẫu demo
        if (box.isEmpty) {
          await box.addAll([
            Service(
              name: "Cleaning",
              imagePath: "images/cleaning.png",
              price: 20,
              rating: 4.5,
              providerName: "Nguyễn Văn A",
            ),
            Service(
              name: "Painting",
              imagePath: "images/painting.png",
              price: 25,
              rating: 4.3,
              providerName: "Lê Thị B",
            ),
            Service(
              name: "Laundry",
              imagePath: "images/laundry.png",
              price: 15,
              rating: 4.7,
              providerName: "Trần Văn C",
            ),
            Service(
              name: "Repairing",
              imagePath: "images/repairing.png",
              price: 30,
              rating: 4.2,
              providerName: "Phạm Văn D",
            ),
          ]);
        }

        emit(HomeLoaded(box.values.toList()));
      } catch (e) {
        emit(HomeError("Lỗi khi tải dịch vụ: ${e.toString()}"));
      }
    });
  }
}
