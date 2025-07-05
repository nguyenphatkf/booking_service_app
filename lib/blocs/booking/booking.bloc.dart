import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/booking.model.dart';
//import '../../models/service.model.dart';
import 'booking.event.dart';
import 'booking.state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<SubmitBookingWithDetails>((event, emit) async {
      emit(BookingLoading());
      try {
        final sessionBox = await Hive.openBox('sessionBox');
        final userId = sessionBox.get('currentUserId');

        if (userId == null) throw Exception("Không tìm thấy người dùng!");

        final booking = Booking(
          userId: userId,
          service: event.service,
          date: event.date,
          hour: event.time.hour,
          minute: event.time.minute,
          location: event.location,
          userCount: event.userCount,
        );

        final bookingsBox = await Hive.openBox<Booking>('bookingsBox');
        await bookingsBox.add(booking);

        emit(BookingSuccess());
      } catch (e) {
        emit(BookingFailure("Không thể đặt dịch vụ: ${e.toString()}"));
      }
    });
  }
}
