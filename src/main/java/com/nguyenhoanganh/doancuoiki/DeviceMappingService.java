package com.nguyenhoanganh.doancuoiki;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DeviceMappingService {

    @Autowired
    private DeviceRepository deviceRepository;

    public Long getOrCreateDeviceId(String topic, String deviceType) {
        return deviceRepository.findByTopic(topic)
                .map(Device::getId)
                .orElseGet(() -> {
                    Device newDevice = new Device();
                    newDevice.setTopic(topic);
                    newDevice.setName(deviceType + " - " + topic);
                    Device savedDevice = deviceRepository.save(newDevice);
                    System.out.println("Đã tạo Device mới - ID: " + savedDevice.getId() + ", Topic: " + topic);
                    return savedDevice.getId();
                });
    }
}

