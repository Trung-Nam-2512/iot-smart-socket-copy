package com.nguyenhoanganh.doancuoiki;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.mqtt.inbound.MqttPahoMessageDrivenChannelAdapter;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/v2/devices")
public class DeviceController {
    @Autowired
    private DeviceRepository deviceRepository;
    @Autowired
    private MqttPublisherService mqttPublisherService;
    @Autowired
    private MqttPahoMessageDrivenChannelAdapter mqttAdapter;

    @GetMapping
    public List<Device> getAllDevices() {
        return deviceRepository.findAll();
    }

    @PostMapping
    public Device createDevice(@RequestBody Device device) {
        try {
            mqttAdapter.addTopic(device.getTopic(), 1);
        } catch (Exception e) {
        }
        return deviceRepository.save(device);
    }

    @PostMapping("/{id}/control")
    public String controlDevice(@PathVariable Long id, @RequestBody String payload) {
        System.out.println("🎮 Control Device API called - ID: " + id);
        System.out.println("📦 Raw Payload received: [" + payload + "]");
        System.out.println("📦 Payload length: " + payload.length());
        System.out.println("📦 Payload bytes: " + java.util.Arrays.toString(payload.getBytes()));
        
        String cleanPayload = payload.trim();
        if (cleanPayload.startsWith("\"") && cleanPayload.endsWith("\"")) {
            cleanPayload = cleanPayload.substring(1, cleanPayload.length() - 1);
            System.out.println("🔧 Removed JSON quotes, new payload: [" + cleanPayload + "]");
        }
        
        Device device = deviceRepository.findById(id).orElse(null);
        if (device != null) {
            String topic = device.getTopic();
            if (topic == null || topic.isEmpty()) {
                topic = "/topic/qos0";
            }
            System.out.println("📡 Device topic: " + topic);
            System.out.println("📤 Publishing payload: [" + cleanPayload + "] to topic: " + topic);
            mqttPublisherService.publish(topic, cleanPayload);
            return "Published to " + topic;
        }
        System.err.println("❌ Device not found with ID: " + id);
        return "Device not found";
    }

    @PostMapping("/control-by-topic")
    public String controlDeviceByTopic(@RequestParam String topic, @RequestBody String payload) {
        System.out.println("🎮 Control by Topic API called - Topic: " + topic);
        System.out.println("📦 Raw Payload received: [" + payload + "]");
        
        String cleanPayload = payload.trim();
        if (cleanPayload.startsWith("\"") && cleanPayload.endsWith("\"")) {
            cleanPayload = cleanPayload.substring(1, cleanPayload.length() - 1);
            System.out.println("🔧 Removed JSON quotes, new payload: [" + cleanPayload + "]");
        }
        
        if (topic == null || topic.isEmpty()) {
            topic = "/topic/qos0";
        }
        System.out.println("📤 Publishing payload: [" + cleanPayload + "] to topic: " + topic);
        mqttPublisherService.publish(topic, cleanPayload);
        return "Published to " + topic;
    }

    @GetMapping("/by-topic")
    public Device getDeviceByTopic(@RequestParam String topic) {
        return deviceRepository.findByTopic(topic).orElse(null);
    }

    @DeleteMapping("/{id}")
    public void deleteDevice(@PathVariable Long id) {
        deviceRepository.deleteById(id);
    }

    @GetMapping("/controllable")
    public List<Device> getControllableDevices() {
        return deviceRepository.findAll().stream()
                .filter(device -> device.getTopic() != null && 
                        (device.getTopic().equals("/topic/qos0") || 
                         device.getTopic().startsWith("/topic/")))
                .toList();
    }
}

