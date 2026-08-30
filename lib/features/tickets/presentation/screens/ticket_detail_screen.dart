import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/helpers/dialog_helper.dart';
import '../../../../app/screens/main_screen_theme.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/utils/extensions/failure_extensions.dart';
import '../../../../app/widgets/app_button.dart';
import '../../../../app/widgets/app_text_field.dart';
import '../../../../injection_container.dart';
import '../cubit/ticket_detail_cubit.dart';

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
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is! TicketDetailLoaded) {
            return MainScreenTheme(child: const SizedBox.shrink());
          }

          final ticket = state.ticket;
          final cubit = context.read<TicketDetailCubit>();

          return MainScreenTheme(
            appBar: AppBar(
              title: Text(ticket.subject, maxLines: 1, overflow: TextOverflow.ellipsis),
              backgroundColor: context.colors.surface,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16.w),
                    children: [
                      Text(ticket.customer, style: context.theme.textTheme.titleMedium),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _StatusDropdown(
                            value: ticket.status,
                            onChanged: state.isSubmitting
                                ? null
                                : (v) => cubit.updateStatus(v!),
                          ),
                          SizedBox(width: 8.w),
                          _PriorityDropdown(
                            value: ticket.priority,
                            onChanged: state.isSubmitting
                                ? null
                                : (v) => cubit.updatePriority(v!),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      if (ticket.assigneeId == null)
                        AppButton(
                          text: context.translate('claim'),
                          isLoading: state.isSubmitting,
                          onClickEvent:
                              state.isSubmitting ? null : () => cubit.claim(),
                        ),
                      SizedBox(height: 16.h),
                      ...ticket.replies.map(
                        (reply) => Card(
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reply.authorName,
                                    style: context.theme.textTheme.labelLarge),
                                SizedBox(height: 4.h),
                                Text(reply.body),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    children: [
                      if (_attachment != null)
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(_attachment!.path.split('/').last),
                        ),
                      AppTextField(
                        controller: _replyController,
                        hintText: context.translate('write_reply'),
                        maxLines: 3,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _pickAttachment,
                            icon: const Icon(Icons.attach_file),
                          ),
                          Expanded(
                            child: AppButton(
                              text: context.translate('send'),
                              isLoading: state.isSubmitting,
                              onClickEvent: state.isSubmitting
                                  ? null
                                  : () {
                                      cubit.sendReply(
                                        _replyController.text,
                                        attachment: _attachment,
                                      );
                                      _replyController.clear();
                                      setState(() => _attachment = null);
                                    },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?>? onChanged;

  const _StatusDropdown({required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: ['open', 'pending', 'solved']
          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
          .toList(),
    );
  }
}

class _PriorityDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?>? onChanged;

  const _PriorityDropdown({required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: ['low', 'normal', 'high', 'urgent']
          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
          .toList(),
    );
  }
}
