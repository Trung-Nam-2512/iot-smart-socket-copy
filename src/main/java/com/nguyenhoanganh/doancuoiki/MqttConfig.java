package com.nguyenhoanganh.doancuoiki;

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
import org.springframework.integration.mqtt.support.MqttHeaders;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHandler;
import org.springframework.beans.factory.annotation.Autowired;
import java.time.LocalDateTime;

@Configuration
public class MqttConfig {
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
        MqttPahoMessageDrivenChannelAdapter adapter = new MqttPahoMessageDrivenChannelAdapter(
                clientId + "_in",
                mqttClientFactory(),
                "/test/info");
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
                String topic = message.getHeaders().get(MqttHeaders.RECEIVED_TOPIC, String.class);
                String payload = message.getPayload().toString();

                System.out.println("Nhan tin nhan tu ESP32: Topic=" + topic + ", Payload=" + payload);

                mqttToWebSocketService.pushToWebSocket(topic, payload);

                Long deviceId = extractDeviceIdFromPayload(payload);

                if (deviceId == null) {
                    String deviceType = determineDeviceType(topic);
                    deviceId = deviceMappingService.getOrCreateDeviceId(topic, deviceType);
                } else {
                    System.out.println("Su dung deviceId tu payload: " + deviceId);
                }

                saveTelemetry(deviceId, payload);

                if (topic.equals("/test/info")) {
                    powerConsumptionService.savePowerData(deviceId, payload);
                }

            } catch (Exception e) {
                System.err.println("Loi khi xu ly MQTT message: " + e.getMessage());
                e.printStackTrace();
            }
        };
    }

    private Long extractDeviceIdFromPayload(String payload) {
        try {
            String fixedPayload = fixIncompleteJson(payload);

            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            com.fasterxml.jackson.databind.JsonNode jsonNode = mapper.readTree(fixedPayload);

            com.fasterxml.jackson.databind.JsonNode deviceIdNode = jsonNode.get("deviceId");
            if (deviceIdNode == null || deviceIdNode.isNull()) {
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
                String fixed = trimmed.substring(0, lastComma) + "}";
                System.out.println(
                        "Fixed incomplete JSON in MqttConfig: " + trimmed.substring(0, Math.min(50, trimmed.length()))
                                + "... -> " + fixed.substring(0, Math.min(50, fixed.length())) + "...");
                return fixed;
            } else {
                String fixed = trimmed + "}";
                System.out.println("Fixed incomplete JSON (no comma) in MqttConfig: "
                        + trimmed.substring(0, Math.min(50, trimmed.length())) + "... -> " + fixed);
                return fixed;
            }
        }

        return trimmed;
    }

    private String determineDeviceType(String topic) {
        if (topic == null || topic.isEmpty()) {
            return "Unknown Device";
        }

        if (topic.equals("/test/info")) {
            return "Sensor Device";
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

    private void saveTelemetry(Long deviceId, String payload) {
        try {
            Telemetry t = new Telemetry();
            t.setDeviceId(deviceId);
            t.setPayload(payload);
            t.setTimestamp(LocalDateTime.now());

            String fixedPayload = fixIncompleteJson(payload);
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            com.fasterxml.jackson.databind.JsonNode jsonNode = mapper.readTree(fixedPayload);

            if (jsonNode.has("V")) {
                t.setVoltage(jsonNode.get("V").asDouble());
            }
            if (jsonNode.has("A")) {
                t.setCurrent(jsonNode.get("A").asDouble());
            }
            if (jsonNode.has("W")) {
                t.setPower(jsonNode.get("W").asDouble());
            }
            if (jsonNode.has("T")) {
                t.setTemperature(jsonNode.get("T").asDouble());
            }
            if (jsonNode.has("H")) {
                t.setHumidity(jsonNode.get("H").asDouble());
            }
            if (jsonNode.has("relay")) {
                t.setRelay(jsonNode.get("relay").asInt());
            }

            telemetryRepository.save(t);
            System.out.println("Da luu lich su cho Device ID: " + deviceId);
        } catch (Exception e) {
            System.err.println("Loi khi parse va luu telemetry: " + e.getMessage());
            Telemetry t = new Telemetry();
            t.setDeviceId(deviceId);
            t.setPayload(payload);
            t.setTimestamp(LocalDateTime.now());
            telemetryRepository.save(t);
        }
    }

    @Bean
    @ServiceActivator(inputChannel = "mqttOutboundChannel")
    public MessageHandler mqttOutbound() {
        MqttPahoMessageHandler messageHandler = new MqttPahoMessageHandler(clientId + "_out", mqttClientFactory());
        messageHandler.setAsync(true);
        messageHandler.setDefaultTopic("/topic/qos0");
        return messageHandler;
    }

    @Bean
    public MessageChannel mqttOutboundChannel() {
        return new DirectChannel();
    }
}
