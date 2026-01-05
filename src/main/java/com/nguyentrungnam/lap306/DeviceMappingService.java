package com.nguyentrungnam.lap306;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Service để map MQTT topic sang Device ID
 * Tự động tạo Device nếu chưa tồn tại
 */
@Service
public class DeviceMappingService {

    @Autowired
    private DeviceRepository deviceRepository;

    /**
     * Lấy hoặc tạo Device ID từ topic và device type
     * 
     * @param topic      MQTT topic
     * @param deviceType Loại thiết bị
     * @return Device ID
     */
    public Long getOrCreateDeviceId(String topic, String deviceType) {
        // Tìm Device theo topic
        return deviceRepository.findByTopic(topic)
                .map(Device::getId)
                .orElseGet(() -> {
                    // Nếu chưa tồn tại, tạo mới
                    Device newDevice = new Device();
                    newDevice.setTopic(topic);
                    newDevice.setName(deviceType + " - " + topic);
                    Device savedDevice = deviceRepository.save(newDevice);
                    System.out.println("Đã tạo Device mới - ID: " + savedDevice.getId() + ", Topic: " + topic);
                    return savedDevice.getId();
                });
    }
}
