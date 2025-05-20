// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payslips.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PayslipItemAdapter extends TypeAdapter<PayslipItem> {
  @override
  final int typeId = 1;

  @override
  PayslipItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PayslipItem(
      description: fields[0] as String,
      amount: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PayslipItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayslipItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PayslipAdapter extends TypeAdapter<Payslip> {
  @override
  final int typeId = 0;

  @override
  Payslip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Payslip(
      id: fields[0] as String,
      name: fields[1] as String,
      employeeName: fields[2] as String,
      employeeId: fields[3] as String,
      dateFrom: fields[4] as String,
      dateTo: fields[5] as String,
      status: fields[6] as String,
      grossEarnings: fields[7] as double,
      totalDeductions: fields[8] as double,
      netSalary: fields[9] as double,
      earnings: (fields[10] as List).cast<PayslipItem>(),
      deductions: (fields[11] as List).cast<PayslipItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, Payslip obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.employeeName)
      ..writeByte(3)
      ..write(obj.employeeId)
      ..writeByte(4)
      ..write(obj.dateFrom)
      ..writeByte(5)
      ..write(obj.dateTo)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.grossEarnings)
      ..writeByte(8)
      ..write(obj.totalDeductions)
      ..writeByte(9)
      ..write(obj.netSalary)
      ..writeByte(10)
      ..write(obj.earnings)
      ..writeByte(11)
      ..write(obj.deductions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayslipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
