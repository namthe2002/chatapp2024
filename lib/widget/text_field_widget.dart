import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import '../utils/utils.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {Key? key,
      required this.controller,
      this.textInputAction = TextInputAction.next,
      this.isEnable = true,
      this.autoFocus = false,
      this.onChanged,
      this.isPassword = false,
      this.icon,
      this.errorText,
      this.labelText,
      this.hintText,
      this.inputFormatters,
      this.maxLines,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.readOnly = false,
      this.onTap,
      this.fillColor,
      this.onSubmitted,
      this.maxLength,
      this.isCounterText = false,
      this.fillBackground = false,
      this.suffixIcon,
      this.onPressDelete,
      this.titleText,
      this.require = false,
      this.borderColor})
      : super(key: key);

  final TextEditingController controller;
  final bool isEnable;
  final bool autoFocus;
  final bool require;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final FormFieldSetter<String>? onChanged;
  final bool isPassword;
  final String? titleText;
  final String? errorText;
  final String? labelText;
  final String? hintText;
  final int? maxLines;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final FormFieldSetter<String>? onSubmitted;
  final dynamic icon;
  final bool readOnly;
  final Function()? onTap;
  final Color? fillColor;
  final Color? borderColor;
  final int? maxLength;
  final bool fillBackground;
  final bool? isCounterText;
  final String? suffixIcon;
  final VoidCallback? onPressDelete;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool _obscureText;
  bool _reachMaxLength = false;
  final Debouncer _debouncer =
      Debouncer<String>(Duration(milliseconds: 400), initialValue: '');

  @override
  void initState() {
    super.initState();
    if (widget.maxLength != null) {
      _reachMaxLength = widget.controller.text.length >= widget.maxLength!;
    }
    _obscureText = widget.isPassword;
    _debouncer.values.listen((value) {
      widget.onChanged?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: !Utils.isEmpty(widget.titleText),
            child: Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: RichText(
                text: TextSpan(
                    text: widget.titleText ?? "",
                    // style: Theme.of(context).textTheme.bodyMdStyle,
                    children: widget.require
                        ? <TextSpan>[
                            TextSpan(
                              text: " *",
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .body2Bold
                              //     .copyWith(color: R.color.red, height: 1),
                            ),
                          ]
                        : []),
              ),
            )),
        TextField(
          enabled: widget.isEnable,
          autofocus: widget.autoFocus,
          focusNode: widget.focusNode,
          controller: widget.controller,
          obscureText: _obscureText,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          decoration: InputDecoration(
            counterText: widget.isCounterText! ? null : '',
            filled: widget.fillBackground,
            // filled: true,
            fillColor: widget.fillColor ??
                (widget.isEnable
                    ? ColorValue.colorPrimary
                    : ColorValue.colorTextDark),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                  width: 1, color: widget.borderColor ?? ColorValue.colorYl),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                  width: 1, color: widget.borderColor ?? ColorValue.colorYl),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                  width: 1, color: widget.borderColor ?? ColorValue.colorYl),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                  width: 1, color: widget.borderColor ?? ColorValue.colorYl),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                  width: 1, color: widget.borderColor ?? ColorValue.colorYl),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                  width: 1, color: widget.borderColor ?? ColorValue.colorYl),
            ),
            contentPadding:
                EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
            hintText: widget.hintText,
            errorText: widget.errorText,
            errorMaxLines: 1000,
            labelText: widget.labelText,
            prefixIcon: widget.icon == null
                ? null
                : (widget.icon is String
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          widget.icon,
                          fit: BoxFit.fitHeight,
                          height: 20,
                          width: 20,
                          color: ColorValue.neutralColor,
                        ),
                      )
                    : Icon(
                        widget.icon,
                        size: 20,
                      )),
            suffixIcon: widget.readOnly == true
                ? null
                : (widget.isPassword || widget.suffixIcon != null
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.onPressDelete != null) {
                              widget.controller.clear();
                              widget.onPressDelete?.call();
                              return;
                            }
                            if (widget.isPassword) {
                              _obscureText = !_obscureText;
                              return;
                            }
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 12, bottom: 12, left: 10, right: 16),
                          child: SvgPicture.asset(
                            (!Utils.isEmpty(widget.controller.text) &&
                                    widget.onPressDelete != null)
                                ? 'asset/icons/delete.svg'
                                : (widget.suffixIcon != null
                                    ? (widget.suffixIcon ??
                                        'asset/icons/hidden.svg')
                                    : _obscureText
                                        ? 'asset/icons/hidden.svg'
                                        : 'asset/icons/eye_login.svg'),
                            height: 24,
                            width: 24,
                          ),
                        ),
                      )
                    : (Utils.isEmpty(widget.controller.text)
                        ? null
                        : GestureDetector(
                            onTap: () {
                              widget.controller.clear();
                              widget.onChanged?.call("");
                              setState(() {});
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 12, bottom: 12, left: 10, right: 16),
                              child: SvgPicture.asset(
                                'asset/icons/delete.svgs',
                                height: 24,
                                width: 24,
                                color: ColorValue.neutralColor,
                              ),
                            ),
                          ))),
            suffixIconConstraints: BoxConstraints(
              minHeight: 18.5.h,
              minWidth: 18.5.w,
            ),
            // labelStyle: Theme.of(context).textTheme.textRegular.copyWith(
            //     color: widget.isEnable ? R.color.black : R.color.gray, height: 1),
            // hintStyle: Theme.of(context).textTheme.subTitle.copyWith(
            //     color: R.color.arrowRightColor, height: 1
            // ),
            // helperStyle: Theme.of(context).textTheme.textRegular.copyWith(
            //   color: R.color.lightGray,
            // ),
            // counterStyle: Theme.of(context).textTheme.textRegular.copyWith(
            //   color: _reachMaxLength ? R.color.red : R.color.lightGray,
            // ),
            // errorStyle: Theme.of(context).textTheme.textRegular.copyWith(
            //   color: R.color.red,
            // )
          ),
          keyboardType: widget.keyboardType,
          onChanged: (value) {
            setState(() {
              if (widget.maxLength != null) {
                _reachMaxLength = value.length >= widget.maxLength!;
              }
              _debouncer.value = value;
            });
          },
          onSubmitted: widget.onSubmitted,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          // style: Theme.of(context).textTheme.bodyMdStyle,

          // widget.fillBackground
          //     ? Theme.of(context).textTheme.subTitleRegular.copyWith(
          //           color: widget.isEnable ? R.color.black : R.color.dark5,
          //         )
          //     : Theme.of(context).textTheme.subTitleRegular.copyWith(
          //           color: widget.isEnable ? R.color.black : R.color.dark5,
          //         ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _debouncer.cancel();
    super.dispose();
  }
}
