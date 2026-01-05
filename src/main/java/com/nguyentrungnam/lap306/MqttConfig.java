package com.nguyentrungnam.lap306;

import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.mqtt.core.DefaultMqttPahoClientFactory;
import org.springframework.integration.mqtt.core.MqttPahoClientFactory;
import org.springframework.integration.mqtt.inbound.MqttPahoMessageDrivenChannelAdapter;
import org.springframework.integration.mqtt.outbound.MqttPahoMessageHandler;
import org.springframework.integration.mqtt.support.DefaultPahoMessageConverter;
import org.springframework.integration.mqtt.support.MqttHeaders; // <--- NHỚ IMPORT CÁI NÀY
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHandler;
import com.nguyentrungnam.lap306.Telemetry;
import com.nguyentrungnam.lap306.TelemetryRepository;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime; // <--- IMPORT CÁI NÀY ĐỂ LƯU THỜI GIAN

@Configuration
public class MqttConfig {
    // ... (Các phần khai báo biến @Value giữ nguyên như cũ) ...
    @Value("${mqtt.broker.url}")
    private String brokerUrl;
    @Value("${mqtt.client.id}")
    private String clientId;
    @Value("${mqtt.username:}")
    private String username;
    @Value("${mqtt.password:}")
    private String password;

    @Autowired
    private TelemetryRepository telemetryRepository;

    @Autowired
    private MqttToWebSocketService mqttToWebSocketService;

    @Autowired
    private PowerConsumptionService powerConsumptionService;

    @Autowired
    private DeviceMappingService deviceMappingService;

    @Bean
    public MqttPahoClientFactory mqttClientFactory() {
        // ... (Giữ nguyên đoạn này) ...
        DefaultMqttPahoClientFactory factory = new DefaultMqttPahoClientFactory();
        MqttConnectOptions options = new MqttConnectOptions();
        options.setServerURIs(new String[] { brokerUrl });
        if (username != null && !username.isEmpty())
            options.setUserName(username);
        if (password != null && !password.isEmpty())
            options.setPassword(password.toCharArray());
        factory.setConnectionOptions(options);
        return factory;
    }

    @Bean
    public MessageChannel mqttInputChannel() {
        return new DirectChannel();
    }

    @Bean
    public MqttPahoMessageDrivenChannelAdapter inbound() {
        // --- SỬA CHỖ 1: Đổi "/test/topic" thành "home/s3/led" hoặc "#" ---
        MqttPahoMessageDrivenChannelAdapter adapter = new MqttPahoMessageDrivenChannelAdapter(
                clientId + "_in",
                mqttClientFactory(),
                "#" // Dấu # nghĩa là lắng nghe TẤT CẢ topic
        );
        adapter.setCompletionTimeout(5000);
        adapter.setConverter(new DefaultPahoMessageConverter());
        adapter.setQos(1);
        adapter.setOutputChannel(mqttInputChannel());
        return adapter;
    }

    @Bean
    @ServiceActivator(inputChannel = "mqttInputChannel")
    public MessageHandler handler() {
        return message -> {
            try {
                // Lấy topic và nội dung tin nhắn
                String topic = message.getHeaders().get(MqttHeaders.RECEIVED_TOPIC, String.class);
                String payload = message.getPayload().toString();

                System.out.println("Nhan tin nhan tu ESP32: Topic=" + topic + ", Payload=" + payload);

                // ĐẨY NGAY LẬP TỨC SANG WEBSOCKET (trước khi xử lý database)
                // Tất cả message từ ESP32 đều được đẩy sang WebSocket ngay lập tức
                mqttToWebSocketService.pushToWebSocket(topic, payload);

                // --- Logic lưu database theo topic (THÔNG MINH) ---
                // Hỗ trợ 2 cách: deviceId từ payload HOẶC từ topic mapping

                // Thử lấy deviceId từ payload trước (ESP32 có thể gửi kèm)
                Long deviceId = extractDeviceIdFromPayload(payload);

                if (deviceId == null) {
                    // Nếu không có deviceId trong payload, dùng topic mapping
                    String deviceType = determineDeviceType(topic);
                    deviceId = deviceMappingService.getOrCreateDeviceId(topic, deviceType);
                } else {
                    System.out.println("Su dung deviceId tu payload: " + deviceId);
                }

                // Lưu vào Telemetry (tương thích ngược)
                saveTelemetry(deviceId, payload);

                // Nếu là topic status (có dữ liệu công suất), lưu vào PowerConsumptionHistory
                if (topic.contains("/status") || topic.contains("status")) {
                    powerConsumptionService.savePowerData(deviceId, payload);
                }

            } catch (Exception e) {
                System.err.println("Loi khi xu ly MQTT message: " + e.getMessage());
                e.printStackTrace();
            }
        };
    }

    /**
     * Extract deviceId từ payload nếu ESP32 gửi kèm
     * Hỗ trợ cả "deviceId" (camelCase) và "DEVICE_ID" (UPPER_CASE)
     * Format: {"deviceId": 36, ...} hoặc {"DEVICE_ID": 111, ...}
     */
    private Long extractDeviceIdFromPayload(String payload) {
        try {
            // Fix JSON nếu bị cắt cụt
            String fixedPayload = fixIncompleteJson(payload);

            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            com.fasterxml.jackson.databind.JsonNode jsonNode = mapper.readTree(fixedPayload);

            // Thử "deviceId" trước (camelCase)
            com.fasterxml.jackson.databind.JsonNode deviceIdNode = jsonNode.get("deviceId");
            if (deviceIdNode == null || deviceIdNode.isNull()) {
                // Thử "DEVICE_ID" (UPPER_CASE) - format từ ESP32
                deviceIdNode = jsonNode.get("DEVICE_ID");
            }

            if (deviceIdNode != null && !deviceIdNode.isNull()) {
                if (deviceIdNode.isNumber()) {
                    return deviceIdNode.asLong();
                } else if (deviceIdNode.isTextual()) {
                    try {
                        return Long.parseLong(deviceIdNode.asText());
                    } catch (NumberFormatException e) {
                        return null;
                    }
                }
            }
        } catch (Exception e) {
            // Không có deviceId trong payload hoặc JSON không hợp lệ, dùng fallback
        }
        return null;
    }

    /**
     * Fix JSON nếu bị cắt cụt (thiếu dấu đóng ngoặc)
     * Xử lý trường hợp:
     * {"volt":2.1,"curr":0.000,"pwr":0.0,"humi":78.0,"relay":0,"DEVICE_ID":111
     * -> {"volt":2.1,"curr":0.000,"pwr":0.0,"humi":78.0,"relay":0}
     */
    private String fixIncompleteJson(String payload) {
        if (payload == null || payload.trim().isEmpty()) {
            return "{}";
        }

        String trimmed = payload.trim();

        // Nếu bắt đầu bằng { nhưng không kết thúc bằng }
        if (trimmed.startsWith("{") && !trimmed.endsWith("}")) {
            // Tìm vị trí dấu phẩy cuối cùng trước khi bị cắt
            int lastComma = trimmed.lastIndexOf(',');
            if (lastComma > 0) {
                // Cắt bỏ phần sau dấu phẩy cuối (field bị cắt cụt) và thêm }
                String fixed = trimmed.substring(0, lastComma) + "}";
                System.out.println(
                        "Fixed incomplete JSON in MqttConfig: " + trimmed.substring(0, Math.min(50, trimmed.length()))
                                + "... -> " + fixed.substring(0, Math.min(50, fixed.length())) + "...");
                return fixed;
            } else {
                // Nếu không có dấu phẩy, chỉ thêm }
                String fixed = trimmed + "}";
                System.out.println("Fixed incomplete JSON (no comma) in MqttConfig: "
                        + trimmed.substring(0, Math.min(50, trimmed.length())) + "... -> " + fixed);
                return fixed;
            }
        }

        return trimmed;
    }

    /**
     * Xác định loại thiết bị dựa trên topic pattern
     */
    private String determineDeviceType(String topic) {
        if (topic == null || topic.isEmpty()) {
            return "Unknown Device";
        }

        if (topic.contains("/status")) {
            return "Power Sensor";
        } else if (topic.contains("/led")) {
            return "LED Controller";
        } else if (topic.contains("/temp")) {
            return "Temperature Sensor";
        } else if (topic.contains("/pump")) {
            return "Pump Controller";
        } else if (topic.contains("/sensor")) {
            return "Sensor Device";
        }

        return "IoT Device";
    }

    // Hàm phụ để code gọn hơn
    private void saveTelemetry(Long deviceId, String payload) {
        Telemetry t = new Telemetry();
        t.setDeviceId(deviceId);

        // Lưu ý: Kiểm tra file Telemetry.java xem biến là 'payload' hay 'value' để dùng
        // set cho đúng
        t.setPayload(payload);

        // --- SỬA LỖI TẠI ĐÂY ---
        // Xóa .toString() đi, truyền trực tiếp LocalDateTime vào
        t.setTimestamp(LocalDateTime.now());
        // -----------------------

        telemetryRepository.save(t);
        System.out.println("Da luu lich su cho Device ID: " + deviceId);
    }

    // ... (Phần Outbound giữ nguyên) ...
    @Bean
    @ServiceActivator(inputChannel = "mqttOutboundChannel")
    public MessageHandler mqttOutbound() {
        MqttPahoMessageHandler messageHandler = new MqttPahoMessageHandler(clientId + "_out", mqttClientFactory());
        messageHandler.setAsync(true);
        messageHandler.setDefaultTopic("/test/topic");
        return messageHandler;
    }

    @Bean
    public MessageChannel mqttOutboundChannel() {
        return new DirectChannel();
    }
}