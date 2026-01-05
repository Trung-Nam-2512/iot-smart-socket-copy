package com.nguyentrungnam.lap306;

import org.springframework.stereotype.Service;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Service để lưu dữ liệu công suất tiêu thụ
 */
@Service
public class PowerConsumptionService {

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * Lưu dữ liệu công suất từ payload
     * 
     * @param deviceId Device ID
     * @param payload  JSON payload chứa dữ liệu công suất (volt, curr, pwr, etc.)
     */
    public void savePowerData(Long deviceId, String payload) {
        try {
            // Parse JSON payload
            String fixedPayload = fixIncompleteJson(payload);
            JsonNode jsonNode = objectMapper.readTree(fixedPayload);

            // Extract power data
            Double voltage = extractDouble(jsonNode, "volt", "voltage");
            Double current = extractDouble(jsonNode, "curr", "current");
            Double power = extractDouble(jsonNode, "pwr", "power");
            Double humidity = extractDouble(jsonNode, "humi", "humidity");
            Integer relay = extractInteger(jsonNode, "relay");

            // Log power consumption data
            System.out.println(String.format(
                    "Power Consumption Data - Device ID: %d, Voltage: %.2fV, Current: %.3fA, Power: %.2fW, Humidity: %.1f%%, Relay: %d",
                    deviceId, voltage != null ? voltage : 0.0, current != null ? current : 0.0,
                    power != null ? power : 0.0, humidity != null ? humidity : 0.0, relay != null ? relay : 0));

            // TODO: Lưu vào PowerConsumptionHistory entity nếu cần
            // PowerConsumptionHistory history = new PowerConsumptionHistory();
            // history.setDeviceId(deviceId);
            // history.setVoltage(voltage);
            // history.setCurrent(current);
            // history.setPower(power);
            // history.setTimestamp(LocalDateTime.now());
            // powerConsumptionRepository.save(history);

        } catch (Exception e) {
            System.err.println("Lỗi khi lưu dữ liệu công suất: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Extract double value from JSON node
     */
    private Double extractDouble(JsonNode node, String... keys) {
        for (String key : keys) {
            JsonNode value = node.get(key);
            if (value != null && !value.isNull()) {
                if (value.isNumber()) {
                    return value.asDouble();
                } else if (value.isTextual()) {
                    try {
                        return Double.parseDouble(value.asText());
                    } catch (NumberFormatException e) {
                        return null;
                    }
                }
            }
        }
        return null;
    }

    /**
     * Extract integer value from JSON node
     */
    private Integer extractInteger(JsonNode node, String... keys) {
        for (String key : keys) {
            JsonNode value = node.get(key);
            if (value != null && !value.isNull()) {
                if (value.isNumber()) {
                    return value.asInt();
                } else if (value.isTextual()) {
                    try {
                        return Integer.parseInt(value.asText());
                    } catch (NumberFormatException e) {
                        return null;
                    }
                }
            }
        }
        return null;
    }

    /**
     * Fix incomplete JSON (similar to MqttConfig)
     */
    private String fixIncompleteJson(String payload) {
        if (payload == null || payload.trim().isEmpty()) {
            return "{}";
        }

        String trimmed = payload.trim();
        if (trimmed.startsWith("{") && !trimmed.endsWith("}")) {
            int lastComma = trimmed.lastIndexOf(',');
            if (lastComma > 0) {
                return trimmed.substring(0, lastComma) + "}";
            } else {
                return trimmed + "}";
            }
        }

        return trimmed;
    }
}



