import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../app/helpers/appbar_helper.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/screens/main_screen_theme.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/utils/extensions/failure_extensions.dart';
import '../../../../app/widgets/app_button.dart';
import '../../../../app/widgets/app_refresh_widget.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/helpers/logout_helper.dart';
import '../cubit/inbox_cubit.dart';
import '../widgets/inbox_empty_state.dart';
import '../widgets/inbox_filters_bar.dart';
import '../widgets/inbox_search_field.dart';
import '../widgets/inbox_ticket_skeleton.dart';
import '../widgets/ticket_card.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final _refreshController = RefreshController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, InboxState state) {
    final customColors = context.customColors;
    final InboxLoaded? loaded = switch (state) {
      InboxLoaded loaded => loaded,
      _ => null,
    };

    return AppBarHelper.build(
      context,
      backgroundColor: context.colors.surface,
      surfaceTintColor: context.colors.surface,
      centerTitle: false,
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('inbox'),
            style: AppTextStyles.titleMedium(context, fontSize: 18),
          ),
          if (loaded != null)
            Text(
              context.translate(
                'tickets_total',
                arguments: {'count': '${loaded.total}'},
              ),
              style: AppTextStyles.bodyMedium(
                context,
                fontSize: 12,
                color: customColors.textSecondary,
              ),
            ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12.w, top: 8.h, bottom: 8.h),
          child: AppButton(
            text: context.translate('logout'),
            height: 36,
            radius: 8,
            textStyle: AppTextStyles.button(context, color: context.colors.primary),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            onClickEvent: () => LogoutHelper.logout(context),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InboxCubit>()..init(),
      child: BlocConsumer<InboxCubit, InboxState>(
        listener: (context, state) {
          if (state is InboxFailure) {
            state.failure.showToast(context);
          }
          if (state is InboxLoaded && !state.isLoadingMore) {
            _refreshController.refreshCompleted();
            _refreshController.loadComplete();
          }
        },
        builder: (context, state) {
          return MainScreenTheme(
            appBar: _buildAppBar(context, state),
            child: Column(
              children: [
                InboxSearchField(
                  controller: _searchController,
                  onChanged: (value) =>
                      context.read<InboxCubit>().search(value),
                ),
                InboxFiltersBar(state: state),
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, InboxState state) {
    if (state is InboxLoading) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
        itemCount: 7,
        itemBuilder: (_, __) => const InboxTicketSkeleton(),
      );
    }

    if (state is InboxLoaded) {
      if (state.tickets.isEmpty) {
        return const InboxEmptyState();
      }

      return AppRefreshWidget(
        refreshController: _refreshController,
        enablePullUp: state.nextCursor != null,
        onRefresh: () => context.read<InboxCubit>().loadTickets(refresh: true),
        onLoading: () => context.read<InboxCubit>().loadMore(),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
          itemCount: state.tickets.length,
          itemBuilder: (context, index) {
            final ticket = state.tickets[index];
            return TicketCard(
              ticket: ticket,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.ticketDetailRoute,
                  arguments: ticket.id,
                );
              },
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
