// lib/data/mock_data.dart

import '../../constants/payslips_app_constants.dart'; // Import constants

// Renamed to be public for access from PayslipPage
final List<Map<String, dynamic>> mockPayslipData = [
  {
    'id': 'payslip_jan_it',
    'name': 'Salary Slip of Anshul Sharma for January-2025',
    'employeeName': 'Anshul Sharma',
    'employeeId': 'EMP0023',
    'dateFrom': '01/01/2025',
    'dateTo': '01/31/2025',
    'status': kStatusDone,
    'grossEarnings': 50000,
    'totalDeductions': 8000,
    'netSalary': 42000,
    'earnings': [
      {'description': 'Basic Salary', 'amount': 35000},
      {'description': 'House Rent Allowance (HRA)', 'amount': 10000},
      {'description': 'Performance Bonus', 'amount': 5000},
    ],
    'deductions': [
      {'description': 'Income Tax (TDS)', 'amount': 6000},
      {'description': 'Provident Fund (PF)', 'amount': 2000},
    ],
  },
  {
    'id': 'payslip_feb_it',
    'name': 'Salary Slip of Anshul Sharma for February-2025',
    'employeeName': 'Anshul Sharma',
    'employeeId': 'EMP023',
    'dateFrom': '02/01/2025',
    'dateTo': '02/28/2025',
    'status': kStatusDone,
    'grossEarnings': 50000,
    'totalDeductions': 8000,
    'netSalary': 42000,
    'earnings': [
      {'description': 'Basic Salary', 'amount': 35000},
      {'description': 'House Rent Allowance (HRA)', 'amount': 10000},
      {'description': 'Travel Allowance', 'amount': 4000},
      {'description': 'Special Allowance', 'amount': 1000},
    ],
    'deductions': [
      {'description': 'Income Tax (TDS)', 'amount': 6000},
      {'description': 'Provident Fund (PF)', 'amount': 2000},
    ],
  },
  {
    'id': 'payslip_mar_it',
    'name': 'Salary Slip of Anshul Sharma Dept for March-2025',
    'employeeName': 'Anshul Sharma',
    'employeeId': 'EMP023',
    'dateFrom': '03/01/2025',
    'dateTo': '03/31/2025',
    'status': kStatusWaiting,
    'grossEarnings': null,
    'totalDeductions': null,
    'netSalary': null,
    'earnings': [],
    'deductions': [],
  },
];
