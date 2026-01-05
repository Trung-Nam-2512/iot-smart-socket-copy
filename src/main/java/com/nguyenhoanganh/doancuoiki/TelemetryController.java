package com.nguyenhoanganh.doancuoiki;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/v2/telemetry")
public class TelemetryController {
    @Autowired
    private TelemetryRepository telemetryRepository;

    @Autowired
    private DeviceRepository deviceRepository;

    @Autowired
    private MqttPublisherService mqttPublisherService;

    @GetMapping("/{deviceId}")
    public List<Telemetry> getByDevice(@PathVariable Long deviceId) {
        return telemetryRepository.findByDeviceIdOrderByTimestampDesc(deviceId);
    }

    @GetMapping("/{deviceId}/latest")
    public Telemetry getLatestByDevice(@PathVariable Long deviceId) {
        return telemetryRepository.findFirstByDeviceIdOrderByTimestampDesc(deviceId);
    }

    @GetMapping("/{deviceId}/range")
    public List<Telemetry> getByDeviceAndTimeRange(
            @PathVariable Long deviceId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return telemetryRepository.findByDeviceIdAndTimestampBetween(deviceId, start, end);
    }

    @GetMapping("/{deviceId}/recent")
    public List<Telemetry> getRecentByDevice(
            @PathVariable Long deviceId,
            @RequestParam(defaultValue = "24") Integer hours) {
        LocalDateTime startTime = LocalDateTime.now().minusHours(hours);
        return telemetryRepository.findRecentByDeviceId(deviceId, startTime);
    }

    @GetMapping("/{deviceId}/temperature")
    public List<Telemetry> getByTemperatureRange(
            @PathVariable Long deviceId,
            @RequestParam Double minTemp,
            @RequestParam Double maxTemp) {
        return telemetryRepository.findByDeviceIdAndTemperatureRange(deviceId, minTemp, maxTemp);
    }

    @GetMapping("/{deviceId}/humidity")
    public List<Telemetry> getByHumidityRange(
            @PathVariable Long deviceId,
            @RequestParam Double minHumidity,
            @RequestParam Double maxHumidity) {
        return telemetryRepository.findByDeviceIdAndHumidityRange(deviceId, minHumidity, maxHumidity);
    }

    @GetMapping("/{deviceId}/power")
    public List<Telemetry> getByMinPower(
            @PathVariable Long deviceId,
            @RequestParam Double minPower) {
        return telemetryRepository.findByDeviceIdAndMinPower(deviceId, minPower);
    }

    @PostMapping
    public Telemetry createTelemetry(@RequestBody Telemetry telemetry) {
        Device device = deviceRepository.findById(telemetry.getDeviceId()).orElse(null);
        if (device != null && device.getTopic() != null) {
            mqttPublisherService.publish(device.getTopic(), telemetry.getPayload());
        }
        return telemetry;
    }
}

