// import 'package:koompi_hotspot/all_export.dart';

// class CustomBottomSheet<T> extends StatelessWidget {
//   final List<DropdownMenuItem<T>>? dropdownMenuItemList;
//   final ValueChanged<T?>? onChanged;
//   final T? value;
//   final bool isEnabled;
//   const CustomBottomSheet({
//     Key? key,
//     @required this.dropdownMenuItemList,
//     @required this.onChanged,
//     @required this.value,
//     this.isEnabled = true,
//   }) : super(key: key);
//   @override

  
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       ignoring: !isEnabled,
//       child: Container(
//         padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//         decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//             border: Border.all(
//               color: primaryColor,
//               width: 1,
//             ),
//             color: isEnabled ? Colors.white : Colors.grey.withAlpha(100)),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton(
//             isExpanded: true,
//             itemHeight: 50.0,
//             style: TextStyle(
//                 fontSize: 15.0,
//                 color: isEnabled ? Colors.black : Colors.grey[700]),
//             items: dropdownMenuItemList,
//             onChanged: onChanged,
//             value: value,
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget customSwapWidget(List<String> items, String value, void Function(String? val) onChange){
//   return Container(
//     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//     decoration: BoxDecoration(
//       borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//       border: Border.all(
//         color: primaryColor,
//         width: 1,
//       ),
//     ),
//     child: DropdownButtonHideUnderline(
//       child: DropdownButton(
//         isExpanded: true,
//         itemHeight: 50.0,
//         style: const TextStyle(
//             fontSize: 15.0,
//             color: Colors.black,
//         ),
//         items: items.map<DropdownMenuItem<String>>((String val) {
//           return DropdownMenuItem(
//             value: val,
//             child: Text(val),
//           );
//         }).toList(),
//         onChanged: (String? val){
//           onChange(val);
//         },
//         value: value,
//       ),
//     ),
//   );
// }