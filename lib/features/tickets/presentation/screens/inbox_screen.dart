import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../app/screens/main_screen_theme.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/utils/extensions/failure_extensions.dart';
import '../../../../app/widgets/app_refresh_widget.dart';
import '../../../../app/widgets/app_text_field.dart';
import '../../../../injection_container.dart';
import '../cubit/inbox_cubit.dart';
import 'ticket_detail_screen.dart';

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
            appBar: AppBar(
              title: Text(context.translate('inbox')),
              backgroundColor: context.colors.surface,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: AppTextField(
                    controller: _searchController,
                    hintText: context.translate('search'),
                    onChanged: (value) =>
                        context.read<InboxCubit>().search(value),
                  ),
                ),
                _FiltersBar(state: state),
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
      return const Center(child: CircularProgressIndicator());
    }

    if (state is InboxLoaded) {
      if (state.tickets.isEmpty) {
        return Center(child: Text(context.translate('no_tickets')));
      }

      return AppRefreshWidget(
        refreshController: _refreshController,
        enablePullUp: state.nextCursor != null,
        onRefresh: () => context.read<InboxCubit>().loadTickets(refresh: true),
        onLoading: () => context.read<InboxCubit>().loadMore(),
        child: ListView.builder(
          itemCount: state.tickets.length,
          itemBuilder: (context, index) {
            final ticket = state.tickets[index];
            return ListTile(
              title: Text(ticket.subject, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text('${ticket.customer} · ${ticket.status} · ${ticket.priority}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TicketDetailScreen(ticketId: ticket.id),
                  ),
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

class _FiltersBar extends StatelessWidget {
  final InboxState state;

  const _FiltersBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final loaded = state is InboxLoaded ? state as InboxLoaded : null;
    final cubit = context.read<InboxCubit>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          FilterChip(
            label: Text(context.translate('all')),
            selected: loaded?.statusFilter == null,
            onSelected: (_) => cubit.setStatusFilter(null),
          ),
          SizedBox(width: 8.w),
          for (final status in ['open', 'pending', 'solved'])
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: FilterChip(
                label: Text(context.translate(status)),
                selected: loaded?.statusFilter == status,
                onSelected: (_) => cubit.setStatusFilter(status),
              ),
            ),
          FilterChip(
            label: Text(context.translate('my_tickets')),
            selected: loaded?.myTicketsOnly ?? false,
            onSelected: (v) => cubit.toggleMyTickets(v),
          ),
        ],
      ),
    );
  }
}
