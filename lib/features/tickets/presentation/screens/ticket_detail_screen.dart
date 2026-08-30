import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/helpers/appbar_helper.dart';
import '../../../../app/helpers/dialog_helper.dart';
import '../../../../app/screens/main_screen_theme.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/utils/extensions/failure_extensions.dart';
import '../../../../injection_container.dart';
import '../cubit/ticket_detail_cubit.dart';
import '../widgets/reply_bubble.dart';
import '../widgets/ticket_chat_composer.dart';
import '../widgets/ticket_detail_header.dart';
import '../widgets/ticket_detail_skeleton.dart';
import '../widgets/ticket_replies_empty_state.dart';

class TicketDetailScreen extends StatefulWidget {
  final String ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final _replyController = TextEditingController();
  File? _attachment;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _attachment = File(file.path));
    }
  }

  void _removeAttachment() {
    setState(() => _attachment = null);
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String subject) {
    return AppBarHelper.build(
      context,
      backgroundColor: context.colors.surface,
      surfaceTintColor: context.colors.surface,
      centerTitle: false,
      iconBackColor: context.colors.onSurface,
      titleWidget: Text(
        subject,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.titleMedium(context, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TicketDetailCubit>(param1: widget.ticketId)..init(),
      child: BlocConsumer<TicketDetailCubit, TicketDetailState>(
        listener: (context, state) {
          if (state is TicketDetailFailure) {
            state.failure.showToast(context);
          }
          if (state is TicketDetailLoaded && state.conflictTicket != null) {
            DialogHelper.showWarningDialog(
              context: context,
              msg: state.conflictMessage ?? context.translate('version_conflict'),
              onClickYes: () {
                Navigator.pop(context);
                context.read<TicketDetailCubit>().applyConflictTicket();
              },
            );
          }
        },
        builder: (context, state) {
          if (state is TicketDetailLoading) {
            return MainScreenTheme(
              appBar: AppBarHelper.build(
                context,
                backgroundColor: context.colors.surface,
                surfaceTintColor: context.colors.surface,
                centerTitle: false,
                iconBackColor: context.colors.onSurface,
                titleWidget: const SizedBox.shrink(),
              ),
              child: const TicketDetailSkeleton(),
            );
          }

          if (state is! TicketDetailLoaded) {
            return MainScreenTheme(child: const SizedBox.shrink());
          }

          final ticket = state.ticket;
          final cubit = context.read<TicketDetailCubit>();

          return MainScreenTheme(
            appBar: _buildAppBar(context, ticket.subject),
            child: Column(
              children: [
                TicketDetailHeader(
                  ticket: ticket,
                  isSubmitting: state.isSubmitting,
                  onStatusChanged: (value) => cubit.updateStatus(value),
                  onPriorityChanged: (value) => cubit.updatePriority(value),
                  onClaim: () => cubit.claim(),
                ),
                Expanded(
                  child: ticket.replies.isEmpty
                      ? const TicketRepliesEmptyState()
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          itemCount: ticket.replies.length,
                          itemBuilder: (context, index) {
                            return ReplyBubble(reply: ticket.replies[index]);
                          },
                        ),
                ),
                TicketChatComposer(
                  controller: _replyController,
                  attachment: _attachment,
                  isSubmitting: state.isSubmitting,
                  onPickAttachment: _pickAttachment,
                  onRemoveAttachment: _removeAttachment,
                  onSend: () {
                    cubit.sendReply(
                      _replyController.text,
                      attachment: _attachment,
                    );
                    _replyController.clear();
                    setState(() => _attachment = null);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
