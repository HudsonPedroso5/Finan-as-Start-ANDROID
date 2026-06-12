import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/model/payment.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentFormScreen extends StatefulWidget {
  final PaymentType type;
  final Payment? payment;

  const PaymentFormScreen({super.key, required this.type, this.payment});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late PaymentType _type;
  late int _accountId;
  late int _categoryId;
  late DateTime _datetime;

  @override
  void initState() {
    super.initState();
    final payment = widget.payment;
    final cubit = context.read<AppCubit>();
    _titleController = TextEditingController(text: payment?.title ?? '');
    _descriptionController = TextEditingController(text: payment?.description ?? '');
    _amountController = TextEditingController(text: payment?.amount.toString() ?? '');
    _type = payment?.type ?? widget.type;
    _datetime = payment?.datetime ?? DateTime.now();
    _accountId = payment?.accountId ?? cubit.state.accounts.first.id;
    _categoryId = payment?.categoryId ?? cubit.state.categories.first.id;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _datetime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _datetime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _datetime.hour,
          _datetime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_datetime),
    );
    if (picked != null) {
      setState(() {
        _datetime = DateTime(
          _datetime.year,
          _datetime.month,
          _datetime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AppCubit>();
    final accounts = cubit.state.accounts;
    final categories = cubit.state.categories;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.payment == null ? 'New payment' : 'Edit payment'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SegmentedButton<PaymentType>(
                segments: const [
                  ButtonSegment(value: PaymentType.debit, label: Text('Expense'), icon: Icon(Icons.remove)),
                  ButtonSegment(value: PaymentType.credit, label: Text('Income'), icon: Icon(Icons.add)),
                ],
                selected: {_type},
                onSelectionChanged: (set) => setState(() => _type = set.first),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _accountId,
                decoration: const InputDecoration(labelText: 'Account', border: OutlineInputBorder()),
                items: accounts
                    .map((account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(account.name),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _accountId = value ?? _accountId),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _categoryId,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _categoryId = value ?? _categoryId),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.date_range),
                      label: Text('${_datetime.day.toString().padLeft(2, '0')}/${_datetime.month.toString().padLeft(2, '0')}/${_datetime.year}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickTime,
                      icon: const Icon(Icons.schedule),
                      label: Text('${_datetime.hour.toString().padLeft(2, '0')}:${_datetime.minute.toString().padLeft(2, '0')}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
                  if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
                    return;
                  }
                  cubit.upsertPayment(
                    id: widget.payment?.id,
                    accountId: _accountId,
                    categoryId: _categoryId,
                    amount: amount,
                    type: _type,
                    datetime: _datetime,
                    title: _titleController.text,
                    description: _descriptionController.text,
                  );
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
