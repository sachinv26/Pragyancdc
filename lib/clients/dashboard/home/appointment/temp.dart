// Row(
// children: [
// ElevatedButton(
// style: ElevatedButton.styleFrom(
// // backgroundColor: Colors.green, // Background color (constant)
// minimumSize:
// const Size(100, 40), // Width and height of the button
// ),
// onPressed: () {
// showDialog(
// context: context,
// builder: (context) {
// return AlertDialog(
// title: const Text(
// 'Schedule for:',
// //style: kTextStyle1, // Assuming you have defined kTextStyle1 somewhere
// ),
// content: SizedBox(
// width: double.infinity,
// child: Column(
// mainAxisSize: MainAxisSize.min,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// RadioListTile<String>(
// title: const Text('Arun'),
// value: 'Arun',
// groupValue: _selectedChild,
// onChanged: (value) {
// setState(() {
// _selectedChild = value!;
// });
// },
// ),
// RadioListTile<String>(
// title: const Text('Amit'),
// value: 'Amit',
// groupValue: _selectedChild,
// onChanged: (value) {
// setState(() {
// _selectedChild = value!;
// });
// },
// ),
// ],
// ),
// ),
// actions: [
// TextButton(
// onPressed: () {
// Navigator.pop(context);
// },
// child: const Text('Cancel'),
// ),
// ElevatedButton(
// onPressed: () {
// Navigator.pop(context);
// Navigator.of(context).push(MaterialPageRoute(
// builder: (context) {
// return const ScheduleAppointment();
// },
// ));
// // Handle schedule button press here
// // print('Schedule clicked with options:');
// // print('Selected Child: $_selectedChild');
// },
// child: const Text('Done'),
// ),
// ],
// );
// },
// );
// },
// child: const Text(
// 'Schedule Therapy',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// Spacer(),
// ElevatedButton(
// onPressed: () {
// showDialog(
// context: context,
// builder: (context) {
// return AlertDialog(
// title: const Text(
// 'Book Consultation for:',
// //style: kTextStyle1, // Assuming you have defined kTextStyle1 somewhere
// ),
// content: SizedBox(
// width: double.infinity,
// child: Column(
// mainAxisSize: MainAxisSize.min,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// RadioListTile<String>(
// title: const Text('Arun'),
// value: 'Arun',
// groupValue: _selectedChild,
// onChanged: (value) {
// setState(() {
// _selectedChild = value!;
// });
// },
// ),
// RadioListTile<String>(
// title: const Text('Amit'),
// value: 'Amit',
// groupValue: _selectedChild,
// onChanged: (value) {
// setState(() {
// _selectedChild = value!;
// });
// },
// ),
// ],
// ),
// ),
// actions: [
// TextButton(
// onPressed: () {
// Navigator.pop(context);
// },
// child: const Text('Cancel'),
// ),
// ElevatedButton(
// onPressed: () {
// Navigator.pop(context);
// Navigator.of(context).push(MaterialPageRoute(
// builder: (context) {
// return const ConsultationAppointment();
// },
// ));
// // Handle schedule button press here
// // print('Schedule clicked with options:');
// // print('Selected Child: $_selectedChild');
// },
// child: const Text('Done'),
// ),
// ],
// );
// },
// );
// },
// style: ElevatedButton.styleFrom(
// // backgroundColor: Colors.green, // Background color (constant)
// minimumSize:
// const Size(100, 40), // Width and height of the button
// ),
// child: const Text(
// 'Book Consultation',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// ],
// ),