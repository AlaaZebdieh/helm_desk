import 'package:get_it/get_it.dart';
import 'data/datasources/tickets_remote_data_source.dart';
import 'data/repositories/tickets_repository_impl.dart';
import 'domain/repositories/tickets_repository.dart';
import 'domain/usecases/add_reply_usecase.dart';
import 'domain/usecases/claim_ticket_usecase.dart';
import 'domain/usecases/get_ticket_usecase.dart';
import 'domain/usecases/get_tickets_usecase.dart';
import 'domain/usecases/update_ticket_usecase.dart';
import 'domain/usecases/upload_attachment_usecase.dart';
import 'presentation/cubit/inbox_cubit.dart';
import 'presentation/cubit/ticket_detail_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory<InboxCubit>(
    () => InboxCubit(
      getTicketsUsecase: sl(),
      sseService: sl(),
    ),
  );

  sl.registerFactoryParam<TicketDetailCubit, String, void>(
    (ticketId, _) => TicketDetailCubit(
      ticketId: ticketId,
      getTicketUsecase: sl(),
      updateTicketUsecase: sl(),
      claimTicketUsecase: sl(),
      addReplyUsecase: sl(),
      uploadAttachmentUsecase: sl(),
      sseService: sl(),
    ),
  );

  sl.registerLazySingleton<GetTicketsUsecase>(
    () => GetTicketsUsecase(repository: sl()),
  );
  sl.registerLazySingleton<GetTicketUsecase>(
    () => GetTicketUsecase(repository: sl()),
  );
  sl.registerLazySingleton<UpdateTicketUsecase>(
    () => UpdateTicketUsecase(repository: sl()),
  );
  sl.registerLazySingleton<ClaimTicketUsecase>(
    () => ClaimTicketUsecase(repository: sl()),
  );
  sl.registerLazySingleton<AddReplyUsecase>(
    () => AddReplyUsecase(repository: sl()),
  );
  sl.registerLazySingleton<UploadAttachmentUsecase>(
    () => UploadAttachmentUsecase(repository: sl()),
  );

  sl.registerLazySingleton<TicketsRepository>(
    () => TicketsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<TicketsRemoteDataSource>(
    () => TicketsRemoteDataSourceImpl(apiClient: sl()),
  );
}
