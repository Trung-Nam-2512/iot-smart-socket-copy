import 'dart:async';
import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:doaniot/features/device/domain/entities/device.dart';
import 'package:doaniot/features/device/data/repositories/device_repository_impl.dart';
import 'package:doaniot/features/device/domain/repositories/device_repository.dart';

class ConnectDeviceScreen extends StatefulWidget {
  final Device device;
  final String? wifiSsid;
  final String? wifiPassword;

  const ConnectDeviceScreen({
      super.key, 
      required this.device,
      this.wifiSsid,
      this.wifiPassword,
  });

  @override
  State<ConnectDeviceScreen> createState() => _ConnectDeviceScreenState();
}

class _ConnectDeviceScreenState extends State<ConnectDeviceScreen> {
  int _connectionStep = 0; // 0: Initial, 1: Connecting, 2: Connected
  int _progress = 0;
  Timer? _timer;
  final DeviceRepository _deviceRepository = DeviceRepositoryImpl();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startConnection() async {
    setState(() {
      _connectionStep = 1;
      _progress = 0;
    });

    // Simulate progress while "connecting"
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_progress < 90) {
          _progress++;
        }
      });
    });

    try {
      // Backend Friend: This is where we attempt valid connection using credentials
      await _deviceRepository.addDevice(
          widget.device, 
          wifiSsid: widget.wifiSsid, 
          wifiPassword: widget.wifiPassword
      );

      _timer?.cancel();
      setState(() {
        _progress = 100;
        _connectionStep = 2;
      });
    } catch (e) {
      _timer?.cancel();
      setState(() {
        _connectionStep = 0; // Reset or show error
        _progress = 0;
      });
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection Failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _connectionStep == 2
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Add Device',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            if (_connectionStep == 2) ...[
              const Spacer(flex: 10),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              const Text(
                'Connected!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You have connected to ${widget.device.name}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(flex: 1),
            ] else ...[
              const Text(
                'Connect to device',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInstructionChip(
                    Icons.wifi,
                    "Turn on your Wifi & Bluetooth to connect",
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.device.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],

            const Spacer(flex: 3),

            // Device Image & Progress
            Stack(
              alignment: Alignment.center,
              children: [
                if (_connectionStep == 1)
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: CircularProgressIndicator(
                      value: _progress / 100,
                      strokeWidth: 8,
                      color: AppColors.primary,
                      backgroundColor: AppColors.lightGrey,
                    ),
                  ),
                SizedBox(
                  width: 250, 
                  height: 250, 
                  child: Image.asset(widget.device.imageUrl, fit: BoxFit.contain)
                ),
              ],
            ),
            if (_connectionStep == 2) const SizedBox.shrink(),

            const Spacer(flex: 3),

            if (_connectionStep == 1) ...[
              const Text(
                'Connecting...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              Text(
                '$_progress%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],

            const Spacer(flex: 8),

            // Bottom Buttons
            if (_connectionStep == 0)
              SizedBox(
                width: 200, // Shortened button width
                child: ElevatedButton(
                  onPressed: _startConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Connect', style: TextStyle(fontSize: 16)),
                ),
              ),

            if (_connectionStep == 1)
              const SizedBox(height: 56), // Placeholder to keep layout stable

            if (_connectionStep == 2)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Return the device to the previous screen (AddDeviceScreen)
                        Navigator.pop(context, widget.device);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Go to Homepage',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Return the device to the previous screen
                        Navigator.pop(context, widget.device);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Control Device',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),

            if (_connectionStep != 2) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Column(
                  children: [
                    Text(
                      "Can't connect with your devices?",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "Learn more",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bluetooth, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
