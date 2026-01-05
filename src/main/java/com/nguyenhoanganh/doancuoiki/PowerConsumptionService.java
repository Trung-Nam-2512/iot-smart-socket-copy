package com.nguyenhoanganh.doancuoiki;

import org.springframework.stereotype.Service;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

@Service
public class PowerConsumptionService {

    private final ObjectMapper objectMapper = new ObjectMapper();

    public void savePowerData(Long deviceId, String payload) {
        try {
            String fixedPayload = fixIncompleteJson(payload);
            JsonNode jsonNode = objectMapper.readTree(fixedPayload);

            Double voltage = extractDouble(jsonNode, "V", "volt", "voltage");
            Double current = extractDouble(jsonNode, "A", "curr", "current");
            Double power = extractDouble(jsonNode, "W", "pwr", "power");
            Double temperature = extractDouble(jsonNode, "T", "temp", "temperature");
            Double humidity = extractDouble(jsonNode, "H", "humi", "humidity");
            Integer relay = extractInteger(jsonNode, "relay");

            System.out.println(String.format(
                    "Power Consumption Data - Device ID: %d, Voltage: %.2fV, Current: %.3fA, Power: %.2fW, Temperature: %.1f°C, Humidity: %.1f%%, Relay: %d",
                    deviceId, voltage != null ? voltage : 0.0, current != null ? current : 0.0,
                    power != null ? power : 0.0, temperature != null ? temperature : 0.0, 
                    humidity != null ? humidity : 0.0, relay != null ? relay : 0));

        } catch (Exception e) {
            System.err.println("Lỗi khi lưu dữ liệu công suất: " + e.getMessage());
            e.printStackTrace();
        }
    }

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

