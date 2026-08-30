import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/widgets/app_icon_button.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/reply_attachment.dart';
import '../helpers/reply_attachment_opener.dart';

class ReplyAttachmentButton extends StatelessWidget {
  final ReplyAttachment attachment;
  final bool isMine;

  const ReplyAttachmentButton({
    super.key,
    required this.attachment,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;

    return AppIconButton(
      onClickEvent: () => sl<ReplyAttachmentOpener>().open(context, attachment),
      shape: BoxShape.circle,
      backgroundColor: isMine
          ? customColors.primarySoft.withValues(alpha: 0.1)
          : customColors.secondarySoft.withValues(alpha: 0.3),
      padding: EdgeInsets.all(3.r),
      margin: EdgeInsetsDirectional.only(
        start: isMine ? 0 : 8.w,
        end: isMine ? 8.w : 0,
      ),
      widget: Icon(
        Icons.attach_file,
        size: 18.r,
        color: isMine ? colors.primary : colors.secondary,
      ),
    );
  }
}
